import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_asset_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_formatters.dart';

part '../../../widgets/research/token_info_tabs_widgets.dart';
part '../../../widgets/research/token_info_market_widgets.dart';
part '../../../widgets/research/token_info_detail_widgets.dart';

const _marketPrimary = AppColors.primary;
const double _tokenInfoVisualScrollClearance = 108;
const double _tokenInfoNativeScrollClearance = 72;
const double _tokenInfoSectionGap = AppSpacing.x3;
const double _tokenInfoHeroAvatar = AppSpacing.buttonCompact;
const double _tokenInfoHeroAvatarGap = AppSpacing.x3;
const double _tokenInfoHeroSubtitleGap = AppSpacing.x1;
const double _tokenInfoHeroPriceGap = AppSpacing.x3;
const double _tokenInfoInfoIcon = 14;
const double _tokenInfoInfoIconGap = AppSpacing.x2;
const double _tokenInfoSupplyProgressGap = AppSpacing.x2;
const double _tokenInfoSupplyProgressHeight = AppSpacing.x1;
const double _tokenInfoMetricGap = AppSpacing.x2;
const double _tokenInfoDonutSize = 70;
const double _tokenInfoDonutStroke = 16;
const double _tokenInfoDonutInset = 8;
const double _tokenInfoDistributionGap = AppSpacing.x3;
const double _tokenInfoDistributionDot = AppSpacing.x2;
const double _tokenInfoDistributionDotGap = AppSpacing.x2;
const double _tokenInfoRecordCardGap = AppSpacing.x2;
const double _tokenInfoRecordIcon = 14;
const double _tokenInfoRecordIconGap = AppSpacing.x1;
const double _tokenInfoRecordValueGap = AppSpacing.x2;
const double _tokenInfoRecordDeltaGap = AppSpacing.x2;
const double _tokenInfoChartIconBox = AppSpacing.buttonCompact;
const double _tokenInfoChartIconGap = AppSpacing.x3;
const double _tokenInfoChartSubtitleGap = AppSpacing.x1;
const double _tokenInfoOnchainIcon = AppSpacing.iconSm;
const double _tokenInfoOnchainIconGap = AppSpacing.x2;
const double _tokenInfoOnchainTitleGap = AppSpacing.x3;
const double _tokenInfoMiniStatGap = AppSpacing.x2;
const double _tokenInfoMiniStatValueGap = AppSpacing.x1;
const double _tokenInfoProjectTitleGap = AppSpacing.x2;
const double _tokenInfoProjectLinkGap = AppSpacing.x2;
const double _tokenInfoProjectLinkIcon = AppSpacing.iconSm + AppSpacing.x1;
const double _tokenInfoProjectLinkIconGap = AppSpacing.x2;
const double _tokenInfoProjectLinkOpenIcon = 15;
const double _tokenInfoDisclaimerIcon = 14;
const double _tokenInfoDisclaimerIconGap = AppSpacing.x2;
const double _tokenInfoDisclaimerLineHeight = 1.25;
const EdgeInsetsDirectional _tokenInfoHeroPadding = EdgeInsetsDirectional.all(
  AppSpacing.x3,
);
const EdgeInsetsDirectional _tokenInfoInfoCardPadding =
    EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.x3);
const EdgeInsetsDirectional _tokenInfoInfoRowPadding =
    EdgeInsetsDirectional.symmetric(vertical: AppSpacing.x2);
const EdgeInsetsDirectional _tokenInfoSupplyCardPadding =
    EdgeInsetsDirectional.all(AppSpacing.x3);
const EdgeInsetsDirectional _tokenInfoMetricLinePadding =
    EdgeInsetsDirectional.symmetric(vertical: AppSpacing.x1);
const EdgeInsetsDirectional _tokenInfoRecordCardPadding =
    EdgeInsetsDirectional.all(AppSpacing.x3);
const EdgeInsetsDirectional _tokenInfoChartCardPadding =
    EdgeInsetsDirectional.all(AppSpacing.x3);
const EdgeInsetsDirectional _tokenInfoOnchainCardPadding =
    EdgeInsetsDirectional.all(AppSpacing.x3);
const EdgeInsetsDirectional _tokenInfoMiniStatPadding =
    EdgeInsetsDirectional.all(AppSpacing.x3);
const EdgeInsetsDirectional _tokenInfoProjectCardPadding =
    EdgeInsetsDirectional.all(AppSpacing.x3);
