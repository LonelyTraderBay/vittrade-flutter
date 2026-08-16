import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/features/earn_core/presentation/widgets/earn_custody_risk_banner.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_savings_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

part '../../../widgets/savings/savings_history_page_sections.dart';
part '../../../widgets/savings/savings_history_page_common.dart';

enum _HistoryTypeFilter { all, subscribe, redeem, interest, compound, early }

enum _HistoryDateFilter { d7, d30, d90, all }

class SavingsHistoryPage extends ConsumerStatefulWidget {
  const SavingsHistoryPage({super.key, this.shellRenderMode});

  static const firstTransactionKey = Key('sc334_first_transaction');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsHistoryPage> createState() => _SavingsHistoryPageState();
}

class _SavingsHistoryPageState extends ConsumerState<SavingsHistoryPage> {
  _HistoryTypeFilter _typeFilter = _HistoryTypeFilter.all;
  _HistoryDateFilter _dateFilter = _HistoryDateFilter.all;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(savingsHistorySnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Lịch sử Tiết kiệm',
      semanticIdentifier: 'SC-334',
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
              onAction: () => ref.invalidate(savingsHistorySnapshotProvider),
            ),
          ),
          data: (snapshot) {
            final mode = widget.shellRenderMode ?? defaultShellRenderMode();
            final scrollTailReserve =
                (mode.usesVisualQaFrame
                    ? DeviceMetrics.bottomChrome + AppSpacing.x3
                    : DeviceMetrics.nativeBottomChrome + AppSpacing.x3) +
                MediaQuery.paddingOf(context).bottom;
            final transactions = _filteredTransactions(
              snapshot.transactions,
              _typeFilter,
            );
            final grouped = _groupTransactions(transactions);

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
                      padding: EdgeInsetsDirectional.only(
                        bottom: scrollTailReserve,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.compact,
                        gap: VitContentGap.tight,
                        children: [
                          _SummaryMetrics(snapshot: snapshot),
                          _SearchField(placeholder: snapshot.searchPlaceholder),
                          _TypeFilterRow(
                            active: _typeFilter,
                            onChanged: (filter) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _typeFilter = filter);
                            },
                          ),
                          _DateFilterRow(
                            active: _dateFilter,
                            onChanged: (filter) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _dateFilter = filter);
                            },
                          ),
                          _ResultsHeader(count: transactions.length),
                          for (final group in grouped) ...[
                            _DateHeader(date: group.date),
                            for (final tx in group.transactions)
                              Padding(
                                padding: EdgeInsetsDirectional.only(
                                  bottom: tx == group.transactions.last
                                      ? AppSpacing.x3
                                      : AppSpacing.x2,
                                ),
                                child: _TransactionCard(
                                  key: tx == transactions.first
                                      ? SavingsHistoryPage.firstTransactionKey
                                      : null,
                                  tx: tx,
                                  receiptRoute: snapshot.receiptRoute,
                                ),
                              ),
                          ],
                          const EarnDisclaimerBanner(
                            text:
                                'Lãi suất và giá trị giao dịch mang tính tham khảo; APY có thể thay đổi theo thời gian.',
                          ),
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
}
