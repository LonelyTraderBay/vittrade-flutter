part of '../../phone/pages/settings/bot_faq_page.dart';

class _HelpCard extends StatelessWidget {
  const _HelpCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: TradeSpacingTokens.tradeBotCompactCardPadding,
      borderColor: _faqPrimary.withValues(alpha: .25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Vẫn cần trợ giúp?',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            'Không tìm thấy câu trả lời? Đội ngũ hỗ trợ của chúng tôi luôn sẵn sàng 24/7.',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          const Row(
            children: [
              Expanded(
                child: _HelpButton(
                  label: 'Trò chuyện trực tiếp',
                  variant: VitCtaButtonVariant.secondary,
                ),
              ),
              SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _HelpButton(
                  label: 'Liên hệ hỗ trợ',
                  variant: VitCtaButtonVariant.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HelpButton extends StatelessWidget {
  const _HelpButton({required this.label, required this.variant});

  final String label;
  final VitCtaButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      height: AppSpacing.buttonCompact,
      density: VitDensity.tool,
      variant: variant,
      onPressed: () => _showComingSoon(context),
      padding: TradeSpacingTokens.tradeBotChipPadding,
      child: Text(label),
    );
  }

  void _showComingSoon(BuildContext context) {
    unawaited(HapticFeedback.selectionClick());
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: label,
        message: '$label sẽ sớm ra mắt',
      ),
    );
  }
}

class _EmptyFaqs extends StatelessWidget {
  const _EmptyFaqs();

  @override
  Widget build(BuildContext context) {
    return const VitEmptyState(
      title: 'Không tìm thấy câu hỏi thường gặp',
      icon: Icons.help_outline_rounded,
    );
  }
}
