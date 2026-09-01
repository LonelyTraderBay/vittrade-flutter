import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

part '../../../widgets/tools/wallet_gas_optimizer_current.dart';
part '../../../widgets/tools/wallet_gas_optimizer_trends.dart';
part '../../../widgets/tools/wallet_gas_optimizer_tips.dart';

const _gasBorder = AppColors.overlayStroke;
const _gasPrimary = AppColors.primary;
const _gasGreen = AppColors.buy;
const _gasAmber = AppColors.caution;
const _gasRed = AppColors.sell;

const _tabCurrent = 'Hiện tại';
const _tabTrends = 'Xu hướng';
const _tabTips = 'Mẹo tiết kiệm';

double _gasScrollBottomInset(BuildContext context, ShellRenderMode mode) {
  return (mode.usesVisualQaFrame
          ? WalletSpacingTokens.walletVisualChromePad
          : WalletSpacingTokens.walletNativeChromePad) +
      MediaQuery.paddingOf(context).bottom;
}

class WalletGasOptimizerPage extends ConsumerStatefulWidget {
  const WalletGasOptimizerPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc149_gas_optimizer_content');
  static const refreshKey = Key('sc149_gas_optimizer_refresh');
  static const feedbackKey = Key('sc149_gas_optimizer_feedback');
  static Key tabKey(String label) => Key('sc149_gas_optimizer_tab_$label');
  static Key speedKey(String speed) => Key('sc149_gas_optimizer_speed_$speed');
  static Key comparisonKey(String type) =>
      Key('sc149_gas_optimizer_comparison_$type');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<WalletGasOptimizerPage> createState() =>
      _WalletGasOptimizerPageState();
}

class _WalletGasOptimizerPageState
    extends ConsumerState<WalletGasOptimizerPage> {
  String _tab = _tabCurrent;
  String _selectedSpeed = 'standard';
  String? _feedbackMessage;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(walletGasOptimizerProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding = _gasScrollBottomInset(context, mode);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Tối ưu phí gas giao dịch trên mạng',
      semanticIdentifier: 'SC-149',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Tối ưu phí gas',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.wallet),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: VitInsetScrollView(
                  key: WalletGasOptimizerPage.contentKey,
                  bottomInset: scrollEndPadding,
                  physics: const ClampingScrollPhysics(),
                  child: snapshotAsync.when(
                    loading: () => const VitSkeletonList(),
                    error: (error, stackTrace) => VitErrorState(
                      title: 'Không tải được dữ liệu tối ưu gas',
                      message: 'Vui lòng kiểm tra kết nối và thử lại.',
                      actionLabel: 'Thử lại',
                      onAction: () =>
                          ref.invalidate(walletGasOptimizerProvider),
                    ),
                    data: _contentForTab,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contentForTab(WalletGasOptimizerSnapshot snapshot) {
    final tabSections = switch (_tab) {
      _tabTrends => _TrendsTab(snapshot: snapshot).sectionChildren,
      _tabTips => _TipsTab(
        snapshot: snapshot,
        onQuickAction: (label) =>
            _showGasNotice('$label is not connected yet.'),
      ).sectionChildren,
      _ => _CurrentGasTab(
        snapshot: snapshot,
        selectedSpeed: _selectedSpeed,
        onSelectSpeed: (speed) => setState(() => _selectedSpeed = speed),
        onRefresh: _refreshGasPrices,
      ).sectionChildren,
    };

    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.compact,
      density: VitDensity.compact,
      gap: VitContentGap.tight,
      children: [
        _GasTabs(
          activeTab: _tab,
          onChanged: (tab) => setState(() => _tab = tab),
        ),
        if (_feedbackMessage != null)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: VitStatusPill(
              key: WalletGasOptimizerPage.feedbackKey,
              label: _feedbackMessage!,
              status: VitStatusPillStatus.info,
              icon: Icons.info_outline_rounded,
              size: VitStatusPillSize.sm,
            ),
          ),
        ...tabSections,
      ],
    );
  }

  void _refreshGasPrices() {
    ref.invalidate(walletGasOptimizerProvider);
    _showGasNotice('Đã làm mới ước tính gas. Xác nhận phí trước khi ký.');
  }

  void _showGasNotice(String message) {
    setState(() => _feedbackMessage = message);
  }
}
