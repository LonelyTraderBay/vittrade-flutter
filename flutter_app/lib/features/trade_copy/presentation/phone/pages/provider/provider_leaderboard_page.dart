import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_copy_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/entities/trade_copy_entities.dart';

part '../../../widgets/provider/provider_leaderboard_controls.dart';
part '../../../widgets/provider/provider_leaderboard_cards.dart';
part '../../../widgets/provider/provider_leaderboard_disclaimer.dart';

const _leaderPrimary = AppColors.primary;
const _leaderChip = AppColors.surface3;
const _leaderWarningBorder = AppColors.warningBorder;
const _leaderWarningText = AppColors.caution;
const double _leaderSpace = AppSpacing.x2;
const double _leaderTinySpace = AppSpacing.x1;
const double _leaderLineFlat = 1.05;
const double _leaderLineReadable = 1.24;
const double _leaderLineLoose = 1.32;

class ProviderLeaderboardPage extends ConsumerStatefulWidget {
  const ProviderLeaderboardPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc079_provider_leaderboard_content');
  static const verifiedToggleKey = Key('sc079_provider_verified_toggle');
  static Key sortKey(String id) => Key('sc079_sort_$id');
  static Key riskKey(String id) => Key('sc079_risk_$id');
  static Key providerKey(String id) => Key('sc079_provider_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ProviderLeaderboardPage> createState() =>
      _ProviderLeaderboardPageState();
}

class _ProviderLeaderboardPageState
    extends ConsumerState<ProviderLeaderboardPage> {
  late String _sortId;
  late String _riskFilterId;
  late bool _verifiedOnly;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(tradeProviderLeaderboardProvider);

    return VitTradeHubScaffold(
      title: 'Bảng xếp hạng',
      semanticLabel: 'Bảng xếp hạng provider',
      semanticIdentifier: 'SC-079',
      contentKey: ProviderLeaderboardPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      useCopyTradingInset: true,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeCopyTrading,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: [
        ...snapshotAsync.when(
          loading: () => const [VitSkeletonList()],
          error: (error, stackTrace) => [
            VitErrorState(
              title: 'Không tải được bảng xếp hạng',
              message: 'Vui lòng kiểm tra kết nối và thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(tradeProviderLeaderboardProvider),
            ),
          ],
          data: (snapshot) {
            if (!_initialized) {
              _sortId = snapshot.defaultSortId;
              _riskFilterId = snapshot.defaultRiskFilterId;
              _verifiedOnly = snapshot.defaultVerifiedOnly;
              _initialized = true;
            }

            final providers = _filteredProviders(snapshot);

            return [
              VitTradeSection(
                title: 'Disclaimer',
                child: _SurvivorshipWarning(snapshot: snapshot),
              ),
              const VitTradeComplianceSection(
                title: 'Compliance review',
                density: VitDensity.tool,
                statusPill: VitStatusPill(
                  label: 'Review required',
                  status: VitStatusPillStatus.info,
                  size: VitStatusPillSize.sm,
                ),
                items: [
                  VitTradeComplianceItem(
                    label: 'Scope',
                    value: 'Ranking, verified status, risk, drawdown',
                  ),
                  VitTradeComplianceItem(
                    label: 'Action',
                    value: 'Review before copying',
                  ),
                ],
              ),
              VitTradeSection(
                title: 'Bộ lọc',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SortTabs(
                      options: snapshot.sortOptions,
                      activeId: _sortId,
                      onChanged: (id) => setState(() => _sortId = id),
                    ),
                    _RiskFilters(
                      filters: snapshot.riskFilters,
                      activeId: _riskFilterId,
                      onChanged: (id) => setState(() => _riskFilterId = id),
                    ),
                    _VerifiedToggle(
                      label: snapshot.verifiedOnlyLabel,
                      checked: _verifiedOnly,
                      onChanged: (value) =>
                          setState(() => _verifiedOnly = value),
                    ),
                  ],
                ),
              ),
              VitTradeSection(
                title: 'Providers',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Hiển thị ${providers.length} providers',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        height: _leaderLineFlat,
                      ),
                    ),
                    for (final entry in providers.indexed) ...[
                      _ProviderRankCard(
                        rank: entry.$1 + 1,
                        provider: entry.$2,
                        onOpen: () => context.push(
                          AppRoutePaths.tradeCopyProvider(
                            entry.$2.id,
                            backPath: AppRoutePaths.tradeCopyLeaderboard,
                          ),
                        ),
                      ),
                      if (entry.$1 != providers.length - 1)
                        const SizedBox(height: AppSpacing.rowGap),
                    ],
                    _Disclaimer(text: snapshot.disclaimer),
                  ],
                ),
              ),
            ];
          },
        ),
      ],
    );
  }

  List<TradeCopyTrader> _filteredProviders(
    TradeProviderLeaderboardSnapshot snapshot,
  ) {
    final filter = snapshot.riskFilters.firstWhere(
      (item) => item.id == _riskFilterId,
      orElse: () => snapshot.riskFilters.first,
    );
    final providers = snapshot.providers.where((provider) {
      if (filter.riskLevel != null && provider.riskLevel != filter.riskLevel) {
        return false;
      }
      if (_verifiedOnly && !_isProviderVerified(provider)) return false;
      return true;
    }).toList();

    providers.sort((a, b) {
      switch (_sortId) {
        case 'sharpe':
          return b.sharpeRatio.compareTo(a.sharpeRatio);
        case 'followers':
          return b.copiers.compareTo(a.copiers);
        case 'recent':
          return (b.totalPnlPct * .3).compareTo(a.totalPnlPct * .3);
        case 'roi':
        default:
          return b.totalPnlPct.compareTo(a.totalPnlPct);
      }
    });
    return providers;
  }
}
