part of '../../phone/pages/hub/p2p_home_page.dart';

final List<({String id, String label, IconData icon, String route})>
_p2pHomeTools = [
  const (
    id: 'express',
    label: 'Express nhanh',
    icon: Icons.bolt_rounded,
    route: AppRoutePaths.p2pExpress,
  ),
  const (
    id: 'dashboard',
    label: 'Bảng điều khiển',
    icon: Icons.dashboard_customize_outlined,
    route: AppRoutePaths.p2pDashboard,
  ),
  const (
    id: 'guide',
    label: 'Hướng dẫn',
    icon: Icons.help_outline_rounded,
    route: AppRoutePaths.p2pGuide,
  ),
  const (
    id: 'compliance_overview',
    label: 'Tuân thủ tổng quan',
    icon: Icons.fact_check_outlined,
    route: AppRoutePaths.p2pComplianceOverview,
  ),
  const (
    id: 'insurance_contribution_history',
    label: 'Đóng góp bảo hiểm',
    icon: Icons.shield_outlined,
    route: AppRoutePaths.p2pContributionHistory,
  ),
  const (
    id: 'payment_method_history',
    label: 'Lịch sử phương thức',
    icon: Icons.account_balance_outlined,
    route: AppRoutePaths.p2pPaymentMethodHistory,
  ),
  const (
    id: 'security_login_history',
    label: 'Lịch sử đăng nhập',
    icon: Icons.manage_history_rounded,
    route: AppRoutePaths.p2pSecurityLoginHistory,
  ),
  const (
    id: 'notifications',
    label: 'Thông báo P2P',
    icon: Icons.notifications_none_rounded,
    route: AppRoutePaths.p2pSettingsNotifications,
  ),
  const (
    id: 'fund_lock_history',
    label: 'Lịch sử khóa quỹ',
    icon: Icons.lock_clock_outlined,
    route: AppRoutePaths.p2pWalletFundLockHistory,
  ),
  const (
    id: 'wallet_history',
    label: 'Lịch sử ví P2P (alias)',
    icon: Icons.account_balance_wallet_outlined,
    route: AppRoutePaths.p2pWalletHistory,
  ),
  (
    id: 'ad_analytics',
    label: 'Phân tích tin',
    icon: Icons.analytics_outlined,
    route: AppRoutePaths.p2pAdAnalytics('sample'),
  ),
];

class _P2PHomeToolsSheet extends StatelessWidget {
  const _P2PHomeToolsSheet({required this.onNavigate});

  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return VitSheetPanel(
      key: P2PHomePage.toolsSheetKey,
      title: 'Công cụ P2P',
      child: VitActionTileGrid(
        density: VitDensity.compact,
        crossAxisSpacing: AppSpacing.x3,
        mainAxisSpacing: AppSpacing.x3,
        physics: const ClampingScrollPhysics(),
        itemCount: _p2pHomeTools.length,
        itemBuilder: (context, index, density) {
          final tool = _p2pHomeTools[index];
          return VitServiceTile(
            key: P2PHomePage.toolKey(tool.id),
            density: density,
            icon: tool.icon,
            label: tool.label,
            accentColor: AppModuleAccents.p2p,
            onTap: () => onNavigate(tool.route),
          );
        },
      ),
    );
  }
}
