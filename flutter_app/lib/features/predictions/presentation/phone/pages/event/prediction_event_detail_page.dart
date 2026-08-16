import 'dart:async';

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/predictions_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/predictions_controller_providers.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/controllers/predictions_controller.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/event/prediction_order_preview_card.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/predictions_time_remaining.dart';

part '../../../widgets/event/prediction_event_detail_header.dart';
part '../../../widgets/event/prediction_event_detail_stats_position.dart';
part '../../../widgets/event/prediction_event_detail_chart.dart';
part '../../../widgets/event/prediction_event_detail_order_book.dart';
part '../../../widgets/event/prediction_event_detail_trade_panel.dart';
part '../../../widgets/event/prediction_event_detail_trade_controls.dart';
part '../../../widgets/event/prediction_event_detail_detail_tabs.dart';
part '../../../widgets/event/prediction_event_detail_comments.dart';
part '../../../widgets/event/prediction_event_detail_activity_holders.dart';
part '../../../widgets/event/prediction_event_detail_related_arena.dart';
part '../../../widgets/event/prediction_event_detail_quick_links.dart';
part '../../../widgets/event/prediction_event_detail_common.dart';

const _predictionPrimary = AppColors.primary;
const _predictionPurple = AppColors.accent;

class PredictionEventDetailPage extends ConsumerStatefulWidget {
  const PredictionEventDetailPage({
    super.key,
    required this.eventId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc030_prediction_event_detail_content');
  static const favoriteKey = Key('sc030_favorite');
  static const shareKey = Key('sc030_share');
  static const orderBookToggleKey = Key('sc030_order_book_toggle');
  static const commentsTabKey = Key('sc030_tab_comments');
  static const holdersTabKey = Key('sc030_tab_holders');
  static const activityTabKey = Key('sc030_tab_activity');
  static const rulesTabKey = Key('sc030_tab_rules');
  static const riskLinkKey = Key('sc030_risk_link');
  static const arenaCreateKey = Key('sc030_arena_create');
  static const dailyRewardsKey = Key('sc030_daily_rewards');
  static const globalActivityKey = Key('sc030_global_activity');

  static Key relatedKey(String id) => Key('sc030_related_$id');

  final String eventId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PredictionEventDetailPage> createState() =>
      _PredictionEventDetailPageState();
}

enum _DetailTab { rules, comments, holders, activity }

class _PredictionEventDetailPageState
    extends ConsumerState<PredictionEventDetailPage> {
  _DetailTab _activeTab = _DetailTab.rules;
  bool _isFavorite = false;
  bool _showOrderBook = false;
  bool _isBuy = true;
  bool _isMarket = true;
  String _selectedOutcome = 'Yes';
  String _amount = '';

  @override
  void didUpdateWidget(covariant PredictionEventDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.eventId != widget.eventId) {
      _activeTab = _DetailTab.rules;
      _showOrderBook = false;
      _selectedOutcome = 'Yes';
      _amount = '';
    }
  }

  void _showComingSoon() {
    unawaited(HapticFeedback.selectionClick());
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Sắp ra mắt',
        message: 'Tìm hiểu rủi ro sẽ sớm ra mắt.',
      ),
    );
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
    context.go(AppRoutePaths.marketsPredictionReceipt(receiptId));
  }

  @override
  Widget build(BuildContext context) {
    final eventDetailAsync = ref.watch(
      predictionsEventDetailSnapshotProvider(widget.eventId),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final footerPadding =
        (mode.usesVisualQaFrame
            ? SharedSpacingTokens.bottomNavVisualClearance
            : SharedSpacingTokens.bottomNavNativeClearance) +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? AppSpacing.x5 : AppSpacing.x4);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Chi tiết sự kiện dự đoán: xác suất, vị thế và quy tắc',
      semanticIdentifier: 'SC-030',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitTopChrome(
            type: VitTopChromeType.detail,
            title: 'Chi tiết sự kiện',
            subtitle: 'Xác suất · vị thế · quy tắc',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.marketsPredictions),
            actions: [
              VitHeaderActionItem(
                key: PredictionEventDetailPage.favoriteKey,
                type: _isFavorite
                    ? VitHeaderActionType.favoriteOn
                    : VitHeaderActionType.favoriteOff,
                onPressed: () => setState(() {
                  _isFavorite = !_isFavorite;
                }),
              ),
              const VitHeaderActionItem(
                key: PredictionEventDetailPage.shareKey,
                type: VitHeaderActionType.share,
                onPressed: _noop,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: PredictionEventDetailPage.contentKey,
                    padding:
                        PredictionsSpacingTokens.predictionDetailScrollPadding(
                          footerPadding,
                        ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      density: VitDensity.compact,
                      children: eventDetailAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được chi tiết sự kiện',
                            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              predictionsEventDetailSnapshotProvider(
                                widget.eventId,
                              ),
                            ),
                          ),
                        ],
                        data: (_) {
                          final viewState = ref.watch(
                            predictionEventDetailControllerProvider(
                              widget.eventId,
                            ),
                          );
                          final controller = ref.read(
                            predictionEventDetailControllerProvider(
                              widget.eventId,
                            ).notifier,
                          );
                          final snapshot = viewState.snapshot;
                          final event = snapshot.event;
                          if (!event.outcomes.any(
                            (outcome) => outcome.label == _selectedOutcome,
                          )) {
                            _selectedOutcome = event.outcomes.first.label;
                          }
                          final orderPreview = controller.previewOrder(
                            outcome: _selectedOutcome,
                            isBuy: _isBuy,
                            isMarket: _isMarket,
                            amountText: _amount,
                          );
                          return [
                            _EventHeader(
                              event: event,
                              selectedOutcome: _selectedOutcome,
                              onOutcomeSelected: (value) => setState(() {
                                _selectedOutcome = value;
                              }),
                            ),
                            _StatsGrid(event: event),
                            if (snapshot.highRiskContractId != null)
                              VitHighRiskStatePanel(
                                state: switch (viewState.status) {
                                  PredictionHighRiskFlowStatus.submitting ||
                                  PredictionHighRiskFlowStatus.submitted =>
                                    VitHighRiskUiState.submitting,
                                  PredictionHighRiskFlowStatus.success =>
                                    VitHighRiskUiState.success,
                                  PredictionHighRiskFlowStatus.error =>
                                    VitHighRiskUiState.error,
                                  PredictionHighRiskFlowStatus.offline =>
                                    VitHighRiskUiState.offline,
                                  _ => VitHighRiskUiState.riskReview,
                                },
                                title: switch (viewState.status) {
                                  PredictionHighRiskFlowStatus.submitting ||
                                  PredictionHighRiskFlowStatus.submitted =>
                                    'Đang gửi lệnh dự đoán',
                                  PredictionHighRiskFlowStatus.error =>
                                    'Gửi lệnh thất bại',
                                  PredictionHighRiskFlowStatus.offline =>
                                    'Mất kết nối',
                                  _ => 'Order risk states active',
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
                                    'Rules, amount setup, probability preview, confirmation, submitted receipt and recovery are tracked in one prediction contract.',
                                },
                                contractId: snapshot.highRiskContractId,
                                density: VitDensity.compact,
                              ),
                            if (snapshot.position != null)
                              _PositionBanner(position: snapshot.position!),
                            _ChartSection(snapshot: snapshot),
                            _OrderBookSection(
                              snapshot: snapshot,
                              expanded: _showOrderBook,
                              onToggle: () => setState(() {
                                _showOrderBook = !_showOrderBook;
                              }),
                            ),
                            if (event.status ==
                                PredictionEventStatus.active) ...[
                              _TradeSection(
                                event: event,
                                preview: orderPreview,
                                selectedOutcome: _selectedOutcome,
                                isBuy: _isBuy,
                                isMarket: _isMarket,
                                amount: _amount,
                                submitting: viewState.status.isBusy,
                                errorMessage: viewState.errorMessage,
                                onSubmit: _submitOrder,
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
                              _RiskLink(onTap: _showComingSoon),
                            ],
                            _DetailTabs(
                              activeTab: _activeTab,
                              onChanged: (value) => setState(() {
                                _activeTab = value;
                              }),
                            ),
                            _TabCard(snapshot: snapshot, activeTab: _activeTab),
                            _RelatedMarketsSection(snapshot: snapshot),
                            _ArenaBridgeSection(
                              snapshot: snapshot,
                              onCreate: () =>
                                  context.go(AppRoutePaths.arenaStudio),
                            ),
                            _QuickLinks(
                              onRewards: () => context.go(
                                AppRoutePaths.marketsPredictionsRewards,
                              ),
                              onActivity: () => context.go(
                                AppRoutePaths.marketsPredictionsActivity,
                              ),
                            ),
                          ];
                        },
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

void _noop() {}
