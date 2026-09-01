import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/earn_core/presentation/widgets/earn_custody_risk_banner.dart';
import 'package:vit_trade_flutter/features/earn_core/presentation/widgets/earn_formatters.dart';
import 'package:vit_trade_flutter/app/providers/earn_staking_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';
part '../../../widgets/staking/staking_history_summary_filters.dart';
part '../../../widgets/staking/staking_history_detail_list.dart';
part '../../../widgets/staking/staking_history_common.dart';

enum _HistoryTypeFilter { all, stake, unstake, claim, compound, penalty }

enum _HistoryStatusFilter { all, completed, pending, failed }

class StakingHistoryPage extends ConsumerStatefulWidget {
  const StakingHistoryPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc360_summary_card');
  static const searchKey = Key('sc360_search_field');
  static const filterButtonKey = Key('sc360_filter_button');
  static const exportButtonKey = Key('sc360_export_button');
  static const filterPanelKey = Key('sc360_filter_panel');
  static const resultCountKey = Key('sc360_result_count');
  static const detailKey = Key('sc360_detail_card');
  static const firstTransactionKey = Key('sc360_first_transaction');

  static Key transactionKey(String id) => Key('sc360_transaction_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingHistoryPage> createState() => _StakingHistoryPageState();
}

class _StakingHistoryPageState extends ConsumerState<StakingHistoryPage> {
  final _searchController = TextEditingController();
  _HistoryTypeFilter _typeFilter = _HistoryTypeFilter.all;
  _HistoryStatusFilter _statusFilter = _HistoryStatusFilter.all;
  bool _showFilters = false;
  String _query = '';
  StakingHistoryTransactionDraft? _selected;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(stakingHistorySnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Lịch sử Staking — tra cứu và lọc giao dịch stake',
      semanticIdentifier: 'SC-360',
      child: Material(
        color: AppColors.bg,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnDashboard),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnDashboard),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(stakingHistorySnapshotProvider),
            ),
          ),
          data: (snapshot) {
            final transactions = _filteredTransactions(snapshot.transactions);
            final mode = widget.shellRenderMode ?? defaultShellRenderMode();
            final bottomInset =
                (mode.usesVisualQaFrame
                    ? DeviceMetrics.bottomChrome + AppSpacing.x7
                    : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
                MediaQuery.paddingOf(context).bottom;

            return VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: snapshot.title,
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: EarnSpacingTokens.earnBottomInsetPadding(
                        bottomInset,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.compact,
                        gap: VitContentGap.defaultGap,
                        children: [
                          _SummaryCard(snapshot: snapshot),
                          _SearchAndActions(
                            controller: _searchController,
                            placeholder: snapshot.searchPlaceholder,
                            filtersActive:
                                _typeFilter != _HistoryTypeFilter.all ||
                                _statusFilter != _HistoryStatusFilter.all,
                            onQueryChanged: (query) {
                              setState(() => _query = query);
                            },
                            onFilter: () {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _showFilters = !_showFilters);
                            },
                            onExport: _export,
                          ),
                          if (_showFilters)
                            _HistoryFilterSection(
                              key: StakingHistoryPage.filterPanelKey,
                              typeFilter: _typeFilter,
                              statusFilter: _statusFilter,
                              onTypeChanged: (filter) {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() => _typeFilter = filter);
                              },
                              onStatusChanged: (filter) {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() => _statusFilter = filter);
                              },
                              onClear: _clearFilters,
                            ),
                          _ResultsHeader(
                            count: transactions.length,
                            filtered:
                                transactions.length !=
                                    snapshot.transactions.length ||
                                _query.isNotEmpty,
                            total: snapshot.transactions.length,
                            onClear: _clearFilters,
                          ),
                          if (_selected != null)
                            _TransactionDetailCard(
                              key: StakingHistoryPage.detailKey,
                              tx: _selected!,
                              onClose: () => setState(() => _selected = null),
                            ),
                          _TransactionList(
                            transactions: transactions,
                            onTap: (tx) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _selected = tx);
                            },
                          ),
                          const EarnDisclaimerBanner(
                            text:
                                'APY là ước tính tham khảo và có thể thay đổi. '
                                'Giá tài sản và APY có thể biến động; DeFi có rủi ro smart contract.',
                          ),
                          _FooterNote(note: snapshot.footerNote),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<StakingHistoryTransactionDraft> _filteredTransactions(
    List<StakingHistoryTransactionDraft> transactions,
  ) {
    final query = _query.trim().toLowerCase();
    return [
      for (final tx in transactions)
        if ((_typeFilter == _HistoryTypeFilter.all ||
                _typeFilter.name == tx.type.name) &&
            (_statusFilter == _HistoryStatusFilter.all ||
                _statusFilter.name == tx.status.name) &&
            (query.isEmpty ||
                tx.id.toLowerCase().contains(query) ||
                tx.asset.toLowerCase().contains(query) ||
                tx.product.toLowerCase().contains(query)))
          tx,
    ];
  }

  void _clearFilters() {
    unawaited(HapticFeedback.selectionClick());
    _searchController.clear();
    setState(() {
      _query = '';
      _typeFilter = _HistoryTypeFilter.all;
      _statusFilter = _HistoryStatusFilter.all;
      _selected = null;
    });
  }

  void _export() {
    unawaited(HapticFeedback.selectionClick());
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Sẽ sớm ra mắt',
        message: 'Xuất lịch sử staking CSV sẽ sớm ra mắt',
      ),
    );
  }
}
