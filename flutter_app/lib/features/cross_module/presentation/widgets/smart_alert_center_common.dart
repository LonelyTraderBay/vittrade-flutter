part of '../phone/pages/smart_alert_center_page.dart';

final class _ModuleVisual {
  const _ModuleVisual({
    required this.icon,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final Color color;
  final Color background;
}

_ModuleVisual _moduleVisual(SmartAlertModuleId module) {
  return switch (module) {
    SmartAlertModuleId.trading => const _ModuleVisual(
      icon: Icons.trending_up_rounded,
      color: AppColors.buy,
      background: AppColors.buy10,
    ),
    SmartAlertModuleId.p2p => const _ModuleVisual(
      icon: Icons.shopping_cart_outlined,
      color: AppModuleAccents.p2p,
      background: AppColors.warn10,
    ),
    SmartAlertModuleId.predictions => const _ModuleVisual(
      icon: Icons.track_changes_rounded,
      color: AppModuleAccents.predictions,
      background: AppColors.accent10,
    ),
    SmartAlertModuleId.arena => const _ModuleVisual(
      icon: Icons.bolt_rounded,
      color: AppModuleAccents.arena,
      background: AppColors.warn10,
    ),
    SmartAlertModuleId.dca => const _ModuleVisual(
      icon: Icons.show_chart_rounded,
      color: AppColors.primary,
      background: AppColors.primary12,
    ),
    SmartAlertModuleId.wallet => const _ModuleVisual(
      icon: Icons.account_balance_wallet_outlined,
      color: AppModuleAccents.wallet,
      background: AppColors.primary15,
    ),
  };
}
