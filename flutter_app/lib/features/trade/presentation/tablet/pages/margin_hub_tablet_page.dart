import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_tablet_keys.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_product_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_two_column_tablet_dashboard.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Bố cục tablet của Trung tâm Margin (SC-090, 2026-08-31) — cùng
/// [tradeMarginTradingHubProvider] với trang phone, dashboard 2 cột: cột
/// chính = chỉ số + nhóm tính năng margin, cột phụ = menu điều hướng nhanh
/// (wired push route thật) + khối tuân thủ.
class MarginHubTabletPage extends ConsumerWidget {
  const MarginHubTabletPage({super.key});

  static const statsKey = Key('sc090_tablet_stats');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hubAsync = ref.watch(tradeMarginTradingHubProvider);
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Trung tâm Margin',
      semanticIdentifier: 'SC-090',
      child: Column(
        children: [
          VitHeader(
            title: 'Trung tâm Margin',
            subtitle: 'Tổng quan vị thế · vay · rủi ro',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.trade,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
            backKey: TradeTabletKeys.back,
          ),
          Expanded(
            child: hubAsync.when(
              loading: () => const Center(child: VitSkeletonList(rows: 6)),
              error: (error, stackTrace) => SingleChildScrollView(
                child: VitErrorState(
                  title: 'Không tải được trung tâm Margin',
                  message: 'Vui lòng kiểm tra kết nối và thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () => ref.invalidate(tradeMarginTradingHubProvider),
                ),
              ),
              data: (snapshot) {
                return VitTwoColumnTabletDashboard(
                  onRefresh: () async {
                    ref.invalidate(tradeMarginTradingHubProvider);
                    await ref.read(tradeMarginTradingHubProvider.future);
                  },
                  primaryChildren: [
                    ...tradeShellWithProductTabs(
                      context: context,
                      showProductTabs: true,
                      activeProductId: 'margin',
                      quickNavKey: TradeTabletKeys.quickNav,
                      navigationBuilder: buildTradeProductNavigation,
                      children: const [SizedBox.shrink()],
                    ),
                    VitTradeSection(
                      innerGap: TabletSpacingTokens.x4,
                      title: 'Chỉ số tổng quan',
                      child: _HubStatsCard(stats: snapshot.stats),
                    ),
                    const VitHighRiskStatePanel(
                      state: VitHighRiskUiState.riskReview,
                      title: 'Xem lại rủi ro ký quỹ',
                      message:
                          'Kiểm tra hạn đòn bẩy, rủi ro thanh lý, phí và ký quỹ khả dụng trước khi mở bất kỳ luồng margin nào.',
                      contractId: 'SC-090 margin hub review',
                      density: VitDensity.tool,
                    ),
                    for (final feature in snapshot.features)
                      VitTradeSection(
                        innerGap: TabletSpacingTokens.x4,
                        title: feature.title,
                        child: VitCard(
                          radius: VitCardRadius.tight,
                          padding: TabletSpacingTokens.cardPaddingCompact,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (final item in feature.items)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: TabletSpacingTokens.x1,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item,
                                          style: AppTextStyles.caption.copyWith(
                                            color: AppColors.text2,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                  ],
                  secondaryChildren: [
                    VitTradeSection(
                      innerGap: TabletSpacingTokens.x4,
                      title: 'Điều hướng nhanh',
                      child: VitCard(
                        radius: VitCardRadius.tight,
                        padding: TabletSpacingTokens.cardPaddingCompact,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (final item in snapshot.menuItems)
                              ListTile(
                                key: Key('sc090_tablet_menu_${item.id}'),
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                title: Text(
                                  item.title,
                                  style: AppTextStyles.control.copyWith(
                                    color: AppColors.text1,
                                  ),
                                ),
                                subtitle: Text(
                                  item.subtitle,
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.text3,
                                  ),
                                ),
                                trailing: const Icon(
                                  Icons.chevron_right_rounded,
                                  color: AppColors.text3,
                                ),
                                onTap: () => context.push(item.targetPath),
                              ),
                          ],
                        ),
                      ),
                    ),
                    VitTradeSection(
                      innerGap: TabletSpacingTokens.x4,
                      title: 'Tuân thủ',
                      child: VitCard(
                        radius: VitCardRadius.tight,
                        padding: TabletSpacingTokens.cardPaddingCompact,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              snapshot.compliance.title,
                              style: AppTextStyles.control.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            const SizedBox(height: TabletSpacingTokens.x4),
                            Text(
                              snapshot.compliance.description,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HubStatsCard extends StatelessWidget {
  const _HubStatsCard({required this.stats});

  final List<TradeMarginHubStat> stats;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: MarginHubTabletPage.statsKey,
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final stat in stats)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: TabletSpacingTokens.x1,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      stat.label,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                  Text(
                    stat.value,
                    style: AppTextStyles.control.copyWith(
                      color: Color(stat.colorHex),
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
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
