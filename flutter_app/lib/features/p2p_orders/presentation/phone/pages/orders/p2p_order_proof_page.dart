import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/p2p_notice_widgets.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/p2p_formatters.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

part '../../../widgets/orders/p2p_order_proof_widgets.dart';

const double _p2pOrderProofVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pOrderProofNativeNavClearance =
    _p2pOrderProofVisualNavClearance - AppSpacing.x4;
const double _p2pOrderProofVisualClearance = AppSpacing.x3;
const double _p2pOrderProofNativeClearance = AppSpacing.x2;

class P2POrderProofPage extends ConsumerStatefulWidget {
  const P2POrderProofPage({
    super.key,
    required this.orderId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc215_p2p_order_proof_content');
  static const cameraKey = Key('sc215_p2p_order_proof_camera');
  static const galleryKey = Key('sc215_p2p_order_proof_gallery');
  static const confirmKey = Key('sc215_p2p_order_proof_confirm');

  static Key removeKey(int index) => Key('sc215_p2p_order_proof_remove_$index');

  final String orderId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2POrderProofPage> createState() => _P2POrderProofPageState();
}

class _P2POrderProofPageState extends ConsumerState<P2POrderProofPage> {
  final List<String> _proofs = [];
  bool _isUploading = false;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pOrderProofProvider(widget.orderId));
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pOrderProofVisualNavClearance + _p2pOrderProofVisualClearance
            : _p2pOrderProofNativeNavClearance +
                  _p2pOrderProofNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Bằng chứng thanh toán đơn hàng P2P',
      semanticIdentifier: 'SC-215',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Bằng chứng thanh toán',
            subtitle: 'Đơn hàng - P2P',
            showBack: true,
            onBack: () => _close(context),
          ),
          child: snapshotAsync.when(
            loading: () => const VitSkeletonList(),
            error: (error, stackTrace) => VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () =>
                  ref.invalidate(p2pOrderProofProvider(widget.orderId)),
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
                      key: P2POrderProofPage.contentKey,
                      physics: const ClampingScrollPhysics(),
                      padding: P2PSpacingTokens.p2pOrderLifecycleScrollPadding(
                        scrollEndPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _OrderProofSummary(order: snapshot.order),
                          Padding(
                            padding: P2PSpacingTokens
                                .p2pFinancialSafetyHorizontalPadding,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(
                                  height: AppSpacing.pageRhythmStandardInnerGap,
                                ),
                                _UploadSection(
                                  title: snapshot.uploadTitle,
                                  subtitle: snapshot.uploadSubtitle,
                                  isUploading: _isUploading,
                                  onCamera: () => _addProof('camera'),
                                  onGallery: () => _addProof('gallery'),
                                ),
                                if (_proofs.isNotEmpty) ...[
                                  const SizedBox(
                                    height:
                                        AppSpacing.pageRhythmStandardInnerGap,
                                  ),
                                  _UploadedProofs(
                                    proofs: _proofs,
                                    onRemove: _removeProof,
                                  ),
                                ],
                                const SizedBox(
                                  height: AppSpacing.pageRhythmStandardInnerGap,
                                ),
                                _TipsCard(
                                  title: snapshot.tipsTitle,
                                  tips: snapshot.tips,
                                ),
                                const SizedBox(
                                  height: AppSpacing.pageRhythmStandardInnerGap,
                                ),
                                _ProofWarning(message: snapshot.warningMessage),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: AppSpacing.pageRhythmStandardInnerGap,
                          ),
                          VitCtaButton(
                            key: P2POrderProofPage.confirmKey,
                            onPressed: _proofs.isEmpty
                                ? null
                                : () => _confirm(context, snapshot.order),
                            loading: _isSubmitting,
                            leading: const Icon(Icons.upload_outlined),
                            child: Text('Xác nhận (${_proofs.length} ảnh)'),
                          ),
                          const VitPageContent(
                            rhythm: VitPageRhythm.standard,
                            padding: VitContentPadding.compact,
                            children: [
                              VitHighRiskStatePanel(
                                state: VitHighRiskUiState.riskReview,
                                title:
                                    'Xem lại trạng thái bằng chứng thanh toán',
                                message:
                                    'Tóm tắt đơn, nguồn tải lên, số tệp đính kèm, thao tác xóa, hướng dẫn, cảnh báo, xác nhận bị vô hiệu hóa, trạng thái tải lên và đang gửi vẫn hiển thị trước khi gửi bằng chứng.',
                                contractId: 'SC-215',
                              ),
                            ],
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

  Future<void> _addProof(String type) async {
    if (_isUploading || _proofs.length >= 3) return;
    unawaited(HapticFeedback.selectionClick());
    setState(() => _isUploading = true);
    await Future<void>.delayed(const Duration(milliseconds: 260));
    if (!mounted) return;
    setState(() {
      _proofs.add('proof_${type}_${_proofs.length + 1}.jpg');
      _isUploading = false;
    });
  }

  void _removeProof(int index) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _proofs.removeAt(index));
  }

  Future<void> _confirm(BuildContext context, P2POrderProofDraft order) async {
    if (_proofs.isEmpty || _isSubmitting) return;
    unawaited(HapticFeedback.mediumImpact());
    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 320));
    if (!context.mounted) return;
    context.go(AppRoutePaths.p2pOrder(order.id));
  }

  void _close(BuildContext context) {
    unawaited(HapticFeedback.selectionClick());
    goBackOrFallback(
      context,
      fallbackPath: AppRoutePaths.p2pOrder(widget.orderId),
      mode: BackNavigationMode.historyThenFallback,
    );
  }
}
