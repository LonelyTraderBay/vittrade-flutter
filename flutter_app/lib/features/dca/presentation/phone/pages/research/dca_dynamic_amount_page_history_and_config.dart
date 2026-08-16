part of 'dca_dynamic_amount_page.dart';

class _AmountHistoryCard extends StatelessWidget {
  const _AmountHistoryCard({required this.entries});

  final List<DcaAmountHistoryEntry> entries;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      clip: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: DcaSpacingTokens.dcaSectionHeaderPadding,
            child: _SectionHeader(
              icon: Icons.bar_chart_rounded,
              title: 'Lịch sử điều chỉnh',
              subtitle: 'So sánh gốc vs thực tế',
              color: AppColors.primary,
            ),
          ),
          Padding(
            padding: DcaSpacingTokens.dcaChartPadding,
            child: SizedBox(
              height: _dcaDynamicChartHeight,
              child: CustomPaint(
                painter: _AmountHistoryPainter(entries: entries),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          const Padding(
            padding: DcaSpacingTokens.dcaChartFooterPadding,
            child: Wrap(
              spacing: AppSpacing.x5,
              children: [
                _LegendItem(
                  color: AppColors.surface3,
                  label: 'Gốc',
                  block: true,
                ),
                _LegendItem(
                  color: AppColors.primary,
                  label: 'Đã điều chỉnh',
                  block: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentDetailsCard extends StatelessWidget {
  const _RecentDetailsCard({required this.entries});

  final List<DcaAmountHistoryEntry> entries;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: _dcaDynamicCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            icon: Icons.history_rounded,
            title: 'Chi tiết gần đây',
            subtitle: '${entries.length} lần điều chỉnh',
            color: AppColors.primarySoft,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          for (final entry in entries.take(6)) ...[
            _HistoryRow(entry: entry),
            if (entry != entries.take(6).last)
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          ],
        ],
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.entry});

  final DcaAmountHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final change = entry.changePercent;
    final color = change > 0
        ? AppColors.buy
        : change < 0
        ? AppColors.warn
        : AppColors.text3;

    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
      ),
      child: Padding(
        padding: DcaSpacingTokens.dcaPaddingX3,
        child: Row(
          children: [
            SizedBox(
              width: AppSpacing.x7 - AppSpacing.x5,
              height: AppSpacing.x7 - AppSpacing.x5,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: change > 0
                      ? AppColors.buy10
                      : change < 0
                      ? AppColors.warn10
                      : AppColors.hoverBg,
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.mdRadius,
                  ),
                ),
                child: Icon(
                  change > 0
                      ? Icons.trending_up_rounded
                      : change < 0
                      ? Icons.trending_down_rounded
                      : Icons.lock_outline_rounded,
                  color: color,
                  size: AppSpacing.iconMd,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.date,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                          fontWeight: AppTextStyles.medium,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            _formatVnd(entry.adjustedAmountVnd),
                            style: AppTextStyles.baseMedium.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          if (change != 0) ...[
                            const SizedBox(width: AppSpacing.x2),
                            _ChangeBadge(change: change, color: color),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    entry.reason,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                      height: DcaSpacingTokens.dcaDynamicHistoryLineHeight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChangeBadge extends StatelessWidget {
  const _ChangeBadge({required this.change, required this.color});

  final double change;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: change > 0
            ? AppColors.buy10
            : change < 0
            ? AppColors.warn10
            : AppColors.hoverBg,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      ),
      child: Padding(
        padding: DcaSpacingTokens.dcaTinyChipPadding,
        child: Text(
          '${change > 0 ? '+' : ''}${change.toStringAsFixed(0)}%',
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _ConfigSection extends StatelessWidget {
  const _ConfigSection({required this.option, required this.items});

  final DcaDynamicStrategyOption option;
  final List<DcaDynamicConfigItem> items;

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor(option.accent);

    return VitCard(
      clip: true,
      child: Column(
        children: [
          SizedBox(
            height: AppSpacing.x1,
            child: ColoredBox(color: accent),
          ),
          Padding(
            padding: _dcaDynamicCardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(
                  icon: Icons.settings_outlined,
                  title: 'Cấu hình ${option.title}',
                  color: accent,
                  actionLabel: 'Chỉnh sửa',
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final availableWidth = math.max(0.0, constraints.maxWidth);
                    final useTwoColumns = availableWidth >= 280;
                    final itemWidth = useTwoColumns
                        ? (availableWidth - AppSpacing.x3) / 2
                        : availableWidth;
                    return Wrap(
                      spacing: useTwoColumns ? AppSpacing.x3 : 0,
                      runSpacing: AppSpacing.x3,
                      children: [
                        for (final item in items)
                          SizedBox(
                            width: itemWidth,
                            child: _ConfigItemCard(item: item),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfigItemCard extends StatelessWidget {
  const _ConfigItemCard({required this.item});

  final DcaDynamicConfigItem item;

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor(item.accent);

    return VitCard(
      variant: VitCardVariant.inner,
      padding: _dcaDynamicCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_iconFor(item.icon), color: accent, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            item.value,
            style: AppTextStyles.baseMedium.copyWith(
              color: accent,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _StrategyExplainer extends StatelessWidget {
  const _StrategyExplainer({required this.option});

  final DcaDynamicStrategyOption option;

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor(option.accent);

    return VitCard(
      variant: VitCardVariant.inner,
      padding: _dcaDynamicCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppSpacing.x7 - AppSpacing.x5,
            height: AppSpacing.x7 - AppSpacing.x5,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: _accentSoft(option.accent),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.mdRadius,
                ),
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                color: accent,
                size: AppSpacing.iconSm,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chiến lược "${option.title}"',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  option.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: DcaSpacingTokens.dcaDynamicExplainerLineHeight,
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

class _DynamicDisclaimer extends StatelessWidget {
  const _DynamicDisclaimer();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.primary08,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.cardRadius,
          side: BorderSide(color: AppColors.primary20),
        ),
      ),
      child: Padding(
        padding: DcaSpacingTokens.dcaPaddingX4,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: AppColors.primary,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                'Dynamic Amount tự điều chỉnh lượng mua dựa trên chiến lược bạn chọn. Bạn có thể thay đổi chiến lược hoặc quay về "Cố định" bất cứ lúc nào.',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: DcaSpacingTokens.dcaDynamicExplainerLineHeight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ApplyStrategyAction extends StatelessWidget {
  const _ApplyStrategyAction({required this.onApply});

  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: DCADynamicAmountPage.applyKey,
      onPressed: onApply,
      leading: const Icon(
        Icons.arrow_upward_rounded,
        color: AppColors.onAccent,
        size: AppSpacing.iconMd,
      ),
      child: const Text('Áp dụng chiến lược'),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.color,
    this.subtitle,
    this.actionLabel,
  });

  final IconData icon;
  final String title;
  final Color color;
  final String? subtitle;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        VitAccentIconBox(icon: icon, color: color),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.x1),
                Text(
                  subtitle!,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ],
          ),
        ),
        if (actionLabel != null)
          Text(
            actionLabel!,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
      ],
    );
  }
}
