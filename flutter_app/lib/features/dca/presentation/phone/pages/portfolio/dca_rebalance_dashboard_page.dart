import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/dca_controller_providers.dart';
import 'package:vit_trade_flutter/features/dca/presentation/widgets/dca_missing_config_panel.dart';

class DCARebalanceDashboardPage extends ConsumerWidget {
  const DCARebalanceDashboardPage({
    super.key,
    required this.configId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc171_rebalance_dashboard_content');
  static const missingConfigKey = Key('sc171_missing_config');
  static const configureKey = Key('sc171_configure_rebalance');

  final String configId;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rebalanceDashboardAsync = ref.watch(
      dcaRebalanceDashboardProvider(configId),
    );
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? SharedSpacingTokens.bottomNavVisualClearance
        : SharedSpacingTokens.bottomNavNativeClearance;
    final scrollEndPadding =
        navClearance + MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Bảng điều khiển cân bằng lại danh mục DCA',
      semanticIdentifier: 'SC-171',
      child: VitAutoHideHeaderScaffold(
        header: VitTopChrome(
          type: VitTopChromeType.detail,
          title: 'Rebalance Dashboard',
          subtitle: 'Đầu tư có kỷ luật · cân bằng danh mục',
          showBack: true,
          onBack: () => _close(context),
        ),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: VitInsetScrollView(
            key: contentKey,
            physics: const ClampingScrollPhysics(),
            bottomInset: scrollEndPadding,
            child: VitPageContent(
              rhythm: VitPageRhythm.standard,
              padding: VitContentPadding.compact,
              density: VitDensity.compact,
              children: [
                ...rebalanceDashboardAsync.when(
                  loading: () => const [VitSkeletonList()],
                  error: (error, stackTrace) => [
                    VitErrorState(
                      title: 'Không tải được bảng cân bằng danh mục',
                      message: 'Thử lại sau hoặc quay lại màn DCA.',
                      actionLabel: 'Thử lại',
                      onAction: () => ref.invalidate(
                        dcaRebalanceDashboardProvider(configId),
                      ),
                    ),
                  ],
                  data: (snapshot) => [
                    if (!snapshot.configFound)
                      DcaMissingConfigPanel(
                        icon: Icons.pie_chart_outline_rounded,
                        title: snapshot.message,
                        titleKey: DCARebalanceDashboardPage.missingConfigKey,
                        subtitle:
                            'Chưa có cấu hình cân bằng danh mục. Thiết lập tỷ lệ mục tiêu và ngưỡng drift trước khi xem lịch sử thực thi.',
                        ctaLabel: 'Thiết lập cân bằng',
                        ctaIcon: Icons.tune_rounded,
                        ctaKey: DCARebalanceDashboardPage.configureKey,
                        onConfigure: () =>
                            context.go(AppRoutePaths.dcaRebalanceConfig),
                      )
                    else
                      VitPageSection(
                        label: 'Lịch sử cân bằng',
                        accentColor: AppModuleAccents.dca,
                        children: [
                          VitCard(
                            density: VitDensity.compact,
                            child: Text(
                              snapshot.message,
                              style: AppTextStyles.base.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.medium,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                const VitHighRiskStatePanel(
                  state: VitHighRiskUiState.riskReview,
                  title: 'Rebalance review required',
                  message:
                      'Rebalance changes can move funds between assets. Show allocation delta, fees, limits, and confirmation before execution.',
                  contractId: 'SC-171',
                  density: VitDensity.compact,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _close(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.dca);
  }
}
