import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/p2p_notice_widgets.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/p2p_formatters.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

part '../../../widgets/wallet/p2p_wallet_hero.dart';
part '../../../widgets/wallet/p2p_wallet_balances.dart';
part '../../../widgets/wallet/p2p_wallet_actions_history.dart';

const double _p2pWalletVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pWalletNativeNavClearance =
    _p2pWalletVisualNavClearance - AppSpacing.x4;
const double _p2pWalletVisualClearance = AppSpacing.x3;
const double _p2pWalletNativeClearance = AppSpacing.x2;
const double _p2pWalletIconBoxExtent = AppSpacing.inputHeight - AppSpacing.x2;
const double _p2pWalletActionMinHeight = AppSpacing.inputHeight - AppSpacing.x1;
const double _p2pWalletDividerExtent = AppSpacing.dividerHairline;
const double _p2pWalletTransactionAmountMaxWidth = 132;
const EdgeInsetsGeometry _p2pWalletCardPadding =
    P2PSpacingTokens.p2pWalletCompactCardPadding;
const EdgeInsetsGeometry _p2pWalletHeroPadding = EdgeInsetsDirectional.all(
  AppSpacing.x4,
);

class P2PWalletPage extends ConsumerStatefulWidget {
  const P2PWalletPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc264_p2p_wallet_hero');
  static const privacyKey = Key('sc264_p2p_wallet_privacy');
  static const transferFromMainKey = Key('sc264_p2p_wallet_from_main');
  static const transferToMainKey = Key('sc264_p2p_wallet_to_main');
  static const infoKey = Key('sc264_p2p_wallet_info');
  static const balancesKey = Key('sc264_p2p_wallet_balances');
  static const transactionsKey = Key('sc264_p2p_wallet_transactions');
  static const historyActionKey = Key('sc264_p2p_wallet_history_action');

  static Key balanceKey(String asset) => Key('sc264_p2p_wallet_balance_$asset');

  static Key depositKey(String asset) => Key('sc264_p2p_wallet_deposit_$asset');

  static Key withdrawKey(String asset) =>
      Key('sc264_p2p_wallet_withdraw_$asset');

  static Key escrowKey(String asset) => Key('sc264_p2p_wallet_escrow_$asset');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PWalletPage> createState() => _P2PWalletPageState();
}

class _P2PWalletPageState extends ConsumerState<P2PWalletPage> {
  bool _balanceVisible = true;
  String? _expandedAsset;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pWalletProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pWalletVisualNavClearance + _p2pWalletVisualClearance
            : _p2pWalletNativeNavClearance + _p2pWalletNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Ví P2P',
      semanticIdentifier: 'SC-264',
      child: Material(
        type: MaterialType.transparency,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2p),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2p),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(p2pWalletProvider),
            ),
          ),
          data: (snapshot) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
              actions: [
                VitHeaderActionItem(
                  key: P2PWalletPage.historyActionKey,
                  type: VitHeaderActionType.history,
                  onPressed: () => context.go(snapshot.historyRoute),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: P2PSpacingTokens.p2pWalletScrollPadding(
                        scrollEndPadding,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.none,
                        fullBleed: true,
                        gap: VitContentGap.tight,
                        children: [
                          _WalletHero(
                            snapshot: snapshot,
                            balanceVisible: _balanceVisible,
                            onPrivacyToggle: () {
                              unawaited(HapticFeedback.selectionClick());
                              setState(
                                () => _balanceVisible = !_balanceVisible,
                              );
                            },
                            onTransferFromMain: () => context.go(
                              '${snapshot.transferRoute}?direction=from-main',
                            ),
                            onTransferToMain: () => context.go(
                              '${snapshot.transferRoute}?direction=to-main',
                            ),
                          ),
                          _WalletInfoBanner(text: snapshot.infoNote),
                          _BalanceSection(
                            snapshot: snapshot,
                            expandedAsset: _expandedAsset,
                            onToggle: (asset) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() {
                                _expandedAsset = _expandedAsset == asset
                                    ? null
                                    : asset;
                              });
                            },
                          ),
                          _RecentTransactions(snapshot: snapshot),
                          const VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Xem lại trạng thái ví P2P',
                            message:
                                'Số dư đã che, hướng chuyển, số dư escrow, thao tác tài sản mở rộng, giao dịch gần đây và lộ trình lịch sử vẫn hiển thị trước khi chuyển tiền.',
                            contractId: 'SC-264',
                            density: VitDensity.compact,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
