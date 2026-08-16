part of '../../phone/pages/governance/arena_governance_gate_page.dart';

class _GovernanceSummary extends StatelessWidget {
  const _GovernanceSummary({
    required this.result,
    required this.privacy,
    required this.resolutionSource,
  });

  final _GovernanceResult result;
  final String privacy;
  final String resolutionSource;

  @override
  Widget build(BuildContext context) {
    final privacyLabel = privacy == 'public'
        ? 'Công khai'
        : privacy == 'private'
        ? 'Riêng tư'
        : 'Unlisted';
    return VitCard(
      borderColor: AppColors.accent20,
      padding: ArenaSpacingTokens.arenaGovernanceCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _MiniHeader(
            icon: Icons.summarize_outlined,
            label: 'Governance Summary',
            pill: 'TỰ SINH',
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _SummaryRow(label: 'Rule clarity', value: '${result.clarity} / 100'),
          _SummaryRow(
            label: 'Publish eligibility',
            value: _tierLabel(result.tier),
          ),
          _SummaryRow(label: 'Risk tier', value: result.risk),
          _SummaryRow(
            label: 'Resolution method',
            value: resolutionSource.isEmpty ? '-' : resolutionSource,
          ),
          _SummaryRow(label: 'Privacy', value: privacyLabel),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCard(
            variant: VitCardVariant.inner,
            borderColor: AppColors.warningBorder,
            padding: ArenaSpacingTokens.arenaGovernanceInnerPadding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_outline_rounded,
                  color: AppColors.warn,
                  size: ArenaSpacingTokens.arenaGovernanceIcon,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    result.tier == _EligibilityTier.green
                        ? 'Rule đủ rõ để tiếp tục.'
                        : 'Nên chuyển sang Private hoặc Unlisted cho đến khi rule rõ ràng hơn.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: _governanceBodyLineRatio,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          _NextActionChip(text: result.nextAction),
        ],
      ),
    );
  }
}

class _GovernanceFooter extends StatelessWidget {
  const _GovernanceFooter({
    required this.canContinue,
    required this.result,
    required this.statusLabel,
    required this.onBack,
    required this.onSave,
    required this.onContinue,
  });

  final bool canContinue;
  final _GovernanceResult result;
  final String? statusLabel;
  final VoidCallback onBack;
  final VoidCallback onSave;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final color = _tierColor(result.tier);
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.bg,
        shape: Border(top: BorderSide(color: AppColors.borderSolid)),
      ),
      child: Padding(
        padding: ArenaSpacingTokens.arenaGovernanceFooterPadding,
        child: Column(
          children: [
            Row(
              children: [
                // card-tile: allow-start — fixed surface, not horizontal strip tile
                VitCard(
                  variant: VitCardVariant.inner,
                  width: _governanceActionExtent,
                  height: _governanceActionExtent,
                  onTap: onBack,
                  child: const Icon(
                    Icons.chevron_left_rounded,
                    color: AppColors.text2,
                    size: ArenaSpacingTokens.arenaGovernanceFooterIcon,
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: VitCtaButton(
                    key: ArenaGovernanceGatePage.continueKey,
                    onPressed: canContinue ? onContinue : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Tiếp tục'),
                        const SizedBox(width: AppSpacing.x1),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: canContinue
                              ? AppColors.onAccent
                              : AppColors.text3,
                          size: ArenaSpacingTokens.arenaGovernanceIcon,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            Row(
              children: [
                VitCard(
                  key: ArenaGovernanceGatePage.saveKey,
                  variant: VitCardVariant.ghost,
                  padding: ArenaSpacingTokens.arenaGovernanceSavePadding,
                  onTap: onSave,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.save_outlined,
                        color: AppColors.text3,
                        size: ArenaSpacingTokens.arenaGovernanceSmallIcon,
                      ),
                      const SizedBox(width: AppSpacing.x1),
                      Text(
                        'Lưu nháp',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontWeight: AppTextStyles.medium,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                    statusLabel ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ),
                _StatusPill(label: _tierLabel(result.tier), color: color),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  'Bước 3 / 6',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
