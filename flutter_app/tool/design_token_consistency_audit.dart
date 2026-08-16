import 'dart:io';

const String _generatedDate = '2026-06-12';

const Set<String> _additionalRootPagePaths = <String>{
  'lib/features/admin/presentation/phone/pages/ab_test_dashboard_page.dart',
  'lib/features/admin/presentation/phone/pages/admin_home_page.dart',
  'lib/features/admin/presentation/phone/pages/analytics_dashboard_page.dart',
  'lib/features/admin/presentation/phone/pages/funnel_dashboard_page.dart',
  'lib/features/dev/presentation/phone/pages/performance_monitor.dart',
  'lib/features/cross_module/presentation/phone/pages/cross_module_analytics_page.dart',
  'lib/features/cross_module/presentation/phone/pages/smart_alert_center_page.dart',
  'lib/features/cross_module/presentation/phone/pages/tax_report_center_page.dart',
  'lib/features/cross_module/presentation/phone/pages/unified_portfolio_dashboard_page.dart',
  'lib/features/onboarding/presentation/phone/pages/onboarding_flow_page.dart',
  'lib/features/trade_copy/presentation/phone/pages/hub/copy_trading_card_demo.dart',
};

const Map<String, int> _p0ModuleDebtBaselines = <String, int>{
  'markets': 2042,
  'p2p': 1911,
  'profile': 1037,
  'trade_bots': 0,
  'trade_compliance': 0,
  'trade_copy': 0,
  'trade_core': 3,
  'trade_terminal': 6,
  'wallet': 759,
};

final class TokenAuditFileMetric {
  const TokenAuditFileMetric({
    required this.scope,
    required this.bundle,
    required this.path,
    required this.fontSizeCount,
    required this.fontFamilyCount,
    required this.weightCount,
    required this.nearOneHeightCount,
    required this.edgeInsetsCount,
    required this.sizedBoxDimensionCount,
    required this.borderRadiusCount,
    required this.radiusCount,
    required this.containerCount,
    required this.boxDecorationCount,
    required this.crossAxisCountCount,
    required this.childAspectRatioCount,
    required this.mainAxisExtentCount,
    required this.fixedWidthCount,
    required this.fixedHeightCount,
    required this.isException,
    required this.exceptionReason,
  });

  final String scope;
  final String bundle;
  final String path;
  final int fontSizeCount;
  final int fontFamilyCount;
  final int weightCount;
  final int nearOneHeightCount;
  final int edgeInsetsCount;
  final int sizedBoxDimensionCount;
  final int borderRadiusCount;
  final int radiusCount;
  final int containerCount;
  final int boxDecorationCount;
  final int crossAxisCountCount;
  final int childAspectRatioCount;
  final int mainAxisExtentCount;
  final int fixedWidthCount;
  final int fixedHeightCount;
  final bool isException;
  final String exceptionReason;

  int get totalDebt =>
      fontSizeCount +
      fontFamilyCount +
      weightCount +
      nearOneHeightCount +
      edgeInsetsCount +
      sizedBoxDimensionCount +
      borderRadiusCount +
      radiusCount +
      containerCount +
      boxDecorationCount +
      crossAxisCountCount +
      childAspectRatioCount +
      mainAxisExtentCount +
      fixedWidthCount +
      fixedHeightCount;

  String get status {
    if (isException) return 'exception';
    if (totalDebt == 0) return 'pass';
    return totalDebt <= 4 ? 'warn' : 'fail';
  }

  TokenAuditFileMetric copyWith({required String bundle}) {
    return TokenAuditFileMetric(
      scope: scope,
      bundle: bundle,
      path: path,
      fontSizeCount: fontSizeCount,
      fontFamilyCount: fontFamilyCount,
      weightCount: weightCount,
      nearOneHeightCount: nearOneHeightCount,
      edgeInsetsCount: edgeInsetsCount,
      sizedBoxDimensionCount: sizedBoxDimensionCount,
      borderRadiusCount: borderRadiusCount,
      radiusCount: radiusCount,
      containerCount: containerCount,
      boxDecorationCount: boxDecorationCount,
      crossAxisCountCount: crossAxisCountCount,
      childAspectRatioCount: childAspectRatioCount,
      mainAxisExtentCount: mainAxisExtentCount,
      fixedWidthCount: fixedWidthCount,
      fixedHeightCount: fixedHeightCount,
      isException: isException,
      exceptionReason: exceptionReason,
    );
  }
}

final class TypographyModuleMetric {
  const TypographyModuleMetric({
    required this.module,
    required this.fontSizeCount,
    required this.fontFamilyCount,
    required this.weightCount,
  });

  final String module;
  final int fontSizeCount;
  final int fontFamilyCount;
  final int weightCount;

  int get total => fontSizeCount + fontFamilyCount + weightCount;

