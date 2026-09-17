part of 'predictions_tablet_pages.dart';

// ---------------------------------------------------------------------------
// SC-215: Hoạt động toàn cục prediction — thống kê trực tiếp + lọc số tiền
// tối thiểu + bảng tin giao dịch, state cục bộ như phone SC-034.
// ---------------------------------------------------------------------------

class PredictionsGlobalActivityTabletPage extends ConsumerStatefulWidget {
  const PredictionsGlobalActivityTabletPage({super.key});

  static const contentKey = Key('sc215_tablet_content');

  @override
  ConsumerState<PredictionsGlobalActivityTabletPage> createState() =>
      _PredictionsGlobalActivityTabletPageState();
}

class _PredictionsGlobalActivityTabletPageState
    extends ConsumerState<PredictionsGlobalActivityTabletPage> {
  double _minAmount = 0;

  static const _amountSteps = <double>[0, 100, 500, 1000, 5000];

  @override
  Widget build(BuildContext context) {
    final activityAsync = ref.watch(
      predictionsGlobalActivitySnapshotProvider(_minAmount),
    );

    return activityAsync.when(
      loading: () => _frame(children: const [VitSkeletonList(rows: 6)]),
      error: (error, stackTrace) => _frame(
        children: [
          _pdmError(
            'Không tải được hoạt động toàn cầu',
            () => ref.invalidate(
              predictionsGlobalActivitySnapshotProvider(_minAmount),
            ),
          ),
        ],
      ),
      data: (snapshot) => _frame(
        subtitle: '${snapshot.buyCount} mua · ${snapshot.sellCount} bán',
        children: [
          VitCard(
            density: VitDensity.compact,
            child: Row(
              children: [
                Expanded(
                  child: _Sc215LiveStat(
                    label: 'Khối lượng 24h',
                    value: VitFormat.compactSuffix(
                      snapshot.totalVolume,
                      prefix: r'$',
                    ),
                  ),
                ),
                Expanded(
                  child: _Sc215LiveStat(
                    label: 'Lệnh mua',
                    value: VitFormat.count(snapshot.buyCount),
                    valueColor: AppColors.buy,
                  ),
                ),
                Expanded(
                  child: _Sc215LiveStat(
                    label: 'Lệnh bán',
                    value: VitFormat.count(snapshot.sellCount),
                    valueColor: AppColors.sell,
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (
                  var index = 0;
                  index < _amountSteps.length;
                  index += 1
                ) ...[
                  VitChoicePill(
                    label: _amountSteps[index] == 0
                        ? 'Tất cả'
                        : '${VitFormat.compactSuffix(_amountSteps[index], prefix: r'$')}+',
                    selected: _minAmount == _amountSteps[index],
                    onTap: () => setState(() {
                      _minAmount = _amountSteps[index];
                    }),
                    accentColor: AppColors.primary,
                  ),
                  if (index != _amountSteps.length - 1)
                    const SizedBox(width: TabletSpacingTokens.x1),
                ],
              ],
            ),
          ),
          if (snapshot.activities.isEmpty)
            const VitEmptyState(
              title: 'Không có hoạt động',
              message: 'Hạ mức lọc số tiền tối thiểu để xem thêm',
              icon: Icons.timeline_rounded,
            )
          else
            VitPageSection(
              label: 'Bảng tin trực tiếp',
              accentColor: AppColors.primary,
              innerGap: TabletSpacingTokens.x4,
              children: [
                VitCard(
                  density: VitDensity.compact,
                  child: Column(
                    children: [
                      for (final activity in snapshot.activities)
                        _Sc215ActivityRow(activity: activity),
                    ],
                  ),
                ),
              ],
            ),
          _pdmBody('Cập nhật ${snapshot.lastUpdatedLabel}'),
        ],
      ),
    );
  }

  Widget _frame({required List<Widget> children, String? subtitle}) {
    return VitTabletSectionFrame(
      semanticIdentifier: 'SC-215',
      semanticLabel: 'Hoạt động toàn cục prediction',
      title: 'Hoạt động toàn cục',
      subtitle: subtitle ?? 'Bảng tin giao dịch trực tiếp',
      contentKey: PredictionsGlobalActivityTabletPage.contentKey,
      backFallback: AppRoutePaths.marketsPredictions,
      children: children,
    );
  }
}

class _Sc215LiveStat extends StatelessWidget {
  const _Sc215LiveStat({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: TabletSpacingTokens.x1),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _Sc215ActivityRow extends StatelessWidget {
  const _Sc215ActivityRow({required this.activity});

  final PredictionGlobalActivityDraft activity;

  @override
  Widget build(BuildContext context) {
    final isBuy = activity.action == PredictionGlobalActivityAction.bought;
    final color = isBuy ? AppColors.buy : AppColors.sell;
    return Padding(
      padding: TabletSpacingTokens.tableCellPaddingV,
      child: Row(
        children: [
          CircleAvatar(
            radius: TabletSpacingTokens.iconSm,
            backgroundColor: AppColors.surface2,
            child: Text(
              activity.avatar,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const SizedBox(width: TabletSpacingTokens.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: TabletSpacingTokens.x1,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      activity.user,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    _pdmTinyBadge(
                      label: isBuy ? 'Mua' : 'Bán',
                      color: color,
                      background: color.withValues(alpha: .12),
                    ),
                    Text(
                      activity.outcome,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${VitFormat.count(activity.shares)} cổ phần @ '
                  '${VitFormat.usd(activity.price)}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                VitFormat.usd(activity.amount),
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              const SizedBox(height: TabletSpacingTokens.x1),
              Text(
                activity.timestamp,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SC-219: Lịch sự kiện prediction — lọc danh mục + dòng thời gian theo tháng
// (chốt kèo, xác suất, đang theo dõi), state cục bộ như phone SC-039.
// ---------------------------------------------------------------------------

class PredictionEventCalendarTabletPage extends ConsumerStatefulWidget {
  const PredictionEventCalendarTabletPage({super.key});

  static const contentKey = Key('sc219_tablet_content');
  static const controlPaneKey = Key('sc219_tablet_control_pane');
  static const allCategoryKey = Key('sc219_category_all');

  @override
  ConsumerState<PredictionEventCalendarTabletPage> createState() =>
      _PredictionEventCalendarTabletPageState();
}

class _PredictionEventCalendarTabletPageState
    extends ConsumerState<PredictionEventCalendarTabletPage> {
  String? _category;

  @override
  Widget build(BuildContext context) {
    final calendarAsync = ref.watch(
      predictionsEventCalendarSnapshotProvider(_category),
    );

    return calendarAsync.when(
      loading: () => _frame(
        context,
        body: _pdmStatusBody(
          PredictionEventCalendarTabletPage.contentKey,
          const [VitSkeletonList(rows: 6)],
        ),
      ),
      error: (error, stackTrace) => _frame(
        context,
        body: _pdmStatusBody(PredictionEventCalendarTabletPage.contentKey, [
          _pdmError(
            'Không tải được lịch sự kiện',
            () => ref.invalidate(
              predictionsEventCalendarSnapshotProvider(_category),
            ),
          ),
        ]),
      ),
      data: (snapshot) {
        final categoryChips = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              VitFilterChip(
                key: PredictionEventCalendarTabletPage.allCategoryKey,
                label: 'Tất cả',
                active: _category == null,
                onTap: () => setState(() {
                  _category = null;
                }),
                color: AppColors.primary,
              ),
              const SizedBox(width: TabletSpacingTokens.x2),
              for (
                var index = 0;
                index < snapshot.categories.length;
                index += 1
              ) ...[
                VitFilterChip(
                  label: snapshot.categories[index],
                  active: _category == snapshot.categories[index],
                  onTap: () => setState(() {
                    _category = _category == snapshot.categories[index]
                        ? null
                        : snapshot.categories[index];
                  }),
                  color: AppColors.primary,
                ),
                if (index != snapshot.categories.length - 1)
                  const SizedBox(width: TabletSpacingTokens.x2),
              ],
            ],
          ),
        );
        final months = [
          for (final month in snapshot.months)
            VitPageSection(
              label: month.label,
              accentColor: AppColors.primary,
              innerGap: TabletSpacingTokens.x4,
              children: [
                PredictionTabletCardGrid(
                  children: [
                    for (final event in month.events)
                      _Sc219CalendarEventCard(event: event),
                  ],
                ),
              ],
            ),
        ];
        final footer = _pdmBody('Cập nhật ${snapshot.lastUpdatedLabel}');
        return _frame(
          context,
          subtitle: '${snapshot.events.length} sự kiện',
          body: VitTabletPaneWorkspace(
            contentKey: PredictionEventCalendarTabletPage.contentKey,
            secondaryContentKey:
                PredictionEventCalendarTabletPage.controlPaneKey,
            primaryChildren: [...months, footer],
            secondaryChildren: [categoryChips],
            narrowChildren: [categoryChips, ...months, footer],
          ),
        );
      },
    );
  }

  Widget _frame(
    BuildContext context, {
    required Widget body,
    String? subtitle,
  }) {
    final showBack = context.canPop();
    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Lịch sự kiện prediction',
      semanticIdentifier: 'SC-219',
      child: Column(
        children: [
          VitHeader(
            title: 'Lịch sự kiện',
            subtitle: subtitle ?? 'Ngày chốt kèo · Theo dõi',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.marketsPredictions,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}

class _Sc219CalendarEventCard extends StatelessWidget {
  const _Sc219CalendarEventCard({required this.event});

  final PredictionCalendarEventDraft event;

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (event.status) {
      PredictionCalendarEventStatus.active => AppColors.buy,
      PredictionCalendarEventStatus.upcoming => AppColors.text3,
      PredictionCalendarEventStatus.resolving => AppColors.warn,
      PredictionCalendarEventStatus.resolved => AppColors.text3,
    };
    return VitCard(
      onTap: () => context.push(AppRoutePaths.marketsPredictionEvent(event.id)),
      density: VitDensity.compact,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${event.resolutionDate.day}',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: TabletSpacingTokens.x1),
              Text(
                'Tháng ${event.resolutionDate.month}',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(width: TabletSpacingTokens.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: TabletSpacingTokens.x1,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      event.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    if (event.isWatching)
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.warn,
                        size: TabletSpacingTokens.iconSm,
                      ),
                  ],
                ),
                Text(
                  '${event.category} · '
                  '${VitFormat.percent(event.probability, fractionDigits: 0)} · '
                  'khối lượng '
                  '${VitFormat.compactSuffix(event.volume, prefix: r'$')}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          _pdmTinyBadge(
            label: switch (event.status) {
              PredictionCalendarEventStatus.active => 'Đang mở',
              PredictionCalendarEventStatus.upcoming => 'Sắp mở',
              PredictionCalendarEventStatus.resolving => 'Đang chốt',
              PredictionCalendarEventStatus.resolved => 'Đã chốt',
            },
            color: statusColor,
            background: statusColor.withValues(alpha: .12),
          ),
        ],
      ),
    );
  }
}
