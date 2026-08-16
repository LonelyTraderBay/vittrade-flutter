import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/vit_p2p_flow_scaffold.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

const double _p2pOwnershipSectionGap = P2PSpacingTokens.p2pPaymentCardGap;
const double _p2pOwnershipHeroIconBox = AppSpacing.searchBarCompactHeight;
const double _p2pOwnershipDocumentIconBox = AppSpacing.buttonCompact;

class P2PPaymentMethodOwnershipPage extends ConsumerStatefulWidget {
  const P2PPaymentMethodOwnershipPage({
    super.key,
    required this.methodId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc234_payment_ownership_content');
  static const submitButtonKey = Key('sc234_payment_ownership_submit');
  static const confirmSubmitKey = Key('sc234_payment_ownership_confirm');

  static Key uploadKey(String id) => Key('sc234_upload_$id');
  static Key removeKey(String id) => Key('sc234_remove_$id');
  static Key documentKey(String id) => Key('sc234_document_$id');

  final String methodId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PPaymentMethodOwnershipPage> createState() =>
      _P2PPaymentMethodOwnershipPageState();
}

class _P2PPaymentMethodOwnershipPageState
    extends ConsumerState<P2PPaymentMethodOwnershipPage> {
  final Set<String> _uploaded = {};
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(
      p2pPaymentMethodOwnershipControllerProvider(widget.methodId),
    );

    return controllerAsync.when(
      loading: () => VitP2PFlowScaffold(
        title: 'Đang tải…',
        semanticLabel: 'Xác minh sở hữu',
        semanticIdentifier: 'SC-234',
        onBack: () => context.go(AppRoutePaths.p2pPaymentMethods),
        children: const [VitSkeletonList()],
      ),
      error: (error, stackTrace) => VitP2PFlowScaffold(
        title: 'Không tải được',
        semanticLabel: 'Xác minh sở hữu',
        semanticIdentifier: 'SC-234',
        onBack: () => context.go(AppRoutePaths.p2pPaymentMethods),
        children: [
          VitErrorState(
            title: 'Không tải được',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(
              p2pPaymentMethodOwnershipControllerProvider(widget.methodId),
            ),
          ),
        ],
      ),
      data: (controller) {
        final snapshot = controller.state.snapshot;
        final canSubmit = controller.canSubmit(_uploaded) && !_submitting;
        return VitP2PFlowScaffold(
          title: 'Xác minh sở hữu',
          subtitle: 'Thanh toán · P2P',
          semanticLabel: 'Xác minh sở hữu',
          semanticIdentifier: 'SC-234',
          contentKey: P2PPaymentMethodOwnershipPage.contentKey,
          shellRenderMode: widget.shellRenderMode,
          rhythm: VitPageRhythm.form,
          onBack: () => context.go(AppRoutePaths.p2pPaymentMethods),
          children: [
            const _OwnershipHero(),
            Text(
              'Tài liệu cần thiết',
              style: AppTextStyles.baseMedium.copyWith(color: AppColors.text1),
            ),
            for (final document in snapshot.documents)
              _OwnershipDocumentCard(
                document: document,
                uploaded: _uploaded.contains(document.id),
                onUpload: () => _markUploaded(document.id),
                onRemove: () => _removeUpload(document.id),
              ),
            if (snapshot.highRiskContractId != null)
              VitHighRiskStatePanel(
                state: VitHighRiskUiState.riskReview,
                title: 'Cần xem trước gửi xác minh sở hữu',
                message:
                    'Tài liệu bắt buộc, bằng chứng tùy chọn và trạng thái tải lên phải đủ trước khi gửi. '
                    'Không hoàn tác sau khi xác nhận gửi. '
                    'Bước tiếp theo: đối chiếu KYC và mở hạn mức khi được duyệt.',
                contractId: snapshot.highRiskContractId,
              ),
            Semantics(
              label: 'Gửi xác minh sở hữu phương thức thanh toán P2P',
              button: true,
              enabled: canSubmit,
              child: VitCtaButton(
                key: P2PPaymentMethodOwnershipPage.submitButtonKey,
                loading: _submitting,
                onPressed: canSubmit
                    ? () => _confirmSubmit(context, controller)
                    : null,
                trailing: const Icon(Icons.chevron_right_rounded),
                child: const Text('Gửi xác minh'),
              ),
            ),
          ],
        );
      },
    );
  }

  void _markUploaded(String id) {
    unawaited(HapticFeedback.lightImpact());
    setState(() => _uploaded.add(id));
  }

  void _removeUpload(String id) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _uploaded.remove(id));
  }

  Future<void> _confirmSubmit(
    BuildContext context,
    P2PPaymentMethodOwnershipController controller,
  ) async {
    final preview = controller.submitPreview(_uploaded);
    final confirmed = await showVitConfirmDialog(
      context: context,
      title: preview.confirmTitle,
      message:
          '${preview.confirmMessage}\n'
          'Không hoàn tác sau khi xác nhận. '
          'Bước tiếp theo: hệ thống đối chiếu hồ sơ KYC trước khi mở hạn mức.',
      confirmLabel: 'Xác nhận',
      confirmKey: P2PPaymentMethodOwnershipPage.confirmSubmitKey,
    );

    if (!context.mounted || !confirmed) return;
    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (!context.mounted) return;
    setState(() => _submitting = false);
    await showVitNoticeSheet(
      context: context,
      title: 'Đã gửi xác minh sở hữu',
      message: 'Tài liệu đang được xem xét. Kết quả sẽ được thông báo sau.',
      variant: VitBannerVariant.success,
      ctaVariant: VitCtaButtonVariant.success,
      onPrimary: () {
        if (context.mounted) context.go(preview.saveRoute);
      },
    );
  }
}

