import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
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

part '../../../widgets/merchant/p2p_identity_verification_page_sections.dart';
part '../../../widgets/merchant/p2p_identity_verification_page_common.dart';

class P2PIdentityVerificationPage extends ConsumerStatefulWidget {
  const P2PIdentityVerificationPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc249_p2p_identity_hero');
  static const documentTypesKey = Key('sc249_p2p_identity_document_types');
  static Key documentTypeKey(String id) => Key('sc249_p2p_identity_doc_$id');
  static const guidelinesKey = Key('sc249_p2p_identity_guidelines');
  static const frontUploadKey = Key('sc249_p2p_identity_front_upload');
  static const backUploadKey = Key('sc249_p2p_identity_back_upload');
  static const securityKey = Key('sc249_p2p_identity_security');
  static const submitKey = Key('sc249_p2p_identity_submit');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PIdentityVerificationPage> createState() =>
      _P2PIdentityVerificationPageState();
}

class _P2PIdentityVerificationPageState
    extends ConsumerState<P2PIdentityVerificationPage> {
  String? _selectedTypeId;
  bool _frontUploaded = false;
  bool _backUploaded = false;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pIdentityVerificationProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome +
                  P2PSpacingTokens.p2pKycBottomInsetVisual
            : DeviceMetrics.nativeBottomChrome +
                  P2PSpacingTokens.p2pKycBottomInsetNative) +
        MediaQuery.paddingOf(context).bottom;
    final routeName = GoRouterState.of(context).uri.path;
    final screenContract = routeName.startsWith('/p2p/kyc/verify')
        ? 'SC-402'
        : 'SC-249';

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Xác minh danh tính P2P',
      semanticIdentifier: screenContract,
      child: Material(
        type: MaterialType.transparency,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
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
              onAction: () => ref.invalidate(p2pIdentityVerificationProvider),
            ),
          ),
          data: (snapshot) {
            final selectedDocument = _selectedTypeId == null
                ? null
                : snapshot.documentTypes.firstWhere(
                    (document) => document.id == _selectedTypeId,
                    orElse: () => snapshot.documentTypes.first,
                  );
            return VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: 'Xác minh danh tính',
                subtitle: 'KYC · P2P',
                showBack: true,
                onBack: () => context.go(snapshot.parentRoute),
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
                        physics: const ClampingScrollPhysics(),
                        padding: P2PSpacingTokens.p2pKycScrollPadding(
                          bottomInset,
                        ),
                        child: VitPageContent(
                          rhythm: VitPageRhythm.form,
                          padding: VitContentPadding.none,
                          fullBleed: true,
                          gap: VitContentGap.tight,
                          children: [
                            _IdentityHero(snapshot: snapshot),
                            if (selectedDocument == null)
                              _DocumentTypePicker(
                                documents: snapshot.documentTypes,
                                onSelected: (document) {
                                  unawaited(HapticFeedback.selectionClick());
                                  setState(() => _selectedTypeId = document.id);
                                },
                              )
                            else ...[
                              _GuidelinesCard(snapshot: snapshot),
                              _UploadSection(
                                selectedDocument: selectedDocument,
                                frontUploaded: _frontUploaded,
                                backUploaded: _backUploaded,
                                onFrontUpload: () {
                                  unawaited(HapticFeedback.selectionClick());
                                  setState(() => _frontUploaded = true);
                                },
                                onBackUpload: _frontUploaded
                                    ? () {
                                        unawaited(
                                          HapticFeedback.selectionClick(),
                                        );
                                        setState(() => _backUploaded = true);
                                      }
                                    : null,
                                onFrontRemove: () {
                                  unawaited(HapticFeedback.selectionClick());
                                  setState(() {
                                    _frontUploaded = false;
                                    _backUploaded = false;
                                  });
                                },
                                onBackRemove: () {
                                  unawaited(HapticFeedback.selectionClick());
                                  setState(() => _backUploaded = false);
                                },
                              ),
                              _SecurityCard(snapshot: snapshot),
                              VitCtaButton(
                                key: P2PIdentityVerificationPage.submitKey,
                                onPressed: _frontUploaded && _backUploaded
                                    ? () {
                                        unawaited(
                                          HapticFeedback.selectionClick(),
                                        );
                                        context.go(snapshot.nextRoute);
                                      }
                                    : null,
                                trailing: const Icon(
                                  Icons.chevron_right_rounded,
                                ),
                                child: const Text('Tiếp tục'),
                              ),
                            ],
                            const VitCard(
                              variant: VitCardVariant.inner,
                              padding: EdgeInsetsDirectional.all(AppSpacing.x3),
                              child: VitHighRiskStatePanel(
                                state: VitHighRiskUiState.riskReview,
                                title: 'Xem lại giấy tờ định danh',
                                message:
                                    'Loại giấy tờ, trạng thái tải mặt trước/sau, cảnh báo bảo mật, lộ trình KYC và bước xác minh tiếp theo đã được xem trước khi tiếp tục.',
                                contractId: 'p2p-identity-verification-review',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
