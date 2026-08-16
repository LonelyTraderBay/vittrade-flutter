part of '../../phone/pages/claim/launchpad_claim_receipt_page.dart';

class _ClaimSheet extends StatelessWidget {
  const _ClaimSheet({
    required this.entry,
    required this.receipt,
    required this.onClose,
  });

  final LaunchpadRewardVestingEntryDraft entry;
  final LaunchpadRewardClaimReceiptDraft receipt;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: AppColors.dynamicIslandBg.withValues(alpha: .72),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            color: AppColors.surface,
            borderRadius: AppRadii.sheetTopLargeRadius,
            child: Padding(
              key: LaunchpadClaimReceiptPage.claimSheetKey,
              padding: LaunchpadSpacingTokens.launchpadClaimSheetPadding(
                MediaQuery.paddingOf(context).bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Align(
                    child: SizedBox(
                      width: LaunchpadSpacingTokens.launchpadBox40,
                      height: AppSpacing.x1,
                      child: DecoratedBox(
                        decoration: ShapeDecoration(
                          color: AppColors.borderSolid,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadii.xsRadius,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: AppSpacing.pageRhythmStandardSectionGap,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Nhận phần thưởng',
                          style: AppTextStyles.sectionTitle.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      VitIconButton(
                        icon: Icons.close_rounded,
                        tooltip: 'Đóng',
                        onPressed: onClose,
                        variant: VitIconButtonVariant.transparent,
                        size: VitIconButtonSize.md,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: AppSpacing.pageRhythmStandardSectionGap,
                  ),
                  Text(
                    '${_formatNumber(entry.amount)} ${entry.token}',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.pageTitle.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  Text(
                    '~${_formatUsd(entry.amount * receipt.rewardTokenPrice)} USD',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                    ),
                  ),
                  const SizedBox(
                    height: AppSpacing.pageRhythmStandardSectionGap,
                  ),
                  _DetailLine(row: _DetailRow('Đợt', entry.label)),
                  _DetailLine(row: _DetailRow('Chuỗi', receipt.chain)),
                  const _DetailLine(row: _DetailRow('Gas ước tính', r'~$0.15')),
                  const SizedBox(
                    height: AppSpacing.pageRhythmStandardSectionGap,
                  ),
                  VitHighRiskStatePanel(
                    key: LaunchpadClaimReceiptPage.claimSheetReviewStateKey,
                    state: VitHighRiskUiState.riskReview,
                    title: 'Rà soát biên lai nhận thưởng',
                    message:
                        'Kiểm tra token thưởng, chuỗi, gas và số lượng nhận.',
                    contractId: 'SC-302 / ${receipt.positionId}',
                  ),
                  const SizedBox(
                    height: AppSpacing.pageRhythmStandardSectionGap,
                  ),
                  VitCtaButton(
                    onPressed: onClose,
                    variant: VitCtaButtonVariant.success,
                    child: Text(
                      'Xác nhận nhận ${_formatNumber(entry.amount)} ${entry.token}',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
