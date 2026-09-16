part of 'predictions_tablet_pages.dart';

// ---------------------------------------------------------------------------
// SC-210: Biến động mạnh — tổng quan tăng/giảm + lọc danh mục + thẻ mover
// xếp hạng + đăng ký email báo cáo, state cục bộ như phone SC-029.
// ---------------------------------------------------------------------------

class PredictionsBreakingTabletPage extends ConsumerStatefulWidget {
  const PredictionsBreakingTabletPage({super.key});

  static const contentKey = Key('sc210_tablet_content');
  static const allTabKey = Key('sc210_tab_all');
  static const cryptoTabKey = Key('sc210_tab_live_crypto');
  static const subscribeKey = Key('sc210_subscribe');

  static Key moverKey(String id) => Key('sc210_mover_$id');

  @override
  ConsumerState<PredictionsBreakingTabletPage> createState() =>
      _PredictionsBreakingTabletPageState();
}

class _PredictionsBreakingTabletPageState
    extends ConsumerState<PredictionsBreakingTabletPage> {
  final _emailController = TextEditingController();
  String? _category;
  bool _subscribed = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final breakingAsync = ref.watch(
      predictionsBreakingSnapshotProvider(_category),
    );

    return breakingAsync.when(
      loading: () => _frame(children: const [VitSkeletonList(rows: 6)]),
      error: (error, stackTrace) => _frame(
        children: [
          _pdmError(
            'Không tải được biến động',
            () =>
                ref.invalidate(predictionsBreakingSnapshotProvider(_category)),
          ),
        ],
      ),
      data: (snapshot) => _frame(
        subtitle: '${snapshot.upCount} tăng · ${snapshot.downCount} giảm',
        children: [
          _Sc210MovementSummary(snapshot: snapshot),
          _Sc210CategoryTabs(
            categories: snapshot.categories,
            activeCategory: _category,
            onSelected: (value) => setState(() {
              _category = value;
            }),
          ),
          if (snapshot.movers.isEmpty)
            _Sc210BreakingEmptyState(
              onShowAll: () => setState(() {
                _category = null;
              }),
            )
          else
            for (var index = 0; index < snapshot.movers.length; index += 1)
              _Sc210MoverCard(
                key: PredictionsBreakingTabletPage.moverKey(
                  snapshot.movers[index].id,
                ),
                event: snapshot.movers[index],
                rank: index + 1,
                onTap: () => context.push(
                  AppRoutePaths.marketsPredictionEvent(
                    snapshot.movers[index].id,
                  ),
                ),
              ),
          _Sc210EmailCta(
            controller: _emailController,
            subscribed: _subscribed,
            onSubscribe: () => setState(() {
              if (_emailController.text.contains('@')) {
                _subscribed = true;
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _frame({required List<Widget> children, String? subtitle}) {
    return VitTabletSectionFrame(
      gutterFlush: true,
      semanticIdentifier: 'SC-210',
      semanticLabel: 'Biến động prediction',
      title: 'Biến động',
      subtitle: subtitle ?? 'Xác suất thay đổi 24h',
      contentKey: PredictionsBreakingTabletPage.contentKey,
      backFallback: AppRoutePaths.marketsPredictions,
      children: children,
    );
  }
}

class _Sc210MovementSummary extends StatelessWidget {
  const _Sc210MovementSummary({required this.snapshot});

  final PredictionBreakingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface2,
      borderRadius: AppRadii.inputRadius,
      child: Padding(
        padding: TabletSpacingTokens.cardPaddingCompact,
        child: Row(
          children: [
            const SizedBox.square(
              dimension: TabletSpacingTokens.iconSm,
              child: Icon(
                Icons.bolt_outlined,
                color: AppColors.warn,
                size: TabletSpacingTokens.iconSm,
              ),
            ),
            const SizedBox(width: TabletSpacingTokens.x2),
            Expanded(
              child: Text(
                'Biến động 24h',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            _Sc210MovementCount(
              icon: Icons.trending_up_rounded,
              label: '${snapshot.upCount} tăng',
              color: AppColors.buy,
            ),
            const SizedBox(width: TabletSpacingTokens.x2),
            _Sc210MovementCount(
              icon: Icons.trending_down_rounded,
              label: '${snapshot.downCount} giảm',
              color: AppColors.sell,
            ),
          ],
        ),
      ),
    );
  }
}

class _Sc210MovementCount extends StatelessWidget {
  const _Sc210MovementCount({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox.square(
          dimension: TabletSpacingTokens.iconSm,
          child: Icon(icon, color: color, size: TabletSpacingTokens.iconSm),
        ),
        const SizedBox(width: TabletSpacingTokens.x1),
        Text(
          label,
          style: AppTextStyles.badge.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _Sc210CategoryTabs extends StatelessWidget {
  const _Sc210CategoryTabs({
    required this.categories,
    required this.activeCategory,
    required this.onSelected,
  });

  final List<String> categories;
  final String? activeCategory;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var index = 0; index < categories.length + 1; index += 1) ...[
            VitChoicePill(
              key: index == 0
                  ? PredictionsBreakingTabletPage.allTabKey
                  : categories[index - 1] == 'Live Crypto'
                  ? PredictionsBreakingTabletPage.cryptoTabKey
                  : Key('sc210_category_${categories[index - 1]}'),
              label: index == 0
                  ? 'Tất cả'
                  : categories[index - 1] == 'Live Crypto'
                  ? 'Crypto'
                  : categories[index - 1],
              selected: index == 0
                  ? activeCategory == null
                  : activeCategory == categories[index - 1],
              onTap: () =>
                  onSelected(index == 0 ? null : categories[index - 1]),
              accentColor: AppColors.primary,
            ),
            if (index != categories.length)
              const SizedBox(width: TabletSpacingTokens.x1),
          ],
        ],
      ),
    );
  }
}

class _Sc210MoverCard extends StatelessWidget {
  const _Sc210MoverCard({
    super.key,
    required this.event,
    required this.rank,
    required this.onTap,
  });

  final PredictionEventDraft event;
  final int rank;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final topOutcome = event.outcomes.first;
    final isUp = event.change24h > 0;
    final rankColor = switch (rank) {
      1 => AppColors.warn,
      2 => AppColors.medalSilverBlue,
      3 => AppColors.medalBronze,
      _ => AppColors.text3,
    };
    final changeColor = isUp ? AppColors.buy : AppColors.sell;

    return VitCard(
      onTap: onTap,
      density: VitDensity.compact,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: rank <= 3
                ? rankColor.withValues(alpha: .12)
                : AppColors.surface2,
            borderRadius: AppRadii.smRadius,
            child: SizedBox.square(
              dimension: TabletSpacingTokens.accentIconBoxSize,
              child: Center(
                child: Text(
                  '$rank',
                  style: AppTextStyles.caption.copyWith(
                    color: rankColor,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: TabletSpacingTokens.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: TabletSpacingTokens.x1),
                Wrap(
                  spacing: TabletSpacingTokens.x1,
                  runSpacing: TabletSpacingTokens.x1,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Kết quả hàng đầu: '
                      '${VitFormat.percent(topOutcome.chance, fractionDigits: 0)}',
                      style: AppTextStyles.numericMicro.copyWith(
                        color: topOutcome.chance >= 50
                            ? AppColors.buy
                            : AppColors.sell,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                    _Sc210ChangeBadge(
                      value: event.change24h,
                      color: changeColor,
                    ),
                  ],
                ),
                const SizedBox(height: TabletSpacingTokens.x1),
                Text(
                  '${event.category} · khối lượng 24h '
                  '${VitFormat.compactSuffix(event.volume24h, prefix: r'$')}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Sc210ChangeBadge extends StatelessWidget {
  const _Sc210ChangeBadge({required this.value, required this.color});

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: .12),
      borderRadius: AppRadii.badgeRadius,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: TabletSpacingTokens.x2,
          vertical: TabletSpacingTokens.x1,
        ),
        child: Text(
          VitFormat.signedPercent(value),
          style: AppTextStyles.badge.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _Sc210BreakingEmptyState extends StatelessWidget {
  const _Sc210BreakingEmptyState({required this.onShowAll});

  final VoidCallback onShowAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.trending_flat_rounded,
            color: AppColors.text3.withValues(alpha: .40),
            size: TabletSpacingTokens.iconLg,
          ),
          const SizedBox(height: TabletSpacingTokens.x3),
          Text(
            'Không có biến động trong danh mục này',
            style: AppTextStyles.body.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x1),
          Text(
            'Xem tất cả danh mục để không bỏ sót mover mới',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
          VitCtaButton(
            onPressed: onShowAll,
            child: const Text('Xem tất cả danh mục'),
          ),
        ],
      ),
    );
  }
}

class _Sc210EmailCta extends StatelessWidget {
  const _Sc210EmailCta({
    required this.controller,
    required this.subscribed,
    required this.onSubscribe,
  });

  final TextEditingController controller;
  final bool subscribed;
  final VoidCallback onSubscribe;

  @override
  Widget build(BuildContext context) {
    if (subscribed) {
      return const VitBanner(
        variant: VitBannerVariant.success,
        title: 'Đã đăng ký',
        message: 'Bạn sẽ nhận báo cáo biến động 24h qua email.',
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Nhận báo cáo biến động 24h',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: TabletSpacingTokens.x3),
        VitInput(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          semanticLabel: 'Email nhận báo cáo biến động',
          hintText: 'email@vidu.com',
        ),
        const SizedBox(height: TabletSpacingTokens.x3),
        VitCtaButton(
          key: PredictionsBreakingTabletPage.subscribeKey,
          onPressed: onSubscribe,
          variant: VitCtaButtonVariant.secondary,
          child: const Text('Đăng ký'),
        ),
      ],
    );
  }
}
