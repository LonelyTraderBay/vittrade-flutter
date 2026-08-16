import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_compliance_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/features/trade_compliance/domain/entities/trade_compliance_entities.dart';

const _trackingBorder = AppColors.borderSolid;
const _trackingPrimary = AppColors.primary;
const _trackingGreen = AppColors.buy;
const _trackingAmber = AppColors.caution;
const _trackingSpace = AppSpacing.x2;
const _trackingTinySpace = AppSpacing.x1;
const _trackingIconTile = AppSpacing.iconLg;
const _trackingTimelineRailWidth =
    TradeSpacingTokens.complaintTrackingTimelineRailWidth;
const _trackingTimelineDotRadius = AppSpacing.iconSm;
const _trackingTimelineConnectorHeight =
    TradeSpacingTokens.complaintTrackingTimelineConnectorHeight;
const _trackingActionHeight = TradeSpacingTokens.complaintTrackingActionHeight;
const _trackingLineTight = 1.2;
const _trackingLineBody = 1.24;

class ComplaintTrackingPage extends ConsumerWidget {
  const ComplaintTrackingPage({
    super.key,
    this.complaintId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc113_complaint_tracking_content');
  static Key actionKey(String id) => Key('sc113_tracking_action_$id');

  final String? complaintId;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(tradeComplaintTrackingProvider(complaintId));
    return VitTradeHubScaffold(
      // Header không cần đợi async: complaintId hiển thị luôn suy ra được từ
      // tham số trang (mock chuẩn hoá `snapshot.complaintId` y hệt
      // `complaintId ?? 'undefined'`) — xem GD4-Async-Playbook.md mục 5.
      title: 'Complaint ${complaintId ?? 'undefined'}',
      semanticLabel: 'Theo dõi tiến trình xử lý khiếu nại',
      semanticIdentifier: 'SC-113',
      contentKey: contentKey,
      shellRenderMode: shellRenderMode,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeCopyComplaintsHandling,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: async.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được dữ liệu',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () =>
                ref.invalidate(tradeComplaintTrackingProvider(complaintId)),
          ),
        ],
        data: (snapshot) => [
          const VitTradeSection(
            title: 'Review',
            child: VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              title: 'Review complaint case status',
              message:
                  'Confirm evidence, response deadline, escalation limits, and next steps before adding information.',
              density: VitDensity.tool,
            ),
          ),
          VitTradeComplianceSection(
            title: 'Case review',
            statusPill: VitStatusPill(
              label: snapshot.statusLabel,
              status: VitStatusPillStatus.info,
              size: VitStatusPillSize.sm,
            ),
            items: [
              VitTradeComplianceItem(
                label: 'Deadline',
                value: snapshot.responseDueLabel,
              ),
              VitTradeComplianceItem(
                label: 'Timeline',
                value: '${snapshot.timeline.length} steps',
              ),
            ],
          ),
          VitTradeSection(
            title: 'Status',
            child: _StatusCard(snapshot: snapshot),
          ),
          VitTradeSection(
            title: 'Investigation Timeline',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _TimelineList(steps: snapshot.timeline),
                _DeadlineNotice(snapshot: snapshot),
                for (final action in snapshot.actions)
                  _TrackingActionButton(action: action),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.snapshot});

  final TradeComplaintTrackingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.tool,
      radius: VitCardRadius.standard,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: _trackingBorder.withValues(alpha: .76),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: ShapeDecoration(
              color: AppColors.surface2,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadii.smRadius,
                side: BorderSide(color: _trackingAmber.withValues(alpha: .24)),
              ),
            ),
            child: const SizedBox(
              width: _trackingIconTile,
              height: _trackingIconTile,
              child: Icon(
                Icons.schedule_rounded,
                color: _trackingAmber,
                size: AppSpacing.x4,
              ),
            ),
          ),
          const SizedBox(width: _trackingSpace),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: _trackingLineBody,
                  ),
                ),
                const SizedBox(height: _trackingTinySpace),
                Text(
                  snapshot.statusLabel,
                  style: AppTextStyles.base.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: _trackingLineTight,
                  ),
                ),
                const SizedBox(height: _trackingTinySpace),
                Wrap(
                  spacing: _trackingSpace,
                  runSpacing: _trackingTinySpace,
                  children: [
                    _StatusMetricInline(
                      label: 'Submitted',
                      value: snapshot.submittedLabel,
                    ),
                    _StatusMetricInline(
                      label: 'Response Due',
                      value: snapshot.responseDueLabel,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusMetricInline extends StatelessWidget {
  const _StatusMetricInline({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: '$label: ',
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          height: _trackingLineTight,
        ),
        children: [
          TextSpan(
            text: value,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: _trackingLineTight,
            ),
          ),
        ],
      ),
    );
  }
}

