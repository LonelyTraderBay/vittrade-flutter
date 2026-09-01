import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_savings_controller_providers.dart';
import 'package:vit_trade_flutter/features/earn_core/presentation/widgets/earn_custody_risk_banner.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

part '../../../widgets/savings/savings_recommendations_hero.dart';
part '../../../widgets/savings/savings_recommendations_amount_panel.dart';
part '../../../widgets/savings/savings_recommendations_strategy_card.dart';
part '../../../widgets/savings/savings_recommendations_insights.dart';
part '../../../widgets/savings/savings_recommendations_strategy_detail_sheet.dart';
part '../../../widgets/savings/savings_recommendations_compare_sheet.dart';
part '../../../widgets/savings/savings_recommendations_shared.dart';

class SavingsRecommendationsPage extends ConsumerStatefulWidget {
  const SavingsRecommendationsPage({super.key, this.shellRenderMode});

  static const amountFieldKey = Key('sc338_amount_field');
  static const strategyListKey = Key('sc338_strategy_list');
  static const compareButtonKey = Key('sc338_compare_button');
  static const riskButtonKey = Key('sc338_risk_button');
  static const productsButtonKey = Key('sc338_products_button');
  static const detailCtaKey = Key('sc338_strategy_detail_cta');

  static Key strategyKey(String id) => Key('sc338_strategy_$id');
  static Key amountChipKey(int amount) => Key('sc338_amount_$amount');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsRecommendationsPage> createState() =>
      _SavingsRecommendationsPageState();
}

class _SavingsRecommendationsPageState
    extends ConsumerState<SavingsRecommendationsPage> {
  String _amountText = '15000';
  late final TextEditingController _amountController;

  double get _amount => double.tryParse(_amountText) ?? 0;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: _amountText);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(savingsRecommendationsSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Gợi ý Tiết kiệm',
      semanticIdentifier: 'SC-338',
      child: Material(
        color: AppColors.bg,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnStaking),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnStaking),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () =>
                  ref.invalidate(savingsRecommendationsSnapshotProvider),
            ),
          ),
          data: (snapshot) {
            final mode = widget.shellRenderMode ?? defaultShellRenderMode();
            final scrollEndPadding =
                (mode.usesVisualQaFrame
                    ? SharedSpacingTokens.bottomNavVisualClearance
                    : SharedSpacingTokens.bottomNavNativeClearance) +
                MediaQuery.paddingOf(context).bottom;

            return VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: snapshot.title,
                subtitle: kSavingsToolsHeaderSubtitle,
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: EdgeInsetsDirectional.only(
                        bottom: scrollEndPadding,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.compact,
                        gap: VitContentGap.defaultGap,
                        children: [
                          _HeroCard(snapshot: snapshot),
                          _ProfileCard(snapshot: snapshot),
                          _AmountSimulator(
                            controller: _amountController,
                            amountText: _amountText,
                            onAmountChanged: (value) =>
                                setState(() => _amountText = value),
                            onQuickAmount: (value) {
                              unawaited(HapticFeedback.selectionClick());
                              _setAmountText('$value');
                            },
                          ),
                          _CompareButton(
                            onTap: () => _openCompareSheet(snapshot.strategies),
                          ),
                          VitPageSection(
                            label: 'Chiến lược được Đề xuất',
                            accentColor: AppColors.accent,
                            children: [
                              Column(
                                key: SavingsRecommendationsPage.strategyListKey,
                                children: [
                                  for (final strategy in snapshot.strategies)
                                    _StrategyCard(
                                      key:
                                          SavingsRecommendationsPage.strategyKey(
                                            strategy.id,
                                          ),
                                      strategy: strategy,
                                      amount: _amount,
                                      onTap: () => _openStrategySheet(
                                        strategy,
                                        snapshot.savingsRoute,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                          VitPageSection(
                            label: 'Gợi ý Cá nhân hóa',
                            accentColor: AppColors.buy,
                            children: [
                              Column(
                                children: [
                                  for (final insight in snapshot.insights)
                                    _InsightCard(insight: insight),
                                ],
                              ),
                            ],
                          ),
                          _QuickLinks(snapshot: snapshot),
                          const SavingsToolsYieldFooter(),
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

  void _setAmountText(String value) {
    _amountController.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
    setState(() => _amountText = value);
  }

  Future<void> _openStrategySheet(
    SavingsStrategyDraft strategy,
    String savingsRoute,
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
            borderRadius: AppRadii.sheetTopLargeRadius,
            padding: AppSpacing.zeroInsets,
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: EarnSpacingTokens.earnSheetContentPadding,
                child: _StrategyDetailSheet(
                  strategy: strategy,
                  amount: _amount,
                  savingsRoute: savingsRoute,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _openCompareSheet(List<SavingsStrategyDraft> strategies) async {
    unawaited(HapticFeedback.selectionClick());
    await showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.72,
          child: VitSheetSurface(
            color: AppColors.surface,
            borderRadius: AppRadii.sheetTopLargeRadius,
            padding: AppSpacing.zeroInsets,
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: EarnSpacingTokens.earnSheetContentPadding,
                child: _CompareSheet(strategies: strategies, amount: _amount),
              ),
            ),
          ),
        );
      },
    );
  }
}
