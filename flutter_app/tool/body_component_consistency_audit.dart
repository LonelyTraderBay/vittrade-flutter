import 'dart:io';

final class BodyRouteEntry {
  const BodyRouteEntry({
    required this.feature,
    required this.route,
    required this.pageClass,
    required this.pageFile,
    required this.screenLevel,
    required this.archetype,
    required this.bodyGrade,
    required this.issuePriority,
    required this.layoutStatus,
    required this.surfaceStatus,
    required this.controlsStatus,
    required this.stateStatus,
    required this.financialSafetyStatus,
    required this.responsiveStatus,
    required this.copyBoundaryStatus,
    required this.sharedComponentCount,
    required this.customBodyCount,
    required this.fixedSizeCount,
    required this.localFontCount,
    required this.sourceFileCount,
    required this.primaryIssue,
    required this.recommendedAction,
    required this.testScope,
    required this.sourceFiles,
  });

  final String feature;
  final String route;
  final String pageClass;
  final String pageFile;
  final String screenLevel;
  final String archetype;
  final String bodyGrade;
  final String issuePriority;
  final String layoutStatus;
  final String surfaceStatus;
  final String controlsStatus;
  final String stateStatus;
  final String financialSafetyStatus;
  final String responsiveStatus;
  final String copyBoundaryStatus;
  final int sharedComponentCount;
  final int customBodyCount;
  final int fixedSizeCount;
  final int localFontCount;
  final int sourceFileCount;
  final String primaryIssue;
  final String recommendedAction;
  final String testScope;
  final List<String> sourceFiles;

  bool get isDGrade => bodyGrade == 'D';

  bool get isCGrade => bodyGrade == 'C';

  bool get isTool => bodyGrade == 'Tool';

  bool get needsManualReview =>
      isCGrade ||
      isDGrade ||
      isTool ||
      financialSafetyStatus == 'warn' ||
      financialSafetyStatus == 'fail' ||
      copyBoundaryStatus == 'warn' ||
      copyBoundaryStatus == 'fail';
}

final class RouteInventoryEntry {
  const RouteInventoryEntry({
    required this.feature,
    required this.route,
    required this.pageClass,
    required this.pageFile,
    required this.archetype,
    required this.screenLevel,
  });

  final String feature;
  final String route;
  final String pageClass;
  final String pageFile;
  final String archetype;
  final String screenLevel;
}

final class SourceBundle {
  const SourceBundle({
    required this.source,
    required this.files,
    required this.unresolved,
  });

  final String source;
  final List<String> files;
  final bool unresolved;
}

const _generatedDate = '2026-06-04';

const _sharedPrimitiveTokens = <String>[
  'VitPageLayout',
  'VitAutoHideHeaderScaffold',
  'VitTopChrome',
  'VitHeader',
  'VitPageContent',
  'VitPageSection',
  'VitCard',
  'VitCardStat',
  'VitCtaButton',
  'VitTabBar',
  'VitSearchBar',
  'VitInput',
  'VitEmptyState',
  'VitErrorState',
  'VitOfflineBanner',
  'VitBanner',
  'VitSkeleton',
  'VitHighRiskStatePanel',
  'VitStickyFooter',
  'VitServiceTile',
  'VitModuleHeroCard',
  'VitMetricCard',
  'VitStatusPill',
  'VitModuleSectionHeader',
];

const _customRiskTokens = <String>[
  'Container(',
  'GestureDetector(',
  'TextField(',
  'CustomPaint(',
  'Positioned(',
  'Stack(',
  'SizedBox(height:',
  'fontSize:',
  'fontFamily:',
  'BorderRadius.circular(',
];

const _fullscreenToolPages = <String>{
  'AdvancedChartPage',
  'FuturesPage',
  'P2PChatPage',
  'TradingBotsPage',
  'EnterpriseStatesPage',
};

const _highImpactFeatures = <String>{
  'wallet',
  'trade',
  'profile',
  'p2p',
  'p2p_core',
  'p2p_marketplace',
  'p2p_orders',
  'p2p_account',
  'p2p_security',
  'p2p_dispute',
  'predictions',
  'markets',
  'rewards',
};

const _financialSafetyFeatures = <String>{
  'wallet',
  'trade',
  'p2p',
  'p2p_core',
  'p2p_marketplace',
  'p2p_orders',
  'p2p_account',
  'p2p_security',
  'p2p_dispute',
  'earn',
  'launchpad',
  'dca',
  'profile',
  'predictions',
};

const _financialSafetyKeywords = <String>[
  'withdraw',
  'deposit',
  'address',
  'escrow',
  'paymentmethod',
  'payment_method',
  'payment method',
  'leverage',
  'margin',
  'copy',
  'apikey',
  'api key',
  'security',
  '2fa',
  'kyc',
  'confirm',
  'confirmation',
  'receipt',
  'transfer',
  'redeem',
  'claim',
  'rebalance',
  'automation',
  'approval',
  'device',
  'verification',
  'release',
  'emergency',
];

