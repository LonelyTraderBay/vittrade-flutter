part of '../../phone/pages/claim/launchpad_claim_receipt_page.dart';

class _RiskDisclosureTile extends StatelessWidget {
  const _RiskDisclosureTile();

  @override
  Widget build(BuildContext context) {
    return const VitInfoCallout(
      icon: Icons.warning_amber_rounded,
      accentColor: AppColors.warn,
      iconSize: AppSpacing.iconSm,
      message: 'Lưu ý rủi ro đầu tư',
      messageColor: AppColors.warn,
      messageWeight: AppTextStyles.bold,
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: AppColors.text3,
        size: AppSpacing.iconMd,
      ),
    );
  }
}

class _HistoryEntry extends StatelessWidget {
  const _HistoryEntry({required this.entry});

  final LaunchpadClaimHistoryEntryDraft entry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: LaunchpadSpacingTokens.launchpadBottomPaddingX3,
      child: VitCard(
        key: LaunchpadClaimReceiptPage.historyKey(entry.id),
        radius: VitCardRadius.standard,
        padding: LaunchpadSpacingTokens.launchpadPaddingX4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  color: AppColors.buy,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    '+${_formatNumber(entry.amount)} ${entry.token}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                Text(
                  _formatUsd(entry.usdValue),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            Text(
              '${entry.claimedAt} · Gas: ${entry.gasUsed} · ${entry.txHash}',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    required this.suffix,
    required this.color,
  });

  final String label;
  final String value;
  final String suffix;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCardStat(
      padding: LaunchpadSpacingTokens.launchpadPaddingX3,
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          Text(
            suffix,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.row});

  final _DetailRow row;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: LaunchpadSpacingTokens.launchpadVerticalPaddingX2,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  row.label,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ),
              Text(
                row.value,
                textAlign: TextAlign.right,
                style: AppTextStyles.caption.copyWith(
                  color: row.color ?? AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: AppSpacing.dividerHairline,
          color: AppColors.divider,
        ),
      ],
    );
  }
}

final class _DetailRow {
  const _DetailRow(this.label, this.value, {this.color});

  final String label;
  final String value;
  final Color? color;
}

enum _ClaimReceiptTab {
  overview('overview'),
  vesting('vesting'),
  history('history');

  const _ClaimReceiptTab(this.id);

  final String id;

  static _ClaimReceiptTab byId(String id) {
    return _ClaimReceiptTab.values.firstWhere(
      (tab) => tab.id == id,
      orElse: () => _ClaimReceiptTab.overview,
    );
  }
}

IconData _vestingIcon(LaunchpadVestingEntryStatus status) {
  return switch (status) {
    LaunchpadVestingEntryStatus.claimed => Icons.check_circle_outline_rounded,
    LaunchpadVestingEntryStatus.claimable => Icons.card_giftcard_rounded,
    LaunchpadVestingEntryStatus.unlocking => Icons.schedule_rounded,
    LaunchpadVestingEntryStatus.locked => Icons.lock_outline_rounded,
  };
}

Color _vestingColor(LaunchpadVestingEntryStatus status) {
  return switch (status) {
    LaunchpadVestingEntryStatus.claimed => AppColors.buy,
    LaunchpadVestingEntryStatus.claimable => AppColors.primary,
    LaunchpadVestingEntryStatus.unlocking => AppColors.warn,
    LaunchpadVestingEntryStatus.locked => AppColors.text3,
  };
}

String _vestingLabel(LaunchpadVestingEntryStatus status) {
  return switch (status) {
    LaunchpadVestingEntryStatus.claimed => 'Đã nhận',
    LaunchpadVestingEntryStatus.claimable => 'Nhận ngay',
    LaunchpadVestingEntryStatus.unlocking => 'Sắp mở',
    LaunchpadVestingEntryStatus.locked => 'Khóa',
  };
}

String _unlockStateText(String nextUnlockDate) {
  final trimmed = nextUnlockDate.trim();
  if (trimmed.isEmpty) return 'Chưa có lịch mở khóa';
  return trimmed;
}

VitStatusPillStatus _vestingPillStatus(LaunchpadVestingEntryStatus status) {
  return switch (status) {
    LaunchpadVestingEntryStatus.claimed => VitStatusPillStatus.success,
    LaunchpadVestingEntryStatus.claimable => VitStatusPillStatus.info,
    LaunchpadVestingEntryStatus.unlocking => VitStatusPillStatus.warning,
    LaunchpadVestingEntryStatus.locked => VitStatusPillStatus.neutral,
  };
}

String _truncateAddress(String value) => maskAddress(value);

String _formatUsd(double value) {
  final fixed = value < 1 ? value.toStringAsFixed(2) : value.toStringAsFixed(1);
  return '\$${_withCommas(_trimTrailingZero(fixed))}';
}

String _formatNumber(double value) {
  final fixed = value % 1 == 0
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(1);
  return _withCommas(_trimTrailingZero(fixed));
}

String _trimTrailingZero(String value) {
  return value.contains('.')
      ? value.replaceFirst(RegExp(r'\.?0+$'), '')
      : value;
}

String _withCommas(String value) {
  final parts = value.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  if (parts.length > 1) {
    buffer.write('.');
    buffer.write(parts.last);
  }
  return buffer.toString();
}
