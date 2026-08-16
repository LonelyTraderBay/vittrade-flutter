part of '../../phone/pages/client_money/client_money_protection_page.dart';

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.snapshot});

  final TradeClientMoneyProtectionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.tool,
      radius: VitCardRadius.standard,
      borderColor: _moneyBorder.withValues(alpha: .72),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // card-tile: allow-start — fixed surface, not horizontal strip tile
              VitCard(
                width: TradeSpacingTokens.tradeBotClientMoneyBalanceIcon,
                height: TradeSpacingTokens.tradeBotClientMoneyBalanceIcon,
                variant: VitCardVariant.inner,
                radius: VitCardRadius.tight,
                alignment: Alignment.center,
                borderColor: _moneyGreen.withValues(alpha: .35),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  color: _moneyGreen,
                  size: TradeSpacingTokens.tradeBotClientMoneyBalanceGlyph,
                ),
              ),
              const SizedBox(width: TradeSpacingTokens.tradeBotStatusGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Segregated Balance',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      _formatUsd(snapshot.balance),
                      style: AppTextStyles.sectionTitleSm.copyWith(
                        color: AppColors.text1,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Fully segregated and protected',
                      style: AppTextStyles.micro.copyWith(color: _moneyGreen),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _MetricBox(
                  label: 'Trust Account',
                  value: snapshot.trustAccount,
                ),
              ),
              const SizedBox(width: TradeSpacingTokens.tradeBotRowGap),
              Expanded(
                child: _MetricBox(
                  label: 'Last Reconciled',
                  value: snapshot.lastReconciled,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  const _Overview({required this.snapshot});

  final TradeClientMoneyProtectionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.tool,
      children: [
        VitPageSection(
          key: ClientMoneyProtectionPage.overviewSectionKey,
          label: 'How Your Money Is Protected',
          density: VitDensity.tool,
          children: [
            VitCard(
              density: VitDensity.tool,
              radius: VitCardRadius.tight,
              borderColor: _moneyBorder.withValues(alpha: .72),
              child: VitPageContent(
                rhythm: VitPageRhythm.standard,
                padding: VitContentPadding.none,
                fullBleed: true,
                density: VitDensity.tool,
                children: [
                  for (final item in snapshot.protections)
                    _ProtectionItem(item: item),
                ],
              ),
            ),
          ],
        ),
        VitPageSection(
          label: 'In Case of Insolvency',
          density: VitDensity.tool,
          children: [
            VitCard(
              density: VitDensity.tool,
              radius: VitCardRadius.tight,
              borderColor: _moneyBorder.withValues(alpha: .72),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.text1,
                        size: TradeSpacingTokens
                            .tradeBotClientMoneyInsolvencyIcon,
                      ),
                      const SizedBox(
                        width: TradeSpacingTokens.tradeBotDisclosureGap,
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                            children: [
                              TextSpan(
                                text: 'Client Money Protection: ',
                                style: AppTextStyles.micro.copyWith(
                                  color: AppColors.text1,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                              TextSpan(text: snapshot.insolvencySummary),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    snapshot.insolvencyDetail,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProtectionItem extends StatelessWidget {
  const _ProtectionItem({required this.item});

  final TradeClientMoneyProtectionItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle_outline,
          color: _moneyGreen,
          size: TradeSpacingTokens.tradeToolBodyIcon,
        ),
        const SizedBox(width: TradeSpacingTokens.tradeBotCardIconGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                item.description,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
