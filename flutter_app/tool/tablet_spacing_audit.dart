// Tablet Spacing & Gutter Standard — audit scanner.
//
// Locks the static half of
// docs/02_FLUTTER_MIGRATION/standards/Tablet-Spacing-Gutter-Standard.md
// across every tablet-surface Dart file under lib/ (path contains
// "/tablet/", or the file name mentions "tablet"). The tablet surface is
// already at ZERO literal spacing — these rules are absolute (no baseline,
// no ratchet): any new literal fails CI outright.
//
//   S1 literal gap      — `SizedBox(height|width: <number>` must reference
//                         an AppSpacing (or module spacing) token instead.
//   S2 literal inset    — EdgeInsets constructors with numeric literals
//                         (`EdgeInsets.all(12)`) must use tokens; token
//                         references like `AppSpacing.x5` do not match
//                         because the digit is glued to a word char.
//   S3 literal stroke   — `thickness: <number>` and `Divider(height:
//                         <number>` must use AppSpacing.dividerHairline /
//                         token references.
//   S4 pane separator   — a `SizedBox` standing as a DIRECT element of a
//                         rhythm-owning scaffold's children expression:
//                         `ProfilePaneScaffold(children:)` or
//                         `VitTwoColumnTabletDashboard(primaryChildren:/
//                         secondaryChildren:)`. Both scaffolds already wrap
//                         their children in VitPageContent(rhythm:) (the
//                         dashboard's columns do so per-column), which
//                         inserts the section gap between every pair of
//                         children, so an element-level SizedBox stacks onto
//                         those gaps (16+8+16=40dp instead of 16dp) and
//                         breaks the pane's rhythm. Children must stay flat
//                         — inner gaps belong inside child widgets, not
//                         between them. S4 is a token-blind rule: even a
//                         tokenized SizedBox is a violation at children
//                         level.
//
// Usage (from flutter_app/):
//   dart run tool/tablet_spacing_audit.dart            # regen artifact
//   dart run tool/tablet_spacing_audit.dart --check    # CI staleness
import 'dart:io';

const _artifactPath =
    '../docs/02_FLUTTER_MIGRATION/audits/VitTrade-Tablet-Spacing-Audit.csv';

final _literalGapRe = RegExp(r'SizedBox\(\s*(height|width):\s*\d');
final _literalInsetRe = RegExp(
  r'EdgeInsets(?:Directional)?\.\w+\([^)]*\b\d+\.?\d*\b[^)]*\)',
);
final _literalStrokeRe = RegExp(r'thickness:\s*\d');

/// Rhythm-owning scaffolds whose children expressions S4 guards. Both wrap
/// their children in VitPageContent(rhythm:) — the dashboard does so per
/// column — so an element-level separator SizedBox always stacks onto the
/// rhythm's own section gaps.
const _paneScaffoldMarkers = <String>[
  'ProfilePaneScaffold(',
  'VitTwoColumnTabletDashboard(',
];

/// Children argument names the S4 scanner recognizes on those scaffolds.
const _childrenArgs = <String>[
  'children:',
  'primaryChildren:',
  'secondaryChildren:',
];

