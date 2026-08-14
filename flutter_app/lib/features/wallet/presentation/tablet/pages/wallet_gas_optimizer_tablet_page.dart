import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/widgets/wallet_tablet_detail_surface.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Independent Tablet composition for wallet gas optimizer SC-149.
class WalletGasOptimizerTabletPage extends ConsumerStatefulWidget {
  const WalletGasOptimizerTabletPage({super.key});

  static const contentKey = Key('sc149_gas_optimizer_tablet_content');
  static const refreshKey = Key('sc149_gas_optimizer_refresh_tablet');
  static const feedbackKey = Key('sc149_gas_optimizer_feedback_tablet');
  static Key tabKey(String label) =>
      Key('sc149_gas_optimizer_tab_tablet_$label');
  static Key speedKey(String speed) =>
      Key('sc149_gas_optimizer_speed_tablet_$speed');
  static Key comparisonKey(String type) =>
      Key('sc149_gas_optimizer_comparison_tablet_$type');

  @override
  ConsumerState<WalletGasOptimizerTabletPage> createState() =>
      _WalletGasOptimizerTabletPageState();
}

class _WalletGasOptimizerTabletPageState
    extends ConsumerState<WalletGasOptimizerTabletPage> {
  static const _current = 'current';
  static const _trends = 'trends';
  static const _tips = 'tips';

  String _tab = _current;
  String? _selectedSpeed;
  String? _feedback;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(walletGasOptimizerProvider);
    return snapshotAsync.when(
      loading: () => _frame(
        primary: const VitSkeletonList(),
        secondary: const SizedBox.shrink(),
      ),
      error: (error, stackTrace) => _frame(
        primary: VitErrorState(
          title: 'Không tải được dữ liệu tối ưu gas',
          message: 'Vui lòng kiểm tra kết nối và thử lại.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(walletGasOptimizerProvider),
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
      semanticLabel: 'Tối ưu phí gas trên tablet',
      semanticIdentifier: 'SC-149-TABLET',
      title: 'Tối ưu phí gas',
      subtitle: 'Theo dõi mạng · chọn mức phí có kiểm soát',
      onBack: () => context.go(AppRoutePaths.wallet),
      primary: primary,
      secondary: secondary,
    );
  }

  Widget _buildPrimary(WalletGasOptimizerSnapshot snapshot) {
    return Column(
      key: WalletGasOptimizerTabletPage.contentKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Bảng điều khiển phí',
          headerIcon: Icons.speed_rounded,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.form,
          children: [
            VitTabBar(
              tabs: const [
                VitTabItem(key: _current, label: 'Hiện tại'),
                VitTabItem(key: _trends, label: 'Xu hướng'),
                VitTabItem(key: _tips, label: 'Mẹo tiết kiệm'),
              ],
              activeKey: _tab,
              onChanged: (tab) => setState(() => _tab = tab),
              variant: VitTabBarVariant.pill,
            ),
          ],
        ),
        switch (_tab) {
          _trends => _buildTrends(snapshot),
          _tips => _buildTips(snapshot),
          _ => _buildCurrent(snapshot),
        },
      ],
    );
  }

  Widget _buildCurrent(WalletGasOptimizerSnapshot snapshot) {
    final selected = snapshot.levels.firstWhere(
      (level) => level.speed == _selectedSpeed,
      orElse: () => snapshot.recommendedLevel,
    );
    return Column(
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
                    const Text('Mức phí được đề xuất'),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${snapshot.recommendedLevel.gwei} Gwei',
                      style: AppTextStyles.heroNumber.copyWith(
                        color: Color(snapshot.recommendedLevel.colorHex),
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${snapshot.recommendedLevel.timeEstimate} · ${VitFormat.signedPercent(snapshot.vsAveragePct, fractionDigits: 2)} so với trung bình',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.local_gas_station_rounded),
            ],
          ),
        ),
        VitPageSection(
          label: 'Chọn tốc độ giao dịch',
          headerIcon: Icons.tune_rounded,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.form,
          children: [
            VitTabBar(
              tabs: [
                for (final level in snapshot.levels)
                  VitTabItem(
                    key: level.speed,
                    label: '${level.label} · ${level.gwei} Gwei',
                    widgetKey: WalletGasOptimizerTabletPage.speedKey(
                      level.speed,
                    ),
                  ),
              ],
              activeKey: selected.speed,
              onChanged: (speed) => setState(() => _selectedSpeed = speed),
              variant: VitTabBarVariant.segment,
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            VitCard(
              variant: VitCardVariant.inner,
              child: VitInfoRow(
                label: 'Ước tính phí',
                value: VitFormat.usd(selected.usd),
                leading: const Icon(Icons.receipt_long_outlined),
                density: VitDensity.compact,
                showDivider: false,
              ),
            ),
          ],
        ),
        VitPageSection(
          label: 'So sánh loại giao dịch',
          headerIcon: Icons.compare_arrows_rounded,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.form,
          children: [
            VitCard(
              variant: VitCardVariant.inner,
              child: Column(
                children: [
                  for (var i = 0; i < snapshot.comparisons.length; i++)
                    VitInfoRow(
                      key: WalletGasOptimizerTabletPage.comparisonKey(
                        snapshot.comparisons[i].type,
                      ),
                      label: snapshot.comparisons[i].type,
                      value: VitFormat.usd(snapshot.comparisons[i].usd),
                      leading: Text('${snapshot.comparisons[i].gas} gas'),
                      density: VitDensity.compact,
                      showDivider: i != snapshot.comparisons.length - 1,
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTrends(WalletGasOptimizerSnapshot snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Xu hướng phí 24 giờ',
          headerIcon: Icons.show_chart_rounded,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.form,
          children: [
            VitCard(
              variant: VitCardVariant.inner,
              child: SizedBox(
                height: AppSpacing.x7 * 3,
                child: VitSparkline(
                  values: [
                    for (final point in snapshot.history)
                      point.standard.toDouble(),
                  ],
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        VitPageSection(
          label: 'Hoạt động mạng',
          headerIcon: Icons.bar_chart_rounded,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.form,
          children: [
            VitCard(
              variant: VitCardVariant.inner,
              child: Column(
                children: [
                  for (var i = 0; i < snapshot.networkActivity.length; i++)
                    VitInfoRow(
                      label: snapshot.networkActivity[i].hour,
                      value: VitFormat.count(
                        snapshot.networkActivity[i].txCount,
                      ),
                      leading: const Icon(Icons.swap_horiz_rounded),
                      density: VitDensity.compact,
                      showDivider: i != snapshot.networkActivity.length - 1,
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTips(WalletGasOptimizerSnapshot snapshot) {
    return VitPageSection(
      label: 'Mẹo tiết kiệm phí',
      headerIcon: Icons.lightbulb_outline_rounded,
      headerIconColor: AppColors.primary,
      headerVariant: VitSectionHeaderVariant.plain,
      accentColor: AppColors.primary,
      rhythm: VitPageRhythm.form,
      children: [
        for (final tip in snapshot.tips)
          VitCard(
            variant: VitCardVariant.inner,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tip.title, style: AppTextStyles.sectionTitle),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  tip.description,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${tip.potentialSaving} · ${tip.difficulty}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.buy),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSecondary(WalletGasOptimizerSnapshot snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitHighRiskStatePanel(
          state: VitHighRiskUiState.riskReview,
          title: 'Kiểm tra phí trước khi ký',
          message:
              'Ước tính có thể thay đổi theo mạng. Xác nhận phí, tốc độ và hạn mức trước giao dịch.',
          contractId: 'Tối ưu phí gas',
          density: VitDensity.compact,
        ),
        VitPageSection(
          label: 'Tóm tắt vận hành',
          headerIcon: Icons.monitor_heart_outlined,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.form,
          children: [
            VitCard(
              variant: VitCardVariant.inner,
              child: Column(
                children: [
                  VitInfoRow(
                    label: 'Trung bình lịch sử',
                    value: '${snapshot.historicalAverageGwei} Gwei',
                    density: VitDensity.compact,
                    showDivider: true,
                  ),
                  VitInfoRow(
                    label: 'Mạng đề xuất',
                    value: snapshot.recommendedLevel.timeEstimate,
                    density: VitDensity.compact,
                    showDivider: false,
                  ),
                ],
              ),
            ),
          ],
        ),
        VitCtaButton(
          key: WalletGasOptimizerTabletPage.refreshKey,
          onPressed: () {
            ref.invalidate(walletGasOptimizerProvider);
            setState(
              () => _feedback =
                  'Đã làm mới ước tính gas. Xác nhận phí trước khi ký.',
            );
          },
          variant: VitCtaButtonVariant.secondary,
          leading: const Icon(Icons.refresh_rounded),
          child: const Text('Làm mới ước tính'),
        ),
        if (_feedback != null)
          VitStatusPill(
            key: WalletGasOptimizerTabletPage.feedbackKey,
            label: _feedback!,
            status: VitStatusPillStatus.info,
            icon: Icons.info_outline_rounded,
            size: VitStatusPillSize.sm,
          ),
      ],
    );
  }
}
