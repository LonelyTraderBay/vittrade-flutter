import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_copy_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/entities/trade_copy_entities.dart';

part '../../../widgets/phone/active_copies_overview.dart';
part '../../../widgets/phone/active_copies_card.dart';
part '../../../widgets/phone/active_copies_expanded_details.dart';
part '../../../widgets/phone/active_copies_alerts_modal.dart';
part '../../../widgets/phone/active_copies_shared.dart';

class ActiveCopiesPage extends ConsumerStatefulWidget {
  const ActiveCopiesPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc066_active_copies_scroll_content');
  static const addCopyKey = Key('sc066_add_copy');
  static const stopConfirmInputKey = Key('sc066_stop_confirm_input');
  static const stopConfirmButtonKey = Key('sc066_stop_confirm_button');

  static Key tabKey(String id) => Key('sc066_tab_$id');
  static Key copyKey(String id) => Key('sc066_copy_$id');
  static Key expandKey(String id) => Key('sc066_expand_$id');
  static Key detailsKey(String id) => Key('sc066_details_$id');
  static Key configureKey(String id) => Key('sc066_configure_$id');
  static Key stopKey(String id) => Key('sc066_stop_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ActiveCopiesPage> createState() => _ActiveCopiesPageState();
}

class _ActiveCopiesPageState extends ConsumerState<ActiveCopiesPage> {
  String _activeTab = 'all';
  String? _expandedCopyId;
  TradeActiveCopy? _pendingStopCopy;
  String _confirmText = '';
  String? _actionStatus;

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(tradeActiveCopiesControllerProvider);

