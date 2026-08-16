part of '../../phone/pages/tools/network_status_page.dart';

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.snapshot,
    required this.onRefresh,
    this.refreshFeedback,
  });

  final WalletNetworkStatusSnapshot snapshot;
  final VoidCallback onRefresh;
  final String? refreshFeedback;

  @override
  Widget build(BuildContext context) {
    final summaryColor = snapshot.downCount > 0
        ? _networkRed
        : snapshot.issueCount > 0
        ? _networkAmber
        : _networkGreen;
    final summaryMessage = snapshot.downCount > 0
        ? '${snapshot.downCount} m\u1EA1ng \u0111ang b\u1EA3o tr\u00EC'
        : snapshot.issueCount > 0
        ? '${snapshot.issueCount} m\u1EA1ng \u0111ang ch\u1EADm'
        : 'T\u1EA5t c\u1EA3 m\u1EA1ng ho\u1EA1t \u0111\u1ED9ng t\u1ED1t';

    return VitCard(
      padding: VitDensity.compact.cardPadding,
      radius: VitCardRadius.large,
      borderColor: summaryColor.withValues(alpha: .34),
      child: Column(
        children: [
          Row(
            children: [
              // card-tile: allow-start — fixed surface, not horizontal strip tile
              VitCard(
                width: _networkSummaryIconSize,
                height: _networkSummaryIconSize,
                variant: VitCardVariant.ghost,
                radius: VitCardRadius.standard,
                borderColor: summaryColor.withValues(alpha: .42),
                background: ColoredBox(
                  color: summaryColor.withValues(alpha: .08),
                ),
                clip: true,
                alignment: Alignment.center,
                child: Icon(
                  snapshot.downCount > 0
                      ? Icons.wifi_off_rounded
                      : Icons.wifi_rounded,
                  color: summaryColor,
                  size: WalletSpacingTokens.walletNetworkSummaryIconGlyph,
                ),
              ),
              const SizedBox(width: _networkInlineGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      summaryMessage,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: _networkTinyGap),
                    Text(
                      'C\u1EADp nh\u1EADt t\u1EF1 \u0111\u1ED9ng m\u1ED7i ${snapshot.refreshIntervalSeconds} gi\u00E2y',
                      style: AppTextStyles.micro.copyWith(color: _networkMuted),
                    ),
                  ],
                ),
              ),
              VitIconButton(
                key: NetworkStatusPage.refreshKey,
                icon: Icons.refresh_rounded,
                tooltip: 'Refresh network status',
                onPressed: onRefresh,
                size: VitIconButtonSize.sm,
              ),
            ],
          ),
          if (refreshFeedback != null) ...[
            const SizedBox(height: _networkCardGap),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: VitStatusPill(
                key: NetworkStatusPage.refreshFeedbackKey,
                label: refreshFeedback!,
                status: VitStatusPillStatus.info,
                icon: Icons.check_circle_outline_rounded,
                size: VitStatusPillSize.sm,
              ),
            ),
          ],
          const SizedBox(height: _networkCardGap),
          Row(
            children: [
              _SummaryStat(
                value: snapshot.operationalCount.toString(),
                label: 'Ho\u1EA1t \u0111\u1ED9ng',
                color: _networkGreen,
              ),
              const SizedBox(width: _networkTinyGap),
              _SummaryStat(
                value: snapshot.issueCount.toString(),
                label: 'Ch\u1EADm / T\u1EAFc',
                color: _networkAmber,
              ),
              const SizedBox(width: _networkTinyGap),
              _SummaryStat(
                value: snapshot.downCount.toString(),
                label: 'B\u1EA3o tr\u00EC',
                color: _networkRed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // card-tile: allow-start — fixed surface, not horizontal strip tile
      child: VitCard(
        variant: VitCardVariant.inner,
        height: _networkSummaryStatHeight,
        alignment: Alignment.center,
        borderColor: color.withValues(alpha: .32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: AppTextStyles.baseMedium.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            const SizedBox(height: _networkTinyGap),
            Text(
              label,
              style: AppTextStyles.micro.copyWith(color: _networkMuted),
            ),
          ],
        ),
      ),
    );
  }
}
