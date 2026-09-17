// Size-gate note (QA audit 2026-07-27, Future-Feature-Onboarding-Checklist
// "data fixture files above 500 lines"): this file is intentionally long
// because it is a single homogeneous data table — one `_intent(...)` entry
// per route contract, grouped only by product module
// (`_p2pContracts`/`_earnContracts`/`_launchpadContracts`/
// `_discoveryContracts`/`_crossModuleContracts`). There is no mixed
// responsibility to split out: the ~30 lines of type/model/lookup code at
// the top (`RouteContractIntent`, `DynamicNavigationIntentContracts`,
// `_RoutePattern`) is shared plumbing for every entry below it, and
// splitting the per-route list itself would just scatter one flat table
// across files without improving readability. Consumers:
// `test/app/router/dynamic_navigation_route_contract_test.dart` and
// `test/core/navigation/navigation_intent_test.dart`.
import 'package:vit_trade_flutter/core/navigation/navigation_intent.dart';

enum NavigationIntentModule {
  p2p('p2p', 'P2P Trading', 'p2p'),
  earn('earn', 'Earn and Savings', 'earn'),
  launchpad('launchpad', 'Launchpad and Token Access', 'launchpad'),
  discovery('discovery', 'Home and Discovery', 'discovery'),
  crossModule(
    'cross_module',
    'Enterprise Cross-Module Intelligence',
    'cross_module',
  );

  const NavigationIntentModule(this.id, this.productArea, this.technicalModule);

  final String id;
  final String productArea;
  final String technicalModule;
}

enum NavigationIntentLifecycleStage {
  entry('Entry'),
  trustGate('Trust gate / eligibility'),
  discover('Discover / orient'),
  decide('Decide / analyze'),
  setup('Setup / configure'),
  submit('Submit / confirm / settle'),
  manage('Monitor / manage'),
  operate('Operate / extend'),
  recover('Recover / resolve');

  const NavigationIntentLifecycleStage(this.label);

  final String label;
}

final class RouteContractIntent extends NavigationIntent {
  const RouteContractIntent({
    required this.contractId,
    required this.module,
    required this.capability,
    required this.flow,
    required this.screenName,
    required this.routePattern,
    required this.samplePath,
    required this.lifecycleStage,
    required this.surface,
    required this.explanation,
    this.allowedQueryKeys = const {},
  });

  final String contractId;
  final NavigationIntentModule module;
  final String capability;
  final String flow;
  final String screenName;
  final String routePattern;
  final String samplePath;
  final NavigationIntentLifecycleStage lifecycleStage;
  final String surface;
  final String explanation;
  final Set<String> allowedQueryKeys;

  String get productArea => module.productArea;

  String get technicalModule => module.technicalModule;

  @override
  String resolve() => samplePath;

  bool matchesRoute(String route) {
    return _RoutePattern.matches(
      routePattern: routePattern,
      candidateRoute: route,
      allowedQueryKeys: allowedQueryKeys,
    );
  }

  String get humanReadableLine {
    return [
      productArea,
      technicalModule,
      capability,
      flow,
      '$screenName [$routePattern]',
      lifecycleStage.label,
      surface,
      explanation,
    ].join(' > ');
  }
}

final class DynamicNavigationIntentContracts {
  const DynamicNavigationIntentContracts._();

  static const modules = <NavigationIntentModule>[
    NavigationIntentModule.p2p,
    NavigationIntentModule.earn,
    NavigationIntentModule.launchpad,
    NavigationIntentModule.discovery,
    NavigationIntentModule.crossModule,
  ];

  static final contracts = <RouteContractIntent>[
    ..._p2pContracts,
    ..._earnContracts,
    ..._launchpadContracts,
    ..._discoveryContracts,
    ..._crossModuleContracts,
  ];

  static RouteContractIntent? findByRoute(String route, {String? module}) {
    for (final contract in contracts) {
      if (module != null && contract.module.id != module) continue;
      if (contract.matchesRoute(route)) return contract;
    }
    return null;
  }

  static List<RouteContractIntent> contractsForModule(String module) {
    return [
      for (final contract in contracts)
        if (contract.module.id == module) contract,
    ];
  }

  static List<String> humanReadableFlowMap({String? module}) {
    return [
      for (final contract in contracts)
        if (module == null || contract.module.id == module)
          contract.humanReadableLine,
    ];
  }
}

