import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/earn_staking_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/widgets/staking/staking_custody_assets.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/widgets/staking/staking_custody_audit.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/widgets/staking/staking_custody_common.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/widgets/staking/staking_custody_overview.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_error_state.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_skeleton.dart';

class StakingCustodyPage extends ConsumerStatefulWidget {
  const StakingCustodyPage({super.key, this.shellRenderMode});

  static const heroKey = StakingCustodyKeys.hero;
  static const custodianKey = StakingCustodyKeys.custodian;
  static const segregationKey = StakingCustodyKeys.segregation;
  static const hotColdKey = StakingCustodyKeys.hotCold;
  static const reconciliationKey = StakingCustodyKeys.reconciliation;
  static const transparencyKey = StakingCustodyKeys.transparency;
  static const auditTrailButtonKey = StakingCustodyKeys.auditTrailButton;
  static const feedbackKey = StakingCustodyKeys.feedback;
  static const footerKey = StakingCustodyKeys.footer;

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingCustodyPage> createState() => _StakingCustodyPageState();
}

class _StakingCustodyPageState extends ConsumerState<StakingCustodyPage> {
  String? _feedback;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(stakingCustodySnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Lưu ký tách bạch và minh bạch tài sản',
      semanticIdentifier: 'SC-375',
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
              onAction: () => ref.invalidate(stakingCustodySnapshotProvider),
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
                subtitle: 'Lưu ký tách bạch và minh bạch tài sản',
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
                            child: StakingCustodyHeroCard(snapshot: snapshot),
                          ),
                          if (_feedback != null)
                            StakingCustodyFeedbackNote(text: _feedback!),
                          StakingCustodyCustodianSection(
                            custodian: snapshot.custodian,
                          ),
                          StakingCustodySegregationSection(snapshot: snapshot),
                          StakingCustodyHotColdSection(snapshot: snapshot),
                          StakingCustodyReconciliationSection(
                            snapshot: snapshot,
                            onAuditTrail: _openAuditTrail,
                          ),
                          StakingCustodyTransparencySection(snapshot: snapshot),
                          StakingCustodyFooterNote(text: snapshot.footerNote),
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

  void _openAuditTrail() {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _feedback = 'Opening full custody audit trail');
  }
}
