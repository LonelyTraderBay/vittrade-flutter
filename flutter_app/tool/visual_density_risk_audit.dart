import 'dart:io';

final class CsvRow {
  const CsvRow(this.fields);

  final Map<String, String> fields;

  String operator [](String key) => fields[key] ?? '';

  int intValue(String key) => int.tryParse(this[key]) ?? 0;
}

final class SourceBundle {
  const SourceBundle({
    required this.source,
    required this.files,
    required this.unresolvedFiles,
  });

  final String source;
  final List<String> files;
  final List<String> unresolvedFiles;
}

final class VisualDensityEntry {
  const VisualDensityEntry({
    required this.feature,
    required this.route,
    required this.page,
    required this.pageFile,
    required this.screenLevel,
    required this.archetype,
    required this.bodyGrade,
    required this.officialDensityScore,
    required this.visualDensityRiskScore,
    required this.visualDensityPriority,
    required this.tokenizedFixedHeightRefs,
    required this.tokenizedGapRefs,
    required this.spacerRefs,
    required this.manualContentRefs,
    required this.bottomInsetRefs,
    required this.rootTopChromeRefs,
    required this.detailTopChromeRefs,
    required this.scrollRefs,
    required this.gridOrWrapRefs,
    required this.rootCauses,
    required this.recommendation,
    required this.sourceFiles,
    required this.unresolvedSourceFiles,
  });

  final String feature;
  final String route;
  final String page;
  final String pageFile;
  final String screenLevel;
  final String archetype;
  final String bodyGrade;
  final int officialDensityScore;
  final int visualDensityRiskScore;
  final String visualDensityPriority;
  final int tokenizedFixedHeightRefs;
  final int tokenizedGapRefs;
  final int spacerRefs;
  final int manualContentRefs;
  final int bottomInsetRefs;
  final int rootTopChromeRefs;
  final int detailTopChromeRefs;
  final int scrollRefs;
  final int gridOrWrapRefs;
  final List<String> rootCauses;
  final String recommendation;
  final List<String> sourceFiles;
  final List<String> unresolvedSourceFiles;
}

const _generatedDate = '2026-06-19';

const _priorityOrder = <String>[
  'P0_CRITICAL_DENSITY_REVIEW',
  'P1_HIGH_DENSITY_REVIEW',
  'P1_TOOL_VISUAL_QA',
  'P2_MEDIUM_DENSITY_REVIEW',
  'P3_LOW_DENSITY_REVIEW',
  'PASS_MONITOR',
];

void main(List<String> args) {
  final checkOnly = args.contains('--check');
  final appRoot = _findAppRoot();
  final repoRoot = appRoot.uri.resolve('..').toFilePath();
  final docsDir = Directory('${repoRoot}docs/02_FLUTTER_MIGRATION');
  final bodyCsvFile = File(
    '${docsDir.path}/audits/VitTrade-Body-Component-Consistency-Audit.csv',
  );
  final officialDensityCsvFile = File(
    '${docsDir.path}/audits/VitTrade-UI-Fullscreen-Density-Audit.csv',
  );
  final markdownFile = File(
    '${docsDir.path}/audits/VitTrade-Visual-Density-Risk-Audit.md',
  );
  final csvFile = File(
    '${docsDir.path}/audits/VitTrade-Visual-Density-Risk-Audit.csv',
  );

  if (!bodyCsvFile.existsSync()) {
    stderr.writeln(
      'Missing body component CSV. Run '
      '`dart run tool/body_component_consistency_audit.dart` first.',
    );
    exitCode = 1;
    return;
  }

  if (!officialDensityCsvFile.existsSync()) {
    stderr.writeln(
      'Missing UI fullscreen density CSV. Run '
      '`dart run tool/ui_fullscreen_density_audit.dart` first.',
    );
    exitCode = 1;
    return;
  }

  final bodyRows = _readCsvRows(bodyCsvFile);
  final officialDensityByRoute = {
    for (final row in _readCsvRows(officialDensityCsvFile)) row['route']: row,
  };

  final entries = _collectEntries(
    bodyRows: bodyRows,
    officialDensityByRoute: officialDensityByRoute,
    repoRoot: repoRoot,
  )..sort(_compareEntries);

  final markdown = _renderMarkdown(entries);
  final csv = _renderCsv(entries);
  final summary = _renderSummary(entries);

  if (checkOnly) {
    final failures = <String>[];
    if (entries.length != 409) {
      failures.add(
        'Visual density audit expected 409 routed screens, '
        'found ${entries.length}.',
      );
    }
    if (!markdownFile.existsSync()) {
      failures.add('Visual density risk markdown artifact is missing.');
    } else if (markdownFile.readAsStringSync() != markdown) {
      failures.add('Visual density risk markdown artifact is stale.');
    }

    if (!csvFile.existsSync()) {
      failures.add('Visual density risk CSV artifact is missing.');
    } else if (csvFile.readAsStringSync() != csv) {
      failures.add('Visual density risk CSV artifact is stale.');
    }

    if (failures.isNotEmpty) {
      for (final failure in failures) {
        stderr.writeln(failure);
      }
      stderr.writeln(
        'Run `dart run tool/visual_density_risk_audit.dart` '
        'from flutter_app/.',
      );
      exitCode = 1;
      return;
    }

    stdout.write(summary);
    stdout.writeln('Visual density risk artifacts are current.');
    return;
  }

  docsDir.createSync(recursive: true);
  markdownFile.writeAsStringSync(markdown);
  csvFile.writeAsStringSync(csv);
  stdout.writeln('Wrote ${markdownFile.path}');
  stdout.writeln('Wrote ${csvFile.path}');
  stdout.write(summary);
}