RouteContractIntent _intent({
  required String id,
  required NavigationIntentModule module,
  required String capability,
  required String flow,
  required String screen,
  required String route,
  required NavigationIntentLifecycleStage stage,
  required String surface,
  required String explanation,
  String? sample,
  Set<String> allowedQueryKeys = const {},
}) {
  return RouteContractIntent(
    contractId: '${module.id}.$id',
    module: module,
    capability: capability,
    flow: flow,
    screenName: screen,
    routePattern: route,
    samplePath: sample ?? _samplePathFor(route, allowedQueryKeys),
    lifecycleStage: stage,
    surface: surface,
    explanation: explanation,
    allowedQueryKeys: allowedQueryKeys,
  );
}

String _samplePathFor(String routePattern, Set<String> allowedQueryKeys) {
  final path = routePattern
      .split('?')
      .first
      .split('/')
      .map((segment) => segment.startsWith(':') ? 'sample' : segment)
      .join('/');
  if (allowedQueryKeys.isEmpty) return path;
  final query = allowedQueryKeys.map((key) => '$key=sample').join('&');
  return '$path?$query';
}

final class _RoutePattern {
  const _RoutePattern._();

  static bool matches({
    required String routePattern,
    required String candidateRoute,
    required Set<String> allowedQueryKeys,
  }) {
    final patternSegments = _pathSegments(routePattern);
    final candidateSegments = _pathSegments(candidateRoute);
    if (patternSegments.length != candidateSegments.length) return false;

    for (var index = 0; index < patternSegments.length; index += 1) {
      final pattern = patternSegments[index];
      final candidate = candidateSegments[index];
      if (_isParameterized(pattern)) continue;
      if (_isUnresolvedTemplate(candidate) && _isParameterized(pattern)) {
        continue;
      }
      if (pattern != candidate) return false;
    }

    final queryKeys = _queryKeys(candidateRoute);
    if (queryKeys.isEmpty) return true;
    return queryKeys.every(allowedQueryKeys.contains);
  }

  static List<String> _pathSegments(String route) {
    final path = route.split('?').first;
    return path.split('/').where((segment) => segment.isNotEmpty).toList();
  }

  static Set<String> _queryKeys(String route) {
    final queryStart = route.indexOf('?');
    if (queryStart < 0 || queryStart == route.length - 1) return const {};
    return route
        .substring(queryStart + 1)
        .split('&')
        .where((part) => part.isNotEmpty)
        .map((part) => part.split('=').first)
        .toSet();
  }

  static bool _isParameterized(String segment) => segment.startsWith(':');

  static bool _isUnresolvedTemplate(String segment) {
    return segment.startsWith(':') ||
        segment.contains(r'$') ||
        segment.contains('{') ||
        segment.contains('}');
  }
}

