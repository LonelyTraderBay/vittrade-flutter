import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/earn_staking_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/widgets/staking/staking_recommendations_common.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/widgets/staking/staking_recommendations_overview.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/widgets/staking/staking_recommendations_sheet.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/widgets/staking/staking_recommendations_strategy.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_bottom_sheet.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_sheet_handle.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_error_state.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_skeleton.dart';

class StakingRecommendationsPage extends ConsumerStatefulWidget {
  const StakingRecommendationsPage({super.key, this.shellRenderMode});

  static const heroKey = StakingRecommendationsKeys.hero;
  static const profileKey = StakingRecommendationsKeys.profile;
  static const amountFieldKey = StakingRecommendationsKeys.amountField;
  static const strategyListKey = StakingRecommendationsKeys.strategyList;
  static const detailCtaKey = StakingRecommendationsKeys.detailCta;
  static const riskButtonKey = StakingRecommendationsKeys.riskButton;
  static const tipsKey = StakingRecommendationsKeys.tips;

  static Key strategyKey(String id) => StakingRecommendationsKeys.strategy(id);

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingRecommendationsPage> createState() =>
      _StakingRecommendationsPageState();
}

class _StakingRecommendationsPageState
    extends ConsumerState<StakingRecommendationsPage> {
  String _amountText = '10000';

  double get _amount => double.tryParse(_amountText) ?? 0;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(stakingRecommendationsSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Gợi ý chiến lược staking cá nhân hóa',
      semanticIdentifier: 'SC-372',
      child: Material(
        color: AppColors.bg,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnStaking),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnStaking),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () =>
                  ref.invalidate(stakingRecommendationsSnapshotProvider),
            ),
          ),
          data: (snapshot) {
            final mode = widget.shellRenderMode ?? defaultShellRenderMode();
            final bottomInset =
                (mode.usesVisualQaFrame
                    ? DeviceMetrics.bottomChrome + AppSpacing.x7
                    : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
                MediaQuery.paddingOf(context).bottom;

            return VitAutoHideHeaderScaffold(
              header: VitTopChrome(
                type: VitTopChromeType.detail,
                title: snapshot.title,
                subtitle: 'Gợi ý chiến lược — không cam kết lợi nhuận',
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: EarnSpacingTokens.earnBottomInsetPadding(
                        bottomInset,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.compact,
                        gap: VitContentGap.defaultGap,
                        children: [
                          VitCard(
                            variant: VitCardVariant.standard,
                            radius: VitCardRadius.standard,
                            padding: AppSpacing.zeroInsets,
                            child: StakingRecommendationsHeroCard(
                              snapshot: snapshot,
                            ),
                          ),
                          StakingRecommendationsProfileCard(snapshot: snapshot),
                          StakingRecommendationsAmountSimulator(
                            amountText: _amountText,
                            onAmountChanged: (value) =>
                                setState(() => _amountText = value),
                          ),
                          VitPageSection(
                            label: 'Chiến lược được Đề xuất',
                            accentColor: AppModuleAccents.earn,
                            children: [
                              Column(
                                key: StakingRecommendationsKeys.strategyList,
                                children: [
                                  for (final strategy in snapshot.strategies)
                                    StakingRecommendationsStrategyCard(
                                      key: StakingRecommendationsKeys.strategy(
                                        strategy.id,
                                      ),
                                      strategy: strategy,
                                      amount: _amount,
                                      onTap: () => _openStrategySheet(
                                        strategy,
                                        snapshot.stakingRoute,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                          VitPageSection(
                            key: StakingRecommendationsKeys.tips,
                            label: 'Tips Cá nhân hóa',
                            accentColor: AppModuleAccents.earn,
                            children: [
                              Column(
                                children: [
                                  for (final tip in snapshot.tips)
                                    StakingRecommendationsTipCard(tip: tip),
                                ],
                              ),
                            ],
                          ),
                          StakingRecommendationsDisclaimer(
                            text: snapshot.disclaimer,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _openStrategySheet(
    StakingStrategyDraft strategy,
    String stakingRoute,
  ) async {
    unawaited(HapticFeedback.selectionClick());
    await showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.86,
          child: VitSheetSurface(
            color: AppColors.surface,
            borderRadius: AppRadii.sheetTopRadius,
            padding: AppSpacing.zeroInsets,
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: EarnSpacingTokens.earnSheetContentPadding,
                child: StakingRecommendationsStrategyDetailSheet(
                  strategy: strategy,
                  amount: _amount,
                  stakingRoute: stakingRoute,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
