import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';

/// Cross-product Earn navigation contracts (ADR-011).
///
/// Siblings must not import each other; use these paths for hub bridges
/// (e.g. Staking hub CTA to Savings).
abstract final class EarnHubNavigation {
  static const String stakingHub = AppRoutePaths.earn;
  static const String stakingAlias = AppRoutePaths.earnStaking;
  static const String savingsHub = AppRoutePaths.earnSavings;
  static const String savingsPortfolio = AppRoutePaths.earnSavingsPortfolio;
}
