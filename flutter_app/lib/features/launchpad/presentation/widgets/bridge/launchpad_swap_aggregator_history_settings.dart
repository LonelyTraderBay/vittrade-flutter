part of '../../phone/pages/bridge/launchpad_swap_aggregator_page.dart';

class _HistorySection extends StatelessWidget {
  const _HistorySection({required this.history});

  final List<LaunchpadSwapHistoryDraft> history;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: LaunchpadSwapAggregatorPage.historyKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VitSectionHeader(
            title: 'Giao d\u1ECBch g\u1EA7n \u0111\u00E2y',
            bottomGap: AppSpacing.pageRhythmStandardInnerGap,
            density: VitDensity.compact,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCard(
            clip: true,
            padding: AppSpacing.zeroInsets,
            child: Column(
              children: [
                for (var i = 0; i < history.length; i++) ...[
                  Padding(
                    padding: AppSpacing.cardPadding,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Wrap(
                                spacing: AppSpacing.x2,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    '${history[i].from} \u2192 ${history[i].to}',
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.text1,
                                      fontWeight: AppTextStyles.bold,
                                    ),
                                  ),
                                  VitStatusPill(
                                    label: switch (history[i].status) {
                                      LaunchpadSwapStatus.success =>
                                        'TH\u00C0NH C\u00D4NG',
                                      LaunchpadSwapStatus.pending => 'CH\u1EDD',
                                      LaunchpadSwapStatus.failed =>
                                        'TH\u1EA4T B\u1EA0I',
                                    },
                                    status: switch (history[i].status) {
                                      LaunchpadSwapStatus.success =>
                                        VitStatusPillStatus.success,
                                      LaunchpadSwapStatus.pending =>
                                        VitStatusPillStatus.info,
                                      LaunchpadSwapStatus.failed =>
                                        VitStatusPillStatus.error,
                                    },
                                    size: VitStatusPillSize.sm,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${history[i].amount.toStringAsFixed(0)} ${history[i].from}',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                                fontFeatures: AppTextStyles.tabularFigures,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: AppSpacing.pageRhythmCompactInnerGap,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                history[i].dex,
                                style: AppTextStyles.micro.copyWith(
                                  color: AppColors.text3,
                                ),
                              ),
                            ),
                            Text(
                              '@${history[i].rate.toStringAsFixed(2)}',
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                                fontFeatures: AppTextStyles.tabularFigures,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: AppSpacing.pageRhythmCompactInnerGap,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                history[i].timestamp,
                                style: AppTextStyles.micro.copyWith(
                                  color: AppColors.text3,
                                ),
                              ),
                            ),
                            Text(
                              history[i].txHash,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (i < history.length - 1)
                    const Divider(
                      height: AppSpacing.dividerHairline,
                      thickness: AppSpacing.dividerHairline,
                      color: AppColors.divider,
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

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.slippage,
    required this.autoRefresh,
    required this.onSlippageChanged,
    required this.onAutoRefreshChanged,
  });

  final String slippage;
  final bool autoRefresh;
  final ValueChanged<String> onSlippageChanged;
  final ValueChanged<bool> onAutoRefreshChanged;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: LaunchpadSwapAggregatorPage.settingsKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VitSectionHeader(
            title: 'Slippage & Gas',
            bottomGap: AppSpacing.pageRhythmStandardInnerGap,
            density: VitDensity.compact,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCard(
            padding: AppSpacing.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\u0110\u1ED9 tr\u01B0\u1EE3t gi\u00E1 (%)',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                VitSegmentedChoice.withPrimaryAccent<String>(
                  selected: slippage,
                  onChanged: onSlippageChanged,
                  height: AppSpacing.buttonCompact,
                  options: [
                    for (final value in ['0.1', '0.5', '1.0', '3.0'])
                      VitSegmentedChoiceOption<String>(
                        key: LaunchpadSwapAggregatorPage.slippageKey(value),
                        value: value,
                        label: '$value%',
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'T\u1EF1 \u0111\u1ED9ng l\u00E0m m\u1EDBi',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          Text(
                            'C\u1EADp nh\u1EADt gi\u00E1 m\u1ED7i 10s',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      key: LaunchpadSwapAggregatorPage.autoRefreshKey,
                      value: autoRefresh,
                      activeThumbColor: AppColors.primary,
                      onChanged: onAutoRefreshChanged,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          const VitSectionHeader(
            title: 'An to\u00E0n',
            bottomGap: AppSpacing.pageRhythmStandardInnerGap,
            density: VitDensity.compact,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCard(
            borderColor: AppColors.accent20,
            background: const ColoredBox(color: AppColors.accent08),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.accent,
                  size: AppSpacing.iconMd,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    'Lu\u00F4n ki\u1EC3m tra \u0111\u1ECBa ch\u1EC9 h\u1EE3p \u0111\u1ED3ng v\u00E0 ch\u1EC9 swap tr\u00EAn c\u00E1c DEX uy t\u00EDn. Kh\u00F4ng chia s\u1EBB private key.',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      height: LaunchpadSpacingTokens.launchpadLineHeightShort,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
