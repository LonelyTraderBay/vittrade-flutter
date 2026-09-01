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

part '../../../widgets/merchant/p2p_kyc_status_page_sections.dart';
part '../../../widgets/merchant/p2p_kyc_status_page_common.dart';

const _p2pKycVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const _p2pKycNativeNavClearance = _p2pKycVisualNavClearance - AppSpacing.x4;
const _p2pKycVisualClearance = AppSpacing.x3;
const _p2pKycNativeClearance = AppSpacing.x2;
const _p2pKycSectionGap = AppSpacing.x2;
const _p2pKycTightGap = AppSpacing.x1;
const _p2pKycSupportIconGap = AppSpacing.x2;

class P2PKycStatusPage extends ConsumerWidget {
  const P2PKycStatusPage({super.key, this.shellRenderMode});

  static const statusCardKey = Key('sc248_p2p_kyc_status_card');
  static const timelineKey = Key('sc248_p2p_kyc_status_timeline');
  static Key stepKey(String stepId) => Key('sc248_p2p_kyc_status_step_$stepId');
  static Key actionKey(String stepId) =>
      Key('sc248_p2p_kyc_status_action_$stepId');
  static const supportKey = Key('sc248_p2p_kyc_status_support');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pKycStatusProvider);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pKycVisualNavClearance + _p2pKycVisualClearance
            : _p2pKycNativeNavClearance + _p2pKycNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Trạng thái KYC P2P',
      semanticIdentifier: 'SC-248',
      child: Material(
        type: MaterialType.transparency,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2pKycRequirements),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2pKycRequirements),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(p2pKycStatusProvider),
            ),
          ),
          data: (snapshot) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Trạng thái KYC',
              subtitle: 'KYC · P2P',
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: RefreshIndicator(
                    color: AppModuleAccents.p2p,
                    backgroundColor: AppColors.surface2,
                    onRefresh: () async {
                      unawaited(HapticFeedback.selectionClick());
                      await Future<void>.delayed(
                        const Duration(milliseconds: 120),
                      );
                    },
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(
                        context,
                      ).copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: ClampingScrollPhysics(),
                        ),
                        padding: P2PSpacingTokens.p2pKycStatusScrollPadding(
                          scrollEndPadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _OverallStatusCard(snapshot: snapshot),
                            const SizedBox(height: _p2pKycSectionGap),
                            Text(
                              'Chi tiết các bước',
                              style: AppTextStyles.baseMedium.copyWith(
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            const SizedBox(height: _p2pKycTightGap),
                            _StatusTimeline(steps: snapshot.steps),
                            const SizedBox(height: _p2pKycSectionGap),
                            _SupportCard(snapshot: snapshot),
                            const VitPageContent(
                              rhythm: VitPageRhythm.form,
                              padding: VitContentPadding.none,
                              fullBleed: true,
                              customGap: P2PSpacingTokens.p2pKycContentGap,
                              children: [
                                VitHighRiskStatePanel(
                                  state: VitHighRiskUiState.riskReview,
                                  title: 'Xem lại trạng thái KYC',
                                  message:
                                      'Trạng thái tổng, trạng thái làm mới, thao tác timeline, đường hỗ trợ và ảnh hưởng giao dịch P2P vẫn hiển thị trong khi xác minh được xem xét.',
                                  contractId: 'SC-248',
                                ),
                              ],
                            ),
                          ],
                        ),
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