void main(List<String> args) {
  _selfTest();
  final checkOnly = args.contains('--check');

  final rows = <SpacingRow>[];
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
    // Token files là nơi số liệu ĐƯỢC PHÉP sống (app_spacing,
    // *_spacing_tokens — kể cả tablet_spacing_tokens tách 2026-09-01):
    // scanner chỉ khóa literal tại call-site, không khóa định nghĩa token.
    if (normalized.contains('/app/theme/spacing/') ||
        normalized.endsWith('/app_spacing.dart')) {
      continue;
    }

    final lines = entity.readAsLinesSync();
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.trimLeft().startsWith('//')) continue;
      final rel = normalized.replaceFirst('lib/', '');
      if (_literalGapRe.hasMatch(line)) {
        rows.add(SpacingRow(rel, i + 1, 'S1-literal-gap', line.trim()));
      }
      if (_literalInsetRe.hasMatch(line)) {
        rows.add(SpacingRow(rel, i + 1, 'S2-literal-inset', line.trim()));
      }
      if (_literalStrokeRe.hasMatch(line) ||
          (line.contains('Divider(') &&
              RegExp(r'height:\s*\d').hasMatch(line))) {
        rows.add(SpacingRow(rel, i + 1, 'S3-literal-stroke', line.trim()));
      }
    }
    // S4 needs whole-file context (the children expression spans lines),
    // so it runs per file rather than per line — only on files that
    // actually mount one of the rhythm-owning scaffolds.
    if (lines.any((line) => _paneScaffoldMarkers.any(line.contains))) {
      final rel = normalized.replaceFirst('lib/', '');
      final stripped = [
        for (final line in lines) _stripLineComments(line),
      ].join('\n');
      for (final hit in findHighLevelPaneSeparators(stripped)) {
        final lineNo = '\n'.allMatches(stripped.substring(0, hit)).length + 1;
        rows.add(
          SpacingRow(
            rel,
            lineNo,
            'S4-pane-separator',
            lines[lineNo - 1].trim(),
          ),
        );
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
        'Tablet spacing audit artifact is stale. '
        'Run `dart run tool/tablet_spacing_audit.dart` from flutter_app/.',
      );
      exit(1);
    }
    stdout.writeln('Tablet spacing audit artifact is current.');
  } else {
    File(_artifactPath).writeAsStringSync(artifact);
    stdout.writeln('Wrote $_artifactPath');
  }

  stdout.writeln(
    rows.isEmpty
        ? 'Tablet spacing audit: 0 violations (absolute lock — no baseline).'
        : 'Tablet spacing audit: ${rows.length} violations (absolute lock — '
              'fix by moving to AppSpacing/module tokens, never baseline them).',
  );
}

// ---------------------------------------------------------------------------
// S4 — element-level pane separator scanner.
//
// Pure functions over a comment-stripped source string so the behavior is
// locked by the built-in self-test that runs on every tool invocation.
// ---------------------------------------------------------------------------

/// Returns the source indexes of every `SizedBox` token standing as a
/// direct element of a rhythm-owning scaffold's children expression —
/// checked against EVERY children argument of the occurrence
/// (`children:`/`primaryChildren:`/`secondaryChildren:`), not just the
/// first.
///
/// The children expression may be an inline list, a `snapshot.when(...)`
/// whose branches each return a list, or a helper call — only inline lists
/// are visible to static scanning; SizedBox elements built inside helper
/// functions are out of this rule's reach (and of its false-positive risk).
List<int> findHighLevelPaneSeparators(String source) {
  final hits = <int>[];
  for (final marker in _paneScaffoldMarkers) {
    for (final match in marker.allMatches(source)) {
      for (final range in _childrenExpressionRanges(source, match.end)) {
        hits.addAll(_elementLevelSizedBoxes(source, range.$1, range.$2));
      }
    }
  }
  return hits;
}

/// Locates every children argument expression (`children:`,
/// `primaryChildren:`, `secondaryChildren:`) inside the constructor
/// argument list that opens right before [argsStart]. Each returned
/// `(contentStart, contentEnd)` covers one argument's expression, from
/// after the argument name to the following `,`/`)` at argument depth.
/// An occurrence that declares (rather than passes) the parameter, or has
/// only helper-call children, yields no range for that argument.
List<(int, int)> _childrenExpressionRanges(String source, int argsStart) {
  // Depth counts every bracket kind: a `,` between list elements must sit
  // at depth 2+ (inside the `[...]`), so only the argument-level `,`/`)`
  // that FOLLOWS a children expression can close it.
  var depth = 1; // inside the constructor's parentheses
  var childrenStart = -1;
  final ranges = <(int, int)>[];
  var i = argsStart;
  while (i < source.length && depth > 0) {
    final ch = source[i];
    if (ch == "'" || ch == '"') {
      i = _skipString(source, i);
      continue;
    }
    if (ch == '(' || ch == '[' || ch == '{') depth++;
    if (ch == ')' || ch == ']' || ch == '}') depth--;
    if (depth == 1 && childrenStart < 0 && _atArgumentBoundary(source, i)) {
      for (final arg in _childrenArgs) {
        if (source.startsWith(arg, i)) {
          childrenStart = i + arg.length;
          break;
        }
      }
    }
    if (childrenStart >= 0 && depth == 1 && (ch == ',' || ch == ')')) {
      if (i > childrenStart) ranges.add((childrenStart, i));
      childrenStart = -1; // keep looking for the next children argument
    }
    i++;
  }
  return ranges;
}

