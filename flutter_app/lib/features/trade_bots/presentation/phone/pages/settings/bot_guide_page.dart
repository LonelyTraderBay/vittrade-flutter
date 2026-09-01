import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_bots_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_bots/domain/entities/trade_bots_entities.dart';

part '../../../widgets/settings/bot_guide_intro_tabs.dart';
part '../../../widgets/settings/bot_guide_strategies.dart';
part '../../../widgets/settings/bot_guide_blocks.dart';
part '../../../widgets/settings/bot_guide_practices_videos.dart';
part '../../../widgets/settings/bot_guide_common.dart';

const _guidePrimary = AppColors.primary;
const _guideGreen = AppColors.buy;
const _guideRed = AppColors.sell;

class BotGuidePage extends ConsumerStatefulWidget {
  const BotGuidePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc131_bot_guide_content');
  static Key tabKey(String id) => Key('sc131_bot_guide_tab_$id');
  static Key strategyKey(String id) => Key('sc131_bot_guide_strategy_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotGuidePage> createState() => _BotGuidePageState();
}

class _BotGuidePageState extends ConsumerState<BotGuidePage> {
  String _view = 'strategies';
  String? _expandedStrategyId;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(tradeBotGuideProvider);
    return VitTradeHubScaffold(
      title: 'Hướng dẫn Bot giao dịch',
      subtitle: 'Hướng dẫn chiến lược và thực hành bot',
      semanticLabel: 'Hướng dẫn sử dụng bot giao dịch',
      semanticIdentifier: 'SC-131',
      contentKey: BotGuidePage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      activeProductId: 'bots',
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeBots,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: snapshotAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được hướng dẫn bot',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradeBotGuideProvider),
          ),
        ],
        data: (snapshot) => [
          VitBotSubpageHero(
            primaryLabel: 'Chiến lược',
            primaryValue: '${snapshot.strategies.length}',
            secondaryLabel: 'Thực hành',
            secondaryValue: '${snapshot.bestPractices.length}',
          ),
          const VitTradeSection(title: 'Tổng quan', child: _IntroBanner()),
          VitTradeSection(
            title: 'Chủ đề',
            child: VitTabBar(
              tabs: [
                VitTabItem(
                  key: 'strategies',
                  label: 'Chiến lược',
                  widgetKey: BotGuidePage.tabKey('strategies'),
                ),
                VitTabItem(
                  key: 'best-practices',
                  label: 'Thực hành',
                  widgetKey: BotGuidePage.tabKey('best-practices'),
                ),
                VitTabItem(
                  key: 'mistakes',
                  label: 'Sai lầm',
                  widgetKey: BotGuidePage.tabKey('mistakes'),
                ),
              ],
              activeKey: _view,
              onChanged: _setView,
              variant: VitTabBarVariant.pill,
            ),
          ),
          VitTradeSection(
            title: _view == 'strategies'
                ? 'Strategies'
                : _view == 'best-practices'
                ? 'Best practices'
                : 'Common mistakes',
            child: _view == 'strategies'
                ? _StrategiesView(
                    strategies: snapshot.strategies,
                    expandedStrategyId: _expandedStrategyId,
                    onToggle: _toggleStrategy,
                  )
                : _view == 'best-practices'
                ? _BestPracticesView(items: snapshot.bestPractices)
                : _MistakesView(items: snapshot.mistakes),
          ),
          const VitTradeSection(
            title: 'Video hướng dẫn',
            child: _VideoTutorialsCard(),
          ),
          const VitBotRiskReviewFooter(
            title: 'Xem lại nội dung giáo dục Bot',
            message:
                'Loại chiến lược, rủi ro thiết lập, giới hạn vận hành, lỗi thường gặp và bước tiếp theo được xem lại trước khi kích hoạt bot.',
            contractId: 'bot-guide-review',
            statusLabel: 'Học trước khi kích hoạt',
            status: VitStatusPillStatus.warning,
          ),
        ],
      ),
    );
  }

  void _setView(String view) {
    setState(() {
      _view = view;
      _expandedStrategyId = null;
    });
  }

  void _toggleStrategy(String strategyId) {
    setState(() {
      _expandedStrategyId = _expandedStrategyId == strategyId
          ? null
          : strategyId;
    });
  }
}
