part of '../../phone/pages/tools/launchpad_multisig_page.dart';

class _TxDetails extends StatelessWidget {
  const _TxDetails({
    required this.tx,
    required this.copiedField,
    required this.onCopy,
    this.onSign,
    this.onExecute,
  });

  final LaunchpadMultisigTxDraft tx;
  final String? copiedField;
  final void Function(String text, String field) onCopy;
  final VoidCallback? onSign;
  final VoidCallback? onExecute;

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Function', tx.functionName),
      ('Contract', tx.contractAddress),
      ('Value', tx.value),
      ('Gas', tx.estimatedGas),
      ('Created', tx.createdAt),
      ('Expires', tx.expiresAt),
      if (tx.executedAt != null) ('Executed', tx.executedAt!),
      if (tx.executeTxHash != null) ('Tx Hash', tx.executeTxHash!),
    ];
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(
            height: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
          Padding(
            padding: LaunchpadSpacingTokens.launchpadPaddingX3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  tx.description,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                for (final row in rows)
                  _DetailRow(
                    label: row.$1,
                    value: row.$2,
                    copied: copiedField == '${tx.id}_${row.$1}',
                    onCopy: row.$1 == 'Contract' || row.$1 == 'Tx Hash'
                        ? () => onCopy(row.$2, '${tx.id}_${row.$1}')
                        : null,
                  ),
                if (tx.params.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                  DecoratedBox(
                    decoration: const ShapeDecoration(
                      color: AppColors.surface2,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadii.inputRadius,
                      ),
                    ),
                    child: Padding(
                      padding: LaunchpadSpacingTokens.launchpadPaddingX2,
                      child: Column(
                        children: [
                          for (final entry in tx.params.entries)
                            _DetailRow(label: entry.key, value: entry.value),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  'Signers (${tx.signedCount}/${tx.threshold} required)',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x1),
                for (final signer in tx.signers) _SignerRow(signer: signer),
                if (tx.status == LaunchpadMultisigTxStatus.pendingSignatures &&
                    onSign != null) ...[
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  VitCtaButton(
                    key: LaunchpadMultisigPage.signKey,
                    variant: VitCtaButtonVariant.warning,
                    onPressed: onSign,
                    child: const Text('Ký giao dịch'),
                  ),
                ],
                if (tx.status == LaunchpadMultisigTxStatus.ready &&
                    onExecute != null) ...[
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  VitCtaButton(
                    key: LaunchpadMultisigPage.executeKey,
                    variant: VitCtaButtonVariant.success,
                    onPressed: onExecute,
                    child: const Text('Thực hiện giao dịch'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.copied = false,
    this.onCopy,
  });

  final String label;
  final String value;
  final bool copied;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: LaunchpadSpacingTokens.launchpadVerticalPaddingX1,
          child: Row(
            children: [
              Text(
                label,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
              if (onCopy != null)
                VitIconButton(
                  onPressed: onCopy,
                  icon: copied ? Icons.check_rounded : Icons.copy_rounded,
                  tooltip: 'Copy $label',
                  variant: copied
                      ? VitIconButtonVariant.success
                      : VitIconButtonVariant.transparent,
                  size: VitIconButtonSize.sm,
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

class _SignerRow extends StatelessWidget {
  const _SignerRow({required this.signer});

  final LaunchpadMultisigSignerDraft signer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: LaunchpadSpacingTokens.launchpadTopPaddingX1,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: signer.signed ? AppColors.buy10 : AppColors.surface2,
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadii.inputRadius,
          ),
        ),
        child: Padding(
          padding: LaunchpadSpacingTokens.launchpadInlinePillPadding,
          child: Row(
            children: [
              Icon(
                signer.signed
                    ? Icons.check_circle_outline_rounded
                    : Icons.schedule_rounded,
                color: signer.signed ? AppColors.buy : AppColors.text3,
                size: LaunchpadSpacingTokens.launchpadIconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                signer.label,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  signer.address,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              if (signer.signedAt != null)
                Text(
                  signer.signedAt!,
                  style: AppTextStyles.micro.copyWith(color: AppColors.buy),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
