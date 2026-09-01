import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/core/utils/data_masking.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/vit_p2p_flow_scaffold.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

part '../../../widgets/payment/p2p_payment_methods_page_sections.dart';
part '../../../widgets/payment/p2p_payment_methods_page_common.dart';

const double _p2pMethodsVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pMethodsNativeNavClearance =
    _p2pMethodsVisualNavClearance - AppSpacing.x5 + AppSpacing.x1;
const double _p2pMethodsVisualClearance = AppSpacing.x3;
const double _p2pMethodsNativeClearance = AppSpacing.x2;

class P2PPaymentMethodsPage extends ConsumerStatefulWidget {
  const P2PPaymentMethodsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc237_p2p_payment_methods_content');
  static const addBankKey = Key('sc237_p2p_payment_methods_add_bank');
  static const addEwalletKey = Key('sc237_p2p_payment_methods_add_ewallet');
  static const deleteConfirmKey = Key(
    'sc237_p2p_payment_methods_delete_confirm',
  );

  static Key methodKey(String id) => Key('sc237_p2p_payment_method_$id');
  static Key editKey(String id) => Key('sc237_p2p_payment_method_edit_$id');
  static Key deleteKey(String id) => Key('sc237_p2p_payment_method_delete_$id');
  static Key defaultKey(String id) =>
      Key('sc237_p2p_payment_method_default_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PPaymentMethodsPage> createState() =>
      _P2PPaymentMethodsPageState();
}

class _P2PPaymentMethodsPageState extends ConsumerState<P2PPaymentMethodsPage> {
  var _seeded = false;
  List<P2PPaymentListMethodDraft> _methods = const [];

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pPaymentMethodsProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pMethodsVisualNavClearance + _p2pMethodsVisualClearance
            : _p2pMethodsNativeNavClearance + _p2pMethodsNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return snapshotAsync.when(
      loading: () => VitP2PFlowScaffold(
        semanticLabel: 'Phương thức thanh toán',
        semanticIdentifier: 'SC-237',
        title: 'Đang tải…',
        onBack: () => context.go(AppRoutePaths.p2p),
        children: const [VitSkeletonList()],
      ),
      error: (error, stackTrace) => VitP2PFlowScaffold(
        semanticLabel: 'Phương thức thanh toán',
        semanticIdentifier: 'SC-237',
        title: 'Không tải được',
        onBack: () => context.go(AppRoutePaths.p2p),
        children: [
          VitErrorState(
            title: 'Không tải được',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(p2pPaymentMethodsProvider),
          ),
        ],
      ),
      data: (snapshot) {
        if (!_seeded) {
          _methods = List<P2PPaymentListMethodDraft>.of(snapshot.methods);
          _seeded = true;
        }

        final bankMethods = _methods
            .where((item) => item.type == P2PPaymentListMethodType.bank)
            .toList(growable: false);
        final ewalletMethods = _methods
            .where((item) => item.type == P2PPaymentListMethodType.ewallet)
            .toList(growable: false);

        return VitP2PFlowScaffold(
          semanticLabel: 'Phương thức thanh toán',
          semanticIdentifier: 'SC-237',
          title: 'Phương thức thanh toán',
          subtitle: 'Thanh toán · P2P',
          onBack: () => context.go(AppRoutePaths.p2p),
          contentKey: P2PPaymentMethodsPage.contentKey,
          shellRenderMode: mode,
          bottomInset: scrollEndPadding,
          children: [
            _AddMethodRow(snapshot: snapshot),
            const _ComplianceLinksRow(),
            if (bankMethods.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SectionHeader(
                    icon: Icons.credit_card_rounded,
                    title: 'Tài khoản ngân hàng (${bankMethods.length})',
                  ),
                  for (var index = 0; index < bankMethods.length; index++) ...[
                    if (index > 0)
                      const SizedBox(
                        height:
                            P2PSpacingTokens.p2pPaymentMethodsListSectionGap,
                      ),
                    _PaymentMethodCard(
                      method: bankMethods[index],
                      onEdit: () => _openEdit(bankMethods[index]),
                      onDelete: () => unawaited(
                        _requestDelete(bankMethods[index], snapshot),
                      ),
                      onSetDefault: () => _setDefault(bankMethods[index].id),
                    ),
                  ],
                ],
              ),
            if (ewalletMethods.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SectionHeader(
                    icon: Icons.phone_android_rounded,
                    title: 'Ví điện tử (${ewalletMethods.length})',
                  ),
                  for (
                    var index = 0;
                    index < ewalletMethods.length;
                    index++
                  ) ...[
                    if (index > 0)
                      const SizedBox(
                        height:
                            P2PSpacingTokens.p2pPaymentMethodsListSectionGap,
                      ),
                    _PaymentMethodCard(
                      method: ewalletMethods[index],
                      onEdit: () => _openEdit(ewalletMethods[index]),
                      onDelete: () => unawaited(
                        _requestDelete(ewalletMethods[index], snapshot),
                      ),
                      onSetDefault: () => _setDefault(ewalletMethods[index].id),
                    ),
                  ],
                ],
              ),
            if (_methods.isEmpty) _EmptyPaymentMethods(snapshot: snapshot),
            _SecurityNotice(text: snapshot.securityNote),
          ],
        );
      },
    );
  }

  void _openEdit(P2PPaymentListMethodDraft method) {
    unawaited(HapticFeedback.selectionClick());
    final type = method.type == P2PPaymentListMethodType.bank
        ? 'bank'
        : 'ewallet';
    context.go('${AppRoutePaths.p2pPaymentMethodAdd}?type=$type');
  }

  Future<void> _requestDelete(
    P2PPaymentListMethodDraft method,
    P2PPaymentMethodsSnapshot snapshot,
  ) async {
    unawaited(HapticFeedback.selectionClick());
    final confirmed = await showVitConfirmDialog(
      context: context,
      title: snapshot.deleteConfirmTitle,
      message: snapshot.deleteConfirmMessage,
      rows: [VitConfirmDialogRow(label: 'Phương thức', value: method.name)],
      confirmLabel: 'Xóa',
      confirmVariant: VitCtaButtonVariant.danger,
      confirmKey: P2PPaymentMethodsPage.deleteConfirmKey,
    );
    if (!confirmed || !mounted) return;
    unawaited(HapticFeedback.mediumImpact());
    setState(() {
      _methods = _methods.where((item) => item.id != method.id).toList();
    });
    await showVitNoticeSheet(
      context: context,
      title: 'Đã xóa phương thức',
      message: 'Đã xóa "${method.name}" khỏi danh sách thanh toán.',
      variant: VitBannerVariant.success,
      ctaVariant: VitCtaButtonVariant.success,
    );
  }

  void _setDefault(String id) {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _methods = _methods
          .map((item) => item.copyWith(isDefault: item.id == id))
          .toList();
    });
  }
}
