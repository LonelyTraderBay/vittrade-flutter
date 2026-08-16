import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_copy_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/widgets/provider/trader_profile_chart_painters.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_analytics_hero.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_detail_hero.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/entities/trade_copy_entities.dart';

part '../../../widgets/provider/trader_profile_overview.dart';
part '../../../widgets/provider/trader_profile_trades.dart';
part '../../../widgets/provider/trader_profile_stats_common.dart';

const _profilePrimary = AppColors.primary;
const _profileGreen = AppColors.buy;
const _profileAmber = AppColors.caution;
const _profileRed = AppColors.sell;

class TraderProfilePage extends ConsumerStatefulWidget {
  const TraderProfilePage({
    super.key,
    required this.traderId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc087_trader_profile_content');
  static const copyButtonKey = Key('sc087_trader_profile_copy');
  static Key tabKey(String id) => Key('sc087_trader_profile_tab_$id');

  final String traderId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<TraderProfilePage> createState() => _TraderProfilePageState();
}

class _TraderProfilePageState extends ConsumerState<TraderProfilePage> {
  String _tab = 'overview';
  bool _isFollowing = false;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(
      tradeTraderProfileProvider(widget.traderId),
    );

    return VitTradeHubScaffold(
      title: 'Hồ sơ trader',
      subtitle: 'Sao chép giao dịch',
      semanticLabel: 'Hồ sơ trader',
      semanticIdentifier: 'SC-087',
      contentKey: TraderProfilePage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      activeProductId: 'copy',
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.trade,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: [
        ...snapshotAsync.when(
          loading: () => const [VitSkeletonList()],
          error: (error, stackTrace) => [
            VitErrorState(
              title: 'Không tải được hồ sơ trader',
              message: 'Vui lòng kiểm tra kết nối và thử lại.',
              actionLabel: 'Thử lại',
              onAction: () =>
                  ref.invalidate(tradeTraderProfileProvider(widget.traderId)),
            ),
          ],
          data: (snapshot) => _buildBody(snapshot),
        ),
      ],
    );
  }

  List<Widget> _buildBody(TradeTraderProfileSnapshot snapshot) {
    final trader = snapshot.trader;
    final risk = _riskPresentation(trader.riskLevel);

    return [
      VitTradeDetailHero(
        borderColor: _profilePrimary.withValues(alpha: .25),
        avatar: VitAssetAvatar(
          label: trader.avatar,
          accentColor: _profilePrimary,
          size: TradeSpacingTokens.traderProfileAvatarSize,
          radius: AppRadii.cardRadius,
          border: true,
        ),
        identityTitle: trader.name,
        identityTrailing: _isFollowing
            ? const Icon(
                Icons.star_rounded,
                color: _profileAmber,
                size: TradeSpacingTokens.traderProfileActionIcon,
              )
            : null,
        tags: [
          for (final tag in trader.tags)
            VitAccentPill(label: tag, accentColor: AppColors.text2),
          VitAccentPill(
            label: 'Rủi ro: ${risk.label}',
            accentColor: risk.color,
          ),
        ],
        stats: [
          VitTradeAnalyticsStat(
            label: 'Tổng ROI',
            value: '+${trader.totalPnlPct.toStringAsFixed(1)}%',
            color: _profileGreen,
          ),
          VitTradeAnalyticsStat(
            label: 'Win Rate',
            value: '${trader.winRate.toStringAsFixed(1)}%',
            color: _profileGreen,
          ),
          VitTradeAnalyticsStat(
            label: 'Sharpe',
            value: trader.sharpeRatio.toStringAsFixed(2),
            color: _profileAmber,
          ),
          VitTradeAnalyticsStat(
            label: 'MDD',
            value: '${trader.maxDrawdown.toStringAsFixed(1)}%',
            color: _profileRed,
          ),
        ],
        progressValue: (trader.copiers / trader.maxCopiers).clamp(0, 1),
        progressColor: _profilePrimary,
        progressLeadingLabel:
            'Copiers: ${trader.copiers} / ${trader.maxCopiers}',
        progressTrailingLabel:
            '${trader.maxCopiers - trader.copiers} slots trống',
        ctaKey: TraderProfilePage.copyButtonKey,
        ctaLabel: _isFollowing ? 'Hủy theo dõi' : 'Copy Trader này',
        ctaLeading: Icon(
          _isFollowing
              ? Icons.warning_amber_rounded
              : Icons.content_copy_rounded,
          size: TradeSpacingTokens.traderProfileActionIcon,
        ),
        ctaVariant: _isFollowing
            ? VitCtaButtonVariant.destructive
            : VitCtaButtonVariant.primary,
        onCtaPressed: () => setState(() => _isFollowing = !_isFollowing),
      ),
      VitTradeSection(
        title: 'Rủi ro & phù hợp',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              density: VitDensity.tool,
              title: 'Xem lại hồ sơ trader',
              message:
                  'Hiệu suất, giao dịch gần đây, thống kê, lịch sử rủi ro và mức phù hợp copy được xem lại trước khi theo dõi.',
              contractId: 'trader-profile-${widget.traderId}',
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            const VitStatusPill(
              label: 'Hiệu suất trước không đảm bảo tương lai',
              status: VitStatusPillStatus.warning,
              size: VitStatusPillSize.sm,
            ),
          ],
        ),
      ),
      _SegmentTabs(
        activeId: _tab,
        tabs: const [
          _TraderTab(id: 'overview', label: 'Tổng quan'),
          _TraderTab(id: 'trades', label: 'Giao dịch'),
          _TraderTab(id: 'stats', label: 'Thống kê'),
        ],
        onChanged: (id) => setState(() => _tab = id),
      ),
      VitPageSection(
        density: VitDensity.tool,
        children: [
          if (_tab == 'overview')
            _OverviewTab(snapshot: snapshot)
          else if (_tab == 'trades')
            _TradesTab(trades: snapshot.recentTrades)
          else
            _StatsTab(trader: trader),
        ],
      ),
    ];
  }
}
