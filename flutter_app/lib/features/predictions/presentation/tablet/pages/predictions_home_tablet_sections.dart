part of 'predictions_home_tablet_page.dart';

class _Sc208Hero extends StatelessWidget {
  const _Sc208Hero({
    required this.openEventCount,
    required this.openPositionCount,
    required this.onPositionsTap,
  });

  final int openEventCount;
  final int openPositionCount;
  final VoidCallback onPositionsTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      padding: TabletSpacingTokens.cardPaddingHero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _Sc208HeroKpi(
                  label: 'Sự kiện mở',
                  value: VitFormat.count(openEventCount),
                  caption: 'Thị trường đang giao dịch',
                  valueColor: AppColors.text1,
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
                  child: Material(
                    color: AppColors.transparent,
                    child: InkWell(
                      key: PredictionsHomeTabletPage.myPredictionsKey,
                      onTap: onPositionsTap,
                      borderRadius: AppRadii.smRadius,
                      child: _Sc208HeroKpi(
                        label: 'Vị thế của tôi',
                        value: VitFormat.count(openPositionCount),
                        caption: 'Xem danh mục vị thế',
                        valueColor: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
          VitCtaButton(
            onPressed: () =>
                context.push(AppRoutePaths.marketsPredictionsBreaking),
            variant: VitCtaButtonVariant.secondary,
            leading: const Icon(Icons.bolt_outlined),
            child: const Text('Xem Biến động'),
          ),
        ],
      ),
    );
  }
}

/// Banner KPI ngang giữa chrome và hai cột (thiết kế nội dung mới
/// 2026-09-19 — idiom banner của dashboard chuẩn): 2 số KPI + CTA ghim
/// phải, cố định không cuộn theo cột; tầng hẹp giữ hero dọc [_Sc208Hero].
class _Sc208KpiBanner extends StatelessWidget {
  const _Sc208KpiBanner({
    required this.openEventCount,
    required this.openPositionCount,
    required this.onPositionsTap,
  });

