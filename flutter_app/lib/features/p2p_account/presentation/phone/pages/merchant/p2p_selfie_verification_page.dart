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

part '../../../widgets/merchant/p2p_selfie_verification_page_sections.dart';
part '../../../widgets/merchant/p2p_selfie_verification_page_common.dart';

enum _SelfieStep { guide, capture, liveness, result }

const double _p2pSelfieVisualClearance = AppSpacing.x3;
const double _p2pSelfieNativeClearance = AppSpacing.x2;
const double _p2pSelfieMajorGap = AppSpacing.x3;
const double _p2pSelfieSectionGap = AppSpacing.x2;
const double _p2pSelfieTightGap = AppSpacing.x1;
const double _p2pSelfieHeroIconBox = AppSpacing.searchBarCompactHeight;
const double _p2pSelfieActionIconBox = AppSpacing.x7;
const double _p2pSelfieSampleIconSize = AppSpacing.x7;
const double _p2pSelfieLivenessIconSize = AppSpacing.x7;
const double _p2pSelfieBodyLineHeight = 1.35;

class P2PSelfieVerificationPage extends ConsumerStatefulWidget {
  const P2PSelfieVerificationPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc251_p2p_selfie_hero');
  static const sampleKey = Key('sc251_p2p_selfie_sample');
  static const guidelinesKey = Key('sc251_p2p_selfie_guidelines');
  static const tipsKey = Key('sc251_p2p_selfie_tips');
  static const startKey = Key('sc251_p2p_selfie_start');
  static const captureKey = Key('sc251_p2p_selfie_capture');
  static const livenessKey = Key('sc251_p2p_selfie_liveness');
  static const livenessActionKey = Key('sc251_p2p_selfie_liveness_action');
  static const resultKey = Key('sc251_p2p_selfie_result');
  static const completeKey = Key('sc251_p2p_selfie_complete');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PSelfieVerificationPage> createState() =>
      _P2PSelfieVerificationPageState();
}

class _P2PSelfieVerificationPageState
    extends ConsumerState<P2PSelfieVerificationPage> {
  _SelfieStep _step = _SelfieStep.guide;
  int _currentActionIndex = 0;
  final Set<String> _completedActions = <String>{};

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pSelfieVerificationProvider);
    final routePath = GoRouterState.of(context).uri.path;
    final isFaceMatchRoute = routePath.startsWith('/p2p/kyc/face-match');
    final screenContract = isFaceMatchRoute ? 'SC-403' : 'SC-251';
    final title = switch (_step) {
      _SelfieStep.guide =>
        isFaceMatchRoute ? 'So khớp khuôn mặt' : 'Xác minh selfie',
      _SelfieStep.capture => 'Chụp ảnh selfie',
      _SelfieStep.liveness => 'Nhận diện sống',
      _SelfieStep.result => 'Kết quả xác minh',
    };

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: isFaceMatchRoute ? 'So khớp khuôn mặt' : 'Xác minh selfie',
      semanticIdentifier: screenContract,
      child: Material(
        type: MaterialType.transparency,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: title,
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2pKycStatus),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2pKycStatus),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(p2pSelfieVerificationProvider),
            ),
          ),
          data: (snapshot) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: title,
              subtitle: 'KYC · P2P',
              showBack: _step != _SelfieStep.liveness,
              onBack: () => _step == _SelfieStep.guide
                  ? context.go(snapshot.parentRoute)
                  : setState(() => _resetToGuide()),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [Expanded(child: _buildStep(context, snapshot))],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep(
    BuildContext context,
    P2PSelfieVerificationSnapshot snapshot,
  ) {
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + _p2pSelfieVisualClearance
            : DeviceMetrics.nativeBottomChrome + _p2pSelfieNativeClearance) +
        MediaQuery.paddingOf(context).bottom;
    final stepBody = switch (_step) {
      _SelfieStep.guide => _GuideStep(
        snapshot: snapshot,
        onStart: () {
          unawaited(HapticFeedback.selectionClick());
          setState(() => _step = _SelfieStep.capture);
        },
      ),
      _SelfieStep.capture => _CaptureStep(
        onCapture: () {
          unawaited(HapticFeedback.selectionClick());
          setState(() => _step = _SelfieStep.liveness);
        },
      ),
      _SelfieStep.liveness => _LivenessStep(
        snapshot: snapshot,
        currentActionIndex: _currentActionIndex,
        completedActions: _completedActions,
        onConfirmAction: () {
          unawaited(HapticFeedback.selectionClick());
          setState(() {
            final action = snapshot.livenessActions[_currentActionIndex];
            _completedActions.add(action.id);
            if (_currentActionIndex < snapshot.livenessActions.length - 1) {
              _currentActionIndex += 1;
            } else {
              _step = _SelfieStep.result;
            }
          });
        },
      ),
      _SelfieStep.result => _ResultStep(
        snapshot: snapshot,
        onComplete: () {
          unawaited(HapticFeedback.selectionClick());
          context.go(snapshot.statusRoute);
        },
        onSupport: () {
          unawaited(HapticFeedback.selectionClick());
          context.go(snapshot.supportRoute);
        },
      ),
    };

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: P2PSpacingTokens.p2pSelfieScrollPadding(scrollEndPadding),
        child: VitPageContent(
          rhythm: VitPageRhythm.form,
          padding: VitContentPadding.none,
          fullBleed: true,
          gap: VitContentGap.tight,
          children: [
            stepBody,
            const VitCard(
              variant: VitCardVariant.inner,
              padding: P2PSpacingTokens.p2pSelfieReviewPadding,
              child: VitHighRiskStatePanel(
                state: VitHighRiskUiState.riskReview,
                title: 'Xem lại xác minh selfie',
                message:
                    'Hướng dẫn, chụp ảnh, tiến trình liveness, xử lý sinh trắc học, trạng thái kết quả và bước hỗ trợ tiếp theo đã được xem trước khi hoàn tất xác minh P2P.',
                contractId: 'p2p-selfie-verification-review',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _resetToGuide() {
    _step = _SelfieStep.guide;
    _currentActionIndex = 0;
    _completedActions.clear();
  }
}