void main(List<String> args) {
  final checkOnly = args.contains('--check');
  final appRoot = _findAppRoot();
  final repoRoot = appRoot.uri.resolve('..').toFilePath();
  final docsDir = Directory('${repoRoot}docs/02_FLUTTER_MIGRATION');
  final topHeaderFile = File(
    '${docsDir.path}/audits/VitTrade-Top-Header-Visual-Archetype-Audit.md',
  );
  final markdownFile = File(
    '${docsDir.path}/audits/VitTrade-Body-Component-Consistency-Audit.md',
  );
  final csvFile = File(
    '${docsDir.path}/audits/VitTrade-Body-Component-Consistency-Audit.csv',
  );

  final entries = _collectBodyRouteEntries(appRoot, repoRoot, topHeaderFile);
  final markdown = _renderMarkdown(entries);
  final csv = _renderCsv(entries);
  final summary = _renderSummary(entries);

  if (checkOnly) {
    final failures = <String>[];
    if (!markdownFile.existsSync()) {
      failures.add('Body component consistency markdown artifact is missing.');
    } else if (markdownFile.readAsStringSync() != markdown) {
      failures.add('Body component consistency markdown artifact is stale.');
    }

    if (!csvFile.existsSync()) {
      failures.add('Body component consistency CSV artifact is missing.');
    } else if (csvFile.readAsStringSync() != csv) {
      failures.add('Body component consistency CSV artifact is stale.');
    }

    if (failures.isNotEmpty) {
      for (final failure in failures) {
        stderr.writeln(failure);
      }
      stderr.writeln(
        'Run `dart run tool/body_component_consistency_audit.dart` '
        'from flutter_app/.',
      );
      exitCode = 1;
      return;
    }

    stdout.write(summary);
    stdout.writeln('Body component consistency artifacts are current.');
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

List<BodyRouteEntry> _collectBodyRouteEntries(
  Directory appRoot,
  String repoRoot,
  File topHeaderFile,
) {
  final routeEntries = _parseRouteInventory(topHeaderFile);
  return [
    for (final routeEntry in routeEntries)
      _analyzeRouteEntry(
        appRoot: appRoot,
        repoRoot: repoRoot,
        routeEntry: routeEntry,
      ),
  ]..sort((a, b) {
    final featureCompare = a.feature.compareTo(b.feature);
    if (featureCompare != 0) return featureCompare;
    final pageCompare = a.pageFile.compareTo(b.pageFile);
    if (pageCompare != 0) return pageCompare;
    return a.route.compareTo(b.route);
  });
}

List<RouteInventoryEntry> _parseRouteInventory(File topHeaderFile) {
  if (!topHeaderFile.existsSync()) {
    throw StateError(
      'Missing top header visual archetype audit: ${topHeaderFile.path}',
    );
  }

  final entries = <RouteInventoryEntry>[];
  var inInventory = false;

  for (final line in topHeaderFile.readAsLinesSync()) {
    if (line.trim() == '## Route Visual Inventory') {
      inInventory = true;
      continue;
    }
    if (!inInventory) continue;
    if (!line.startsWith('|')) continue;
    if (line.startsWith('| Feature |') || line.startsWith('| --- |')) {
      continue;
    }

    final cells = _splitMarkdownRow(line);
    if (cells.length < 20) continue;

    entries.add(
      RouteInventoryEntry(
        feature: _cleanMarkdownCell(cells[0]),
        route: _cleanMarkdownCell(cells[1]),
        pageClass: _cleanMarkdownCell(cells[2]),
        archetype: _cleanMarkdownCell(cells[5]),
        screenLevel: _cleanMarkdownCell(cells[6]),
        pageFile: _cleanMarkdownCell(cells[19]),
      ),
    );
  }

  if (entries.isEmpty) {
    throw StateError('No route inventory rows found in ${topHeaderFile.path}.');
  }

  return entries;
}

BodyRouteEntry _analyzeRouteEntry({
  required Directory appRoot,
  required String repoRoot,
  required RouteInventoryEntry routeEntry,
}) {
  final bundle = _readSourceBundle(appRoot, repoRoot, routeEntry);
  final source = bundle.source;
  final lower = source.toLowerCase();
  final isTool =
      routeEntry.screenLevel == 'L3_fullscreenTool' ||
      routeEntry.archetype == 'fullscreenTool' ||
      _fullscreenToolPages.contains(routeEntry.pageClass);

  final sharedComponentCount = _countTokenList(source, _sharedPrimitiveTokens);
  final customBodyCount = _countTokenList(source, _customRiskTokens);
  final fixedSizeCount = _fixedSizeCount(source);
  final localFontCount =
      _countOccurrences(source, 'fontSize:') +
      _countOccurrences(source, 'fontFamily:');

  final layoutStatus = _layoutStatus(
    source: source,
    unresolved: bundle.unresolved,
    isTool: isTool,
  );
  final surfaceStatus = _surfaceStatus(
    source: source,
    isTool: isTool,
    customBodyCount: customBodyCount,
  );
  final controlsStatus = _controlsStatus(source);
  final stateStatus = _stateStatus(
    source: source,
    routeEntry: routeEntry,
    isHighRisk: _isFinancialSafetyCandidate(routeEntry, lower),
  );
  final financialSafetyStatus = _financialSafetyStatus(
    source: source,
    lower: lower,
    routeEntry: routeEntry,
  );
  final responsiveStatus = _responsiveStatus(source);
  final copyBoundaryStatus = _copyBoundaryStatus(routeEntry, lower);

  final bodyGrade = _bodyGrade(
    unresolved: bundle.unresolved,
    isTool: isTool,
    sharedComponentCount: sharedComponentCount,
    customBodyCount: customBodyCount,
    layoutStatus: layoutStatus,
    surfaceStatus: surfaceStatus,
    controlsStatus: controlsStatus,
    stateStatus: stateStatus,
    financialSafetyStatus: financialSafetyStatus,
    responsiveStatus: responsiveStatus,
    copyBoundaryStatus: copyBoundaryStatus,
  );
  final issuePriority = _issuePriority(
    routeEntry: routeEntry,
    bodyGrade: bodyGrade,
    layoutStatus: layoutStatus,
    surfaceStatus: surfaceStatus,
    controlsStatus: controlsStatus,
    stateStatus: stateStatus,
    financialSafetyStatus: financialSafetyStatus,
    responsiveStatus: responsiveStatus,
    copyBoundaryStatus: copyBoundaryStatus,
  );
  final primaryIssue = _primaryIssue(
    unresolved: bundle.unresolved,
    isTool: isTool,
    customBodyCount: customBodyCount,
    fixedSizeCount: fixedSizeCount,
    layoutStatus: layoutStatus,
    surfaceStatus: surfaceStatus,
    controlsStatus: controlsStatus,
    stateStatus: stateStatus,
    financialSafetyStatus: financialSafetyStatus,
    responsiveStatus: responsiveStatus,
    copyBoundaryStatus: copyBoundaryStatus,
  );

  return BodyRouteEntry(
    feature: routeEntry.feature,
    route: routeEntry.route,
    pageClass: routeEntry.pageClass,
    pageFile: _canonicalPageFile(routeEntry),
    screenLevel: routeEntry.screenLevel,
    archetype: routeEntry.archetype,
    bodyGrade: bodyGrade,
    issuePriority: issuePriority,
    layoutStatus: layoutStatus,
    surfaceStatus: surfaceStatus,
    controlsStatus: controlsStatus,
    stateStatus: stateStatus,
    financialSafetyStatus: financialSafetyStatus,
    responsiveStatus: responsiveStatus,
    copyBoundaryStatus: copyBoundaryStatus,
    sharedComponentCount: sharedComponentCount,
    customBodyCount: customBodyCount,
    fixedSizeCount: fixedSizeCount,
    localFontCount: localFontCount,
    sourceFileCount: bundle.files.length,
    primaryIssue: primaryIssue,
    recommendedAction: _recommendedAction(primaryIssue, bodyGrade),
    testScope: _testScope(routeEntry.feature),
    sourceFiles: bundle.files,
  );
}

SourceBundle _readSourceBundle(
  Directory appRoot,
  String repoRoot,
  RouteInventoryEntry entry,
) {
  final pageFile = _resolveRepoFile(
    appRoot,
    repoRoot,
    _canonicalPageFile(entry),
  );
  if (pageFile == null || !pageFile.existsSync()) {
    return const SourceBundle(source: '', files: [], unresolved: true);
  }

  final visited = <String>{};
  final primaryFiles = <File>[];
  final widgetFiles = <File>[];
  final primarySources = <String>[];

  void addPrimary(File file) {
    final key = file.path.toLowerCase();
    if (!visited.add(key)) return;
    if (!file.existsSync()) return;
    primaryFiles.add(file);
    final source = file.readAsStringSync();
    primarySources.add(source);

    for (final part in _partFiles(file, source)) {
      addPrimary(part);
    }
    for (final widget in _directFeatureWidgetImports(
      owner: file,
      source: source,
      appRoot: appRoot,
      feature: entry.feature,
    )) {
      widgetFiles.add(widget);
    }
  }

  addPrimary(pageFile);

  // Trade shells own VitPageLayout/VitPageContent in trade_core. Append that
  // source for body grading only — do not export it into source_files, or the
  // density audit will count shared-shell markers against every trade page.
  var tradeShellLayoutOverlay = '';
  final primaryJoined = primarySources.join('\n');
  if (RegExp(
    r'VitTrade(Detail|Hub|Workspace)Scaffold\(|VitTradeSimpleShell\(',
  ).hasMatch(primaryJoined)) {
    final layoutFile = File(
      _joinPath(
        appRoot.path,
        'lib/features/trade_core/presentation/widgets/trade_module_layout.dart'
            .replaceAll('/', Platform.pathSeparator),
      ),
    );
    if (layoutFile.existsSync()) {
      tradeShellLayoutOverlay = layoutFile.readAsStringSync();
    }
  }

  // Tablet wallet detail pages own their wide-screen VitPageLayout and
  // VitPageContent in WalletTabletDetailSurface. Append that shared surface
  // for grading only; keep it out of source_files so the route inventory does
  // not pretend the page directly owns the frame implementation.
  var walletTabletSurfaceOverlay = '';
  if (primaryJoined.contains('WalletTabletDetailSurface(')) {
    final surfaceFile = File(
      _joinPath(
        appRoot.path,
        'lib/features/wallet/presentation/tablet/widgets/'
                'wallet_tablet_detail_surface.dart'
            .replaceAll('/', Platform.pathSeparator),
      ),
    );
    if (surfaceFile.existsSync()) {
      walletTabletSurfaceOverlay = surfaceFile.readAsStringSync();
    }
  }

  if (entry.pageClass == 'RewardsHubPage') {
    widgetFiles.add(
      File(
        _joinPath(
          appRoot.path,
          'lib/app/feature_bridges/rewards_arena_points_bridge.dart'.replaceAll(
            '/',
            Platform.pathSeparator,
          ),
        ),
      ),
    );
  }

  final widgetVisited = <String>{};
  final widgetSourceFiles = <File>[];
  final widgetSources = <String>[];

  void addWidget(File file) {
    final key = file.path.toLowerCase();
    if (!widgetVisited.add(key)) return;
    if (!file.existsSync()) return;
    widgetSourceFiles.add(file);
    final source = file.readAsStringSync();
    widgetSources.add(source);
    for (final part in _partFiles(file, source)) {
      addWidget(part);
    }
  }

  for (final widgetFile in widgetFiles) {
    addWidget(widgetFile);
  }

  final files = <String>{
    for (final file in primaryFiles) _relativePath(file, repoRoot),
    for (final file in widgetSourceFiles.where((file) => file.existsSync()))
      _relativePath(file, repoRoot),
  }.toList()..sort();

  return SourceBundle(
    source: [
      ...primarySources,
      ...widgetSources,
      if (tradeShellLayoutOverlay.isNotEmpty) tradeShellLayoutOverlay,
      if (walletTabletSurfaceOverlay.isNotEmpty) walletTabletSurfaceOverlay,
    ].join('\n'),
    files: files,
    unresolved: false,
  );
}

/// Responsive entries are dispatchers, not the body composition audited by
/// this inventory. Keep the audit pointed at the canonical Phone page, while
/// Tablet has its own separate page and focused UI suite.
String _canonicalPageFile(RouteInventoryEntry entry) {
  return switch (entry.pageClass) {
    'HomeResponsiveEntry' =>
      'flutter_app/lib/features/home/presentation/phone/pages/home_page.dart',
    'MarketsResponsiveEntry' =>
      'flutter_app/lib/features/markets/presentation/phone/pages/market_list_page.dart',
    'WalletResponsiveEntry' =>
      'flutter_app/lib/features/wallet/presentation/phone/pages/wallet_page.dart',
    'TradeResponsiveEntry' =>
      'flutter_app/lib/features/trade/presentation/phone/pages/trade_page.dart',
    'ProfileResponsiveEntry' =>
      'flutter_app/lib/features/profile/presentation/phone/pages/profile_page.dart',
    _ => entry.pageFile,
  };
}

File? _resolveRepoFile(Directory appRoot, String repoRoot, String path) {
  if (path == 'unresolved' || path == '-' || path.isEmpty) return null;
  final native = path.replaceAll('/', Platform.pathSeparator);
  if (path.startsWith('flutter_app/')) {
    return File(_joinPath(repoRoot, native));
  }
  if (path.startsWith('lib/')) {
    return File(_joinPath(appRoot.path, native));
  }
  return File(_joinPath(repoRoot, native));
}

List<File> _partFiles(File owner, String source) {
  final files = <File>[];
  for (final match in RegExp(
    r'''part\s+['"]([^'"]+)['"]''',
  ).allMatches(source)) {
    final uri = match.group(1)!;
    if (uri.startsWith('dart:') || uri.startsWith('package:')) continue;
    files.add(File(owner.uri.resolve(uri).toFilePath()));
  }
  return files;
}

List<File> _directFeatureWidgetImports({
  required File owner,
  required String source,
  required Directory appRoot,
  required String feature,
}) {
  final files = <File>[];
  final featureWidgetPath = '/lib/features/$feature/presentation/widgets/'
      .toLowerCase();

  for (final match in RegExp(
    r'''import\s+['"]([^'"]+)['"]''',
  ).allMatches(source)) {
    final uri = match.group(1)!;
    File? file;

    if (uri.startsWith('package:vit_trade_flutter/')) {
      final packagePath = uri.replaceFirst('package:vit_trade_flutter/', '');
      file = File(
        _joinPath(
          appRoot.path,
          'lib${Platform.pathSeparator}${packagePath.replaceAll('/', Platform.pathSeparator)}',
        ),
      );
    } else if (!uri.startsWith('dart:') && !uri.startsWith('package:')) {
      file = File(owner.uri.resolve(uri).toFilePath());
    }

    if (file == null) continue;
    final normalized = file.path.replaceAll('\\', '/').toLowerCase();
    if (normalized.contains(featureWidgetPath) && file.existsSync()) {
      files.add(file);
    }
  }

  return files;
}

String _layoutStatus({
  required String source,
  required bool unresolved,
  required bool isTool,
}) {
  if (unresolved || source.isEmpty) return 'fail';
  if (isTool) {
    return _containsAny(source, const [
          'SafeArea',
          'MediaQuery.paddingOf',
          'DeviceMetrics',
          'VitHeader',
          'VitTopChrome',
        ])
        ? 'pass'
        : 'warn';
  }

  final hasSharedLayout = _containsAny(source, const [
    'VitPageLayout',
    'VitAutoHideHeaderScaffold',
    'RewardsArenaPointsBridge',
  ]);
  final hasSharedContent = _containsAny(source, const [
    'VitPageContent',
    'VitPageSection',
  ]);

  if (hasSharedLayout && hasSharedContent) return 'pass';
  if (hasSharedLayout || hasSharedContent) return 'warn';
  return 'fail';
}

String _surfaceStatus({
  required String source,
  required bool isTool,
  required int customBodyCount,
}) {
  final sharedSurfaceCount = _countTokenList(source, const [
    'VitCard',
    'VitCardStat',
    'VitServiceTile',
    'VitModuleHeroCard',
    'VitMetricCard',
  ]);

  if (isTool) return sharedSurfaceCount > 0 ? 'pass' : 'warn';
  if (sharedSurfaceCount >= 3 && customBodyCount <= 45) return 'pass';
  if (sharedSurfaceCount > 0) return 'warn';
  if (_countOccurrences(source, 'Container(') >= 6) return 'fail';
  return 'warn';
}

String _controlsStatus(String source) {
  final rawTextField = _countOccurrences(source, 'TextField(');
  final hasSharedInput = _containsAny(source, const [
    'VitInput',
    'VitSearchBar',
  ]);
  final rawButtons = _countTokenList(source, const [
    'ElevatedButton(',
    'TextButton(',
    'OutlinedButton(',
    'IconButton(',
  ]);
  final hasSharedAction = _containsAny(source, const [
    'VitCtaButton',
    'VitHeaderActionButton',
    'VitHeaderActionItem',
  ]);
  final gestureCount = _countOccurrences(source, 'GestureDetector(');

  if (rawTextField > 0 && !hasSharedInput) return 'fail';
  if (rawButtons >= 4 && !hasSharedAction) return 'warn';
  if (gestureCount >= 12 &&
      !_containsAny(source, const ['InkWell(', 'onTap:'])) {
    return 'warn';
  }
  return 'pass';
}

String _stateStatus({
  required String source,
  required RouteInventoryEntry routeEntry,
  required bool isHighRisk,
}) {
  final hasSharedState = _containsAny(source, const [
    'VitEmptyState',
    'VitErrorState',
    'VitOfflineBanner',
    'VitBanner',
    'VitSkeleton',
    'VitHighRiskStatePanel',
  ]);
  final hasStateKeywords = _containsAny(source.toLowerCase(), const [
    'loading',
    'empty',
    'error',
    'offline',
    'submitting',
    'success',
    'failure',
    'asyncvalue',
    '.when(',
  ]);

  if (hasSharedState) return 'pass';
  if (isHighRisk) return hasStateKeywords ? 'warn' : 'fail';
  if (_highImpactFeatures.contains(routeEntry.feature) && !hasStateKeywords) {
    return 'warn';
  }
  return 'pass';
}

String _financialSafetyStatus({
  required String source,
  required String lower,
  required RouteInventoryEntry routeEntry,
}) {
  final isCandidate = _isFinancialSafetyCandidate(routeEntry, lower);
  if (!isCandidate) return 'not_applicable';

  final hasHighRiskPanel = source.contains('VitHighRiskStatePanel');
  final previewConfirmScore = _countLowerTokens(lower, const [
    'preview',
    'confirm',
    'confirmation',
    'receipt',
    'success',
    'submitting',
  ]);
  final disclosureScore = _countLowerTokens(lower, const [
    'fee',
    'fees',
    'risk',
    'limit',
    'limits',
    'network',
    'next step',
    'mask',
    'masked',
    'review',
  ]);

  if (hasHighRiskPanel || (previewConfirmScore >= 2 && disclosureScore >= 2)) {
    return 'pass';
  }
  if (previewConfirmScore > 0 || disclosureScore > 0) return 'warn';
  return 'fail';
}

String _responsiveStatus(String source) {
  final hasSafeBottom = _containsAny(source, const [
    'DeviceMetrics',
    'MediaQuery.paddingOf(context).bottom',
    'MediaQuery.of(context).padding.bottom',
    'SafeArea',
    'VitPageLayout',
    'VitAutoHideHeaderScaffold',
  ]);
  final hasBottomPosition = RegExp(
    r'Positioned\s*\([^)]*bottom\s*:',
    dotAll: true,
  ).hasMatch(source);
  final unsafeWidth = _hasUnsafeFixedWidth(source);
  final fixedSizeCount = _fixedSizeCount(source);

  if (unsafeWidth) return 'fail';
  if (hasBottomPosition && !hasSafeBottom) return 'fail';
  if (fixedSizeCount >= 30 &&
      !_containsAny(source, const [
        'LayoutBuilder',
        'Flexible(',
        'Expanded(',
      ])) {
    return 'warn';
  }
  return 'pass';
}

String _copyBoundaryStatus(RouteInventoryEntry routeEntry, String lower) {
  if (routeEntry.feature == 'arena') {
    if (_containsAny(lower, const [
      'payout',
      'stake return',
      'casino',
      'gamble',
      'gambling',
    ])) {
      return 'fail';
    }
    if (_containsAny(lower, const ['wallet', 'profit'])) return 'warn';
    return 'pass';
  }

  if (routeEntry.feature == 'predictions') {
    return _containsAny(lower, const ['casino', 'gamble', 'gambling', 'fomo'])
        ? 'fail'
        : 'pass';
  }

  if (_containsAny(lower, const ['casino', 'gamble', 'gambling', 'fomo'])) {
    return 'warn';
  }

  return 'pass';
}

String _bodyGrade({
  required bool unresolved,
  required bool isTool,
  required int sharedComponentCount,
  required int customBodyCount,
  required String layoutStatus,
  required String surfaceStatus,
  required String controlsStatus,
  required String stateStatus,
  required String financialSafetyStatus,
  required String responsiveStatus,
  required String copyBoundaryStatus,
}) {
  if (isTool) return 'Tool';
  if (unresolved) return 'D';

  final statuses = [
    layoutStatus,
    surfaceStatus,
    controlsStatus,
    stateStatus,
    if (financialSafetyStatus != 'not_applicable') financialSafetyStatus,
    responsiveStatus,
    copyBoundaryStatus,
  ];
  final failCount = statuses.where((status) => status == 'fail').length;
  final warnCount = statuses.where((status) => status == 'warn').length;
  final customPressureStabilized =
      customBodyCount >= 50 &&
      sharedComponentCount >= 8 &&
      layoutStatus == 'pass' &&
      surfaceStatus != 'fail' &&
      controlsStatus == 'pass' &&
      stateStatus == 'pass' &&
      (financialSafetyStatus == 'pass' ||
          financialSafetyStatus == 'not_applicable') &&
      responsiveStatus == 'pass' &&
      copyBoundaryStatus == 'pass';

  if (sharedComponentCount == 0 && customBodyCount == 0) return 'D';
  if (failCount >= 2) return 'D';
  if (layoutStatus == 'fail' && surfaceStatus == 'fail') return 'D';
  if (failCount == 1 ||
      warnCount >= 3 ||
      (customBodyCount >= 50 && !customPressureStabilized)) {
    return 'C';
  }
  if (warnCount == 0 && sharedComponentCount >= 5 && customBodyCount <= 35) {
    return 'A';
  }
  return 'B';
}

String _issuePriority({
  required RouteInventoryEntry routeEntry,
  required String bodyGrade,
  required String layoutStatus,
  required String surfaceStatus,
  required String controlsStatus,
  required String stateStatus,
  required String financialSafetyStatus,
  required String responsiveStatus,
  required String copyBoundaryStatus,
}) {
  if (copyBoundaryStatus == 'fail' ||
      responsiveStatus == 'fail' ||
      financialSafetyStatus == 'fail' ||
      controlsStatus == 'fail') {
    return 'P0';
  }
  if (bodyGrade == 'D') return 'P1';
  if (bodyGrade == 'C' && _highImpactFeatures.contains(routeEntry.feature)) {
    return 'P1';
  }
  if (bodyGrade == 'C' ||
      layoutStatus == 'warn' ||
      surfaceStatus == 'warn' ||
      stateStatus == 'warn' ||
      financialSafetyStatus == 'warn' ||
      copyBoundaryStatus == 'warn') {
    return 'P2';
  }
  return 'P3';
}

String _primaryIssue({
  required bool unresolved,
  required bool isTool,
  required int customBodyCount,
  required int fixedSizeCount,
  required String layoutStatus,
  required String surfaceStatus,
  required String controlsStatus,
  required String stateStatus,
  required String financialSafetyStatus,
  required String responsiveStatus,
  required String copyBoundaryStatus,
}) {
  if (unresolved) return 'page_source_unresolved';
  if (copyBoundaryStatus == 'fail') return 'domain_copy_boundary_violation';
  if (financialSafetyStatus == 'fail') {
    return 'missing_financial_safety_preview_confirm';
  }
  if (responsiveStatus == 'fail') return 'responsive_or_bottom_chrome_risk';
  if (controlsStatus == 'fail') return 'raw_controls_need_shared_primitives';
  if (layoutStatus == 'fail') return 'missing_shared_body_layout';
  if (surfaceStatus == 'fail') return 'local_surfaces_need_vitcard';
  if (stateStatus == 'fail') return 'missing_required_state_coverage';
  if (isTool) return 'fullscreen_tool_manual_visual_qa_required';
  if (financialSafetyStatus == 'warn') {
    return 'financial_safety_needs_manual_review';
  }
  if (copyBoundaryStatus == 'warn') return 'domain_copy_boundary_needs_review';
  if (layoutStatus == 'warn') return 'partial_shared_body_layout';
  if (surfaceStatus == 'warn') return 'surface_consistency_needs_review';
  if (stateStatus == 'warn') return 'state_coverage_needs_review';
  if (fixedSizeCount >= 30) return 'fixed_size_pressure_needs_mobile_qa';
  if (customBodyCount >= 50) return 'custom_body_pressure_high';
  return 'none';
}

String _recommendedAction(String primaryIssue, String bodyGrade) {
  return switch (primaryIssue) {
    'page_source_unresolved' =>
      'Resolve page file mapping or route inventory before grading this route.',
    'domain_copy_boundary_violation' =>
      'Fix product copy boundary first, then rerun the audit.',
    'missing_financial_safety_preview_confirm' =>
      'Add or verify preview, confirmation, fee/risk/limit, masking, result, and next-step states.',
    'responsive_or_bottom_chrome_risk' =>
      'Remove unsafe fixed sizes or bottom positioning; verify 360 px and bottom-nav clearance.',
    'raw_controls_need_shared_primitives' =>
      'Replace raw TextField/buttons with VitInput, VitSearchBar, VitCtaButton, or approved shared controls.',
    'missing_shared_body_layout' =>
      'Wrap the standard body in VitPageLayout/VitAutoHideHeaderScaffold and VitPageContent.',
    'local_surfaces_need_vitcard' =>
      'Replace repeated local Container panels with VitCard or documented domain surfaces.',
    'missing_required_state_coverage' =>
      'Add loading, empty, error, offline, submitting, and success states where applicable.',
    'fullscreen_tool_manual_visual_qa_required' =>
      'Document fullscreen exception and verify safe close/back controls, safe areas, and nonblank rendering.',
    'financial_safety_needs_manual_review' =>
      'Manually confirm high-risk preview/confirm/result semantics and update notes.',
    'domain_copy_boundary_needs_review' =>
      'Review copy in context; keep Arena points-only and Prediction value-based boundaries separate.',
    'partial_shared_body_layout' =>
      'Complete shared body composition with VitPageContent and section primitives.',
    'surface_consistency_needs_review' =>
      'Normalize primary surfaces to VitCard and theme tokens when touching this screen.',
    'state_coverage_needs_review' =>
      'Verify network and financial states manually; migrate local banners/states if needed.',
    'fixed_size_pressure_needs_mobile_qa' =>
      'Run 360 px visual QA and replace rigid dimensions with responsive constraints where needed.',
    'custom_body_pressure_high' =>
      'Audit local body widgets and consolidate repeated surfaces/controls into shared primitives.',
    _ =>
      bodyGrade == 'A'
          ? 'No body refactor required; keep visual smoke coverage when touched.'
          : 'Acceptable for now; polish when touching the feature.',
  };
}

String _testScope(String feature) {
  return switch (feature) {
    'wallet' => 'flutter test test/features/wallet --reporter=compact',
    'trade' => 'flutter test test/features/trade --reporter=compact',
    'profile' => 'flutter test test/features/profile --reporter=compact',
    'p2p' =>
      'flutter test test/features/p2p_core test/features/p2p_marketplace '
          'test/features/p2p_orders test/features/p2p_account '
          'test/features/p2p_security test/features/p2p_dispute --reporter=compact',
    'p2p_core' => 'flutter test test/features/p2p_core --reporter=compact',
    'p2p_marketplace' =>
      'flutter test test/features/p2p_marketplace --reporter=compact',
    'p2p_orders' => 'flutter test test/features/p2p_orders --reporter=compact',
    'p2p_account' =>
      'flutter test test/features/p2p_account --reporter=compact',
    'p2p_security' =>
      'flutter test test/features/p2p_security --reporter=compact',
    'p2p_dispute' =>
      'flutter test test/features/p2p_dispute --reporter=compact',
    'predictions' =>
      'flutter test test/features/predictions --reporter=compact',
    'markets' => 'flutter test test/features/markets --reporter=compact',
    'arena' => 'flutter test test/features/arena --reporter=compact',
    'dca' => 'flutter test test/features/dca --reporter=compact',
    'earn' =>
      'flutter test test/features/earn_staking test/features/earn_savings --reporter=compact',
    'earn_staking' =>
      'flutter test test/features/earn_staking --reporter=compact',
    'earn_savings' =>
      'flutter test test/features/earn_savings --reporter=compact',
    'earn_core' => 'flutter test test/features/earn_core --reporter=compact',
    'launchpad' => 'flutter test test/features/launchpad --reporter=compact',
    _ => 'flutter test --reporter=compact',
  };
}

String _renderMarkdown(List<BodyRouteEntry> entries) {
  final gradeCounts = _countsBy(entries.map((entry) => entry.bodyGrade));
  final priorityCounts = _countsBy(entries.map((entry) => entry.issuePriority));
  final featureGroups = <String, List<BodyRouteEntry>>{};
  final screenLevelGradeCounts = <String, int>{};

  for (final entry in entries) {
    featureGroups.putIfAbsent(entry.feature, () => []).add(entry);
    final key = '${entry.screenLevel} / ${entry.bodyGrade}';
    screenLevelGradeCounts[key] = (screenLevelGradeCounts[key] ?? 0) + 1;
  }

  final dGrade = entries.where((entry) => entry.isDGrade).toList();
  final cGrade = entries.where((entry) => entry.isCGrade).toList();
  final tools = entries.where((entry) => entry.isTool).toList();
  final safetyReview = entries
      .where(
        (entry) =>
            entry.financialSafetyStatus == 'warn' ||
            entry.financialSafetyStatus == 'fail',
      )
      .toList();
  final copyWarnings = entries
      .where(
        (entry) =>
            entry.copyBoundaryStatus == 'warn' ||
            entry.copyBoundaryStatus == 'fail',
      )
      .toList();

  final buffer = StringBuffer()
    ..writeln('# VitTrade Body Component Consistency Audit')
    ..writeln()
    ..writeln('Generated: $_generatedDate')
    ..writeln()
    ..writeln(
      'Generated from `flutter_app/tool/body_component_consistency_audit.dart`.',
    )
    ..writeln()
    ..writeln('## Inputs')
    ..writeln()
    ..writeln(
      '- `docs/02_FLUTTER_MIGRATION/audits/VitTrade-Top-Header-Visual-Archetype-Audit.md`',
    )
    ..writeln('- Routed page files under `flutter_app/lib/features/`')
    ..writeln('- Page `part` files')
    ..writeln(
      '- Direct feature-local widget imports under `presentation/widgets/`',
    )
    ..writeln()
    ..writeln('## Summary')
    ..writeln()
    ..writeln('```text')
    ..writeln('total_routed_screens=${entries.length}')
    ..writeln('grade_A=${gradeCounts['A'] ?? 0}')
    ..writeln('grade_B=${gradeCounts['B'] ?? 0}')
    ..writeln('grade_C=${gradeCounts['C'] ?? 0}')
    ..writeln('grade_D=${gradeCounts['D'] ?? 0}')
    ..writeln('grade_Tool=${gradeCounts['Tool'] ?? 0}')
    ..writeln(
      'manual_review=${entries.where((entry) => entry.needsManualReview).length}',
    )
    ..writeln('financial_safety_warn_or_fail=${safetyReview.length}')
    ..writeln('copy_boundary_warn_or_fail=${copyWarnings.length}')
    ..writeln('```')
    ..writeln()
    ..writeln('Header/chrome status remains governed by the top-header audit.')
    ..writeln('Current expected header baseline:')
    ..writeln()
    ..writeln('```text')
    ..writeln('total_routed_screens=414')
    ..writeln('strict_visual_issues=0')
    ..writeln('screen_level_mismatches=0')
    ..writeln('```')
    ..writeln()
    ..writeln('## Grade Counts')
    ..writeln()
    ..writeln('| Grade | Routes |')
    ..writeln('| --- | ---: |');

  for (final entry in _sortedCounts(gradeCounts)) {
    buffer.writeln('| ${entry.key} | ${entry.value} |');
  }

  buffer
    ..writeln()
    ..writeln('## Issue Priority Counts')
    ..writeln()
    ..writeln('| Priority | Routes |')
    ..writeln('| --- | ---: |');

  for (final entry in _sortedCounts(priorityCounts)) {
    buffer.writeln('| ${entry.key} | ${entry.value} |');
  }

  buffer
    ..writeln()
    ..writeln('## Feature-Level Status')
    ..writeln()
    ..writeln(
      '| Feature | Routes | A | B | C | D | Tool | P0 | P1 | P2 | P3 | Avg shared | Avg custom |',
    )
    ..writeln(
      '| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |',
    );

  final featureNames = featureGroups.keys.toList()..sort();
  for (final feature in featureNames) {
    final group = featureGroups[feature]!;
    final grades = _countsBy(group.map((entry) => entry.bodyGrade));
    final priorities = _countsBy(group.map((entry) => entry.issuePriority));
    final avgShared =
        group.fold<int>(0, (sum, entry) => sum + entry.sharedComponentCount) /
        group.length;
    final avgCustom =
        group.fold<int>(0, (sum, entry) => sum + entry.customBodyCount) /
        group.length;
    buffer.writeln(
      '| $feature | ${group.length} | ${grades['A'] ?? 0} | '
      '${grades['B'] ?? 0} | ${grades['C'] ?? 0} | ${grades['D'] ?? 0} | '
      '${grades['Tool'] ?? 0} | ${priorities['P0'] ?? 0} | '
      '${priorities['P1'] ?? 0} | ${priorities['P2'] ?? 0} | '
      '${priorities['P3'] ?? 0} | ${avgShared.toStringAsFixed(1)} | '
      '${avgCustom.toStringAsFixed(1)} |',
    );
  }

  buffer
    ..writeln()
    ..writeln('## Screen-Level Grade Counts')
    ..writeln()
    ..writeln('| Screen level / grade | Routes |')
    ..writeln('| --- | ---: |');

  for (final entry in _sortedCounts(screenLevelGradeCounts)) {
    buffer.writeln('| ${entry.key} | ${entry.value} |');
  }

  _writeIssueSection(
    buffer,
    title: 'D-Grade Pages',
    entries: dGrade,
    emptyText: 'No D-grade pages detected.',
  );
  _writeIssueSection(
    buffer,
    title: 'C-Grade Pages',
    entries: cGrade,
    emptyText: 'No C-grade pages detected.',
  );
  _writeIssueSection(
    buffer,
    title: 'Tool Exceptions',
    entries: tools,
    emptyText: 'No fullscreen tool exceptions detected.',
  );
  _writeIssueSection(
    buffer,
    title: 'Financial Or Security Manual Review',
    entries: safetyReview,
    emptyText: 'No financial/security safety warnings detected.',
  );
  _writeIssueSection(
    buffer,
    title: 'Domain Copy Boundary Warnings',
    entries: copyWarnings,
    emptyText: 'No domain copy boundary warnings detected.',
  );

  buffer
    ..writeln()
    ..writeln('## Recommended Batch Order')
    ..writeln()
    ..writeln('1. Resolve unexplained D-grade pages.')
    ..writeln('2. Refactor P0/P1 Wallet child transaction and utility pages.')
    ..writeln(
      '3. Refactor Profile root, security, API, device, and settings pages.',
    )
    ..writeln(
      '4. Refactor Trade P1 margin, analytics, copy, regulatory, and bot pages.',
    )
    ..writeln(
      '5. Refactor P2P high-risk order, payment, dispute, and KYC pages.',
    )
    ..writeln('6. Refactor Prediction event detail and receipt pages.')
    ..writeln('7. Visual QA Markets chart/list pages and approved tools.')
    ..writeln('8. Document remaining approved exceptions.')
    ..writeln()
    ..writeln('## Verification Commands')
    ..writeln()
    ..writeln('```bash')
    ..writeln('cd flutter_app')
    ..writeln('dart format .')
    ..writeln('dart run tool/body_component_consistency_audit.dart')
    ..writeln('dart run tool/body_component_consistency_audit.dart --check')
    ..writeln(
      'dart run tool/top_header_visual_archetype_audit.dart --check --strict',
    )
    ..writeln('dart run tool/route_coverage_audit.dart --check')
    ..writeln('flutter analyze')
    ..writeln('flutter test --reporter=compact')
    ..writeln('```')
    ..writeln()
    ..writeln('## Route Body Inventory')
    ..writeln()
    ..writeln(
      '| Feature | Route | Page | Grade | Priority | Layout | Surface | Controls | State | Safety | Responsive | Copy | Shared | Custom | Fixed | Fonts | Source files | Primary issue | Recommended action | Page file |',
    )
    ..writeln(
      '| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | --- | --- | --- |',
    );

  for (final entry in entries) {
    buffer.writeln(
      '| ${entry.feature} | `${_escapeMarkdown(entry.route)}` | '
      '`${entry.pageClass}` | ${entry.bodyGrade} | ${entry.issuePriority} | '
      '${entry.layoutStatus} | ${entry.surfaceStatus} | '
      '${entry.controlsStatus} | ${entry.stateStatus} | '
      '${entry.financialSafetyStatus} | ${entry.responsiveStatus} | '
      '${entry.copyBoundaryStatus} | ${entry.sharedComponentCount} | '
      '${entry.customBodyCount} | ${entry.fixedSizeCount} | '
      '${entry.localFontCount} | ${entry.sourceFileCount} | '
      '${_escapeMarkdown(entry.primaryIssue)} | '
      '${_escapeMarkdown(entry.recommendedAction)} | '
      '`${entry.pageFile}` |',
    );
  }

  return buffer.toString();
}

void _writeIssueSection(
  StringBuffer buffer, {
  required String title,
  required List<BodyRouteEntry> entries,
  required String emptyText,
}) {
  buffer
    ..writeln()
    ..writeln('## $title')
    ..writeln();

  if (entries.isEmpty) {
    buffer.writeln(emptyText);
    return;
  }

  buffer
    ..writeln('| Priority | Feature | Route | Page | Grade | Issue | Action |')
    ..writeln('| --- | --- | --- | --- | --- | --- | --- |');

  for (final entry in entries) {
    buffer.writeln(
      '| ${entry.issuePriority} | ${entry.feature} | '
      '`${_escapeMarkdown(entry.route)}` | `${entry.pageClass}` | '
      '${entry.bodyGrade} | ${_escapeMarkdown(entry.primaryIssue)} | '
      '${_escapeMarkdown(entry.recommendedAction)} |',
    );
  }
}

String _renderCsv(List<BodyRouteEntry> entries) {
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
        'issue_priority',
        'layout_status',
        'surface_status',
        'controls_status',
        'state_status',
        'financial_safety_status',
        'responsive_status',
        'copy_boundary_status',
        'shared_component_count',
        'custom_body_count',
        'fixed_size_count',
        'local_font_count',
        'source_file_count',
        'primary_issue',
        'recommended_action',
        'test_scope',
        'source_files',
      ].join(','),
    );

  for (final entry in entries) {
    buffer.writeln(
      [
        entry.feature,
        entry.route,
        entry.pageClass,
        entry.pageFile,
        entry.screenLevel,
        entry.archetype,
        entry.bodyGrade,
        entry.issuePriority,
        entry.layoutStatus,
        entry.surfaceStatus,
        entry.controlsStatus,
        entry.stateStatus,
        entry.financialSafetyStatus,
        entry.responsiveStatus,
        entry.copyBoundaryStatus,
        '${entry.sharedComponentCount}',
        '${entry.customBodyCount}',
        '${entry.fixedSizeCount}',
        '${entry.localFontCount}',
        '${entry.sourceFileCount}',
        entry.primaryIssue,
        entry.recommendedAction,
        entry.testScope,
        entry.sourceFiles.join(';'),
      ].map(_csvEscape).join(','),
    );
  }

  return buffer.toString();
}