final _p2pContracts = <RouteContractIntent>[
  _intent(
    id: 'home',
    module: NavigationIntentModule.p2p,
    capability: 'P2P Trading Lifecycle',
    flow: 'P2P order lifecycle and chat',
    screen: 'P2P home',
    route: '/p2p',
    stage: NavigationIntentLifecycleStage.entry,
    surface: 'Trade tab product hub',
    explanation: 'Primary escrow commerce entry point.',
  ),
  _intent(
    id: 'order',
    module: NavigationIntentModule.p2p,
    capability: 'P2P Trading Lifecycle',
    flow: 'P2P order lifecycle and chat',
    screen: 'P2P order status',
    route: '/p2p/order/:orderId',
    stage: NavigationIntentLifecycleStage.submit,
    surface: 'Trade tab product hub',
    explanation: 'Escrow order detail, payment status, and release controls.',
    sample: '/p2p/order/p2p001',
  ),
  _intent(
    id: 'chat',
    module: NavigationIntentModule.p2p,
    capability: 'P2P Trading Lifecycle',
    flow: 'P2P order lifecycle and chat',
    screen: 'P2P order chat',
    route: '/p2p/chat/:orderId',
    stage: NavigationIntentLifecycleStage.submit,
    surface: 'Trade tab product hub',
    explanation: 'Order-scoped buyer/seller communication.',
    sample: '/p2p/chat/p2p001',
  ),
  _intent(
    id: 'merchant',
    module: NavigationIntentModule.p2p,
    capability: 'P2P Merchant Operations',
    flow: 'P2P ads, merchant and reputation operations',
    screen: 'P2P merchant profile',
    route: '/p2p/merchant/:merchantId',
    stage: NavigationIntentLifecycleStage.operate,
    surface: 'Trade tab product hub',
    explanation: 'Merchant reputation, ads, and trust evidence.',
    sample: '/p2p/merchant/mc001',
  ),
  _intent(
    id: 'merchant-report',
    module: NavigationIntentModule.p2p,
    capability: 'P2P Merchant Operations',
    flow: 'P2P disputes and evidence',
    screen: 'P2P merchant report',
    route: '/p2p/report/:merchantId',
    stage: NavigationIntentLifecycleStage.recover,
    surface: 'Contextual support',
    explanation: 'Merchant dispute or abuse report path.',
    sample: '/p2p/report/mc001',
  ),
  _intent(
    id: 'payment-add',
    module: NavigationIntentModule.p2p,
    capability: 'P2P Trust, Security and Payment Methods',
    flow: 'P2P payment methods',
    screen: 'P2P payment method add',
    route: '/p2p/payment-method/add',
    stage: NavigationIntentLifecycleStage.setup,
    surface: 'Trade tab product hub',
    explanation: 'Payment-method setup with reviewed type query.',
    sample: '/p2p/payment-method/add?type=bank',
    allowedQueryKeys: {'type'},
  ),
  _intent(
    id: 'payment-methods',
    module: NavigationIntentModule.p2p,
    capability: 'P2P Trust, Security and Payment Methods',
    flow: 'P2P payment methods',
    screen: 'P2P payment methods',
    route: '/p2p/payment-methods',
    stage: NavigationIntentLifecycleStage.setup,
    surface: 'Trade tab product hub',
    explanation: 'Payment-method list and management.',
  ),
  _intent(
    id: 'kyc-step',
    module: NavigationIntentModule.p2p,
    capability: 'P2P Trust, Security and Payment Methods',
    flow: 'P2P KYC and verification',
    screen: 'P2P KYC step',
    route: '/p2p/kyc/:step',
    stage: NavigationIntentLifecycleStage.trustGate,
    surface: 'Profile tab / contextual support',
    explanation: 'P2P eligibility and identity verification steps.',
    sample: '/p2p/kyc/status',
  ),
  _intent(
    id: 'security-tool',
    module: NavigationIntentModule.p2p,
    capability: 'P2P Trust, Security and Payment Methods',
    flow: 'P2P account security',
    screen: 'P2P security tool',
    route: '/p2p/security/:tool',
    stage: NavigationIntentLifecycleStage.trustGate,
    surface: 'Profile tab / contextual support',
    explanation: 'P2P account-protection controls.',
    sample: '/p2p/security/center',
  ),
  _intent(
    id: 'profile-devices',
    module: NavigationIntentModule.p2p,
    capability: 'P2P Trust, Security and Payment Methods',
    flow: 'P2P account security',
    screen: 'Profile devices',
    route: '/profile/devices',
    stage: NavigationIntentLifecycleStage.trustGate,
    surface: 'Profile tab',
    explanation: 'Shared device trust surface linked from P2P security.',
  ),
  _intent(
    id: 'profile-settings',
    module: NavigationIntentModule.p2p,
    capability: 'P2P Trust, Security and Payment Methods',
    flow: 'P2P account security',
    screen: 'Profile settings',
    route: '/profile/settings',
    stage: NavigationIntentLifecycleStage.trustGate,
    surface: 'Profile tab',
    explanation: 'Shared profile settings linked from P2P trust prompts.',
  ),
  _intent(
    id: 'settings-security',
    module: NavigationIntentModule.p2p,
    capability: 'P2P Trust, Security and Payment Methods',
    flow: 'P2P account security',
    screen: 'Security setting',
    route: '/settings/security/:tool',
    stage: NavigationIntentLifecycleStage.trustGate,
    surface: 'Profile tab',
    explanation: 'Shared security setting linked from P2P security checklist.',
    sample: '/settings/security/biometric',
  ),
  _intent(
    id: 'compliance-tool',
    module: NavigationIntentModule.p2p,
    capability: 'P2P Risk, Compliance and Wallet Operations',
    flow: 'P2P compliance, limits and tax',
    screen: 'P2P compliance tool',
    route: '/p2p/compliance/:tool',
    stage: NavigationIntentLifecycleStage.trustGate,
    surface: 'Trade tab product hub',
    explanation: 'AML, source-of-funds, and compliance readiness views.',
    sample: '/p2p/compliance/overview',
  ),
  _intent(
    id: 'limits',
    module: NavigationIntentModule.p2p,
    capability: 'P2P Risk, Compliance and Wallet Operations',
    flow: 'P2P compliance, limits and tax',
    screen: 'P2P limits',
    route: '/p2p/limits',
    stage: NavigationIntentLifecycleStage.manage,
    surface: 'Trade tab product hub',
    explanation: 'P2P limit overview.',
  ),
  _intent(
    id: 'limits-tracker',
    module: NavigationIntentModule.p2p,
    capability: 'P2P Risk, Compliance and Wallet Operations',
    flow: 'P2P compliance, limits and tax',
    screen: 'P2P limits tracker',
    route: '/p2p/limits/tracker',
    stage: NavigationIntentLifecycleStage.manage,
    surface: 'Trade tab product hub',
    explanation: 'Limit consumption tracking.',
  ),
  _intent(
    id: 'tax-report-detail',
    module: NavigationIntentModule.p2p,
    capability: 'P2P Risk, Compliance and Wallet Operations',
    flow: 'P2P compliance, limits and tax',
    screen: 'P2P tax report detail',
    route: '/p2p/tax-report/detailed/:year',
    stage: NavigationIntentLifecycleStage.manage,
    surface: 'Trade tab product hub',
    explanation: 'Annual P2P tax detail route.',
    sample: '/p2p/tax-report/detailed/2026',
  ),
  _intent(
    id: 'wallet-tool',
    module: NavigationIntentModule.p2p,
    capability: 'P2P Risk, Compliance and Wallet Operations',
    flow: 'P2P wallet, dashboard and safety tools',
    screen: 'P2P wallet tool',
    route: '/p2p/wallet/:tool',
    stage: NavigationIntentLifecycleStage.manage,
    surface: 'Trade tab product hub',
    explanation: 'P2P wallet history and transfer surfaces.',
    sample: '/p2p/wallet/history',
  ),
  _intent(
    id: 'wallet',
    module: NavigationIntentModule.p2p,
    capability: 'P2P Risk, Compliance and Wallet Operations',
    flow: 'P2P wallet, dashboard and safety tools',
    screen: 'P2P wallet',
    route: '/p2p/wallet',
    stage: NavigationIntentLifecycleStage.manage,
    surface: 'Trade tab product hub',
    explanation: 'P2P wallet balance surface.',
  ),
  _intent(
    id: 'escrow-balance',
    module: NavigationIntentModule.p2p,
    capability: 'P2P Trading',
    flow: 'P2P escrow and balance',
    screen: 'P2P escrow balance',
    route: '/p2p/escrow/balance',
    stage: NavigationIntentLifecycleStage.submit,
    surface: 'Trade tab product hub',
    explanation: 'Escrow balance and settlement status.',
  ),
  _intent(
    id: 'insurance-tool',
    module: NavigationIntentModule.p2p,
    capability: 'P2P Risk, Compliance and Wallet Operations',
    flow: 'P2P insurance fund',
    screen: 'P2P insurance tool',
    route: '/p2p/insurance/:tool',
    stage: NavigationIntentLifecycleStage.recover,
    surface: 'Contextual support',
    explanation: 'Insurance fund certificate, claim, and contribution tools.',
    sample: '/p2p/insurance/certificate',
  ),
  _intent(
    id: 'insurance-claim',
    module: NavigationIntentModule.p2p,
    capability: 'P2P Risk, Compliance and Wallet Operations',
    flow: 'P2P insurance fund',
    screen: 'P2P insurance claim detail',
    route: '/p2p/insurance/claim/:claimId',
    stage: NavigationIntentLifecycleStage.recover,
    surface: 'Contextual support',
    explanation: 'Claim recovery route with case-specific support context.',
    sample: '/p2p/insurance/claim/claim001',
  ),
  _intent(
    id: 'insurance',
    module: NavigationIntentModule.p2p,
    capability: 'P2P Risk, Compliance and Wallet Operations',
    flow: 'P2P insurance fund',
    screen: 'P2P insurance',
    route: '/p2p/insurance',
    stage: NavigationIntentLifecycleStage.recover,
    surface: 'Contextual support',
    explanation: 'Insurance fund overview.',
  ),
  _intent(
    id: 'insurance-fund',
    module: NavigationIntentModule.p2p,
    capability: 'P2P Risk, Compliance and Wallet Operations',
    flow: 'P2P insurance fund',
    screen: 'P2P insurance fund',
    route: '/p2p/insurance-fund',
    stage: NavigationIntentLifecycleStage.recover,
    surface: 'Contextual support',
    explanation: 'Insurance fund transparency page.',
  ),
  _intent(
    id: 'support',
    module: NavigationIntentModule.p2p,
    capability: 'P2P Trading Lifecycle',
    flow: 'P2P disputes and evidence',
    screen: 'Support',
    route: '/support',
    stage: NavigationIntentLifecycleStage.recover,
    surface: 'Contextual support',
    explanation: 'Generic support route for P2P recovery.',
  ),
  _intent(
    id: 'support-help',
    module: NavigationIntentModule.p2p,
    capability: 'P2P Trading Lifecycle',
    flow: 'P2P disputes and evidence',
    screen: 'Support help',
    route: '/support/help',
    stage: NavigationIntentLifecycleStage.recover,
    surface: 'Contextual support',
    explanation: 'Help-center route linked from P2P guide.',
  ),
  _intent(
    id: 'general-second-level',
    module: NavigationIntentModule.p2p,
    capability: 'P2P Trading Lifecycle',
    flow: 'P2P trading and account operations',
    screen: 'P2P secondary screen',
    route: '/p2p/:section',
    stage: NavigationIntentLifecycleStage.operate,
    surface: 'Trade tab product hub',
    explanation: 'Reviewed P2P route-bearing data for product operations.',
    sample: '/p2p/express',
  ),
  _intent(
    id: 'general-third-level',
    module: NavigationIntentModule.p2p,
    capability: 'P2P Trading Lifecycle',
    flow: 'P2P trading and account operations',
    screen: 'P2P nested screen',
    route: '/p2p/:section/:subsection',
    stage: NavigationIntentLifecycleStage.operate,
    surface: 'Trade tab product hub',
    explanation: 'Reviewed nested P2P route-bearing data.',
    sample: '/p2p/settings/notifications',
  ),
];

