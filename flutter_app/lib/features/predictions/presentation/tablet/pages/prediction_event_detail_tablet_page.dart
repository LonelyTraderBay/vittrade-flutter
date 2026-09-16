import 'dart:async';

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/predictions_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/controllers/predictions_controller.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/event/prediction_order_preview_card.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/predictions_time_remaining.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_section_frame.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part 'prediction_event_detail_tablet_sections.dart';
part 'prediction_event_detail_tablet_tabs.dart';
part 'prediction_event_detail_tablet_trade.dart';
part 'prediction_event_detail_tablet_links.dart';

/// SC-211: Chi tiết sự kiện dự đoán trên tablet — tái composition đầy đủ
/// theo trang phone SC-030 (cùng section, cùng luồng đặt lệnh qua máy trạng
/// thái ADR-001), khác phone ở hai điểm theo chuẩn surface: khoảng cách đọc
/// token tablet, và bước xác nhận đặt lệnh là bottom sheet thay vì submit
/// thẳng (Bottom-Sheet-Standard + Financial Safety).
class PredictionEventDetailTabletPage extends ConsumerStatefulWidget {
  const PredictionEventDetailTabletPage({super.key, required this.eventId});

  static const contentKey = Key('sc211_tablet_content');
  static const favoriteKey = Key('sc211_favorite_action');
  static const shareKey = Key('sc211_share_action');
  static const orderBookToggleKey = Key('sc211_order_book_toggle');
  static const rulesTabKey = Key('sc211_tab_rules');
  static const commentsTabKey = Key('sc211_tab_comments');
  static const holdersTabKey = Key('sc211_tab_holders');
  static const activityTabKey = Key('sc211_tab_activity');
  static const riskLinkKey = Key('sc211_risk_link');
  static const arenaCreateKey = Key('sc211_arena_create');
  static const dailyRewardsKey = Key('sc211_daily_rewards');
  static const globalActivityKey = Key('sc211_global_activity');
  static const submitKey = Key('sc211_submit_order');

  static Key relatedKey(String id) => Key('sc211_related_$id');

  final String eventId;

  @override
  ConsumerState<PredictionEventDetailTabletPage> createState() =>
      _PredictionEventDetailTabletPageState();
}

enum _Sc211DetailTab { rules, comments, holders, activity }