String _renderSummary(List<BodyRouteEntry> entries) {
  final gradeCounts = _countsBy(entries.map((entry) => entry.bodyGrade));
  final priorityCounts = _countsBy(entries.map((entry) => entry.issuePriority));
  final buffer = StringBuffer()
    ..writeln('total_routed_screens=${entries.length}')
    ..writeln('grade_A=${gradeCounts['A'] ?? 0}')
    ..writeln('grade_B=${gradeCounts['B'] ?? 0}')
    ..writeln('grade_C=${gradeCounts['C'] ?? 0}')
    ..writeln('grade_D=${gradeCounts['D'] ?? 0}')
    ..writeln('grade_Tool=${gradeCounts['Tool'] ?? 0}')
    ..writeln('priority_P0=${priorityCounts['P0'] ?? 0}')
    ..writeln('priority_P1=${priorityCounts['P1'] ?? 0}')
    ..writeln('priority_P2=${priorityCounts['P2'] ?? 0}')
    ..writeln('priority_P3=${priorityCounts['P3'] ?? 0}');
  return buffer.toString();
}

bool _isFinancialSafetyCandidate(RouteInventoryEntry routeEntry, String lower) {
  if (!_financialSafetyFeatures.contains(routeEntry.feature)) return false;
  final routeContext =
      '${routeEntry.feature} ${routeEntry.route} ${routeEntry.pageClass}'
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-z0-9_ ]+'), ' ');
  if (_containsAny(routeContext, _financialSafetyKeywords)) return true;

  final routeMentionsOrder = routeContext.contains('order');
  if (routeMentionsOrder &&
      _containsAny(routeEntry.feature, const ['trade', 'p2p', 'predictions'])) {
    return !routeContext.contains('history') &&
        !routeContext.contains('report') &&
        !routeContext.contains('analytics');
  }

  if (routeEntry.screenLevel == 'L3_transactionFlow' &&
      !routeContext.contains('history') &&
      !routeContext.contains('guide') &&
      !routeContext.contains('faq')) {
    return true;
  }

  return _containsAny(lower, const [
    'vithighriskstatepanel',
    'preview',
    'confirm',
    'confirmation',
    'release escrow',
    'disable 2fa',
  ]);
}

