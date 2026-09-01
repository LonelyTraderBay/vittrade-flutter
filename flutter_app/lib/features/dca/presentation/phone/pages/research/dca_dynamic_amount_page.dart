import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/dca_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/dca_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

part 'dca_dynamic_amount_page_hero_and_strategy.dart';
part 'dca_dynamic_amount_page_history_and_config.dart';
part 'dca_dynamic_amount_page_volatility_chart.dart';
part 'dca_dynamic_amount_page_common.dart';

const double _dcaDynamicChartHeight = 144;
const EdgeInsetsDirectional _dcaDynamicHeroPadding = EdgeInsetsDirectional.all(
  AppSpacing.x4,
);
const EdgeInsetsDirectional _dcaDynamicCardPadding = EdgeInsetsDirectional.all(
  AppSpacing.x3,
);

class DCADynamicAmountPage extends ConsumerStatefulWidget {
  const DCADynamicAmountPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc175_dynamic_amount_content');
  static const applyKey = Key('sc175_apply_strategy');
  static const settingsKey = Key('sc175_dynamic_settings');

  static Key strategyKey(DcaDynamicStrategy strategy) {
    return Key('sc175_strategy_${strategy.name}');
  }

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DCADynamicAmountPage> createState() =>
      _DCADynamicAmountPageState();
}

class _DCADynamicAmountPageState extends ConsumerState<DCADynamicAmountPage> {
  DcaDynamicStrategy _activeStrategy = DcaDynamicStrategy.volatility;

  @override
  Widget build(BuildContext context) {
    final dcaDynamicAmountAsync = ref.watch(dcaDynamicAmountProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? SharedSpacingTokens.bottomNavVisualClearance
        : SharedSpacingTokens.bottomNavNativeClearance;
    final scrollEndPadding =
        navClearance + MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      semanticLabel:
          'Điều chỉnh số tiền DCA linh hoạt theo biến động thị trường',
      semanticIdentifier: 'SC-175',
      child: VitAutoHideHeaderScaffold(
        header: VitHeader(
          title: 'Dynamic Amount',
          subtitle: 'Đầu tư có kỷ luật · điều chỉnh số tiền',
          showBack: true,
          onBack: _close,
          actions: [
            VitHeaderActionItem(
              key: DCADynamicAmountPage.settingsKey,
              type: VitHeaderActionType.settings,
              onPressed: _showSettingsNotice,
            ),
          ],
        ),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: VitInsetScrollView(
            key: DCADynamicAmountPage.contentKey,
            physics: const ClampingScrollPhysics(),
            bottomInset: scrollEndPadding,
            child: VitPageContent(
              rhythm: VitPageRhythm.standard,
              padding: VitContentPadding.compact,
              density: VitDensity.compact,
              children: [
                ...dcaDynamicAmountAsync.when(
                  loading: () => const [VitSkeletonList()],
                  error: (error, stackTrace) => [
                    VitErrorState(
                      title: 'Không tải được số tiền linh hoạt',
                      message: 'Thử lại sau hoặc quay lại màn DCA.',
                      actionLabel: 'Thử lại',
                      onAction: () => ref.invalidate(dcaDynamicAmountProvider),
                    ),
                  ],
                  data: (snapshot) {
                    final activeOption = _strategyOption(
                      snapshot.strategies,
                      _activeStrategy,
                    );
                    final adjustment = _adjustmentFor(
                      _activeStrategy,
                      snapshot.adjustment,
                    );
                    return [
                      _DynamicHero(
                        option: activeOption,
                        adjustment: adjustment,
                        onChangeStrategy: _showStrategyNotice,
                      ),
                      _StrategyStrip(
                        strategies: snapshot.strategies,
                        activeStrategy: _activeStrategy,
                        onChanged: (strategy) {
                          setState(() => _activeStrategy = strategy);
                        },
                      ),
                      _StrategyVisualization(
                        strategy: _activeStrategy,
                        option: activeOption,
                        volatilityHistory: snapshot.volatilityHistory,
                      ),
                      _AmountHistoryCard(entries: snapshot.amountHistory),
                      _RecentDetailsCard(entries: snapshot.amountHistory),
                      _ConfigSection(
                        option: activeOption,
                        items: _activeStrategy == DcaDynamicStrategy.volatility
                            ? snapshot.configItems
                            : _configItemsFor(_activeStrategy),
                      ),
                      _StrategyExplainer(option: activeOption),
                    ];
                  },
                ),
                const _DynamicDisclaimer(),
                const VitHighRiskStatePanel(
                  state: VitHighRiskUiState.riskReview,
                  title: 'Xem lại chiến lược số tiền',
                  message:
                      'Áp dụng chiến lược điều chỉnh sẽ thay đổi lượng mua DCA ở các lần thực thi tiếp theo.',
                  contractId: 'SC-175',
                ),
                _ApplyStrategyAction(
                  onApply: () => context.go(AppRoutePaths.dca),
                ),
              ],
            ),
          ),
        ),
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

  void _showSettingsNotice() {
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Sắp ra mắt',
        message: 'Cài đặt số tiền linh hoạt sẽ sớm ra mắt.',
      ),
    );
  }

  void _showStrategyNotice() {
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Chọn chiến lược',
        message: 'Chọn chiến lược trong thanh bên dưới.',
      ),
    );
  }
}
