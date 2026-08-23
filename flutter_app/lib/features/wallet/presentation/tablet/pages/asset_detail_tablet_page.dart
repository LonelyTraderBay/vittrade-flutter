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

/// Independent Tablet composition for wallet asset detail SC-147.
class AssetDetailTabletPage extends ConsumerStatefulWidget {
  const AssetDetailTabletPage({super.key, required this.assetId});

  static const contentKey = Key('sc147_asset_detail_tablet_content');
  static Key actionKey(String id) => Key('sc147_asset_action_tablet_$id');
  static Key periodKey(String id) => Key('sc147_asset_period_tablet_$id');
  static Key transactionKey(String id) => Key('sc147_asset_tx_tablet_$id');

  final String assetId;

  @override
  ConsumerState<AssetDetailTabletPage> createState() =>
      _AssetDetailTabletPageState();
}

class _AssetDetailTabletPageState extends ConsumerState<AssetDetailTabletPage> {
  String _period = '1M';

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(walletAssetDetailProvider(widget.assetId));
    return snapshotAsync.when(
      loading: () => _frame(
        title: widget.assetId.toUpperCase(),
        primary: const VitSkeletonList(),
        secondary: const SizedBox.shrink(),
      ),
      error: (error, stackTrace) => _frame(
        title: widget.assetId.toUpperCase(),
        primary: VitErrorState(
          title: 'Không tải được chi tiết tài sản',
          message: 'Vui lòng kiểm tra kết nối và thử lại.',
          actionLabel: 'Thử lại',
          onAction: () =>
              ref.invalidate(walletAssetDetailProvider(widget.assetId)),
        ),
        secondary: const SizedBox.shrink(),
      ),
      data: (snapshot) => _frame(
        title: snapshot.symbol,
        primary: _buildPrimary(snapshot),
        secondary: _buildSecondary(snapshot),
      ),
    );
  }

  Widget _frame({
    required String title,
    required Widget primary,
    required Widget secondary,
  }) {
    return WalletTabletDetailSurface(
      semanticLabel: 'Chi tiết tài sản trên tablet',
      semanticIdentifier: 'SC-147-TABLET',
      title: title,
      subtitle: 'Chi tiết tài sản · Ví',
      onBack: () => context.go(AppRoutePaths.wallet),
      primary: primary,
      secondary: secondary,
    );
  }

  Widget _buildPrimary(WalletAssetDetailSnapshot snapshot) {
    final accent = Color(snapshot.colorHex);
    return Column(
      key: AssetDetailTabletPage.contentKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          variant: VitCardVariant.hero,
          borderColor: accent.withValues(alpha: .22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  VitAssetAvatar(
                    label: snapshot.symbol,
                    accentColor: accent,
                    size: AppSpacing.buttonCompact,
                    border: true,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.name,
                          style: AppTextStyles.baseMedium.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          snapshot.symbol,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  VitMetricDeltaPill(
                    label: _assetPercent(snapshot.change24h),
                    tone: snapshot.change24h >= 0
                        ? VitMetricDeltaTone.positive
                        : VitMetricDeltaTone.negative,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(
                VitFormat.usd(snapshot.usdValue),
                style: AppTextStyles.heroNumber.copyWith(
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                '${_assetAmount(snapshot.balance)} ${snapshot.symbol}',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ],
          ),
        ),
        VitPageSection(
          label: 'Thao tác nhanh',
          headerIcon: Icons.bolt_outlined,
          headerIconColor: accent,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: accent,
          rhythm: VitPageRhythm.form,
          children: [
            Wrap(
              spacing: AppSpacing.gridGap,
              runSpacing: AppSpacing.gridGap,
              children: [
                for (final action in snapshot.actions)
                  SizedBox(
                    width: AppSpacing.serviceTileMinHeight * 2,
                    child: VitServiceTile(
                      key: AssetDetailTabletPage.actionKey(action.id),
                      density: VitServiceTileDensity.compact,
                      icon: _actionIcon(action.iconKey),
                      label: action.label,
                      accentColor: Color(action.colorHex),
                      onTap: () => context.go(action.route),
                    ),
                  ),
              ],
            ),
          ],
        ),
        VitPageSection(
          label: 'Biểu đồ giá',
          headerIcon: Icons.show_chart_rounded,
          headerIconColor: accent,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: accent,
          rhythm: VitPageRhythm.form,
          children: [
            VitTabBar(
              tabs: [
                for (final period in const ['1W', '1M', '3M'])
                  VitTabItem(
                    key: period,
                    label: period,
                    widgetKey: AssetDetailTabletPage.periodKey(period),
                  ),
              ],
              activeKey: _period,
              onChanged: (period) => setState(() => _period = period),
              variant: VitTabBarVariant.segment,
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            VitCard(
              variant: VitCardVariant.inner,
              child: SizedBox(
                height: AppSpacing.x7 * 3,
                child: VitSparkline(
                  values: [for (final point in snapshot.chart) point.price],
                  color: accent,
                  strokeWidth: AppSpacing.borderWidth,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSecondary(WalletAssetDetailSnapshot snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Phân bổ số dư',
          headerIcon: Icons.account_balance_wallet_outlined,
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
                    label: 'Khả dụng',
                    value:
                        '${_assetAmount(snapshot.available)} ${snapshot.symbol}',
                    leading: const Icon(Icons.check_circle_outline_rounded),
                    valueColor: AppColors.buy,
                    density: VitDensity.compact,
                    showDivider: true,
                  ),
                  VitInfoRow(
                    label: 'Trong lệnh',
                    value:
                        '${_assetAmount(snapshot.inOrder)} ${snapshot.symbol}',
                    leading: const Icon(Icons.swap_horiz_rounded),
                    valueColor: AppColors.primary,
                    density: VitDensity.compact,
                    showDivider: true,
                  ),
                  VitInfoRow(
                    label: 'Đóng băng',
                    value:
                        '${_assetAmount(snapshot.frozen)} ${snapshot.symbol}',
                    leading: const Icon(Icons.lock_outline_rounded),
                    valueColor: AppColors.caution,
                    density: VitDensity.compact,
                    showDivider: false,
                  ),
                ],
              ),
            ),
          ],
        ),
        VitPageSection(
          label: 'Giao dịch gần đây',
          headerIcon: Icons.receipt_long_outlined,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.form,
          children: snapshot.transactions.isEmpty
              ? const [
                  VitEmptyState(
                    title: 'Chưa có giao dịch',
                    message: 'Giao dịch của tài sản sẽ xuất hiện tại đây.',
                    icon: Icons.receipt_long_outlined,
                  ),
                ]
              : [
                  for (final tx in snapshot.transactions)
                    VitCard(
                      key: AssetDetailTabletPage.transactionKey(tx.id),
                      variant: VitCardVariant.ghost,
                      density: VitDensity.compact,
                      onTap: () => context.go(tx.route),
                      child: Row(
                        children: [
                          Icon(
                            tx.isIncoming
                                ? Icons.arrow_downward_rounded
                                : Icons.arrow_upward_rounded,
                            color: tx.isIncoming
                                ? AppColors.buy
                                : AppColors.sell,
                          ),
                          const SizedBox(width: AppSpacing.x2),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(tx.label),
                                const SizedBox(height: AppSpacing.x1),
                                Text(
                                  tx.createdAt,
                                  style: AppTextStyles.micro.copyWith(
                                    color: AppColors.text3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${tx.isIncoming ? '+' : '-'}${_assetAmount(tx.amount)} ${tx.asset}',
                            style: AppTextStyles.caption.copyWith(
                              color: tx.isIncoming
                                  ? AppColors.buy
                                  : AppColors.sell,
                              fontWeight: AppTextStyles.bold,
                              fontFeatures: AppTextStyles.tabularFigures,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
        ),
      ],
    );
  }
}

IconData _actionIcon(String key) => switch (key) {
  'deposit' => Icons.south_west_rounded,
  'withdraw' => Icons.north_east_rounded,
  'transfer' => Icons.swap_vert_rounded,
  _ => Icons.repeat_rounded,
};

String _assetAmount(double value) => value.toStringAsFixed(6);

String _assetPercent(double value) =>
    '${value >= 0 ? '+' : ''}${value.toStringAsFixed(2)}%';
