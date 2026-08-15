import 'dart:io';

final class VisualHeaderRouteEntry {
  const VisualHeaderRouteEntry({
    required this.feature,
    required this.path,
    required this.pageClass,
    required this.pageFile,
    required this.headerBehavior,
    required this.headerVariant,
    required this.archetype,
    required this.screenLevel,
    required this.expectedArchetype,
    required this.screenLevelMismatch,
    required this.usesVitHeader,
    required this.usesVitTopChrome,
    required this.customHeaderClass,
    required this.noHeaderReason,
    required this.statusBannerPlacement,
    required this.statusBannerCondition,
    required this.offlineBannerState,
    required this.expectedActionCount,
    required this.exceptionReason,
    required this.issue,
  });

  final String feature;
  final String path;
  final String pageClass;
  final String pageFile;
  final String headerBehavior;
  final String headerVariant;
  final String archetype;
  final String screenLevel;
  final String expectedArchetype;
  final String screenLevelMismatch;
  final bool usesVitHeader;
  final bool usesVitTopChrome;
  final String customHeaderClass;
  final String noHeaderReason;
  final String statusBannerPlacement;
  final String statusBannerCondition;
  final String offlineBannerState;
  final int expectedActionCount;
  final String exceptionReason;
  final String issue;

  bool get hasStrictIssue => issue != '-';

  bool get hasScreenLevelMismatch => screenLevelMismatch == 'yes';
}

final class PageGroup {
  const PageGroup({
    required this.file,
    required this.feature,
    required this.source,
    required this.headerBehavior,
    required this.headerVariant,
  });

  final String file;
  final String feature;
  final String source;
  final String headerBehavior;
  final String headerVariant;
}

final class _NoHeaderDecision {
  const _NoHeaderDecision(this.archetype, this.reason, {this.issue = '-'});

  final String archetype;
  final String reason;
  final String issue;
}

const _rootModulePages = <String>{
  'MarketListPage',
  'WalletPage',
  'ProfilePage',
  'P2PHomePage',
  'LaunchpadPage',
  'RewardsHubPage',
};

const _primaryTabRootPages = <String>{
  'MarketListPage',
  'WalletPage',
  'ProfilePage',
};

const _productModuleHubPages = <String>{
  'P2PHomePage',
  'DCAPage',
  'LaunchpadPage',
  'StakingEarnPage',
  'ArenaHomePage',
  'PredictionsHomePage',
  'RewardsHubPage',
};

const _fullscreenToolPages = <String>{'AdvancedChartPage', 'P2PChatPage'};

const _noHeaderDecisions = <String, _NoHeaderDecision>{
  'LoginPage': _NoHeaderDecision(
    'authOnboarding',
    'Auth entry screen intentionally owns its onboarding chrome.',
  ),
  'AdvancedChartPage': _NoHeaderDecision(
    'fullscreenTool',
    'Fullscreen chart workspace; navigation must be provided in the tool UI.',
  ),
  'FuturesPage': _NoHeaderDecision(
    'instrument',
    'Futures beginner shell uses instrument workspace chrome via VitTradeSimpleShell.',
  ),
  'P2PChatPage': _NoHeaderDecision(
    'fullscreenTool',
    'Conversation workspace; navigation must be provided in the chat UI.',
  ),
  'TradingBotsPage': _NoHeaderDecision(
    'fullscreenTool',
    'Bot workspace; navigation must be provided in the workspace UI.',
  ),
  'DCARebalanceDashboardPage': _NoHeaderDecision(
    'detail',
    'Needs migration decision: dashboard should use detail/rootModule chrome unless proven fullscreen.',
    issue: 'no_header_needs_migration_decision',
  ),
  'DCAScheduleAnalyticsPage': _NoHeaderDecision(
    'detail',
    'Needs migration decision: analytics screen should use detail chrome unless proven fullscreen.',
    issue: 'no_header_needs_migration_decision',
  ),
  'EnterpriseStatesPage': _NoHeaderDecision(
    'fullscreenTool',
    'Dev/showcase exception; not a normal financial route.',
  ),
  'WalletPage': _NoHeaderDecision(
    'rootModule',
    'Wallet root module must move page identity into VitTopChrome.',
    issue: 'root_title_in_content',
  ),
  'ProfilePage': _NoHeaderDecision(
    'rootModule',
    'Profile root module must move page identity into VitTopChrome.',
    issue: 'root_title_in_content',
  ),
};

