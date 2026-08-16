import 'dart:async';

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
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/auth_controller_providers.dart';
import 'package:vit_trade_flutter/features/auth/presentation/controllers/password_reset_flow_controller.dart';
import 'package:vit_trade_flutter/app/theme/spacing/auth_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/widgets/auth_hero_icon_box.dart';

part '../../phone/widgets/otp_identity_intro.dart';
part '../../phone/widgets/otp_input_status.dart';

const _authPrimary = AppColors.primary;
const _authPrimary10 = AppColors.primary12;
const _authPrimary30 = AppColors.primary30;
const _freezeAuthCountdownForQa = bool.fromEnvironment('FREEZE_AUTH_COUNTDOWN');

class OTPPage extends ConsumerStatefulWidget {
  const OTPPage({
    super.key,
    this.contact = 'your@email.com',
    this.contactType = AuthContactType.email,
    this.purpose = AuthOtpPurpose.verify,
  });

  final String contact;
  final AuthContactType contactType;
  final AuthOtpPurpose purpose;

  static const contentKey = Key('sc003_otp_content');
  static const submitKey = Key('sc003_otp_submit');
  static const resendKey = Key('sc003_otp_resend');

  static Key digitFieldKey(int index) => Key('sc003_otp_digit_$index');

  @override
  ConsumerState<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends ConsumerState<OTPPage> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  Timer? _timer;

  bool _submitting = false;
  bool _canResend = false;
  int _countdown = 58;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(6, (_) => TextEditingController());
    _focusNodes = List.generate(6, (_) => FocusNode());
    _startCountdown();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNodes.first.requestFocus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  String get _code => _controllers.map((controller) => controller.text).join();

  int get _filledCount =>
      _controllers.where((controller) => controller.text.isNotEmpty).length;

