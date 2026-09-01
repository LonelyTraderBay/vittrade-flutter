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

part '../../../widgets/staking/staking_institutional_overview_batches.dart';
part '../../../widgets/staking/staking_institutional_signers_features.dart';
part '../../../widgets/staking/staking_institutional_sheet_painter.dart';

enum _InstitutionalBatchTab { pending, executed }

class StakingInstitutionalPage extends ConsumerStatefulWidget {
  const StakingInstitutionalPage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc368_info_banner');
  static const statsKey = Key('sc368_stats');
  static const createButtonKey = Key('sc368_create_batch');
  static const createSheetKey = Key('sc368_create_sheet');
  static const tabsKey = Key('sc368_tabs');
  static const signersKey = Key('sc368_signers');
  static const featuresKey = Key('sc368_features');
  static const complianceKey = Key('sc368_compliance');

  static Key tabKey(String id) => Key('sc368_tab_$id');

  static Key batchKey(String id) => Key('sc368_batch_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingInstitutionalPage> createState() =>
      _StakingInstitutionalPageState();
}

class _StakingInstitutionalPageState
    extends ConsumerState<StakingInstitutionalPage> {
  _InstitutionalBatchTab _tab = _InstitutionalBatchTab.pending;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(stakingInstitutionalSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel:
          'Bảng điều khiển staking tổ chức — phê duyệt đa chữ ký và xử lý theo lô cho doanh nghiệp',
      semanticIdentifier: 'SC-368',
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
                  ref.invalidate(stakingInstitutionalSnapshotProvider),
            ),
          ),
          data: (snapshot) {
            final mode = widget.shellRenderMode ?? defaultShellRenderMode();
            final bottomInset =
                (mode.usesVisualQaFrame
                    ? DeviceMetrics.bottomChrome + AppSpacing.x7
                    : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
                MediaQuery.paddingOf(context).bottom;
            final batches = _tab == _InstitutionalBatchTab.pending
                ? snapshot.pendingBatches
                : snapshot.executedBatches;

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
                      padding: EarnSpacingTokens.earnBottomInsetPadding(
                        bottomInset,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.compact,
                        gap: VitContentGap.defaultGap,
                        children: [
                          VitInfoCallout(
                            key: StakingInstitutionalPage.infoKey,
                            message: snapshot.infoBody,
                            icon: Icons.apartment_rounded,
                            accentColor: AppModuleAccents.earn,
                            padding: EarnSpacingTokens.earnPaddingX4,
                          ),
                          _StatsCard(snapshot: snapshot),
                          VitCtaButton(
                            key: StakingInstitutionalPage.createButtonKey,
                            onPressed: () => _showCreateBatch(snapshot),
                            child: const Text('Create Batch Operation'),
                          ),
                          _BatchTabs(
                            active: _tab,
                            onChanged: (tab) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _tab = tab);
                            },
                          ),
                          VitPageSection(
                            label: _tab == _InstitutionalBatchTab.pending
                                ? 'Pending Approvals'
                                : 'Executed Batches',
                            accentColor: AppModuleAccents.earn,
                            children: [
                              for (final batch in batches)
                                _BatchOperationCard(batch: batch),
                            ],
                          ),
                          _AuthorizedSigners(snapshot: snapshot),
                          _EnterpriseFeatures(snapshot: snapshot),
                          _ComplianceNote(snapshot: snapshot),
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

  Future<void> _showCreateBatch(StakingInstitutionalSnapshot snapshot) async {
    unawaited(HapticFeedback.selectionClick());
    await showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) =>
          _SheetFrame(child: _CreateBatchSheet(snapshot: snapshot)),
    );
  }
}
