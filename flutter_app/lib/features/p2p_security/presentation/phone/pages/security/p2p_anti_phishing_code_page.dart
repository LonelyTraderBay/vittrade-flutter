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

part '../../../widgets/security/p2p_anti_phishing_code_page_sections.dart';
part '../../../widgets/security/p2p_anti_phishing_code_page_common.dart';

class P2PAntiPhishingCodePage extends ConsumerStatefulWidget {
  const P2PAntiPhishingCodePage({super.key, this.shellRenderMode});

  static const statusKey = Key('sc256_p2p_anti_phishing_status');
  static const explainerKey = Key('sc256_p2p_anti_phishing_explainer');
  static const codeCardKey = Key('sc256_p2p_anti_phishing_code_card');
  static const examplesKey = Key('sc256_p2p_anti_phishing_examples');
  static const warningKey = Key('sc256_p2p_anti_phishing_warning');
  static const revealKey = Key('sc256_p2p_anti_phishing_reveal');
  static const copyKey = Key('sc256_p2p_anti_phishing_copy');
  static const editKey = Key('sc256_p2p_anti_phishing_edit');
  static const inputKey = Key('sc256_p2p_anti_phishing_input');
  static const generateKey = Key('sc256_p2p_anti_phishing_generate');
  static const saveKey = Key('sc256_p2p_anti_phishing_save');
  static const saveConfirmKey = Key('sc256_p2p_anti_phishing_save_confirm');
  static const saveCancelKey = Key('sc256_p2p_anti_phishing_save_cancel');