Directory _findAppRoot() {
  final current = Directory.current;
  if (Directory('${current.path}/lib/app/router/route_groups').existsSync()) {
    return current;
  }

  final nested = Directory('${current.path}/flutter_app');
  if (Directory('${nested.path}/lib/app/router/route_groups').existsSync()) {
    return nested;
  }

  throw StateError('Run from repo root or flutter_app/.');
}

List<CsvRow> _readCsvRows(File csvFile) {
  final lines = csvFile.readAsLinesSync();
  if (lines.isEmpty) return const [];

  final headers = _parseCsvLine(lines.first);
  final rows = <CsvRow>[];

  for (final line in lines.skip(1)) {
    if (line.trim().isEmpty) continue;
    final values = _parseCsvLine(line);
    rows.add(
      CsvRow({
        for (var i = 0; i < headers.length; i++)
          headers[i]: i < values.length ? values[i] : '',
      }),
    );
  }

  return rows;
}

List<VisualDensityEntry> _collectEntries({
  required List<CsvRow> bodyRows,
  required Map<String, CsvRow> officialDensityByRoute,
  required String repoRoot,
}) {
  return [
    for (final row in bodyRows)
      _entryFor(
        row: row,
        officialDensityRow: officialDensityByRoute[row['route']],
        sourceBundle: _sourceBundleFor(row, repoRoot),
      ),
  ];
}

SourceBundle _sourceBundleFor(CsvRow row, String repoRoot) {
  final sourceFiles = _sourceFilesFor(row);
  final buffer = StringBuffer();
  final resolved = <String>[];
  final unresolved = <String>[];

  for (final sourceFile in sourceFiles) {
    final file = File(
      '$repoRoot${sourceFile.replaceAll('/', Platform.pathSeparator)}',
    );
    if (!file.existsSync()) {
      unresolved.add(sourceFile);
      continue;
    }

    resolved.add(sourceFile);
    buffer
      ..writeln()
      ..write(file.readAsStringSync());
  }

  return SourceBundle(
    source: buffer.toString(),
    files: resolved,
    unresolvedFiles: unresolved,
  );
}

List<String> _sourceFilesFor(CsvRow row) {
  final sourceFiles = row['source_files']
      .split(';')
      .map((file) => file.trim())
      .where((file) => file.isNotEmpty)
      .toList();
  if (sourceFiles.isNotEmpty) return sourceFiles;

  final pageFile = row['page_file'].trim();
  if (pageFile.isEmpty || pageFile == 'unresolved' || pageFile == '-') {
    return const [];
  }
  return [pageFile];
}

