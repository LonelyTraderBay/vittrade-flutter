part of '../../phone/pages/tools/launchpad_multisig_page.dart';

class _SafeSelector extends StatelessWidget {
  const _SafeSelector({
    required this.safes,
    required this.selectedAddress,
    required this.onChanged,
  });

  final List<LaunchpadMultisigSafeDraft> safes;
  final String selectedAddress;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: LaunchpadMultisigPage.safeSelectorKey,
      padding: LaunchpadSpacingTokens.launchpadHeaderStatsPadding,
      child: Row(
        children: [
          for (final safe in safes) ...[
            Expanded(
              child: VitCard(
                key: LaunchpadMultisigPage.safeKey(safe.address),
                variant: selectedAddress == safe.address
                    ? VitCardVariant.standard
                    : VitCardVariant.inner,
                borderColor: selectedAddress == safe.address
                    ? AppModuleAccents.launchpad.withValues(alpha: .34)
                    : AppColors.cardBorder,
                padding: LaunchpadSpacingTokens.launchpadPaddingX3,
                onTap: () => onChanged(safe.address),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        VitAccentIconBox(
                          icon: Icons.shield_outlined,
                          color: selectedAddress == safe.address
                              ? AppModuleAccents.launchpad
                              : safe.accent.resolve(),
                          iconSize:
                              LaunchpadSpacingTokens.launchpadIcon5xl * .45,
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Expanded(
                          child: Text(
                            safe.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Row(
                      children: [
                        Text(
                          safe.chain,
                          style: AppTextStyles.micro.copyWith(
                            color: safe.accent.resolve(),
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Text(
                          '${safe.threshold}/${safe.owners.length}',
                          style: AppTextStyles.numericMicro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      safe.balance,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (safe != safes.last) const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _StatsStrip extends StatelessWidget {
  const _StatsStrip({required this.safe, required this.pending});

  final LaunchpadMultisigSafeDraft safe;
  final int pending;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: LaunchpadMultisigPage.statsKey,
      padding: LaunchpadSpacingTokens.launchpadStatsStripPadding,
      child: Row(
        children: [
          Expanded(
            child: _StatTile(
              label: 'Ngưỡng',
              value: '${safe.threshold}/${safe.owners.length}',
              color: AppModuleAccents.launchpad,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: _StatTile(
              label: 'Đang chờ',
              value: '$pending',
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: _StatTile(
              label: 'Tổng tx',
              value: '${safe.txCount}',
              color: AppColors.buy,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      borderColor: color.withValues(alpha: .22),
      background: ColoredBox(color: color.withValues(alpha: .08)),
      padding: LaunchpadSpacingTokens.launchpadVerticalPaddingX2,
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.numericCode.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              height: LaunchpadSpacingTokens.launchpadLineHeightTight,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: LaunchpadSpacingTokens.launchpadLineHeightShort,
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurityNotice extends StatelessWidget {
  const _SecurityNotice({required this.safe});

  final LaunchpadMultisigSafeDraft safe;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadMultisigPage.noticeKey,
      variant: VitCardVariant.inner,
      borderColor: AppModuleAccents.launchpad.withValues(alpha: .24),
      background: const ColoredBox(color: AppColors.accent08),
      padding: LaunchpadSpacingTokens.launchpadPaddingX3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lock_outline_rounded,
            color: AppModuleAccents.launchpad,
            size: LaunchpadSpacingTokens.launchpadIconLg,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Multi-sig yêu cầu ${safe.threshold}/${safe.owners.length} chữ ký trước khi thực hiện. Mỗi giao dịch có thời hạn 7 ngày. Đảm bảo tất cả signers xác nhận trước khi hết hạn.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: LaunchpadSpacingTokens.launchpadLineHeightShort,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
