import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_empty_state.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_error_state.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_offline_banner.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_skeleton.dart';

/// UI state rendered by [VitHighRiskStatePanel] for high-risk (contract-like)
/// flows: from initial loading through submitting to success/error/offline.
enum VitHighRiskUiState {
  loading,
  empty,
  error,
  offline,
  submitting,
  success,
  riskReview,
}

/// Single entry point rendering the correct panel (loading/empty/error/
/// offline/submitting/success/riskReview) for a high-risk flow's
/// [VitHighRiskUiState], with a consistent contract-id-aware semantics label.
class VitHighRiskStatePanel extends StatelessWidget {
  const VitHighRiskStatePanel({
    super.key,
    required this.state,
    required this.title,
    required this.message,
    this.contractId,
    this.actionLabel,
    this.onAction,
    this.density = VitDensity.standard,
  });

  final VitHighRiskUiState state;
  final String title;
  final String message;
  final String? contractId;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VitDensity density;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: contractId == null
          ? 'High risk flow state: ${state.name}'
          : 'High risk flow state: ${state.name}. Contract: $contractId',
      container: true,
      child: switch (state) {
        VitHighRiskUiState.loading => _LoadingPanel(
          title: title,
          message: message,
          density: density,
        ),
        VitHighRiskUiState.empty => VitEmptyState(
          title: title,
          message: message,
          icon: Icons.inbox_outlined,
          actionLabel: actionLabel,
          onAction: onAction,
        ),
        VitHighRiskUiState.error => VitErrorState(
          title: title,
          message: message,
          actionLabel: actionLabel ?? 'Thử lại',
          onAction: onAction,
        ),
        VitHighRiskUiState.offline => VitOfflineBanner(
          message: title,
          detail: message,
        ),
        VitHighRiskUiState.submitting => _CompactPanel(
          icon: Icons.pending_actions_rounded,
          title: title,
          message: message,
          foreground: AppColors.primary,
          background: AppColors.primary08,
          border: AppColors.primary20,
          density: density,
          trailing: Semantics(
            label: 'Đang xử lý',
            liveRegion: true,
            child: const SizedBox(
              width: AppSpacing.x4 + AppSpacing.x1,
              height: AppSpacing.x4 + AppSpacing.x1,
              child: CircularProgressIndicator(
                strokeWidth: AppSpacing.hairlineStroke,
              ),
            ),
          ),
        ),
        VitHighRiskUiState.success => _CompactPanel(
          icon: Icons.check_circle_outline_rounded,
          title: title,
          message: message,
          foreground: AppColors.buy,
          background: AppColors.buy10,
          border: AppColors.buy20,
          density: density,
        ),
        VitHighRiskUiState.riskReview => _CompactPanel(
          icon: Icons.verified_user_outlined,
          title: title,
          message: message,
          foreground: AppColors.riskWarning,
          background: AppColors.riskWarning08,
          border: AppColors.warningBorder,
          density: density,
        ),
      },
    );
  }
}

class _LoadingPanel extends StatelessWidget {
  const _LoadingPanel({
    required this.title,
    required this.message,
    required this.density,
  });

  final String title;
  final String message;
  final VitDensity density;

  @override
  Widget build(BuildContext context) {
    return _CompactPanel(
      icon: Icons.hourglass_empty_rounded,
      title: title,
      message: message,
      foreground: AppColors.text2,
      background: AppColors.surface2,
      border: AppColors.borderSolid,
      density: density,
      trailing: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(
          width:
              AppSpacing.buttonStandard +
              AppSpacing.buttonCompact +
              AppSpacing.x1,
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            VitSkeleton(width: 72, height: 10),
            SizedBox(height: AppSpacing.x2),
            VitSkeleton(width: 48, height: 10),
          ],
        ),
      ),
    );
  }
}

class _CompactPanel extends StatelessWidget {
  const _CompactPanel({
    required this.icon,
    required this.title,
    required this.message,
    required this.foreground,
    required this.background,
    required this.border,
    required this.density,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String message;
  final Color foreground;
  final Color background;
  final Color border;
  final VitDensity density;
  final Widget? trailing;

  bool get _isCompact =>
      density == VitDensity.compact || density == VitDensity.tool;

  EdgeInsetsGeometry get _padding {
    if (density == VitDensity.standard) {
      return const EdgeInsetsDirectional.all(AppSpacing.x4);
    }
    return density.cardPadding;
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: background,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.cardRadius,
          side: BorderSide(color: border),
        ),
      ),
      child: Padding(
        padding: _padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: foreground,
              size: _isCompact ? AppSpacing.iconSm : AppSpacing.ctaLoadingIcon,
            ),
            SizedBox(width: _isCompact ? AppSpacing.x2 : AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.caption.copyWith(
                      color: foreground,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    message,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[
              SizedBox(width: _isCompact ? AppSpacing.x2 : AppSpacing.x3),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
