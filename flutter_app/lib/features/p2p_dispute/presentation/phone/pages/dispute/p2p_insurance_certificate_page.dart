import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/vit_p2p_flow_scaffold.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/p2p_formatters.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

part '../../../widgets/dispute/p2p_insurance_certificate_page_sections.dart';
part '../../../widgets/dispute/p2p_insurance_certificate_page_common.dart';

const double _p2pInsuranceVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pInsuranceNativeNavClearance =
    _p2pInsuranceVisualNavClearance - AppSpacing.x4;
const double _p2pInsuranceVisualClearance = AppSpacing.x3;
const double _p2pInsuranceNativeClearance = AppSpacing.x2;
const double _p2pInsuranceSectionGap = AppSpacing.x3;
const double _p2pInsuranceTightGap = AppSpacing.x2;
const double _p2pInsuranceHeroIconBox = P2PSpacingTokens.p2pDocumentHeroIconBox;
const double _p2pInsuranceBodyLineHeight =
    P2PSpacingTokens.p2pInsuranceCertificateBodyLineHeight;

class P2PInsuranceCertificatePage extends ConsumerStatefulWidget {
  const P2PInsuranceCertificatePage({super.key, this.shellRenderMode});

  static const cardKey = Key('sc239_p2p_insurance_certificate_card');
  static const downloadKey = Key('sc239_p2p_insurance_certificate_download');
  static const shareKey = Key('sc239_p2p_insurance_certificate_share');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PInsuranceCertificatePage> createState() =>
      _P2PInsuranceCertificatePageState();
}

class _P2PInsuranceCertificatePageState
    extends ConsumerState<P2PInsuranceCertificatePage> {
  String? _feedback;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pInsuranceCertificateProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pInsuranceVisualNavClearance + _p2pInsuranceVisualClearance
            : _p2pInsuranceNativeNavClearance + _p2pInsuranceNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return snapshotAsync.when(
      loading: () => VitP2PFlowScaffold(
        semanticLabel: 'Chứng nhận bảo hiểm',
        semanticIdentifier: 'SC-239',
        title: 'Đang tải…',
        onBack: () => context.go(AppRoutePaths.p2pInsurance),
        children: const [VitSkeletonList()],
      ),
      error: (error, stackTrace) => VitP2PFlowScaffold(
        semanticLabel: 'Chứng nhận bảo hiểm',
        semanticIdentifier: 'SC-239',
        title: 'Không tải được',
        onBack: () => context.go(AppRoutePaths.p2pInsurance),
        children: [
          VitErrorState(
            title: 'Không tải được',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(p2pInsuranceCertificateProvider),
          ),
        ],
      ),
      data: (snapshot) => VitP2PFlowScaffold(
        semanticLabel: 'Chứng nhận bảo hiểm',
        semanticIdentifier: 'SC-239',
        title: 'Chứng nhận bảo hiểm',
        subtitle: 'Bảo hiểm · P2P',
        onBack: () => context.go(AppRoutePaths.p2pInsurance),
        shellRenderMode: mode,
        bottomInset: scrollEndPadding,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ActionRow(
                snapshot: snapshot,
                onFeedback: (message) {
                  setState(() => _feedback = message);
                },
              ),
              if (_feedback != null) ...[
                const SizedBox(height: _p2pInsuranceTightGap),
                _FeedbackBanner(message: _feedback!),
              ],
            ],
          ),
          _CertificateCard(snapshot: snapshot),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DisclosureCard(snapshot: snapshot),
              const SizedBox(height: _p2pInsuranceTightGap),
              const VitHighRiskStatePanel(
                state: VitHighRiskUiState.riskReview,
                title: 'Xem lại chứng nhận bảo hiểm',
                message:
                    'Thông tin chứng nhận, phạm vi bảo hiểm, tải xuống/chia sẻ và giới hạn chính sách được xem lại trước khi xuất chứng minh P2P.',
                contractId: 'SC-239',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
