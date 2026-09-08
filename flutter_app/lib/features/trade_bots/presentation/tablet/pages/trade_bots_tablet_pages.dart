import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/trade_bots_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part 'trade_bots_tablet_pages_risk.dart';
part 'trade_bots_tablet_pages_docs.dart';

part 'trade_bots_tablet_pages_analytics.dart';

String _tbpDec(num value, [int digits = 2]) => value.toStringAsFixed(digits);

String _tbpPct(num value, [int digits = 1]) =>
    VitFormat.percent(value, fractionDigits: digits);

Widget _tbpFrame({
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
                  fallbackPath: AppRoutePaths.tradeBots,
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

Widget _tbpError(String title, VoidCallback onRetry) {
  return VitErrorState(
    title: title,
    message: 'Vui lòng kiểm tra kết nối và thử lại.',
    actionLabel: 'Thử lại',
    onAction: onRetry,
  );
}

Widget _tbpSection({required String title, required List<Widget> rows}) {
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

List<Widget> _tbpRows(List<(String, String)> pairs) {
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

List<Widget> _tbpBullets(List<String> notes) {
  return [
    for (final note in notes)
      Padding(
        padding: TabletSpacingTokens.tableCellPaddingV,
        child: VitBulletRow(text: note),
      ),
  ];
}

Widget _tbpQuickLinks(BuildContext context, List<(String, String)> links) {
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

Widget _tbpBody(String text) {
  return Text(
    text,
    style: AppTextStyles.caption.copyWith(color: AppColors.text2, height: 1.3),
  );
}

/// SC-124: Hub Trading Bots — danh sách bot đang chạy + chiến lược.
class TradingBotsTabletPage extends ConsumerWidget {
  const TradingBotsTabletPage({super.key});

  static const contentKey = Key('sc124_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradingBotsSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _tbpFrame(
        context: context,
        semanticIdentifier: 'SC-124',
        semanticLabel: 'Bảng điều khiển bots',
        title: 'Trading Bots',
        subtitle: 'Tự động hóa giao dịch',
        contentKey: TradingBotsTabletPage.contentKey,
        child: _tbpError(
          'Không tải được trading bots',
          () => ref.invalidate(tradingBotsSnapshotProvider),
        ),
      ),
      data: (snapshot) => _tbpFrame(
        context: context,
        semanticIdentifier: 'SC-124',
        semanticLabel: 'Bảng điều khiển bots',
        title: 'Trading Bots',
        subtitle: 'Cập nhật ${snapshot.lastUpdatedLabel}',
        contentKey: TradingBotsTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _tbpSection(
              title: 'Bot đang chạy',
              rows: [
                for (final bot in snapshot.activeBots)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${bot.strategyName} · ${bot.pair}',
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                  color: AppColors.text1,
                                ),
                              ),
                              Text(
                                '${bot.status.name} · ${bot.trades} lệnh',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text2,
                                  fontFeatures: AppTextStyles.tabularFigures,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${VitFormat.usdSigned(bot.profit)} (${_tbpPct(bot.profitPct, 2)})',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: AppTextStyles.bold,
                            color: bot.profit >= 0
                                ? AppColors.buy
                                : AppColors.sell,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _tbpSection(
              title: 'Chiến lược khả dụng',
              rows: [
                for (final strategy in snapshot.strategies)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                strategy.name,
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                  color: AppColors.text1,
                                ),
                              ),
                              Text(
                                strategy.description,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text2,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${strategy.risk.name} · ${strategy.avgReturn}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _tbpSection(
              title: 'Khám phá',
              rows: [
                _tbpQuickLinks(context, [
                  ('Lịch sử', AppRoutePaths.tradeBotHistory),
                  (
                    'Phân tích hiệu suất',
                    AppRoutePaths.tradeBotPerformanceAnalytics,
                  ),
                  ('Kiểm thử lại', AppRoutePaths.tradeBotBacktesting),
                  ('So sánh chiến lược', AppRoutePaths.tradeBotStrategyCompare),
                  ('Tối ưu hoá', AppRoutePaths.tradeBotOptimization),
                  (
                    'Bảng điều khiển danh mục',
                    AppRoutePaths.tradeBotPortfolioDashboard,
                  ),
                  (
                    'Phân tích sụt giảm',
                    AppRoutePaths.tradeBotDrawdownAnalyzer,
                  ),
                  ('Đường cong vốn', AppRoutePaths.tradeBotEquityCurve),
                  ('Bảng rủi ro', AppRoutePaths.tradeBotRiskDashboard),
                  ('Dừng khẩn cấp', AppRoutePaths.tradeBotEmergencyStop),
                  ('Cài đặt bảo mật', AppRoutePaths.tradeBotSecuritySettings),
                  (
                    'Đánh giá phù hợp',
                    AppRoutePaths.tradeBotSuitabilityAssessment,
                  ),
                  ('Hướng dẫn', AppRoutePaths.tradeBotGuide),
                  ('Câu hỏi thường gặp', AppRoutePaths.tradeBotFaq),
                  ('Báo cáo thuế', AppRoutePaths.tradeBotTaxReporting),
                  ('Tài liệu API', AppRoutePaths.tradeBotApiDocumentation),
                  ('Điều khoản dịch vụ', AppRoutePaths.tradeBotTermsOfService),
                  ('Tiết lộ rủi ro', AppRoutePaths.tradeBotRiskDisclosure),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-125: Điều khoản dịch vụ bot.
class BotTermsOfServiceTabletPage extends ConsumerWidget {
  const BotTermsOfServiceTabletPage({super.key});

  static const contentKey = Key('sc125_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeBotTermsOfServiceProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _tbpFrame(
        context: context,
        semanticIdentifier: 'SC-125',
        semanticLabel: 'Điều khoản bot',
        title: snapshotAsync.value?.infoTitle ?? 'Điều khoản bot',
        subtitle: 'Điều khoản · Cam kết',
        contentKey: BotTermsOfServiceTabletPage.contentKey,
        child: _tbpError(
          'Không tải được điều khoản',
          () => ref.invalidate(tradeBotTermsOfServiceProvider),
        ),
      ),
      data: (snapshot) => _tbpFrame(
        context: context,
        semanticIdentifier: 'SC-125',
        semanticLabel: 'Điều khoản bot',
        title: snapshot.infoTitle,
        subtitle: snapshot.infoDescription,
        contentKey: BotTermsOfServiceTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final section in snapshot.sections) ...[
              _tbpSection(
                title: section.title,
                rows: [
                  ..._tbpBullets(section.paragraphs),
                  if (section.warningTitle != null)
                    Padding(
                      padding: TabletSpacingTokens.tableCellPaddingV,
                      child: Text(
                        '${section.warningTitle} — ${section.warningBody}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.caution,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ..._tbpBullets(section.bullets),
                ],
              ),
              const SizedBox(height: TabletSpacingTokens.x3),
            ],
            _tbpSection(
              title: snapshot.complianceTitle,
              rows: [_tbpBody(snapshot.complianceDescription)],
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-126: Công bố rủi ro bot.
class BotRiskDisclosureTabletPage extends ConsumerWidget {
  const BotRiskDisclosureTabletPage({super.key});

  static const contentKey = Key('sc126_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeBotRiskDisclosureProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _tbpFrame(
        context: context,
        semanticIdentifier: 'SC-126',
        semanticLabel: 'Công bố rủi ro bot',
        title: snapshotAsync.value?.highRiskTitle ?? 'Công bố rủi ro',
        subtitle: 'Rủi ro · Cảnh báo',
        contentKey: BotRiskDisclosureTabletPage.contentKey,
        child: _tbpError(
          'Không tải được công bố rủi ro',
          () => ref.invalidate(tradeBotRiskDisclosureProvider),
        ),
      ),
      data: (snapshot) => _tbpFrame(
        context: context,
        semanticIdentifier: 'SC-126',
        semanticLabel: 'Công bố rủi ro bot',
        title: snapshot.highRiskTitle,
        subtitle: snapshot.highRiskBody,
        contentKey: BotRiskDisclosureTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _tbpSection(
              title: snapshot.pastPerformanceTitle,
              rows: [_tbpBody(snapshot.pastPerformanceBody)],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            for (final category in snapshot.categories) ...[
              _tbpSection(
                title: category.title,
                rows: [
                  _tbpBody(category.description),
                  ..._tbpBullets(category.examples),
                  if (category.mitigation.isNotEmpty)
                    _tbpBody('Giảm thiểu: ${category.mitigation}'),
                ],
              ),
              const SizedBox(height: TabletSpacingTokens.x3),
            ],
            _tbpSection(
              title: snapshot.additionalWarningsLabel,
              rows: [
                for (final warning in snapshot.additionalWarnings)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          warning.title,
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: AppTextStyles.bold,
                            color: AppColors.text1,
                          ),
                        ),
                        Text(
                          warning.text,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _tbpSection(
              title: snapshot.regulatoryTitle,
              rows: [
                _tbpBody(snapshot.regulatoryBody),
                ..._tbpBullets(snapshot.regulatoryNotes),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
