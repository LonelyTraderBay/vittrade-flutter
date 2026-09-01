import 'dart:math' as math;

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
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_bots/domain/entities/trade_bots_entities.dart';

part '../../../widgets/dashboard/bot_portfolio_dashboard_page_sections.dart';
part '../../../widgets/dashboard/bot_portfolio_dashboard_page_common.dart';

const _portfolioPrimary = AppColors.primary;
const _portfolioGreen = AppColors.buy;
const _portfolioAmber = AppColors.caution;
const _portfolioRed = AppColors.sell;
const _portfolioAxis = AppColors.chartAxisStrong;

class BotPortfolioDashboardPage extends ConsumerWidget {
  const BotPortfolioDashboardPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc128_bot_portfolio_dashboard_content');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeBotPortfolioDashboardProvider);
    return VitTradeHubScaffold(
      title: 'Bảng điều khiển danh mục',
      subtitle: 'Tổng quan danh mục bot đang chạy',
      semanticLabel: 'Bảng điều khiển danh mục bot',
      semanticIdentifier: 'SC-128',
      contentKey: BotPortfolioDashboardPage.contentKey,
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
            title: 'Không tải được bảng danh mục',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradeBotPortfolioDashboardProvider),
          ),
        ],
        data: (snapshot) => [
          VitBotSubpageHero(
            primaryLabel: 'Tổng vốn',
            primaryValue:
                '\$${snapshot.summary.totalEquity.toStringAsFixed(0)}',
            secondaryLabel: 'Bot hoạt động',
            secondaryValue: '${snapshot.summary.activeBots}',
            secondaryColor: _portfolioGreen,
          ),
          VitTradeSection(
            title: 'Tổng quan',
            child: _SummaryGrid(summary: snapshot.summary),
          ),
          VitTradeSection(
            title: 'Đường cong vốn danh mục',
            child: _EquityCard(points: snapshot.equityPoints),
          ),
          VitTradeSection(
            title: 'Chi tiết phân bổ',
            child: _AllocationCard(allocations: snapshot.allocations),
          ),
          VitTradeSection(
            title: 'Ma trận tương quan bot',
            child: _CorrelationCard(rows: snapshot.correlations),
          ),
          VitTradeSection(
            title: 'Sức khoẻ danh mục',
            child: _HealthCard(items: snapshot.healthItems),
          ),
          const VitBotRiskReviewFooter(
            title: 'Xem lại rủi ro danh mục',
            message:
                'Đường cong vốn, mức tập trung phân bổ, áp lực tương quan và bước xử lý sức khoẻ danh mục tiếp theo được xem lại trước khi thay đổi danh mục.',
            contractId: 'bot-portfolio-review',
          ),
        ],
      ),
    );
  }
}
