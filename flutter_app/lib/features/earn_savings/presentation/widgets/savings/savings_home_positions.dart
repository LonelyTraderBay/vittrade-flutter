part of '../../phone/pages/savings/savings_page.dart';

class _SavingsPositions extends StatelessWidget {
  const _SavingsPositions({required this.positions});

  final List<SavingsPositionDraft> positions;

  @override
  Widget build(BuildContext context) {
    if (positions.isEmpty) {
      return const VitEmptyState(
        icon: Icons.business_center_outlined,
        title: 'Chưa có đăng ký tiết kiệm',
        message: 'Sản phẩm bạn đã đăng ký sẽ hiển thị tại đây.',
      );
    }

    return Column(
      children: [
        for (final position in positions) ...[
          VitCard(
            radius: VitCardRadius.large,
            padding: EarnSpacingTokens.earnCardPaddingX4,
            child: Row(
              children: [
                _AssetBadge(
                  asset: position.asset,
                  color: _riskColor(position.riskLevel),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        position.product,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      Text(
                        '${position.amount} · APY ước tính ${position.apy}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  position.earned,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
          if (position != positions.last)
            const SizedBox(height: AppSpacing.rowGap),
        ],
      ],
    );
  }
}

class _AssetBadge extends StatelessWidget {
  const _AssetBadge({required this.asset, required this.color});

  final String asset;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color.withValues(alpha: 0.4)),
          borderRadius: AppRadii.mdRadius,
        ),
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Center(
          child: Text(
            asset.length > 3 ? asset.substring(0, 3) : asset,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: background,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      ),
      child: Padding(
        padding: EarnSpacingTokens.earnSmallPillPadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}
