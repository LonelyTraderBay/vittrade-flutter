part of '../../phone/pages/tools/launchpad_multisig_page.dart';

class _TxCard extends StatelessWidget {
  const _TxCard({
    required this.tx,
    required this.expanded,
    required this.copiedField,
    required this.onToggle,
    required this.onCopy,
    this.onSign,
    this.onExecute,
  });

  final LaunchpadMultisigTxDraft tx;
  final bool expanded;
  final String? copiedField;
  final VoidCallback onToggle;
  final void Function(String text, String field) onCopy;
  final VoidCallback? onSign;
  final VoidCallback? onExecute;

  @override
  Widget build(BuildContext context) {
    final status = _statusView(tx.status);
    return VitCard(
      key: LaunchpadMultisigPage.txKey(tx.id),
      clip: true,
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                SizedBox(
                  width: LaunchpadSpacingTokens.launchpadVerticalMarkerWidth,
                  child: ColoredBox(color: status.color),
                ),
                Expanded(
                  child: VitCard(
                    key: LaunchpadMultisigPage.txToggleKey(tx.id),
                    variant: VitCardVariant.ghost,
                    radius: VitCardRadius.standard,
                    padding: LaunchpadSpacingTokens.launchpadPaddingX3,
                    onTap: onToggle,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VitAccentIconBox(
                          icon: status.icon,
                          color: status.color,
                          iconSize:
                              LaunchpadSpacingTokens.launchpadIcon7xl * .45,
                        ),
                        const SizedBox(width: AppSpacing.x3),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: AppSpacing.x2,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    tx.label,
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.text1,
                                      fontWeight: AppTextStyles.bold,
                                    ),
                                  ),
                                  VitStatusPill(
                                    label: status.label,
                                    status: _statusPillStatus(tx.status),
                                    size: VitStatusPillSize.sm,
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.x1),
                              Row(
                                children: [
                                  Text(
                                    '${tx.signedCount}/${tx.threshold} signed',
                                    style: AppTextStyles.numericMicro.copyWith(
                                      color: AppColors.text3,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.x2),
                                  VitAccentPill(
                                    label: tx.chain,
                                    accentColor: tx.accent.resolve(),
                                  ),
                                  const SizedBox(width: AppSpacing.x2),
                                  Text(
                                    '#${tx.nonce}',
                                    style: AppTextStyles.numericMicro.copyWith(
                                      color: AppColors.text3,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: AppSpacing.pageRhythmCompactInnerGap,
                              ),
                              _SignatureProgress(tx: tx),
                            ],
                          ),
                        ),
                        Icon(
                          expanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: AppColors.text3,
                          size: LaunchpadSpacingTokens.launchpadIcon2xl,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (expanded)
            _TxDetails(
              tx: tx,
              copiedField: copiedField,
              onCopy: onCopy,
              onSign: onSign,
              onExecute: onExecute,
            ),
        ],
      ),
    );
  }
}

class _SignatureProgress extends StatelessWidget {
  const _SignatureProgress({required this.tx});

  final LaunchpadMultisigTxDraft tx;

  @override
  Widget build(BuildContext context) {
    final ratio = tx.signers.isEmpty ? 0.0 : tx.signedCount / tx.signers.length;
    final color = tx.signedCount >= tx.threshold
        ? AppColors.buy
        : AppColors.primary;
    return ClipRRect(
      borderRadius: AppRadii.pillRadius,
      child: LinearProgressIndicator(
        minHeight: LaunchpadSpacingTokens.launchpadDotSm,
        value: ratio.clamp(0, 1),
        backgroundColor: AppColors.surface3,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

final class _StatusView {
  const _StatusView(this.label, this.color, this.icon);

  final String label;
  final Color color;
  final IconData icon;
}

_StatusView _statusView(LaunchpadMultisigTxStatus status) {
  return switch (status) {
    LaunchpadMultisigTxStatus.draft => const _StatusView(
      'Draft',
      AppColors.text3,
      Icons.description_outlined,
    ),
    LaunchpadMultisigTxStatus.pendingSignatures => const _StatusView(
      'Chờ ký',
      AppColors.primary,
      Icons.edit_outlined,
    ),
    LaunchpadMultisigTxStatus.ready => const _StatusView(
      'Sẵn sàng',
      AppColors.buy,
      Icons.check_circle_outline_rounded,
    ),
    LaunchpadMultisigTxStatus.executing => const _StatusView(
      'Đang xử lý',
      AppModuleAccents.launchpad,
      Icons.bolt_rounded,
    ),
    LaunchpadMultisigTxStatus.executed => const _StatusView(
      'Đã thực hiện',
      AppColors.buy,
      Icons.check_circle_outline_rounded,
    ),
    LaunchpadMultisigTxStatus.expired => const _StatusView(
      'Hết hạn',
      AppColors.sell,
      Icons.cancel_outlined,
    ),
    LaunchpadMultisigTxStatus.cancelled => const _StatusView(
      'Đã hủy',
      AppColors.text3,
      Icons.cancel_outlined,
    ),
  };
}

VitStatusPillStatus _statusPillStatus(LaunchpadMultisigTxStatus status) {
  return switch (status) {
    LaunchpadMultisigTxStatus.draft => VitStatusPillStatus.neutral,
    LaunchpadMultisigTxStatus.pendingSignatures => VitStatusPillStatus.info,
    LaunchpadMultisigTxStatus.ready => VitStatusPillStatus.success,
    LaunchpadMultisigTxStatus.executing => VitStatusPillStatus.purple,
    LaunchpadMultisigTxStatus.executed => VitStatusPillStatus.success,
    LaunchpadMultisigTxStatus.expired => VitStatusPillStatus.error,
    LaunchpadMultisigTxStatus.cancelled => VitStatusPillStatus.neutral,
  };
}
