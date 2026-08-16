import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
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
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';

class LaunchpadDetailPage extends ConsumerWidget {
  const LaunchpadDetailPage({
    super.key,
    this.projectId = 'sample',
    this.shellRenderMode,
  });

  static const contentKey = Key('sc318_launchpad_detail_content');
  static const errorKey = Key('sc318_launchpad_detail_error');
  static const summaryKey = Key('sc318_launchpad_detail_summary');

  final String projectId;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(launchpadDetailSnapshotProvider(projectId));
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    // GD4-F4: subtitle phụ thuộc snapshot.project (nullable) nên bọc CẢ
    // scaffold — title/backRoute vẫn là literal hằng số (xem
    // GD4-Async-Playbook.md, mục "header phụ thuộc dữ liệu").
    return detailAsync.when(
      loading: () => VitPageLayout(
        variant: VitPageVariant.flush,
        semanticLabel: 'Chi tiết dự án Launchpad',
        semanticIdentifier: 'SC-318',
        child: Material(
          type: MaterialType.transparency,
          child: VitAutoHideHeaderScaffold(
            bottomInset: bottomInset,
            semanticLabel: 'Chi tiết dự án – vùng cuộn nội dung',
            semanticIdentifier: 'SC-318',
            header: VitHeader(
              title: 'Launchpad',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.launchpad),
            ),
            child: const VitSkeletonList(),
          ),
        ),
      ),
      error: (error, stackTrace) => VitPageLayout(
        variant: VitPageVariant.flush,
        semanticLabel: 'Chi tiết dự án Launchpad',
        semanticIdentifier: 'SC-318',
        child: Material(
          type: MaterialType.transparency,
          child: VitAutoHideHeaderScaffold(
            bottomInset: bottomInset,
            semanticLabel: 'Chi tiết dự án – vùng cuộn nội dung',
            semanticIdentifier: 'SC-318',
            header: VitHeader(
              title: 'Launchpad',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.launchpad),
            ),
            child: VitErrorState(
              title: 'Không tải được dữ liệu',
              message: 'Vui lòng kiểm tra kết nối và thử lại.',
              actionLabel: 'Thử lại',
              onAction: () =>
                  ref.invalidate(launchpadDetailSnapshotProvider(projectId)),
            ),
          ),
        ),
      ),
      data: (snapshot) => VitPageLayout(
        variant: VitPageVariant.flush,
        semanticLabel: 'Chi tiết dự án Launchpad',
        semanticIdentifier: 'SC-318',
        child: Material(
          type: MaterialType.transparency,
          child: VitAutoHideHeaderScaffold(
            bottomInset: bottomInset,
            semanticLabel: 'Chi tiết dự án – vùng cuộn nội dung',
            semanticIdentifier: 'SC-318',
            header: VitHeader(
              title: snapshot.title,
              subtitle: snapshot.project == null
                  ? null
                  : '${_typeLabel(snapshot.project!.type)} · ${snapshot.project!.chain}',
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            child: SingleChildScrollView(
              key: contentKey,
              physics: const ClampingScrollPhysics(),
              child: VitPageContent(
                rhythm: VitPageRhythm.standard,
                padding: VitContentPadding.defaultPadding,
                children: [
                  if (snapshot.project == null)
                    const _LaunchpadDetailError()
                  else
                    _LaunchpadDetailSummary(snapshot: snapshot),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LaunchpadDetailError extends StatelessWidget {
  const _LaunchpadDetailError();

  @override
  Widget build(BuildContext context) {
    return VitErrorState(
      key: LaunchpadDetailPage.errorKey,
      title: 'Không tải được dữ liệu',
      message: 'Vui lòng kiểm tra kết nối mạng và thử lại.',
      icon: Icons.error_outline_rounded,
      iconContainerSize: 48,
      iconSize: 24,
      iconShape: BoxShape.circle,
      verticalPadding: AppSpacing.x7,
      horizontalPadding: AppSpacing.x6,
      titleStyle: AppTextStyles.baseMedium.copyWith(
        color: AppColors.text1,
        fontWeight: AppTextStyles.bold,
      ),
      messageStyle: AppTextStyles.caption.copyWith(
        color: AppColors.text3,
        height: LaunchpadSpacingTokens.launchpadLineHeightLong,
      ),
    );
  }
}

class _LaunchpadDetailSummary extends StatelessWidget {
  const _LaunchpadDetailSummary({required this.snapshot});

  final LaunchpadDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final project = snapshot.project!;
    final typeLabel = _typeLabel(project.type);
    final status = _statusPill(project.status);

    return Column(
      key: LaunchpadDetailPage.summaryKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          radius: VitCardRadius.large,
          padding: LaunchpadSpacingTokens.launchpadPaddingX5,
          borderColor: AppModuleAccents.launchpad.withValues(alpha: .24),
          child: Row(
            children: [
              _LaunchpadLogoMark(project: project),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x2,
                      children: [
                        VitStatusPill(
                          label: typeLabel,
                          status: VitStatusPillStatus.purple,
                          size: VitStatusPillSize.sm,
                        ),
                        VitStatusPill(
                          label: status.label,
                          status: status.status,
                          size: VitStatusPillSize.sm,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardInnerGap,
                    ),
                    Text(
                      project.name,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${project.symbol} - ${project.chain}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        Row(
          children: [
            Expanded(
              child: VitCardStat(
                child: _LaunchpadDetailStat(
                  label: 'Giá token',
                  value: '\$${_formatPrice(project.price)}',
                  meta: project.priceUnit,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: VitCardStat(
                child: _LaunchpadDetailStat(
                  label: 'Đã huy động',
                  value: project.totalRaise,
                  meta: 'trên ${project.hardCap}',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitCard(
          variant: VitCardVariant.inner,
          radius: VitCardRadius.large,
          padding: LaunchpadSpacingTokens.launchpadPaddingX5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.description,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: LaunchpadSpacingTokens.launchpadLineHeightLong,
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              Wrap(
                spacing: AppSpacing.x2,
                runSpacing: AppSpacing.x2,
                children: [
                  for (final tag in project.tags)
                    VitStatusPill(
                      label: tag,
                      status: VitStatusPillStatus.neutral,
                      size: VitStatusPillSize.sm,
                      outline: true,
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              Row(
                children: [
                  Expanded(
                    child: _LaunchpadDetailFact(
                      label: 'KYC',
                      value: project.kyc ? 'Level ${project.kycLevel}' : 'No',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _LaunchpadDetailFact(
                      label: 'Audit',
                      value: project.audit,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitHighRiskStatePanel(
          state: VitHighRiskUiState.riskReview,
          title: 'Cần rà soát staking Launchpad',
          message:
              'Xem lại phân bổ, điều kiện tham gia, thời hạn khóa, phí và rủi ro dự án trước khi mở luồng staking.',
          contractId: project.id,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitCard(
          variant: VitCardVariant.ghost,
          radius: VitCardRadius.large,
          padding: LaunchpadSpacingTokens.launchpadPaddingX5,
          borderColor: AppModuleAccents.launchpad.withValues(alpha: .24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Bước tiếp theo',
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(
                'Chỉ mở staking sau khi đã xem điều kiện và thời hạn khóa.',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: LaunchpadSpacingTokens.launchpadLineHeightLong,
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              VitCtaButton(
                onPressed: () => context.go(snapshot.stakingRoute),
                leading: const Icon(Icons.rocket_launch_outlined),
                child: const Text('Mở staking Launchpad'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LaunchpadLogoMark extends StatelessWidget {
  const _LaunchpadLogoMark({required this.project});

  final LaunchpadProjectDraft project;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.x7,
      height: AppSpacing.x7,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: project.accent.resolve().withValues(alpha: .12),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: project.accent.resolve().withValues(alpha: .24),
            ),
            borderRadius: AppRadii.cardRadius,
          ),
        ),
        child: Center(
          child: Text(
            project.logo,
            style: AppTextStyles.base.copyWith(
              color: project.accent.resolve(),
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _LaunchpadDetailStat extends StatelessWidget {
  const _LaunchpadDetailStat({
    required this.label,
    required this.value,
    required this.meta,
  });

  final String label;
  final String value;
  final String meta;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        if (meta.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.x1),
          Text(
            meta,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ],
    );
  }
}

class _LaunchpadDetailFact extends StatelessWidget {
  const _LaunchpadDetailFact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCardStat(
      child: _LaunchpadDetailStat(label: label, value: value, meta: ''),
    );
  }
}

final class _LaunchpadStatusLabel {
  const _LaunchpadStatusLabel({required this.label, required this.status});

  final String label;
  final VitStatusPillStatus status;
}

_LaunchpadStatusLabel _statusPill(LaunchpadProjectStatus status) {
  return switch (status) {
    LaunchpadProjectStatus.active => const _LaunchpadStatusLabel(
      label: 'Đang diễn ra',
      status: VitStatusPillStatus.success,
    ),
    LaunchpadProjectStatus.upcoming => const _LaunchpadStatusLabel(
      label: 'Sắp diễn ra',
      status: VitStatusPillStatus.info,
    ),
    LaunchpadProjectStatus.ended => const _LaunchpadStatusLabel(
      label: 'Đã kết thúc',
      status: VitStatusPillStatus.neutral,
    ),
  };
}

String _typeLabel(LaunchpadProjectType type) {
  return switch (type) {
    LaunchpadProjectType.ido => 'IDO',
    LaunchpadProjectType.ieo => 'IEO',
    LaunchpadProjectType.launchpool => 'Launchpool',
  };
}

String _formatPrice(double value) {
  final decimals = value < 0.01 ? 3 : 2;
  final fixed = value.toStringAsFixed(decimals);
  return fixed.replaceFirst(RegExp(r'\.?0+$'), '');
}
