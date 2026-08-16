import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
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

part '../../../widgets/dispute/p2p_insurance_score_page_sections.dart';
part '../../../widgets/dispute/p2p_insurance_score_page_common.dart';

class P2PInsuranceScorePage extends ConsumerWidget {
  const P2PInsuranceScorePage({super.key, this.shellRenderMode});

  static const scoreCardKey = Key('sc240_p2p_insurance_score_card');
  static const factorsKey = Key('sc240_p2p_insurance_score_factors');
  static Key quickActionKey(String label) => Key('sc240_quick_$label');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pInsuranceScoreProvider);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Điểm bảo vệ P2P',
      semanticIdentifier: 'SC-240',
      child: Material(
        type: MaterialType.transparency,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2pInsurance),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2pInsurance),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(p2pInsuranceScoreProvider),
            ),
          ),
          data: (snapshot) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Điểm bảo vệ',
              subtitle: 'Bảo hiểm · P2P',
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
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
                      padding: P2PSpacingTokens.p2pInsuranceScoreScrollPadding(
                        bottomInset,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.none,
                        fullBleed: true,
                        gap: VitContentGap.tight,
                        children: [
                          _ScoreOverviewCard(snapshot: snapshot),
                          _FactorBreakdownCard(snapshot: snapshot),
                          _QuickActionsCard(actions: snapshot.quickActions),
                          _TierPathCard(snapshot: snapshot),
                          _DisclosureCard(text: snapshot.disclosure),
                          const VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Xem lại điểm bảo vệ',
                            message:
                                'Điểm bảo vệ, yếu tố ảnh hưởng, hành động nhanh, lộ trình hạng và cảnh báo được xem lại trước khi thay đổi mức bảo hiểm P2P.',
                            contractId: 'SC-240',
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
