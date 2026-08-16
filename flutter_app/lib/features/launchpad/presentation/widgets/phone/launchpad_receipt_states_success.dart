part of '../../phone/pages/hub/launchpad_receipt_page.dart';

class _ReceiptErrorState extends StatelessWidget {
  const _ReceiptErrorState();

  @override
  Widget build(BuildContext context) {
    return const VitErrorState(
      key: LaunchpadReceiptPage.errorKey,
      title: 'Không tải được dữ liệu',
      message: 'Vui lòng kiểm tra kết nối mạng và thử lại.',
      icon: Icons.error_outline_rounded,
    );
  }
}

List<Widget> _receiptSuccessChildren(
  BuildContext context,
  LaunchpadReceiptSnapshot snapshot,
) {
  final subscription = snapshot.subscription!;
  final status = _statusStyle(subscription.status);

  return [
    _SuccessHero(subscription: subscription),
    _ProjectReceiptCard(subscription: subscription, status: status),
    _ReceiptDetailsCard(subscription: subscription, status: status),
    VitHighRiskStatePanel(
      state: VitHighRiskUiState.success,
      title: 'Đã rà soát biên lai',
      message:
          'Phí, giới hạn, rủi ro phân bổ, bước tiếp theo và hoàn tiền vẫn gắn với biên lai này.',
      contractId: subscription.id,
    ),
    const _ReceiptNextSteps(),
    const _ReceiptDisclosure(),
    Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCtaButton(
          key: LaunchpadReceiptPage.portfolioButtonKey,
          onPressed: () => context.go(snapshot.portfolioRoute),
          leading: const Icon(Icons.business_center_outlined),
          child: const Text('Xem danh mục'),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        VitCtaButton(
          key: LaunchpadReceiptPage.launchpadButtonKey,
          variant: VitCtaButtonVariant.secondary,
          onPressed: () => context.go(snapshot.launchpadRoute),
          child: const Text('Quay lại Launchpad'),
        ),
      ],
    ),
  ];
}

class _SuccessHero extends StatelessWidget {
  const _SuccessHero({required this.subscription});

  final LaunchpadSubscriptionDraft subscription;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox.square(
          dimension: LaunchpadSpacingTokens.launchpadBox48,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: AppColors.buy15,
              shape: CircleBorder(
                side: BorderSide(color: AppColors.buy.withValues(alpha: .30)),
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.buy,
                size: AppSpacing.iconLg,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        Text(
          'Đăng ký thành công!',
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Text(
          'Đơn đăng ký ${subscription.projectSymbol} đã được ghi nhận. Token sẽ được phân bổ sau khi kết thúc.',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            height: LaunchpadSpacingTokens.launchpadLineHeightShort,
          ),
        ),
      ],
    );
  }
}
