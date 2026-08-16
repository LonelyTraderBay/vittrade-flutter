part of '../../phone/pages/security/p2p_login_history_page.dart';

class _LoginStats extends StatelessWidget {
  const _LoginStats({required this.snapshot});

  final P2PLoginHistorySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: P2PLoginHistoryPage.statsKey,
      children: [
        Expanded(
          child: _StatTile(
            icon: Icons.shield_outlined,
            value: '${snapshot.events.length}',
            label: 'Tổng số',
            color: AppModuleAccents.p2p,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _StatTile(
            icon: Icons.check_circle_outline_rounded,
            value: '${snapshot.successCount}',
            label: 'Thành công',
            color: AppColors.buy,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _StatTile(
            icon: Icons.warning_amber_rounded,
            value: '${snapshot.riskEventCount}',
            label: 'Đáng ngờ',
            color: AppColors.warn,
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x2,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox.square(
            dimension: AppSpacing.buttonCompact,
            child: Material(
              type: MaterialType.transparency,
              color: color.withValues(alpha: .12),
              borderRadius: AppRadii.lgRadius,
              child: Icon(icon, color: color, size: AppSpacing.iconMd),
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _RiskWarning extends StatelessWidget {
  const _RiskWarning({required this.snapshot});

  final P2PLoginHistorySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: P2PLoginHistoryPage.warningKey,
      type: MaterialType.transparency,
      color: AppColors.warn10,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadii.lgRadius,
        side: BorderSide(color: AppColors.warningBorder),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.all(AppSpacing.x2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warn,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Phát hiện ${snapshot.riskEventCount} đăng nhập đáng ngờ',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.warn,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    snapshot.warningBody,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
