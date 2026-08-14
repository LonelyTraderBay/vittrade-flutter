import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/auth_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/auth_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/widgets/auth_hero_icon_box.dart';

part '../../phone/widgets/two_fa_setup_steps.dart';
part '../../phone/widgets/two_fa_setup_qr.dart';
part '../../phone/widgets/two_fa_setup_verify.dart';
part '../../phone/widgets/two_fa_setup_backup.dart';

const _authPrimary = AppColors.primary;
const _authPrimary10 = AppColors.primary12;
const _authPrimary20 = AppColors.primary20;
const _authPrimary30 = AppColors.primary30;
const _authStepInactive = AppColors.surface3;
const _secretKey = 'JBSWY3DPEHPK3PXP';
const _backupCodes = [
  '84923-13721',
  '29381-84752',
  '56743-29187',
  '93847-65432',
  '12837-49283',
];

class TwoFASetupPage extends ConsumerStatefulWidget {
  const TwoFASetupPage({super.key});

  static const contentKey = Key('sc004_two_fa_content');
  static const copyKey = Key('sc004_two_fa_copy');
  static const codeFieldKey = Key('sc004_two_fa_code_field');
  static const backupSavedKey = Key('sc004_two_fa_backup_saved');
  static const submitKey = Key('sc004_two_fa_submit');

  @override
  ConsumerState<TwoFASetupPage> createState() => _TwoFASetupPageState();
}

class _TwoFASetupPageState extends ConsumerState<TwoFASetupPage> {
  final _codeController = TextEditingController();
  final _codeFocusNode = FocusNode();

  int _step = 1;
  bool _copied = false;
  bool _backupCodesSaved = false;
  bool _submitting = false;
  String _error = '';

  @override
  void dispose() {
    _codeController.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  String get _code => _codeController.text;

  void _goBack() {
    goBackOrFallback(
      context,
      fallbackPath: AppRoutePaths.authOtp,
      mode: BackNavigationMode.historyThenFallback,
    );
  }

  Future<void> _copySecret() async {
    if (mounted) setState(() => _copied = true);
    await Clipboard.setData(const ClipboardData(text: _secretKey));
  }

  void _nextFromQr() {
    setState(() {
      _step = 2;
      _error = '';
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _codeFocusNode.requestFocus();
    });
  }

  void _handleCodeChanged(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    final next = digits.length > 6 ? digits.substring(0, 6) : digits;
    if (_codeController.text != next) {
      _codeController.value = TextEditingValue(
        text: next,
        selection: TextSelection.collapsed(offset: next.length),
      );
    }
    if (_error.isNotEmpty) {
      setState(() => _error = '');
      return;
    }
    setState(() {});
  }

  Future<void> _verifyCode() async {
    if (_submitting || _code.length != 6) return;
    setState(() {
      _submitting = true;
      _error = '';
    });

    try {
      final result = await ref
          .read(authControllerProvider)
          .verifyFactor(
            contact: 'user@vittrade.vn',
            code: _code,
            purpose: AuthOtpPurpose.twoFactor,
          );

      if (!mounted) return;
      if (!result.success) {
        setState(() {
          _error = result.errorMessage ?? 'Mã xác thực không đúng.';
          _codeController.clear();
        });
        _codeFocusNode.requestFocus();
        return;
      }

      setState(() => _step = 3);
    } catch (error) {
      if (mounted) {
        setState(() {
          _error = authOperationErrorMessage(error);
          _codeController.clear();
        });
        _codeFocusNode.requestFocus();
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _completeSetup() async {
    if (_submitting || !_backupCodesSaved) return;
    setState(() {
      _submitting = true;
      _error = '';
    });

    try {
      final result = await ref
          .read(authControllerProvider)
          .setupTwoFactor(
            secretKey: _secretKey,
            code: _code,
            backupCodesSaved: _backupCodesSaved,
          );

      if (!mounted) return;
      if (!result.success) {
        setState(() {
          _error =
              result.errorMessage ??
              'Không thể hoàn tất 2FA. Vui lòng thử lại.';
        });
        return;
      }

      context.go(AppRoutePaths.home);
    } catch (error) {
      if (mounted) {
        setState(() => _error = authOperationErrorMessage(error));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  VoidCallback? get _primaryAction {
    if (_submitting) return null;
    if (_step == 1) return _nextFromQr;
    if (_step == 2) return _code.length == 6 ? _verifyCode : null;
    return _backupCodesSaved ? _completeSetup : null;
  }

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      semanticLabel: 'Thiết lập 2FA',
      semanticIdentifier: 'SC-004',
      child: VitAutoHideHeaderScaffold(
        header: VitHeader(
          title: 'Thiết lập 2FA',
          subtitle: 'Xác thực · Bảo mật',
          showBack: true,
          onBack: _goBack,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TwoFaStepper(step: _step),
            Expanded(
              child: SingleChildScrollView(
                key: TwoFASetupPage.contentKey,
                padding: AuthSpacingTokens.authScrollBottomPadding,
                child: VitPageContent(
                  rhythm: VitPageRhythm.form,
                  children: [
                    if (_step == 1)
                      _QrStep(onCopy: _copySecret, copied: _copied),
                    if (_step == 2)
                      _VerifyStep(
                        controller: _codeController,
                        focusNode: _codeFocusNode,
                        error: _error,
                        onChanged: _handleCodeChanged,
                      ),
                    if (_step == 3)
                      _BackupCodesStep(
                        saved: _backupCodesSaved,
                        error: _error,
                        onSavedChanged: () {
                          setState(() {
                            _backupCodesSaved = !_backupCodesSaved;
                            _error = '';
                          });
                        },
                      ),
                    VitCtaButton(
                      key: TwoFASetupPage.submitKey,
                      onPressed: _primaryAction,
                      loading: _submitting,
                      variant: _step == 3
                          ? VitCtaButtonVariant.success
                          : VitCtaButtonVariant.auth,
                      trailing: _step == 1
                          ? const Icon(Icons.chevron_right_rounded)
                          : null,
                      leading: _step == 3
                          ? const Icon(Icons.check_rounded)
                          : null,
                      child: Text(_buttonLabel),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _buttonLabel {
    if (_submitting && _step == 2) return 'Đang xác minh...';
    if (_submitting && _step == 3) return 'Đang hoàn tất...';
    if (_step == 1) return 'Tiếp theo';
    if (_step == 2) return 'Xác nhận';
    return 'Hoàn tất thiết lập 2FA';
  }
}
