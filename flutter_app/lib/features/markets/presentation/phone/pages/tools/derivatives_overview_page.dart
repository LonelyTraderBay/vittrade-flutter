import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tools/market_derivatives_common.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tools/market_derivatives_liquidation.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tools/market_derivatives_overview.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tools/market_derivatives_perpetual.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tools/market_derivatives_tabs.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';

class DerivativesOverviewPage extends ConsumerStatefulWidget {
  const DerivativesOverviewPage({super.key, this.shellRenderMode});

  static const contentKey = MarketDerivativesKeys.content;
  static const overviewTabKey = MarketDerivativesKeys.overviewTab;
  static const perpetualTabKey = MarketDerivativesKeys.perpetualTab;
  static const liquidationTabKey = MarketDerivativesKeys.liquidationTab;

  static Key sortKey(MarketDerivativesSort sort) =>
      MarketDerivativesKeys.sort(sort);

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DerivativesOverviewPage> createState() =>
      _DerivativesOverviewPageState();
}

class _DerivativesOverviewPageState
    extends ConsumerState<DerivativesOverviewPage> {
  String _tab = 'overview';
  MarketDerivativesSort _sortBy = MarketDerivativesSort.openInterest;

  @override
  Widget build(BuildContext context) {
    final derivativesAsync = ref.watch(
      marketDerivativesSnapshotProvider(_sortBy),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? AppSpacing.x7 + AppSpacing.x6
            : AppSpacing.x7) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Phái sinh',
      semanticIdentifier: 'SC-018',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Phái sinh',
            subtitle: 'Dữ liệu phái sinh · Markets',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.markets),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MarketDerivativesTabs(
                activeTab: _tab,
                onChanged: (value) => setState(() => _tab = value),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: DerivativesOverviewPage.contentKey,
                    padding:
                        MarketsSpacingTokens.marketDerivativesScrollPadding(
                          scrollEndClearance,
                        ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.compact,
                      padding: VitContentPadding.compact,
                      gap: VitContentGap.tight,
                      children: derivativesAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được dữ liệu phái sinh',
                            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              marketDerivativesSnapshotProvider(_sortBy),
                            ),
                          ),
                        ],
                        data: (snapshot) => [
                          if (_tab == 'overview') ...[
                            MarketDerivativesOpenInterestHero(
                              stats: snapshot.globalStats,
                            ),
                            MarketDerivativesOverviewStatGrid(
                              stats: snapshot.globalStats,
                            ),
                            const MarketDerivativesSectionHeader(
                              label: 'Thanh lý theo thời gian (24h)',
                              accentColor: AppColors.sell,
                            ),
                            MarketDerivativesLiquidationTimeline(
                              history: snapshot.liquidationHistory,
                              pairs: snapshot.pairs,
                            ),
                            const MarketDerivativesSectionHeader(
                              label: 'Top Open Interest',
                              accentColor: marketDerivativesPrimary,
                            ),
                            MarketDerivativesTopOpenInterestList(
                              pairs: snapshot.pairs.take(5).toList(),
                            ),
                          ] else if (_tab == 'perpetual') ...[
                            MarketDerivativesSortChips(
                              active: _sortBy,
                              onSelected: (value) => setState(() {
                                _sortBy = value;
                              }),
                            ),
                            for (final pair in snapshot.pairs)
                              MarketDerivativesPerpetualPairCard(pair: pair),
                          ] else ...[
                            MarketDerivativesLiquidationSummary(
                              stats: snapshot.globalStats,
                            ),
                            const MarketDerivativesSectionHeader(
                              label: 'Thanh lý theo cặp',
                              accentColor: AppColors.sell,
                            ),
                            for (final pair
                                in [...snapshot.pairs]..sort(
                                  (a, b) => b.totalLiquidations24h.compareTo(
                                    a.totalLiquidations24h,
                                  ),
                                ))
                              MarketDerivativesLiquidationPairCard(pair: pair),
                            const MarketDerivativesRiskWarningCard(),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
