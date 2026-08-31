import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/auth_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/auth/presentation/controllers/password_reset_flow_controller.dart';
import 'package:vit_trade_flutter/features/auth/presentation/tablet/widgets/auth_tablet_surface.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Independent Tablet composition for SC-003.
class OtpTabletPage extends ConsumerStatefulWidget {
  const OtpTabletPage({
    super.key,
    this.contact = 'your@email.com',
    this.contactType = AuthContactType.email,
    this.purpose = AuthOtpPurpose.verify,
  });

  final String contact;
  final AuthContactType contactType;
  final AuthOtpPurpose purpose;

  static const contentKey = Key('sc003_otp_content');
  static const codeFieldKey = Key('sc003_otp_code_field');
  static const submitKey = Key('sc003_otp_submit');

  @override
  ConsumerState<OtpTabletPage> createState() => _OtpTabletPageState();
}

class _OtpTabletPageState extends ConsumerState<OtpTabletPage> {
  final _codeController = TextEditingController();
  bool _submitting = false;
  String _error = '';

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final code = _codeController.text.trim();
    if (_submitting) return;
    if (code.length != 6) {
      setState(() => _error = 'Vui lòng nhập đủ 6 chữ số xác minh.');
      return;
    }
    setState(() {
      _error = '';
      _submitting = true;
    });
    try {
      final result = await ref
          .read(authControllerProvider)
          .verifyFactor(
            contact: widget.contact,
            code: code,
            purpose: widget.purpose,
          );
      if (!result.success) {
        if (mounted) {
          setState(
            () => _error = result.errorMessage ?? 'Mã xác minh chưa đúng.',
          );
        }
        return;
      }
      if (!mounted) return;
      switch (widget.purpose) {
        case AuthOtpPurpose.register:
          context.go(AppRoutePaths.auth2faSetup);
        case AuthOtpPurpose.twoFactor:
          context.go(AppRoutePaths.home);
        case AuthOtpPurpose.passwordReset:
        case AuthOtpPurpose.verify:
          ref
              .read(passwordResetChallengeProvider.notifier)
              .save(email: widget.contact, otp: code);
          context.go(AppRoutePaths.authResetPassword);
      }
    } catch (error) {
      if (mounted) setState(() => _error = authOperationErrorMessage(error));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final channel = widget.contactType == AuthContactType.email
        ? 'email'
        : 'số điện thoại';
    return AuthTabletSurface(
      semanticLabel: 'Xác minh OTP tablet',
      semanticIdentifier: 'SC-003-TABLET',
      title: 'Xác minh OTP',
      subtitle: 'Mã xác minh đã được gửi qua $channel',
      onBack: () => context.go(AppRoutePaths.authLogin),
      child: Column(
        key: OtpTabletPage.contentKey,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthTabletInfoBanner(
            message: 'Mã đang được gửi đến ${widget.contact}.',
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
          VitInput(
            controller: _codeController,
            fieldKey: OtpTabletPage.codeFieldKey,
            label: 'Mã xác minh 6 chữ số',
            hintText: '000000',
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            textInputAction: TextInputAction.done,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            onChanged: (_) {
              if (_error.isNotEmpty) setState(() => _error = '');
            },
            onSubmitted: (_) => _submit(),
          ),
          if (_error.isNotEmpty) ...[
            const SizedBox(
              height: TabletSpacingTokens.pageRhythmStandardSectionGap,
            ),
            AuthTabletErrorBanner(message: _error),
          ],
          const SizedBox(height: TabletSpacingTokens.x4),
          VitCtaButton(
            key: OtpTabletPage.submitKey,
            onPressed: _submitting ? null : _submit,
            loading: _submitting,
            variant: VitCtaButtonVariant.auth,
            child: const Text('Xác minh và tiếp tục'),
          ),
        ],
      ),
    );
  }
}
