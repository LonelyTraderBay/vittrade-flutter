import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';

/// One Earn hub tool tile (label + route + icon key).
final class EarnHubTool {
  const EarnHubTool({
    required this.id,
    required this.label,
    required this.route,
    required this.iconKey,
  });

  final String id;
  final String label;
  final String route;
  final String iconKey;
}

/// Canonical Earn / Savings hub tool grids (STEP-P3.1 / P3.3).
abstract final class EarnHubToolsCatalog {
  static const stakingTools = <EarnHubTool>[
    EarnHubTool(
      id: 'analytics',
      label: 'Phân tích',
      route: AppRoutePaths.earnAnalytics,
      iconKey: 'analytics',
    ),
    EarnHubTool(
      id: 'calendar',
      label: 'Lịch lãi',
      route: AppRoutePaths.earnCalendar,
      iconKey: 'calendar',
    ),
    EarnHubTool(
      id: 'history',
      label: 'Lịch sử',
      route: AppRoutePaths.earnHistory,
      iconKey: 'history',
    ),
    EarnHubTool(
      id: 'guide',
      label: 'Hướng dẫn',
      route: AppRoutePaths.earnGuide,
      iconKey: 'guide',
    ),
    EarnHubTool(
      id: 'faq',
      label: 'FAQ',
      route: AppRoutePaths.earnFAQ,
      iconKey: 'faq',
    ),
    EarnHubTool(
      id: 'recommendations',
      label: 'Gợi ý',
      route: AppRoutePaths.earnRecommendations,
      iconKey: 'recommendations',
    ),
    EarnHubTool(
      id: 'notifications',
      label: 'Thông báo',
      route: AppRoutePaths.earnNotifications,
      iconKey: 'notifications',
    ),
    EarnHubTool(
      id: 'staking',
      label: 'Stake',
      route: AppRoutePaths.earnStaking,
      iconKey: 'staking',
    ),
  ];

  static const savingsTools = <EarnHubTool>[
    EarnHubTool(
      id: 'analytics',
      label: 'Phân tích',
      route: AppRoutePaths.earnSavingsAnalytics,
      iconKey: 'analytics',
    ),
    EarnHubTool(
      id: 'autopilot',
      label: 'Autopilot',
      route: AppRoutePaths.earnSavingsAutoPilot,
      iconKey: 'autopilot',
    ),
    EarnHubTool(
      id: 'backtest',
      label: 'Mô phỏng',
      route: AppRoutePaths.earnSavingsBacktest,
      iconKey: 'backtest',
    ),
    EarnHubTool(
      id: 'comparison',
      label: 'So sánh',
      route: AppRoutePaths.earnSavingsComparison,
      iconKey: 'comparison',
    ),
    EarnHubTool(
      id: 'export',
      label: 'Xuất báo cáo',
      route: AppRoutePaths.earnSavingsExport,
      iconKey: 'export',
    ),
    EarnHubTool(
      id: 'faq',
      label: 'FAQ',
      route: AppRoutePaths.earnSavingsFAQ,
      iconKey: 'faq',
    ),
    EarnHubTool(
      id: 'goals',
      label: 'Mục tiêu',
      route: AppRoutePaths.earnSavingsGoals,
      iconKey: 'goals',
    ),
    EarnHubTool(
      id: 'guide',
      label: 'Hướng dẫn',
      route: AppRoutePaths.earnSavingsGuide,
      iconKey: 'guide',
    ),
    EarnHubTool(
      id: 'history',
      label: 'Lịch sử',
      route: AppRoutePaths.earnSavingsHistory,
      iconKey: 'history',
    ),
    EarnHubTool(
      id: 'ladder',
      label: 'Thang lãi',
      route: AppRoutePaths.earnSavingsLadder,
      iconKey: 'ladder',
    ),
    EarnHubTool(
      id: 'notifications',
      label: 'Thông báo',
      route: AppRoutePaths.earnSavingsNotifications,
      iconKey: 'notifications',
    ),
    EarnHubTool(
      id: 'rebalance',
      label: 'Tái cân bằng',
      route: AppRoutePaths.earnSavingsRebalance,
      iconKey: 'rebalance',
    ),
    EarnHubTool(
      id: 'recommendations',
      label: 'Khuyến nghị',
      route: AppRoutePaths.earnSavingsRecommendations,
      iconKey: 'recommendations',
    ),
    EarnHubTool(
      id: 'smart-suggestions',
      label: 'Gợi ý',
      route: AppRoutePaths.earnSavingsSmartSuggestions,
      iconKey: 'smart-suggestions',
    ),
    EarnHubTool(
      id: 'what-if',
      label: 'What-if',
      route: AppRoutePaths.earnSavingsWhatIf,
      iconKey: 'what-if',
    ),
  ];
}
