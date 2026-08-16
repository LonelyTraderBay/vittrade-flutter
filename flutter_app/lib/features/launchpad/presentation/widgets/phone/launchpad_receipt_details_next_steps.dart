part of '../../phone/pages/hub/launchpad_receipt_page.dart';

class _ProjectReceiptCard extends StatelessWidget {
  const _ProjectReceiptCard({required this.subscription, required this.status});

  final LaunchpadSubscriptionDraft subscription;
  final _StatusStyle status;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      borderColor: AppModuleAccents.launchpad.withValues(alpha: .20),
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      child: Row(
        children: [
          SizedBox.square(
            dimension: LaunchpadSpacingTokens.launchpadBox48,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: subscription.accent.resolve().withValues(alpha: .12),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadii.lgRadius,
                  side: BorderSide(
                    color: subscription.accent.resolve().withValues(alpha: .35),
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  subscription.projectLogo,
                  style: AppTextStyles.caption.copyWith(
                    color: subscription.accent.resolve(),
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subscription.projectName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  '\$${subscription.projectSymbol}',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          VitStatusPill(
            label: status.label,
            status: _receiptPillStatus(status),
            size: VitStatusPillSize.sm,
          ),
        ],
      ),
    );
  }
}

class _ReceiptDetailsCard extends StatelessWidget {
  const _ReceiptDetailsCard({required this.subscription, required this.status});

  final LaunchpadSubscriptionDraft subscription;
  final _StatusStyle status;

  @override
  Widget build(BuildContext context) {
    final rows = [
      _ReceiptRowDraft('Mã đăng ký', subscription.id, isMono: true),
      _ReceiptRowDraft('Thời gian', subscription.timestamp),
      _ReceiptRowDraft(
        'Số tiền',
        '${_formatUsd(subscription.amount)} USDT',
        isMono: true,
        isStrong: true,
      ),
      _ReceiptRowDraft(
        'Dự kiến nhận',
        '${_formatInt(subscription.tokensAllocated)} ${subscription.projectSymbol}',
        isMono: true,
      ),
      _ReceiptRowDraft('Trạng thái', status.label, color: status.color),
      _ReceiptRowDraft('Mở khóa tiếp theo', subscription.nextUnlockDate),
    ];

    return VitCard(
      radius: VitCardRadius.large,
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Chi tiết đơn đăng ký',
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (final row in rows) _ReceiptInfoRow(row: row),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Mã giao dịch',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ),
              InkWell(
                borderRadius: AppRadii.smRadius,
                onTap: () {
                  unawaited(
                    Clipboard.setData(ClipboardData(text: subscription.txHash)),
                  );
                  unawaited(HapticFeedback.selectionClick());
                },
                child: Padding(
                  padding: LaunchpadSpacingTokens.launchpadInlinePillPadding,
                  child: Row(
                    children: [
                      Text(
                        subscription.txHash,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x2),
                      const Icon(
                        Icons.copy_rounded,
                        color: AppColors.text3,
                        size: AppSpacing.iconSm,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReceiptInfoRow extends StatelessWidget {
  const _ReceiptInfoRow({required this.row});

  final _ReceiptRowDraft row;

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
                style: AppTextStyles.caption.copyWith(
                  color:
                      row.color ??
                      (row.isStrong ? AppColors.text1 : AppColors.text2),
                  fontWeight: row.isStrong
                      ? AppTextStyles.bold
                      : AppTextStyles.medium,
                  fontFeatures: row.isMono
                      ? AppTextStyles.tabularFigures
                      : null,
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: AppSpacing.dividerHairline,
          thickness: AppSpacing.dividerHairline,
          color: AppColors.divider,
        ),
      ],
    );
  }
}

class _ReceiptNextSteps extends StatelessWidget {
  const _ReceiptNextSteps();

  static const _steps = [
    'Đơn đăng ký đã được ghi nhận thành công.',
    'Token sẽ được phân bổ theo tỷ lệ sau khi kết thúc vòng mở bán.',
    'Phần USDT không được phân bổ sẽ được hoàn trả tự động.',
    'Theo dõi lịch mở khóa trong tab Danh mục.',
  ];

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                color: AppModuleAccents.launchpad,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Tiếp theo là gì?',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (var i = 0; i < _steps.length; i++)
            Padding(
              padding: i == 0
                  ? AppSpacing.zeroInsets
                  : LaunchpadSpacingTokens.launchpadTopPaddingX2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: AppSpacing.x5,
                    child: Text(
                      '${i + 1}.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppModuleAccents.launchpad,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _steps[i],
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: LaunchpadSpacingTokens.launchpadLineHeightShort,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ReceiptDisclosure extends StatelessWidget {
  const _ReceiptDisclosure();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.info_outline_rounded,
          color: AppColors.text3,
          size: AppSpacing.iconSm,
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            'Phân bổ thực tế có thể khác dự kiến nếu tổng đăng ký vượt trần huy động. Hiệu suất quá khứ không đảm bảo kết quả tương lai.',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: LaunchpadSpacingTokens.launchpadLineHeightShort,
            ),
          ),
        ),
      ],
    );
  }
}

VitStatusPillStatus _receiptPillStatus(_StatusStyle status) {
  return switch (status.label) {
    'Chờ phân bổ' => VitStatusPillStatus.warning,
    'Đã phân bổ' => VitStatusPillStatus.success,
    'Phân bổ 1 phần' => VitStatusPillStatus.info,
    'Đã nhận' => VitStatusPillStatus.success,
    'Đã hoàn tiền' => VitStatusPillStatus.neutral,
    _ => VitStatusPillStatus.neutral,
  };
}

final class _ReceiptRowDraft {
  const _ReceiptRowDraft(
    this.label,
    this.value, {
    this.isMono = false,
    this.isStrong = false,
    this.color,
  });

  final String label;
  final String value;
  final bool isMono;
  final bool isStrong;
  final Color? color;
}

final class _StatusStyle {
  const _StatusStyle({required this.label, required this.color});

  final String label;
  final Color color;
}

_StatusStyle _statusStyle(LaunchpadSubscriptionStatus status) {
  return switch (status) {
    LaunchpadSubscriptionStatus.pending => const _StatusStyle(
      label: 'Chờ phân bổ',
      color: AppColors.warn,
    ),
    LaunchpadSubscriptionStatus.allocated => const _StatusStyle(
      label: 'Đã phân bổ',
      color: AppColors.buy,
    ),
    LaunchpadSubscriptionStatus.partiallyAllocated => const _StatusStyle(
      label: 'Phân bổ 1 phần',
      color: AppColors.primary,
    ),
    LaunchpadSubscriptionStatus.claimed => const _StatusStyle(
      label: 'Đã nhận',
      color: AppColors.buy,
    ),
    LaunchpadSubscriptionStatus.refunded => const _StatusStyle(
      label: 'Đã hoàn tiền',
      color: AppColors.text2,
    ),
  };
}

String _formatUsd(double value) => '\$${_withCommas(value.toStringAsFixed(2))}';

String _formatInt(int value) => _withCommas(value.toString());

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
