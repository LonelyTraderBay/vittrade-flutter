import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/predictions_controller_providers.dart';
import 'package:vit_trade_flutter/features/predictions/domain/entities/predictions_entities.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part 'predictions_tablet_pages_explore.dart';
part 'predictions_tablet_pages_explore2.dart';

String _pdmUsd(num v) => VitFormat.usd(v.toDouble());
String _pdmUsdS(num v) => VitFormat.usdSigned(v.toDouble());
String _pdmPct(num v, [int d = 1]) => VitFormat.percent(v, fractionDigits: d);
String _pdmDec(num v, [int d = 2]) => v.toStringAsFixed(d);

Widget _pdmFrame({
  required BuildContext context,
  required String semanticIdentifier,
  required String semanticLabel,
  required String title,
  required String subtitle,
  required Widget child,
  Key? contentKey,
}) {
  final showBack = context.canPop();
  return VitPageLayout(
    variant: VitPageVariant.flush,
    semanticLabel: semanticLabel,
    semanticIdentifier: semanticIdentifier,
    child: Column(
      children: [
        VitHeader(
          title: title,
          subtitle: subtitle,
          showBack: showBack,
          onBack: showBack
              ? () => goBackOrFallback(
                  context,
                  fallbackPath: AppRoutePaths.marketsPredictions,
                  mode: BackNavigationMode.historyThenFallback,
                )
              : null,
        ),
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1080),
              child: SingleChildScrollView(
                key: contentKey,
                padding: const EdgeInsets.fromLTRB(
                  TabletSpacingTokens.x6,
                  TabletSpacingTokens.x4,
                  TabletSpacingTokens.x6,
                  TabletSpacingTokens.x6,
                ),
                child: child,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _pdmError(String title, VoidCallback onRetry) {
  return VitErrorState(
    title: title,
    message: 'Vui lòng kiểm tra kết nối và thử lại.',
    actionLabel: 'Thử lại',
    onAction: onRetry,
  );
}

Widget _pdmSection({required String title, required List<Widget> rows}) {
  return VitCard(
    radius: VitCardRadius.tight,
    padding: TabletSpacingTokens.cardPaddingCompact,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.control.copyWith(
            fontWeight: AppTextStyles.bold,
            color: AppColors.text1,
          ),
        ),
        const SizedBox(height: TabletSpacingTokens.x2),
        ...rows,
      ],
    ),
  );
}

List<Widget> _pdmRows(List<(String, String)> pairs) {
  return [
    for (final (label, value) in pairs)
      Padding(
        padding: TabletSpacingTokens.tableCellPaddingV,
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
          ],
        ),
      ),
  ];
}

List<Widget> _pdmBullets(List<String> notes) {
  return [
    for (final note in notes)
      Padding(
        padding: TabletSpacingTokens.tableCellPaddingV,
        child: VitBulletRow(text: note),
      ),
  ];
}

Widget _pdmBody(String text) {
  return Text(
    text,
    style: AppTextStyles.caption.copyWith(color: AppColors.text2, height: 1.3),
  );
}

Widget _pdmQuickLinks(BuildContext context, List<(String, String)> links) {
  return Wrap(
    spacing: TabletSpacingTokens.x2,
    runSpacing: TabletSpacingTokens.x2,
    children: [
      for (final (label, path) in links)
        VitFilterChip(
          label: label,
          active: false,
          color: AppColors.primary,
          onTap: () => context.go(path),
        ),
    ],
  );
}

List<Widget> _pdmEventRows(
  BuildContext context,
  List<PredictionEventDraft> events,
) {
  return [
    for (final event in events.take(10))
      Padding(
        padding: TabletSpacingTokens.tableCellPaddingV,
        child: Material(
          color: AppColors.transparent,
          child: InkWell(
            onTap: () =>
                context.go(AppRoutePaths.marketsPredictionEvent(event.id)),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: AppTextStyles.bold,
                          color: AppColors.text1,
                        ),
                      ),
                      Text(
                        '${event.category} · khối lượng 24h ${_pdmUsd(event.volume24h)}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${event.outcomes.length} kết quả',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ),
      ),
  ];
}

