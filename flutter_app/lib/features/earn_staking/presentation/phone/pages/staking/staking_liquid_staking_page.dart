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
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_staking_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

part '../../../widgets/staking/staking_liquid_staking_common.dart';
part '../../../widgets/staking/staking_liquid_staking_stake.dart';
part '../../../widgets/staking/staking_liquid_staking_swap.dart';
part '../../../widgets/staking/staking_liquid_staking_swap_fields.dart';
part '../../../widgets/staking/staking_liquid_staking_holdings.dart';
part '../../../widgets/staking/staking_liquid_staking_benefits.dart';
part '../../../widgets/staking/staking_liquid_staking_detail_sheet.dart';

enum _LiquidTab { stake, swap, holdings }

class StakingLiquidStakingPage extends ConsumerStatefulWidget {
  const StakingLiquidStakingPage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc364_info_banner');
  static const tabsKey = Key('sc364_tabs');
  static const detailSheetKey = Key('sc364_detail_sheet');
  static const swapCardKey = Key('sc364_swap_card');
  static const swapAmountKey = Key('sc364_swap_amount');
  static const swapSummaryKey = Key('sc364_swap_summary');
  static const holdingsKey = Key('sc364_holdings');
  static const emptyKey = Key('sc364_empty_holdings');
  static const benefitsKey = Key('sc364_benefits');

  static Key tabKey(String id) => Key('sc364_tab_$id');

  static Key tokenKey(String id) => Key('sc364_token_$id');

  static Key detailButtonKey(String id) => Key('sc364_detail_$id');

  static Key stakeButtonKey(String id) => Key('sc364_stake_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingLiquidStakingPage> createState() =>
      _StakingLiquidStakingPageState();
}

class _StakingLiquidStakingPageState
    extends ConsumerState<StakingLiquidStakingPage> {
  final _swapAmountController = TextEditingController();
  _LiquidTab _tab = _LiquidTab.stake;
  String _swapFrom = 'stETH';
  String _swapTo = 'ETH';

  @override
  void dispose() {
    _swapAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(stakingLiquidStakingSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel:
          'Về Liquid Staking — stake, hoán đổi và quản lý token thanh khoản',
      semanticIdentifier: 'SC-364',
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
                  ref.invalidate(stakingLiquidStakingSnapshotProvider),
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
                subtitle: snapshot.infoTitle,
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: AppSpacing.zeroInsets.copyWith(
                        bottom: bottomInset,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.compact,
                        gap: VitContentGap.defaultGap,
                        children: [
                          VitInfoCallout(
                            key: StakingLiquidStakingPage.infoKey,
                            message: snapshot.infoBody,
                            icon: Icons.water_drop_outlined,
                            accentColor: AppModuleAccents.earn,
                          ),
                          _LiquidTabs(
                            active: _tab,
                            onChanged: (tab) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _tab = tab);
                            },
                          ),
                          if (_tab == _LiquidTab.stake)
                            _StakeTab(
                              snapshot: snapshot,
                              onDetail: _showTokenDetail,
                              onStake: (token) {
                                unawaited(HapticFeedback.lightImpact());
                                unawaited(
                                  showVitNoticeSheet(
                                    context: context,
                                    title: 'Đã chọn',
                                    message: 'Đã chọn stake ${token.symbol}',
                                  ),
                                );
                              },
                            ),
                          if (_tab == _LiquidTab.swap)
                            _SwapTab(
                              snapshot: snapshot,
                              swapFrom: _swapFrom,
                              swapTo: _swapTo,
                              amountController: _swapAmountController,
                              onFromChanged: (value) =>
                                  setState(() => _swapFrom = value),
                              onToChanged: (value) =>
                                  setState(() => _swapTo = value),
                              onAmountChanged: (_) => setState(() {}),
                              onReverse: () {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() {
                                  final oldFrom = _swapFrom;
                                  _swapFrom = _swapTo;
                                  _swapTo = oldFrom;
                                });
                              },
                            ),
                          if (_tab == _LiquidTab.holdings)
                            _HoldingsTab(
                              snapshot: snapshot,
                              onStakeNow: () {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() => _tab = _LiquidTab.stake);
                              },
                            ),
                          _BenefitsGrid(snapshot: snapshot),
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

  Future<void> _showTokenDetail(StakingLiquidTokenDraft token) async {
    unawaited(HapticFeedback.selectionClick());
    await showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) {
        return _SheetFrame(child: _TokenDetailSheet(token: token));
      },
    );
  }
}
