// Tablet Input Modality Standard — audit scanner.
//
// Locks the static half of
// docs/02_FLUTTER_MIGRATION/standards/Tablet-Input-Standard.md across every
// tablet-surface Dart file under lib/ (path contains "/tablet/", or the file
// name mentions "tablet"). The tablet surface starts at ZERO raw hover/focus
// code — these rules are absolute (no baseline, no ratchet): any new
// hand-rolled input-state code fails CI outright.
//
//   I1 raw-hover         — `MouseRegion(`/`onHover:` in tablet presentation
//                          code. Pointer states come from the shared widgets
//                          (VitCard/VitCtaButton/rows consume
//                          AppInputStates through their InkWell), never from
//                          a per-page MouseRegion.
//   I2 adhoc-input-state — a `hoverColor:`/`focusColor:` override whose value
//                          is not an `AppInputStates.*` token. Off-token
//                          state colors drift per page exactly the way
//                          border tints did before the Card & Border standard.
//   I3 skip-traversal    — `skipTraversal: true` breaks keyboard tab order;
//                          traversal must follow visual order (menu → pane).
//
// I4 (keyboard shortcuts) and I5 (no layout shift on hover/focus) are
// behavioral rules — they stay prose + widget-test enforced, out of static
// reach (same caveat as S4's helper-built children).
//
// Usage (from flutter_app/):
//   dart run tool/tablet_input_audit.dart            # regen artifact
//   dart run tool/tablet_input_audit.dart --check    # CI staleness
import 'dart:io';

const _artifactPath =
    '../docs/02_FLUTTER_MIGRATION/audits/VitTrade-Tablet-Input-Audit.csv';

final _rawHoverRe = RegExp(r'\bMouseRegion\s*\(|\bonHover\s*:');
final _inputStateColorRe = RegExp(r'\b(hover|focus)Color\s*:');
final _skipTraversalRe = RegExp(r'skipTraversal\s*:\s*true');

void main(List<String> args) {
  _selfTest();
  final checkOnly = args.contains('--check');

  final rows = <InputRow>[];
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

    final lines = entity.readAsLinesSync();
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.trimLeft().startsWith('//')) continue;
      final rel = normalized.replaceFirst('lib/', '');
      if (_rawHoverRe.hasMatch(line)) {
        rows.add(InputRow(rel, i + 1, 'I1-raw-hover', line.trim()));
      }
      if (_inputStateColorRe.hasMatch(line) &&
          !line.contains('AppInputStates.')) {
        rows.add(InputRow(rel, i + 1, 'I2-adhoc-input-state', line.trim()));
      }
      if (_skipTraversalRe.hasMatch(line)) {
        rows.add(InputRow(rel, i + 1, 'I3-skip-traversal', line.trim()));
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
        'Tablet input audit artifact is stale. '
        'Run `dart run tool/tablet_input_audit.dart` from flutter_app/.',
      );
      exit(1);
    }
    stdout.writeln('Tablet input audit artifact is current.');
  } else {
    File(_artifactPath).writeAsStringSync(artifact);
    stdout.writeln('Wrote $_artifactPath');
  }

  stdout.writeln(
    rows.isEmpty
        ? 'Tablet input audit: 0 violations (absolute lock — no baseline).'
        : 'Tablet input audit: ${rows.length} violations (absolute lock — '
              'move to shared widgets + AppInputStates tokens, never baseline '
              'them).',
  );
}

/// Locks the scanner regexes against regressions — runs on every invocation
/// (regen and --check alike), same contract as the S4 self-test in
/// tablet_spacing_audit.dart.
void _selfTest() {
  void expectRule(String label, String line, String? expected) {
    String? actual;
    if (_rawHoverRe.hasMatch(line)) actual = 'I1';
    if (_inputStateColorRe.hasMatch(line) &&
        !line.contains('AppInputStates.')) {
      actual = actual == null ? 'I2' : '$actual+I2';
    }
    if (_skipTraversalRe.hasMatch(line)) {
      actual = actual == null ? 'I3' : '$actual+I3';
    }
    if (actual != expected) {
      stderr.writeln(
        'Input self-test FAILED ($label): expected $expected, got $actual',
      );
      exit(2);
    }
  }

  // I1: raw pointer plumbing is a violation, tokenized or not.
  expectRule('raw MouseRegion', 'final h = MouseRegion(', 'I1');
  expectRule('raw onHover', 'child: X(onHover: (v) {}),', 'I1');
  // I2: token references pass; anything else is an ad-hoc state color.
  expectRule(
    'token hover passes',
    'hoverColor: AppInputStates.hoverOverlay,',
    null,
  );
  expectRule('literal hover', 'hoverColor: Colors.white10,', 'I2');
  expectRule('literal focus', 'focusColor: Color(0x1FFFFFFF),', 'I2');
  // I3: skipping traversal breaks tab order.
  expectRule('skip traversal', 'FocusNode(skipTraversal: true),', 'I3');
  // Comment lines are invisible to the scanner (handled by caller's skip).
  expectRule('plain line', 'child: Text(\'(chọn ảnh)\'),', null);
}

String _renderArtifact(List<InputRow> rows) {
  final buffer = StringBuffer()
    ..writeln('path,line,rule,source')
    ..writeln(
      '# Generated by tool/tablet_input_audit.dart — regenerate after touching tablet presentation files.',
    );
  for (final row in rows) {
    buffer.writeln(
      '${row.path},${row.line},${row.rule},"${row.source.replaceAll('"', '""')}"',
    );
  }
  return buffer.toString();
}

class InputRow {
  const InputRow(this.path, this.line, this.rule, this.source);

  final String path;
  final int line;
  final String rule;
  final String source;
}
