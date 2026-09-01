import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_page_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_formatters.dart';

part '../../../widgets/assets/asset_detail_page_sections.dart';
part '../../../widgets/assets/asset_detail_page_common.dart';

const _assetBackground = AppColors.bg;
const _assetGreen = AppColors.buy;
const _assetRed = AppColors.sell;
const _assetPrimary = AppColors.primary;

/// Same clearance as DeviceMetrics shell chrome without density-audit markers.
double _assetScrollEndPad(BuildContext context, ShellRenderMode mode) {
  return (mode.usesVisualQaFrame
          ? 90.0 + AppSpacing.x6
          : 72.0 + AppSpacing.x6) +
      MediaQuery.paddingOf(context).bottom;
}

class AssetDetailPage extends ConsumerStatefulWidget {
  const AssetDetailPage({
    super.key,
    required this.assetId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc147_asset_detail_content');
  static Key actionKey(String id) => Key('sc147_asset_action_$id');
  static Key periodKey(String id) => Key('sc147_asset_period_$id');
  static Key transactionKey(String id) => Key('sc147_asset_tx_$id');

  final String assetId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AssetDetailPage> createState() => _AssetDetailPageState();
}

class _AssetDetailPageState extends ConsumerState<AssetDetailPage> {
  String _period = '1M';

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(walletAssetDetailProvider(widget.assetId));
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPad = _assetScrollEndPad(context, mode);

    // GD4-F2: title phụ thuộc snapshot.symbol nên bọc CẢ scaffold (không chỉ
    // children) — khác khuôn mặc định "header tĩnh ở ngoài .when()" (xem
    // GD4-Async-Playbook.md, mục "header phụ thuộc dữ liệu").
    return snapshotAsync.when(
      loading: () => VitAutoHidePageScaffold(
        semanticLabel: 'Chi tiết tài sản - số dư minh bạch',
        semanticIdentifier: 'SC-147',
        background: _assetBackground,
        header: VitTopChrome(
          type: VitTopChromeType.detail,
          title: widget.assetId.toUpperCase(),
          subtitle: 'Chi tiết tài sản · số dư minh bạch',
          showBack: true,
          onBack: () => context.go(AppRoutePaths.wallet),
        ),
        body: const VitInsetScrollView(child: VitSkeletonList()),
      ),
      error: (error, stackTrace) => VitAutoHidePageScaffold(
        semanticLabel: 'Chi tiết tài sản - số dư minh bạch',
        semanticIdentifier: 'SC-147',
        background: _assetBackground,
        header: VitTopChrome(
          type: VitTopChromeType.detail,
          title: widget.assetId.toUpperCase(),
          subtitle: 'Chi tiết tài sản · số dư minh bạch',
          showBack: true,
          onBack: () => context.go(AppRoutePaths.wallet),
        ),
        body: VitInsetScrollView(
          child: VitErrorState(
            title: 'Không tải được chi tiết tài sản',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () =>
                ref.invalidate(walletAssetDetailProvider(widget.assetId)),
          ),
        ),
      ),
      data: (snapshot) => VitAutoHidePageScaffold(
        semanticLabel: 'Chi tiết tài sản - số dư minh bạch',
        semanticIdentifier: 'SC-147',
        background: _assetBackground,
        header: VitTopChrome(
          type: VitTopChromeType.detail,
          title: snapshot.symbol,
          subtitle: 'Chi tiết tài sản · số dư minh bạch',
          showBack: true,
          onBack: () => context.go(AppRoutePaths.wallet),
        ),
        body: VitInsetScrollView(
          key: AssetDetailPage.contentKey,
          bottomInset: scrollEndPad,
          child: VitPageContent(
            rhythm: VitPageRhythm.standard,
            padding: VitContentPadding.compact,
            density: VitDensity.compact,
            gap: VitContentGap.tight,
            children: [
              _AssetHero(snapshot: snapshot),
              _AssetActionGrid(
                actions: snapshot.actions,
                onNavigate: (route) => context.go(route),
              ),
              VitPageSection(
                label: 'Biểu đồ giá',
                headerIcon: Icons.show_chart_rounded,
                headerIconColor: _assetPrimary,
                headerVariant: VitSectionHeaderVariant.plain,
                headerDensity: VitDensity.compact,
                innerGap: AppSpacing.pageRhythmStandardInnerGap,
                children: [
                  _PriceChartCard(
                    snapshot: snapshot,
                    activePeriod: _period,
                    onPeriod: (period) => setState(() => _period = period),
                  ),
                ],
              ),
              VitPageSection(
                label: 'Lịch sử giao dịch',
                headerIcon: Icons.receipt_long_outlined,
                headerIconColor: _assetPrimary,
                headerVariant: VitSectionHeaderVariant.plain,
                headerDensity: VitDensity.compact,
                innerGap: AppSpacing.pageRhythmStandardInnerGap,
                children: [
                  _AssetTransactions(
                    transactions: snapshot.transactions,
                    onNavigate: (route) => context.go(route),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
