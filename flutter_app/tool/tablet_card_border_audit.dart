// Tablet Card & Border Standard — audit scanner.
//
// Enforces the static half of
// docs/02_FLUTTER_MIGRATION/standards/Tablet-Card-Border-Standard.md across
// every tablet-surface Dart file under lib/ (path contains "/tablet/" or the
// file name mentions "tablet"):
//
//   R1 raw-border    — no hand-rolled `Border.all(`/`BorderSide(` in tablet
//                      presentation code; frames come from VitCard only.
//   R2 ad-hoc tint   — a `borderColor:` override tinted via
//                      `.withValues(alpha: X)` must use one of the three
//                      sanctioned tint steps {.12, .22, .34}; plain color
//                      tokens (incl. AppColors.transparent) pass untouched.
//   R3 literal radius— `BorderRadius.circular(`/`Radius.circular(` are
//                      forbidden outright (0 tolerance; the whole lib/ is
//                      already at zero — keep it there).
//   R4 deprecated    — `AppRadii.mdRadius`/`xsRadius`/`headerActionRadius`
//                      (all @Deprecated) must not appear in tablet files.
//   R5 fixed-height  — a `VitCard` that fixes its own `height:` is a
//                      control surface, not a content card: radius role must
//                      be `VitCardRadius.tight` (standard 16 on a ~34dp bar
//                      reads as a pill — the movers-strip bug of 2026-08-27).
//                      Legacy wallet tiles are pinned in the baseline;
//                      migrate on touch, never add.
//
// Usage (from flutter_app/):
//   dart run tool/tablet_card_border_audit.dart              # regen artifact
//   dart run tool/tablet_card_border_audit.dart --check      # CI staleness
//   dart run tool/tablet_card_border_audit.dart --regen-baseline
import 'dart:io';

const _artifactPath =
    '../docs/02_FLUTTER_MIGRATION/audits/VitTrade-Tablet-Card-Border-Audit.csv';
const _baselinePath = 'test/quality/tablet_card_border_baseline.txt';

/// Sanctioned tint steps from the standard (subtle / standard / strong).
const _sanctionedTints = <String>{'.12', '.22', '.34', '0.12', '0.22', '0.34'};

final _rawBorderRe = RegExp(r'Border\.all\(|\bBorderSide\s*\(');
final _borderColorTintRe = RegExp(
  r'borderColor:\s*[^\n]+?\.withValues\(\s*alpha:\s*(\d*\.?\d+)\s*\)',
);
final _literalRadiusRe = RegExp(
  r'BorderRadius\.circular\(|\bRadius\.circular\(',
);
final _deprecatedRadiusRe = RegExp(
  r'AppRadii\.(mdRadius|xsRadius|headerActionRadius)\b',
);
final _vitCardStartRe = RegExp(r'\bVitCard\s*\(');

void main(List<String> args) {
  final checkOnly = args.contains('--check');
  final regenBaseline = args.contains('--regen-baseline');

  final rows = <BorderRow>[];
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
    // The app/theme folder is the token layer — the one sanctioned home for
    // BorderSide color tokens (like app_radii owns radii). Presentation
    // rules must not fire there.
    if (normalized.contains('/app/theme/')) continue;

    final lines = entity.readAsLinesSync();
    final rel = normalized.replaceFirst('lib/', '');
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.trimLeft().startsWith('//')) continue;
      if (_rawBorderRe.hasMatch(line)) {
        rows.add(BorderRow(rel, i + 1, 'R1-raw-border', line.trim()));
        continue;
      }
      final tint = _borderColorTintRe.firstMatch(line);
      if (tint != null) {
        if (!_sanctionedTints.contains(tint.group(1)!.trimLeft())) {
          rows.add(
            BorderRow(
              rel,
              i + 1,
              'R2-adhoc-tint(${tint.group(1)})',
              line.trim(),
            ),
          );
        }
        continue;
      }
      if (_literalRadiusRe.hasMatch(line)) {
        rows.add(BorderRow(rel, i + 1, 'R3-literal-radius', line.trim()));
        continue;
      }
      if (_deprecatedRadiusRe.hasMatch(line)) {
        rows.add(BorderRow(rel, i + 1, 'R4-deprecated-radius', line.trim()));
      }
    }

    // R5 needs the whole file (a VitCard constructor spans lines, and the
    // `height:` that matters is the card's OWN argument — never one buried
    // in a child subtree).
    final content = entity.readAsStringSync();
    for (final match in _vitCardStartRe.allMatches(content)) {
      final openParen = content.indexOf('(', match.start);
      final closeParen = _matchingParen(content, openParen);
      if (closeParen < 0) continue;
      final args = _topLevelArgs(content.substring(openParen + 1, closeParen));
      final fixesHeight = args.any((a) => a.startsWith('height:'));
      if (!fixesHeight) continue;
      String? radiusArg;
      for (final a in args) {
        if (a.startsWith('radius:')) {
          radiusArg = a;
          break;
        }
      }
      if (radiusArg != null && radiusArg.contains('VitCardRadius.tight')) {
        continue;
      }
      final lineNo =
          '\n'.allMatches(content.substring(0, match.start)).length + 1;
      final lineText = lines[lineNo - 1].trim();
      rows.add(BorderRow(rel, lineNo, 'R5-fixed-height-card', lineText));
    }
  }

  rows.sort((a, b) {
    final byPath = a.path.compareTo(b.path);
    if (byPath != 0) return byPath;
    return a.line.compareTo(b.line);
  });

  final artifact = _renderArtifact(rows);
  if (regenBaseline) {
    File(_baselinePath).writeAsStringSync(_renderBaseline(rows));
    stdout.writeln('Wrote $_baselinePath (${rows.length} entries).');
  }
  if (checkOnly) {
    final existing = File(_artifactPath).existsSync()
        ? File(_artifactPath).readAsStringSync()
        : null;
    if (existing == null || existing != artifact) {
      stderr.writeln(
        'Tablet card border audit artifact is stale. '
        'Run `dart run tool/tablet_card_border_audit.dart` from flutter_app/.',
      );
      exit(1);
    }
    stdout.writeln('Tablet card border audit artifact is current.');
  } else {
    File(_artifactPath).writeAsStringSync(artifact);
    stdout.writeln('Wrote $_artifactPath');
  }

  final byRule = <String, int>{};
  for (final row in rows) {
    final key = row.rule.split('(').first;
    byRule[key] = (byRule[key] ?? 0) + 1;
  }
  stdout.writeln(
    'Tablet card border audit: ${byRule.isEmpty ? "0 violations" : byRule.entries.map((e) => "${e.value} ${e.key}").join(", ")} '
    '(ratchet down via test/quality/tablet_card_border_baseline.txt).',
  );
}

