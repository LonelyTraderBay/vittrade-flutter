part of '../../phone/pages/payment/p2p_payment_method_verification_page.dart';

class _VerificationFlow extends StatelessWidget {
  const _VerificationFlow({
    required this.snapshot,
    required this.methodId,
    required this.controller,
    required this.submitting,
    required this.onChanged,
    required this.onSubmit,
  });

  final P2PPaymentMethodVerificationSnapshot snapshot;
  final String methodId;
  final TextEditingController controller;
  final bool submitting;
  final VoidCallback onChanged;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    final method = snapshot.methods.firstWhere(
      (item) => item.id == methodId,
      orElse: () => snapshot.methods.first,
    );
    if (methodId != 'micro_deposit') {
      return _ManualVerificationPending(method: method);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CenteredMethodIntro(method: method),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        VitCard(
          padding: P2PSpacingTokens.p2pPaymentCardPadding,
          child: Column(
            children: [
              for (var i = 0; i < snapshot.microDepositSteps.length; i++) ...[
                _StepRow(index: i + 1, text: snapshot.microDepositSteps[i]),
                if (i != snapshot.microDepositSteps.length - 1)
                  const SizedBox(height: AppSpacing.rowGap),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        VitInput(
          controller: controller,
          fieldKey: P2PPaymentMethodVerificationPage.codeFieldKey,
          label: 'Số tiền nhận được (VND)',
          hintText: 'Nhập số tiền (VD: 1 hoặc 2)',
          prefix: const Icon(Icons.payments_outlined),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        VitCtaButton(
          key: P2PPaymentMethodVerificationPage.submitButtonKey,
          loading: submitting,
          onPressed: onSubmit,
          leading: const Icon(Icons.check_circle_outline_rounded),
          child: const Text('Xác nhận số tiền'),
        ),
      ],
    );
  }
}

class _CenteredMethodIntro extends StatelessWidget {
  const _CenteredMethodIntro({required this.method});

  final P2PPaymentVerificationMethodDraft method;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Material(
          color: AppColors.primary12,
          shape: CircleBorder(),
          child: SizedBox(
            width: P2PSpacingTokens.p2pPaymentVerificationIntroIconBox,
            height: P2PSpacingTokens.p2pPaymentVerificationIntroIconBox,
            child: Icon(
              Icons.credit_card_rounded,
              color: AppColors.primary,
              size: P2PSpacingTokens.p2pPaymentVerificationIntroIcon,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        Text(
          'Xác minh qua ${method.label}',
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle.copyWith(color: AppColors.text1),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          'Chúng tôi sẽ gửi 1-2 VND vào tài khoản của bạn',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _ManualVerificationPending extends StatelessWidget {
  const _ManualVerificationPending({required this.method});

  final P2PPaymentVerificationMethodDraft method;

  @override
  Widget build(BuildContext context) {
    return VitEmptyState(
      icon: method.iconKey == 'camera'
          ? Icons.photo_camera_outlined
          : Icons.upload_file_rounded,
      title: method.label,
      message:
          'Luồng ${method.label} sẽ dùng bộ tải tài liệu đã xác minh KYC. Vui lòng dùng Micro-deposit cho bản mock hiện tại.',
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.index, required this.text});

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: AppColors.primary12,
          shape: const CircleBorder(),
          child: SizedBox(
            width: P2PSpacingTokens.p2pPaymentVerificationStepDot,
            height: P2PSpacingTokens.p2pPaymentVerificationStepDot,
            child: Center(
              child: Text(
                '$index',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.primary,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
      ],
    );
  }
}

class _MethodIcon extends StatelessWidget {
  const _MethodIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary12,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      child: SizedBox(
        width: AppSpacing.x6,
        height: AppSpacing.x6,
        child: Icon(icon, color: AppModuleAccents.p2p, size: AppSpacing.iconMd),
      ),
    );
  }
}

class _WarningNote extends StatelessWidget {
  const _WarningNote({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      padding: P2PSpacingTokens.p2pPaymentCompactCardPadding,
      borderColor: AppColors.warningBorder,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              note,
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}
