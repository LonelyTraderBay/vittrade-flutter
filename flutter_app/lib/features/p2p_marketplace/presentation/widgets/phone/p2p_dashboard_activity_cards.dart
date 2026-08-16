part of '../../phone/pages/hub/p2p_dashboard_page.dart';

class _ExtraStats extends StatelessWidget {
  const _ExtraStats({required this.snapshot});

  final P2PDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final stats = snapshot.stats;
    return Row(
      children: [
        Expanded(
          child: _CenteredStat(
            icon: Icons.groups_outlined,
            value: '${stats.uniqueCounterparties}',
            label: 'Đối tác',
            color: AppColors.accent,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _CenteredStat(
            icon: Icons.swap_horiz_rounded,
            value: '${stats.repeatCustomerRate.toStringAsFixed(1)}%',
            label: 'Quay lại',
            color: AppModuleAccents.p2p,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _CenteredStat(
            icon: Icons.attach_money_rounded,
            value: _formatMoneyCompact(stats.avgOrderSize),
            label: 'TB đơn hàng',
            color: AppColors.buy,
          ),
        ),
      ],
    );
  }
}

class _OrderBreakdownCard extends StatelessWidget {
  const _OrderBreakdownCard({required this.snapshot});

  final P2PDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final stats = snapshot.stats;
    final rows = [
      _BreakdownConfig(
        label: 'Hoàn thành',
        count: stats.completedOrders,
        color: AppColors.buy,
        icon: Icons.check_circle_outline_rounded,
      ),
      _BreakdownConfig(
        label: 'Đã hủy',
        count: stats.cancelledOrders,
        color: AppColors.sell,
        icon: Icons.cancel_outlined,
      ),
      _BreakdownConfig(
        label: 'Tranh chấp',
        count: stats.disputedOrders,
        color: AppColors.warn,
        icon: Icons.warning_amber_rounded,
      ),
    ];
    return VitCard(
      key: P2PDashboardPage.breakdownKey,
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pDashboardCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VitSectionHeader(
            title: 'Phân tích đơn hàng',
            icon: Icons.shopping_cart_outlined,
            iconColor: AppColors.text2,
            bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          ),
          for (final row in rows) ...[
            _BreakdownLine(row: row, total: stats.totalOrders),
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          ],
        ],
      ),
    );
  }
}

class _TopMerchantsCard extends StatelessWidget {
  const _TopMerchantsCard({required this.snapshot});

  final P2PDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PDashboardPage.merchantsKey,
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pDashboardCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: VitSectionHeader(
                  title: 'Top Merchants',
                  icon: Icons.star_border_rounded,
                  iconColor: AppColors.text2,
                  bottomGap: AppSpacing.pageRhythmStandardInnerGap,
                ),
              ),
              Text(
                '30 ngày qua',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          for (var index = 0; index < snapshot.topMerchants.length; index++)
            _MerchantRow(
              rank: index + 1,
              merchant: snapshot.topMerchants[index],
              onTap: () {
                unawaited(HapticFeedback.selectionClick());
                context.go(
                  AppRoutePaths.p2pMerchant(snapshot.topMerchants[index].id),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _RecentActivityCard extends StatelessWidget {
  const _RecentActivityCard({required this.snapshot});

  final P2PDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PDashboardPage.activityKey,
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pDashboardCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: VitSectionHeader(
                  title: 'Hoạt động gần đây',
                  icon: Icons.schedule_rounded,
                  iconColor: AppColors.text2,
                  bottomGap: AppSpacing.pageRhythmStandardInnerGap,
                ),
              ),
              _TextLinkButton(
                key: P2PDashboardPage.myOrdersKey,
                label: 'Xem tất cả',
                onTap: () {
                  unawaited(HapticFeedback.selectionClick());
                  context.go(snapshot.myOrdersRoute);
                },
              ),
            ],
          ),
          for (var index = 0; index < snapshot.recentActivity.length; index++)
            _ActivityRow(
              activity: snapshot.recentActivity[index],
              last: index == snapshot.recentActivity.length - 1,
            ),
        ],
      ),
    );
  }
}

class _QuickNavigation extends StatelessWidget {
  const _QuickNavigation({required this.snapshot});

  final P2PDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PDashboardPage.quickNavKey,
      children: [
        for (var row = 0; row < 2; row++) ...[
          Row(
            children: [
              Expanded(
                child: _QuickActionTile(action: snapshot.quickActions[row * 2]),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _QuickActionTile(
                  action: snapshot.quickActions[row * 2 + 1],
                ),
              ),
            ],
          ),
          if (row == 0)
            const SizedBox(height: P2PSpacingTokens.p2pDashboardMetricRowGap),
        ],
      ],
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({required this.action});

  final P2PDashboardQuickActionDraft action;

  @override
  Widget build(BuildContext context) {
    final color = _quickColor(action.id);
    return VitCard(
      key: P2PDashboardPage.quickActionKey(action.id),
      variant: VitCardVariant.ghost,
      borderColor: AppColors.border,
      background: const ColoredBox(color: AppColors.surface),
      padding: P2PSpacingTokens.p2pDashboardQuickActionPadding,
      onTap: () {
        unawaited(HapticFeedback.selectionClick());
        context.go(action.route);
      },
      clip: true,
      child: Row(
        children: [
          VitAccentIconBox(icon: _quickIcon(action.iconKey), color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              action.label,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconSm,
          ),
        ],
      ),
    );
  }
}

class _TrendBadge extends StatelessWidget {
  const _TrendBadge({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.arrow_outward_rounded,
          color: AppColors.buy,
          size: P2PSpacingTokens.p2pDashboardTrendIcon,
        ),
        const SizedBox(width: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.buy,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _TinyLegend extends StatelessWidget {
  const _TinyLegend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: color,
          shape: const CircleBorder(),
          child: const SizedBox(width: AppSpacing.x2, height: AppSpacing.x2),
        ),
        const SizedBox(width: AppSpacing.x1),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _SmallPill extends StatelessWidget {
  const _SmallPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(label: label, accentColor: color);
  }
}

class _ComparisonLine extends StatelessWidget {
  const _ComparisonLine({required this.item});

  final P2PDashboardComparisonDraft item;

  @override
  Widget build(BuildContext context) {
    final better = item.lowerBetter
        ? item.yours < item.platform
        : item.yours > item.platform;
    final color = better ? AppColors.buy : AppColors.warn;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                item.label,
                style: AppTextStyles.micro.copyWith(color: AppColors.text2),
              ),
            ),
            Text(
              '${_formatDecimal(item.yours)}${item.suffix}',
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              'vs ${_formatDecimal(item.platform)}${item.suffix}',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ClipRRect(
          borderRadius: AppRadii.xsRadius,
          child: LinearProgressIndicator(
            value: (item.yours / 100).clamp(.02, 1),
            minHeight: AppSpacing.x2,
            backgroundColor: AppColors.surface2,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
