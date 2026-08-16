part of '../../phone/pages/hub/predictions_breaking_page.dart';

class _EmailCta extends StatelessWidget {
  const _EmailCta({
    required this.controller,
    required this.subscribed,
    required this.onSubscribe,
  });

  final TextEditingController controller;
  final bool subscribed;
  final VoidCallback onSubscribe;

  @override
  Widget build(BuildContext context) {
    if (subscribed) {
      return VitCard(
        borderColor: AppColors.buy.withValues(alpha: .24),
        density: VitDensity.compact,
        padding: AppSpacing.cardPaddingCompact,
        child: Row(
          children: [
            Material(
              color: AppColors.buy.withValues(alpha: .12),
              borderRadius: AppRadii.mdRadius,
              child: const SizedBox.square(
                dimension: _breakingIconBox,
                child: Icon(
                  Icons.mail_outline_rounded,
                  color: AppColors.buy,
                  size: AppSpacing.x4,
                ),
              ),
            ),
            const SizedBox(width: _breakingSpace),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Đã đăng ký',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.buy,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  Text(
                    'Nhận cập nhật biến động hàng ngày',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return VitCard(
      borderColor: _emailPurple.withValues(alpha: .24),
      density: VitDensity.compact,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        children: [
          Row(
            children: [
              Material(
                color: _emailPurple.withValues(alpha: .13),
                borderRadius: AppRadii.mdRadius,
                child: const SizedBox.square(
                  dimension: _breakingIconBox,
                  child: Icon(
                    Icons.mail_outline_rounded,
                    color: _emailPurple,
                    size: AppSpacing.x4,
                  ),
                ),
              ),
              const SizedBox(width: _breakingSpace),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nhận cập nhật hàng ngày',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      'Biến động và thị trường xu hướng qua email',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: _breakingSpace),
          Row(
            children: [
              Expanded(
                child: VitInput(
                  fieldKey: PredictionsBreakingPage.emailFieldKey,
                  controller: controller,
                  keyboardType: TextInputType.emailAddress,
                  semanticLabel: 'Email đăng ký tin nóng dự đoán',
                  hintText: 'your@email.com',
                  textStyle: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                  ),
                ),
              ),
              const SizedBox(width: _breakingSpace),
              VitCtaButton(
                key: PredictionsBreakingPage.subscribeKey,
                onPressed: onSubscribe,
                fullWidth: false,
                height: _breakingCtaHeight,
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: AppSpacing.x3,
                ),
                child: const Text('Đăng ký'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BreakingEmptyState extends StatelessWidget {
  const _BreakingEmptyState({required this.onShowAll});

  final VoidCallback onShowAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PredictionsSpacingTokens.predictionEmptyStatePadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bolt_outlined,
            color: AppColors.text3.withValues(alpha: .40),
            size: PredictionsSpacingTokens.predictionHomeEmptyIcon,
          ),
          const SizedBox(height: _breakingSpace),
          Text(
            'Không có biến động trong danh mục này',
            style: AppTextStyles.body.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: _breakingTinySpace),
          Text(
            'Thử chọn danh mục khác hoặc xem tất cả sự kiện',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCtaButton(
            onPressed: onShowAll,
            variant: VitCtaButtonVariant.secondary,
            child: const Text('Xem tất cả'),
          ),
        ],
      ),
    );
  }
}

String _formatVolume(double value) {
  if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(1)}M';
  if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(0)}K';
  return '\$${value.toStringAsFixed(0)}';
}