final _earnContracts = <RouteContractIntent>[
  _intent(
    id: 'home',
    module: NavigationIntentModule.earn,
    capability: 'Staking / Earn',
    flow: 'Earn and staking entry',
    screen: 'Earn home',
    route: '/earn',
    stage: NavigationIntentLifecycleStage.entry,
    surface: 'Trade tab product hub',
    explanation: 'Primary yield product entry.',
  ),
  _intent(
    id: 'staking',
    module: NavigationIntentModule.earn,
    capability: 'Staking / Earn',
    flow: 'Earn and staking entry',
    screen: 'Staking home',
    route: '/earn/staking',
    stage: NavigationIntentLifecycleStage.entry,
    surface: 'Trade tab product hub',
    explanation: 'Primary staking product route.',
  ),
  _intent(
    id: 'savings',
    module: NavigationIntentModule.earn,
    capability: 'Savings',
    flow: 'Savings product and portfolio lifecycle',
    screen: 'Savings home',
    route: '/earn/savings',
    stage: NavigationIntentLifecycleStage.entry,
    surface: 'Trade tab product hub',
    explanation: 'Primary savings product route.',
  ),
  _intent(
    id: 'dashboard',
    module: NavigationIntentModule.earn,
    capability: 'Staking / Earn',
    flow: 'Staking dashboard and history',
    screen: 'Staking dashboard',
    route: '/earn/dashboard',
    stage: NavigationIntentLifecycleStage.manage,
    surface: 'Trade tab product hub',
    explanation: 'Yield dashboard, positions, and status overview.',
  ),
  _intent(
    id: 'risk-dashboard',
    module: NavigationIntentModule.earn,
    capability: 'Staking / Earn',
    flow: 'Staking compliance, custody and risk controls',
    screen: 'Staking risk dashboard',
    route: '/earn/risk-dashboard',
    stage: NavigationIntentLifecycleStage.manage,
    surface: 'Trade tab product hub',
    explanation: 'Risk metrics and action center for staking.',
  ),
  _intent(
    id: 'staking-step',
    module: NavigationIntentModule.earn,
    capability: 'Staking / Earn',
    flow: 'Staking operations and products',
    screen: 'Staking nested screen',
    route: '/earn/staking/:screen',
    stage: NavigationIntentLifecycleStage.setup,
    surface: 'Trade tab product hub',
    explanation: 'Staking route-bearing data for setup and risk screens.',
    sample: '/earn/staking/risk-assessment',
  ),
  _intent(
    id: 'savings-product',
    module: NavigationIntentModule.earn,
    capability: 'Savings',
    flow: 'Savings product and portfolio lifecycle',
    screen: 'Savings product detail',
    route: '/earn/savings/product/:productId',
    stage: NavigationIntentLifecycleStage.decide,
    surface: 'Trade tab product hub',
    explanation: 'Savings product detail from data-driven product cards.',
    sample: '/earn/savings/product/sample',
  ),
  _intent(
    id: 'savings-step',
    module: NavigationIntentModule.earn,
    capability: 'Savings',
    flow: 'Savings product and portfolio lifecycle',
    screen: 'Savings nested screen',
    route: '/earn/savings/:screen',
    stage: NavigationIntentLifecycleStage.manage,
    surface: 'Trade tab product hub',
    explanation:
        'Savings route-bearing data for portfolio, history, guides, and automation.',
    sample: '/earn/savings/portfolio',
  ),
  _intent(
    id: 'voting',
    module: NavigationIntentModule.earn,
    capability: 'Staking / Earn',
    flow: 'Staking community, governance and integrations',
    screen: 'Staking voting detail',
    route: '/earn/voting/:proposalId',
    stage: NavigationIntentLifecycleStage.operate,
    surface: 'Trade tab product hub',
    explanation: 'Governance proposal voting route.',
    sample: '/earn/voting/prop001',
  ),
  _intent(
    id: 'earn-tool',
    module: NavigationIntentModule.earn,
    capability: 'Staking / Earn',
    flow: 'Staking compliance, education, and risk tools',
    screen: 'Earn tool screen',
    route: '/earn/:screen',
    stage: NavigationIntentLifecycleStage.operate,
    surface: 'Trade tab product hub',
    explanation:
        'Reviewed Earn route-bearing data for risk, education, audit, and support tools.',
    sample: '/earn/history',
  ),
  _intent(
    id: 'home',
    module: NavigationIntentModule.earn,
    capability: 'Home, Discovery and Notifications',
    flow: 'Home dashboard',
    screen: 'Home command center',
    route: '/home',
    stage: NavigationIntentLifecycleStage.entry,
    surface: 'Home tab',
    explanation: 'Earn flows can return to the command center.',
  ),
  _intent(
    id: 'tax-reports',
    module: NavigationIntentModule.earn,
    capability: 'Enterprise Cross-Module Intelligence',
    flow: 'Tax reporting',
    screen: 'Tax report center',
    route: '/tax-reports',
    stage: NavigationIntentLifecycleStage.manage,
    surface: 'Admin gated',
    explanation: 'Tax reporting route linked from Earn reporting data.',
  ),
];