  TypographyModuleMetric add(TokenAuditFileMetric metric) {
    return TypographyModuleMetric(
      module: module,
      fontSizeCount: fontSizeCount + metric.fontSizeCount,
      fontFamilyCount: fontFamilyCount + metric.fontFamilyCount,
      weightCount: weightCount + metric.weightCount,
    );
  }
}

void main(List<String> args) {
  final checkOnly = args.contains('--check');
  final appRoot = _findAppRoot();
  final repoRoot = appRoot.uri.resolve('..').toFilePath();
  final docsDir = Directory('$repoRoot/docs/02_FLUTTER_MIGRATION');
  final markdownFile = File(
    '${docsDir.path}/audits/VitTrade-Design-Token-Consistency-Audit.md',
  );
  final csvFile = File(
    '${docsDir.path}/audits/VitTrade-Design-Token-Consistency-Audit.csv',
  );

  final metrics = _collectMetrics(appRoot, repoRoot);
  final markdown = _renderMarkdown(metrics);
  final csv = _renderCsv(metrics);

  if (checkOnly) {
    final failures = <String>[];
    if (!markdownFile.existsSync()) {
      failures.add(
        'Missing token consistency markdown artifact: ${markdownFile.path}',
      );
    } else if (_normalizeLineEndings(markdownFile.readAsStringSync()) !=
        _normalizeLineEndings(markdown)) {
      failures.add('Token consistency markdown artifact is stale.');
    }
    if (!csvFile.existsSync()) {
      failures.add('Missing token consistency CSV artifact: ${csvFile.path}');
    } else if (_normalizeLineEndings(csvFile.readAsStringSync()) !=
        _normalizeLineEndings(csv)) {
      failures.add('Token consistency CSV artifact is stale.');
      // In dòng khác biệt đầu tiên để log CI tự chỉ chỗ (khỏi đoán cross-OS).
      final oldLines = _normalizeLineEndings(
        csvFile.readAsStringSync(),
      ).split('\n');
      final newLines = _normalizeLineEndings(csv).split('\n');
      for (var i = 0; i < oldLines.length || i < newLines.length; i++) {
        final oldLine = i < oldLines.length ? oldLines[i] : '<missing>';
        final newLine = i < newLines.length ? newLines[i] : '<missing>';
        if (oldLine != newLine) {
          failures.add('First CSV diff at line ${i + 1}:');
          failures.add('  committed: $oldLine');
          failures.add('  generated: $newLine');
          break;
        }
      }
    }
    failures.addAll(_collectP0ModuleGateFailures(metrics));
    failures.addAll(_collectStrictTypographyGateFailures(appRoot, repoRoot));

    if (failures.isNotEmpty) {
      for (final failure in failures) {
        stderr.writeln(failure);
      }
      stderr.writeln(
        'Run `dart run tool/design_token_consistency_audit.dart` from flutter_app/.',
      );
      exitCode = 1;
      return;
    }

    stdout.writeln('Token consistency artifacts are current.');
    stdout.writeln(_renderSummary(metrics));
    stdout.writeln(_renderP0ModuleGateSummary(metrics));
    stdout.writeln(_renderStrictTypographyGateSummary(appRoot, repoRoot));
    return;
  }

  docsDir.createSync(recursive: true);
  markdownFile.writeAsStringSync(markdown);
  csvFile.writeAsStringSync(csv);
  stdout.writeln('Wrote ${markdownFile.path}');
  stdout.writeln('Wrote ${csvFile.path}');
  stdout.writeln(_renderSummary(metrics));
}

// Windows checkouts of this repo (core.autocrlf=true) materialize tracked
// files with CRLF line endings, while this tool always writes LF. Comparing
// raw bytes would then report staleness on every checkout even though the
// content is unchanged, so both sides are normalized before comparing.
String _normalizeLineEndings(String value) => value.replaceAll('\r\n', '\n');

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

