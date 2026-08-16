import 'dart:async';

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vit_trade_flutter/core/utils/data_masking.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_staking_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/earn_core/presentation/widgets/earn_formatters.dart';

part '../../../widgets/staking/staking_proof_of_reserves_common.dart';
part '../../../widgets/staking/staking_proof_of_reserves_overview.dart';
part '../../../widgets/staking/staking_proof_of_reserves_overview_painters.dart';
part '../../../widgets/staking/staking_proof_of_reserves_assets.dart';
part '../../../widgets/staking/staking_proof_of_reserves_verify.dart';
part '../../../widgets/staking/staking_proof_of_reserves_verify_sheet.dart';

enum _ReserveTab { overview, assets, verify }

class StakingProofOfReservesPage extends ConsumerStatefulWidget {
  const StakingProofOfReservesPage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc380_info');
  static const tabsKey = Key('sc380_tabs');
  static const overviewKey = Key('sc380_overview');
  static const reserveStatusKey = Key('sc380_reserve_status');
  static const trendKey = Key('sc380_trend');
  static const auditsKey = Key('sc380_audits');
  static const assetsKey = Key('sc380_assets');
  static const verifyKey = Key('sc380_verify');
  static const verifySheetKey = Key('sc380_verify_sheet');
  static const userIdFieldKey = Key('sc380_user_id_field');
  static const balanceFieldKey = Key('sc380_balance_field');
  static const verifySubmitKey = Key('sc380_verify_submit');
  static const proofResultKey = Key('sc380_proof_result');
  static const footerKey = Key('sc380_footer');

  static Key tabKey(String id) => Key('sc380_tab_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingProofOfReservesPage> createState() =>
      _StakingProofOfReservesPageState();
}

class _StakingProofOfReservesPageState
    extends ConsumerState<StakingProofOfReservesPage> {
  _ReserveTab _tab = _ReserveTab.overview;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(stakingProofOfReservesSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel:
          'Bằng chứng dự trữ staking — minh bạch tài sản và kiểm toán độc lập',
      semanticIdentifier: 'SC-380',
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
                  ref.invalidate(stakingProofOfReservesSnapshotProvider),
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
              header: VitTopChrome(
                type: VitTopChromeType.detail,
                title: snapshot.title,
                subtitle: 'Minh bạch dự trữ — kiểm tra độc lập',
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
                        gap: VitContentGap.tight,
                        children: [
                          VitBanner(
                            key: StakingProofOfReservesPage.infoKey,
                            variant: VitBannerVariant.info,
                            icon: Icons.shield_outlined,
                            message: snapshot.infoTitle,
                            detail: snapshot.infoBody,
                          ),
                          _ReserveTabs(
                            active: _tab,
                            onChanged: (tab) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _tab = tab);
                            },
                          ),
                          if (_tab == _ReserveTab.overview)
                            _OverviewTab(snapshot: snapshot)
                          else if (_tab == _ReserveTab.assets)
                            _AssetsTab(snapshot: snapshot)
                          else
                            _VerifyTab(
                              snapshot: snapshot,
                              onVerify: () => _openVerifySheet(snapshot),
                            ),
                          _FooterNote(note: snapshot.footerNote),
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

  Future<void> _openVerifySheet(StakingProofOfReservesSnapshot snapshot) async {
    unawaited(HapticFeedback.selectionClick());
    await showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => _VerifySheet(snapshot: snapshot),
    );
  }
}

class _ReserveTabs extends StatelessWidget {
  const _ReserveTabs({required this.active, required this.onChanged});

  final _ReserveTab active;
  final ValueChanged<_ReserveTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingProofOfReservesPage.tabsKey,
      variant: VitCardVariant.inner,
      padding: EarnSpacingTokens.earnPaddingX2,
      child: VitTabBar(
        variant: VitTabBarVariant.underline,
        activeKey: active.name,
        tabs: [
          for (final tab in _ReserveTab.values)
            VitTabItem(
              key: tab.name,
              label: _tabLabel(tab),
              widgetKey: StakingProofOfReservesPage.tabKey(tab.name),
            ),
        ],
        onChanged: (key) => onChanged(_reserveTabFromKey(key)),
      ),
    );
  }
}