    return controllerAsync.when(
      loading: () => VitTradeHubScaffold(
        title: 'Copy đang chạy',
        semanticLabel: 'Copy đang chạy',
        semanticIdentifier: 'SC-066',
        contentKey: ActiveCopiesPage.contentKey,
        shellRenderMode: widget.shellRenderMode,
        onBack: () => goBackOrFallback(
          context,
          fallbackPath: AppRoutePaths.tradeCopyTrading,
          mode: BackNavigationMode.historyThenFallback,
        ),
        children: const [VitSkeletonList()],
      ),
      error: (error, stackTrace) => VitTradeHubScaffold(
        title: 'Copy đang chạy',
        semanticLabel: 'Copy đang chạy',
        semanticIdentifier: 'SC-066',
        contentKey: ActiveCopiesPage.contentKey,
        shellRenderMode: widget.shellRenderMode,
        onBack: () => goBackOrFallback(
          context,
          fallbackPath: AppRoutePaths.tradeCopyTrading,
          mode: BackNavigationMode.historyThenFallback,
        ),
        children: [
          VitErrorState(
            title: 'Không tải được danh sách copy đang chạy',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradeActiveCopiesControllerProvider),
          ),
        ],
      ),
      data: (controller) {
        final snapshot = controller.state.snapshot;
        final copies = _filteredCopies(snapshot.copies);

        return Stack(
          children: [
            VitTradeHubScaffold(
              title: 'Copy đang chạy',
              semanticLabel: 'Copy đang chạy',
              semanticIdentifier: 'SC-066',
              contentKey: ActiveCopiesPage.contentKey,
              shellRenderMode: widget.shellRenderMode,
              onBack: () => goBackOrFallback(
                context,
                fallbackPath: AppRoutePaths.tradeCopyTrading,
                mode: BackNavigationMode.historyThenFallback,
              ),
              headerActions: [
                VitHeaderActionItem(
                  key: ActiveCopiesPage.addCopyKey,
                  type: VitHeaderActionType.add,
                  onPressed: () => context.push(AppRoutePaths.tradeCopyTrading),
                ),
              ],
              children: [
                VitTradeSection(
                  title: 'Tổng quan portfolio',
                  child: _PortfolioOverview(snapshot: snapshot.portfolio),
                ),
                VitTradeSection(
                  title: 'Đánh giá rủi ro',
                  child: VitHighRiskStatePanel(
                    state: VitHighRiskUiState.riskReview,
                    density: VitDensity.tool,
                    title: 'Review active copy exposure',
                    message:
                        'Check open provider risk, stop-loss rules, cooling-off status, and current P/L before changing or stopping a copy.',
                    contractId: 'Active copies: ${copies.length}',
                  ),
                ),
                VitTradeSection(
                  title: 'Trạng thái',
                  child: VitSegmentedTabBar(
                    activeKey: _activeTab,
                    onChanged: (id) => setState(() {
                      _activeTab = id;
                      _expandedCopyId = null;
                    }),
                    tabs: [
                      for (final tab in snapshot.tabs)
                        VitTabItem(
                          key: tab.id,
                          label: tab.label,
                          widgetKey: ActiveCopiesPage.tabKey(tab.id),
                        ),
                    ],
                  ),
                ),
                VitTradeSection(
                  title: 'Danh sách copy',
                  child: copies.isEmpty
                      ? _EmptyCopiesState(
                          history: _activeTab == 'history',
                          onExplore: () =>
                              context.push(AppRoutePaths.tradeCopyTrading),
                        )
                      : _ActiveCopyList(
                          copies: copies,
                          expandedCopyId: _expandedCopyId,
                          onToggle: (copyId) => setState(() {
                            _expandedCopyId = _expandedCopyId == copyId
                                ? null
                                : copyId;
                          }),
                          onViewDetails: (copy) => context.push(
                            AppRoutePaths.tradeCopyProvider(
                              copy.providerId,
                              backPath: AppRoutePaths.tradeCopyActive,
                            ),
                          ),
                          onConfigure: (copy) => context.push(
                            AppRoutePaths.tradeCopyProviderConfiguration(
                              copy.providerId,
                              backPath: AppRoutePaths.tradeCopyActive,
                            ),
                          ),
                          onStop: (copy) {
                            if (copy.status ==
                                TradeActiveCopyStatus.coolingOff) {
                              return;
                            }
                            setState(() {
                              _pendingStopCopy = copy;
                              _confirmText = '';
                            });
                          },
                        ),
                ),
                if (_actionStatus != null)
                  VitTradeSection(
                    title: 'Trạng thái thao tác',
                    child: _ActionStatusBanner(text: _actionStatus!),
                  ),
                if (controller.hasRiskAlert(snapshot.copies))
                  VitTradeSection(
                    title: 'Cảnh báo',
                    child: _RiskAlert(
                      onViewDetails: () =>
                          setState(() => _activeTab = 'active'),
                    ),
                  ),
              ],
            ),
            if (_pendingStopCopy != null)
              _StopCopyModal(
                copy: _pendingStopCopy!,
                confirmText: _confirmText,
                onTextChanged: (value) => setState(() => _confirmText = value),
                onCancel: () => setState(() => _pendingStopCopy = null),
                onConfirm: () async {
                  final result = await controller.submitCopyAction(
                    providerId: _pendingStopCopy!.providerId,
                    action: 'stop',
                  );
                  if (!mounted) return;
                  setState(() {
                    _actionStatus =
                        'Yêu cầu ${result.action} ${result.providerId} đã được ghi nhận';
                    _pendingStopCopy = null;
                    _confirmText = '';
                  });
                },
              ),
          ],
        );
      },
    );
  }

  List<TradeActiveCopy> _filteredCopies(List<TradeActiveCopy> copies) {
    return switch (_activeTab) {
      'active' =>
        copies
            .where(
              (copy) =>
                  copy.status == TradeActiveCopyStatus.active ||
                  copy.status == TradeActiveCopyStatus.coolingOff,
            )
            .toList(),
      'paused' =>
        copies
            .where((copy) => copy.status == TradeActiveCopyStatus.paused)
            .toList(),
      'history' =>
        copies
            .where((copy) => copy.status == TradeActiveCopyStatus.stopped)
            .toList(),
      _ => copies,
    };
  }
}
