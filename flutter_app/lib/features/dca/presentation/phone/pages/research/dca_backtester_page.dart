import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/dca_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/dca/presentation/widgets/research/dca_backtester_analysis.dart';
import 'package:vit_trade_flutter/features/dca/presentation/widgets/research/dca_backtester_common.dart';
import 'package:vit_trade_flutter/features/dca/presentation/widgets/research/dca_backtester_results.dart';
import 'package:vit_trade_flutter/features/dca/presentation/widgets/research/dca_backtester_setup.dart';
import 'package:vit_trade_flutter/features/dca/presentation/widgets/research/dca_backtester_tabs.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class DCABacktesterPage extends ConsumerStatefulWidget {
  const DCABacktesterPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc176_backtester_content');
  static const runKey = Key('sc176_run_backtest');

  static Key tabKey(String tabName) => Key('sc176_tab_$tabName');
  static Key strategyKey(DcaBacktestStrategy strategy) {
    return Key('sc176_strategy_${strategy.name}');
  }

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DCABacktesterPage> createState() => _DCABacktesterPageState();
}

class _DCABacktesterPageState extends ConsumerState<DCABacktesterPage> {
  DcaBacktesterTab _activeTab = DcaBacktesterTab.setup;
  String _asset = 'BTC';
  DcaBacktestFrequency _frequency = DcaBacktestFrequency.monthly;
  DcaBacktestStrategy _strategy = DcaBacktestStrategy.fixed;
  bool _hasResults = false;

  @override
  Widget build(BuildContext context) {
    final dcaBacktesterAsync = ref.watch(dcaBacktesterProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? SharedSpacingTokens.bottomNavVisualClearance
        : SharedSpacingTokens.bottomNavNativeClearance;
    final scrollEndPadding =
        navClearance + MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      semanticLabel: 'Kiểm thử lịch sử chiến lược DCA (Backtester)',
      semanticIdentifier: 'SC-176',
      child: VitAutoHideHeaderScaffold(
        header: VitHeader(
          title: 'DCA Backtester',
          subtitle: 'Đầu tư có kỷ luật · mô phỏng lịch sử',
          showBack: true,
          onBack: _close,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DcaBacktesterTopTabs(
              activeTab: _activeTab,
              tabKey: DCABacktesterPage.tabKey,
              onChanged: (tab) => setState(() => _activeTab = tab),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: DCABacktesterPage.contentKey,
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsetsDirectional.only(bottom: scrollEndPadding),
                  child: VitPageContent(
                    rhythm: VitPageRhythm.standard,
                    padding: VitContentPadding.compact,
                    density: VitDensity.compact,
                    children: [
                      ...dcaBacktesterAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được backtester',
                            message: 'Thử lại sau hoặc quay lại màn DCA.',
                            actionLabel: 'Thử lại',
                            onAction: () =>
                                ref.invalidate(dcaBacktesterProvider),
                          ),
                        ],
                        data: (snapshot) => [
                          if (_activeTab == DcaBacktesterTab.setup)
                            DcaBacktesterSetup(
                              snapshot: snapshot,
                              asset: _asset,
                              frequency: _frequency,
                              strategy: _strategy,
                              runKey: DCABacktesterPage.runKey,
                              strategyKey: DCABacktesterPage.strategyKey,
                              onAssetChanged: (asset) =>
                                  setState(() => _asset = asset),
                              onFrequencyChanged: (frequency) =>
                                  setState(() => _frequency = frequency),
                              onStrategyChanged: (strategy) =>
                                  setState(() => _strategy = strategy),
                              onRun: _runBacktest,
                            ),
                          if (_activeTab == DcaBacktesterTab.results)
                            if (_hasResults)
                              DcaBacktesterResults(snapshot: snapshot)
                            else
                              const DcaNoResultsCard(),
                          if (_activeTab == DcaBacktesterTab.analysis)
                            if (_hasResults)
                              DcaBacktesterAnalysis(
                                snapshot: snapshot,
                                onDownloadReport: _downloadReport,
                              )
                            else
                              const DcaNoResultsCard(),
                        ],
                      ),
                      const VitHighRiskStatePanel(
                        state: VitHighRiskUiState.riskReview,
                        title: 'Backtest chỉ mang tính tham khảo',
                        message:
                            'Kết quả mô phỏng dựa trên dữ liệu lịch sử; không đảm bảo hiệu suất tương lai. Mọi thay đổi chiến lược DCA cần xem lại trước khi áp dụng.',
                        contractId: 'SC-176',
                        density: VitDensity.compact,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _runBacktest() {
    setState(() {
      _hasResults = true;
      _activeTab = DcaBacktesterTab.results;
    });
  }

  void _downloadReport() {
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Sắp ra mắt',
        message: 'Báo cáo kiểm tra chiến lược sẽ sớm ra mắt.',
      ),
    );
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.dca);
  }
}
