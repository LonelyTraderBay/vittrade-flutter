part of '../../phone/pages/complaints/complaint_submission_page.dart';

class _SubmissionFooter extends StatelessWidget {
  const _SubmissionFooter({required this.enabled, required this.onSubmit});

  final bool enabled;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      height: _submissionFooterHeight,
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.complaintSubmissionFooterPadding,
      borderColor: _submissionBorder.withValues(alpha: .35),
      child: VitCtaButton(
        key: ComplaintSubmissionPage.submitKey,
        onPressed: enabled ? onSubmit : null,
        variant: VitCtaButtonVariant.primary,
        density: VitDensity.tool,
        leading: const Icon(Icons.chat_bubble_outline_rounded),
        child: const Text('Submit Complaint'),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.navLabel.copyWith(
        color: AppColors.text2,
        height: _submissionLineTight,
      ),
    );
  }
}

final OutlineInputBorder _inputBorder = OutlineInputBorder(
  borderRadius: AppRadii.smRadius,
  borderSide: BorderSide(color: _submissionBorder.withValues(alpha: .76)),
);
