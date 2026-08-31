import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
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

/// Bố cục tablet của Cài đặt giao dịch (SC-052, 2026-08-31) — cùng
/// [tradeSettingsSnapshotProvider] với trang phone, dashboard 2 cột: cột
/// chính = các nhóm công tắc (Xác nhận · Phản hồi · Hiển thị) mọi công
/// tắc wired state cục bộ + Lưu gọi `patchTradeSettings`; cột phụ = giá
/// trị cấu hình hiện tại.
class TradeSettingsTabletPage extends ConsumerStatefulWidget {
  const TradeSettingsTabletPage({super.key});

  static const saveKey = Key('sc052_tablet_save');

  @override
  ConsumerState<TradeSettingsTabletPage> createState() =>
      _TradeSettingsTabletPageState();
}

class _TradeSettingsTabletPageState
    extends ConsumerState<TradeSettingsTabletPage> {
  TradeSettings? _draft;

  TradeSettings _draftOf(TradeSettings seed) {
    return _draft ??= seed;
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(tradeSettingsSnapshotProvider);
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Cài đặt giao dịch',
      semanticIdentifier: 'SC-052',
      child: Column(
        children: [
          VitHeader(
            title: 'Cài đặt giao dịch',
            subtitle: 'Xác nhận · thông báo · hiển thị',
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
            child: settingsAsync.when(
              loading: () => const Center(child: VitSkeletonList(rows: 6)),
              error: (error, stackTrace) => SingleChildScrollView(
                child: VitErrorState(
                  title: 'Không tải được cài đặt giao dịch',
                  message: 'Vui lòng kiểm tra kết nối và thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () => ref.invalidate(tradeSettingsSnapshotProvider),
                ),
              ),
              data: (snapshot) {
                final draft = _draftOf(snapshot.settings);
                return VitTwoColumnTabletDashboard(
                  primaryChildren: [
                    ...tradeShellWithProductTabs(
                      context: context,
                      showProductTabs: true,
                      activeProductId: 'spot',
                      productPair: snapshot.trade.pair,
                      quickNavKey: TradeTabletKeys.quickNav,
                      navigationBuilder: buildTradeProductNavigation,
                      children: const [SizedBox.shrink()],
                    ),
                    VitTradeSection(
                      title: 'Xác nhận lệnh',
                      child: _SettingsSwitchCard(
                        rows: [
                          _SwitchRowData(
                            key: 'confirm_orders',
                            label: 'Xác nhận trước khi gửi lệnh',
                            value: draft.confirmOrders,
                          ),
                          _SwitchRowData(
                            key: 'skip_small',
                            label: 'Bỏ qua xác nhận lệnh nhỏ',
                            value: draft.skipConfirmSmall,
                          ),
                        ],
                        onChanged: (id, value) => setState(() {
                          _draft = id == 'confirm_orders'
                              ? draft.copyWith(confirmOrders: value)
                              : draft.copyWith(skipConfirmSmall: value);
                        }),
                      ),
                    ),
                    VitTradeSection(
                      title: 'Phản hồi khi khớp lệnh',
                      child: _SettingsSwitchCard(
                        rows: [
                          _SwitchRowData(
                            key: 'sound',
                            label: 'Âm thanh khi khớp lệnh',
                            value: draft.soundOnFill,
                          ),
                          _SwitchRowData(
                            key: 'haptic',
                            label: 'Rung khi khớp lệnh',
                            value: draft.hapticOnFill,
                          ),
                        ],
                        onChanged: (id, value) => setState(() {
                          _draft = id == 'sound'
                              ? draft.copyWith(soundOnFill: value)
                              : draft.copyWith(hapticOnFill: value);
                        }),
                      ),
                    ),
                    VitTradeSection(
                      title: 'Hiển thị terminal',
                      child: _SettingsSwitchCard(
                        rows: [
                          _SwitchRowData(
                            key: 'order_book',
                            label: 'Hiện sổ lệnh trên terminal',
                            value: draft.showOrderBook,
                          ),
                          _SwitchRowData(
                            key: 'recent_trades',
                            label: 'Hiện giao dịch gần đây',
                            value: draft.showRecentTrades,
                          ),
                          _SwitchRowData(
                            key: 'pct_buttons',
                            label: 'Dùng nút phần trăm nhanh',
                            value: draft.defaultPctButtons,
                          ),
                        ],
                        onChanged: (id, value) => setState(() {
                          _draft = switch (id) {
                            'order_book' => draft.copyWith(
                              showOrderBook: value,
                            ),
                            'recent_trades' => draft.copyWith(
                              showRecentTrades: value,
                            ),
                            _ => draft.copyWith(defaultPctButtons: value),
                          };
                        }),
                      ),
                    ),
                  ],
                  secondaryChildren: [
                    VitTradeSection(
                      title: 'Cấu hình hiện tại',
                      // Nút Lưu nằm trong CÙNG section child với card cấu
                      // hình — khoảng thở là inner gap (S7: children của
                      // dashboard không được mang inset dọc).
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _CurrentConfigCard(settings: snapshot.settings),
                          const SizedBox(
                            height: AppSpacing.pageRhythmStandardSectionGap,
                          ),
                          VitCtaButton(
                            key: TradeSettingsTabletPage.saveKey,
                            onPressed: () async {
                              final saved = await ref
                                  .read(tradeReadModelControllerProvider)
                                  .patchTradeSettings(draft);
                              if (!mounted) return;
                              setState(() => _draft = saved);
                              if (!context.mounted) return;
                              await showVitNoticeSheet(
                                context: context,
                                title: 'Đã lưu cài đặt',
                                message: 'Cài đặt giao dịch đã được cập nhật.',
                                variant: VitBannerVariant.success,
                                ctaVariant: VitCtaButtonVariant.success,
                              );
                            },
                            child: const Text('Lưu cài đặt'),
                          ),
                        ],
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

class _SwitchRowData {
  const _SwitchRowData({
    required this.key,
    required this.label,
    required this.value,
  });

  final String key;
  final String label;
  final bool value;
}

class _SettingsSwitchCard extends StatelessWidget {
  const _SettingsSwitchCard({required this.rows, required this.onChanged});

  final List<_SwitchRowData> rows;
  final void Function(String id, bool value) onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final row in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      row.label,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                      ),
                    ),
                  ),
                  VitTogglePill(
                    key: Key('sc052_tablet_toggle_${row.key}'),
                    enabled: row.value,
                    onChanged: (value) => onChanged(row.key, value),
                    semanticLabel: row.label,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CurrentConfigCard extends StatelessWidget {
  const _CurrentConfigCard({required this.settings});

  final TradeSettings settings;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (label, value) in [
            ('Loại lệnh mặc định', settings.defaultOrderType),
            ('Trượt giá cho phép', '${settings.defaultSlippage}%'),
            ('Ngưỡng lệnh nhỏ', '${settings.smallOrderThreshold} USDT'),
            ('Số thập phân giá', settings.priceDecimals),
            ('Khung giờ chart', settings.chartTimeframe),
          ])
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                  Text(
                    value,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
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
