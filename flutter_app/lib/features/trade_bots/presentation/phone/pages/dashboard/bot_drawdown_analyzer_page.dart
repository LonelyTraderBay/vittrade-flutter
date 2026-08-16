import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_bots_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_bots/domain/entities/trade_bots_entities.dart';

part '../../../widgets/dashboard/bot_drawdown_analyzer_page_sections.dart';
part '../../../widgets/dashboard/bot_drawdown_analyzer_page_common.dart';

const _drawdownRed = AppColors.sell;
const _drawdownAmber = AppColors.caution;
const _drawdownGreen = AppColors.buy;
const _drawdownPrimary = AppColors.primary;
const _drawdownAxis = AppColors.chartAxisStrong;
const double _drawdownUnderwaterExtent =
    AppSpacing.buttonStandard * 3 + AppSpacing.x2;
const double _drawdownDurationExtent =
    AppSpacing.buttonStandard * 2 + AppSpacing.x5;

class BotDrawdownAnalyzerPage extends ConsumerWidget {
  const BotDrawdownAnalyzerPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc129_bot_drawdown_analyzer_content');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeBotDrawdownAnalyzerProvider);
    return VitTradeHubScaffold(
      title: 'Phân tích sụt giảm vốn',
      subtitle: 'Phân tích độ sụt giảm vốn bot',
      semanticLabel: 'Phân tích mức sụt giảm vốn của bot',
      semanticIdentifier: 'SC-129',
      contentKey: BotDrawdownAnalyzerPage.contentKey,
      shellRenderMode: shellRenderMode,
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
            title: 'Không tải được phân tích sụt giảm',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradeBotDrawdownAnalyzerProvider),
          ),
        ],
        data: (snapshot) => [
          VitBotSubpageHero(
            primaryLabel: 'Sụt tối đa',
            primaryValue:
                '-${snapshot.summary.maxDrawdownPct.toStringAsFixed(1)}%',
            primaryColor: _drawdownRed,
            secondaryLabel: 'Ngày sụt',
            secondaryValue: '${snapshot.summary.drawdownDays}',
            secondaryColor: _drawdownAmber,
          ),
          VitTradeSection(
            title: 'Chỉ số',
            child: _MetricGrid(summary: snapshot.summary),
          ),
          VitTradeSection(
            title: 'Vốn trong giai đoạn sụt giảm',
            child: _UnderwaterCard(points: snapshot.underwaterPoints),
          ),
          VitTradeSection(
            title: 'Phân bố thời gian sụt giảm vốn',
            child: _DurationCard(buckets: snapshot.durationBuckets),
          ),
          VitTradeSection(
            title: 'Các đợt sụt giảm vốn lớn',
            child: _EventsList(events: snapshot.events),
          ),
          VitTradeSection(
            title: 'Phân tích',
            child: _AnalysisCard(insights: snapshot.insights),
          ),
          const VitBotRiskReviewFooter(
            title: 'Xem lại mức sụt giảm vốn',
            message:
                'Chỉ số đỉnh-đáy, phân bố thời lượng, bằng chứng sự kiện và bước giảm thiểu tiếp theo được xem lại trước khi thay đổi chiến lược.',
            contractId: 'bot-drawdown-review',
          ),
        ],
      ),
    );
  }
}