int _countTokenList(String source, List<String> tokens) {
  var count = 0;
  for (final token in tokens) {
    count += _countOccurrences(source, token);
  }
  return count;
}

int _countLowerTokens(String lower, List<String> tokens) {
  var count = 0;
  for (final token in tokens) {
    count += _countOccurrences(lower, token);
  }
  return count;
}

int _countOccurrences(String source, String needle) {
  if (needle.isEmpty) return 0;
  var count = 0;
  var index = 0;
  while (true) {
    index = source.indexOf(needle, index);
    if (index == -1) return count;
    count += 1;
    index += needle.length;
  }
}

int _fixedSizeCount(String source) {
  var count = 0;
  for (final match in RegExp(
    r'\b(height|width):\s*([0-9]+(?:\.[0-9]+)?)',
  ).allMatches(source)) {
    final property = match.group(1)!;
    final value = double.tryParse(match.group(2)!) ?? 0;
    if (property == 'height' && value > 56) count += 1;
    if (property == 'width' && value > 320) count += 1;
  }
  return count;
}

bool _hasUnsafeFixedWidth(String source) {
  for (final match in RegExp(
    r'\bwidth:\s*([0-9]+(?:\.[0-9]+)?)',
  ).allMatches(source)) {
    final value = double.tryParse(match.group(1)!) ?? 0;
    if (value > 360) return true;
  }
  return false;
}

