import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_product_navigation.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';

import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_body_review_widgets.dart';

part '../../../widgets/phone/trade_history_export_summary_sections.dart';
part '../../../widgets/phone/trade_history_export_selectors_includes.dart';
part '../../../widgets/phone/trade_history_export_footer.dart';

const _tradePrimary = AppColors.primary;
const double _exportFramedFooterClearance =
    AppSpacing.buttonStandard + AppSpacing.x5;
const double _exportNativeFooterClearance =
    AppSpacing.buttonStandard + AppSpacing.x3;
const double _exportFooterHeight = AppSpacing.buttonStandard + AppSpacing.x4;
const double _exportFormatExtent = AppSpacing.buttonStandard + AppSpacing.x7;

class TradeHistoryExportPage extends ConsumerStatefulWidget {
  const TradeHistoryExportPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc054_export_content');
  static const exportKey = Key('sc054_export');
  static const newExportKey = Key('sc054_new_export');
  static const downloadKey = Key('sc054_download');

  static Key formatKey(String id) => Key('sc054_format_$id');
  static Key periodKey(String id) => Key('sc054_period_$id');
  static Key includeKey(String id) => Key('sc054_include_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<TradeHistoryExportPage> createState() =>
      _TradeHistoryExportPageState();
}

class _TradeHistoryExportPageState
    extends ConsumerState<TradeHistoryExportPage> {
  // STATE-S23: format/period/includes/isExporting/result sống ở
  // TradeHistoryExportStateController (một nguồn sự thật) — hết `late
  // String`/`late List` seed từ ref.read + setState.

  @override
  Widget build(BuildContext context) {
    // GD4 Cụm F3: `getTradeExport` giờ Future<T> — gate qua `.when()` trước
    // khi đọc Notifier (mục 6), đảm bảo `.value` bên trong không bao giờ
    // null trong luồng UI thật.
    final exportSnapshotAsync = ref.watch(tradeExportSnapshotProvider);
    return exportSnapshotAsync.when(
      loading: () => const VitSkeletonList(),
      error: (error, stackTrace) => VitErrorState(
        title: 'Không tải được lịch sử xuất giao dịch',
        message: 'Vui lòng kiểm tra kết nối và thử lại.',
        actionLabel: 'Thử lại',
        onAction: () => ref.invalidate(tradeExportSnapshotProvider),
      ),
      data: (_) => _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final viewState = ref.watch(tradeHistoryExportStateControllerProvider);
    final snapshot = viewState.snapshot;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final footerSafePadding =
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame
            ? _exportFramedFooterClearance
            : _exportNativeFooterClearance);
    final scrollEndClearance =
        tradeScrollBottomInset(context, shellRenderMode: mode) +
        _exportFooterHeight +
        footerSafePadding;

    return Stack(
      children: [
        VitTradeDetailScaffold(
          title: 'Xuất lịch sử giao dịch',
          semanticLabel: 'Xuất lịch sử giao dịch',
          semanticIdentifier: 'SC-054',
          contentKey: TradeHistoryExportPage.contentKey,
          shellRenderMode: widget.shellRenderMode,
          bottomInset: scrollEndClearance,
          onBack: () => goBackOrFallback(
            context,
            fallbackPath: AppRoutePaths.trade,
            mode: BackNavigationMode.historyThenFallback,
          ),
          showProductTabs: true,
          navigationBuilder: buildTradeProductNavigation,
          children: [
            VitTradeSection(
              title: 'Tổng quan',
              child: _SummaryCard(stats: snapshot.stats),
            ),
            VitTradeSection(
              title: 'Định dạng file',
              child: _FormatSelector(
                formats: snapshot.formats,
                activeFormat: viewState.format,
                onChanged: (format) => ref
                    .read(tradeHistoryExportStateControllerProvider.notifier)
                    .setFormat(format),
              ),
            ),
            VitTradeSection(
              title: 'Khoảng thời gian',
              child: _PeriodSelector(
                periods: snapshot.periods,
                activePeriod: viewState.period,
                onChanged: (period) => ref
                    .read(tradeHistoryExportStateControllerProvider.notifier)
                    .setPeriod(period),
              ),
            ),
            VitTradeSection(
              title: 'Bao gồm dữ liệu',
              child: _IncludeList(
                includes: viewState.includes,
                onToggle: _toggleInclude,
              ),
            ),
            const VitTradeSection(title: 'Thuế', child: _TaxNote()),
            const VitTradeSection(
              title: 'Đánh giá xuất',
              child: VitCard(
                variant: VitCardVariant.inner,
                radius: VitCardRadius.tight,
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: AppSpacing.x3,
                  vertical: AppSpacing.x2,
                ),
                child: VitHighRiskStatePanel(
                  state: VitHighRiskUiState.riskReview,
                  title: 'Export review state',
                  message:
                      'Format, period, included records, tax note, generated result and download next step are reviewed before export.',
                  contractId: 'trade-history-export-review',
                  density: VitDensity.tool,
                ),
              ),
            ),
            const TradeBodyReviewSection(
              title: 'Export body review',
              message: 'Trade export body reviewed',
              detail:
                  'Format, period, includes, tax note, export, download, and result states stay visible.',
              primary: 'Export selectors remain above generated result state.',
              secondary: 'Tax note stays visible before export confirmation.',
              tertiary:
                  'Download/new-export actions remain in the sticky footer.',
            ),
          ],
        ),
        Positioned(
          // notice-ack: allow-sticky-footer
          left: 0,
          right: 0,
          bottom: footerSafePadding,
          child: _ExportFooter(
            format: viewState.format,
            period: viewState.period,
            isExporting: viewState.isExporting,
            result: viewState.result,
            onExport: _handleExport,
            onNewExport: () => ref
                .read(tradeHistoryExportStateControllerProvider.notifier)
                .resetResult(),
          ),
        ),
      ],
    );
  }

  void _toggleInclude(String id) {
    ref
        .read(tradeHistoryExportStateControllerProvider.notifier)
        .toggleInclude(id);
  }

  Future<void> _handleExport() async {
    await ref
        .read(tradeHistoryExportStateControllerProvider.notifier)
        .submitExport();
    if (!mounted) return;
    final viewState = ref.read(tradeHistoryExportStateControllerProvider);
    if (viewState.result != null) {
      await showVitNoticeSheet(
        context: context,
        title: 'File đã sẵn sàng tải xuống',
        message:
            'File ${viewState.format.toUpperCase()} của bạn đã được tạo thành công.',
        variant: VitBannerVariant.success,
        ctaVariant: VitCtaButtonVariant.success,
        ctaLabel: 'Tiếp tục',
      );
    }
  }
}