/// SC-208: Hub Prediction Markets.
class PredictionsHomeTabletPage extends ConsumerWidget {
  const PredictionsHomeTabletPage({super.key});

  static const contentKey = Key('sc208_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      predictionsHomeSnapshotProvider((
        filter: PredictionFilterTab.trending,
        category: null,
        searchQuery: '',
      )),
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _pdmFrame(
        context: context,
        semanticIdentifier: 'SC-208',
        semanticLabel: 'Thị trường dự đoán',
        title: 'Prediction Markets',
        subtitle: 'Sự kiện · Xác suất',
        contentKey: PredictionsHomeTabletPage.contentKey,
        child: _pdmError(
          'Không tải được prediction',
          () => ref.invalidate(
            predictionsHomeSnapshotProvider((
              filter: PredictionFilterTab.trending,
              category: null,
              searchQuery: '',
            )),
          ),
        ),
      ),
      data: (snapshot) => _pdmFrame(
        context: context,
        semanticIdentifier: 'SC-208',
        semanticLabel: 'Thị trường dự đoán',
        title: 'Prediction Markets',
        subtitle: '${snapshot.openPositionCount} vị thế mở',
        contentKey: PredictionsHomeTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _pdmSection(
              title: 'Sự kiện nổi bật',
              rows: _pdmEventRows(context, snapshot.events),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _pdmSection(
              title: 'Danh mục',
              rows: _pdmBullets(snapshot.categories),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _pdmSection(
              title: 'Khám phá',
              rows: [
                _pdmQuickLinks(context, [
                  ('Tìm kiếm', AppRoutePaths.marketsPredictionsSearch),
                  ('Biến động mạnh', AppRoutePaths.marketsPredictionsBreaking),
                  ('Danh mục', AppRoutePaths.marketsPredictionsPortfolio),
                  ('Phần thưởng', AppRoutePaths.marketsPredictionsRewards),
                  (
                    'Bảng xếp hạng',
                    AppRoutePaths.marketsPredictionsLeaderboard,
                  ),
                  ('Hoạt động', AppRoutePaths.marketsPredictionsActivity),
                  ('Giải đấu', AppRoutePaths.marketsPredictionsTournaments),
                  (
                    'Lịch sự kiện',
                    AppRoutePaths.marketsPredictionsEventCalendar,
                  ),
                  (
                    'Máy tính rủi ro',
                    AppRoutePaths.marketsPredictionsRiskCalculator,
                  ),
                  ('Market maker', AppRoutePaths.marketsPredictionsMarketMaker),
                  (
                    'Phân tích danh mục',
                    AppRoutePaths.marketsPredictionsPortfolioAnalyzer,
                  ),
                  ('Cộng đồng', AppRoutePaths.marketsPredictionsSocial),
                  (
                    'Tích hợp dữ liệu',
                    AppRoutePaths.marketsPredictionsDataIntegration,
                  ),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-209: Tìm kiếm sự kiện dự đoán.
class PredictionsSearchTabletPage extends ConsumerWidget {
  const PredictionsSearchTabletPage({super.key});

  static const contentKey = Key('sc209_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      predictionsSearchSnapshotProvider((
        sort: PredictionSearchSort.trending,
        status: PredictionStatusFilter.all,
        category: null,
        searchQuery: '',
      )),
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _pdmFrame(
        context: context,
        semanticIdentifier: 'SC-209',
        semanticLabel: 'Tìm kiếm prediction',
        title: 'Tìm kiếm',
        subtitle: 'Sự kiện · Kết quả',
        contentKey: PredictionsSearchTabletPage.contentKey,
        child: _pdmError(
          'Không tải được tìm kiếm',
          () => ref.invalidate(
            predictionsSearchSnapshotProvider((
              sort: PredictionSearchSort.trending,
              status: PredictionStatusFilter.all,
              category: null,
              searchQuery: '',
            )),
          ),
        ),
      ),
      data: (snapshot) => _pdmFrame(
        context: context,
        semanticIdentifier: 'SC-209',
        semanticLabel: 'Tìm kiếm prediction',
        title: 'Tìm kiếm',
        subtitle: '${snapshot.results.length} kết quả',
        contentKey: PredictionsSearchTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _pdmSection(
              title: 'Kết quả',
              rows: _pdmEventRows(context, snapshot.results),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _pdmSection(
              title: 'Cập nhật',
              rows: [_pdmBody('Cập nhật ${snapshot.lastUpdatedLabel}')],
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-210: Biến động mạnh.
class PredictionsBreakingTabletPage extends ConsumerWidget {
  const PredictionsBreakingTabletPage({super.key});

  static const contentKey = Key('sc210_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(predictionsBreakingSnapshotProvider(null));

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _pdmFrame(
        context: context,
        semanticIdentifier: 'SC-210',
        semanticLabel: 'Biến động prediction',
        title: 'Biến động mạnh',
        subtitle: 'Tăng · Giảm',
        contentKey: PredictionsBreakingTabletPage.contentKey,
        child: _pdmError(
          'Không tải được biến động',
          () => ref.invalidate(predictionsBreakingSnapshotProvider(null)),
        ),
      ),
      data: (snapshot) => _pdmFrame(
        context: context,
        semanticIdentifier: 'SC-210',
        semanticLabel: 'Biến động prediction',
        title: 'Biến động mạnh',
        subtitle: '${snapshot.upCount} tăng · ${snapshot.downCount} giảm',
        contentKey: PredictionsBreakingTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _pdmSection(
              title: 'Movers',
              rows: _pdmEventRows(context, snapshot.movers),
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-211: Chi tiết sự kiện dự đoán.
class PredictionEventDetailTabletPage extends ConsumerWidget {
  const PredictionEventDetailTabletPage({super.key, required this.eventId});

  static const contentKey = Key('sc211_tablet_content');

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      predictionsEventDetailSnapshotProvider(eventId),
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _pdmFrame(
        context: context,
        semanticIdentifier: 'SC-211',
        semanticLabel: 'Chi tiết sự kiện prediction',
        title: 'Chi tiết sự kiện',
        subtitle: eventId,
        contentKey: PredictionEventDetailTabletPage.contentKey,
        child: _pdmError(
          'Không tải được sự kiện',
          () => ref.invalidate(predictionsEventDetailSnapshotProvider(eventId)),
        ),
      ),
      data: (snapshot) => _pdmFrame(
        context: context,
        semanticIdentifier: 'SC-211',
        semanticLabel: 'Chi tiết sự kiện prediction',
        title: snapshot.event.title,
        subtitle: snapshot.event.category,
        contentKey: PredictionEventDetailTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _pdmSection(title: 'Quy tắc', rows: _pdmBullets(snapshot.rules)),
            const SizedBox(height: TabletSpacingTokens.x3),
            _stkLikeHolders(snapshot.topHolders),
            const SizedBox(height: TabletSpacingTokens.x3),
            _pdmSection(
              title: 'Liên quan',
              rows: [
                _pdmQuickLinks(context, [
                  (
                    'Biểu đồ nâng cao',
                    AppRoutePaths.marketsPredictionsAdvancedChart(eventId),
                  ),
                  ('Cộng đồng', AppRoutePaths.marketsPredictionsSocial),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _stkLikeHolders(List<PredictionHolderDraft> holders) {
    return _pdmSection(
      title: 'Nắm giữ lớn',
      rows: _pdmRows([
        for (final holder in holders.take(8))
          ('${holder.name} · ${holder.outcome}', '${holder.shares} cổ phần'),
      ]),
    );
  }
}

/// SC-212: Danh mục prediction.
class PredictionsPortfolioTabletPage extends ConsumerWidget {
  const PredictionsPortfolioTabletPage({super.key});

  static const contentKey = Key('sc212_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(predictionsPortfolioSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _pdmFrame(
        context: context,
        semanticIdentifier: 'SC-212',
        semanticLabel: 'Danh mục prediction',
        title: 'Danh mục prediction',
        subtitle: 'Vị thế · Lãi lỗ',
        contentKey: PredictionsPortfolioTabletPage.contentKey,
        child: _pdmError(
          'Không tải được danh mục',
          () => ref.invalidate(predictionsPortfolioSnapshotProvider),
        ),
      ),
      data: (value) {
        return _pdmFrame(
          context: context,
          semanticIdentifier: 'SC-212',
          semanticLabel: 'Danh mục prediction',
          title: 'Danh mục prediction',
          subtitle: 'Giá trị ${_pdmUsd(value.totalCurrentValue)}',
          contentKey: PredictionsPortfolioTabletPage.contentKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _pdmSection(
                title: 'Tổng quan',
                rows: _pdmRows([
                  ('Giá trị hiện tại', _pdmUsd(value.totalCurrentValue)),
                  ('Đã đầu tư', _pdmUsd(value.totalInvested)),
                  ('Lãi lỗ', _pdmUsdS(value.totalPnl)),
                ]),
              ),
              const SizedBox(height: TabletSpacingTokens.x3),
              _pdmSection(
                title: 'Vị thế',
                rows: [
                  for (final position in value.positions)
                    Padding(
                      padding: TabletSpacingTokens.tableCellPaddingV,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  position.outcome,
                                  style: AppTextStyles.caption.copyWith(
                                    fontWeight: AppTextStyles.bold,
                                    color: AppColors.text1,
                                  ),
                                ),
                                Text(
                                  '${_pdmDec(position.shares, 1)} cổ phần · giá TB ${_pdmDec(position.avgPrice)}',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.text2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            _pdmUsdS(position.pnl),
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: AppTextStyles.bold,
                              color: position.pnl >= 0
                                  ? AppColors.buy
                                  : AppColors.sell,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: TabletSpacingTokens.x3),
              _pdmSection(
                title: 'Biên lai',
                rows: [
                  for (final receipt in value.receipts.take(6))
                    Padding(
                      padding: TabletSpacingTokens.tableCellPaddingV,
                      child: Material(
                        color: AppColors.transparent,
                        child: InkWell(
                          onTap: () => context.go(
                            AppRoutePaths.marketsPredictionReceipt(receipt.id),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${receipt.outcome} · ${receipt.status}',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.text1,
                                  ),
                                ),
                              ),
                              Text(
                                _pdmUsd(receipt.total),
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                  color: AppColors.text1,
                                  fontFeatures: AppTextStyles.tabularFigures,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

/// SC-213: Phần thưởng thanh khoản prediction.
class PredictionsRewardsTabletPage extends ConsumerWidget {
  const PredictionsRewardsTabletPage({super.key});

  static const contentKey = Key('sc213_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(predictionsRewardsSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _pdmFrame(
        context: context,
        semanticIdentifier: 'SC-213',
        semanticLabel: 'Phần thưởng prediction',
        title: 'Phần thưởng',
        subtitle: 'Quỹ hàng ngày',
        contentKey: PredictionsRewardsTabletPage.contentKey,
        child: _pdmError(
          'Không tải được phần thưởng',
          () => ref.invalidate(predictionsRewardsSnapshotProvider),
        ),
      ),
      data: (snapshot) => _pdmFrame(
        context: context,
        semanticIdentifier: 'SC-213',
        semanticLabel: 'Phần thưởng prediction',
        title: 'Phần thưởng',
        subtitle: 'Quỹ ngày ${_pdmUsd(snapshot.totalDailyPool)}',
        contentKey: PredictionsRewardsTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _pdmSection(
              title: 'Cơ hội kiếm thưởng',
              rows: [
                for (final reward in snapshot.rewards.take(8))
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${reward.category} · chênh lệch tối đa ${_pdmPct(reward.maxSpread)}',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        Text(
                          '${_pdmUsd(reward.dailyReward)}/ngày',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: AppTextStyles.bold,
                            color: AppColors.buy,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
