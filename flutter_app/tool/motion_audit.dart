// Motion Standard — audit scanner (phase 1: tablet surface, absolute).
//
// Locks the static half of
// docs/02_FLUTTER_MIGRATION/standards/Motion-Standard.md across every
// tablet-surface Dart file under lib/ (path contains "/tablet/", or the file
// name mentions "tablet"). The tablet surface starts at ZERO literal motion
// (2026-08-23 sweep migrated the last two 180ms literals) — these rules are
// absolute (no baseline, no ratchet): any new literal fails CI outright.
//
//   M1 literal-duration — an animation `duration: <Duration literal>` (incl.
//                          transitionDuration/reverseDuration) must reference
//                          an AppMotion token instead. Mock repository /
//                          network delays (`Future.delayed(const Duration…`,
//                          no `duration:` argument position) are NOT motion
//                          and never match.
//   M2 literal-curve    — a `Curves.` reference in tablet presentation code;
//                          easing comes from AppMotion.enter/emphasized/exit.
//
// M3 (reduced-motion via AppMotion.respect), M4 (tokens only — enforced by
// M1/M2), and M5 (skeleton respects reduced motion) are behavioral: prose +
// widget tests, out of static reach.
//
// Phase 2 (roadmap, not this tool yet): phone surface keeps its current
// rules; adopting tokens there lands with its own ratchet baseline.
//
// Usage (from flutter_app/):
//   dart run tool/motion_audit.dart            # regen artifact
//   dart run tool/motion_audit.dart --check    # CI staleness
import 'dart:io';

const _artifactPath =
    '../docs/02_FLUTTER_MIGRATION/audits/VitTrade-Motion-Audit.csv';

final _literalDurationRe = RegExp(r'[dD]uration:\s*(?:const\s+)?Duration\s*\(');
final _literalCurveRe = RegExp(r'\bCurves\.');

void main(List<String> args) {
  _selfTest();
  final checkOnly = args.contains('--check');

  final rows = <MotionRow>[];
  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    stderr.writeln('Run from flutter_app/ — lib/ not found.');
    exit(2);
  }
  for (final entity in libDir.listSync(recursive: true)) {
    if (entity is! File) continue;
    final normalized = entity.path.replaceAll('\\', '/');
    final fileName = normalized.split('/').last;
    final isTabletSurface =
        normalized.contains('/tablet/') || fileName.contains('tablet');
    if (!isTabletSurface || !normalized.endsWith('.dart')) continue;
    // The theme folder is the token layer — AppMotion itself (and any future
    // motion token file) is the sanctioned home for Duration/Curves values,
    // the same exemption the card border audit gives app/theme/.
    if (normalized.contains('/app/theme/')) continue;

    final lines = entity.readAsLinesSync();
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.trimLeft().startsWith('//')) continue;
      final rel = normalized.replaceFirst('lib/', '');
      if (_literalDurationRe.hasMatch(line)) {
        rows.add(MotionRow(rel, i + 1, 'M1-literal-duration', line.trim()));
      }
      if (_literalCurveRe.hasMatch(line)) {
        rows.add(MotionRow(rel, i + 1, 'M2-literal-curve', line.trim()));
      }
    }
  }

  rows.sort((a, b) {
    final byPath = a.path.compareTo(b.path);
    if (byPath != 0) return byPath;
    return a.line.compareTo(b.line);
  });

  final artifact = _renderArtifact(rows);
  if (checkOnly) {
    final existing = File(_artifactPath).existsSync()
        ? File(_artifactPath).readAsStringSync()
        : null;
    if (existing == null || existing != artifact) {
      stderr.writeln(
        'Motion audit artifact is stale. '
        'Run `dart run tool/motion_audit.dart` from flutter_app/.',
      );
      exit(1);
    }
    stdout.writeln('Motion audit artifact is current.');
  } else {
    File(_artifactPath).writeAsStringSync(artifact);
    stdout.writeln('Wrote $_artifactPath');
  }

  stdout.writeln(
    rows.isEmpty
        ? 'Motion audit: 0 violations (absolute lock — no baseline).'
        : 'Motion audit: ${rows.length} violations (absolute lock — move to '
              'AppMotion tokens, never baseline them).',
  );
}

/// Locks the scanner regexes against regressions — runs on every invocation,
/// same contract as the S4 self-test in tablet_spacing_audit.dart.
void _selfTest() {
  void expectRule(String label, String line, String? expected) {
    String? actual;
    if (_literalDurationRe.hasMatch(line)) actual = 'M1';
    if (_literalCurveRe.hasMatch(line)) {
      actual = actual == null ? 'M2' : '$actual+M2';
    }
    if (actual != expected) {
      stderr.writeln(
        'Motion self-test FAILED ($label): expected $expected, got $actual',
      );
      exit(2);
    }
  }

  // M1: animation duration literals are violations, token refs are not.
  expectRule(
    'literal duration',
    'duration: const Duration(milliseconds: 180),',
    'M1',
  );
  expectRule('bare duration', 'duration: Duration(seconds: 1),', 'M1');
  expectRule(
    'transition duration',
    'transitionDuration: const Duration(milliseconds: 300),',
    'M1',
  );
  expectRule('token duration', 'duration: AppMotion.element,', null);
  // Mock/network delays are not motion — the `delayed(` call position has no
  // `duration:` argument name, so it must never match.
  expectRule(
    'mock delay',
    'await Future<void>.delayed(const Duration(milliseconds: 360));',
    null,
  );
  expectRule(
    'load delay param',
    'const MockProfileRepository(loadDelay: Duration.zero),',
    null,
  );
  // M2: curve literals are violations, token refs are not.
  expectRule('literal curve', 'curve: Curves.easeOutCubic,', 'M2');
  expectRule('token curve', 'curve: AppMotion.enter,', null);
}

String _renderArtifact(List<MotionRow> rows) {
  final buffer = StringBuffer()
    ..writeln('path,line,rule,source')
    ..writeln(
      '# Generated by tool/motion_audit.dart — regenerate after touching tablet presentation files.',
    );
  for (final row in rows) {
    buffer.writeln(
      '${row.path},${row.line},${row.rule},"${row.source.replaceAll('"', '""')}"',
    );
  }
  return buffer.toString();
}

class MotionRow {
  const MotionRow(this.path, this.line, this.rule, this.source);

  final String path;
  final int line;
  final String rule;
  final String source;
}
