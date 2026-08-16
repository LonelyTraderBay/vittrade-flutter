import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

part '../../../widgets/phone/launchpad_portfolio_hero_tabs.dart';
part '../../../widgets/phone/launchpad_portfolio_subscription.dart';
part '../../../widgets/phone/launchpad_portfolio_empty_disclaimer_common.dart';

const double _launchpadPortfolioLineHeightLabel =
    LaunchpadSpacingTokens.launchpadLineHeightLabel;
const double _launchpadPortfolioLineHeightDense =
    LaunchpadSpacingTokens.launchpadLineHeightDense;

class LaunchpadPortfolioPage extends ConsumerStatefulWidget {
  const LaunchpadPortfolioPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc296_launchpad_portfolio_content');
  static const heroKey = Key('sc296_launchpad_portfolio_hero');
  static const tabsKey = Key('sc296_launchpad_portfolio_tabs');
  static const disclaimerKey = Key('sc296_launchpad_portfolio_disclaimer');

  static Key tabKey(String id) => Key('sc296_launchpad_portfolio_tab_$id');
  static Key subscriptionKey(String id) =>
      Key('sc296_launchpad_portfolio_subscription_$id');
  static Key claimKey(String id) => Key('sc296_launchpad_portfolio_claim_$id');
  static Key refundKey(String id) =>
      Key('sc296_launchpad_portfolio_refund_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadPortfolioPage> createState() =>
      _LaunchpadPortfolioPageState();
}

class _LaunchpadPortfolioPageState
    extends ConsumerState<LaunchpadPortfolioPage> {
  var _activeTab = _PortfolioTab.all;

  @override
  Widget build(BuildContext context) {
    final portfolioAsync = ref.watch(launchpadPortfolioSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? SharedSpacingTokens.bottomNavVisualClearance
        : SharedSpacingTokens.bottomNavNativeClearance;
    final scrollEndPadding =
        navClearance + MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Danh mục dự án Launchpad đã tham gia',
      semanticIdentifier: 'SC-296',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          semanticLabel: 'Danh mục dự án Launchpad – vùng cuộn nội dung',
          semanticIdentifier: 'SC-296',
          header: VitHeader(
            title: 'Danh mục Launchpad',
            subtitle: 'Các dự án đã tham gia',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.launchpad),
          ),
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              key: LaunchpadPortfolioPage.contentKey,
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsetsDirectional.only(bottom: scrollEndPadding),
              child: VitPageContent(
                rhythm: VitPageRhythm.standard,
                padding: VitContentPadding.compact,
                density: VitDensity.compact,
                children: [
                  ...portfolioAsync.when(
                    loading: () => const [VitSkeletonList()],
                    error: (error, stackTrace) => [
                      VitErrorState(
                        title: 'Không tải được danh mục',
                        message: 'Vui lòng kiểm tra kết nối và thử lại.',
                        actionLabel: 'Thử lại',
                        onAction: () =>
                            ref.invalidate(launchpadPortfolioSnapshotProvider),
                      ),
                    ],
                    data: (snapshot) {
                      final subscriptions = _subscriptionsFor(
                        snapshot.subscriptions,
                        _activeTab,
                      );
                      return [
                        _PortfolioHero(subscriptions: snapshot.subscriptions),
                        _PortfolioTabs(
                          activeTab: _activeTab,
                          onChanged: (tab) => setState(() => _activeTab = tab),
                        ),
                        if (subscriptions.isEmpty)
                          _EmptyPortfolio(
                            route: snapshot.launchpadRoute,
                            filtered: _activeTab != _PortfolioTab.all,
                            onShowAll: () =>
                                setState(() => _activeTab = _PortfolioTab.all),
                          )
                        else
                          for (final subscription in subscriptions)
                            _SubscriptionCard(
                              subscription: subscription,
                              receiptRoute: snapshot.receiptRoute,
                            ),
                        const _PortfolioDisclaimer(),
                      ];
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
