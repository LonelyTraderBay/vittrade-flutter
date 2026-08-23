// Motion Standard — audit scanner.
//
//   Tablet surface  — ABSOLUTE lock (phase 1, 2026-08-23): zero literal
//                     motion, no baseline. Any violation fails the run.
//   Phone surface   — RATCHET lock (phase 2, 2026-08-24): every
//                     Dart file under lib/ outside the tablet set and the
//                     token layer. Existing debt is pinned in
//                     test/quality/motion_phone_baseline.txt (regen only via
//                     --regen-baseline); new violations fail CI, entries must
//                     disappear as files are touched.
//
//   M1 literal-duration — an animation `duration: <Duration literal>` (incl.
//                          transitionDuration/reverseDuration) must reference
//                          an AppMotion token instead. Mock repository /
//                          network delays (`Future.delayed(const Duration…`,
//                          no `duration:` argument position) are NOT motion
//                          and never match.
//   M2 literal-curve    — a `Curves.` reference in presentation code;
//                          easing comes from AppMotion.enter/emphasized/exit.
//
// `lib/app/theme/` is exempt on both scopes — it is the token layer
// (AppMotion itself is the sanctioned home for Duration/Curves values).
// M3 (reduced motion), M4's shared-widget half, and M5 (skeleton behavior)
// are behavioral: prose + widget tests, out of static reach.
//
// Usage (from flutter_app/):
//   dart run tool/motion_audit.dart                   # regen artifact
//   dart run tool/motion_audit.dart --check           # CI: artifact + baseline
//   dart run tool/motion_audit.dart --regen-baseline  # only when retiring debt
import 'dart:io';

const _artifactPath =
    '../docs/02_FLUTTER_MIGRATION/audits/VitTrade-Motion-Audit.csv';
const _phoneBaselinePath = 'test/quality/motion_phone_baseline.txt';

final _literalDurationRe = RegExp(r'[dD]uration:\s*(?:const\s+)?Duration\s*\(');
final _literalCurveRe = RegExp(r'\bCurves\.');

bool _isTabletSurface(String normalizedPath) {
  final fileName = normalizedPath.split('/').last;
  return normalizedPath.contains('/tablet/') || fileName.contains('tablet');
}

/// The phone scope: every Dart file under lib/ except the tablet set and
/// the token layer — presentation, shared widgets, shared layout.
bool _isPhoneSurface(String normalizedPath) =>
    !_isTabletSurface(normalizedPath) &&
    !normalizedPath.contains('/app/theme/');

void main(List<String> args) {
  _selfTest();
  final checkOnly = args.contains('--check');
  final regenBaseline = args.contains('--regen-baseline');

  final tabletRows = <MotionRow>[];
  final phoneRows = <MotionRow>[];
  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    stderr.writeln('Run from flutter_app/ — lib/ not found.');
    exit(2);
  }
  for (final entity in libDir.listSync(recursive: true)) {
    if (entity is! File) continue;
    final normalized = entity.path.replaceAll('\\', '/');
    if (!normalized.endsWith('.dart')) continue;

    final isTablet = _isTabletSurface(normalized);
    if (!isTablet && !_isPhoneSurface(normalized)) continue;

    final rel = normalized.replaceFirst('lib/', '');
    final lines = entity.readAsLinesSync();
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.trimLeft().startsWith('//')) continue;
      if (_literalDurationRe.hasMatch(line)) {
        (isTablet ? tabletRows : phoneRows).add(
          MotionRow(rel, i + 1, 'M1-literal-duration', line.trim()),
        );
      }
      if (_literalCurveRe.hasMatch(line)) {
        (isTablet ? tabletRows : phoneRows).add(
          MotionRow(rel, i + 1, 'M2-literal-curve', line.trim()),
        );
      }
    }
  }

  // Phase 1 — tablet absolute: any violation fails the run outright.
  if (tabletRows.isNotEmpty) {
    stderr.writeln(
      'Motion audit: ${tabletRows.length} TABLET violations (absolute lock, '
      'no baseline):\n${tabletRows.map((r) => '${r.path}|${r.line}|${r.rule}').join('\n')}\n'
      'Move to AppMotion tokens — the tablet surface stays at zero.',
    );
    exit(2);
  }

  phoneRows.sort(_byPathThenLine);

  if (regenBaseline) {
    File(_phoneBaselinePath).writeAsStringSync(_renderBaseline(phoneRows));
    stdout.writeln('Wrote $_phoneBaselinePath (${phoneRows.length} entries).');
  }

  if (checkOnly) {
    // Artifact currency.
    final rendered = _renderArtifact(phoneRows);
    final existing = File(_artifactPath).existsSync()
        ? File(_artifactPath).readAsStringSync()
        : null;
    if (existing == null || existing != rendered) {
      stderr.writeln(
        'Motion audit artifact is stale. '
        'Run `dart run tool/motion_audit.dart` from flutter_app/.',
      );
      exit(1);
    }
    // Phone ratchet: every current entry must already be pinned.
    final baseline = _readBaseline();
    final newDebt = phoneRows
        .map((r) => '${r.path}|${r.line}|${r.rule}')
        .where((entry) => !baseline.contains(entry))
        .toList();
    if (newDebt.isNotEmpty) {
      stderr.writeln(
        'Motion audit: ${newDebt.length} new PHONE violations outside the '
        'ratchet baseline:\n${newDebt.join('\n')}\n'
        'Use AppMotion tokens (never baseline new debt by hand).',
      );
      exit(1);
    }
    stdout.writeln(
      'Motion audit current: tablet 0, phone ${phoneRows.length} pinned.',
    );
  } else {
    File(_artifactPath).writeAsStringSync(_renderArtifact(phoneRows));
    stdout.writeln('Wrote $_artifactPath');
  }

  stdout.writeln(
    'Motion audit: tablet 0 violations (absolute); phone ${phoneRows.length} '
    'ratcheted entries (only shrink — migrate to AppMotion as files are '
    'touched).',
  );
}

int _byPathThenLine(MotionRow a, MotionRow b) {
  final byPath = a.path.compareTo(b.path);
  return byPath != 0 ? byPath : a.line.compareTo(b.line);
}

Set<String> _readBaseline() {
  final file = File(_phoneBaselinePath);
  if (!file.existsSync()) return <String>{};
  return file
      .readAsLinesSync()
      .where((line) => line.isNotEmpty && !line.startsWith('#'))
      .toSet();
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
      '# Generated by tool/motion_audit.dart — phone-surface motion debt (ratchet). Tablet surface is absolute-zero and never listed here.',
    );
  for (final row in rows) {
    buffer.writeln(
      '${row.path},${row.line},${row.rule},"${row.source.replaceAll('"', '""')}"',
    );
  }
  return buffer.toString();
}

String _renderBaseline(List<MotionRow> rows) {
  final buffer = StringBuffer()
    ..writeln(
      '# Phone motion debt baseline — ratchet: entries may only be REMOVED.',
    )
    ..writeln('# Regenerate intentionally via:')
    ..writeln('#   dart run tool/motion_audit.dart --regen-baseline')
    ..writeln(
      '# Never add entries by hand; new UI uses AppMotion tokens outright.',
    );
  for (final row in rows) {
    buffer.writeln('${row.path}|${row.line}|${row.rule}');
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