void main(List<String> args) {
  final checkOnly = args.contains('--check');
  final strict = args.contains('--strict');
  final appRoot = _findAppRoot();
  final repoRoot = appRoot.uri.resolve('..').toFilePath();
  final docsDir = Directory('${repoRoot}docs/02_FLUTTER_MIGRATION');
  final markdownFile = File(
    '${docsDir.path}/audits/VitTrade-Top-Header-Visual-Archetype-Audit.md',
  );
  final csvFile = File(
    '${docsDir.path}/audits/VitTrade-Top-Header-Visual-Archetype-Audit.csv',
  );

  final entries = _collectVisualHeaderRouteEntries(appRoot, repoRoot);
  final markdown = _renderMarkdown(entries);
  final csv = _renderCsv(entries);
  final summary = _renderSummary(entries);

  if (checkOnly) {
    final failures = <String>[];
    if (!markdownFile.existsSync()) {
      failures.add('Top header visual archetype markdown artifact is missing.');
    } else if (markdownFile.readAsStringSync() != markdown) {
      failures.add('Top header visual archetype markdown artifact is stale.');
    }

    if (!csvFile.existsSync()) {
      failures.add('Top header visual archetype CSV artifact is missing.');
    } else if (csvFile.readAsStringSync() != csv) {
      failures.add('Top header visual archetype CSV artifact is stale.');
    }

    if (strict) {
      final strictIssues = entries.where((entry) => entry.hasStrictIssue);
      if (strictIssues.isNotEmpty) {
        failures.add(
          'Strict top header visual archetype guardrail found '
          '${strictIssues.length} violation(s).',
        );
      }
    }

    if (failures.isNotEmpty) {
      for (final failure in failures) {
        stderr.writeln(failure);
      }
      stderr.writeln(
        'Run `dart run tool/top_header_visual_archetype_audit.dart` '
        'from flutter_app/.',
      );
      if (strict) {
        stderr.writeln(
          'Strict mode requires every route to have a clean visual archetype.',
        );
      }
      exitCode = 1;
      return;
    }

    stdout.write(summary);
    stdout.writeln('Top header visual archetype artifacts are current.');
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

List<VisualHeaderRouteEntry> _collectVisualHeaderRouteEntries(
  Directory appRoot,
  String repoRoot,
) {
  final pageIndex = _PageIndex(appRoot, repoRoot);
  final routeGroups = Directory('${appRoot.path}/lib/app/router/route_groups');
  final entries = <VisualHeaderRouteEntry>[];

  final files =
      routeGroups
          .listSync()
          .whereType<File>()
          .where(
            (file) =>
                file.path.endsWith('.dart') &&
                !file.path.endsWith('surface_route_helpers.dart'),
          )
          .toList()
        ..sort(
          (a, b) => a.path
              .replaceAll(r'\', '/')
              .compareTo(b.path.replaceAll(r'\', '/')),
        );

  for (final file in files) {
    final text = file.readAsStringSync();
    final routeGroup = _relativePath(file, repoRoot);
    final usesTabletUtilityFamily =
        routeGroup.endsWith('earn_savings_routes.dart') ||
        routeGroup.endsWith('earn_staking_routes.dart') ||
        routeGroup.endsWith('trade_bots_routes.dart') ||
        routeGroup.endsWith('trade_copy_routes.dart') ||
        routeGroup.endsWith('trade_compliance_routes.dart') ||
        routeGroup.endsWith('markets_routes.dart');
    var index = 0;

    while (true) {
      final start = text.indexOf('GoRoute(', index);
      if (start == -1) break;

      final blockEnd = _findBalancedEnd(text, start + 'GoRoute'.length);
      if (blockEnd == -1) break;

      final block = text.substring(start, blockEnd + 1);
      index = blockEnd + 1;

      if (block.contains('redirect:') && !block.contains('builder:')) {
        continue;
      }

      final path = _extractNamedArgument(block, 'path') ?? '-';
      final pageClass =
          usesTabletUtilityFamily && path != 'AppRoutePaths.markets'
          ? 'VitTabletUtilityPage'
          : _extractPageClass(block);
      final page = switch (pageClass) {
        'VitTabletUtilityPage' => _tabletUtilityPageGroup(appRoot, routeGroup),
        'VitWebUtilityPage' => _webUtilityPageGroup(appRoot, routeGroup),
        _ => pageIndex.find(pageClass),
      };

      entries.add(
        _buildEntry(
          feature: page?.feature ?? _featureFromRouteGroup(routeGroup),
          path: path,
          pageClass: pageClass,
          pageFile: page?.file ?? 'unresolved',
          page: page,
        ),
      );
    }
  }

  entries.sort((a, b) {
    final featureCompare = a.feature.compareTo(b.feature);
    if (featureCompare != 0) return featureCompare;
    return a.path.replaceAll(r'\', '/').compareTo(b.path.replaceAll(r'\', '/'));
  });

  return entries;
}

PageGroup? _tabletUtilityPageGroup(Directory appRoot, String routeGroup) {
  final file = File(
    '${appRoot.path}/lib/shared/layout/vit_tablet_utility_page.dart',
  );
  if (!file.existsSync()) return null;
  final source = file.readAsStringSync();
  return PageGroup(
    file: 'flutter_app/lib/shared/layout/vit_tablet_utility_page.dart',
    feature: _featureFromRouteGroup(routeGroup),
    source: source,
    headerBehavior: _classifyHeaderBehavior(source, source),
    headerVariant: _classifyHeaderVariant(source),
  );
}

PageGroup? _webUtilityPageGroup(Directory appRoot, String routeGroup) {
  final file = File(
    '${appRoot.path}/lib/shared/layout/vit_web_utility_page.dart',
  );
  if (!file.existsSync()) return null;
  final source = file.readAsStringSync();
  return PageGroup(
    file: 'flutter_app/lib/shared/layout/vit_web_utility_page.dart',
    feature: _featureFromRouteGroup(routeGroup),
    source: source,
    headerBehavior: _classifyHeaderBehavior(source, source),
    headerVariant: _classifyHeaderVariant(source),
  );
}

VisualHeaderRouteEntry _buildEntry({
  required String feature,
  required String path,
  required String pageClass,
  required String pageFile,
  required PageGroup? page,
}) {
  final source = page?.source ?? '';
  final behavior = page?.headerBehavior ?? 'unresolved';
  final transitiveTopChromeType = _transitiveTopChromeType(
    pageClass: pageClass,
    source: source,
  );
  final variant = transitiveTopChromeType == null
      ? page?.headerVariant ?? 'unresolved'
      : 'vit_top_chrome_${transitiveTopChromeType}_transitive';
  final usesVitHeader = source.contains('VitHeader(');
  final usesVitTopChrome =
      source.contains('VitTopChrome(') || transitiveTopChromeType != null;
  final customHeaderClass = _customHeaderClass(source);
  final statusPlacement = _statusBannerPlacement(source);
  final statusCondition = _statusBannerCondition(source);
  final offlineState = _offlineBannerState(source);
  final actionCount = _expectedActionCount(source);

  var archetype = _detectArchetype(
    pageClass: pageClass,
    behavior: behavior,
    variant: variant,
    source: source,
  );
  if (pageClass == 'VitTabletUtilityPage' &&
      _tabletProductHubPaths.contains(path)) {
    archetype = 'rootModule';
  }
  var noHeaderReason = '-';
  var exceptionReason = '-';
  var issue = '-';

  if (behavior == 'no_top_header') {
    final decision = _noHeaderDecisions[pageClass];
    if (decision == null) {
      archetype = 'unclassified';
      issue = 'no_header_without_exception_reason';
      noHeaderReason = 'missing decision';
    } else {
      archetype = decision.archetype;
      noHeaderReason = decision.reason;
      exceptionReason =
          decision.archetype == 'fullscreenTool' ||
              decision.archetype == 'authOnboarding'
          ? decision.reason
          : '-';
      issue = decision.issue;
    }
  }

  final screenLevel = _screenLevelFor(
    feature: feature,
    path: path,
    pageClass: pageClass,
    source: source,
    archetype: archetype,
  );
  final expectedArchetype = _expectedArchetypeFor(screenLevel);
  final screenLevelMismatch =
      expectedArchetype != '-' && archetype != expectedArchetype ? 'yes' : 'no';

  if (usesVitTopChrome && _rootModulePages.contains(pageClass)) {
    issue = issue == 'root_title_in_content' ? '-' : issue;
  }

  final detectedIssue = _detectIssue(
    pageClass: pageClass,
    source: source,
    behavior: behavior,
    archetype: archetype,
    usesVitTopChrome: usesVitTopChrome,
    statusPlacement: statusPlacement,
    statusCondition: statusCondition,
    expectedArchetype: expectedArchetype,
    hasScreenLevelMismatch: screenLevelMismatch == 'yes',
    existingIssue: issue,
  );

  return VisualHeaderRouteEntry(
    feature: feature,
    path: path,
    pageClass: pageClass,
    pageFile: pageFile,
    headerBehavior: behavior,
    headerVariant: variant,
    archetype: archetype,
    screenLevel: screenLevel,
    expectedArchetype: expectedArchetype,
    screenLevelMismatch: screenLevelMismatch,
    usesVitHeader: usesVitHeader,
    usesVitTopChrome: usesVitTopChrome,
    customHeaderClass: customHeaderClass,
    noHeaderReason: noHeaderReason,
    statusBannerPlacement: statusPlacement,
    statusBannerCondition: statusCondition,
    offlineBannerState: offlineState,
    expectedActionCount: actionCount,
    exceptionReason: exceptionReason,
    issue: detectedIssue,
  );
}

String _detectArchetype({
  required String pageClass,
  required String behavior,
  required String variant,
  required String source,
}) {
  final explicitType = RegExp(
    r'type:\s*VitTopChromeType\.([A-Za-z0-9_]+)',
  ).firstMatch(source);
  if (explicitType != null) return explicitType.group(1)!;

  if (pageClass == 'HomePage' || source.contains('_HomeHeader')) {
    return 'rootBrand';
  }
  if (pageClass == 'TradePage' || pageClass == 'MarginTradingPage') {
    return 'instrument';
  }
  if (pageClass == 'FuturesPage' && source.contains('VitTradeSimpleShell(')) {
    return 'instrument';
  }
  if (_rootModulePages.contains(pageClass) ||
      source.contains('MarketListHeader')) {
    return 'rootModule';
  }
  if (source.contains('_TradeHeader') || source.contains('_PairHeader')) {
    return 'instrument';
  }
  if (behavior == 'fixed_vit_header') {
    return 'detail';
  }
  if (behavior == 'auto_hide_header' && source.contains('VitHeader(')) {
    return 'detail';
  }
  if (behavior == 'custom_scroll_header' && variant.contains('custom')) {
    return 'instrument';
  }
  if (behavior == 'no_top_header') return 'unclassified';
  return 'unclassified';
}

const _tabletProductHubPaths = <String>{
  'AppRoutePaths.marketsPredictions',
  'AppRoutePaths.dca',
  'AppRoutePaths.arena',
  'AppRoutePaths.launchpad',
  'AppRoutePaths.earn',
  'AppRoutePaths.earnSavings',
};

String? _transitiveTopChromeType({
  required String pageClass,
  required String source,
}) {
  if (pageClass == 'RewardsHubPage' &&
      source.contains('RewardsArenaPointsBridge(')) {
    return 'rootModule';
  }
  return null;
}

String _screenLevelFor({
  required String feature,
  required String path,
  required String pageClass,
  required String source,
  required String archetype,
}) {
  if (pageClass == 'HomePage') return 'L0_homeRoot';
  if (pageClass == 'LoginPage') return 'L0_authEntry';
  if (_primaryTabRootPages.contains(pageClass)) return 'L1_primaryTabRoot';
  if (pageClass == 'VitTabletUtilityPage' &&
      _tabletProductHubPaths.contains(path)) {
    return 'L1_productModuleHub';
  }
  if (_productModuleHubPages.contains(pageClass)) {
    return 'L1_productModuleHub';
  }
  if (pageClass == 'TradePage') return 'L1_instrumentWorkspace';
  if (pageClass == 'MarginTradingPage') return 'L1_instrumentWorkspace';
  if (pageClass == 'FuturesPage' && source.contains('VitTradeSimpleShell(')) {
    return 'L1_instrumentWorkspace';
  }
  if (pageClass == 'PairDetailPage') return 'L2_instrumentDetail';
  if (_fullscreenToolPages.contains(pageClass) ||
      archetype == 'fullscreenTool') {
    return 'L3_fullscreenTool';
  }
  if (feature == 'auth') return 'L1_authFlow';

  final normalized = '$feature $path $pageClass'.toLowerCase();
  if (_containsAny(normalized, const [
    'confirm',
    'confirmation',
    'receipt',
    'claim',
    'bridgeorder',
    'bridge_order',
    'orderreceipt',
    'order_receipt',
    'withdraw',
    'deposit',
    'transfer',
    'redeem',
    'submit',
    'release',
    'add',
    'create',
    'edit',
    'setup',
    'verification',
    'assessment',
    'configuration',
    'paymentmethod',
    'payment_method',
    'kyc',
    '2fa',
    'addressbook',
    'address_book',
  ])) {
    return 'L3_transactionFlow';
  }

  if (_containsAny(normalized, const [
    'search',
    'topic',
    'topics',
    'crypto',
    'news',
    'notifications',
    'support',
    'referral',
    'unifiedportfolio',
    'unified_portfolio',
    'crossmodule',
    'cross_module',
  ])) {
    return 'L1_utilityHub';
  }

  if (path.contains(':') || pageClass.endsWith('DetailPage')) {
    return 'L2_entityDetail';
  }

  if (_containsAny(normalized, const [
    'dashboard',
    'overview',
    'hub',
    'center',
  ])) {
    return 'L2_sectionHub';
  }

  if (_containsAny(normalized, const [
    'analytics',
    'history',
    'settings',
    'guide',
    'faq',
    'calendar',
    'reports',
    'reporting',
    'risk',
    'limits',
    'management',
    'portfolio',
    'watchlist',
    'alerts',
  ])) {
    return 'L2_utilityDetail';
  }

  if (source.contains('VitHeader(')) return 'L2_detail';
  return 'L2_detail';
}

String _expectedArchetypeFor(String screenLevel) {
  return switch (screenLevel) {
    'L0_homeRoot' => 'rootBrand',
    'L0_authEntry' => 'authOnboarding',
    'L1_primaryTabRoot' => 'rootModule',
    'L1_productModuleHub' => 'rootModule',
    'L1_instrumentWorkspace' => 'instrument',
    'L2_instrumentDetail' => 'instrument',
    'L3_fullscreenTool' => 'fullscreenTool',
    'L1_authFlow' => 'detail',
    'L1_utilityHub' => 'detail',
    'L2_sectionHub' => 'detail',
    'L2_entityDetail' => 'detail',
    'L2_utilityDetail' => 'detail',
    'L3_transactionFlow' => 'detail',
    'L2_detail' => 'detail',
    _ => '-',
  };
}

bool _containsAny(String source, List<String> needles) {
  for (final needle in needles) {
    if (source.contains(needle)) return true;
  }
  return false;
}

String _detectIssue({
  required String pageClass,
  required String source,
  required String behavior,
  required String archetype,
  required bool usesVitTopChrome,
  required String statusPlacement,
  required String statusCondition,
  required String expectedArchetype,
  required bool hasScreenLevelMismatch,
  required String existingIssue,
}) {
  final issues = <String>[];
  if (existingIssue != '-') issues.add(existingIssue);
  if (archetype == 'unclassified') {
    issues.add('unclassified_visual_archetype');
  }
  if (_rootModulePages.contains(pageClass) &&
      !usesVitTopChrome &&
      (pageClass == 'WalletPage' ||
          pageClass == 'ProfilePage' ||
          pageClass == 'MarketListPage' ||
          pageClass == 'P2PHomePage')) {
    issues.add('root_module_missing_vit_top_chrome');
  }
  if (statusPlacement == 'header' && statusCondition == 'hard_coded') {
    issues.add('offline_banner_hard_coded_in_header');
  } else if (statusCondition == 'hard_coded' &&
      pageClass != 'EnterpriseStatesPage') {
    issues.add('offline_banner_hard_coded_without_state_gate');
  }
  if (source.contains('fontSize: 30') &&
      (pageClass == 'MarketListPage' || archetype == 'rootModule')) {
    issues.add('root_header_uses_nonstandard_font_size_30');
  }
  if (_customTopHeaderUsesLocalPadding(source)) {
    issues.add('top_header_uses_local_padding_tokens');
  }
  if (hasScreenLevelMismatch) {
    issues.add('screen_level_archetype_mismatch(expected_$expectedArchetype)');
  }
  if (behavior == 'no_top_header' && existingIssue == '-') {
    return issues.isEmpty ? '-' : _joinUnique(issues);
  }
  return issues.isEmpty ? '-' : _joinUnique(issues);
}

String _customHeaderClass(String source) {
  final classes = <String>[];
  if (source.contains('_HomeHeader')) classes.add('_HomeHeader');
  if (source.contains('MarketListHeader')) classes.add('MarketListHeader');
  if (source.contains('_PairHeader')) classes.add('_PairHeader');
  if (source.contains('_TradeHeader')) classes.add('_TradeHeader');
  return classes.isEmpty ? '-' : classes.join(';');
}

bool _customTopHeaderUsesLocalPadding(String source) {
  for (final className in const [
    '_HomeHeader',
    'MarketListHeader',
    '_PairHeader',
    '_TradeHeader',
  ]) {
    final block = _extractClassBlock(source, className);
    if (block == null) continue;
    if (block.contains('EdgeInsets.fromLTRB(20,') ||
        block.contains('EdgeInsets.symmetric(horizontal: 20)')) {
      return true;
    }
  }
  return false;
}

String? _extractClassBlock(String source, String className) {
  final classMatch = RegExp(
    '\\bclass\\s+${RegExp.escape(className)}\\b',
  ).firstMatch(source);
  if (classMatch == null) return null;

  final openBrace = source.indexOf('{', classMatch.end);
  if (openBrace == -1) return null;
  final closeBrace = _findBalancedBraceEnd(source, openBrace);
  if (closeBrace == -1) return null;

  return source.substring(classMatch.start, closeBrace + 1);
}

String _statusBannerPlacement(String source) {
  if (!source.contains('VitOfflineBanner(')) return 'none';
  final bannerIndex = source.indexOf('VitOfflineBanner(');
  final headerColumnIndex = source.indexOf('header: Column(');
  if (headerColumnIndex >= 0 && headerColumnIndex < bannerIndex) {
    final openParen = source.indexOf('(', headerColumnIndex);
    final headerEnd = openParen == -1
        ? -1
        : _findBalancedEnd(source, openParen);
    if (headerEnd == -1 || bannerIndex < headerEnd) return 'header';
  }
  return 'content';
}

String _statusBannerCondition(String source) {
  if (!source.contains('VitOfflineBanner(')) return 'none';
  final bannerIndex = source.indexOf('VitOfflineBanner(');
  final contextStart = bannerIndex - 480 < 0 ? 0 : bannerIndex - 480;
  final context = source.substring(contextStart, bannerIndex);
  final normalized = context.toLowerCase();
  if (context.contains('if (') ||
      context.contains('switch') ||
      context.contains('showOfflineBanner') ||
      context.contains('currentState') ||
      normalized.contains('offline') ||
      normalized.contains('stale') ||
      normalized.contains('reconnecting')) {
    return 'state_driven';
  }
  return 'hard_coded';
}

String _offlineBannerState(String source) {
  if (!source.contains('VitOfflineBanner(')) return 'none';
  final lower = source.toLowerCase();
  if (lower.contains('showofflinebanner')) return 'offlineWithCache';
  if (lower.contains('reconnecting')) return 'reconnecting';
  if (lower.contains('offline') && lower.contains('cache')) {
    return 'offlineWithCache';
  }
  if (lower.contains('offline') && lower.contains('empty')) {
    return 'offlineNoCache';
  }
  if (_statusBannerCondition(source) == 'hard_coded') return 'unknownHardCoded';
  return 'offlineWithCache';
}

int _expectedActionCount(String source) {
  return _countOccurrences(source, 'VitHeaderActionItem(') +
      _countOccurrences(source, 'VitHeaderActionButton(');
}

String _extractPageClass(String block) {
  if (block.contains('buildSurfaceAwareTabletRoute') ||
      block.contains('_tabletPredictionRoute') ||
      block.contains('_tabletMarketPairRoute') ||
      block.contains('_tabletTradeTerminalRoute') ||
      block.contains('_tabletDcaRoute') ||
      block.contains('_tabletLaunchpadRoute') ||
      block.contains('_tabletArenaRoute')) {
    return 'VitTabletUtilityPage';
  }

  // The Trade receipt route deliberately selects a device-specific page in
  // one builder. Use the phone page as the audit representative; the Tablet
  // page has its own dedicated receipt implementation and shares the same
  // route contract.
  if (block.contains('TradeTabletOrderReceiptPage') &&
      block.contains('OrderReceiptPage')) {
    return 'OrderReceiptPage';
  }

  if (block.contains('AuthRouteShell')) {
    if (block.contains('LoginPage')) return 'LoginPage';
    if (block.contains('RegisterPage')) return 'RegisterPage';
    if (block.contains('buildOtpPage')) return 'OTPPage';
    if (block.contains('TwoFASetupPage')) return 'TwoFASetupPage';
    if (block.contains('ForgotPasswordPage')) return 'ForgotPasswordPage';
    if (block.contains('ResetPasswordPage')) return 'ResetPasswordPage';
  }

  for (final pattern in [
    RegExp(r'child:\s*(?:const\s+)?([A-Z]\w*)\s*\('),
    RegExp(r'=>\s*(?:const\s+)?([A-Z]\w*)\s*\('),
    RegExp(r'return\s+(?:const\s+)?([A-Z]\w*)\s*\('),
  ]) {
    final match = pattern.firstMatch(block);
    if (match == null) continue;
    final pageClass = match.group(1)!;
    if (pageClass == 'InternalSurfaceGate' || pageClass == 'AuthRouteShell') {
      continue;
    }
    return pageClass;
  }

  return 'unresolved';
}

String? _extractNamedArgument(String block, String name) {
  final match = RegExp('$name:\\s*([^,\\n]+)').firstMatch(block);
  return match?.group(1)?.trim();
}

String _featureFromRouteGroup(String routeGroup) {
  final fileName = routeGroup.split('/').last;
  return fileName.replaceAll('_routes.dart', '');
}

final class _PageIndex {
  _PageIndex(Directory appRoot, String repoRoot) {
    _build(appRoot, repoRoot);
  }

  final _classes = <String, PageGroup>{};

  PageGroup? find(String pageClass) => _classes[pageClass];

  void _build(Directory appRoot, String repoRoot) {
    final featuresDir = Directory('${appRoot.path}/lib/features');
    final sourceByGroup = <String, List<File>>{};

    final files =
        featuresDir
            .listSync(recursive: true)
            .whereType<File>()
            .where((file) => file.path.endsWith('.dart'))
            .toList()
          ..sort(
            (a, b) => a.path
                .replaceAll(r'\', '/')
                .compareTo(b.path.replaceAll(r'\', '/')),
          );

    for (final file in files) {
      final source = file.readAsStringSync();
      final partOf = RegExp(r"part of '([^']+)';").firstMatch(source);
      final groupFile = partOf == null
          ? file
          : File(file.uri.resolve(partOf.group(1)!).toFilePath());
      final relativeGroup = _relativePath(groupFile, repoRoot);
      sourceByGroup.putIfAbsent(relativeGroup, () => []).add(file);
    }

    for (final entry in sourceByGroup.entries) {
      final baseSource = entry.value
          .map((file) => file.readAsStringSync())
          .join('\n');
      final source = [
        baseSource,
        ..._extraSourceForPageGroup(appRoot, entry.key, baseSource),
      ].join('\n');
      final pageGroup = PageGroup(
        file: entry.key,
        feature: _featureFromFeaturePath(entry.key),
        source: source,
        headerBehavior: _classifyHeaderBehavior(source, baseSource),
        headerVariant: _classifyHeaderVariant(source),
      );

      for (final match in RegExp(
        r'\bclass\s+([A-Z]\w*)\b',
      ).allMatches(source)) {
        _classes[match.group(1)!] = pageGroup;
      }
    }
  }
}

// Known residual gap: when a `part of` file group holds more than one
// *routed* page class, each using a genuinely different shell (e.g.
// ClientCategorizationPage's own file uses VitTradeHubScaffold, while its
// `client_categorization_opt_up_page.dart` part-file sibling routes
// ClientOptUpRequestPage through VitTradeDetailScaffold), both classes
// share this single group-level classification, so one page's shell can
// still bleed into the other's row. A per-class fix was attempted and
// reverted: narrowing to `<Class>`/`_<Class>State` bodies broke unrelated
// pages elsewhere that delegate header rendering to a third, differently
// named helper class within the same group (e.g. markets' PairDetailPage
// -> _PairDetailPageState -> _PairHeader). Resolving this correctly needs
// per-routed-class body resolution that also follows arbitrary
// custom-header helper classes, not just the State-class convention —
// tracked separately, out of scope for the file-vs-class extra-source fix
// above.

String _featureFromFeaturePath(String path) {
  final parts = path.split('/');
  final featuresIndex = parts.indexOf('features');
  if (featuresIndex == -1 || featuresIndex + 1 >= parts.length) return '-';
  return parts[featuresIndex + 1];
}

/// A shell widget reference used as extra classification source. When
/// [className] is null, the whole file at [path] is safe to include (it
/// defines exactly one relevant shell class). When [className] is set, the
/// file defines *multiple* shell classes (e.g.
/// `trade_module_layout.dart`), so only that one class's body is extracted
/// via brace matching — including the whole file would leak an unrelated
/// sibling class's behavior (e.g. `VitTradeHubScaffold`'s
/// `VitAutoHideHeaderScaffold(` bleeding into a `VitTradeDetailScaffold`
/// page's classification).
typedef _ShellSourceRef = ({String path, String? className});

List<String> _extraSourceForPageGroup(
  Directory appRoot,
  String relativeGroup,
  String baseSource,
) {
  final extraPaths = <String>[];

  if (relativeGroup ==
      'flutter_app/lib/features/markets/presentation/phone/pages/market_list_page.dart') {
    extraPaths.add(
      'lib/features/markets/presentation/widgets/phone/market_list_header.dart',
    );
  }

  const tradeModuleLayout =
      'lib/features/trade_core/presentation/widgets/trade_module_layout.dart';

  const shellSources = <String, List<_ShellSourceRef>>{
    'VitTradeHubScaffold(': [
      (path: tradeModuleLayout, className: 'VitTradeHubScaffold'),
    ],
    'VitTradeDetailScaffold(': [
      (path: tradeModuleLayout, className: 'VitTradeDetailScaffold'),
    ],
    'VitTradeSimpleShell(': [
      (
        path:
            'lib/features/trade/presentation/widgets/phone/vit_trade_simple_shell.dart',
        className: null,
      ),
      // VitTradeSimpleShell always wraps VitTradeHubScaffold (never
      // VitTradeDetailScaffold) — see vit_trade_simple_shell.dart's build().
      (path: tradeModuleLayout, className: 'VitTradeHubScaffold'),
    ],
    'VitTradeWorkspaceScaffold(': [
      (path: tradeModuleLayout, className: 'VitTradeWorkspaceScaffold'),
    ],
    'VitWalletDetailScaffold(': [
      (
        path:
            'lib/features/wallet/presentation/phone/widgets/vit_wallet_detail_scaffold.dart',
        className: null,
      ),
    ],
    'WalletTabletDetailSurface(': [
      (
        path:
            'lib/features/wallet/presentation/tablet/widgets/wallet_tablet_detail_surface.dart',
        className: null,
      ),
    ],
    'ProfileTabletUtilitySurface(': [
      (
        path:
            'lib/features/profile/presentation/tablet/widgets/profile_tablet_utility_surface.dart',
        className: null,
      ),
    ],
    'P2PTabletUtilitySurface(': [
      (
        path:
            'lib/features/p2p_core/presentation/tablet/widgets/p2p_tablet_utility_surface.dart',
        className: null,
      ),
    ],
    'VitTabletUtilityPage(': [
      (path: 'lib/shared/layout/vit_tablet_utility_page.dart', className: null),
    ],
    'CrossModuleTabbedPageShell(': [
      (
        path:
            'lib/features/cross_module/presentation/widgets/cross_module_tabbed_shell.dart',
        className: null,
      ),
    ],
    'VitAutoHidePageScaffold(': [
      (
        path: 'lib/shared/layout/vit_auto_hide_page_scaffold.dart',
        className: null,
      ),
    ],
    'VitP2PFlowScaffold(': [
      (
        path:
            'lib/features/p2p_core/presentation/widgets/vit_p2p_flow_scaffold.dart',
        className: null,
      ),
    ],
  };

  final extraSources = <String>[];
  for (final binding in shellSources.entries) {
    if (!baseSource.contains(binding.key)) continue;
    for (final ref in binding.value) {
      final file = File('${appRoot.path}/${ref.path}');
      if (!file.existsSync()) continue;
      final content = file.readAsStringSync();
      if (ref.className == null) {
        extraSources.add(content);
        continue;
      }
      final body = _extractClassBody(content, ref.className!);
      if (body != null) extraSources.add(body);
    }
  }

  return [
    for (final path in extraPaths)
      if (File('${appRoot.path}/$path').existsSync())
        File('${appRoot.path}/$path').readAsStringSync(),
    ...extraSources,
  ];
}

/// Extracts the brace-matched body of `class [className] ... { ... }` from
/// [source], from the `class` keyword through its balanced closing brace.
/// Returns null if the class isn't found. This is a plain-text depth
/// counter (not an AST parse), matching the rest of this file's
/// substring-based classification approach — sufficient for Dart source
/// where `{`/`}` outside class bodies mostly appear in balanced pairs
/// (including string interpolations like `'${x}'`).
String? _extractClassBody(String source, String className) {
  final match = RegExp('class\\s+$className\\b[^{]*\\{').firstMatch(source);
  if (match == null) return null;

  var depth = 1;
  var i = match.end;
  while (i < source.length && depth > 0) {
    final char = source[i];
    if (char == '{') depth++;
    if (char == '}') depth--;
    i++;
  }
  return source.substring(match.start, i);
}

/// Classifies how [source] (a page's own source, optionally concatenated
/// with extra shell-wrapper source appended after it) renders its top
/// header. [baseSource] is the page's own literal source with no extras
/// appended — the "is the header inline inside a scroll view" ordering
/// check below is only meaningful when [source] and [baseSource] describe
/// the *same* widget's layout. When `VitHeader(` is found only inside
/// appended extra source (i.e. a shared shell like `VitTradeDetailScaffold`
/// that the page merely calls, rather than a header the page builds
/// inline), text position relative to a scroll-container mention
/// elsewhere in the *page's own, unrelated* body is meaningless — string
/// concatenation order isn't widget-tree order — so that case always
/// resolves to `fixed_vit_header` (a shared shell placing `VitHeader(` as
/// a fixed sibling before its scrollable body, never inline-in-scroll).
String _classifyHeaderBehavior(String source, [String? baseSource]) {
  if (source.contains('VitAutoHideHeaderScaffold(')) {
    return 'auto_hide_header';
  }
  if (source.contains('RewardsArenaPointsBridge(')) {
    return 'auto_hide_header';
  }
  if (source.contains('_CollapsibleHomeHeader') ||
      (source.contains('_headerVisible') &&
          (source.contains('UserScrollNotification') ||
              source.contains('ScrollUpdateNotification')))) {
    return 'auto_hide_header';
  }

  final headerIndex = source.indexOf('VitHeader(');
  if (headerIndex >= 0) {
    final headerInBaseSource =
        baseSource == null || headerIndex < baseSource.length;
    if (headerInBaseSource) {
      final scrollIndex = _firstIndexOfAny(source, const [
        'SingleChildScrollView',
        'ListView',
        'CustomScrollView',
        'NestedScrollView',
      ]);
      if (scrollIndex >= 0 && scrollIndex < headerIndex) {
        return 'custom_scroll_header';
      }
    }
    return 'fixed_vit_header';
  }

  if (source.contains('_TradeHeader') || source.contains('MarketListHeader')) {
    return 'custom_scroll_header';
  }

  return 'no_top_header';
}

String _classifyHeaderVariant(String source) {
  if (source.contains('VitTopChrome(')) {
    final type = RegExp(
      r'type:\s*VitTopChromeType\.([A-Za-z0-9_]+)',
    ).firstMatch(source);
    return type == null ? 'vit_top_chrome' : 'vit_top_chrome_${type.group(1)}';
  }
  if (source.contains('VitAutoHideHeaderScaffold(')) {
    return 'shared_auto_hide_scaffold';
  }
  if (source.contains('RewardsArenaPointsBridge(')) {
    return 'shared_auto_hide_scaffold';
  }
  if (source.contains('_CollapsibleHomeHeader')) {
    return 'home_collapsible_custom';
  }
  if (source.contains('_TradeHeader')) return 'trade_custom_in_scroll';
  if (source.contains('MarketListHeader')) return 'market_custom_in_scroll';
  if (!source.contains('VitHeader(')) return 'no_top_header';
  if (source.contains('variant: VitHeaderVariant.custom')) {
    return 'vit_header_custom';
  }
  if (source.contains('trailing:') || source.contains('action:')) {
    return 'vit_header_default_with_actions';
  }
  if (source.contains('subtitle:')) {
    return 'vit_header_default_title_subtitle';
  }
  return 'vit_header_default_title_only';
}

int _firstIndexOfAny(String source, List<String> needles) {
  final indexes = <int>[];
  for (final needle in needles) {
    final index = source.indexOf(needle);
    if (index >= 0) indexes.add(index);
  }
  if (indexes.isEmpty) return -1;
  indexes.sort();
  return indexes.first;
}

String _renderMarkdown(List<VisualHeaderRouteEntry> entries) {
  final archetypeCounts = _countsBy(entries.map((entry) => entry.archetype));
  final screenLevelCounts = _countsBy(
    entries.map((entry) => entry.screenLevel),
  );
  final screenLevelMismatchCounts = _countsBy(
    entries
        .where((entry) => entry.hasScreenLevelMismatch)
        .map(
          (entry) =>
              '${entry.screenLevel}: ${entry.archetype}->${entry.expectedArchetype}',
        ),
  );
  final issueCounts = _countsBy(
    entries.expand(
      (entry) => entry.issue == '-' ? const <String>[] : entry.issue.split(';'),
    ),
  );
  final strictIssues = entries.where((entry) => entry.hasStrictIssue).length;
  final screenLevelMismatches = entries
      .where((entry) => entry.hasScreenLevelMismatch)
      .length;

  final buffer = StringBuffer()
    ..writeln('# VitTrade Top Header Visual Archetype Audit')
    ..writeln()
    ..writeln(
      'Generated from `flutter_app/tool/top_header_visual_archetype_audit.dart`.',
    )
    ..writeln()
    ..writeln('```text')
    ..writeln('total_routed_screens=${entries.length}')
    ..writeln('strict_visual_issues=$strictIssues')
    ..writeln('screen_level_mismatches=$screenLevelMismatches')
    ..writeln(
      'uses_vit_top_chrome=${entries.where((entry) => entry.usesVitTopChrome).length}',
    )
    ..writeln(
      'status_banner_in_header=${entries.where((entry) => entry.statusBannerPlacement == 'header').length}',
    )
    ..writeln(
      'hard_coded_offline_banner=${entries.where((entry) => entry.statusBannerCondition == 'hard_coded').length}',
    )
    ..writeln('```')
    ..writeln()
    ..writeln('## Screen-Level Contract')
    ..writeln()
    ..writeln('| Level | Screen type | Expected top chrome |')
    ..writeln('| --- | --- | --- |')
    ..writeln('| L0 | Home root | `rootBrand` |')
    ..writeln('| L0 | Auth entry | `authOnboarding` |')
    ..writeln(
      '| L1 | Primary tab roots: Markets, Wallet, Profile | `rootModule` |',
    )
    ..writeln(
      '| L1 | Product module hubs: P2P, DCA, Launchpad, Earn, Arena, Prediction Markets, Rewards | `rootModule` |',
    )
    ..writeln('| L1 | Trade instrument workspace | `instrument` |')
    ..writeln(
      '| L1 | Utility hubs: Search, News, Notifications, Support, Referral, cross-module tools | `detail` |',
    )
    ..writeln('| L2 | Section hub, utility detail, entity detail | `detail` |')
    ..writeln('| L2 | Instrument detail such as Pair Detail | `instrument` |')
    ..writeln(
      '| L3 | Transaction flows: confirm, receipt, withdraw, deposit, add payment method | `detail` |',
    )
    ..writeln(
      '| L3 | Fullscreen tools: terminal chart, futures terminal, chat | `fullscreenTool` |',
    )
    ..writeln()
    ..writeln('## Header Policy')
    ..writeln()
    ..writeln(
      '- `rootModule` allows at most two visible primary actions before overflow unless a product exception is documented.',
    )
    ..writeln(
      '- `detail` usually has zero or one visible action; transaction flows expose safety actions only.',
    )
    ..writeln(
      '- Module identity is accent-only: icon, pill, border, tab indicator, chart marker, or restrained accent color. No per-module header backgrounds or local header palettes.',
    )
    ..writeln(
      '- DCA, Arena, Earn, Prediction Markets, P2P, Launchpad, and Rewards are product hubs; Convert/Swap, receipts, confirmations, settings, history, and analytics remain detail rhythm.',
    )
    ..writeln()
    ..writeln('## Screen-Level Counts')
    ..writeln()
    ..writeln('| Screen level | Routes |')
    ..writeln('| --- | ---: |');

  for (final entry in _sortedCounts(screenLevelCounts)) {
    buffer.writeln('| ${entry.key} | ${entry.value} |');
  }

  buffer
    ..writeln()
    ..writeln('## Archetype Counts')
    ..writeln()
    ..writeln('| Archetype | Routes |')
    ..writeln('| --- | ---: |');

  for (final entry in _sortedCounts(archetypeCounts)) {
    buffer.writeln('| ${entry.key} | ${entry.value} |');
  }

  buffer
    ..writeln()
    ..writeln('## Strict Issue Counts')
    ..writeln()
    ..writeln('| Issue | Routes |')
    ..writeln('| --- | ---: |');

  if (issueCounts.isEmpty) {
    buffer.writeln('| none | 0 |');
  } else {
    for (final entry in _sortedCounts(issueCounts)) {
      buffer.writeln('| ${entry.key} | ${entry.value} |');
    }
  }

  buffer
    ..writeln()
    ..writeln('## Screen-Level Mismatch Counts')
    ..writeln()
    ..writeln('| Mismatch | Routes |')
    ..writeln('| --- | ---: |');

  if (screenLevelMismatchCounts.isEmpty) {
    buffer.writeln('| none | 0 |');
  } else {
    for (final entry in _sortedCounts(screenLevelMismatchCounts)) {
      buffer.writeln('| ${entry.key} | ${entry.value} |');
    }
  }

  buffer
    ..writeln()
    ..writeln('## Route Visual Inventory')
    ..writeln()
    ..writeln(
      '| Feature | Route | Page | Behavior | Variant | Archetype | Screen level | Expected | Mismatch | VitHeader | VitTopChrome | Custom header | No-header reason | Banner placement | Banner condition | Offline state | Actions | Exception | Issue | Page file |',
    )
    ..writeln(
      '| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | ---: | --- | --- | --- |',
    );

  for (final entry in entries) {
    buffer.writeln(
      '| ${entry.feature} | `${_escape(entry.path)}` | '
      '`${entry.pageClass}` | ${entry.headerBehavior} | '
      '${entry.headerVariant} | ${entry.archetype} | '
      '${entry.screenLevel} | ${entry.expectedArchetype} | '
      '${entry.screenLevelMismatch} | '
      '${entry.usesVitHeader ? 'yes' : 'no'} | '
      '${entry.usesVitTopChrome ? 'yes' : 'no'} | '
      '`${_escape(entry.customHeaderClass)}` | '
      '${_escape(entry.noHeaderReason)} | ${entry.statusBannerPlacement} | '
      '${entry.statusBannerCondition} | ${entry.offlineBannerState} | '
      '${entry.expectedActionCount} | ${_escape(entry.exceptionReason)} | '
      '${_escape(entry.issue)} | `${entry.pageFile}` |',
    );
  }

  return buffer.toString();
}

String _renderCsv(List<VisualHeaderRouteEntry> entries) {
  final buffer = StringBuffer()
    ..writeln(
      [
        'feature',
        'route',
        'pageClass',
        'pageFile',
        'headerBehavior',
        'headerVariant',
        'archetype',
        'screenLevel',
        'expectedArchetype',
        'screenLevelMismatch',
        'usesVitHeader',
        'usesVitTopChrome',
        'customHeaderClass',
        'noHeaderReason',
        'statusBannerPlacement',
        'statusBannerCondition',
        'offlineBannerState',
        'expectedActionCount',
        'exceptionReason',
        'issue',
      ].join(','),
    );

  for (final entry in entries) {
    buffer.writeln(
      [
        entry.feature,
        entry.path,
        entry.pageClass,
        entry.pageFile,
        entry.headerBehavior,
        entry.headerVariant,
        entry.archetype,
        entry.screenLevel,
        entry.expectedArchetype,
        entry.screenLevelMismatch,
        entry.usesVitHeader ? 'yes' : 'no',
        entry.usesVitTopChrome ? 'yes' : 'no',
        entry.customHeaderClass,
        entry.noHeaderReason,
        entry.statusBannerPlacement,
        entry.statusBannerCondition,
        entry.offlineBannerState,
        entry.expectedActionCount.toString(),
        entry.exceptionReason,
        entry.issue,
      ].map(_csvCell).join(','),
    );
  }

  return buffer.toString();
}

String _renderSummary(List<VisualHeaderRouteEntry> entries) {
  final counts = _countsBy(entries.map((entry) => entry.archetype));
  final buffer = StringBuffer()
    ..writeln('total_routed_screens=${entries.length}')
    ..writeln(
      'strict_visual_issues=${entries.where((entry) => entry.hasStrictIssue).length}',
    )
    ..writeln(
      'screen_level_mismatches=${entries.where((entry) => entry.hasScreenLevelMismatch).length}',
    )
    ..writeln(
      'uses_vit_top_chrome=${entries.where((entry) => entry.usesVitTopChrome).length}',
    )
    ..writeln(
      'status_banner_in_header=${entries.where((entry) => entry.statusBannerPlacement == 'header').length}',
    )
    ..writeln(
      'hard_coded_offline_banner=${entries.where((entry) => entry.statusBannerCondition == 'hard_coded').length}',
    );

  for (final entry in _sortedCounts(counts)) {
    buffer.writeln('${entry.key}=${entry.value}');
  }
  return buffer.toString();
}

Map<String, int> _countsBy(Iterable<String> values) {
  final counts = <String, int>{};
  for (final value in values) {
    counts.update(value, (count) => count + 1, ifAbsent: () => 1);
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

String _joinUnique(List<String> values) {
  return values.toSet().join(';');
}

int _countOccurrences(String source, String needle) {
  var count = 0;
  var index = 0;
  while (true) {
    index = source.indexOf(needle, index);
    if (index == -1) return count;
    count += 1;
    index += needle.length;
  }
}

String _csvCell(String value) {
  final escaped = value.replaceAll('"', '""');
  return '"$escaped"';
}

String _escape(String value) {
  return value.replaceAll('|', r'\|').replaceAll('\n', ' ');
}

String _relativePath(File file, String repoRoot) {
  return file.path
      .replaceAll('\\', '/')
      .replaceFirst(repoRoot.replaceAll('\\', '/'), '');
}

int _findBalancedEnd(String text, int openParenIndex) {
  var depth = 0;
  var inSingleQuote = false;
  var inDoubleQuote = false;
  var escaping = false;

  for (var i = openParenIndex; i < text.length; i++) {
    final char = text[i];

    if (escaping) {
      escaping = false;
      continue;
    }
    if (char == r'\') {
      escaping = true;
      continue;
    }
    if (char == "'" && !inDoubleQuote) {
      inSingleQuote = !inSingleQuote;
      continue;
    }
    if (char == '"' && !inSingleQuote) {
      inDoubleQuote = !inDoubleQuote;
      continue;
    }
    if (inSingleQuote || inDoubleQuote) continue;

    if (char == '(') {
      depth += 1;
    } else if (char == ')') {
      depth -= 1;
      if (depth == 0) return i;
    }
  }

  return -1;
}

int _findBalancedBraceEnd(String text, int openBraceIndex) {
  var depth = 0;
  var inSingleQuote = false;
  var inDoubleQuote = false;
  var escaping = false;

  for (var i = openBraceIndex; i < text.length; i++) {
    final char = text[i];

    if (escaping) {
      escaping = false;
      continue;
    }
    if (char == r'\') {
      escaping = true;
      continue;
    }
    if (char == "'" && !inDoubleQuote) {
      inSingleQuote = !inSingleQuote;
      continue;
    }
    if (char == '"' && !inSingleQuote) {
      inDoubleQuote = !inDoubleQuote;
      continue;
    }
    if (inSingleQuote || inDoubleQuote) continue;

    if (char == '{') {
      depth += 1;
    } else if (char == '}') {
      depth -= 1;
      if (depth == 0) return i;
    }
  }

  return -1;
}