VisualDensityEntry _entryFor({
  required CsvRow row,
  required CsvRow? officialDensityRow,
  required SourceBundle sourceBundle,
}) {
  final source = sourceBundle.source;
  final officialScore = officialDensityRow?.intValue('density_score') ?? 0;
  final tokenizedFixedHeightRefs = _countTokenizedFixedHeightRefs(source);
  final tokenizedGapRefs = _countTokenizedGapRefs(source);
  final spacerRefs = _countRegex(source, RegExp(r'\bSpacer\s*\('));
  final manualContentRefs = _countManualContentRefs(source);
  final bottomInsetRefs = _countBottomInsetRefs(source);
  final rootTopChromeRefs = _countRootTopChromeRefs(source);
  final detailTopChromeRefs = _countDetailTopChromeRefs(source);
  final scrollRefs = _countScrollRefs(source);
  final gridOrWrapRefs = _countGridOrWrapRefs(source);

  final visualScore =
      officialScore +
      tokenizedFixedHeightRefs * 3 +
      tokenizedGapRefs * 2 +
      spacerRefs * 4 +
      manualContentRefs * 5 +
      bottomInsetRefs * 2 +
      rootTopChromeRefs * 3 +
      detailTopChromeRefs;
  final priority = _visualDensityPriority(row['archetype'], visualScore);
  final rootCauses = _rootCauses(
    archetype: row['archetype'],
    bodyGrade: row['body_grade'],
    officialDensityScore: officialScore,
    visualDensityRiskScore: visualScore,
    tokenizedFixedHeightRefs: tokenizedFixedHeightRefs,
    tokenizedGapRefs: tokenizedGapRefs,
    spacerRefs: spacerRefs,
    manualContentRefs: manualContentRefs,
    bottomInsetRefs: bottomInsetRefs,
    rootTopChromeRefs: rootTopChromeRefs,
    unresolvedSourceFiles: sourceBundle.unresolvedFiles,
  );

  return VisualDensityEntry(
    feature: row['feature'],
    route: row['route'],
    page: row['page'],
    pageFile: row['page_file'],
    screenLevel: row['screen_level'],
    archetype: row['archetype'],
    bodyGrade: row['body_grade'],
    officialDensityScore: officialScore,
    visualDensityRiskScore: visualScore,
    visualDensityPriority: priority,
    tokenizedFixedHeightRefs: tokenizedFixedHeightRefs,
    tokenizedGapRefs: tokenizedGapRefs,
    spacerRefs: spacerRefs,
    manualContentRefs: manualContentRefs,
    bottomInsetRefs: bottomInsetRefs,
    rootTopChromeRefs: rootTopChromeRefs,
    detailTopChromeRefs: detailTopChromeRefs,
    scrollRefs: scrollRefs,
    gridOrWrapRefs: gridOrWrapRefs,
    rootCauses: rootCauses,
    recommendation: _recommendation(priority: priority, rootCauses: rootCauses),
    sourceFiles: sourceBundle.files,
    unresolvedSourceFiles: sourceBundle.unresolvedFiles,
  );
}

int _countTokenizedFixedHeightRefs(String source) {
  return _countRegex(
    source,
    RegExp(r'\bheight\s*:\s*AppSpacing\.[A-Za-z0-9_]*Height[A-Za-z0-9_]*\b'),
  );
}

int _countTokenizedGapRefs(String source) {
  // Count ad-hoc Gap/Spacing tokens only. Sanctioned pageRhythm* aliases are
  // required by page_rhythm_spacing_scale_guardrail (raw x2/x3/x4 banned), so
  // they must not inflate sparse-density risk.
  return _countRegex(
    source,
    RegExp(
      r'SizedBox\s*\(\s*height\s*:\s*AppSpacing\.(?!pageRhythm)[A-Za-z0-9_]*(?:Gap|Spacing|Top|Bottom)\b',
    ),
  );
}

int _countManualContentRefs(String source) {
  return _countRegex(
    source,
    RegExp(
      r'\bcustomGap\s*:|VitContentPadding\.relaxed|VitContentGap\.(?:loose|relaxed)',
    ),
  );
}