/// Returns the indexes of `SizedBox` tokens at element level within
/// [start, end): tokens whose nesting depth equals the depth of the
/// outermost list's elements. SizedBox tokens nested deeper (inside a
/// child widget's own Column/body) are legal inner gaps and are ignored.
List<int> _elementLevelSizedBoxes(String source, int start, int end) {
  final hits = <int>[];
  var nest = 0; // relative depth inside the expression
  var elementDepth = -1; // depth of the outermost list's elements
  var i = start;
  while (i < end) {
    final ch = source[i];
    if (ch == "'" || ch == '"') {
      i = _skipString(source, i);
      continue;
    }
    if (ch == '(' || ch == '[' || ch == '{') {
      nest++;
      if (elementDepth < 0 && ch == '[') elementDepth = nest;
      i++;
      continue;
    }
    if (ch == ')' || ch == ']' || ch == '}') {
      nest--;
      i++;
      continue;
    }
    if (elementDepth >= 0 &&
        nest == elementDepth &&
        source.startsWith('SizedBox', i) &&
        !_isWordChar(source, i - 1) &&
        !_isWordChar(source, i + 'SizedBox'.length)) {
      hits.add(i);
    }
    i++;
  }
  return hits;
}

/// Advances past a string literal beginning at [start] (the opening quote)
/// and returns the index just after its closing quote.
int _skipString(String source, int start) {
  final quote = source[start];
  var i = start + 1;
  while (i < source.length) {
    if (source[i] == r'\') {
      i += 2;
      continue;
    }
    if (source[i] == quote) return i + 1;
    i++;
  }
  return i;
}

/// True when the identifier starting at [i] directly follows the argument
/// list's opening `(` or a separating `,` (skipping whitespace) — i.e. it
/// is an argument NAME, not a substring such as `this.children`.
bool _atArgumentBoundary(String source, int i) {
  var j = i - 1;
  while (j >= 0 &&
      (source[j] == ' ' ||
          source[j] == '\t' ||
          source[j] == '\n' ||
          source[j] == '\r')) {
    j--;
  }
  return j >= 0 && (source[j] == '(' || source[j] == ',');
}

bool _isWordChar(String source, int i) {
  if (i < 0 || i >= source.length) return false;
  final c = source.codeUnitAt(i);
  return (c >= 97 && c <= 122) || // a-z
      (c >= 65 && c <= 90) || // A-Z
      (c >= 48 && c <= 57) || // 0-9
      c == 95 || // _
      c == 36; // $
}

/// Strips a trailing `//` comment from one line, honoring string literals
/// (so `(chọn ảnh)` or `://` inside quotes never truncates code). Keeps
/// the line's newline handling to the caller (join with '\n' preserves
/// line numbers for reporting).
String _stripLineComments(String line) {
  for (var i = 0; i < line.length; i++) {
    final ch = line[i];
    if (ch == "'" || ch == '"') {
      i = _skipString(line, i) - 1;
      continue;
    }
    if (ch == '/' &&
        i + 1 < line.length &&
        line[i + 1] == '/' &&
        (i == 0 || line[i - 1] != ':')) {
      return line.substring(0, i);
    }
  }
  return line;
}

