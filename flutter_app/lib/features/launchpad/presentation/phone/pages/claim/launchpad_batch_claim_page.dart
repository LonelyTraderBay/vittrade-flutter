import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';
part '../../../widgets/claim/launchpad_batch_claim_summary.dart';
part '../../../widgets/claim/launchpad_batch_claim_selection.dart';
part '../../../widgets/claim/launchpad_batch_claim_review_success.dart';

enum _BatchClaimStep { select, review }

class LaunchpadBatchClaimPage extends ConsumerStatefulWidget {
  const LaunchpadBatchClaimPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc304_launchpad_batch_claim_content');
  static const heroKey = Key('sc304_launchpad_batch_claim_hero');
  static const gasKey = Key('sc304_launchpad_batch_claim_gas');
  static const warningKey = Key('sc304_launchpad_batch_claim_warning');
  static const ctaKey = Key('sc304_launchpad_batch_claim_cta');
  static const reviewKey = Key('sc304_launchpad_batch_claim_review');
  static const reviewStateKey = Key('sc304_launchpad_batch_claim_review_state');

  static Key positionKey(String id) =>
      Key('sc304_launchpad_batch_claim_position_$id');
  static Key checkboxKey(String id) =>
      Key('sc304_launchpad_batch_claim_checkbox_$id');
  static Key detailKey(String id) =>
      Key('sc304_launchpad_batch_claim_detail_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadBatchClaimPage> createState() =>
      _LaunchpadBatchClaimPageState();
}

class _LaunchpadBatchClaimPageState
    extends ConsumerState<LaunchpadBatchClaimPage> {
  var _step = _BatchClaimStep.select;
  // GD4-F4 bẫy 14: initState() không còn seed từ getter đồng bộ — hạt giống
  // 1 lần trong nhánh `data:` qua `_selectedIds ??= ...`.
  Set<String>? _selectedIds;

  @override
  Widget build(BuildContext context) {
    final batchClaimAsync = ref.watch(launchpadBatchClaimSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navInset = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final safeBottom = MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Nhận thưởng hàng loạt Launchpad',
      semanticIdentifier: 'SC-304',
      child: Material(
        type: MaterialType.transparency,
        child: batchClaimAsync.when(
          loading: () => Stack(
            children: [
              VitAutoHideHeaderScaffold(
                bottomInset: navInset + safeBottom + AppSpacing.x6,
                semanticLabel: 'Nhận thưởng hàng loạt – vùng cuộn nội dung',
                semanticIdentifier: 'SC-304',
                header: VitHeader(
                  title: 'Nhận hàng loạt',
                  showBack: true,
                  onBack: () => context.go(AppRoutePaths.launchpadStaking),
                ),
                child: const VitSkeletonList(),
              ),
            ],
          ),
          error: (error, stackTrace) => Stack(
            children: [
              VitAutoHideHeaderScaffold(
                bottomInset: navInset + safeBottom + AppSpacing.x6,
                semanticLabel: 'Nhận thưởng hàng loạt – vùng cuộn nội dung',
                semanticIdentifier: 'SC-304',
                header: VitHeader(
                  title: 'Nhận hàng loạt',
                  showBack: true,
                  onBack: () => context.go(AppRoutePaths.launchpadStaking),
                ),
                child: VitErrorState(
                  title: 'Không tải được dữ liệu',
                  message: 'Vui lòng kiểm tra kết nối và thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () =>
                      ref.invalidate(launchpadBatchClaimSnapshotProvider),
                ),
              ),
            ],
          ),
          data: (snapshot) {
            final selectedIds = _selectedIds ??= snapshot.positions
                .map((position) => position.positionId)
                .toSet();
            final footerHeight =
                _step == _BatchClaimStep.select && selectedIds.isNotEmpty
                ? 92.0
                : 0.0;
            final bottomInset =
                navInset + safeBottom + AppSpacing.x6 + footerHeight;
            final selectedPositions = snapshot.positions
                .where((position) => selectedIds.contains(position.positionId))
                .toList();
            final selectedSummary = _summaryFor(selectedPositions);

            return Stack(
              children: [
                VitAutoHideHeaderScaffold(
                  bottomInset: bottomInset,
                  semanticLabel: 'Nhận thưởng hàng loạt – vùng cuộn nội dung',
                  semanticIdentifier: 'SC-304',
                  header: VitHeader(
                    title: snapshot.title,
                    showBack: true,
                    onBack: () => context.go(snapshot.backRoute),
                  ),
                  child: SingleChildScrollView(
                    key: LaunchpadBatchClaimPage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      padding: VitContentPadding.defaultPadding,
                      children: [
                        if (_step == _BatchClaimStep.select) ...[
                          _BatchSummaryHero(
                            summary: selectedSummary,
                            positionCount: selectedIds.length,
                          ),
                          _GasSavingsBanner(summary: selectedSummary),
                          _SelectionHeader(
                            selected: selectedIds.length,
                            total: snapshot.positions.length,
                            onSelectAll: () => setState(() {
                              _selectedIds = snapshot.positions
                                  .map((position) => position.positionId)
                                  .toSet();
                            }),
                            onClear: () => setState(selectedIds.clear),
                          ),
                          for (final position in snapshot.positions)
                            _BatchPositionCard(
                              position: position,
                              selected: selectedIds.contains(
                                position.positionId,
                              ),
                              onToggle: () => _toggle(position.positionId),
                              onDetail: () =>
                                  context.go(snapshot.claimReceiptRoute),
                            ),
                          if (selectedSummary.chains.length > 1)
                            _ChainWarning(summary: selectedSummary),
                        ] else
                          _ReviewStep(
                            positions: selectedPositions,
                            summary: selectedSummary,
                            onBack: () =>
                                setState(() => _step = _BatchClaimStep.select),
                            onConfirm: () => unawaited(
                              _confirmClaim(
                                snapshot,
                                selectedPositions.length,
                                selectedSummary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (_step == _BatchClaimStep.select && selectedIds.isNotEmpty)
                  Positioned(
                    // notice-ack: allow-sticky-footer-form-cta — select-step
                    // CTA footer, not a success toast overlay.
                    left: 0,
                    right: 0,
                    bottom: navInset + safeBottom,
                    child: VitStickyFooter(
                      backgroundColor: AppColors.surface.withValues(alpha: .94),
                      child: VitCtaButton(
                        key: LaunchpadBatchClaimPage.ctaKey,
                        variant: VitCtaButtonVariant.success,
                        leading: const Icon(
                          Icons.bolt_rounded,
                          color: AppColors.onAccent,
                          size: AppSpacing.iconSm,
                        ),
                        onPressed: () =>
                            setState(() => _step = _BatchClaimStep.review),
                        child: Text(
                          'Nhận ${selectedIds.length} vị trí - ~${_formatUsd(selectedSummary.totalClaimableUsd)}',
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _toggle(String id) {
    setState(() {
      final ids = _selectedIds;
      if (ids == null) return;
      if (ids.contains(id)) {
        ids.remove(id);
      } else {
        ids.add(id);
      }
    });
  }

  Future<void> _confirmClaim(
    LaunchpadBatchClaimSnapshot snapshot,
    int positionCount,
    LaunchpadBatchClaimSummaryDraft summary,
  ) async {
    await showVitNoticeSheet(
      context: context,
      title: 'Nhận hàng loạt thành công!',
      message:
          'Đã nhận phần thưởng từ $positionCount vị trí — '
          '~${_formatUsd(summary.totalClaimableUsd)}.',
      variant: VitBannerVariant.success,
      ctaVariant: VitCtaButtonVariant.success,
      onPrimary: () {
        if (mounted) context.go(snapshot.backRoute);
      },
    );
  }
}