int _countBottomInsetRefs(String source) {
  return _countRegex(
    source,
    RegExp(r'bottomInset|BottomInset|bottomChrome|BottomChrome'),
  );
}

int _countRootTopChromeRefs(String source) {
  return _countRegex(
    source,
    RegExp(r'VitTopChromeType\.(?:rootModule|rootBrand)'),
  );
}

int _countDetailTopChromeRefs(String source) {
  return _countRegex(
    source,
    RegExp(r'VitTopChromeType\.detail|\bVitHeader\s*\('),
  );
}

int _countScrollRefs(String source) {
  return _countRegex(
    source,
    RegExp(
      r'\b(?:SingleChildScrollView|CustomScrollView|ListView|GridView|VitInsetScrollView)\s*\(',
    ),
  );
}

int _countGridOrWrapRefs(String source) {
  return _countRegex(
    source,
    RegExp(r'\b(?:GridView|Wrap|SliverGrid|VitActionTileGrid)\s*\('),
  );
}

String _visualDensityPriority(String archetype, int visualScore) {
  if (archetype == 'fullscreenTool') return 'P1_TOOL_VISUAL_QA';
  if (visualScore >= 60) return 'P0_CRITICAL_DENSITY_REVIEW';
  if (visualScore >= 40) return 'P1_HIGH_DENSITY_REVIEW';
  if (visualScore >= 25) return 'P2_MEDIUM_DENSITY_REVIEW';
  if (visualScore >= 10) return 'P3_LOW_DENSITY_REVIEW';
  return 'PASS_MONITOR';
}

List<String> _rootCauses({
  required String archetype,
  required String bodyGrade,
  required int officialDensityScore,
  required int visualDensityRiskScore,
  required int tokenizedFixedHeightRefs,
  required int tokenizedGapRefs,
  required int spacerRefs,
  required int manualContentRefs,
  required int bottomInsetRefs,
  required int rootTopChromeRefs,
  required List<String> unresolvedSourceFiles,
}) {
  final causes = <String>[];

  if (unresolvedSourceFiles.isNotEmpty) {
    causes.add('source_file_unresolved');
  }
  if (archetype == 'fullscreenTool') {
    causes.add('fullscreen_tool_manual_visual_qa');
  }
  if (tokenizedFixedHeightRefs >= 8) {
    causes.add('very_high_tokenized_fixed_height_pressure');
  } else if (tokenizedFixedHeightRefs >= 4) {
    causes.add('tokenized_fixed_height_pressure');
  }
  if (tokenizedGapRefs >= 8) {
    causes.add('very_high_vertical_gap_accumulation');
  } else if (tokenizedGapRefs >= 4) {
    causes.add('vertical_gap_accumulation');
  }
  if (spacerRefs >= 4) {
    causes.add('spacer_driven_loose_cards');
  } else if (spacerRefs > 0) {
    causes.add('spacer_inside_cards');
  }
  if (manualContentRefs >= 2) {
    causes.add('manual_content_density_bypass');
  }
  if (bottomInsetRefs >= 2) {
    causes.add('bottom_nav_inset_pressure');
  }
  if (rootTopChromeRefs > 0) {
    causes.add('root_top_chrome_first_viewport_cost');
  }
  if (officialDensityScore < 8 && visualDensityRiskScore >= 25) {
    causes.add('official_audit_blind_spot');
  }
  if (bodyGrade == 'A' && visualDensityRiskScore >= 25) {
    causes.add('shared_component_compliant_but_sparse');
  }

  if (causes.isEmpty) causes.add('low_signal_monitor');
  return causes;
}