final _launchpadContracts = <RouteContractIntent>[
  _intent(
    id: 'home',
    module: NavigationIntentModule.launchpad,
    capability: 'Launchpad Portfolio and Staking',
    flow: 'Launchpad overview, portfolio and staking',
    screen: 'Launchpad home',
    route: '/launchpad',
    stage: NavigationIntentLifecycleStage.entry,
    surface: 'Trade tab product hub',
    explanation: 'Primary token access entry.',
  ),
  _intent(
    id: 'home-back',
    module: NavigationIntentModule.launchpad,
    capability: 'Home, Discovery and Notifications',
    flow: 'Home dashboard',
    screen: 'Home command center',
    route: '/home',
    stage: NavigationIntentLifecycleStage.entry,
    surface: 'Home tab',
    explanation: 'Launchpad flows can return to the command center.',
  ),
  _intent(
    id: 'project-detail',
    module: NavigationIntentModule.launchpad,
    capability: 'Launchpad Participation and Settlement',
    flow: 'Launchpad IDO bridge, contract and receipt flow',
    screen: 'Launchpad project detail',
    route: '/launchpad/sample',
    stage: NavigationIntentLifecycleStage.decide,
    surface: 'Trade tab product hub',
    explanation:
        'Project detail route from launchpad cards and selected project state.',
  ),
  _intent(
    id: 'parameterized-screen',
    module: NavigationIntentModule.launchpad,
    capability: 'Launchpad Participation and Settlement',
    flow: 'Launchpad IDO bridge, contract and receipt flow',
    screen: 'Launchpad parameterized screen',
    route: '/launchpad/:screen/:id',
    stage: NavigationIntentLifecycleStage.submit,
    surface: 'Trade tab product hub',
    explanation:
        'Contract, bridge, receipt, claim, and ABI-diff routes with backend IDs.',
    sample: '/launchpad/receipt/sub001',
  ),
  _intent(
    id: 'bridge-compare',
    module: NavigationIntentModule.launchpad,
    capability: 'Launchpad Participation and Settlement',
    flow: 'Launchpad IDO bridge, contract and receipt flow',
    screen: 'Launchpad bridge compare',
    route: '/launchpad/bridge-compare',
    stage: NavigationIntentLifecycleStage.decide,
    surface: 'Trade tab product hub',
    explanation: 'Bridge-route comparison before execution.',
  ),
  _intent(
    id: 'portfolio',
    module: NavigationIntentModule.launchpad,
    capability: 'Launchpad Portfolio and Staking',
    flow: 'Launchpad overview, portfolio and staking',
    screen: 'Launchpad portfolio',
    route: '/launchpad/portfolio',
    stage: NavigationIntentLifecycleStage.manage,
    surface: 'Trade tab product hub',
    explanation: 'Token-access portfolio status and holdings.',
  ),
  _intent(
    id: 'staking',
    module: NavigationIntentModule.launchpad,
    capability: 'Launchpad Portfolio and Staking',
    flow: 'Launchpad overview, portfolio and staking',
    screen: 'Launchpad staking',
    route: '/launchpad/staking',
    stage: NavigationIntentLifecycleStage.setup,
    surface: 'Trade tab product hub',
    explanation: 'Launchpool staking route from launchpad entry.',
  ),
  _intent(
    id: 'batch-claim',
    module: NavigationIntentModule.launchpad,
    capability: 'Launchpad Participation and Settlement',
    flow: 'Launchpad claim and receipt flow',
    screen: 'Launchpad batch claim',
    route: '/launchpad/batch-claim',
    stage: NavigationIntentLifecycleStage.submit,
    surface: 'Trade tab product hub',
    explanation: 'Claim selection and review route.',
  ),
  _intent(
    id: 'operations-tool',
    module: NavigationIntentModule.launchpad,
    capability: 'Launchpad Operations and Risk Tools',
    flow: 'Launchpad operations, notifications and address book',
    screen: 'Launchpad operation screen',
    route: '/launchpad/:screen',
    stage: NavigationIntentLifecycleStage.operate,
    surface: 'Trade tab product hub',
    explanation:
        'Reviewed Launchpad route-bearing data for operations and risk tools.',
    sample: '/launchpad/event-log',
  ),
];

