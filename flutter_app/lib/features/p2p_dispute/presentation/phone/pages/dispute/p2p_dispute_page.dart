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

class P2PDisputePage extends ConsumerStatefulWidget {
  const P2PDisputePage({
    super.key,
    required this.orderId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc221_p2p_dispute_content');
  static const descriptionKey = Key('sc221_p2p_dispute_description');
  static const uploadKey = Key('sc221_p2p_dispute_upload');
  static const submitKey = Key('sc221_p2p_dispute_submit');

  static Key reasonKey(String reason) =>
      Key('sc221_p2p_dispute_reason_${reason.hashCode}');

  final String orderId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PDisputePage> createState() => _P2PDisputePageState();
}

class _P2PDisputePageState extends ConsumerState<P2PDisputePage> {
  late final TextEditingController _descriptionController;
  String? _selectedReason;
  bool _evidenceUploaded = false;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _selectedReason != null && _descriptionController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pDisputeOpenProvider(widget.orderId));
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome +
                  P2PSpacingTokens.p2pDisputeBottomInsetVisual
            : DeviceMetrics.nativeBottomChrome +
                  P2PSpacingTokens.p2pDisputeBottomInsetNative) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Mở tranh chấp P2P',
      semanticIdentifier: 'SC-221',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Mở tranh chấp',
            subtitle: 'Tranh chấp · P2P',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.p2pOrder(widget.orderId)),
          ),
          child: snapshotAsync.when(
            loading: () => const VitSkeletonList(),
            error: (error, stackTrace) => VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () =>
                  ref.invalidate(p2pDisputeOpenProvider(widget.orderId)),
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
                      key: P2PDisputePage.contentKey,
                      physics: const ClampingScrollPhysics(),
                      padding: P2PSpacingTokens.p2pDisputeScrollPadding(
                        bottomInset,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.form,
                        padding: VitContentPadding.none,
                        fullBleed: true,
                        gap: VitContentGap.tight,
                        children: [
                          _DisputeHero(snapshot: snapshot),
                          const VitSectionHeader(
                            title: 'Lý do tranh chấp',
                            bottomGap: AppSpacing.pageRhythmFormInnerGap,
                          ),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final tileWidth =
                                  (constraints.maxWidth - AppSpacing.x2) / 2;
                              return Wrap(
                                spacing: AppSpacing.x2,
                                runSpacing: AppSpacing.x2,
                                children: [
                                  for (final reason in snapshot.reasons)
                                    SizedBox(
                                      width: tileWidth,
                                      child: _ReasonTile(
                                        key: P2PDisputePage.reasonKey(reason),
                                        reason: reason,
                                        selected: reason == _selectedReason,
                                        onTap: () => _selectReason(reason),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                          VitInput(
                            controller: _descriptionController,
                            fieldKey: P2PDisputePage.descriptionKey,
                            label: snapshot.descriptionLabel,
                            hintText: snapshot.descriptionPlaceholder,
                            textCapitalization: TextCapitalization.sentences,
                            onChanged: (_) => setState(() {}),
                          ),
                          _EvidenceUploadBox(
                            title: snapshot.uploadTitle,
                            subtitle: snapshot.uploadSubtitle,
                            uploaded: _evidenceUploaded,
                            onTap: _markEvidenceUploaded,
                          ),
                          VitCtaButton(
                            key: P2PDisputePage.submitKey,
                            onPressed: _canSubmit
                                ? () => _submit(snapshot.targetDisputeId)
                                : null,
                            variant: VitCtaButtonVariant.danger,
                            child: const Text('Gửi tranh chấp'),
                          ),
                          const VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Xem lại gửi tranh chấp',
                            message:
                                'Lý do, mô tả, bằng chứng đã tải, ảnh hưởng escrow, đối tượng vụ việc và bước tranh chấp tiếp theo đã được xem trước khi gửi.',
                            contractId: 'p2p-dispute-open-review',
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

  void _selectReason(String reason) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _selectedReason = reason);
  }

  void _markEvidenceUploaded() {
    unawaited(HapticFeedback.mediumImpact());
    setState(() => _evidenceUploaded = true);
  }

  void _submit(String disputeId) {
    unawaited(HapticFeedback.mediumImpact());
    context.go(AppRoutePaths.p2pDisputeDetail(disputeId));
  }
}

class _DisputeHero extends StatelessWidget {
  const _DisputeHero({required this.snapshot});

  final P2PDisputeOpenSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      borderColor: AppColors.sell15,
      padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: AppColors.sell.withValues(alpha: .18),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.inputRadius,
            ),
            child: const Padding(
              padding: EdgeInsetsDirectional.all(AppSpacing.x2),
              child: Icon(
                Icons.warning_amber_rounded,
                color: AppColors.sell,
                size: AppSpacing.iconSm,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.sell,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReasonTile extends StatelessWidget {
  const _ReasonTile({
    super.key,
    required this.reason,
    required this.selected,
    required this.onTap,
  });

  final String reason;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      onTap: onTap,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      borderColor: selected ? AppColors.sell : AppColors.borderSolid,
      background: ColoredBox(
        color: selected ? AppColors.sell10 : AppColors.transparent,
      ),
      clip: true,
      constraints: const BoxConstraints(
        minHeight: AppSpacing.buttonCompact + AppSpacing.x2,
      ),
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        reason,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.caption.copyWith(
          color: selected ? AppColors.sell : AppColors.text1,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _EvidenceUploadBox extends StatelessWidget {
  const _EvidenceUploadBox({
    required this.title,
    required this.subtitle,
    required this.uploaded,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool uploaded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = uploaded ? AppColors.buy : AppColors.text3;
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: uploaded ? AppColors.buy20 : AppColors.accent30,
        radius: AppRadii.cardRadius.topLeft,
      ),
      child: VitCard(
        key: P2PDisputePage.uploadKey,
        onTap: onTap,
        variant: VitCardVariant.ghost,
        radius: VitCardRadius.standard,
        background: ColoredBox(color: AppColors.surface.withValues(alpha: .56)),
        clip: true,
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              uploaded
                  ? Icons.check_circle_outline_rounded
                  : Icons.upload_outlined,
              color: color,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            Text(
              uploaded ? 'evidence_p2p001.png' : title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              uploaded ? 'Đã thêm bằng chứng' : subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final Radius radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppSpacing.borderWidth;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(Offset.zero & size, radius));
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + P2PSpacingTokens.p2pDisputeDashLength;
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + P2PSpacingTokens.p2pDisputeDashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}
