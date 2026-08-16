import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/trade_compliance_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/widgets/governance/transaction_reporting_actions.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/widgets/governance/transaction_reporting_common.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/widgets/governance/transaction_reporting_filters.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/widgets/governance/transaction_reporting_reports.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/widgets/governance/transaction_reporting_stats.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_hero.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class TransactionReportingPage extends ConsumerStatefulWidget {
  const TransactionReportingPage({super.key, this.shellRenderMode});

  static const contentKey = transactionReportingContentKey;
  static const searchKey = transactionReportingSearchKey;

  static Key tabKey(String id) => transactionReportingTabKey(id);
  static Key actionKey(String id) => transactionReportingActionKey(id);

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<TransactionReportingPage> createState() =>
      _TransactionReportingPageState();
}

class _TransactionReportingPageState
    extends ConsumerState<TransactionReportingPage> {
  String _tab = 'queue';
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(tradeTransactionReportingProvider);
    return Material(
      color: transactionReportBackground,
      child: VitTradeHubScaffold(
        title: 'Transaction Reporting',
        subtitle: 'MiFID II - EMIR Compliance',
        semanticLabel: 'Báo cáo giao dịch tuân thủ quy định',
        semanticIdentifier: 'SC-093',
        contentKey: TransactionReportingPage.contentKey,
        shellRenderMode: widget.shellRenderMode,
        useCopyTradingInset: true,
        onBack: () => goBackOrFallback(
          context,
          fallbackPath: AppRoutePaths.tradeCopyTrading,
          mode: BackNavigationMode.historyThenFallback,
        ),
        children: async.when(
          loading: () => const [VitSkeletonList()],
          error: (error, stackTrace) => [
            VitErrorState(
              title: 'Không tải được dữ liệu',
              message: 'Vui lòng kiểm tra kết nối và thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(tradeTransactionReportingProvider),
            ),
          ],
          data: (snapshot) {
            final reports = filterTransactionReports(
              snapshot: snapshot,
              tab: _tab,
              query: _query,
            );
            return [
              const VitTradeSection(
                title: 'Review',
                child: VitHighRiskStatePanel(
                  state: VitHighRiskUiState.riskReview,
                  density: VitDensity.tool,
                  title: 'Review regulatory reporting queue',
                  message:
                      'Confirm report status, retry impact, and next steps before resubmitting transaction records.',
                ),
              ),
              VitTradeComplianceSection(
                title: 'Reporting status',
                statusPill: VitStatusPill(
                  label: 'Queue: ${snapshot.stats.pending}',
                  status: VitStatusPillStatus.warning,
                  size: VitStatusPillSize.sm,
                ),
                items: [
                  VitTradeComplianceItem(
                    label: 'Confirmed',
                    value: '${snapshot.stats.confirmed}',
                  ),
                  VitTradeComplianceItem(
                    label: 'Failed',
                    value: '${snapshot.stats.failed}',
                  ),
                ],
              ),
              VitTradeSection(
                title: 'Queue',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const VitTradeComplianceHero(
                      title: 'MiFID II Article 26 Compliance',
                      description:
                          'All transactions must be reported to ARM within '
                          'T+1. Reports include 65+ RTS 22 fields. '
                          'Auto-submission enabled.',
                      icon: Icons.shield_outlined,
                      accentColor: transactionReportPrimary,
                    ),
                    TransactionReportingStatsGrid(stats: snapshot.stats),
                    TransactionReportingSearchField(
                      query: _query,
                      onChanged: (value) => setState(() => _query = value),
                    ),
                    TransactionReportingTabs(
                      activeId: _tab,
                      stats: snapshot.stats,
                      onChanged: (id) => setState(() => _tab = id),
                    ),
                    if (_tab == 'stats')
                      TransactionReportingStatsTab(stats: snapshot.stats)
                    else
                      TransactionReportsSection(
                        reports: reports,
                        query: _query,
                        onViewXml: (report) async {
                          await showVitNoticeSheet(
                            context: context,
                            title: 'Xem XML',
                            message: 'ISO 20022 XML: ${report.id}',
                            variant: VitBannerVariant.success,
                            ctaVariant: VitCtaButtonVariant.success,
                          );
                        },
                        onRetry: (report) async {
                          await showVitNoticeSheet(
                            context: context,
                            title: 'Đã xếp hàng chờ',
                            message:
                                'Đã thêm ${report.id} vào hàng chờ gửi lại.',
                            variant: VitBannerVariant.success,
                            ctaVariant: VitCtaButtonVariant.success,
                          );
                        },
                        onCopy: (report) async {
                          final messageId = report.messageId;
                          if (messageId == null) return;
                          await Clipboard.setData(
                            ClipboardData(text: messageId),
                          );
                          if (!context.mounted) return;
                          await showVitNoticeSheet(
                            context: context,
                            title: 'Đã sao chép',
                            message: 'ID tin nhắn đã được sao chép.',
                            variant: VitBannerVariant.success,
                            ctaVariant: VitCtaButtonVariant.success,
                          );
                        },
                      ),
                    TransactionReportingQuickActions(
                      onDashboard: () => context.push(
                        AppRoutePaths.tradeCopyRegulatoryReportsDashboard,
                      ),
                      onArmStatus: () => context.push(
                        AppRoutePaths.tradeCopyArmIntegrationStatus,
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
        ),
      ),
    );
  }
}
