import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/widgets/wallet_tablet_detail_surface.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Independent Tablet composition for wallet health score SC-151.
class WalletHealthScoreTabletPage extends ConsumerStatefulWidget {
  const WalletHealthScoreTabletPage({super.key});

  static const contentKey = Key('sc151_health_score_tablet_content');
  static const sheetCloseKey = Key('sc151_health_score_sheet_close_tablet');
  static Key tabKey(String label) =>
      Key('sc151_health_score_tab_tablet_$label');
  static Key metricKey(String category) =>
      Key('sc151_health_score_metric_tablet_$category');
  static Key recommendationKey(String id) =>
      Key('sc151_health_score_recommendation_tablet_$id');

  @override
  ConsumerState<WalletHealthScoreTabletPage> createState() =>
      _WalletHealthScoreTabletPageState();
}

class _WalletHealthScoreTabletPageState
    extends ConsumerState<WalletHealthScoreTabletPage> {
  static const _overview = 'overview';
  static const _security = 'security';
  static const _diversification = 'diversification';

  String _tab = _overview;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(walletHealthScoreProvider);
    return snapshotAsync.when(
      loading: () => _frame(
        primary: const VitSkeletonList(),
        secondary: const SizedBox.shrink(),
      ),
      error: (error, stackTrace) => _frame(
        primary: VitErrorState(
          title: 'Không tải được điểm sức khỏe ví',
          message: 'Vui lòng kiểm tra kết nối và thử lại.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(walletHealthScoreProvider),
        ),
        secondary: const SizedBox.shrink(),
      ),
      data: (snapshot) => _frame(
        primary: _buildPrimary(snapshot),
        secondary: _buildSecondary(snapshot),
      ),
    );
  }

  Widget _frame({required Widget primary, required Widget secondary}) {
    return WalletTabletDetailSurface(
      semanticLabel: 'Điểm sức khỏe ví trên tablet',
      semanticIdentifier: 'SC-151-TABLET',
      title: 'Điểm sức khỏe ví',
      subtitle: 'Tổng quan · bảo mật · đa dạng hóa',
      onBack: () => context.go(AppRoutePaths.wallet),
      primary: primary,
      secondary: secondary,
    );
  }

  Widget _buildPrimary(WalletHealthScoreSnapshot snapshot) {
    return Column(
      key: WalletHealthScoreTabletPage.contentKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          variant: VitCardVariant.hero,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Điểm sức khỏe tổng thể'),
                    const SizedBox(height: TabletSpacingTokens.x4),
                    Text(
                      '${snapshot.overallScore}',
                      style: AppTextStyles.heroNumber.copyWith(
                        color: AppColors.primary,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                    const SizedBox(height: TabletSpacingTokens.x4),
                    Text(
                      _statusLabel(snapshot.overallScore),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.buy,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: TabletSpacingTokens.x7 * 2,
                height: TabletSpacingTokens.x7 * 2,
                child: CircularProgressIndicator(
                  value: snapshot.overallScore / 100,
                  strokeWidth: TabletSpacingTokens.x1,
                  color: AppColors.primary,
                  backgroundColor: AppColors.surface3,
                ),
              ),
            ],
          ),
        ),
        VitPageSection(
          innerGap: TabletSpacingTokens.x4,
          label: 'Khu vực đánh giá',
          headerIcon: Icons.fact_check_outlined,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.standard,
          children: [
            VitTabBar(
              tabs: [
                VitTabItem(
                  key: _overview,
                  label: 'Tổng quan',
                  widgetKey: WalletHealthScoreTabletPage.tabKey('overview'),
                ),
                VitTabItem(
                  key: _security,
                  label: 'Bảo mật',
                  widgetKey: WalletHealthScoreTabletPage.tabKey('security'),
                ),
                VitTabItem(
                  key: _diversification,
                  label: 'Đa dạng hóa',
                  widgetKey: WalletHealthScoreTabletPage.tabKey(
                    'diversification',
                  ),
                ),
              ],
              activeKey: _tab,
              onChanged: (tab) => setState(() => _tab = tab),
              variant: VitTabBarVariant.pill,
            ),
          ],
        ),
        switch (_tab) {
          _security => _buildSecurity(snapshot),
          _diversification => _buildDiversification(snapshot),
          _ => _buildOverview(snapshot),
        },
      ],
    );
  }

  Widget _buildOverview(WalletHealthScoreSnapshot snapshot) {
    return VitPageSection(
      innerGap: TabletSpacingTokens.x4,
      label: 'Ưu tiên cải thiện',
      headerIcon: Icons.priority_high_rounded,
      headerIconColor: AppColors.caution,
      headerVariant: VitSectionHeaderVariant.plain,
      accentColor: AppColors.primary,
      rhythm: VitPageRhythm.standard,
      children: [
        for (final recommendation in snapshot.priorityRecommendations)
          VitCard(
            key: WalletHealthScoreTabletPage.recommendationKey(
              recommendation.id,
            ),
            variant: VitCardVariant.inner,
            onTap: () => _showRecommendation(recommendation),
            child: Row(
              children: [
                const Icon(Icons.shield_outlined, color: AppColors.caution),
                const SizedBox(width: TabletSpacingTokens.x4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(recommendation.title),
                      const SizedBox(height: TabletSpacingTokens.x4),
                      Text(
                        recommendation.description,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSecurity(WalletHealthScoreSnapshot snapshot) {
    return VitPageSection(
      innerGap: TabletSpacingTokens.x4,
      label: 'Bảo mật ví',
      headerIcon: Icons.security_outlined,
      headerIconColor: AppColors.primary,
      headerVariant: VitSectionHeaderVariant.plain,
      accentColor: AppColors.primary,
      rhythm: VitPageRhythm.standard,
      children: [
        VitCard(
          variant: VitCardVariant.inner,
          child: Column(
            children: [
              for (var i = 0; i < snapshot.securityChecklist.length; i++)
                VitInfoRow(
                  label: snapshot.securityChecklist[i].item,
                  value: snapshot.securityChecklist[i].enabled
                      ? 'Đã bật'
                      : 'Cần xử lý',
                  leading: Icon(
                    snapshot.securityChecklist[i].enabled
                        ? Icons.check_circle_outline_rounded
                        : Icons.warning_amber_rounded,
                    color: snapshot.securityChecklist[i].enabled
                        ? AppColors.buy
                        : AppColors.caution,
                  ),
                  valueColor: snapshot.securityChecklist[i].enabled
                      ? AppColors.buy
                      : AppColors.caution,
                  density: VitDensity.compact,
                  showDivider: i != snapshot.securityChecklist.length - 1,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDiversification(WalletHealthScoreSnapshot snapshot) {
    return VitPageSection(
      innerGap: TabletSpacingTokens.x4,
      label: 'Phân bổ tài sản',
      headerIcon: Icons.pie_chart_outline_rounded,
      headerIconColor: AppColors.primary,
      headerVariant: VitSectionHeaderVariant.plain,
      accentColor: AppColors.primary,
      rhythm: VitPageRhythm.standard,
      children: [
        VitCard(
          variant: VitCardVariant.inner,
          child: Column(
            children: [
              for (var i = 0; i < snapshot.diversification.length; i++)
                VitInfoRow(
                  label: snapshot.diversification[i].name,
                  value: '${snapshot.diversification[i].value}%',
                  leading: VitAssetAvatar(
                    label: snapshot.diversification[i].name,
                    accentColor: Color(snapshot.diversification[i].colorHex),
                    size: TabletSpacingTokens.iconLg,
                  ),
                  density: VitDensity.compact,
                  showDivider: i != snapshot.diversification.length - 1,
                ),
            ],
          ),
        ),
        const VitCard(
          variant: VitCardVariant.ghost,
          child: Text(
            'Đa dạng hóa giúp giảm rủi ro tập trung, nhưng không loại bỏ rủi ro thị trường.',
          ),
        ),
      ],
    );
  }

  Widget _buildSecondary(WalletHealthScoreSnapshot snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitHighRiskStatePanel(
          state: VitHighRiskUiState.riskReview,
          title: 'Đánh giá không phải tư vấn tài chính',
          message:
              'Điểm số chỉ là tín hiệu tham khảo. Kiểm tra dữ liệu và hoàn cảnh riêng trước quyết định.',
          contractId: 'Điểm sức khỏe ví',
          density: VitDensity.compact,
        ),
        VitPageSection(
          innerGap: TabletSpacingTokens.x4,
          label: 'Chi tiết điểm',
          headerIcon: Icons.insights_outlined,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.standard,
          children: [
            VitCard(
              variant: VitCardVariant.inner,
              child: Column(
                children: [
                  for (var i = 0; i < snapshot.metrics.length; i++)
                    VitInfoRow(
                      key: WalletHealthScoreTabletPage.metricKey(
                        snapshot.metrics[i].category,
                      ),
                      label: snapshot.metrics[i].category,
                      value:
                          '${snapshot.metrics[i].score}/${snapshot.metrics[i].maxScore}',
                      leading: const Icon(Icons.circle_outlined),
                      valueColor: _metricColor(snapshot.metrics[i].score),
                      density: VitDensity.compact,
                      showDivider: i != snapshot.metrics.length - 1,
                    ),
                ],
              ),
            ),
          ],
        ),
        if (snapshot.history.isNotEmpty)
          VitCard(
            variant: VitCardVariant.inner,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Xu hướng điểm số'),
                const SizedBox(height: TabletSpacingTokens.x4),
                SizedBox(
                  height: TabletSpacingTokens.x7 * 3,
                  child: VitSparkline(
                    values: [
                      for (final point in snapshot.history)
                        point.score.toDouble(),
                    ],
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _showRecommendation(WalletHealthRecommendation recommendation) {
    return showVitBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(TabletSpacingTokens.x5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(recommendation.title, style: AppTextStyles.sectionTitle),
              const SizedBox(height: TabletSpacingTokens.x4),
              Text(recommendation.description),
              const SizedBox(height: TabletSpacingTokens.x4),
              VitStatusPill(
                label: 'Khuyến nghị ưu tiên · ${recommendation.category}',
                status: VitStatusPillStatus.warning,
                icon: Icons.info_outline_rounded,
                size: VitStatusPillSize.sm,
              ),
              const SizedBox(height: TabletSpacingTokens.x4),
              VitCtaButton(
                key: WalletHealthScoreTabletPage.sheetCloseKey,
                onPressed: () => Navigator.of(context).pop(),
                variant: VitCtaButtonVariant.secondary,
                child: const Text('Đóng'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _statusLabel(int score) {
    if (score >= 80) return 'Rất tốt';
    if (score >= 60) return 'Tốt';
    if (score >= 40) return 'Cần cải thiện';
    return 'Cần ưu tiên xử lý';
  }

  Color _metricColor(int score) {
    if (score >= 80) return AppColors.buy;
    if (score >= 60) return AppColors.caution;
    return AppColors.sell;
  }
}
