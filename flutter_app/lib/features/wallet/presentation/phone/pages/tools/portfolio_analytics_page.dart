import 'dart:math' as math;

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
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_page_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

part '../../../widgets/tools/portfolio_analytics_summary_switcher.dart';
part '../../../widgets/tools/portfolio_analytics_overview_chart.dart';
part '../../../widgets/tools/portfolio_analytics_metrics_assets.dart';
part '../../../widgets/tools/portfolio_analytics_common.dart';

const _analyticsBackground = AppColors.bg;
const _analyticsPrimary = AppColors.primary;
const _analyticsGreen = AppColors.buy;
const _analyticsRed = AppColors.sell;

class PortfolioAnalyticsPage extends ConsumerStatefulWidget {
  const PortfolioAnalyticsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc142_portfolio_analytics_content');
  static Key periodKey(String period) => Key('sc142_period_$period');
  static Key viewKey(String id) => Key('sc142_view_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PortfolioAnalyticsPage> createState() =>
      _PortfolioAnalyticsPageState();
}

class _PortfolioAnalyticsPageState
    extends ConsumerState<PortfolioAnalyticsPage> {
  String _activeView = 'overview';
  late String _activePeriod;

  @override
  void initState() {
    super.initState();
    _activePeriod = '1M';
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(walletPortfolioAnalyticsProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? WalletSpacingTokens.walletAnalyticsBottomInsetVisual
            : WalletSpacingTokens.walletAnalyticsBottomInsetNative) +
        MediaQuery.paddingOf(context).bottom;

    return VitAutoHidePageScaffold(
      semanticLabel: 'Phân tích danh mục - tổng quan tài sản',
      semanticIdentifier: 'SC-142',
      background: _analyticsBackground,
      header: VitTopChrome(
        type: VitTopChromeType.detail,
        title: 'Phân tích Danh mục',
        subtitle: 'Tổng quan tài sản · không hype',
        showBack: true,
        onBack: () => context.go(AppRoutePaths.wallet),
      ),
      body: VitInsetScrollView(
        key: PortfolioAnalyticsPage.contentKey,
        bottomInset: bottomInset,
        child: VitPageContent(
          rhythm: VitPageRhythm.standard,
          padding: VitContentPadding.compact,
          density: VitDensity.compact,
          gap: VitContentGap.tight,
          children: [
            ...snapshotAsync.when(
              loading: () => const [VitSkeletonList()],
              error: (error, stackTrace) => [
                VitErrorState(
                  title: 'Không tải được phân tích danh mục',
                  message: 'Vui lòng kiểm tra kết nối và thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () =>
                      ref.invalidate(walletPortfolioAnalyticsProvider),
                ),
              ],
              data: (snapshot) => [
                _ValueSummary(snapshot: snapshot),
                _ViewSwitcher(
                  active: _activeView,
                  onChanged: (view) => setState(() => _activeView = view),
                ),
                if (_activeView == 'overview') ...[
                  ..._OverviewContent(
                    snapshot: snapshot,
                    activePeriod: _activePeriod,
                    onPeriodChanged: (period) =>
                        setState(() => _activePeriod = period),
                  ).sectionChildren,
                ] else
                  _PlaceholderAnalyticsView(view: _activeView),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
