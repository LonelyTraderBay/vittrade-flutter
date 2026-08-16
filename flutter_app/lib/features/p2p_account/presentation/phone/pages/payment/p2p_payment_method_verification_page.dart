import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
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

part '../../../widgets/payment/p2p_payment_method_verification_methods.dart';
part '../../../widgets/payment/p2p_payment_method_verification_flow.dart';

const double _p2pPaymentVerificationVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pPaymentVerificationNativeNavClearance =
    _p2pPaymentVerificationVisualNavClearance - AppSpacing.x4;
const double _p2pPaymentVerificationVisualClearance = AppSpacing.x3;
const double _p2pPaymentVerificationNativeClearance = AppSpacing.x2;

class P2PPaymentMethodVerificationPage extends ConsumerStatefulWidget {
  const P2PPaymentMethodVerificationPage({
    super.key,
    required this.methodId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc233_payment_verification_content');
  static const codeFieldKey = Key('sc233_payment_verification_code');
  static const submitButtonKey = Key('sc233_payment_verification_submit');
  static const confirmSubmitKey = Key('sc233_payment_verification_confirm');

  static Key methodKey(String id) => Key('sc233_verification_method_$id');

  final String methodId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PPaymentMethodVerificationPage> createState() =>
      _P2PPaymentMethodVerificationPageState();
}

class _P2PPaymentMethodVerificationPageState
    extends ConsumerState<P2PPaymentMethodVerificationPage> {
  final _codeController = TextEditingController();
  String? _selectedMethodId;
  bool _submitting = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(
      p2pPaymentMethodVerificationProvider(widget.methodId),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pPaymentVerificationVisualNavClearance +
                  _p2pPaymentVerificationVisualClearance
            : _p2pPaymentVerificationNativeNavClearance +
                  _p2pPaymentVerificationNativeClearance) +
        MediaQuery.paddingOf(context).bottom;
    // onBack phải là closure INLINE tại từng VitHeader — auditor
    // back-navigation phân loại theo body lambda, không phân giải tham
    // chiếu hàm local (bài học F5).
    return VitPageLayout(
      semanticLabel: 'Xác minh phương thức thanh toán P2P',
      semanticIdentifier: 'SC-233',
      child: Material(
        type: MaterialType.transparency,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Xác minh phương thức',
              showBack: true,
              onBack: () {
                if (_selectedMethodId != null) {
                  setState(() => _selectedMethodId = null);
                  return;
                }
                context.go(AppRoutePaths.p2pPaymentMethods);
              },
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () {
                if (_selectedMethodId != null) {
                  setState(() => _selectedMethodId = null);
                  return;
                }
                context.go(AppRoutePaths.p2pPaymentMethods);
              },
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(
                p2pPaymentMethodVerificationProvider(widget.methodId),
              ),
            ),
          ),
          data: (snapshot) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: _selectedMethodId == null
                  ? 'Xác minh phương thức'
                  : _selectedTitle(snapshot),
              subtitle: _selectedMethodId == null ? 'Thanh toán · P2P' : null,
              showBack: true,
              onBack: () {
                if (_selectedMethodId != null) {
                  setState(() => _selectedMethodId = null);
                  return;
                }
                context.go(AppRoutePaths.p2pPaymentMethods);
              },
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
                      key: P2PPaymentMethodVerificationPage.contentKey,
                      physics: const ClampingScrollPhysics(),
                      padding:
                          P2PSpacingTokens.p2pPaymentVerificationScrollPadding(
                            scrollEndPadding,
                          ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.form,
                        padding: VitContentPadding.none,
                        fullBleed: true,
                        children: [
                          if (_selectedMethodId == null)
                            _MethodChooser(
                              snapshot: snapshot,
                              onSelected: (methodId) {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() => _selectedMethodId = methodId);
                              },
                            )
                          else
                            _VerificationFlow(
                              snapshot: snapshot,
                              methodId: _selectedMethodId!,
                              controller: _codeController,
                              submitting: _submitting,
                              onChanged: () => setState(() {}),
                              onSubmit: _canSubmit
                                  ? () => _confirmSubmit(context, snapshot)
                                  : null,
                            ),
                          const VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Xem lại xác minh phương thức thanh toán',
                            message:
                                'Xác nhận micro-deposit, kiểm tra sở hữu, ghi chú cảnh báo và đường quay lại đã được xem trước khi bật phương thức thanh toán P2P cho giao dịch escrow.',
                            contractId: 'SC-233',
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

  bool get _canSubmit =>
      _selectedMethodId == 'micro_deposit' &&
      _codeController.text.trim().isNotEmpty &&
      !_submitting;

  String _selectedTitle(P2PPaymentMethodVerificationSnapshot snapshot) {
    final method = snapshot.methods.firstWhere(
      (item) => item.id == _selectedMethodId,
      orElse: () => snapshot.methods.first,
    );
    if (method.id == 'micro_deposit') return 'Xác minh micro-deposit';
    return method.label;
  }

  Future<void> _confirmSubmit(
    BuildContext context,
    P2PPaymentMethodVerificationSnapshot snapshot,
  ) async {
    final confirmed = await showVitConfirmDialog(
      context: context,
      title: snapshot.confirmTitle,
      message: snapshot.confirmMessage,
      confirmLabel: 'Xác nhận',
      confirmKey: P2PPaymentMethodVerificationPage.confirmSubmitKey,
    );

    if (!context.mounted || !confirmed) return;
    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (!context.mounted) return;
    setState(() => _submitting = false);
    await showVitNoticeSheet(
      context: context,
      title: 'Đã xác minh phương thức',
      message: 'Phương thức thanh toán đã sẵn sàng sử dụng cho giao dịch P2P.',
      variant: VitBannerVariant.success,
      ctaVariant: VitCtaButtonVariant.success,
      onPrimary: () {
        if (context.mounted) context.go(snapshot.saveRoute);
      },
    );
  }
}