/// Locks the S4 scanner against regressions. Runs on every invocation
/// (regen and --check alike): a parser regression must fail CI loudly,
/// not silently stop catching separators.
void _selfTest() {
  void expectHits(String label, String source, List<int> expectedLines) {
    final source0 = source.startsWith('\n') ? source.substring(1) : source;
    final actualLines = [
      for (final hit in findHighLevelPaneSeparators(source0))
        '\n'.allMatches(source0.substring(0, hit)).length + 1,
    ]..sort();
    final expected = [...expectedLines]..sort();
    if (actualLines.toString() != expected.toString()) {
      stderr.writeln(
        'S4 self-test FAILED ($label): expected lines $expected, '
        'got $actualLines',
      );
      exit(2);
    }
  }

  // 1. The original bug shape: a separator SizedBox between top-level panes.
  expectHits(
    'inline separator',
    '''return ProfilePaneScaffold(
  children: [
    _Hero(),
    SizedBox(height: VitDensity.compact.verticalSpace),
    _Tabs(),
  ],
);''',
    [4],
  );

  // 2. Same shape inside a snapshot.when data branch.
  expectHits(
    'when-branch separator',
    '''return ProfilePaneScaffold(
  children: snapshot.when(
    loading: () => const [VitSkeleton()],
    data: (s) => [
      _Hero(s),
      SizedBox(height: AppSpacing.x2),
    ],
  ),
);''',
    [6],
  );

  // 3. SizedBox nested inside a child widget is a legal inner gap.
  expectHits('inner gap is legal', '''return ProfilePaneScaffold(
  children: [
    _Card(
      child: Column(
        children: [
          Text('a'),
          SizedBox(height: AppSpacing.x1),
        ],
      ),
    ),
  ],
);''', []);

  // 4. Helper-built children are invisible to the scanner — no hit, and no
  //    false positive either.
  expectHits(
    'helper children',
    'return ProfilePaneScaffold(children: _paneChildren());',
    [],
  );

  // 5. Parens inside a stripped comment must not tilt the depth tracking,
  //    and the element-level SizedBox is still caught.
  expectHits(
    'comment parens',
    '''return ProfilePaneScaffold(
  children: [
    _Hero(), // gap (16+8+16) stacked here previously
    SizedBox(height: AppSpacing.cardGap),
  ],
);''',
    [4],
  );

  // 6. Parens inside string literals (UI copy) must not tilt depth either.
  expectHits(
    'string parens',
    '''return ProfilePaneScaffold(
  children: [
    Text('(chọn ảnh) (1)'),
    SizedBox(height: AppSpacing.x1),
  ],
);''',
    [4],
  );

  // 7. Token-blind: even a fully tokenized const SizedBox is a violation
  //    when standing at children level.
  expectHits(
    'const element separator',
    '''return ProfilePaneScaffold(
  children: [
    const SizedBox(height: AppSpacing.cardGap),
  ],
);''',
    [3],
  );

  // 8. The dashboard scaffold is guarded too: a separator SizedBox in
  //    primaryChildren is caught at that list's element level.
  expectHits(
    'dashboard primary separator',
    '''return VitTwoColumnTabletDashboard(
  primaryChildren: [
    _Portfolio(),
    SizedBox(height: AppSpacing.cardGap),
  ],
  secondaryChildren: [
    _Sidebar(),
  ],
);''',
    [4],
  );

  // 9. ...and so is one standing in secondaryChildren.
  expectHits(
    'dashboard secondary separator',
    '''return VitTwoColumnTabletDashboard(
  primaryChildren: [_Main()],
  secondaryChildren: [
    _Sidebar(),
    const SizedBox(height: AppSpacing.x1),
  ],
);''',
    [5],
  );

  // 10. A SizedBox nested inside a dashboard child widget is a legal inner
  //     gap, in either column.
  expectHits('dashboard inner gap legal', '''return VitTwoColumnTabletDashboard(
  primaryChildren: [
    _Card(
      child: Column(
        children: [
          Text('a'),
          SizedBox(height: AppSpacing.x1),
        ],
      ),
    ),
  ],
  secondaryChildren: const [VitSkeleton()],
);''', []);

  // 11. Both columns are checked independently — a long primary list must
  //     not shadow separators standing in secondaryChildren (the shape that
  //     exposed the first-arg-only scanner bug), and a short primary must
  //     not leak the scan past its own list either.
  expectHits(
    'both columns independently',
    '''return VitTwoColumnTabletDashboard(
  primaryChildren: [
    _ProductTabsSkeleton(),
    SizedBox(height: AppSpacing.pageRhythmCompactSectionGap),
    VitCard(child: _OrderFormSkeleton()),
    SizedBox(height: AppSpacing.pageRhythmCompactSectionGap),
    _RiskPanelSkeleton(),
  ],
  secondaryChildren: [
    _SidebarHeadingSkeleton(),
    SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
    VitCard(child: VitSkeletonList(rows: 2)),
  ],
);''',
    [4, 6, 11],
  );
}

String _renderArtifact(List<SpacingRow> rows) {
  final buffer = StringBuffer()
    ..writeln('path,line,rule,source')
    ..writeln(
      '# Generated by tool/tablet_spacing_audit.dart — regenerate after touching tablet presentation files.',
    );
  for (final row in rows) {
    buffer.writeln(
      '${row.path},${row.line},${row.rule},"${row.source.replaceAll('"', '""')}"',
    );
  }
  return buffer.toString();
}

class SpacingRow {
  const SpacingRow(this.path, this.line, this.rule, this.source);

  final String path;
  final int line;
  final String rule;
  final String source;
}
