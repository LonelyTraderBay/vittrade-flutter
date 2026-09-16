part of 'predictions_tablet_pages.dart';

// ---------------------------------------------------------------------------
// SC-213: Phần thưởng thanh khoản prediction — hero quỹ ngày + lọc danh mục
// + bảng cơ hội kiếm thưởng, state cục bộ như phone SC-032.
// ---------------------------------------------------------------------------

class PredictionsRewardsTabletPage extends ConsumerStatefulWidget {
  const PredictionsRewardsTabletPage({super.key});

  static const contentKey = Key('sc213_tablet_content');
  static const allCategoryKey = Key('sc213_category_all');

  @override
  ConsumerState<PredictionsRewardsTabletPage> createState() =>
      _PredictionsRewardsTabletPageState();
}

class _PredictionsRewardsTabletPageState
    extends ConsumerState<PredictionsRewardsTabletPage> {
  String? _category;

  @override
  Widget build(BuildContext context) {
    final rewardsAsync = ref.watch(predictionsRewardsSnapshotProvider);

    return rewardsAsync.when(
      loading: () => _frame(children: const [VitSkeletonList(rows: 6)]),
      error: (error, stackTrace) => _frame(
        children: [
          _pdmError(
            'Không tải được phần thưởng',
            () => ref.invalidate(predictionsRewardsSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) {
        final rewards = _category == null
            ? snapshot.rewards
            : snapshot.rewards
                  .where((reward) => reward.category == _category)
                  .toList();
        return _frame(
          subtitle: 'Quỹ ngày ${_pdmUsd(snapshot.totalDailyPool)}',
          children: [
            VitCard(
              variant: VitCardVariant.hero,
              radius: VitCardRadius.large,
              padding: TabletSpacingTokens.cardPaddingHero,
              child: Row(
                children: [
                  Expanded(
                    child: _Sc213HeroKpi(
                      label: 'Quỹ thưởng hàng ngày',
                      value: VitFormat.usd(snapshot.totalDailyPool),
                      caption: 'Chia đều theo thanh khoản cung cấp',
                    ),
                  ),
                  const SizedBox(
                    width: TabletSpacingTokens.dividerHairline,
                    height: TabletSpacingTokens.x6,
                    child: ColoredBox(color: AppColors.border),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: TabletSpacingTokens.x4,
                      ),
                      child: _Sc213HeroKpi(
                        label: 'Cơ hội đang mở',
                        value: VitFormat.count(snapshot.rewards.length),
                        caption: 'Sự kiện cần thanh khoản hai bên',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  VitFilterChip(
                    key: PredictionsRewardsTabletPage.allCategoryKey,
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
            ),
            VitPageSection(
              label: 'Cơ hội kiếm thưởng',
              accentColor: AppColors.primary,
              innerGap: TabletSpacingTokens.x4,
              children: [
                VitCard(
                  density: VitDensity.compact,
                  child: Column(
                    children: [
                      const _Sc213RewardHeader(),
                      const SizedBox(height: TabletSpacingTokens.x3),
                      for (final reward in rewards)
                        _Sc213RewardRow(reward: reward),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _frame({required List<Widget> children, String? subtitle}) {
    return VitTabletSectionFrame(
      gutterFlush: true,
      semanticIdentifier: 'SC-213',
      semanticLabel: 'Phần thưởng prediction',
      title: 'Phần thưởng',
      subtitle: subtitle ?? 'Quỹ hàng ngày',
      contentKey: PredictionsRewardsTabletPage.contentKey,
      backFallback: AppRoutePaths.marketsPredictions,
      children: children,
    );
  }
}

class _Sc213HeroKpi extends StatelessWidget {
  const _Sc213HeroKpi({
    required this.label,
    required this.value,
    required this.caption,
  });

  final String label;
  final String value;
  final String caption;

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
          style: AppTextStyles.heroNumber.copyWith(
            color: AppColors.text1,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        const SizedBox(height: TabletSpacingTokens.x1),
        Text(
          caption,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _Sc213RewardHeader extends StatelessWidget {
  const _Sc213RewardHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          flex: 3,
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: _Sc213RewardLabel('DANH MỤC'),
          ),
        ),
        Expanded(child: _Sc213RewardLabel('SPREAD TỐI ĐA', alignEnd: true)),
        Expanded(child: _Sc213RewardLabel('CỔ PHẦN TỐI THIỂU', alignEnd: true)),
        Expanded(child: _Sc213RewardLabel('THƯỞNG/NGÀY', alignEnd: true)),
      ],
    );
  }
}

class _Sc213RewardLabel extends StatelessWidget {
  const _Sc213RewardLabel(this.label, {this.alignEnd = false});

  final String label;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: alignEnd ? TextAlign.end : TextAlign.start,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text3,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}

class _Sc213RewardRow extends StatelessWidget {
  const _Sc213RewardRow({required this.reward});

  final PredictionRewardOpportunityDraft reward;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: TabletSpacingTokens.tableCellPaddingV,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              reward.category,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              VitFormat.percent(reward.maxSpread, fractionDigits: 1),
              textAlign: TextAlign.end,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          Expanded(
            child: Text(
              VitFormat.count(reward.minShares),
              textAlign: TextAlign.end,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          Expanded(
            child: Text(
              VitFormat.usd(reward.dailyReward),
              textAlign: TextAlign.end,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.buy,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