final _discoveryContracts = <RouteContractIntent>[
  _intent(
    id: 'search',
    module: NavigationIntentModule.discovery,
    capability: 'Home, Discovery and Notifications',
    flow: 'Unified search',
    screen: 'Search',
    route: '/search',
    stage: NavigationIntentLifecycleStage.discover,
    surface: 'Home tab',
    explanation: 'Global discovery query entry.',
  ),
  _intent(
    id: 'topics',
    module: NavigationIntentModule.discovery,
    capability: 'Home, Discovery and Notifications',
    flow: 'Topic discovery',
    screen: 'Topics',
    route: '/topics',
    stage: NavigationIntentLifecycleStage.discover,
    surface: 'Home tab',
    explanation: 'Topic discovery entry from search and feed modules.',
  ),
  _intent(
    id: 'markets-predictions',
    module: NavigationIntentModule.discovery,
    capability: 'Prediction Market Discovery and Portfolio',
    flow: 'Prediction market discovery',
    screen: 'Prediction markets',
    route: '/predictions',
    stage: NavigationIntentLifecycleStage.discover,
    surface: 'Markets tab',
    explanation: 'Prediction discovery route surfaced in discovery data.',
  ),
  _intent(
    id: 'prediction-event',
    module: NavigationIntentModule.discovery,
    capability: 'Prediction Market Operations',
    flow: 'Prediction event trading',
    screen: 'Prediction event',
    route: '/predictions/event/:eventId',
    stage: NavigationIntentLifecycleStage.decide,
    surface: 'Markets tab',
    explanation: 'Prediction event detail route from discovery cards.',
    sample: '/predictions/event/pred-1',
  ),
  _intent(
    id: 'pair',
    module: NavigationIntentModule.discovery,
    capability: 'Pair Intelligence',
    flow: 'Pair and depth intelligence',
    screen: 'Pair detail',
    route: '/pair/:symbol',
    stage: NavigationIntentLifecycleStage.decide,
    surface: 'Markets tab',
    explanation: 'Market pair detail route from discovery search.',
    sample: '/pair/btcusdt',
  ),
  _intent(
    id: 'arena',
    module: NavigationIntentModule.discovery,
    capability: 'Open Arena Discovery and Management',
    flow: 'Arena discovery, guide and production handoff',
    screen: 'Arena home',
    route: '/arena',
    stage: NavigationIntentLifecycleStage.discover,
    surface: 'Home / Trade product hub',
    explanation: 'Points-only Arena discovery route.',
  ),
  _intent(
    id: 'arena-screen',
    module: NavigationIntentModule.discovery,
    capability: 'Open Arena Discovery and Management',
    flow: 'Arena discovery and gameplay handoff',
    screen: 'Arena nested screen',
    route: '/arena/:screen',
    stage: NavigationIntentLifecycleStage.discover,
    surface: 'Home / Trade product hub',
    explanation: 'Arena studio and mode-independent discovery route.',
    sample: '/arena/studio',
  ),
  _intent(
    id: 'arena-entity',
    module: NavigationIntentModule.discovery,
    capability: 'Open Arena Gameplay and Creation',
    flow: 'Arena mode, challenge and resolution flow',
    screen: 'Arena entity detail',
    route: '/arena/:entity/:id',
    stage: NavigationIntentLifecycleStage.decide,
    surface: 'Home / Trade product hub',
    explanation:
        'Arena challenge, mode, and creator routes from discovery cards.',
    sample: '/arena/challenge/ch003',
  ),
];