  static Key exampleKey(String id) =>
      Key('sc256_p2p_anti_phishing_example_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PAntiPhishingCodePage> createState() =>
      _P2PAntiPhishingCodePageState();
}

class _P2PAntiPhishingCodePageState
    extends ConsumerState<P2PAntiPhishingCodePage> {
  // GD4 bẫy 14: initState-seed từ getter giờ-đã-async — bỏ initState, dùng
  // field nullable + `??=` trong nhánh data:.
  TextEditingController? _codeController;
  String? _code;
  bool? _editing;
  bool _showCode = false;

  @override
  void dispose() {
    _codeController?.removeListener(_handleCodeChanged);
    _codeController?.dispose();
    super.dispose();
  }

  void _handleCodeChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pAntiPhishingCodeProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x4
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x3) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Mã chống lừa đảo P2P',
      semanticIdentifier: 'SC-256',
      child: Material(
        type: MaterialType.transparency,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2pSecurityCenter),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2pSecurityCenter),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(p2pAntiPhishingCodeProvider),
            ),
          ),
          data: (snapshot) {
            if (_codeController == null) {
              _code = snapshot.currentCode;
              _editing = !snapshot.hasCode;
              _codeController = TextEditingController(text: _code)
                ..addListener(_handleCodeChanged);
            }
            return VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: 'Mã chống phishing',
                subtitle: 'Bảo mật · P2P',
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
                        padding:
                            P2PSpacingTokens.p2pSecurityDetailsScrollPadding(
                              bottomInset,
                            ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _StatusCard(snapshot: snapshot),
                            const SizedBox(
                              height: AppSpacing.pageRhythmStandardInnerGap,
                            ),
                            _ExplainerCard(snapshot: snapshot),
                            const SizedBox(
                              height: AppSpacing.pageRhythmStandardInnerGap,
                            ),
                            VitSectionHeader(
                              title: _editing!
                                  ? 'Thiết lập code'
                                  : 'Code hiện tại',
                              bottomGap: AppSpacing.pageRhythmStandardInnerGap,
                            ),
                            _editing!
                                ? _editCodeCard()
                                : _currentCodeCard(code: _code!),
                            const SizedBox(
                              height: AppSpacing.pageRhythmStandardInnerGap,
                            ),
                            const VitSectionHeader(
                              title: 'Ví dụ email',
                              bottomGap: AppSpacing.pageRhythmStandardInnerGap,
                            ),
                            _EmailExamples(examples: snapshot.examples),
                            const SizedBox(
                              height: AppSpacing.pageRhythmStandardInnerGap,
                            ),
                            _WarningCard(snapshot: snapshot),
                            const VitPageContent(
                              rhythm: VitPageRhythm.standard,
                              padding: VitContentPadding.none,
                              fullBleed: true,
                              children: [
                                VitHighRiskStatePanel(
                                  state: VitHighRiskUiState.riskReview,
                                  title: 'Xem lại trạng thái mã chống phishing',
                                  message:
                                      'Khả năng hiển thị mã hiện tại, trạng thái chỉnh sửa, ví dụ, nội dung cảnh báo và mức sẵn sàng lưu vẫn hiển thị trước khi thay đổi bảo mật email P2P.',
                                  contractId: 'SC-256',
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
            );
          },
        ),
      ),
    );
  }

  Widget _currentCodeCard({required String code}) {
    return VitCard(
      key: P2PAntiPhishingCodePage.codeCardKey,
      radius: VitCardRadius.large,
      padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Mã của bạn',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _IconAction(
                key: P2PAntiPhishingCodePage.revealKey,
                icon: _showCode
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                onTap: () {
                  unawaited(HapticFeedback.selectionClick());
                  setState(() => _showCode = !_showCode);
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Material(
            color: AppColors.surface2,
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.inputRadius,
              side: BorderSide(color: AppColors.borderSolid),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.x3,
                vertical: AppSpacing.x2,
              ),
              child: Center(
                child: Text(
                  _showCode ? code : List.filled(code.length, '•').join(),
                  style: AppTextStyles.baseMedium.copyWith(
                    fontFeatures: AppTextStyles.tabularFigures,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Expanded(
                child: _SoftActionButton(
                  key: P2PAntiPhishingCodePage.copyKey,
                  label: 'Sao chép',
                  icon: Icons.copy_rounded,
                  color: AppModuleAccents.p2p,
                  onTap: () {
                    unawaited(HapticFeedback.selectionClick());
                    unawaited(Clipboard.setData(ClipboardData(text: _code!)));
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _SoftActionButton(
                  key: P2PAntiPhishingCodePage.editKey,
                  label: 'Đổi code',
                  icon: Icons.edit_outlined,
                  color: AppColors.text2,
                  onTap: () {
                    unawaited(HapticFeedback.selectionClick());
                    _codeController!.text = _code!;
                    setState(() => _editing = true);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _editCodeCard() {
    return VitCard(
      key: P2PAntiPhishingCodePage.codeCardKey,
      radius: VitCardRadius.large,
      padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitInput(
            controller: _codeController!,
            fieldKey: P2PAntiPhishingCodePage.inputKey,
            label: 'Mã chống phishing',
            hintText: 'Nhập code tối thiểu 6 ký tự',
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              LengthLimitingTextInputFormatter(20),
              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9_-]')),
            ],
            onChanged: (value) {
              final upper = value.toUpperCase();
              if (upper != value) {
                _codeController!.value = TextEditingValue(
                  text: upper,
                  selection: TextSelection.collapsed(offset: upper.length),
                );
              }
            },
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          _SoftActionButton(
            key: P2PAntiPhishingCodePage.generateKey,
            label: 'Tạo code ngẫu nhiên',
            icon: Icons.refresh_rounded,
            color: AppColors.text1,
            onTap: () {
              unawaited(HapticFeedback.selectionClick());
              _codeController!.text = 'SEC8F2K9';
            },
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          VitCtaButton(
            key: P2PAntiPhishingCodePage.saveKey,
            variant: VitCtaButtonVariant.success,
            onPressed: _codeController!.text.trim().length < 6
                ? null
                : _confirmSaveCode,
            leading: const Icon(Icons.check_circle_outline_rounded),
            child: const Text('Lưu code'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmSaveCode() async {
    final proposedCode = _codeController!.text.trim().toUpperCase();
    if (proposedCode.length < 6) return;

    final confirmed = await showVitConfirmDialog(
      context: context,
      title: 'Xác nhận thay đổi mã chống lừa đảo',
      message:
          'Mã mới sẽ dùng để nhận diện thông báo P2P chính thức. Không chia sẻ mã này và hãy kiểm tra lại trước khi áp dụng.',
      rows: [
        VitConfirmDialogRow(
          label: 'Mã mới (đã che)',
          value: _maskCode(proposedCode),
        ),
        const VitConfirmDialogRow(
          label: 'Bước tiếp theo',
          value: 'Kiểm tra mã trong email P2P tiếp theo',
        ),
      ],
      confirmLabel: 'Áp dụng mã mới',
      confirmKey: P2PAntiPhishingCodePage.saveConfirmKey,
      cancelKey: P2PAntiPhishingCodePage.saveCancelKey,
    );
    if (!mounted || !confirmed) return;

    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _code = proposedCode;
      _showCode = true;
      _editing = false;
    });
  }

  static String _maskCode(String code) {
    if (code.length <= 4) return List.filled(code.length, '•').join();
    final middle = List.filled(code.length - 4, '•').join();
    return '${code.substring(0, 2)}$middle${code.substring(code.length - 2)}';
  }
}
