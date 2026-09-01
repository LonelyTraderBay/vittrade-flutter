import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_bots_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_bots/domain/entities/trade_bots_entities.dart';

part '../../../widgets/dashboard/bot_risk_dashboard_score.dart';
part '../../../widgets/dashboard/bot_risk_dashboard_metrics.dart';
part '../../../widgets/dashboard/bot_risk_dashboard_charts.dart';
part '../../../widgets/dashboard/bot_risk_dashboard_controls.dart';

const _riskPrimary = AppColors.primary;
const _riskGreen = AppColors.buy;
const _riskAmber = AppColors.caution;
const _riskRed = AppColors.sell;
const _riskPurple = AppColors.accent;
const _riskTrack = AppColors.chartTrackRisk;
const double _riskRingSize = 64;

class BotRiskDashboardPage extends ConsumerStatefulWidget {
  const BotRiskDashboardPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc120_bot_risk_dashboard_content');
  static const emergencyHeaderKey = Key('sc120_bot_risk_header_emergency');
  static const emergencyButtonKey = Key('sc120_bot_risk_emergency_button');
  static const historyCtaKey = Key('sc120_bot_risk_history_cta');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotRiskDashboardPage> createState() =>
      _BotRiskDashboardPageState();
}

class _BotRiskDashboardPageState extends ConsumerState<BotRiskDashboardPage>
    with SingleTickerProviderStateMixin {
  bool _explanationOpen = false;
  late final AnimationController _revealController;

  @override
  void initState() {
    super.initState();
    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    unawaited(_revealController.forward());
  }

  @override
  void dispose() {
    _revealController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(tradeBotRiskDashboardProvider);

    return VitTradeHubScaffold(
      title: 'Bảng điều khiển rủi ro',
      subtitle: 'Giám sát rủi ro bot theo thời gian thực',
      semanticLabel: 'Bảng giám sát rủi ro bot theo thời gian thực',
      semanticIdentifier: 'SC-120',
      contentKey: BotRiskDashboardPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      activeProductId: 'bots',
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeBots,
        mode: BackNavigationMode.historyThenFallback,
      ),
      headerActions: [
        VitHeaderActionItem(
          key: BotRiskDashboardPage.emergencyHeaderKey,
          type: VitHeaderActionType.emergency,
          onPressed: () {
            final path = snapshotAsync.value?.emergencyPath;
            if (path != null) context.go(path);
          },
        ),
      ],
      children: snapshotAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được bảng rủi ro',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradeBotRiskDashboardProvider),
          ),
        ],
        data: (snapshot) => [
          _RiskOpening(snapshot: snapshot, reveal: _revealController),
          VitTradeSection(
            title: 'Chỉ số quan trọng',
            child: _CriticalMetricsGrid(snapshot: snapshot),
          ),
          VitTradeSection(
            title: 'Xu hướng sụt giảm vốn (24h)',
            child: _DrawdownChartCard(
              points: snapshot.drawdownPoints,
              limit: snapshot.maxDrawdownLimit,
            ),
          ),
          VitTradeSection(
            title: 'Mức phơi nhiễm theo tài sản',
            child: _ExposureCard(exposures: snapshot.exposures),
          ),
          VitTradeSection(
            title: 'Xu hướng VaR (7 ngày)',
            child: _VarChartCard(points: snapshot.varHistory),
          ),
          VitTradeSection(
            title: 'Biện pháp an toàn',
            child: _SafetyControlsCard(controls: snapshot.safetyControls),
          ),
          VitTradeSection(
            title: 'Hành động khẩn cấp',
            child: _EmergencyActionCard(
              runningBots: snapshot.runningBots,
              onTap: () => context.go(snapshot.emergencyPath),
            ),
          ),
          VitCtaButton(
            key: BotRiskDashboardPage.historyCtaKey,
            density: VitDensity.tool,
            height: TradeSpacingTokens.tradeBotSheetActionHeight,
            variant: VitCtaButtonVariant.secondary,
            onPressed: () => context.go(AppRoutePaths.tradeBotHistory),
            child: const Text('Xem lịch sử lệnh'),
          ),
          VitTradeSection(
            title: 'Giải thích rủi ro',
            child: _RiskExplanationCard(
              expanded: _explanationOpen,
              onToggle: () =>
                  setState(() => _explanationOpen = !_explanationOpen),
            ),
          ),
          const VitBotRiskReviewFooter(
            title: 'Xem lại bảng điều khiển rủi ro',
            message:
                'Điểm rủi ro, chỉ số quan trọng, mức phơi nhiễm, xu hướng VaR, biện pháp an toàn và bước dừng khẩn cấp tiếp theo được xem lại trước khi thực hiện hành động rủi ro với bot.',
            contractId: 'bot-risk-dashboard-review',
            statusLabel: 'Đã xác nhận lối thoát khẩn cấp',
            status: VitStatusPillStatus.warning,
          ),
        ],
      ),
    );
  }
}

class _RiskOpening extends StatelessWidget {
  const _RiskOpening({required this.snapshot, required this.reveal});

  final TradeBotRiskDashboardSnapshot snapshot;
  final Animation<double> reveal;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(snapshot.riskScore);
    final headroom =
        (snapshot.maxDrawdownLimit.abs() - snapshot.currentDrawdown.abs())
            .clamp(0, 100);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitBotSubpageHero(
          primaryLabel: 'Điểm rủi ro',
          primaryValue: '${snapshot.riskScore}',
          primaryColor: color,
          secondaryLabel: 'Bot đang chạy',
          secondaryValue: '${snapshot.runningBots}',
          secondaryColor: _riskGreen,
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Wrap(
          spacing: TradeSpacingTokens.tradeBotInlineIconGap,
          runSpacing: TradeSpacingTokens.tradeBotTinyGap,
          children: [
            VitStatusPill(
              label: snapshot.riskLabel,
              status: snapshot.riskScore < 40
                  ? VitStatusPillStatus.success
                  : snapshot.riskScore < 70
                  ? VitStatusPillStatus.warning
                  : VitStatusPillStatus.error,
              size: VitStatusPillSize.sm,
            ),
            VitAccentPill(
              label: 'Còn ${headroom.toStringAsFixed(1)}% tới hạn drawdown',
              accentColor: color,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        _RiskScoreCard(snapshot: snapshot, reveal: reveal),
      ],
    );
  }
}

Color _riskColor(int score) {
  if (score < 40) return _riskGreen;
  if (score < 70) return _riskAmber;
  return _riskRed;
}

String _formatSignedMoney(double value) => VitFormat.usdWholeSigned(value);

String _formatMoney(double value) => VitFormat.usdWhole(value);