String _recommendation({
  required String priority,
  required List<String> rootCauses,
}) {
  if (priority == 'P1_TOOL_VISUAL_QA') {
    return 'Keep fullscreen-tool treatment; verify safe areas, controls, '
        'nonblank render, and emulator screenshot evidence.';
  }
  if (rootCauses.contains('manual_content_density_bypass')) {
    return 'Replace relaxed/custom content rhythm with shared compact '
        'sections before tuning individual cards.';
  }
  if (rootCauses.contains('very_high_tokenized_fixed_height_pressure') ||
      rootCauses.contains('tokenized_fixed_height_pressure') ||
      rootCauses.contains('very_high_vertical_gap_accumulation') ||
      rootCauses.contains('vertical_gap_accumulation')) {
    return 'Compact first viewport: reduce tall tokenized cards/gaps and '
        'verify first repeated/actionable section above bottom nav.';
  }
  if (rootCauses.contains('spacer_driven_loose_cards') ||
      rootCauses.contains('spacer_inside_cards')) {
    return 'Remove Spacer-driven loose card expansion or replace with fixed '
        'compact content rhythm.';
  }
  if (rootCauses.contains('bottom_nav_inset_pressure')) {
    return 'Recheck bottom-nav/sticky-footer clearance and keep primary '
        'content visible above chrome.';
  }
  if (priority == 'PASS_MONITOR') {
    return 'Keep as reference/monitor screen; avoid unnecessary churn.';
  }
  return 'Review first viewport manually and apply shared compact primitives '
      'without removing safety or domain-copy requirements.';
}