class _PredictionEventDetailTabletPageState
    extends ConsumerState<PredictionEventDetailTabletPage> {
  _Sc211DetailTab _activeTab = _Sc211DetailTab.rules;
  bool _isFavorite = false;
  bool _showOrderBook = false;
  bool _isBuy = true;
  bool _isMarket = true;
  String _selectedOutcome = 'Yes';
  String _amount = '';

  @override
  void didUpdateWidget(covariant PredictionEventDetailTabletPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.eventId != widget.eventId) {
      _activeTab = _Sc211DetailTab.rules;
      _showOrderBook = false;
      _selectedOutcome = 'Yes';
      _amount = '';
    }
  }

  void _showShareComingSoon() {
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Sắp ra mắt',
        message: 'Chia sẻ sự kiện dự đoán sẽ sớm ra mắt.',
      ),
    );
  }

  void _showRiskComingSoon() {
    unawaited(HapticFeedback.selectionClick());
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Sắp ra mắt',
        message: 'Tìm hiểu rủi ro sẽ sớm ra mắt.',
      ),
    );
  }

  /// Bước xác nhận high-risk (Financial Safety): sheet tổng hợp phí/rủi ro/
  /// bước tiếp theo trước khi gọi máy trạng thái ERR-36.
  Future<void> _confirmAndSubmit(PredictionOrderPreview preview) async {
    final confirmed = await showVitConfirmSheet(
      context: context,
      title: 'Xác nhận lệnh dự đoán',
      rows: [
        VitConfirmDialogRow(label: 'Kết quả', value: preview.outcome),
        VitConfirmDialogRow(label: 'Bên lệnh', value: _isBuy ? 'Mua' : 'Bán'),
        VitConfirmDialogRow(
          label: 'Loại lệnh',
          value: _isMarket ? 'Thị trường' : 'Giới hạn',
        ),
        VitConfirmDialogRow(
          label: 'Xác suất',
          value: VitFormat.percent(preview.probabilityPct, fractionDigits: 0),
        ),
        VitConfirmDialogRow(label: 'Giá', value: VitFormat.usd(preview.price)),
        VitConfirmDialogRow(
          label: 'Số tiền',
          value: VitFormat.usd(preview.amount),
        ),
        VitConfirmDialogRow(
          label: 'Phí ước tính',
          value: VitFormat.usd(preview.fee),
        ),
        VitConfirmDialogRow(
          label: 'Tối đa mất',
          value: VitFormat.usd(preview.maxLoss),
          valueColor: AppColors.sell,
        ),
      ],
      message:
          'Sau khi xác nhận, lệnh gửi thẳng tới thị trường và chuyển sang trang '
          'biên lai. Xác suất không phải sự chắc chắn — đây không phải lời '
          'khuyên đầu tư.',
      confirmLabel: _isBuy ? 'Xác nhận mua' : 'Xác nhận bán',
      confirmVariant: _isBuy
          ? VitCtaButtonVariant.success
          : VitCtaButtonVariant.danger,
      confirmKey: PredictionEventDetailTabletPage.submitKey,
    );
    if (!confirmed || !mounted) return;
    await _submitOrder();
  }

  /// ERR-36: submit thật qua máy trạng thái ADR-001 — thành công điều hướng
  /// trang biên lai, thất bại ở lại trang với banner lỗi từ state.
  Future<void> _submitOrder() async {
    final provider = predictionEventDetailControllerProvider(widget.eventId);
    final receiptId = await ref
        .read(provider.notifier)
        .submitOrder(
          outcome: _selectedOutcome,
          isBuy: _isBuy,
          isMarket: _isMarket,
          amountText: _amount,
        );
    if (!mounted || receiptId == null) return;
    unawaited(HapticFeedback.selectionClick());
    unawaited(context.push(AppRoutePaths.marketsPredictionReceipt(receiptId)));
  }

  Widget _scaffold({
    required List<VitHeaderActionItem> actions,
    required List<Widget> children,
    String? subtitle,
  }) {
    final showBack = context.canPop();
    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Chi tiết sự kiện dự đoán: xác suất, vị thế và quy tắc',
      semanticIdentifier: 'SC-211',
      child: Column(
        children: [
          VitHeader(
            title: 'Chi tiết sự kiện',
            subtitle: subtitle ?? 'Xác suất · vị thế · quy tắc',
            // Gutter-flush (S6): shell markets đã sở hữu outerHorizontalMargin.
            horizontalPadding: TabletSpacingTokens.zero,
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.marketsPredictions,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
            actions: actions,
          ),
          Expanded(
            child: VitTabletSectionBody(
              gutterFlush: true,
              contentKey: PredictionEventDetailTabletPage.contentKey,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventDetailAsync = ref.watch(
      predictionsEventDetailSnapshotProvider(widget.eventId),
    );

    return eventDetailAsync.when(
      loading: () => _scaffold(
        actions: const [],
        children: const [VitSkeletonList(rows: 6)],
      ),
      error: (error, stackTrace) => _scaffold(
        actions: const [],
        children: [
          VitErrorState(
            title: 'Không tải được chi tiết sự kiện',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(
              predictionsEventDetailSnapshotProvider(widget.eventId),
            ),
          ),
        ],
      ),
      data: (_) => _buildContent(),
    );
  }

  Widget _buildContent() {
    final viewState = ref.watch(
      predictionEventDetailControllerProvider(widget.eventId),
    );
    final controller = ref.read(
      predictionEventDetailControllerProvider(widget.eventId).notifier,
    );
    final snapshot = viewState.snapshot;
    final event = snapshot.event;
    if (!event.outcomes.any((outcome) => outcome.label == _selectedOutcome)) {
      _selectedOutcome = event.outcomes.first.label;
    }
    final orderPreview = controller.previewOrder(
      outcome: _selectedOutcome,
      isBuy: _isBuy,
      isMarket: _isMarket,
      amountText: _amount,
    );

    return _scaffold(
      subtitle: event.category,
      actions: [
        VitHeaderActionItem(
          key: PredictionEventDetailTabletPage.favoriteKey,
          type: _isFavorite
              ? VitHeaderActionType.favoriteOn
              : VitHeaderActionType.favoriteOff,
          onPressed: () => setState(() {
            _isFavorite = !_isFavorite;
          }),
        ),
        VitHeaderActionItem(
          key: PredictionEventDetailTabletPage.shareKey,
          type: VitHeaderActionType.share,
          onPressed: _showShareComingSoon,
        ),
      ],
      children: [
        _Sc211EventHeader(
          event: event,
          selectedOutcome: _selectedOutcome,
          onOutcomeSelected: (value) => setState(() {
            _selectedOutcome = value;
          }),
        ),
        _Sc211StatsGrid(event: event),
        if (snapshot.highRiskContractId != null)
          VitHighRiskStatePanel(
            state: switch (viewState.status) {
              PredictionHighRiskFlowStatus.submitting ||
              PredictionHighRiskFlowStatus.submitted =>
                VitHighRiskUiState.submitting,
              PredictionHighRiskFlowStatus.success =>
                VitHighRiskUiState.success,
              PredictionHighRiskFlowStatus.error => VitHighRiskUiState.error,
              PredictionHighRiskFlowStatus.offline =>
                VitHighRiskUiState.offline,
              _ => VitHighRiskUiState.riskReview,
            },
            title: switch (viewState.status) {
              PredictionHighRiskFlowStatus.submitting ||
              PredictionHighRiskFlowStatus.submitted => 'Đang gửi lệnh dự đoán',
              PredictionHighRiskFlowStatus.error => 'Gửi lệnh thất bại',
              PredictionHighRiskFlowStatus.offline => 'Mất kết nối',
              _ => 'Trạng thái rủi ro lệnh đang hoạt động',
            },
            message: switch (viewState.status) {
              PredictionHighRiskFlowStatus.submitting ||
              PredictionHighRiskFlowStatus.submitted =>
                'Đang gửi lệnh tới thị trường dự đoán. Vui lòng chờ trong giây lát.',
              PredictionHighRiskFlowStatus.error ||
              PredictionHighRiskFlowStatus.offline =>
                viewState.errorMessage ??
                    'Không gửi được lệnh. Vui lòng thử lại.',
              _ =>
                'Quy tắc, số tiền, xem trước xác suất, bước xác nhận, biên lai đã gửi và khôi phục đều được theo dõi trong một hợp đồng prediction dùng chung.',
            },
            contractId: snapshot.highRiskContractId,
            density: VitDensity.compact,
          ),
        if (snapshot.position != null)
          _Sc211PositionBanner(position: snapshot.position!),
        _Sc211ChartSection(snapshot: snapshot),
        _Sc211OrderBookSection(
          snapshot: snapshot,
          expanded: _showOrderBook,
          onToggle: () => setState(() {
            _showOrderBook = !_showOrderBook;
          }),
        ),
        if (event.status == PredictionEventStatus.active) ...[
          _Sc211TradeSection(
            event: event,
            preview: orderPreview,
            selectedOutcome: _selectedOutcome,
            isBuy: _isBuy,
            isMarket: _isMarket,
            amount: _amount,
            submitting: viewState.status.isBusy,
            errorMessage: viewState.errorMessage,
            onSubmit: () => _confirmAndSubmit(orderPreview),
            onSideChanged: (value) => setState(() {
              _isBuy = value;
            }),
            onOrderTypeChanged: (value) => setState(() {
              _isMarket = value;
            }),
            onAmountChanged: (value) => setState(() {
              _amount = value;
            }),
            onOutcomeChanged: (value) => setState(() {
              _selectedOutcome = value;
            }),
          ),
          _Sc211RiskLink(onTap: _showRiskComingSoon),
        ],
        _Sc211DetailTabs(
          activeTab: _activeTab,
          onChanged: (value) => setState(() {
            _activeTab = value;
          }),
        ),
        _Sc211TabCard(snapshot: snapshot, activeTab: _activeTab),
        _Sc211RelatedMarketsSection(snapshot: snapshot),
        _Sc211ArenaBridgeSection(
          snapshot: snapshot,
          onCreate: () => context.push(AppRoutePaths.arenaStudio),
        ),
        _Sc211QuickLinks(
          onRewards: () =>
              context.push(AppRoutePaths.marketsPredictionsRewards),
          onActivity: () =>
              context.push(AppRoutePaths.marketsPredictionsActivity),
        ),
      ],
    );
  }
}