List<TokenAuditFileMetric> _collectMetrics(Directory appRoot, String repoRoot) {
  final rootPages = _collectRootPages(appRoot);
  final featureWidgets = _collectFeatureWidgets(appRoot);
  final sharedWidgets = _collectSharedFiles(appRoot, 'shared/widgets');
  final sharedLayout = _collectSharedFiles(appRoot, 'shared/layout');

  final reports = <TokenAuditFileMetric>[];

  for (final pageFile in rootPages) {
    final bundleFiles = _collectBundleFiles(pageFile);
    var bundleMetric = _emptyBundleMetric();
    final bundleName = _relativePath(pageFile.path, repoRoot);

    for (final file in bundleFiles) {
      final metric = _analyzeFile(file, repoRoot);
      if (metric == null) continue;
      reports.add(metric.copyWith(bundle: bundleName));
      bundleMetric = _addMetrics(bundleMetric, metric);
    }

    reports.add(
      TokenAuditFileMetric(
        scope: 'root_page_bundle_summary',
        bundle: bundleName,
        path: '${bundleFiles.length} files',
        fontSizeCount: bundleMetric.fontSizeCount,
        fontFamilyCount: bundleMetric.fontFamilyCount,
        weightCount: bundleMetric.weightCount,
        nearOneHeightCount: bundleMetric.nearOneHeightCount,
        edgeInsetsCount: bundleMetric.edgeInsetsCount,
        sizedBoxDimensionCount: bundleMetric.sizedBoxDimensionCount,
        borderRadiusCount: bundleMetric.borderRadiusCount,
        radiusCount: bundleMetric.radiusCount,
        containerCount: bundleMetric.containerCount,
        boxDecorationCount: bundleMetric.boxDecorationCount,
        crossAxisCountCount: bundleMetric.crossAxisCountCount,
        childAspectRatioCount: bundleMetric.childAspectRatioCount,
        mainAxisExtentCount: bundleMetric.mainAxisExtentCount,
        fixedWidthCount: bundleMetric.fixedWidthCount,
        fixedHeightCount: bundleMetric.fixedHeightCount,
        isException: bundleMetric.isException,
        exceptionReason: bundleMetric.exceptionReason,
      ),
    );
  }

  for (final file in featureWidgets) {
    final metric = _analyzeFile(file, repoRoot);
    if (metric != null) reports.add(metric);
  }
  for (final file in [...sharedWidgets, ...sharedLayout]) {
    final metric = _analyzeFile(file, repoRoot);
    if (metric != null) reports.add(metric);
  }

  reports.sort((a, b) {
    final scopeCompare = a.scope.compareTo(b.scope);
    if (scopeCompare != 0) return scopeCompare;
    final pathCompare = a.path
        .replaceAll(r'\', '/')
        .compareTo(b.path.replaceAll(r'\', '/'));
    if (pathCompare != 0) return pathCompare;
    // Tiebreak BẮT BUỘC: cùng widget path xuất hiện 2 row (bundle theo page
    // và bundle rỗng) — List.sort của Dart KHÔNG stable nên thiếu khóa phụ
    // thì thứ tự tie trôi theo thứ tự listSync của từng OS.
    return a.bundle
        .replaceAll(r'\', '/')
        .compareTo(b.bundle.replaceAll(r'\', '/'));
  });
  return reports;
}

List<File> _collectRootPages(Directory appRoot) {
  final pages = <File>[];
  final featuresDir = Directory('${appRoot.path}/lib/features');
  if (!featuresDir.existsSync()) return pages;

  final candidates =
      featuresDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => _isAuditedRootPage(file, appRoot))
          .toList()
        ..sort(
          (a, b) => a.path
              .replaceAll(r'\', '/')
              .compareTo(b.path.replaceAll(r'\', '/')),
        );

  final visited = <String>{};
  for (final file in candidates) {
    final key = file.path.toLowerCase();
    if (!visited.add(key)) continue;
    pages.add(file);
  }
  return pages;
}

bool _isAuditedRootPage(File file, Directory appRoot) {
  final normalizedPath = file.path.replaceAll('\\', '/');
  if (!normalizedPath.contains('/presentation/pages/')) return false;
  if (normalizedPath.endsWith('_page.dart')) return true;

  final relativePath = _relativePath(
    file.path,
    appRoot.path,
  ).replaceFirst(RegExp(r'^/+'), '');
  return _additionalRootPagePaths.contains(relativePath);
}

List<File> _collectFeatureWidgets(Directory appRoot) {
  final widgetsDir = Directory('${appRoot.path}/lib/features');
  if (!widgetsDir.existsSync()) return const [];
  return widgetsDir
      .listSync(recursive: true)
      .whereType<File>()
      .where(
        (file) =>
            file.path.endsWith('.dart') &&
            file.path
                .replaceAll('\\', '/')
                .contains('/presentation/widgets/') &&
            !file.path.contains('.g.dart'),
      )
      .toList()
    ..sort(
      (a, b) =>
          a.path.replaceAll(r'\', '/').compareTo(b.path.replaceAll(r'\', '/')),
    );
}

List<File> _collectSharedFiles(Directory appRoot, String folder) {
  final sharedDir = Directory('${appRoot.path}/lib/$folder');
  if (!sharedDir.existsSync()) return const [];
  return sharedDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .toList()
    ..sort(
      (a, b) =>
          a.path.replaceAll(r'\', '/').compareTo(b.path.replaceAll(r'\', '/')),
    );
}

List<File> _collectBundleFiles(File rootPageFile) {
  final queue = <File>[rootPageFile];
  final visited = <String>{};
  final files = <File>[];

  while (queue.isNotEmpty) {
    final file = queue.removeAt(0);
    final key = file.path.toLowerCase();
    if (!visited.add(key)) continue;
    if (!file.existsSync()) continue;
    files.add(file);

    final source = file.readAsStringSync();
    for (final match in _partPattern.allMatches(source)) {
      final uri = match.group(1)!;
      queue.add(File(file.uri.resolve(uri).toFilePath()));
    }
  }

  files.sort(
    (a, b) =>
        a.path.replaceAll(r'\', '/').compareTo(b.path.replaceAll(r'\', '/')),
  );
  return files;
}

TokenAuditFileMetric _emptyBundleMetric() => const TokenAuditFileMetric(
  scope: 'bundle',
  bundle: '',
  path: '',
  fontSizeCount: 0,
  fontFamilyCount: 0,
  weightCount: 0,
  nearOneHeightCount: 0,
  edgeInsetsCount: 0,
  sizedBoxDimensionCount: 0,
  borderRadiusCount: 0,
  radiusCount: 0,
  containerCount: 0,
  boxDecorationCount: 0,
  crossAxisCountCount: 0,
  childAspectRatioCount: 0,
  mainAxisExtentCount: 0,
  fixedWidthCount: 0,
  fixedHeightCount: 0,
  isException: false,
  exceptionReason: '-',
);

TokenAuditFileMetric _addMetrics(
  TokenAuditFileMetric a,
  TokenAuditFileMetric b,
) {
  return TokenAuditFileMetric(
    scope: a.scope,
    bundle: a.bundle,
    path: a.path,
    fontSizeCount: a.fontSizeCount + b.fontSizeCount,
    fontFamilyCount: a.fontFamilyCount + b.fontFamilyCount,
    weightCount: a.weightCount + b.weightCount,
    nearOneHeightCount: a.nearOneHeightCount + b.nearOneHeightCount,
    edgeInsetsCount: a.edgeInsetsCount + b.edgeInsetsCount,
    sizedBoxDimensionCount: a.sizedBoxDimensionCount + b.sizedBoxDimensionCount,
    borderRadiusCount: a.borderRadiusCount + b.borderRadiusCount,
    radiusCount: a.radiusCount + b.radiusCount,
    containerCount: a.containerCount + b.containerCount,
    boxDecorationCount: a.boxDecorationCount + b.boxDecorationCount,
    crossAxisCountCount: a.crossAxisCountCount + b.crossAxisCountCount,
    childAspectRatioCount: a.childAspectRatioCount + b.childAspectRatioCount,
    mainAxisExtentCount: a.mainAxisExtentCount + b.mainAxisExtentCount,
    fixedWidthCount: a.fixedWidthCount + b.fixedWidthCount,
    fixedHeightCount: a.fixedHeightCount + b.fixedHeightCount,
    isException: a.isException || b.isException,
    exceptionReason: a.isException ? a.exceptionReason : b.exceptionReason,
  );
}

TokenAuditFileMetric? _analyzeFile(File file, String repoRoot) {
  if (!file.existsSync()) return null;
  final source = file.readAsStringSync();
  final path = _relativePath(file.path, repoRoot);
  final normalized = path.toLowerCase();
  final lowerSource = source.toLowerCase();
  final exception = _detectException(normalized, lowerSource);
  final scope = normalized.startsWith('flutter_app/lib/shared/layout/')
      ? 'shared_layout'
      : normalized.startsWith('flutter_app/lib/shared/widgets/')
      ? 'shared_widget'
      : normalized.contains('/presentation/widgets/')
      ? 'feature_widget'
      : 'root_page';

  return TokenAuditFileMetric(
    scope: scope,
    bundle: '',
    path: path,
    fontSizeCount: _countPattern(source, _fontSizePattern),
    fontFamilyCount: _countPattern(source, _fontFamilyPattern),
    weightCount: _countPattern(source, _heavyWeightPattern),
    nearOneHeightCount: _countNearOneHeight(source),
    edgeInsetsCount: _countPattern(source, _edgeInsetsPattern),
    sizedBoxDimensionCount: _countPattern(source, _sizedBoxDimensionPattern),
    borderRadiusCount: _countPattern(source, _borderRadiusPattern),
    radiusCount: _countPattern(source, _radiusPattern),
    containerCount: _countPattern(source, _containerPattern),
    boxDecorationCount: _countPattern(source, _boxDecorationPattern),
    crossAxisCountCount: _countPattern(source, _crossAxisCountPattern),
    childAspectRatioCount: _countPattern(source, _childAspectRatioPattern),
    mainAxisExtentCount: _countPattern(source, _mainAxisExtentPattern),
    fixedWidthCount: _countDimensionBeyondThreshold(source, 'width', 320),
    fixedHeightCount: _countDimensionBeyondThreshold(source, 'height', 56),
    isException: exception != null,
    exceptionReason: exception ?? '-',
  );
}

String? _detectException(String path, String lowerSource) {
  for (final entry in _exceptionPathPatterns) {
    if (path.contains(entry)) return 'allowed_path_exception: $entry';
  }
  for (final keyword in _exceptionKeywords) {
    if (lowerSource.contains(keyword)) {
      return 'allowed_source_keyword: $keyword';
    }
  }
  return null;
}

List<String> _collectP0ModuleGateFailures(List<TokenAuditFileMetric> metrics) {
  final moduleDebts = _collectP0ModuleDebts(metrics);
  final failures = <String>[];
  for (final entry in _p0ModuleDebtBaselines.entries) {
    final current = moduleDebts[entry.key] ?? 0;
    if (current > entry.value) {
      failures.add(
        'P0 module token debt increased for ${entry.key}: '
        '$current > baseline ${entry.value}.',
      );
    }
  }
  return failures;
}

List<String> _collectStrictTypographyGateFailures(
  Directory appRoot,
  String repoRoot,
) {
  final residuals = _collectStrictTypographyResiduals(appRoot, repoRoot);
  if (residuals.isEmpty) return const [];

  final shown = residuals
      .take(20)
      .map((residual) => '  - $residual')
      .join('\n');
  final hidden = residuals.length > 20
      ? '\n  ... ${residuals.length - 20} more'
      : '';
  return [
    'Strict typography gate failed: ${residuals.length} residual(s) outside '
        'lib/app/theme/**.\n$shown$hidden',
  ];
}

List<String> _collectStrictTypographyResiduals(
  Directory appRoot,
  String repoRoot,
) {
  final libDir = Directory('${appRoot.path}/lib');
  if (!libDir.existsSync()) return const [];

  final residuals = <String>[];
  for (final entity in libDir.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;

    final path = _relativePath(entity.path, repoRoot).replaceAll('\\', '/');
    if (path.startsWith('flutter_app/lib/app/theme/')) continue;

    final source = entity.readAsStringSync();
    for (final entry in _strictTypographyGatePatterns.entries) {
      for (final match in entry.value.allMatches(source)) {
        final line = _lineForOffset(source, match.start);
        residuals.add('$path:$line ${entry.key}');
      }
    }
  }

  residuals.sort();
  return residuals;
}

Map<String, int> _collectP0ModuleDebts(List<TokenAuditFileMetric> metrics) {
  final moduleDebts = <String, int>{};
  for (final metric in metrics) {
    if (metric.scope != 'root_page' && metric.scope != 'feature_widget') {
      continue;
    }
    final feature = _featureNameForPath(metric.path);
    if (feature == null || !_p0ModuleDebtBaselines.containsKey(feature)) {
      continue;
    }
    moduleDebts.update(
      feature,
      (value) => value + metric.totalDebt,
      ifAbsent: () => metric.totalDebt,
    );
  }
  return moduleDebts;
}

List<TypographyModuleMetric> _collectTypographyModuleSummaries(
  List<TokenAuditFileMetric> metrics,
) {
  final summaries = <String, TypographyModuleMetric>{};
  for (final metric in metrics) {
    if (!_isFileMetricScope(metric.scope)) continue;
    final module = _moduleNameForPath(metric.path);
    if (module == null) continue;

    final current =
        summaries[module] ??
        TypographyModuleMetric(
          module: module,
          fontSizeCount: 0,
          fontFamilyCount: 0,
          weightCount: 0,
        );
    summaries[module] = current.add(metric);
  }

  return summaries.values.toList()..sort((a, b) {
    final totalCompare = b.total.compareTo(a.total);
    if (totalCompare != 0) return totalCompare;
    return a.module.compareTo(b.module);
  });
}

bool _isFileMetricScope(String scope) {
  return scope == 'root_page' ||
      scope == 'feature_widget' ||
      scope == 'shared_layout' ||
      scope == 'shared_widget';
}

String? _moduleNameForPath(String path) {
  final feature = _featureNameForPath(path);
  if (feature != null) return feature;
  if (path.startsWith('flutter_app/lib/shared/layout/')) {
    return 'shared/layout';
  }
  if (path.startsWith('flutter_app/lib/shared/widgets/')) {
    return 'shared/widgets';
  }
  return null;
}

String _summaryKey(String value) {
  return value.replaceAll(RegExp(r'[^a-zA-Z0-9]+'), '_').toLowerCase();
}

String? _featureNameForPath(String path) {
  const prefix = 'flutter_app/lib/features/';
  if (!path.startsWith(prefix)) return null;
  final rest = path.substring(prefix.length);
  final slashIndex = rest.indexOf('/');
  if (slashIndex <= 0) return null;
  return rest.substring(0, slashIndex);
}

String _renderP0ModuleGateSummary(List<TokenAuditFileMetric> metrics) {
  final moduleDebts = _collectP0ModuleDebts(metrics);
  final buffer = StringBuffer()..writeln('p0_module_gate=baseline_enforced');
  for (final entry in _p0ModuleDebtBaselines.entries) {
    final current = moduleDebts[entry.key] ?? 0;
    final status = current <= entry.value ? 'pass' : 'fail';
    buffer.writeln('p0_${entry.key}_debt=$current/${entry.value} $status');
  }
  return buffer.toString();
}

String _renderStrictTypographyGateSummary(Directory appRoot, String repoRoot) {
  final residuals = _collectStrictTypographyResiduals(appRoot, repoRoot);
  final status = residuals.isEmpty ? 'pass' : 'fail';
  return 'strict_typography_gate=zero_residual $status residuals=${residuals.length}';
}

String _renderSummary(List<TokenAuditFileMetric> metrics) {
  final scopeTotals = <String, int>{};
  final typographySummaries = _collectTypographyModuleSummaries(metrics);
  var totalFiles = 0;
  var debtTotal = 0;
  var exceptions = 0;
  for (final metric in metrics) {
    totalFiles += 1;
    debtTotal += metric.totalDebt;
    scopeTotals.update(
      metric.scope,
      (value) => value + metric.totalDebt,
      ifAbsent: () => metric.totalDebt,
    );
    if (metric.isException) exceptions += 1;
  }
  final buffer = StringBuffer()
    ..writeln('generated=$_generatedDate')
    ..writeln('total_files=$totalFiles')
    ..writeln('total_debt=$debtTotal')
    ..writeln('exceptions=$exceptions');
  for (final entry in scopeTotals.entries) {
    buffer.writeln('scope_${entry.key}_debt=${entry.value}');
  }
  final moduleDebts = _collectP0ModuleDebts(metrics);
  for (final entry in _p0ModuleDebtBaselines.entries) {
    buffer.writeln('p0_${entry.key}_debt=${moduleDebts[entry.key] ?? 0}');
  }
  for (final summary in typographySummaries) {
    buffer.writeln(
      'typography_${_summaryKey(summary.module)}_debt=${summary.total} '
      'fontSize=${summary.fontSizeCount} '
      'fontFamily=${summary.fontFamilyCount} '
      'w800w900=${summary.weightCount}',
    );
  }
  return buffer.toString();
}

String _renderMarkdown(List<TokenAuditFileMetric> metrics) {
  final topDebt = metrics.where((metric) => !metric.isException).toList()
    ..sort((a, b) => b.totalDebt.compareTo(a.totalDebt));
  final p0ModuleDebts = _collectP0ModuleDebts(metrics);
  final typographySummaries = _collectTypographyModuleSummaries(metrics);

  final failCount = metrics.where((metric) => metric.status == 'fail').length;
  final warnCount = metrics.where((metric) => metric.status == 'warn').length;
  final exceptionCount = metrics.where((metric) => metric.isException).length;

  final buffer = StringBuffer()
    ..writeln('# VitTrade Design Token Consistency Audit')
    ..writeln()
    ..writeln('Generated: $_generatedDate')
    ..writeln()
    ..writeln(
      'Generated from `flutter_app/tool/design_token_consistency_audit.dart`.',
    )
    ..writeln()
    ..writeln('## Inputs')
    ..writeln()
    ..writeln(
      '- Root pages: `lib/features/*/presentation/pages/*_page.dart` plus audited route-screen exceptions (+ part files).',
    )
    ..writeln(
      '- Feature widgets: `lib/features/*/presentation/widgets/*.dart`.',
    )
    ..writeln('- Shared files: `lib/shared/widgets` and `lib/shared/layout`.')
    ..writeln()
    ..writeln('## Summary')
    ..writeln('```text')
    ..writeln('generated=$_generatedDate')
    ..writeln('status_fail=$failCount')
    ..writeln('status_warn=$warnCount')
    ..writeln('status_exception=$exceptionCount')
    ..writeln('rows=${metrics.length}')
    ..writeln('```')
    ..writeln()
    ..writeln('## CI Baseline Gates')
    ..writeln()
    ..writeln(
      'Global debt is report-only while the migration baseline is still being reduced. '
      'P0 financial modules are enforced against the post-tokenization baseline below.',
    )
    ..writeln()
    ..writeln('| module | current debt | max baseline | status |')
    ..writeln('| --- | ---: | ---: | --- |');
  for (final entry in _p0ModuleDebtBaselines.entries) {
    final current = p0ModuleDebts[entry.key] ?? 0;
    final status = current <= entry.value ? 'pass' : 'fail';
    buffer.writeln('| ${entry.key} | $current | ${entry.value} | $status |');
  }

  buffer
    ..writeln()
    ..writeln('## Typography Debt By Module')
    ..writeln()
    ..writeln(
      'This section counts only local typography drift: `fontSize`, '
      '`fontFamily`, and `FontWeight.w800/w900`. Bundle summary rows are '
      'excluded to avoid double-counting root page part files.',
    )
    ..writeln()
    ..writeln(
      '| module | total typography debt | fontSize | fontFamily | w800/w900 |',
    )
    ..writeln('| --- | ---: | ---: | ---: | ---: |');
  for (final summary in typographySummaries) {
    buffer.writeln(
      '| ${summary.module} | ${summary.total} | ${summary.fontSizeCount} | '
      '${summary.fontFamilyCount} | ${summary.weightCount} |',
    );
  }

  buffer
    ..writeln()
    ..writeln('## Top Debt Files (non-exception)')
    ..writeln(
      '| scope | bundle | path | status | total | fontSize | fontFamily | w800/w900 | near1Height | edgeInsets | sizedBox | borderRadius | radius | container | decoration | gridCount | fixedWH | exception |',
    )
    ..writeln(
      '| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |',
    );

  for (final metric in topDebt.take(120)) {
    final rowCount =
        metric.crossAxisCountCount +
        metric.childAspectRatioCount +
        metric.mainAxisExtentCount;
    final fixedCount = metric.fixedWidthCount + metric.fixedHeightCount;
    buffer.writeln(
      '| ${metric.scope} | `${metric.bundle}` | `${metric.path}` | ${metric.status} | '
      '${metric.totalDebt} | ${metric.fontSizeCount} | ${metric.fontFamilyCount} | '
      '${metric.weightCount} | ${metric.nearOneHeightCount} | ${metric.edgeInsetsCount} | '
      '${metric.sizedBoxDimensionCount} | ${metric.borderRadiusCount} | '
      '${metric.radiusCount} | ${metric.containerCount} | ${metric.boxDecorationCount} | '
      '$rowCount | $fixedCount | ${metric.exceptionReason} |',
    );
  }

  buffer
    ..writeln()
    ..writeln('## Report File Matrix')
    ..writeln(
      '| scope | bundle | path | status | fontSize | fontFamily | w800/w900 | height~1 | edgeInsets | sizedBox | borderRadius | radius | container | decoration | crossAxisCount | childAspectRatio | mainAxisExtent | fixedWidth | fixedHeight | exception |',
    )
    ..writeln(
      '| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |',
    );
  for (final metric in metrics) {
    buffer.writeln(
      '| ${metric.scope} | `${metric.bundle}` | `${metric.path}` | ${metric.status} | '
      '${metric.fontSizeCount} | ${metric.fontFamilyCount} | ${metric.weightCount} | '
      '${metric.nearOneHeightCount} | ${metric.edgeInsetsCount} | '
      '${metric.sizedBoxDimensionCount} | ${metric.borderRadiusCount} | '
      '${metric.radiusCount} | ${metric.containerCount} | '
      '${metric.boxDecorationCount} | ${metric.crossAxisCountCount} | '
      '${metric.childAspectRatioCount} | ${metric.mainAxisExtentCount} | '
      '${metric.fixedWidthCount} | ${metric.fixedHeightCount} | ${metric.exceptionReason} |',
    );
  }

  buffer
    ..writeln()
    ..writeln('## Verification Commands')
    ..writeln('```bash')
    ..writeln('cd flutter_app')
    ..writeln('dart run tool/design_token_consistency_audit.dart')
    ..writeln('dart run tool/design_token_consistency_audit.dart --check')
    ..writeln('```');
  return buffer.toString();
}

String _renderCsv(List<TokenAuditFileMetric> metrics) {
  final buffer = StringBuffer()
    ..writeln(
      [
        'scope',
        'bundle',
        'path',
        'status',
        'fontSize',
        'fontFamily',
        'w800w900',
        'heightNearOne',
        'edgeInsets',
        'sizedBoxDimensions',
        'borderRadius',
        'radius',
        'container',
        'boxDecoration',
        'crossAxisCount',
        'childAspectRatio',
        'mainAxisExtent',
        'fixedWidth',
        'fixedHeight',
        'totalDebt',
        'exception',
        'exceptionReason',
      ].map(_csvEscape).join(','),
    );
  for (final metric in metrics) {
    buffer.writeln(
      [
        metric.scope,
        metric.bundle,
        metric.path,
        metric.status,
        '${metric.fontSizeCount}',
        '${metric.fontFamilyCount}',
        '${metric.weightCount}',
        '${metric.nearOneHeightCount}',
        '${metric.edgeInsetsCount}',
        '${metric.sizedBoxDimensionCount}',
        '${metric.borderRadiusCount}',
        '${metric.radiusCount}',
        '${metric.containerCount}',
        '${metric.boxDecorationCount}',
        '${metric.crossAxisCountCount}',
        '${metric.childAspectRatioCount}',
        '${metric.mainAxisExtentCount}',
        '${metric.fixedWidthCount}',
        '${metric.fixedHeightCount}',
        '${metric.totalDebt}',
        metric.isException ? 'yes' : 'no',
        metric.exceptionReason,
      ].map(_csvEscape).join(','),
    );
  }
  return buffer.toString();
}

int _countPattern(String source, RegExp pattern) =>
    pattern.allMatches(source).length;

int _countNearOneHeight(String source) {
  var count = 0;
  for (final match in _heightPattern.allMatches(source)) {
    final value = double.tryParse(match.group(1)!) ?? 0;
    if (value >= 0.85 && value <= 1.2) count += 1;
  }
  return count;
}

int _countDimensionBeyondThreshold(
  String source,
  String dimension,
  double threshold,
) {
  final pattern = dimension == 'width'
      ? _widthPattern
      : _heightPatternForDimension;
  var count = 0;
  for (final match in pattern.allMatches(source)) {
    final value = double.tryParse(match.group(1)!.replaceAll(',', '')) ?? 0;
    if (value >= threshold) count += 1;
  }
  return count;
}

int _lineForOffset(String source, int offset) {
  var line = 1;
  for (var i = 0; i < offset && i < source.length; i += 1) {
    if (source.codeUnitAt(i) == 10) line += 1;
  }
  return line;
}

String _relativePath(String filePath, String repoRoot) {
  final root = repoRoot.replaceAll('\\', '/');
  final path = filePath.replaceAll('\\', '/');
  if (path.startsWith(root)) return path.substring(root.length);
  final flutterApp = '/flutter_app/';
  final idx = path.indexOf(flutterApp);
  if (idx >= 0) return path.substring(idx + 1);
  return path;
}

String _csvEscape(String value) {
  final escaped = value.replaceAll('"', '""');
  if (escaped.contains(',') || escaped.contains('"')) {
    return '"$escaped"';
  }
  return escaped;
}

final RegExp _partPattern = RegExp(r'''part\s+['"]([^'"]+)['"]''');

final RegExp _fontSizePattern = RegExp(r'fontSize:\s*([0-9]+(?:\.[0-9]+)?)');
final RegExp _fontFamilyPattern = RegExp(r'fontFamily:');
final RegExp _heavyWeightPattern = RegExp(r'FontWeight\.w[89]00');
final Map<String, RegExp> _strictTypographyGatePatterns = <String, RegExp>{
  'local fontSize parameter': RegExp(r'\bfontSize\s*:'),
  'local TextStyle': RegExp(r'TextStyle\('),
  'local fontFamily': RegExp(r'fontFamily:'),
  'direct heavy FontWeight': RegExp(r'FontWeight\.w[89]00'),
};
final RegExp _heightPattern = RegExp(r'height:\s*([0-9]+(?:\.[0-9]+)?)');
final RegExp _edgeInsetsPattern = RegExp(
  r'EdgeInsets\.(all|symmetric|only|fromLTRB)\(',
);
final RegExp _sizedBoxDimensionPattern = RegExp(
  r'SizedBox\((?:(?!\)).)*(?:width|height):\s*([0-9]+(?:\.[0-9]+)?)',
  dotAll: true,
);
final RegExp _borderRadiusPattern = RegExp(r'BorderRadius\.circular\(');
final RegExp _radiusPattern = RegExp(r'Radius\.circular\(');
final RegExp _containerPattern = RegExp(r'Container\(');
final RegExp _boxDecorationPattern = RegExp(r'BoxDecoration\(');
final RegExp _crossAxisCountPattern = RegExp(r'crossAxisCount:\s*\d+');
final RegExp _childAspectRatioPattern = RegExp(
  r'childAspectRatio:\s*([0-9]+(?:\.[0-9]+)?)',
);
final RegExp _mainAxisExtentPattern = RegExp(
  r'mainAxisExtent:\s*([0-9]+(?:\.[0-9]+)?)',
);
final RegExp _widthPattern = RegExp(r'width:\s*([0-9]+(?:\.[0-9]+)?)');
final RegExp _heightPatternForDimension = RegExp(
  r'height:\s*([0-9]+(?:\.[0-9]+)?)',
);

final List<String> _exceptionPathPatterns = <String>[
  '/dev/',
  '/internal/',
  '/visual',
  '/chart',
  '/charts',
  '/canvas',
];
final List<String> _exceptionKeywords = <String>[
  'custompainter',
  'extends custompainter',
  'trade chart',
  'orderbook',
  'candlestick',
  'order_book',
];