String _renderMarkdown(List<VisualDensityEntry> entries) {
  final priorityCounts = _countsBy(
    entries.map((entry) => entry.visualDensityPriority),
  );
  final rootCauseCounts = _rootCauseCounts(entries);
  final featureGroups = <String, List<VisualDensityEntry>>{};
  for (final entry in entries) {
    featureGroups.putIfAbsent(entry.feature, () => []).add(entry);
  }
  final toolEntries = entries
      .where((entry) => entry.visualDensityPriority == 'P1_TOOL_VISUAL_QA')
      .toList(growable: false);
  final flagged = entries
      .where((entry) => entry.visualDensityPriority != 'PASS_MONITOR')
      .toList(growable: false);

  final buffer = StringBuffer()
    ..writeln('# VitTrade Visual Density Risk Audit')
    ..writeln()
    ..writeln('Generated: $_generatedDate')
    ..writeln()
    ..writeln(
      'Generated from `flutter_app/tool/visual_density_risk_audit.dart`.',
    )
    ..writeln()
    ..writeln('## Inputs')
    ..writeln()
    ..writeln(
      '- `docs/02_FLUTTER_MIGRATION/audits/VitTrade-Body-Component-Consistency-Audit.csv`',
    )
    ..writeln(
      '- `docs/02_FLUTTER_MIGRATION/audits/VitTrade-UI-Fullscreen-Density-Audit.csv`',
    )
    ..writeln('- Routed page files, `part` files, and feature-local widgets')
    ..writeln()
    ..writeln('## Summary')
    ..writeln()
    ..writeln('```text')
    ..write(_renderSummary(entries))
    ..writeln('```')
    ..writeln()
    ..writeln('## Threshold Policy')
    ..writeln()
    ..writeln('| Priority | Rule | Required action |')
    ..writeln('| --- | --- | --- |')
    ..writeln(
      '| `P0_CRITICAL_DENSITY_REVIEW` | risk score >= 60 | Refactor by archetype before broad rollout; emulator evidence for representative routes. |',
    )
    ..writeln(
      '| `P1_HIGH_DENSITY_REVIEW` | risk score 40-59 | Fix after P0 reference pattern, or document accepted exception with screenshot evidence. |',
    )
    ..writeln(
      '| `P1_TOOL_VISUAL_QA` | fullscreen tool archetype | Do not generic-compact; verify safe areas, controls, and nonblank full-screen rendering. |',
    )
    ..writeln(
      '| `P2_MEDIUM_DENSITY_REVIEW` | risk score 25-39 | Process after compact primitives stabilize; assign fixed/accepted/monitor status. |',
    )
    ..writeln(
      '| `P3_LOW_DENSITY_REVIEW` | risk score 10-24 | Monitor and apply density DoD when touched. |',
    )
    ..writeln(
      '| `PASS_MONITOR` | risk score < 10 | Use as reference unless a concrete UI issue appears. |',
    )
    ..writeln()
    ..writeln(
      'Exceptions require a reason, route, owner feature, and emulator or '
      'widget-test evidence. Compactness must not remove financial safety '
      'copy, Prediction/Arena boundary copy, labels, touch target comfort, '
      'or responsive behavior at 360 px.',
    )
    ..writeln()
    ..writeln('## Priority Counts')
    ..writeln()
    ..writeln('| Priority | Routes |')
    ..writeln('| --- | ---: |');

  for (final priority in _priorityOrder) {
    buffer.writeln('| `$priority` | ${priorityCounts[priority] ?? 0} |');
  }

  buffer
    ..writeln()
    ..writeln('## Root Cause Counts')
    ..writeln()
    ..writeln('| Root cause | Routes |')
    ..writeln('| --- | ---: |');

  for (final count in _sortedCounts(rootCauseCounts)) {
    buffer.writeln('| `${_markdownCell(count.key)}` | ${count.value} |');
  }

  buffer
    ..writeln()
    ..writeln('## Feature-Level Risk')
    ..writeln()
    ..writeln(
      '| Feature | Routes | Avg risk | Max | P0 | P1 | Tool | P2 | P3 | Pass |',
    )
    ..writeln(
      '| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |',
    );

  final featureNames = featureGroups.keys.toList()
    ..sort((a, b) {
      final aMax = _maxRisk(featureGroups[a]!);
      final bMax = _maxRisk(featureGroups[b]!);
      final maxCompare = bMax.compareTo(aMax);
      if (maxCompare != 0) return maxCompare;
      return a.compareTo(b);
    });

  for (final feature in featureNames) {
    final group = featureGroups[feature]!;
    final priorities = _countsBy(
      group.map((entry) => entry.visualDensityPriority),
    );
    final avgRisk =
        group.fold<int>(0, (sum, entry) => sum + entry.visualDensityRiskScore) /
        group.length;
    buffer.writeln(
      '| `$feature` | ${group.length} | ${avgRisk.toStringAsFixed(1)} | '
      '${_maxRisk(group)} | ${priorities['P0_CRITICAL_DENSITY_REVIEW'] ?? 0} | '
      '${priorities['P1_HIGH_DENSITY_REVIEW'] ?? 0} | '
      '${priorities['P1_TOOL_VISUAL_QA'] ?? 0} | '
      '${priorities['P2_MEDIUM_DENSITY_REVIEW'] ?? 0} | '
      '${priorities['P3_LOW_DENSITY_REVIEW'] ?? 0} | '
      '${priorities['PASS_MONITOR'] ?? 0} |',
    );
  }

  buffer
    ..writeln()
    ..writeln('## Top Risk Routes')
    ..writeln()
    ..writeln(
      '| Priority | Score | Feature | Page | Route | Root causes | Recommendation | Page file |',
    )
    ..writeln('| --- | ---: | --- | --- | --- | --- | --- | --- |');

  for (final entry in flagged.take(80)) {
    final cells = [
      entry.visualDensityPriority,
      '${entry.visualDensityRiskScore}',
      entry.feature,
      entry.page,
      '`${entry.route}`',
      entry.rootCauses.join('; '),
      entry.recommendation,
      '`${entry.pageFile}`',
    ].map(_markdownCell).join(' | ');
    buffer.writeln('| $cells |');
  }

  buffer
    ..writeln()
    ..writeln('## Fullscreen Tool Exceptions')
    ..writeln()
    ..writeln('| Feature | Page | Route | Score | Required QA |')
    ..writeln('| --- | --- | --- | ---: | --- |');

  for (final entry in toolEntries) {
    buffer.writeln(
      '| ${entry.feature} | `${_markdownCell(entry.page)}` | '
      '`${_markdownCell(entry.route)}` | ${entry.visualDensityRiskScore} | '
      '${_markdownCell(entry.recommendation)} |',
    );
  }

  buffer
    ..writeln()
    ..writeln('## Verification Commands')
    ..writeln()
    ..writeln('```bash')
    ..writeln('cd flutter_app')
    ..writeln('dart run tool/body_component_consistency_audit.dart --check')
    ..writeln('dart run tool/ui_fullscreen_density_audit.dart --check')
    ..writeln('dart run tool/visual_density_risk_audit.dart')
    ..writeln('dart run tool/visual_density_risk_audit.dart --check')
    ..writeln('```')
    ..writeln()
    ..writeln('## Route Visual Density Inventory')
    ..writeln()
    ..writeln(
      '| Feature | Route | Page | Screen level | Archetype | Body grade | Official score | Visual risk | Priority | Fixed height | Gap | Spacer | Manual content | Bottom inset | Root chrome | Detail chrome | Scroll | Grid/wrap | Root causes | Recommendation | Source files | Page file |',
    )
    ..writeln(
      '| --- | --- | --- | --- | --- | --- | ---: | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- | --- | ---: | --- |',
    );

  for (final entry in entries) {
    buffer.writeln(
      '| ${entry.feature} | `${_markdownCell(entry.route)}` | '
      '`${_markdownCell(entry.page)}` | ${entry.screenLevel} | '
      '${entry.archetype} | ${entry.bodyGrade} | '
      '${entry.officialDensityScore} | ${entry.visualDensityRiskScore} | '
      '${entry.visualDensityPriority} | ${entry.tokenizedFixedHeightRefs} | '
      '${entry.tokenizedGapRefs} | ${entry.spacerRefs} | '
      '${entry.manualContentRefs} | ${entry.bottomInsetRefs} | '
      '${entry.rootTopChromeRefs} | ${entry.detailTopChromeRefs} | '
      '${entry.scrollRefs} | ${entry.gridOrWrapRefs} | '
      '${_markdownCell(entry.rootCauses.join('; '))} | '
      '${_markdownCell(entry.recommendation)} | '
      '${entry.sourceFiles.length} | `${_markdownCell(entry.pageFile)}` |',
    );
  }

  return buffer.toString();
}