final _crossModuleContracts = <RouteContractIntent>[
  _intent(
    id: 'home',
    module: NavigationIntentModule.crossModule,
    capability: 'Enterprise Cross-Module Intelligence',
    flow: 'Unified portfolio intelligence',
    screen: 'Home command center',
    route: '/home',
    stage: NavigationIntentLifecycleStage.entry,
    surface: 'Admin gated',
    explanation:
        'Cross-module dashboard returns to the customer command center.',
  ),
  _intent(
    id: 'wallet',
    module: NavigationIntentModule.crossModule,
    capability: 'Enterprise Cross-Module Intelligence',
    flow: 'Unified portfolio intelligence',
    screen: 'Wallet',
    route: '/wallet',
    stage: NavigationIntentLifecycleStage.manage,
    surface: 'Admin gated',
    explanation: 'Cross-module portfolio drill-down into wallet treasury.',
  ),
  _intent(
    id: 'trade',
    module: NavigationIntentModule.crossModule,
    capability: 'Enterprise Cross-Module Intelligence',
    flow: 'Unified portfolio intelligence',
    screen: 'Trade',
    route: '/trade',
    stage: NavigationIntentLifecycleStage.manage,
    surface: 'Admin gated',
    explanation: 'Cross-module portfolio drill-down into trading exposure.',
  ),
  _intent(
    id: 'p2p',
    module: NavigationIntentModule.crossModule,
    capability: 'Enterprise Cross-Module Intelligence',
    flow: 'Unified portfolio intelligence',
    screen: 'P2P',
    route: '/p2p',
    stage: NavigationIntentLifecycleStage.manage,
    surface: 'Admin gated',
    explanation: 'Cross-module portfolio drill-down into P2P balances.',
  ),
  _intent(
    id: 'predictions',
    module: NavigationIntentModule.crossModule,
    capability: 'Enterprise Cross-Module Intelligence',
    flow: 'Unified portfolio intelligence',
    screen: 'Prediction markets',
    route: '/predictions',
    stage: NavigationIntentLifecycleStage.manage,
    surface: 'Admin gated',
    explanation: 'Cross-module portfolio drill-down into prediction exposure.',
  ),
  _intent(
    id: 'arena',
    module: NavigationIntentModule.crossModule,
    capability: 'Enterprise Cross-Module Intelligence',
    flow: 'Unified portfolio intelligence',
    screen: 'Arena',
    route: '/arena',
    stage: NavigationIntentLifecycleStage.manage,
    surface: 'Admin gated',
    explanation:
        'Cross-module portfolio drill-down into points-only Arena status.',
  ),
  _intent(
    id: 'dca',
    module: NavigationIntentModule.crossModule,
    capability: 'Enterprise Cross-Module Intelligence',
    flow: 'Unified portfolio intelligence',
    screen: 'DCA',
    route: '/dca',
    stage: NavigationIntentLifecycleStage.manage,
    surface: 'Admin gated',
    explanation:
        'Cross-module portfolio drill-down into automation strategies.',
  ),
];
