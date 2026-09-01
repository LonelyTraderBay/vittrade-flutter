import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/profile_controller_providers.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/vip_history_widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/profile_spacing_tokens.dart';

part '../../widgets/profile_vip_hero.dart';
part '../../widgets/profile_vip_overview.dart';
part '../../widgets/profile_vip_benefits.dart';

const _vipAccent = AppColors.primary;
const _vipGold = AppColors.warn;
const _vipSuccess = AppColors.buy;
const _vipMuted = AppColors.text3;
const _vipProfileAccent = AppModuleAccents.profile;

enum _VipTab { overview, benefits, history }

class VIPPage extends ConsumerStatefulWidget {
  const VIPPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc164_vip_content');
  static const loadingKey = Key('sc164_vip_loading');
  static const errorKey = Key('sc164_vip_error');
  static const offlineKey = Key('sc164_vip_offline');
  static const emptyKey = Key('sc164_vip_empty');
  static const tradeCtaKey = Key('sc164_vip_trade_cta');
  static Key tabKey(String id) => Key('sc164_vip_tab_$id');
  static Key tierRowKey(int level) => Key('sc164_vip_tier_$level');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<VIPPage> createState() => _VIPPageState();
}

class _VIPPageState extends ConsumerState<VIPPage> {
  _VipTab _selectedTab = _VipTab.overview;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(profileVipSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollClearance =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome +
                  AppSpacing.x7 +
                  AppSpacing.x6 +
                  AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x6) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Chương trình hội viên VIP',
      semanticIdentifier: 'SC-164',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'VIP Program',
            subtitle: 'VIP \u00B7 Profile',
            showBack: true,
            onBack: _close,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: VIPPage.contentKey,
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsetsDirectional.only(bottom: scrollClearance),
                  child: VitPageContent(
                    rhythm: VitPageRhythm.standard,
                    padding: VitContentPadding.compact,
                    density: VitDensity.compact,
                    children: snapshotAsync.when(
                      loading: () => const [
                        VitSkeletonList(key: VIPPage.loadingKey),
                      ],
                      error: (error, stackTrace) => [
                        VitErrorState(
                          key: VIPPage.errorKey,
                          title: 'Không tải được dữ liệu',
                          message: 'Vui lòng thử lại.',
                          actionLabel: 'Thử lại',
                          onAction: () =>
                              ref.invalidate(profileVipSnapshotProvider),
                        ),
                      ],
                      data: (snapshot) => _vipPageChildren(
                        context: context,
                        snapshot: snapshot,
                        selectedTab: _selectedTab,
                        onTabChanged: (tab) =>
                            setState(() => _selectedTab = tab),
                        onTrade: _openTrade,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openTrade() {
    unawaited(HapticFeedback.selectionClick());
    context.go(AppRoutePaths.tradePair('btcusdt'));
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.profile);
  }
}