bool _containsAny(String source, List<String> needles) {
  for (final needle in needles) {
    if (source.contains(needle)) return true;
  }
  return false;
}

List<String> _splitMarkdownRow(String line) {
  var trimmed = line.trim();
  if (trimmed.startsWith('|')) trimmed = trimmed.substring(1);
  if (trimmed.endsWith('|')) {
    trimmed = trimmed.substring(0, trimmed.length - 1);
  }
  return trimmed.split('|').map((cell) => cell.trim()).toList();
}

String _cleanMarkdownCell(String cell) {
  var cleaned = cell.trim();
  if (cleaned.startsWith('`') && cleaned.endsWith('`') && cleaned.length >= 2) {
    cleaned = cleaned.substring(1, cleaned.length - 1);
  }
  return cleaned.replaceAll(r'\|', '|').trim();
}

Map<String, int> _countsBy(Iterable<String> values) {
  final counts = <String, int>{};
  for (final value in values) {
    counts[value] = (counts[value] ?? 0) + 1;
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

String _relativePath(File file, String repoRoot) {
  final root = repoRoot.replaceAll('\\', '/');
  final path = file.path.replaceAll('\\', '/');
  if (path.startsWith(root)) return path.substring(root.length);
  final flutterAppIndex = path.indexOf('/flutter_app/');
  if (flutterAppIndex >= 0) return path.substring(flutterAppIndex + 1);
  return path;
}

String _joinPath(String root, String child) {
  if (root.endsWith(Platform.pathSeparator)) return '$root$child';
  return '$root${Platform.pathSeparator}$child';
}

String _escapeMarkdown(String value) {
  return value.replaceAll('|', r'\|').replaceAll('\n', ' ');
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
