import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/router/contracts/auth_route_args.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/auth_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/auth_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/auth/domain/validators/password_policy.dart';

part '../../phone/widgets/register_page_sections.dart';

const _authPrimary = AppColors.primary;

enum _RegisterContactType { email, phone }

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  static const contentKey = Key('sc002_register_content');
  static const emailTabKey = Key('sc002_register_email_tab');
  static const phoneTabKey = Key('sc002_register_phone_tab');
  static const nameFieldKey = Key('sc002_register_name_field');
  static const contactFieldKey = Key('sc002_register_contact_field');
  static const passwordFieldKey = Key('sc002_register_password_field');
  static const confirmFieldKey = Key('sc002_register_confirm_field');
  static const referralFieldKey = Key('sc002_register_referral_field');
  static const passwordToggleKey = Key('sc002_register_password_toggle');
  static const agreementKey = Key('sc002_register_agreement');
  static const submitKey = Key('sc002_register_submit');
  static const loginKey = Key('sc002_register_login');

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _referralController = TextEditingController();

  _RegisterContactType _contactType = _RegisterContactType.email;
  bool _showPassword = false;
  bool _agreed = false;
  bool _submitting = false;
  Map<String, String> _errors = const {};

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  void _setContactType(_RegisterContactType value) {
    if (_contactType == value) return;
    setState(() {
      _contactType = value;
      _errors = {..._errors}..remove('contact');
    });
  }

  void _clearError(String key) {
    setState(() {
      final nextErrors = {..._errors}..remove(key);
      _errors = nextErrors;
    });
  }

  void _formatReferral(String value) {
    final formatted = value.toUpperCase();
    if (value == formatted) return;
    _referralController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  bool _validate() {
    final nextErrors = <String, String>{};
    final contact = _contactController.text.trim();
    final password = _passwordController.text;

    if (_nameController.text.trim().isEmpty) {
      nextErrors['name'] = 'Vui lòng nhập họ tên';
    }
    if (contact.isEmpty) {
      nextErrors['contact'] = _contactType == _RegisterContactType.email
          ? 'Vui lòng nhập email'
          : 'Vui lòng nhập số điện thoại';
    } else if (_contactType == _RegisterContactType.email &&
        !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(contact)) {
      nextErrors['contact'] = 'Email không hợp lệ';
    }
    if (password.length < 8) {
      nextErrors['password'] = 'Mật khẩu tối thiểu 8 ký tự';
    } else if (!passwordMeetsPolicy(password)) {
      nextErrors['password'] = 'Mật khẩu cần chữ hoa, chữ thường và chữ số';
    }
    if (password != _confirmController.text) {
      nextErrors['confirm'] = 'Mật khẩu xác nhận không khớp';
    }
    if (!_agreed) {
      nextErrors['agreed'] = 'Vui lòng đồng ý điều khoản dịch vụ';
    }

    setState(() => _errors = nextErrors);
    return nextErrors.isEmpty;
  }

  Future<void> _handleRegister() async {
    if (_submitting || !_validate()) return;

    setState(() => _submitting = true);
    try {
      await ref
          .read(authControllerProvider)
          .register(
            name: _nameController.text.trim(),
            contact: _contactController.text.trim(),
            contactType: _contactType == _RegisterContactType.email
                ? AuthContactType.email
                : AuthContactType.phone,
            password: _passwordController.text,
            referralCode: _referralController.text.trim().isEmpty
                ? null
                : _referralController.text.trim(),
          );
      if (mounted) {
        context.go(
          AppRoutePaths.authOtp,
          extra: OtpPageRouteArgs(
            contact: _contactController.text.trim(),
            contactType: _contactType == _RegisterContactType.email
                ? AuthContactType.email
                : AuthContactType.phone,
            purpose: AuthOtpPurpose.register,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        setState(() => _errors = {'form': authOperationErrorMessage(error)});
      }
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEmail = _contactType == _RegisterContactType.email;

    return VitPageLayout(
      semanticLabel: 'Tạo tài khoản',
      semanticIdentifier: 'SC-002',
      child: VitAutoHideHeaderScaffold(
        header: VitHeader(
          title: 'Tạo tài khoản',
          subtitle: 'Xác thực · Đăng ký',
          showBack: true,
          onBack: () => context.go(AppRoutePaths.authLogin),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                key: RegisterPage.contentKey,
                padding: AuthSpacingTokens.authScrollBottomPadding,
                child: AutofillGroup(
                  child: VitPageContent(
                    rhythm: VitPageRhythm.form,
                    children: [
                      VitCard(
                        variant: VitCardVariant.inner,
                        padding: AuthSpacingTokens.authSurfaceCompactPadding,
                        child: VitSegmentedChoice.withPrimaryAccent(
                          selected: _contactType,
                          onChanged: _setContactType,
                          height: AuthSpacingTokens.authSegmentedHeight,
                          options: [
                            const VitSegmentedChoiceOption(
                              value: _RegisterContactType.email,
                              label: 'Email',
                              key: RegisterPage.emailTabKey,
                            ),
                            const VitSegmentedChoiceOption(
                              value: _RegisterContactType.phone,
                              label: 'Điện thoại',
                              key: RegisterPage.phoneTabKey,
                            ),
                          ],
                        ),
                      ),
                      VitCard(
                        padding: AuthSpacingTokens.authSurfacePadding,
                        child: VitPageSection(
                          customGap: AppSpacing.pageRhythmFormSectionGap,
                          children: [
                            VitInput(
                              controller: _nameController,
                              fieldKey: RegisterPage.nameFieldKey,
                              label: 'Họ và tên',
                              hintText: 'Nguyễn Văn A',
                              prefix: const Icon(Icons.person_outline_rounded),
                              errorText: _errors['name'],
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.name],
                              onChanged: (_) => _clearError('name'),
                            ),
                            VitInput(
                              controller: _contactController,
                              fieldKey: RegisterPage.contactFieldKey,
                              label: isEmail ? 'Email' : 'Số điện thoại',
                              hintText: isEmail
                                  ? 'you@example.com'
                                  : '+84 912 345 678',
                              prefix: Icon(
                                isEmail
                                    ? Icons.mail_outline_rounded
                                    : Icons.phone_iphone_rounded,
                              ),
                              errorText: _errors['contact'],
                              keyboardType: isEmail
                                  ? TextInputType.emailAddress
                                  : TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              autofillHints: isEmail
                                  ? const [AutofillHints.email]
                                  : const [AutofillHints.telephoneNumber],
                              onChanged: (_) => _clearError('contact'),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                VitInput(
                                  controller: _passwordController,
                                  fieldKey: RegisterPage.passwordFieldKey,
                                  label: 'Mật khẩu',
                                  hintText: '••••••••',
                                  prefix: const Icon(
                                    Icons.lock_outline_rounded,
                                  ),
                                  suffix: VitIconButton(
                                    key: RegisterPage.passwordToggleKey,
                                    icon: _showPassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    tooltip: _showPassword
                                        ? 'Ẩn mật khẩu'
                                        : 'Hiện mật khẩu',
                                    onPressed: () {
                                      setState(
                                        () => _showPassword = !_showPassword,
                                      );
                                    },
                                    variant: VitIconButtonVariant.transparent,
                                    size: VitIconButtonSize.sm,
                                  ),
                                  errorText: _errors['password'],
                                  obscureText: !_showPassword,
                                  textInputAction: TextInputAction.next,
                                  autofillHints: const [
                                    AutofillHints.newPassword,
                                  ],
                                  onChanged: (_) => _clearError('password'),
                                ),
                                if (_passwordController.text.isNotEmpty)
                                  Padding(
                                    padding: AuthSpacingTokens.authTopGapX3,
                                    child: _PasswordStrength(
                                      password: _passwordController.text,
                                    ),
                                  ),
                              ],
                            ),
                            VitInput(
                              controller: _confirmController,
                              fieldKey: RegisterPage.confirmFieldKey,
                              label: 'Xác nhận mật khẩu',
                              hintText: '••••••••',
                              prefix: const Icon(Icons.lock_outline_rounded),
                              errorText: _errors['confirm'],
                              obscureText: !_showPassword,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.newPassword],
                              onChanged: (_) => _clearError('confirm'),
                            ),
                            VitInput(
                              controller: _referralController,
                              fieldKey: RegisterPage.referralFieldKey,
                              label: 'Mã giới thiệu (tuỳ chọn)',
                              hintText: 'VD: VITTA-A2B3C',
                              textCapitalization: TextCapitalization.characters,
                              inputFormatters: const [],
                              textInputAction: TextInputAction.done,
                              onChanged: (value) {
                                _formatReferral(value);
                                _clearError('referral');
                              },
                              onSubmitted: (_) => _handleRegister(),
                            ),
                            _AgreementRow(
                              agreed: _agreed,
                              error: _errors['agreed'],
                              onTap: () {
                                setState(() {
                                  _agreed = !_agreed;
                                  final nextErrors = {..._errors}
                                    ..remove('agreed');
                                  _errors = nextErrors;
                                });
                              },
                            ),
                            if (_errors['form'] case final formError?)
                              VitBanner(
                                variant: VitBannerVariant.error,
                                message: formError,
                                icon: Icons.error_outline_rounded,
                              ),
                            VitCtaButton(
                              key: RegisterPage.submitKey,
                              onPressed: _submitting ? null : _handleRegister,
                              loading: _submitting,
                              variant: VitCtaButtonVariant.auth,
                              child: const Text('Tiếp tục'),
                            ),
                          ],
                        ),
                      ),
                      VitCard(
                        variant: VitCardVariant.ghost,
                        borderColor: AppColors.cardBorder,
                        padding: AuthSpacingTokens.authSurfaceCompactPadding,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Đã có tài khoản?',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                              ),
                            ),
                            VitCtaButton(
                              key: RegisterPage.loginKey,
                              onPressed: _submitting
                                  ? null
                                  : () => context.go(AppRoutePaths.authLogin),
                              variant: VitCtaButtonVariant.ghost,
                              fullWidth: false,
                              height: AuthSpacingTokens.authTextButtonHeight,
                              padding:
                                  AuthSpacingTokens.authInlineTextButtonPadding,
                              child: Text(
                                'Đăng nhập',
                                style: AppTextStyles.caption.copyWith(
                                  color: _authPrimary,
                                  fontWeight: AppTextStyles.medium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