String _renderArtifact(List<BorderRow> rows) {
  final buffer = StringBuffer()
    ..writeln('path,line,rule,source')
    ..writeln(
      '# Generated by tool/tablet_card_border_audit.dart — regenerate after touching tablet presentation files.',
    );
  for (final row in rows) {
    buffer.writeln(
      '${row.path},${row.line},${row.rule},"${row.source.replaceAll('"', '""')}"',
    );
  }
  return buffer.toString();
}

String _renderBaseline(List<BorderRow> rows) {
  final buffer = StringBuffer()
    ..writeln(
      '# Tablet card border debt baseline — ratchet: entries may only be REMOVED.',
    )
    ..writeln('# Regenerate intentionally via:')
    ..writeln(
      '#   dart run tool/tablet_card_border_audit.dart --regen-baseline',
    )
    ..writeln(
      '# Never add entries by hand; new tablet UI must follow the standard outright.',
    );
  for (final row in rows) {
    buffer.writeln('${row.path}|${row.line}|${row.rule}');
  }
  return buffer.toString();
}

/// Index of the `)` matching the `(` at [open], skipping string literals;
/// -1 when unbalanced (truncated generated code, macros…).
int _matchingParen(String text, int open) {
  var depth = 0;
  var inStr = false;
  var quote = ' ';
  for (var i = open; i < text.length; i++) {
    final c = text[i];
    if (inStr) {
      if (c == quote && (i == 0 || text[i - 1] != r'\')) inStr = false;
      continue;
    }
    if (c == "'" || c == '"') {
      inStr = true;
      quote = c;
      continue;
    }
    if (c == '(') depth++;
    if (c == ')') {
      depth--;
      if (depth == 0) return i;
    }
  }
  return -1;
}

/// Top-level (depth-0) named arguments of a constructor body — commas
/// inside nested `()`/`[]`/`{}` or string literals do not split. `height:`
/// buried in a child subtree lands at depth > 0 and is therefore ignored.
List<String> _topLevelArgs(String body) {
  final out = <String>[];
  var depth = 0;
  var start = 0;
  var inStr = false;
  var quote = ' ';
  for (var i = 0; i < body.length; i++) {
    final c = body[i];
    if (inStr) {
      if (c == quote && (i == 0 || body[i - 1] != r'\')) inStr = false;
      continue;
    }
    if (c == "'" || c == '"') {
      inStr = true;
      quote = c;
      continue;
    }
    if (c == '(' || c == '[' || c == '{') {
      depth++;
    } else if (c == ')' || c == ']' || c == '}') {
      depth--;
    } else if (c == ',' && depth == 0) {
      out.add(body.substring(start, i));
      start = i + 1;
    }
  }
  out.add(body.substring(start));
  return out.map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
}

class BorderRow {
  const BorderRow(this.path, this.line, this.rule, this.source);

  final String path;
  final int line;
  final String rule;
  final String source;
}
