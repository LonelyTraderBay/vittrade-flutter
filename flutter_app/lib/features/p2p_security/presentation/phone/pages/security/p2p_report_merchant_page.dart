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

part '../../../widgets/security/p2p_report_merchant_summary_actions.dart';
part '../../../widgets/security/p2p_report_merchant_reasons_details.dart';

const double _p2pReportVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pReportNativeNavClearance =
    _p2pReportVisualNavClearance - AppSpacing.x4;
const double _p2pReportVisualClearance = AppSpacing.x3;
const double _p2pReportNativeClearance = AppSpacing.x2;

class P2PReportMerchantPage extends ConsumerStatefulWidget {
  const P2PReportMerchantPage({
    super.key,
    required this.merchantId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc229_p2p_report_content');
  static const blockButtonKey = Key('sc229_p2p_report_block');
  static const profileButtonKey = Key('sc229_p2p_report_profile');
  static const detailFieldKey = Key('sc229_p2p_report_detail');
  static const submitButtonKey = Key('sc229_p2p_report_submit');
  static const confirmKey = Key('sc229_p2p_report_confirm');
  static const cancelKey = Key('sc229_p2p_report_cancel');

  static Key reasonKey(String id) => Key('sc229_p2p_report_reason_$id');

  final String merchantId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PReportMerchantPage> createState() =>
      _P2PReportMerchantPageState();
}

class _P2PReportMerchantPageState extends ConsumerState<P2PReportMerchantPage> {
  final TextEditingController _detailController = TextEditingController();

  String _selectedReasonId = '';
  bool _submitting = false;

  @override
  void dispose() {
    _detailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(
      p2pReportMerchantProvider(widget.merchantId),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pReportVisualNavClearance + _p2pReportVisualClearance
            : _p2pReportNativeNavClearance + _p2pReportNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Báo cáo và chặn người bán P2P',
      semanticIdentifier: 'SC-229',
      child: Material(
        type: MaterialType.transparency,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () =>
                  context.go(AppRoutePaths.p2pMerchant(widget.merchantId)),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () =>
                  context.go(AppRoutePaths.p2pMerchant(widget.merchantId)),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () =>
                  ref.invalidate(p2pReportMerchantProvider(widget.merchantId)),
            ),
          ),
          data: (snapshot) {
            final selectedReason = snapshot.reasons.where(
              (reason) => reason.id == _selectedReasonId,
            );
            return VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: 'Báo cáo & Chặn',
                subtitle: 'An toàn · P2P',
                showBack: true,
                onBack: () => _returnToMerchant(snapshot),
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
                        key: P2PReportMerchantPage.contentKey,
                        physics: const ClampingScrollPhysics(),
                        padding:
                            P2PSpacingTokens.p2pRiskControlsReportScrollPadding(
                              scrollEndPadding,
                            ),
                        child: VitPageContent(
                          rhythm: VitPageRhythm.standard,
                          padding: VitContentPadding.none,
                          fullBleed: true,
                          gap: VitContentGap.tight,
                          children: [
                            _MerchantSummaryCard(snapshot: snapshot),
                            _ReportActionRow(
                              key: P2PReportMerchantPage.blockButtonKey,
                              icon: Icons.person_remove_alt_1_outlined,
                              title: 'Chặn người dùng',
                              subtitle: 'Không thể giao dịch với bạn',
                              foreground: AppColors.sell,
                              background: AppColors.sell10,
                              borderColor: AppColors.sell20,
                              onTap: () {
                                unawaited(HapticFeedback.selectionClick());
                                context.go(snapshot.blacklistAddRoute);
                              },
                            ),
                            _ReportActionRow(
                              key: P2PReportMerchantPage.profileButtonKey,
                              icon: Icons.groups_2_outlined,
                              title: 'Xem profile Merchant',
                              subtitle: 'Đánh giá, lịch sử, thông tin chi tiết',
                              foreground: AppColors.text2,
                              background: AppColors.surface2,
                              borderColor: AppColors.borderSolid,
                              onTap: () {
                                unawaited(HapticFeedback.selectionClick());
                                context.go(snapshot.merchantProfileRoute);
                              },
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const VitModuleSectionHeader(
                                  title: 'Báo cáo vi phạm',
                                  accentColor: AppModuleAccents.p2p,
                                  bottomGap:
                                      AppSpacing.pageRhythmStandardInnerGap,
                                ),
                                Text(
                                  'Chọn lý do báo cáo. Đội ngũ VitTrade sẽ xem xét trong 24–48h.',
                                  style: AppTextStyles.micro.copyWith(
                                    color: AppColors.text3,
                                    height: 1.25,
                                  ),
                                ),
                              ],
                            ),
                            for (final reason in snapshot.reasons)
                              _ReasonCard(
                                reason: reason,
                                selected: reason.id == _selectedReasonId,
                                onTap: () => _selectReason(reason.id),
                              ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 180),
                              child: selectedReason.isEmpty
                                  ? const SizedBox.shrink()
                                  : Padding(
                                      padding: P2PSpacingTokens
                                          .p2pRiskControlsDetailBottomPadding,
                                      child: _DetailField(
                                        controller: _detailController,
                                        hintText: snapshot.detailPrompt,
                                        onChanged: () => setState(() {}),
                                      ),
                                    ),
                            ),
                            _NoticeCard(text: snapshot.reviewNotice),
                            VitCtaButton(
                              key: P2PReportMerchantPage.submitButtonKey,
                              variant: VitCtaButtonVariant.danger,
                              loading: _submitting,
                              leading: const Icon(Icons.send_rounded),
                              onPressed: _selectedReasonId.isEmpty
                                  ? null
                                  : () => _submit(snapshot),
                              child: const Text('Gửi báo cáo'),
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

  void _selectReason(String reasonId) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _selectedReasonId = reasonId);
  }

  Future<void> _submit(P2PReportMerchantSnapshot snapshot) async {
    if (_selectedReasonId.isEmpty || _submitting) return;

    final reason = snapshot.reasons.firstWhere(
      (item) => item.id == _selectedReasonId,
      orElse: () => snapshot.reasons.first,
    );
    final confirmed = await showVitConfirmDialog(
      context: context,
      title: 'Xác nhận gửi báo cáo P2P',
      message:
          'Báo cáo sẽ được đội ngũ VitTrade xem xét. Kiểm tra người bán, lý do và bằng chứng trước khi gửi.',
      rows: [
        VitConfirmDialogRow(label: 'Người bán', value: snapshot.merchant.name),
        VitConfirmDialogRow(label: 'Lý do', value: reason.label),
        VitConfirmDialogRow(
          label: 'Chi tiết bổ sung',
          value: _detailController.text.trim().isEmpty
              ? 'Không có'
              : 'Đã nhập chi tiết',
        ),
      ],
      confirmLabel: 'Gửi báo cáo',
      confirmVariant: VitCtaButtonVariant.danger,
      confirmKey: P2PReportMerchantPage.confirmKey,
      cancelKey: P2PReportMerchantPage.cancelKey,
    );
    if (!mounted || !confirmed) return;

    unawaited(HapticFeedback.lightImpact());
    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 280));
    if (!mounted) return;
    unawaited(HapticFeedback.mediumImpact());
    context.go(snapshot.merchantProfileRoute);
  }

  void _returnToMerchant(P2PReportMerchantSnapshot snapshot) {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(snapshot.merchantProfileRoute);
  }
}
