import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';

class LaunchpadContractPage extends ConsumerWidget {
  const LaunchpadContractPage({
    super.key,
    this.projectId = 'sample',
    this.shellRenderMode,
  });

  static const contentKey = Key('sc300_launchpad_contract_content');
  static const notFoundKey = Key('sc300_launchpad_contract_not_found');

  final String projectId;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contractAsync = ref.watch(
      launchpadContractSnapshotProvider(projectId),
    );
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    // GD4-F4: subtitle phụ thuộc snapshot.project (nullable) nên bọc CẢ
    // scaffold — title/backRoute vẫn là literal hằng số.
    return contractAsync.when(
      loading: () => VitPageLayout(
        variant: VitPageVariant.flush,
        semanticLabel: 'Xem trước hợp đồng dự án Launchpad',
        semanticIdentifier: 'SC-300',
        child: Material(
          type: MaterialType.transparency,
          child: VitAutoHideHeaderScaffold(
            bottomInset: bottomInset,
            semanticLabel: 'Xem trước hợp đồng – vùng cuộn nội dung',
            semanticIdentifier: 'SC-300',
            header: VitHeader(
              title: 'Contract',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.launchpad),
            ),
            child: const VitSkeletonList(),
          ),
        ),
      ),
      error: (error, stackTrace) => VitPageLayout(
        variant: VitPageVariant.flush,
        semanticLabel: 'Xem trước hợp đồng dự án Launchpad',
        semanticIdentifier: 'SC-300',
        child: Material(
          type: MaterialType.transparency,
          child: VitAutoHideHeaderScaffold(
            bottomInset: bottomInset,
            semanticLabel: 'Xem trước hợp đồng – vùng cuộn nội dung',
            semanticIdentifier: 'SC-300',
            header: VitHeader(
              title: 'Contract',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.launchpad),
            ),
            child: VitErrorState(
              title: 'Không tải được dữ liệu',
              message: 'Vui lòng kiểm tra kết nối và thử lại.',
              actionLabel: 'Thử lại',
              onAction: () =>
                  ref.invalidate(launchpadContractSnapshotProvider(projectId)),
            ),
          ),
        ),
      ),
      data: (snapshot) => VitPageLayout(
        variant: VitPageVariant.flush,
        semanticLabel: 'Xem trước hợp đồng dự án Launchpad',
        semanticIdentifier: 'SC-300',
        child: Material(
          type: MaterialType.transparency,
          child: VitAutoHideHeaderScaffold(
            bottomInset: bottomInset,
            semanticLabel: 'Xem trước hợp đồng – vùng cuộn nội dung',
            semanticIdentifier: 'SC-300',
            header: VitHeader(
              title: snapshot.title,
              subtitle: snapshot.project == null
                  ? null
                  : 'Xem trước contract · Xác nhận trước khi ký',
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            child: SingleChildScrollView(
              key: contentKey,
              physics: const ClampingScrollPhysics(),
              child: VitPageContent(
                rhythm: VitPageRhythm.standard,
                padding: VitContentPadding.compact,
                gap: VitContentGap.tight,
                children: [
                  if (snapshot.project == null)
                    const _ContractProjectNotFound()
                  else
                    _ContractParticipationFlow(snapshot: snapshot),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ContractProjectNotFound extends StatelessWidget {
  const _ContractProjectNotFound();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadContractPage.notFoundKey,
      radius: VitCardRadius.large,
      padding: LaunchpadSpacingTokens.launchpadEmptyStatePadding,
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconLg,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Text(
            'Dự án không tồn tại',
            textAlign: TextAlign.center,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            'Contract chỉ khả dụng khi dự án IDO hợp lệ. Quay về Launchpad để chọn dự án.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _ContractParticipationFlow extends StatelessWidget {
  const _ContractParticipationFlow({required this.snapshot});

  final LaunchpadContractSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final project = snapshot.project!;
    final writeFunctions = snapshot.functions
        .where((fn) => fn.type == LaunchpadContractFunctionType.write)
        .take(3)
        .toList();
    final previewSimulation = snapshot.simulations.isNotEmpty
        ? snapshot.simulations.first
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ContractProjectHero(project: project, snapshot: snapshot),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _ContractNetworksSection(networks: snapshot.networks),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _ContractFunctionsSection(functions: writeFunctions),
        if (previewSimulation != null) ...[
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _ContractSimulationCard(simulation: previewSimulation),
        ],
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitCtaButton(
          variant: VitCtaButtonVariant.secondary,
          onPressed: () => context.go(snapshot.abiDiffRoute),
          leading: const Icon(Icons.difference_outlined),
          child: const Text('ABI Diff'),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        const _ContractRiskDisclosure(),
      ],
    );
  }
}

class _ContractProjectHero extends StatelessWidget {
  const _ContractProjectHero({required this.project, required this.snapshot});

  final LaunchpadProjectDraft project;
  final LaunchpadContractSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      borderColor: AppModuleAccents.launchpad.withValues(alpha: .22),
      padding: LaunchpadSpacingTokens.launchpadPaddingX5,
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.x7,
            height: AppSpacing.x7,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: project.accent.resolve().withValues(alpha: .12),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.smRadius,
                ),
              ),
              child: Center(
                child: Text(
                  project.logo,
                  style: AppTextStyles.caption.copyWith(
                    color: project.accent.resolve(),
                    fontWeight: AppTextStyles.extraBold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${project.name} Contract',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  '${snapshot.functions.length} functions · ${snapshot.networks.length} networks',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContractNetworksSection extends StatelessWidget {
  const _ContractNetworksSection({required this.networks});

  final List<LaunchpadBridgeNetworkDraft> networks;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Mạng hỗ trợ',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final network in networks)
                VitAccentPill(
                  label: network.symbol,
                  accentColor: network.accent.resolve(),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContractFunctionsSection extends StatelessWidget {
  const _ContractFunctionsSection({required this.functions});

  final List<LaunchpadContractFunctionDraft> functions;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Hành động chính',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (final fn in functions) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fn.name,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      Text(
                        fn.description,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      if (fn.estimatedGas != null)
                        Text(
                          'Gas ~${fn.estimatedGas}',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                VitStatusPill(
                  label: _riskLabel(fn.riskLevel),
                  status: _riskStatus(fn.riskLevel),
                  size: VitStatusPillSize.sm,
                ),
              ],
            ),
            if (fn != functions.last)
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          ],
        ],
      ),
    );
  }
}

class _ContractSimulationCard extends StatelessWidget {
  const _ContractSimulationCard({required this.simulation});

  final LaunchpadTxSimulationDraft simulation;

  @override
  Widget build(BuildContext context) {
    final status = switch (simulation.status) {
      LaunchpadTxSimulationStatus.success => VitStatusPillStatus.success,
      LaunchpadTxSimulationStatus.warning => VitStatusPillStatus.warning,
      LaunchpadTxSimulationStatus.failed => VitStatusPillStatus.error,
      LaunchpadTxSimulationStatus.simulating => VitStatusPillStatus.neutral,
    };

    return VitCard(
      radius: VitCardRadius.large,
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Mô phỏng: ${simulation.functionName}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              VitStatusPill(
                label: simulation.chain,
                status: status,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            simulation.expectedOutput,
            style: AppTextStyles.micro.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            'Chi phí ${simulation.totalCost} · Gas ${simulation.gasEstimate}',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          if (simulation.warnings.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            for (final warning in simulation.warnings)
              Text(
                warning,
                style: AppTextStyles.micro.copyWith(color: AppColors.warn),
              ),
          ],
        ],
      ),
    );
  }
}

class _ContractRiskDisclosure extends StatelessWidget {
  const _ContractRiskDisclosure();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.warn15,
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              'Mọi giao dịch contract cần xem trước phí, gas và rủi ro slashing/refund trước khi xác nhận.',
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

VitStatusPillStatus _riskStatus(LaunchpadContractRiskLevel level) {
  return switch (level) {
    LaunchpadContractRiskLevel.low => VitStatusPillStatus.success,
    LaunchpadContractRiskLevel.medium => VitStatusPillStatus.warning,
    LaunchpadContractRiskLevel.high => VitStatusPillStatus.error,
  };
}

String _riskLabel(LaunchpadContractRiskLevel level) {
  return switch (level) {
    LaunchpadContractRiskLevel.low => 'Thấp',
    LaunchpadContractRiskLevel.medium => 'Trung bình',
    LaunchpadContractRiskLevel.high => 'Cao',
  };
}