String _renderCsv(List<VisualDensityEntry> entries) {
  final buffer = StringBuffer()
    ..writeln(
      [
        'feature',
        'route',
        'page',
        'page_file',
        'screen_level',
        'archetype',
        'body_grade',
        'official_density_score',
        'visual_density_risk_score',
        'visual_density_priority',
        'tokenized_fixed_height_refs',
        'tokenized_gap_refs',
        'spacer_refs',
        'manual_content_refs',
        'bottom_inset_refs',
        'root_top_chrome_refs',
        'detail_top_chrome_refs',
        'scroll_refs',
        'grid_or_wrap_refs',
        'root_causes',
        'recommendation',
        'source_files',
        'unresolved_source_files',
      ].join(','),
    );

  for (final entry in entries) {
    buffer.writeln(
      [
        entry.feature,
        entry.route,
        entry.page,
        entry.pageFile,
        entry.screenLevel,
        entry.archetype,
        entry.bodyGrade,
        '${entry.officialDensityScore}',
        '${entry.visualDensityRiskScore}',
        entry.visualDensityPriority,
        '${entry.tokenizedFixedHeightRefs}',
        '${entry.tokenizedGapRefs}',
        '${entry.spacerRefs}',
        '${entry.manualContentRefs}',
        '${entry.bottomInsetRefs}',
        '${entry.rootTopChromeRefs}',
        '${entry.detailTopChromeRefs}',
        '${entry.scrollRefs}',
        '${entry.gridOrWrapRefs}',
        entry.rootCauses.join(';'),
        entry.recommendation,
        entry.sourceFiles.join(';'),
        entry.unresolvedSourceFiles.join(';'),
      ].map(_csvEscape).join(','),
    );
  }

  return buffer.toString();
}

