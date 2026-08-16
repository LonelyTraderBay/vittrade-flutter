part of '../../phone/pages/merchant/p2p_selfie_verification_page.dart';

class _LivenessActionTile extends StatelessWidget {
  const _LivenessActionTile({required this.action, required this.completed});

  final P2PSelfieLivenessActionDraft action;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.standard,
      variant: completed ? VitCardVariant.inner : VitCardVariant.ghost,
      borderColor: completed ? AppColors.buy20 : AppColors.cardBorder,
      padding: P2PSpacingTokens.p2pSelfieReviewPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _livenessIcon(action.iconKey),
            color: completed ? AppColors.buy : AppColors.text3,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(height: _p2pSelfieSectionGap),
          Text(
            action.label,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: completed ? AppColors.buy : AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          if (completed) ...[
            const SizedBox(height: _p2pSelfieTightGap),
            const Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.buy,
              size: AppSpacing.iconSm,
            ),
          ],
        ],
      ),
    );
  }
}

class _ResultStep extends StatelessWidget {
  const _ResultStep({
    required this.snapshot,
    required this.onComplete,
    required this.onSupport,
  });

  final P2PSelfieVerificationSnapshot snapshot;
  final VoidCallback onComplete;
  final VoidCallback onSupport;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PSelfieVerificationPage.resultKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: P2PSpacingTokens.p2pSelfieResultIconMargin,
          child: SizedBox.square(
            dimension: _p2pSelfieActionIconBox,
            child: Material(
              color: AppColors.buy10,
              shape: CircleBorder(),
              child: Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.buy,
                size: AppSpacing.iconLg,
              ),
            ),
          ),
        ),
        Text(
          'Xác minh thành công!',
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle.copyWith(color: AppColors.buy),
        ),
        const SizedBox(height: _p2pSelfieSectionGap),
        Text(
          'Khuôn mặt của bạn đã được xác minh',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: _p2pSelfieMajorGap),
        VitCard(
          radius: VitCardRadius.large,
          padding: P2PSpacingTokens.p2pSelfieCardPadding,
          child: Column(
            children: [
              _ScoreRow(label: 'Face Match Score', value: snapshot.matchScore),
              const SizedBox(
                height: AppSpacing.dividerHairline,
                child: ColoredBox(color: AppColors.cardBorder),
              ),
              _ScoreRow(label: 'Liveness Score', value: snapshot.livenessScore),
            ],
          ),
        ),
        const SizedBox(height: _p2pSelfieMajorGap),
        VitCard(
          radius: VitCardRadius.standard,
          padding: P2PSpacingTokens.p2pSelfieCardPadding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.verified_user_outlined,
                color: AppModuleAccents.p2p,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Dữ liệu biometric được mã hóa và xóa sau khi xác minh. Chúng tôi không lưu trữ ảnh selfie của bạn.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: _p2pSelfieBodyLineHeight,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: _p2pSelfieMajorGap),
        VitCtaButton(
          key: P2PSelfieVerificationPage.completeKey,
          onPressed: onComplete,
          trailing: const Icon(Icons.chevron_right_rounded),
          child: const Text('Hoàn tất'),
        ),
        const SizedBox(height: _p2pSelfieSectionGap),
        VitCtaButton(
          onPressed: onSupport,
          variant: VitCtaButtonVariant.secondary,
          height: AppSpacing.buttonCompact,
          padding: P2PSpacingTokens.p2pPaymentDialogActionPadding,
          child: const Text('Liên hệ hỗ trợ'),
        ),
      ],
    );
  }
}

class _ScoreRow extends StatelessWidget {
  const _ScoreRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: P2PSpacingTokens.p2pSelfieScoreRowPadding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.buy,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  const _ChecklistRow({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: P2PSpacingTokens.p2pSelfieChecklistIconPadding,
          child: Icon(
            color == AppColors.warn
                ? Icons.auto_awesome_rounded
                : Icons.check_circle_outline_rounded,
            color: color,
            size: P2PSpacingTokens.p2pSelfieChecklistIconSize,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: _p2pSelfieBodyLineHeight,
            ),
          ),
        ),
      ],
    );
  }
}

IconData _livenessIcon(String iconKey) {
  return switch (iconKey) {
    'smile' => Icons.sentiment_satisfied_alt_rounded,
    'blink' => Icons.visibility_outlined,
    'turn_left' => Icons.keyboard_arrow_left_rounded,
    'turn_right' => Icons.keyboard_arrow_right_rounded,
    _ => Icons.face_retouching_natural_outlined,
  };
}