  final int openEventCount;
  final int openPositionCount;
  final VoidCallback onPositionsTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      padding: TabletSpacingTokens.cardPaddingHero,
      child: Row(
        children: [
          Expanded(
            child: _Sc208HeroKpi(
              label: 'Sự kiện mở',
              value: VitFormat.count(openEventCount),
              caption: 'Thị trường đang giao dịch',
              valueColor: AppColors.text1,
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
              child: Material(
                color: AppColors.transparent,
                child: InkWell(
                  key: PredictionsHomeTabletPage.myPredictionsKey,
                  onTap: onPositionsTap,
                  borderRadius: AppRadii.smRadius,
                  child: _Sc208HeroKpi(
                    label: 'Vị thế của tôi',
                    value: VitFormat.count(openPositionCount),
                    caption: 'Xem danh mục vị thế',
                    valueColor: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: TabletSpacingTokens.x4),
          // Non-flex trong Row nhận width vô hạn — VitCtaButton có min-width
          // riêng nên phải bọc Flexible loose để nhận budget bounded.
          Flexible(
            fit: FlexFit.loose,
            child: VitCtaButton(
              onPressed: () =>
                  context.push(AppRoutePaths.marketsPredictionsBreaking),
              variant: VitCtaButtonVariant.secondary,
              leading: const Icon(Icons.bolt_outlined),
              child: const Text('Xem Biến động'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Sc208HeroKpi extends StatelessWidget {
  const _Sc208HeroKpi({
    required this.label,
    required this.value,
    required this.caption,
    required this.valueColor,
  });

  final String label;
  final String value;
  final String caption;
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
          style: AppTextStyles.heroNumber.copyWith(
            color: valueColor,
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

class _Sc208CategoryChips extends StatelessWidget {
  const _Sc208CategoryChips({
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
          VitFilterChip(
            key: PredictionsHomeTabletPage.categoryAllKey,
            label: 'Tất cả',
            active: activeCategory == null,
            onTap: () => onSelected(null),
            color: AppColors.primary,
          ),
          const SizedBox(width: TabletSpacingTokens.x2),
          for (var index = 0; index < categories.length; index += 1) ...[
            VitFilterChip(
              key: categories[index] == 'Live Crypto'
                  ? PredictionsHomeTabletPage.categoryLiveCryptoKey
                  : Key('sc208_category_${categories[index]}'),
              label: categories[index],
              active: activeCategory == categories[index],
              onTap: () => onSelected(
                activeCategory == categories[index] ? null : categories[index],
              ),
              color: AppColors.primary,
            ),
            if (index != categories.length - 1)
              const SizedBox(width: TabletSpacingTokens.x2),
          ],
        ],
      ),
    );
  }
}

class _Sc208BreakingMoversStrip extends StatelessWidget {
  const _Sc208BreakingMoversStrip({
    required this.snapshot,
    required this.onTap,
  });

  final PredictionHomeSnapshot snapshot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (snapshot.breakingMovers.isEmpty) {
      return const SizedBox.shrink();
    }

    final movers = snapshot.breakingMovers.take(2).toList();
    return Material(
      key: PredictionsHomeTabletPage.breakingMoversKey,
      color: AppColors.surface2,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onTap,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Biến động 24h',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: TabletSpacingTokens.x1),
                    Text(
                      movers
                          .map(
                            (mover) => VitFormat.signedPercent(mover.change24h),
                          )
                          .join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: TabletSpacingTokens.iconMd,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Sc208ArenaBridgeCard extends StatelessWidget {
  const _Sc208ArenaBridgeCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: PredictionsHomeTabletPage.arenaBridgeKey,
      onTap: onTap,
      density: VitDensity.compact,
      child: Row(
        children: [
          const SizedBox.square(
            dimension: TabletSpacingTokens.accentIconBoxSize,
            child: Material(
              color: AppColors.surface2,
              borderRadius: AppRadii.smRadius,
              child: Icon(
                Icons.sports_esports_outlined,
                color: AppColors.text2,
                size: TabletSpacingTokens.iconMd,
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
                      'Thử thách cùng chủ đề',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const PredictionSmallBadge(
                      label: 'Chỉ điểm Arena',
                      color: AppColors.text3,
                      background: AppColors.surface2,
                    ),
                  ],
                ),
                const SizedBox(height: TabletSpacingTokens.x1),
                Text(
                  'Khám phá phòng xã hội chỉ dùng điểm Arena trong Open Arena',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: TabletSpacingTokens.iconMd,
          ),
        ],
      ),
    );
  }
}

class _Sc208EmptyState extends StatelessWidget {
  const _Sc208EmptyState({
    required this.hasActiveFilters,
    required this.onClearFilters,
    required this.onBreaking,
  });

  final bool hasActiveFilters;
  final VoidCallback onClearFilters;
  final VoidCallback onBreaking;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.event_busy_outlined,
            color: AppColors.text3.withValues(alpha: .40),
            size: TabletSpacingTokens.iconLg,
          ),
          const SizedBox(height: TabletSpacingTokens.x3),
          Text(
            'Không có sự kiện phù hợp',
            style: AppTextStyles.body.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x1),
          Text(
            'Thử điều chỉnh bộ lọc hoặc xem sự kiện biến động',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          if (hasActiveFilters) ...[
            const SizedBox(height: TabletSpacingTokens.x4),
            VitCtaButton(
              onPressed: onClearFilters,
              child: const Text('Xóa bộ lọc'),
            ),
          ],
          const SizedBox(height: TabletSpacingTokens.x3),
          TextButton(
            onPressed: onBreaking,
            child: Text(
              'Xem Biến động',
              style: AppTextStyles.caption.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

const _sc208Tools = <({String id, String label, String route})>[
  (
    id: 'portfolio',
    label: 'Danh mục',
    route: AppRoutePaths.marketsPredictionsPortfolio,
  ),
  (
    id: 'portfolio_analyzer',
    label: 'Phân tích',
    route: AppRoutePaths.marketsPredictionsPortfolioAnalyzer,
  ),
  (
    id: 'leaderboard',
    label: 'BXH',
    route: AppRoutePaths.marketsPredictionsLeaderboard,
  ),
  (
    id: 'calendar',
    label: 'Lịch',
    route: AppRoutePaths.marketsPredictionsEventCalendar,
  ),
];

class _Sc208ToolsSection extends StatelessWidget {
  const _Sc208ToolsSection({required this.onNavigate});

  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: PredictionsHomeTabletPage.toolsSectionKey,
      label: 'Công cụ dự đoán',
      headerIcon: Icons.grid_view_rounded,
      headerIconColor: AppColors.primary,
      headerVariant: VitSectionHeaderVariant.plain,
      accentColor: AppColors.primary,
      innerGap: TabletSpacingTokens.x4,
      children: [
        VitPresetChipRow<String>(
          items: [
            for (final tool in _sc208Tools)
              VitPresetChipItem<String>(
                key: PredictionsHomeTabletPage.toolKey(tool.id),
                value: tool.route,
                label: tool.label,
                semanticLabel: 'Mở ${tool.label}',
              ),
          ],
          onTap: onNavigate,
          accentColor: AppColors.primary,
        ),
      ],
    );
  }
}

class _Sc208RiskDisclaimer extends StatelessWidget {
  const _Sc208RiskDisclaimer();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Vị thế dự đoán không đảm bảo kết quả. Xác suất thay đổi theo thị '
      'trường; xem quy tắc resolution trước khi mở vị thế.',
      style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      textAlign: TextAlign.center,
    );
  }
}
