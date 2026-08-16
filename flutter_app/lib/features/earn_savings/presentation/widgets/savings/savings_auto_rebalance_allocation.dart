part of '../../phone/pages/savings/savings_auto_rebalance_page.dart';

class _AllocationComparisonCard extends StatelessWidget {
  const _AllocationComparisonCard({
    required this.snapshot,
    required this.strategy,
  });

  final SavingsAutoRebalanceSnapshot snapshot;
  final SavingsRebalanceStrategyDraft strategy;

  @override
  Widget build(BuildContext context) {
    final drift = _totalDrift(snapshot.positions, strategy);

    return VitCard(
      key: SavingsAutoRebalancePage.allocationKey,
      radius: VitCardRadius.large,
      padding: _savingsRebalanceCardPadding,
      child: VitPageContent(
        rhythm: VitPageRhythm.standard,
        padding: VitContentPadding.none,
        density: VitDensity.compact,
        children: [
          const VitSectionHeader(
            title: 'Hiện tại vs Mục tiêu',
            icon: Icons.compare_arrows_rounded,
            iconColor: AppColors.primary,
            bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _AllocationRing(
                  label: 'Hiện tại',
                  allocations: {
                    for (final position in snapshot.positions)
                      position.asset: position.currentPct,
                  },
                  positions: snapshot.positions,
                ),
              ),
              Padding(
                padding: EarnSpacingTokens.earnHorizontalPaddingX2,
                child: Column(
                  children: [
                    const Icon(
                      Icons.compare_arrows_rounded,
                      color: AppColors.text3,
                      size: _savingsRebalanceInlineIcon,
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    VitAccentPill(
                      label: 'Drift ${drift.toStringAsFixed(1)}%',
                      accentColor: _driftColor(drift),
                      size: VitStatusPillSize.sm,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _AllocationRing(
                  label: strategy.name,
                  allocations: strategy.allocations,
                  positions: snapshot.positions,
                ),
              ),
            ],
          ),
          for (final position in snapshot.positions) ...[
            _AssetDriftRow(position: position, strategy: strategy),
          ],
        ],
      ),
    );
  }
}

class _AllocationRing extends StatelessWidget {
  const _AllocationRing({
    required this.label,
    required this.allocations,
    required this.positions,
  });

  final String label;
  final Map<String, double> allocations;
  final List<SavingsRebalancePositionDraft> positions;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      density: VitDensity.compact,
      children: [
        SizedBox.square(
          dimension: _savingsRebalanceRingExtent,
          child: CustomPaint(
            painter: _AllocationRingPainter(
              allocations: allocations,
              positions: positions,
            ),
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _AssetDriftRow extends StatelessWidget {
  const _AssetDriftRow({required this.position, required this.strategy});

  final SavingsRebalancePositionDraft position;
  final SavingsRebalanceStrategyDraft strategy;

  @override
  Widget build(BuildContext context) {
    final target = strategy.allocations[position.asset] ?? position.targetPct;
    final drift = position.currentPct - target;
    final color = _assetColor(position);
    final driftColor = _driftColor(drift.abs());

    return Row(
      children: [
        SizedBox.square(
          dimension: _savingsRebalanceAssetBadge,
          child: Material(
            color: color.withValues(alpha: .14),
            borderRadius: AppRadii.smRadius,
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  position.asset,
                  style: _captionMedium.copyWith(color: color),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '${position.currentPct.toStringAsFixed(1)}% -> ${target.toStringAsFixed(0)}%',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  if (position.locked) ...[
                    const Icon(
                      Icons.lock_outline_rounded,
                      size: _savingsRebalanceLockIcon,
                      color: AppColors.text3,
                    ),
                    const SizedBox(width: AppSpacing.x1),
                  ],
                  Text(
                    '${drift >= 0 ? '+' : ''}${drift.toStringAsFixed(1)}%',
                    style: _captionMedium.copyWith(color: driftColor),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              SizedBox(
                height: _savingsRebalanceTrackHeight,
                child: CustomPaint(
                  painter: _DriftTrackPainter(
                    color: color,
                    driftColor: driftColor,
                    current: position.currentPct,
                    target: target,
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DriftStatusCard extends StatelessWidget {
  const _DriftStatusCard({
    required this.drift,
    required this.threshold,
    required this.onPreview,
  });

  final double drift;
  final double threshold;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    final color = _driftColor(drift);
    final needsAction = drift >= threshold;

    return VitCard(
      key: SavingsAutoRebalancePage.driftStatusKey,
      radius: VitCardRadius.large,
      padding: _savingsRebalanceCardPadding,
      child: Row(
        children: [
          SizedBox.square(
            dimension: _savingsRebalanceIconBox,
            child: Material(
              color: color.withValues(alpha: .14),
              borderRadius: AppRadii.mdRadius,
              child: Icon(
                needsAction
                    ? Icons.warning_amber_rounded
                    : Icons.check_circle_outline_rounded,
                color: color,
                size: _savingsRebalanceIcon,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  needsAction ? 'Cần tái cân bằng' : 'Danh mục cân bằng',
                  style: _captionMedium.copyWith(color: AppColors.text1),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Tổng drift: ${drift.toStringAsFixed(1)}% · Ngưỡng: ${threshold.toStringAsFixed(0)}%',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          if (needsAction)
            VitCtaButton(
              key: SavingsAutoRebalancePage.previewButtonKey,
              onPressed: onPreview,
              variant: VitCtaButtonVariant.secondary,
              fullWidth: false,
              height: AppSpacing.buttonCompact,
              padding: EarnSpacingTokens.earnCardPaddingX3X2,
              child: const Text('Xem trước'),
            ),
        ],
      ),
    );
  }
}
