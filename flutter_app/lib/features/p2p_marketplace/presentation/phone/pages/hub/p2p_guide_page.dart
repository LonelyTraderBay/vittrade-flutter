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
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

part '../../../widgets/phone/p2p_guide_tabs_faq.dart';
part '../../../widgets/phone/p2p_guide_steps_safety.dart';
part '../../../widgets/phone/p2p_guide_video_common.dart';

class P2PGuidePage extends ConsumerStatefulWidget {
  const P2PGuidePage({super.key, this.shellRenderMode});

  static const tabsKey = Key('sc280_p2p_guide_tabs');
  static const faqListKey = Key('sc280_p2p_guide_faq_list');
  static const buyModeKey = Key('sc280_p2p_guide_buy_mode');
  static const sellModeKey = Key('sc280_p2p_guide_sell_mode');
  static const startKey = Key('sc280_p2p_guide_start');
  static const supportKey = Key('sc280_p2p_guide_support');

  static Key tabKey(String id) => Key('sc280_p2p_guide_tab_$id');
  static Key faqKey(String id) => Key('sc280_p2p_guide_faq_$id');
  static Key videoKey(String id) => Key('sc280_p2p_guide_video_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PGuidePage> createState() => _P2PGuidePageState();
}

class _P2PGuidePageState extends ConsumerState<P2PGuidePage> {
  late String _tab;
  String _mode = 'buy';
  String? _expandedFaqId;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pGuideProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x4
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x3) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Hướng dẫn P2P',
      semanticIdentifier: 'SC-280',
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
              onAction: () => ref.invalidate(p2pGuideProvider),
            ),
          ),
          data: (snapshot) {
            _ensureState(snapshot);
            return VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: snapshot.title,
                subtitle: snapshot.subtitle,
                showBack: true,
                onBack: () => context.go(snapshot.parentRoute),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _GuideTabs(
                    tabs: snapshot.tabs,
                    active: _tab,
                    onChanged: (value) {
                      unawaited(HapticFeedback.selectionClick());
                      setState(() => _tab = value);
                    },
                  ),
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(
                        context,
                      ).copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        padding: P2PSpacingTokens.p2pGuideScrollPadding(
                          bottomInset,
                        ),
                        child: VitPageContent(
                          rhythm: VitPageRhythm.standard,
                          padding: VitContentPadding.none,
                          fullBleed: true,
                          children: [
                            switch (_tab) {
                              'guide' => _HowItWorksTab(
                                snapshot: snapshot,
                                mode: _mode,
                                onModeChanged: (value) {
                                  unawaited(HapticFeedback.selectionClick());
                                  setState(() => _mode = value);
                                },
                              ),
                              'safety' => _SafetyTab(snapshot: snapshot),
                              'video' => _VideoTab(snapshot: snapshot),
                              _ => _FaqTab(
                                snapshot: snapshot,
                                expandedFaqId: _expandedFaqId,
                                onFaqToggle: (faqId) {
                                  unawaited(HapticFeedback.selectionClick());
                                  setState(() {
                                    _expandedFaqId = _expandedFaqId == faqId
                                        ? null
                                        : faqId;
                                  });
                                },
                              ),
                            },
                            Text(
                              snapshot.contractNotes,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                          ],
                        ),
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

  void _ensureState(P2PGuideSnapshot snapshot) {
    if (_initialized) return;
    _tab = snapshot.defaultTab;
    _expandedFaqId = snapshot.faqItems.isEmpty
        ? null
        : snapshot.faqItems.first.id;
    _initialized = true;
  }
}