  void _startCountdown() {
    _timer?.cancel();
    if (_freezeAuthCountdownForQa) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_countdown <= 0) {
        timer.cancel();
        setState(() => _canResend = true);
        return;
      }
      setState(() => _countdown -= 1);
    });
  }

  void _handleChanged(int index, String value) {
    final digit = value.replaceAll(RegExp(r'\D'), '');
    final normalized = digit.isEmpty ? '' : digit[digit.length - 1];
    if (_controllers[index].text != normalized) {
      _controllers[index].value = TextEditingValue(
        text: normalized,
        selection: TextSelection.collapsed(offset: normalized.length),
      );
    }

    if (_error.isNotEmpty) setState(() => _error = '');
    if (normalized.isNotEmpty && index < _focusNodes.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    if (_filledCount == 6) {
      unawaited(_handleVerify());
    } else {
      setState(() {});
    }
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event, int index) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  Future<void> _handleVerify() async {
    if (_submitting || _filledCount < 6) return;
    setState(() {
      _submitting = true;
      _error = '';
    });

    try {
      final result = await ref
          .read(authControllerProvider)
          .verifyFactor(
            contact: widget.contact,
            code: _code,
            purpose: widget.purpose,
          );

      if (!mounted) return;
      if (!result.success) {
        _clearOtp(
          error: result.errorMessage ?? 'Mã OTP không đúng. Vui lòng thử lại.',
        );
        return;
      }

      switch (widget.purpose) {
        case AuthOtpPurpose.register:
          context.go(AppRoutePaths.auth2faSetup);
        case AuthOtpPurpose.twoFactor:
          context.go(AppRoutePaths.home);
        case AuthOtpPurpose.passwordReset:
          _savePasswordResetChallenge();
          context.go(AppRoutePaths.authResetPassword);
        case AuthOtpPurpose.verify:
          _savePasswordResetChallenge();
          context.go(AppRoutePaths.authResetPassword);
      }
    } catch (error) {
      if (mounted) _clearOtp(error: authOperationErrorMessage(error));
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  void _savePasswordResetChallenge() {
    ref
        .read(passwordResetChallengeControllerProvider)
        .save(email: widget.contact, otp: _code);
  }

  void _clearOtp({required String error}) {
    for (final controller in _controllers) {
      controller.clear();
    }
    setState(() => _error = error);
    _focusNodes.first.requestFocus();
  }

  void _handleResend() {
    if (!_canResend) return;
    for (final controller in _controllers) {
      controller.clear();
    }
    setState(() {
      _canResend = false;
      _countdown = 59;
      _error = '';
    });
    _focusNodes.first.requestFocus();
    _startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    final filled = _filledCount;

    return VitPageLayout(
      semanticLabel: 'Xác minh OTP',
      semanticIdentifier: 'SC-003',
      child: VitAutoHideHeaderScaffold(
        header: VitHeader(
          title: 'Xác minh OTP',
          subtitle: 'Xác thực · Bảo mật',
          showBack: true,
          onBack: () => context.go(AppRoutePaths.authLogin),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                key: OTPPage.contentKey,
                padding: AuthSpacingTokens.authScrollBottomPadding,
                child: VitPageContent(
                  rhythm: VitPageRhythm.form,
                  children: [
                    const VitCard(
                      variant: VitCardVariant.ghost,
                      borderColor: _authPrimary30,
                      padding: AuthSpacingTokens.authSurfaceCompactPadding,
                      child: Align(
                        alignment: Alignment.center,
                        child: AuthHeroIconBox(
                          dimension: AuthSpacingTokens.authHeroIconBoxMd,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadii.cardLargeRadius,
                            side: BorderSide(
                              color: _authPrimary30,
                              width: AppSpacing.borderWidth,
                            ),
                          ),
                          fillColor: _authPrimary10,
                          child: Icon(
                            Icons.gpp_good_outlined,
                            color: _authPrimary,
                            size: AuthSpacingTokens.authHeroIconLg,
                          ),
                        ),
                      ),
                    ),
                    VitCard(
                      padding: AuthSpacingTokens.authSurfacePadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _OtpIntro(contact: widget.contact),
                          const Padding(
                            padding: AuthSpacingTokens.authTopGapX4,
                          ),
                          _OtpDigitRow(
                            controllers: _controllers,
                            focusNodes: _focusNodes,
                            hasError: _error.isNotEmpty,
                            onChanged: _handleChanged,
                            onKey: _handleKey,
                          ),
                          const Padding(
                            padding: AuthSpacingTokens.authTopGapX3,
                          ),
                          _OtpProgress(filled: filled),
                          if (_error.isNotEmpty) ...[
                            const Padding(
                              padding: AuthSpacingTokens.authTopGapX3,
                            ),
                            VitBanner(
                              variant: VitBannerVariant.error,
                              message: _error,
                            ),
                          ],
                          const Padding(
                            padding: AuthSpacingTokens.authTopGapX4,
                          ),
                          VitCtaButton(
                            key: OTPPage.submitKey,
                            onPressed: filled < 6 || _submitting
                                ? null
                                : _handleVerify,
                            loading: _submitting,
                            variant: VitCtaButtonVariant.auth,
                            child: Text(
                              _submitting ? 'Đang xác minh...' : 'Xác nhận',
                            ),
                          ),
                        ],
                      ),
                    ),
                    VitCard(
                      variant: VitCardVariant.ghost,
                      borderColor: AppColors.cardBorder,
                      padding: AuthSpacingTokens.authSurfaceCompactPadding,
                      child: Column(
                        children: [
                          _ResendControl(
                            canResend: _canResend,
                            countdown: _countdown,
                            onResend: _handleResend,
                          ),
                          const Padding(
                            padding: AuthSpacingTokens.authTopGapX3,
                          ),
                          Text(
                            'Không nhận được? Kiểm tra thư mục Spam hoặc\n'
                            'đảm bảo email / SĐT chính xác.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text3,
                              height: AuthSpacingTokens.authFooterLineHeight,
                            ),
                          ),
                        ],
                      ),
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
}
