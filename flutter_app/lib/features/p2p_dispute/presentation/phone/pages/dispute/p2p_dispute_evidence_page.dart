import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
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

const double _p2pDisputeEvidenceVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pDisputeEvidenceNativeNavClearance =
    _p2pDisputeEvidenceVisualNavClearance - AppSpacing.x4;
const double _p2pDisputeEvidenceVisualClearance = AppSpacing.x3;
const double _p2pDisputeEvidenceNativeClearance = AppSpacing.x2;

class P2PDisputeEvidencePage extends ConsumerStatefulWidget {
  const P2PDisputeEvidencePage({
    super.key,
    required this.disputeId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc219_p2p_dispute_evidence_content');
  static const submitKey = Key('sc219_p2p_dispute_evidence_submit');

  static Key uploadKey(String id) => Key('sc219_p2p_dispute_evidence_$id');

  final String disputeId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PDisputeEvidencePage> createState() =>
      _P2PDisputeEvidencePageState();
}

class _P2PDisputeEvidencePageState
    extends ConsumerState<P2PDisputeEvidencePage> {
  final Set<String> _uploaded = {};

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(
      p2pDisputeEvidenceControllerProvider(widget.disputeId),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pDisputeEvidenceVisualNavClearance +
                  _p2pDisputeEvidenceVisualClearance
            : _p2pDisputeEvidenceNativeNavClearance +
                  _p2pDisputeEvidenceNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Bằng chứng tranh chấp P2P',
      semanticIdentifier: 'SC-219',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Bằng chứng tranh chấp',
            subtitle: 'Tranh chấp · P2P',
            showBack: true,
            onBack: () =>
                context.go(AppRoutePaths.p2pDisputeDetail(widget.disputeId)),
          ),
          child: controllerAsync.when(
            loading: () => const VitSkeletonList(),
            error: (error, stackTrace) => VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(
                p2pDisputeEvidenceControllerProvider(widget.disputeId),
              ),
            ),
            data: (controller) {
              final snapshot = controller.state.snapshot;
              final documents = controller.documents(_uploaded);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(
                        context,
                      ).copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        key: P2PDisputeEvidencePage.contentKey,
                        physics: const ClampingScrollPhysics(),
                        padding:
                            P2PSpacingTokens.p2pDisputeEvidenceScrollPadding(
                              scrollEndPadding,
                            ),
                        child: VitPageContent(
                          rhythm: VitPageRhythm.form,
                          padding: VitContentPadding.none,
                          fullBleed: true,
                          gap: VitContentGap.tight,
                          children: [
                            _HeroCard(
                              title: snapshot.title,
                              subtitle: snapshot.subtitle,
                            ),
                            const _MockActionNote(
                              text:
                                  'Mock/fail-closed: upload chỉ cập nhật trạng thái cục bộ trong dev smoke; chưa gửi file lên backend.',
                            ),
                            for (final document in documents)
                              _EvidenceRow(
                                document: document,
                                onUpload: () =>
                                    _markUploaded(document.source.id),
                              ),
                            VitCtaButton(
                              key: P2PDisputeEvidencePage.submitKey,
                              onPressed: controller.canSubmit(_uploaded)
                                  ? () {
                                      unawaited(HapticFeedback.mediumImpact());
                                      final preview = controller.submitPreview(
                                        _uploaded,
                                      );
                                      context.go(
                                        AppRoutePaths.p2pDisputeDetail(
                                          preview.disputeId,
                                        ),
                                      );
                                    }
                                  : null,
                              child: const Text('Gửi bằng chứng'),
                            ),
                            const VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'Xem lại gửi bằng chứng',
                              message:
                                  'Tài liệu bắt buộc, trạng thái tải lên, ghi chú backend fail-closed, đối tượng tranh chấp và bước biên nhận tiếp theo đã được xem trước khi gửi bằng chứng.',
                              contractId: 'p2p-dispute-evidence-review',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _markUploaded(String id) {
    unawaited(HapticFeedback.mediumImpact());
    setState(() => _uploaded.add(id));
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppModuleAccents.p2p.withValues(alpha: .24),
      padding: P2PSpacingTokens.p2pDisputeCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppModuleAccents.p2p,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            subtitle,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ],
      ),
    );
  }
}

class _MockActionNote extends StatelessWidget {
  const _MockActionNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      padding: P2PSpacingTokens.p2pDisputeCompactCardPadding,
      borderColor: AppColors.warningBorder,
      child: Text(
        text,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.warn,
          fontWeight: AppTextStyles.medium,
        ),
      ),
    );
  }
}

class _EvidenceRow extends StatelessWidget {
  const _EvidenceRow({required this.document, required this.onUpload});

  final P2PDisputeEvidenceDocumentViewState document;
  final VoidCallback onUpload;

  @override
  Widget build(BuildContext context) {
    final color = document.uploaded ? AppColors.buy : AppModuleAccents.p2p;
    return VitCard(
      padding: P2PSpacingTokens.p2pDisputeCardPadding,
      child: Row(
        children: [
          Material(
            color: color.withValues(alpha: .12),
            shape: const CircleBorder(),
            child: SizedBox(
              width: AppSpacing.x6,
              height: AppSpacing.x6,
              child: Icon(
                document.uploaded
                    ? Icons.check_circle_outline_rounded
                    : _documentIcon(document.source.iconKey),
                color: color,
                size: AppSpacing.iconSm,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.source.label,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                if (document.uploaded) ...[
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    'Đã tải lên',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.buy,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (!document.uploaded)
            _UploadButton(
              key: P2PDisputeEvidencePage.uploadKey(document.source.id),
              onPressed: onUpload,
            ),
        ],
      ),
    );
  }
}

class _UploadButton extends StatelessWidget {
  const _UploadButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: 'Upload',
      selected: false,
      onTap: onPressed,
      padding: P2PSpacingTokens.p2pDisputeEvidenceButtonPadding,
      accentColor: AppModuleAccents.p2p,
      semanticLabel: 'Tải lên bằng chứng khiếu nại',
    );
  }
}

IconData _documentIcon(String iconKey) {
  return switch (iconKey) {
    'image' => Icons.image_outlined,
    _ => Icons.description_outlined,
  };
}
