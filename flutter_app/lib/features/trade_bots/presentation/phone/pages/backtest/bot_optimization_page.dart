import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_bots_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_bots/domain/entities/trade_bots_entities.dart';

part '../../../widgets/backtest/bot_optimization_page_sections.dart';
part '../../../widgets/backtest/bot_optimization_page_common.dart';

const _optimizationBackground = AppColors.bg;
const _optimizationPrimary = AppColors.primary;

class BotOptimizationPage extends ConsumerStatefulWidget {
  const BotOptimizationPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc127_bot_optimization_content');
  static const startKey = Key('sc127_bot_optimization_start');

  static Key targetKey(String id) => Key('sc127_bot_optimization_target_$id');
  static Key rangeKey(String id) => Key('sc127_bot_optimization_range_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotOptimizationPage> createState() =>
      _BotOptimizationPageState();
}

class _BotOptimizationPageState extends ConsumerState<BotOptimizationPage> {
  String _selectedTarget = 'sharpe';
  double _gridCount = 25;
  double _gridRange = 35;
  TradeBotOptimizationResult? _lastResult;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(tradeBotOptimizationProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final shellInset = tradeScrollBottomInset(context, shellRenderMode: mode);

    return VitTradeDetailScaffold(
      title: 'Tối ưu tham số',
      subtitle: 'Tối ưu tham số chiến lược bot',
      semanticLabel: 'Tối ưu hóa tham số chiến lược bot',
      semanticIdentifier: 'SC-127',
      contentKey: BotOptimizationPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      bottomInset: AppSpacing.x3,
      activeProductId: 'bots',
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeBots,
        mode: BackNavigationMode.historyThenFallback,
      ),
      footer: Padding(
        padding: EdgeInsetsDirectional.only(bottom: shellInset),
        child: _StartFooter(onStart: () => _handleStart()),
      ),
      children: snapshotAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được dữ liệu tối ưu hóa',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradeBotOptimizationProvider),
          ),
        ],
        data: (snapshot) => [
          if (_lastResult != null) _QueuedCard(result: _lastResult!),
          VitBotSubpageHero(
            primaryLabel: 'Mục tiêu',
            primaryValue: _selectedTarget.toUpperCase(),
            secondaryLabel: 'Kết quả',
            secondaryValue: _lastResult == null ? '—' : 'Sẵn sàng',
            secondaryColor: _lastResult == null
                ? AppColors.text3
                : _optimizationPrimary,
          ),
          const VitTradeSection(title: 'Tổng quan', child: _IntroCard()),
          VitTradeSection(
            title: 'Mục tiêu tối ưu',
            child: _TargetCard(
              targets: snapshot.targets,
              selectedId: _selectedTarget,
              onChanged: (id) => setState(() => _selectedTarget = id),
            ),
          ),
          VitTradeSection(
            title: 'Khoảng tham số',
            child: _RangeCard(
              ranges: snapshot.parameterRanges,
              gridCount: _gridCount,
              gridRange: _gridRange,
              onGridCountChanged: (value) => setState(() => _gridCount = value),
              onGridRangeChanged: (value) => setState(() => _gridRange = value),
            ),
          ),
          VitTradeSection(
            title: 'Cách hoạt động',
            child: _HowItWorksCard(steps: snapshot.steps),
          ),
          const VitBotRiskReviewFooter(
            title: 'Cần xem lại tối ưu hoá',
            message:
                'Chỉ số mục tiêu, khoảng tham số, trạng thái hàng chờ, xem trước kết quả và bước hoàn tác tiếp theo được xem lại trước khi thay đổi bot.',
            contractId: 'bot-optimization-review',
            statusLabel: 'Xếp hàng chờ trước khi áp dụng',
          ),
        ],
      ),
    );
  }

  Future<void> _handleStart() async {
    final result = await ref
        .read(tradeBotAnalyticsRepositoryProvider)
        .runBotOptimization(
          TradeBotOptimizationRequest(
            targetId: _selectedTarget,
            gridCount: _gridCount,
            gridRangePct: _gridRange,
          ),
        );
    if (!mounted) return;
    setState(() => _lastResult = result);
  }
}
