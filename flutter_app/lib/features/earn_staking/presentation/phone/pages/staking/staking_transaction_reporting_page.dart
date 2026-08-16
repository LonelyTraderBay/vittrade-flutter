import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_staking_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/earn_core/presentation/widgets/earn_formatters.dart';

part '../../../widgets/staking/staking_transaction_reporting_summary_widgets.dart';
part '../../../widgets/staking/staking_transaction_reporting_transaction_widgets.dart';
part '../../../widgets/staking/staking_transaction_reporting_sheet_widgets.dart';

enum _ReportingTab { summary, transactions, export }

const double _transactionReportingControlExtent = 46;
const double _transactionReportingIconBox = 42;
const double _transactionReportingIndicatorExtent = 3;
const double _transactionReportingDividerExtent = 1;
const double _transactionReportingBodyLineHeight = 1.22;
const double _transactionReportingMetricLineHeight = 1.18;
const double _transactionReportingNoticeLineHeight = 1.2;
const double _transactionReportingMethodLineHeight = 1.2;
const EdgeInsetsDirectional _transactionReportingCardPadding =
    EdgeInsetsDirectional.all(AppSpacing.x3);

class StakingTransactionReportingPage extends ConsumerStatefulWidget {
  const StakingTransactionReportingPage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc378_info');
  static const selectorsKey = Key('sc378_selectors');
  static const tabsKey = Key('sc378_tabs');
  static const summaryKey = Key('sc378_summary');
  static const rewardsKey = Key('sc378_rewards');
  static const transactionsKey = Key('sc378_transactions');
  static const exportKey = Key('sc378_export');
  static const methodSheetKey = Key('sc378_method_sheet');
  static const exportSheetKey = Key('sc378_export_sheet');
  static const footerKey = Key('sc378_footer');

  static Key tabKey(String id) => Key('sc378_tab_$id');

  static Key methodKey(String id) => Key('sc378_method_$id');

  static Key exportOptionKey(String id) => Key('sc378_export_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingTransactionReportingPage> createState() =>
      _StakingTransactionReportingPageState();
}

class _StakingTransactionReportingPageState
    extends ConsumerState<StakingTransactionReportingPage> {
  _ReportingTab _tab = _ReportingTab.summary;
  // Bẫy 14 (GD4 playbook): repo giờ đã async — seed 1 lần trong nhánh
  // data: bên dưới thay vì initState.
  String? _year;
  String? _costBasis;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(
      stakingTransactionReportingSnapshotProvider,
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Báo cáo giao dịch staking phục vụ khai thuế',
      semanticIdentifier: 'SC-378',
      child: Material(
        color: AppColors.bg,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnStaking),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnStaking),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () =>
                  ref.invalidate(stakingTransactionReportingSnapshotProvider),
            ),
          ),
          data: (snapshot) {
            _year ??= snapshot.defaultYear;
            _costBasis ??= snapshot.defaultCostBasis;
            final mode = widget.shellRenderMode ?? defaultShellRenderMode();
            final bottomInset =
                (mode.usesVisualQaFrame
                    ? DeviceMetrics.bottomChrome + AppSpacing.x7
                    : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
                MediaQuery.paddingOf(context).bottom;

            return VitAutoHideHeaderScaffold(
              header: VitTopChrome(
                type: VitTopChromeType.detail,
                title: snapshot.title,
                subtitle: 'Báo cáo giao dịch — tham khảo thuế',
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
                        density: VitDensity.compact,
                        children: [
                          VitInfoCallout(
                            key: StakingTransactionReportingPage.infoKey,
                            title: snapshot.infoTitle,
                            message: snapshot.infoBody,
                            icon: Icons.description_outlined,
                            accentColor: AppColors.primarySoft,
                            padding: _transactionReportingCardPadding,
                          ),
                          _Selectors(
                            snapshot: snapshot,
                            year: _year!,
                            costBasis: _costBasis!,
                            onYearChanged: (year) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _year = year);
                            },
                            onOpenCostBasis: () => _openMethodSheet(snapshot),
                          ),
                          _ReportingTabs(
                            active: _tab,
                            onChanged: (tab) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _tab = tab);
                            },
                          ),
                          if (_tab == _ReportingTab.summary)
                            _SummaryTab(
                              snapshot: snapshot,
                              costBasis: _costBasis!,
                            )
                          else if (_tab == _ReportingTab.transactions)
                            _TransactionsTab(snapshot: snapshot)
                          else
                            _ExportTab(
                              snapshot: snapshot,
                              onOpenExport: () => _openExportSheet(snapshot),
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

  Future<void> _openMethodSheet(
    StakingTransactionReportingSnapshot snapshot,
  ) async {
    unawaited(HapticFeedback.selectionClick());
    await showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => _SheetFrame(
        child: _MethodSheet(
          methods: snapshot.costBasisMethods,
          selected: _costBasis!,
          onChanged: (method) {
            setState(() => _costBasis = method);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Future<void> _openExportSheet(
    StakingTransactionReportingSnapshot snapshot,
  ) async {
    unawaited(HapticFeedback.selectionClick());
    await showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) =>
          _SheetFrame(child: _ExportSheet(snapshot: snapshot)),
    );
  }
}