class _DeadlineNotice extends StatelessWidget {
  const _DeadlineNotice({required this.snapshot});

  final TradeComplaintTrackingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitHighRiskStatePanel(
      state: VitHighRiskUiState.riskReview,
      title: '${snapshot.daysRemaining} Days Remaining',
      message: snapshot.deadlineNotice,
      density: VitDensity.tool,
    );
  }
}

class _TimelineList extends StatelessWidget {
  const _TimelineList({required this.steps});

  final List<TradeComplaintTrackingStep> steps;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < steps.length; index++)
          _TimelineStepRow(
            step: steps[index],
            hasConnector: index < steps.length - 1,
          ),
      ],
    );
  }
}

class _TimelineStepRow extends StatelessWidget {
  const _TimelineStepRow({required this.step, required this.hasConnector});

  final TradeComplaintTrackingStep step;
  final bool hasConnector;

  @override
  Widget build(BuildContext context) {
    final color = switch (step.state) {
      TradeComplaintTrackingStepState.completed => _trackingGreen,
      TradeComplaintTrackingStepState.current => _trackingAmber,
      TradeComplaintTrackingStepState.pending => _trackingBorder,
    };

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: _trackingTimelineRailWidth,
          child: Column(
            children: [
              CircleAvatar(
                radius: _trackingTimelineDotRadius,
                backgroundColor: color.withValues(
                  alpha: step.state == TradeComplaintTrackingStepState.pending
                      ? .55
                      : .15,
                ),
                child: _TimelineIcon(state: step.state),
              ),
              if (hasConnector)
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    vertical: AppSpacing.x1,
                  ),
                  child: SizedBox(
                    width: AppSpacing.hairlineStroke,
                    height: _trackingTimelineConnectorHeight,
                    child: ColoredBox(
                      color:
                          step.state ==
                              TradeComplaintTrackingStepState.completed
                          ? _trackingGreen
                          : _trackingBorder,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: _trackingSpace),
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.x2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: _trackingLineTight,
                  ),
                ),
                const SizedBox(height: _trackingTinySpace),
                Text(
                  step.description,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: _trackingLineBody,
                  ),
                ),
                const SizedBox(height: _trackingTinySpace),
                Text(
                  step.dateLabel,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: _trackingLineTight,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TimelineIcon extends StatelessWidget {
  const _TimelineIcon({required this.state});

  final TradeComplaintTrackingStepState state;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      TradeComplaintTrackingStepState.completed => const Icon(
        Icons.check_circle_outline_rounded,
        color: _trackingGreen,
        size: AppSpacing.x4,
      ),
      TradeComplaintTrackingStepState.current => const Icon(
        Icons.schedule_rounded,
        color: _trackingAmber,
        size: AppSpacing.x4,
      ),
      TradeComplaintTrackingStepState.pending => const Center(
        child: Icon(Icons.circle, color: AppColors.text3, size: AppSpacing.x3),
      ),
    };
  }
}

class _TrackingActionButton extends StatelessWidget {
  const _TrackingActionButton({required this.action});

  final TradeComplaintTrackingAction action;

  @override
  Widget build(BuildContext context) {
    final accent = switch (action.icon) {
      TradeComplaintTrackingActionIcon.message => _trackingPrimary,
      TradeComplaintTrackingActionIcon.document => _trackingGreen,
      TradeComplaintTrackingActionIcon.warning => _trackingAmber,
    };
    final icon = switch (action.icon) {
      TradeComplaintTrackingActionIcon.message => Icons.chat_bubble_outline,
      TradeComplaintTrackingActionIcon.document => Icons.description_outlined,
      TradeComplaintTrackingActionIcon.warning => Icons.error_outline_rounded,
    };

    return VitCtaButton(
      key: ComplaintTrackingPage.actionKey(action.id),
      onPressed: () {
        final routePath = action.routePath;
        if (routePath == null) return;
        unawaited(context.push(routePath));
      },
      variant: VitCtaButtonVariant.secondary,
      density: VitDensity.tool,
      height: _trackingActionHeight,
      leading: Icon(icon, color: accent, size: AppSpacing.x4),
      trailing: const Icon(Icons.chevron_right_rounded, size: AppSpacing.x4),
      child: Text(
        action.label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text1,
          fontWeight: AppTextStyles.bold,
          height: _trackingLineTight,
        ),
      ),
    );
  }
}