class _OwnershipHero extends StatelessWidget {
  const _OwnershipHero();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: P2PSpacingTokens.p2pPaymentOwnershipCardPadding,
      borderColor: AppColors.primary20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Material(
            color: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
            child: SizedBox(
              width: _p2pOwnershipHeroIconBox,
              height: _p2pOwnershipHeroIconBox,
              child: Icon(
                Icons.credit_card_rounded,
                color: AppColors.text1,
                size: P2PSpacingTokens.p2pPaymentHeroIcon,
              ),
            ),
          ),
          const SizedBox(width: _p2pOwnershipSectionGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chứng minh tài khoản',
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppModuleAccents.p2p,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Tải lên tài liệu chứng minh tài khoản thuộc sở hữu của bạn',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OwnershipDocumentCard extends StatelessWidget {
  const _OwnershipDocumentCard({
    required this.document,
    required this.uploaded,
    required this.onUpload,
    required this.onRemove,
  });

  final P2POwnershipDocumentDraft document;
  final bool uploaded;
  final VoidCallback onUpload;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PPaymentMethodOwnershipPage.documentKey(document.id),
      radius: VitCardRadius.standard,
      padding: P2PSpacingTokens.p2pPaymentOwnershipCardPadding,
      child: Row(
        children: [
          _DocumentIcon(uploaded: uploaded),
          const SizedBox(width: _p2pOwnershipSectionGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        document.label,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.baseMedium.copyWith(
                          color: AppColors.text1,
                        ),
                      ),
                    ),
                    if (document.optional) ...[
                      const SizedBox(width: AppSpacing.x2),
                      const VitStatusPill(
                        label: 'Tùy chọn',
                        status: VitStatusPillStatus.neutral,
                        size: VitStatusPillSize.sm,
                      ),
                    ],
                  ],
                ),
                if (uploaded) ...[
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
          const SizedBox(width: _p2pOwnershipSectionGap),
          if (uploaded)
            VitInlineIconAction(
              key: P2PPaymentMethodOwnershipPage.removeKey(document.id),
              onPressed: onRemove,
              icon: Icons.close_rounded,
              color: AppColors.text3,
              size: AppSpacing.iconMd,
              tooltip: 'Xóa tài liệu',
            )
          else
            _UploadButton(
              key: P2PPaymentMethodOwnershipPage.uploadKey(document.id),
              onTap: onUpload,
            ),
        ],
      ),
    );
  }
}

class _DocumentIcon extends StatelessWidget {
  const _DocumentIcon({required this.uploaded});

  final bool uploaded;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: uploaded ? AppColors.buy15 : AppColors.primary12,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      child: SizedBox(
        width: _p2pOwnershipDocumentIconBox,
        height: _p2pOwnershipDocumentIconBox,
        child: Icon(
          uploaded
              ? Icons.check_circle_outline_rounded
              : Icons.photo_camera_outlined,
          color: uploaded ? AppColors.buy : AppModuleAccents.p2p,
          size: AppSpacing.iconMd,
        ),
      ),
    );
  }
}

class _UploadButton extends StatelessWidget {
  const _UploadButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: 'Tải lên',
      selected: false,
      onTap: onTap,
      padding: P2PSpacingTokens.p2pPaymentOwnershipOptionPadding,
      accentColor: AppModuleAccents.p2p,
      semanticLabel: 'Tải lên giấy tờ chứng minh sở hữu',
    );
  }
}