String _renderSummary(List<VisualDensityEntry> entries) {
  final priorityCounts = _countsBy(
    entries.map((entry) => entry.visualDensityPriority),
  );
  final rootCauseCounts = _rootCauseCounts(entries);
  final buffer = StringBuffer()
    ..writeln('total_routed_screens=${entries.length}');

  for (final priority in _priorityOrder) {
    buffer.writeln('$priority=${priorityCounts[priority] ?? 0}');
  }

  buffer
    ..writeln(
      'root_official_audit_blind_spot='
      '${rootCauseCounts['official_audit_blind_spot'] ?? 0}',
    )
    ..writeln(
      'root_shared_component_compliant_but_sparse='
      '${rootCauseCounts['shared_component_compliant_but_sparse'] ?? 0}',
    )
    ..writeln(
      'root_tokenized_fixed_height_pressure='
      '${(rootCauseCounts['tokenized_fixed_height_pressure'] ?? 0) + (rootCauseCounts['very_high_tokenized_fixed_height_pressure'] ?? 0)}',
    )
    ..writeln(
      'root_vertical_gap_accumulation='
      '${(rootCauseCounts['vertical_gap_accumulation'] ?? 0) + (rootCauseCounts['very_high_vertical_gap_accumulation'] ?? 0)}',
    )
    ..writeln(
      'root_spacer_driven_looseness='
      '${(rootCauseCounts['spacer_inside_cards'] ?? 0) + (rootCauseCounts['spacer_driven_loose_cards'] ?? 0)}',
    )
    ..writeln(
      'root_manual_content_density_bypass='
      '${rootCauseCounts['manual_content_density_bypass'] ?? 0}',
    )
    ..writeln(
      'root_bottom_nav_inset_pressure='
      '${rootCauseCounts['bottom_nav_inset_pressure'] ?? 0}',
    )
    ..writeln(
      'root_top_chrome_first_viewport_cost='
      '${rootCauseCounts['root_top_chrome_first_viewport_cost'] ?? 0}',
    );
  return buffer.toString();
}

Map<String, int> _countsBy(Iterable<String> values) {
  final counts = <String, int>{};
  for (final value in values) {
    counts[value] = (counts[value] ?? 0) + 1;
  }
  return counts;
}

Map<String, int> _rootCauseCounts(List<VisualDensityEntry> entries) {
  final counts = <String, int>{};
  for (final entry in entries) {
    for (final cause in entry.rootCauses) {
      counts[cause] = (counts[cause] ?? 0) + 1;
    }
  }
  return counts;
}

List<MapEntry<String, int>> _sortedCounts(Map<String, int> counts) {
  return counts.entries.toList()..sort((a, b) {
    final valueCompare = b.value.compareTo(a.value);
    if (valueCompare != 0) return valueCompare;
    return a.key.compareTo(b.key);
  });
}

int _maxRisk(List<VisualDensityEntry> entries) {
  return entries.fold<int>(
    0,
    (max, entry) =>
        entry.visualDensityRiskScore > max ? entry.visualDensityRiskScore : max,
  );
}

int _compareEntries(VisualDensityEntry a, VisualDensityEntry b) {
  final priority = _priorityOrder
      .indexOf(a.visualDensityPriority)
      .compareTo(_priorityOrder.indexOf(b.visualDensityPriority));
  if (priority != 0) return priority;
  final score = b.visualDensityRiskScore.compareTo(a.visualDensityRiskScore);
  if (score != 0) return score;
  final feature = a.feature.compareTo(b.feature);
  if (feature != 0) return feature;
  final page = a.page.compareTo(b.page);
  if (page != 0) return page;
  return a.route.compareTo(b.route);
}

int _countRegex(String source, RegExp pattern) {
  return pattern.allMatches(source).length;
}

List<String> _parseCsvLine(String line) {
  final values = <String>[];
  final buffer = StringBuffer();
  var inQuotes = false;
  var index = 0;

  while (index < line.length) {
    final char = line[index];
    if (char == '"') {
      final isEscapedQuote =
          inQuotes && index + 1 < line.length && line[index + 1] == '"';
      if (isEscapedQuote) {
        buffer.write('"');
        index += 2;
        continue;
      }
      inQuotes = !inQuotes;
      index += 1;
      continue;
    }

    if (char == ',' && !inQuotes) {
      values.add(buffer.toString());
      buffer.clear();
      index += 1;
      continue;
    }

    buffer.write(char);
    index += 1;
  }

  values.add(buffer.toString());
  return values;
}

String _csvEscape(String value) {
  final escaped = value.replaceAll('"', '""');
  if (escaped.contains(',') ||
      escaped.contains('"') ||
      escaped.contains('\n') ||
      escaped.contains('\r')) {
    return '"$escaped"';
  }
  return escaped;
}

String _markdownCell(String value) {
  return value.replaceAll('|', r'\|').replaceAll('\n', ' ');
}