const EdgeInsetsDirectional _tokenInfoProjectLinkPadding =
    EdgeInsetsDirectional.all(AppSpacing.x3);
const EdgeInsetsDirectional _tokenInfoDisclaimerPadding =
    EdgeInsetsDirectional.symmetric(
      horizontal: AppSpacing.x3,
      vertical: AppSpacing.x2,
    );

enum _TokenInfoTab { overview, onchain, project }

class TokenInfoPage extends ConsumerStatefulWidget {
  const TokenInfoPage({super.key, required this.pairId, this.shellRenderMode});

  static const contentKey = Key('sc045_token_info_content');
  static const overviewTabKey = Key('sc045_tab_overview');
  static const onchainTabKey = Key('sc045_tab_onchain');
  static const projectTabKey = Key('sc045_tab_project');
  static const chartButtonKey = Key('sc045_chart_button');
  static const marketStatsCardKey = Key('sc045_market_stats_card');

  final String pairId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<TokenInfoPage> createState() => _TokenInfoPageState();
}

class _TokenInfoPageState extends ConsumerState<TokenInfoPage> {
  _TokenInfoTab _tab = _TokenInfoTab.overview;

  @override
  Widget build(BuildContext context) {
    final tokenInfoAsync = ref.watch(
      marketTokenInfoSnapshotProvider(widget.pairId),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? _tokenInfoVisualScrollClearance
            : _tokenInfoNativeScrollClearance) +
        MediaQuery.paddingOf(context).bottom;
    final fallbackTitle = '${widget.pairId.toUpperCase()} - Thông tin';

    // GD4-F3 (mục 5, biến thể 2): tiêu đề = pair.baseAsset (không suy ra
    // được từ pairId route param) — bọc toàn bộ return trong .when().
    return tokenInfoAsync.when(
      loading: () => _TokenInfoScaffold(
        title: fallbackTitle,
        onBack: () => context.go(AppRoutePaths.pairDetail(widget.pairId)),
        tab: _tab,
        onTabChanged: (tab) => setState(() => _tab = tab),
        scrollEndClearance: scrollEndClearance,
        children: const [VitSkeletonList()],
      ),
      error: (error, stackTrace) => _TokenInfoScaffold(
        title: fallbackTitle,
        onBack: () => context.go(AppRoutePaths.pairDetail(widget.pairId)),
        tab: _tab,
        onTabChanged: (tab) => setState(() => _tab = tab),
        scrollEndClearance: scrollEndClearance,
        children: [
          VitErrorState(
            title: 'Không tải được thông tin token',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () =>
                ref.invalidate(marketTokenInfoSnapshotProvider(widget.pairId)),
          ),
        ],
      ),
      data: (snapshot) => _TokenInfoScaffold(
        title: '${snapshot.pair.baseAsset} - Thông tin',
        onBack: () => context.go(AppRoutePaths.pairDetail(snapshot.pair.id)),
        tab: _tab,
        onTabChanged: (tab) => setState(() => _tab = tab),
        scrollEndClearance: scrollEndClearance,
        children: [
          if (_tab == _TokenInfoTab.overview)
            _OverviewTab(snapshot: snapshot)
          else if (_tab == _TokenInfoTab.onchain)
            _OnchainTab(snapshot: snapshot)
          else
            _ProjectTab(snapshot: snapshot),
          const _Disclaimer(),
        ],
      ),
    );
  }
}

/// Khung trang chung cho 3 nhánh `.when()` của [TokenInfoPage] — tiêu đề
/// phụ thuộc `snapshot.pair.baseAsset` nên cả 3 nhánh dựng scaffold đầy đủ
/// riêng (mục 5, biến thể 2 của GD4-Async-Playbook).
class _TokenInfoScaffold extends StatelessWidget {
  const _TokenInfoScaffold({
    required this.title,
    required this.onBack,
    required this.tab,
    required this.onTabChanged,
    required this.scrollEndClearance,
    required this.children,
  });

  final String title;
  final VoidCallback onBack;
  final _TokenInfoTab tab;
  final ValueChanged<_TokenInfoTab> onTabChanged;
  final double scrollEndClearance;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Thông tin token',
      semanticIdentifier: 'SC-045',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(title: title, showBack: true, onBack: onBack),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TokenTabs(active: tab, onChanged: onTabChanged),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: TokenInfoPage.contentKey,
                    padding: EdgeInsetsDirectional.only(
                      bottom: scrollEndClearance,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.compact,
                      padding: VitContentPadding.compact,
                      density: VitDensity.compact,
                      children: children,
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
