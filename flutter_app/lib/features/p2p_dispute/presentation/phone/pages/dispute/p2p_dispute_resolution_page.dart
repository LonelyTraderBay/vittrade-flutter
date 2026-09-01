import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
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

const double _p2pDisputeResolutionVisualClearance = AppSpacing.x3;
const double _p2pDisputeResolutionNativeClearance = AppSpacing.x2;
const double _p2pDisputeResolutionVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pDisputeResolutionNativeNavClearance =
    _p2pDisputeResolutionVisualNavClearance - AppSpacing.x5 + AppSpacing.x1;
const double _p2pDisputeResolutionSectionGap = AppSpacing.x2;
const double _p2pDisputeResolutionIconBox = AppSpacing.buttonCompact;

class P2PDisputeResolutionPage extends ConsumerStatefulWidget {
  const P2PDisputeResolutionPage({
    super.key,
    required this.disputeId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc220_p2p_dispute_resolution_content');
  static const appealKey = Key('sc220_p2p_dispute_resolution_appeal');
  static const disputesKey = Key('sc220_p2p_dispute_resolution_disputes');

  final String disputeId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PDisputeResolutionPage> createState() =>
      _P2PDisputeResolutionPageState();
}

class _P2PDisputeResolutionPageState
    extends ConsumerState<P2PDisputeResolutionPage> {
  bool _appealOpened = false;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(
      p2pDisputeResolutionProvider(widget.disputeId),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pDisputeResolutionVisualNavClearance +
                  _p2pDisputeResolutionVisualClearance
            : _p2pDisputeResolutionNativeNavClearance +
                  _p2pDisputeResolutionNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Kết quả giải quyết tranh chấp P2P',
      semanticIdentifier: 'SC-220',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Kết quả giải quyết',
            subtitle: 'Tranh chấp · P2P',
            showBack: true,
            onBack: () =>
                context.go(AppRoutePaths.p2pDisputeDetail(widget.disputeId)),
          ),
          child: snapshotAsync.when(
            loading: () => const VitSkeletonList(),
            error: (error, stackTrace) => VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(
                p2pDisputeResolutionProvider(widget.disputeId),
              ),
            ),
            data: (snapshot) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      key: P2PDisputeResolutionPage.contentKey,
                      physics: const ClampingScrollPhysics(),
                      padding:
                          P2PSpacingTokens.p2pDisputeResolutionScrollPadding(
                            scrollEndPadding,
                          ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.form,
                        padding: VitContentPadding.none,
                        fullBleed: true,
                        gap: VitContentGap.tight,
                        children: [
                          _DecisionHero(snapshot: snapshot),
                          _DecisionDetailCard(snapshot: snapshot),
                          _AppealCard(
                            deadline: snapshot.appealDeadline,
                            appealOpened: _appealOpened,
                            onAppeal: _openAppeal,
                          ),
                          VitCtaButton(
                            key: P2PDisputeResolutionPage.disputesKey,
                            onPressed: () =>
                                context.go(AppRoutePaths.p2pDisputes),
                            child: const Text('Quay về danh sách tranh chấp'),
                          ),
                          if (snapshot.highRiskContractId != null)
                            VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'Xem lại kết quả giải quyết',
                              message:
                                  'Quyết định, số tiền hoàn, ghi chú hòa giải, trạng thái kháng cáo, danh sách tranh chấp và bước vụ việc tiếp theo đã được xem trước khi đóng.',
                              contractId: snapshot.highRiskContractId,
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

  void _openAppeal() {
    unawaited(HapticFeedback.mediumImpact());
    setState(() => _appealOpened = true);
  }
}

class _DecisionHero extends StatelessWidget {
  const _DecisionHero({required this.snapshot});

  final P2PDisputeResolutionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.large,
      borderColor: AppColors.buy15,
      background: const ColoredBox(color: AppColors.buy10),
      clip: true,
      child: Padding(
        padding: P2PSpacingTokens.p2pDisputeResolutionCardPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Material(
              color: AppColors.buy,
              shape: RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
              child: SizedBox(
                width: _p2pDisputeResolutionIconBox,
                height: _p2pDisputeResolutionIconBox,
                child: Icon(
                  Icons.check_circle_outline_rounded,
                  color: AppColors.onAccent,
                  size: AppSpacing.iconMd,
                ),
              ),
            ),
            const SizedBox(width: _p2pDisputeResolutionSectionGap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.resultTitle,
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.buy,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    snapshot.disputeLabel,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DecisionDetailCard extends StatelessWidget {
  const _DecisionDetailCard({required this.snapshot});

  final P2PDisputeResolutionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: P2PSpacingTokens.p2pDisputeResolutionCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chi tiết quyết định',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: _p2pDisputeResolutionSectionGap),
          _DetailField(
            label: 'Số tiền hoàn trả',
            value: snapshot.refundAmountLabel,
            prominent: true,
          ),
          const SizedBox(height: _p2pDisputeResolutionSectionGap),
          _DetailField(label: 'Lý do', value: snapshot.reason),
          const SizedBox(height: _p2pDisputeResolutionSectionGap),
          _DetailField(label: 'Trọng tài', value: snapshot.mediator),
          const SizedBox(height: _p2pDisputeResolutionSectionGap),
          _DetailField(label: 'Quyết định lúc', value: snapshot.resolvedAt),
        ],
      ),
    );
  }
}

class _DetailField extends StatelessWidget {
  const _DetailField({
    required this.label,
    required this.value,
    this.prominent = false,
  });

  final String label;
  final String value;
  final bool prominent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontWeight: AppTextStyles.medium,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style:
              (prominent ? AppTextStyles.sectionTitle : AppTextStyles.caption)
                  .copyWith(
                    color: prominent ? AppColors.text1 : AppColors.text2,
                    fontWeight: prominent
                        ? AppTextStyles.bold
                        : AppTextStyles.normal,
                    fontFeatures: prominent
                        ? AppTextStyles.tabularFigures
                        : null,
                  ),
        ),
      ],
    );
  }
}

class _AppealCard extends StatelessWidget {
  const _AppealCard({
    required this.deadline,
    required this.appealOpened,
    required this.onAppeal,
  });

  final String deadline;
  final bool appealOpened;
  final VoidCallback onAppeal;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      borderColor: AppColors.warn15,
      background: const ColoredBox(color: AppColors.warn10),
      clip: true,
      child: Padding(
        padding: P2PSpacingTokens.p2pDisputeResolutionCardPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.chat_bubble_outline_rounded,
              color: AppColors.warn,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quyền kháng cáo',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.warn,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    'Bạn có thể kháng cáo quyết định này trước $deadline',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                  ),
                  const SizedBox(height: _p2pDisputeResolutionSectionGap),
                  VitCtaButton(
                    key: P2PDisputeResolutionPage.appealKey,
                    onPressed: onAppeal,
                    variant: VitCtaButtonVariant.warning,
                    fullWidth: false,
                    height: AppSpacing.buttonCompact,
                    padding:
                        P2PSpacingTokens.p2pDisputeResolutionCompactCardPadding,
                    child: Text(
                      appealOpened ? 'Đang mở kháng cáo' : 'Kháng cáo',
                    ),
                  ),
                  if (appealOpened) ...[
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Text(
                      'Form kháng cáo đã được chuẩn bị. Mock/fail-closed: chưa gửi appeal lên backend.',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.warn,
                        fontWeight: AppTextStyles.medium,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
