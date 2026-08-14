import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/auth_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/router/contracts/auth_route_args.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/auth/domain/validators/password_policy.dart';
import 'package:vit_trade_flutter/features/auth/presentation/tablet/widgets/auth_tablet_surface.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Independent Tablet composition for SC-002.
class RegisterTabletPage extends ConsumerStatefulWidget {
  const RegisterTabletPage({super.key});

  static const contentKey = Key('sc002_register_content');
  static const emailTabKey = Key('sc002_register_email_tab');
  static const phoneTabKey = Key('sc002_register_phone_tab');
  static const nameFieldKey = Key('sc002_register_name_field');
  static const contactFieldKey = Key('sc002_register_contact_field');
  static const passwordFieldKey = Key('sc002_register_password_field');
  static const confirmFieldKey = Key('sc002_register_confirm_field');
  static const referralFieldKey = Key('sc002_register_referral_field');
  static const submitKey = Key('sc002_register_submit');
  static const agreementKey = Key('sc002_register_agreement');

  @override
  ConsumerState<RegisterTabletPage> createState() => _RegisterTabletPageState();
}

class _RegisterTabletPageState extends ConsumerState<RegisterTabletPage> {
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _referralController = TextEditingController();
  AuthContactType _contactType = AuthContactType.email;
  bool _agreed = false;
  bool _submitting = false;
  String _error = '';

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  bool _validate() {
    final name = _nameController.text.trim();
    final contact = _contactController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;
    String? error;
    if (name.isEmpty) {
      error = 'Vui lòng nhập họ và tên.';
    } else if (contact.isEmpty) {
      error = _contactType == AuthContactType.email
          ? 'Vui lòng nhập email.'
          : 'Vui lòng nhập số điện thoại.';
    } else if (password.length < 8 || !passwordMeetsPolicy(password)) {
      error = 'Mật khẩu cần tối thiểu 8 ký tự, chữ hoa, chữ thường và chữ số.';
    } else if (password != confirm) {
      error = 'Mật khẩu xác nhận chưa khớp.';
    } else if (!_agreed) {
      error = 'Vui lòng đồng ý với điều khoản để tiếp tục.';
    }
    setState(() => _error = error ?? '');
    return error == null;
  }

  Future<void> _submit() async {
    if (_submitting || !_validate()) return;
    setState(() => _submitting = true);
    try {
      await ref
          .read(authControllerProvider)
          .register(
            name: _nameController.text.trim(),
            contact: _contactController.text.trim(),
            contactType: _contactType,
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
            contactType: _contactType,
            purpose: AuthOtpPurpose.register,
          ),
        );
      }
    } catch (error) {
      if (mounted) setState(() => _error = authOperationErrorMessage(error));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthTabletSurface(
      semanticLabel: 'Tạo tài khoản tablet',
      semanticIdentifier: 'SC-002-TABLET',
      title: 'Tạo tài khoản',
      subtitle: 'Xác thực thông tin trước khi đăng ký',
      onBack: () => context.go(AppRoutePaths.authLogin),
      child: AutofillGroup(
        key: RegisterTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VitSegmentedChoice<AuthContactType>(
              selected: _contactType,
              onChanged: (value) => setState(() => _contactType = value),
              options: const [
                VitSegmentedChoiceOption(
                  value: AuthContactType.email,
                  label: 'Email',
                  key: RegisterTabletPage.emailTabKey,
                  semanticLabel: 'Đăng ký bằng email',
                ),
                VitSegmentedChoiceOption(
                  value: AuthContactType.phone,
                  label: 'Số điện thoại',
                  key: RegisterTabletPage.phoneTabKey,
                  semanticLabel: 'Đăng ký bằng số điện thoại',
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            VitInput(
              controller: _nameController,
              fieldKey: RegisterTabletPage.nameFieldKey,
              label: 'Họ và tên',
              hintText: 'Nhập tên hiển thị',
              prefix: const Icon(Icons.person_outline_rounded),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSpacing.pageRhythmFormInnerGap),
            VitInput(
              controller: _contactController,
              fieldKey: RegisterTabletPage.contactFieldKey,
              label: _contactType == AuthContactType.email
                  ? 'Email'
                  : 'Số điện thoại',
              hintText: _contactType == AuthContactType.email
                  ? 'Nhập email đã xác minh'
                  : 'Nhập số điện thoại đã xác minh',
              prefix: Icon(
                _contactType == AuthContactType.email
                    ? Icons.mail_outline_rounded
                    : Icons.phone_outlined,
              ),
              keyboardType: _contactType == AuthContactType.email
                  ? TextInputType.emailAddress
                  : TextInputType.phone,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSpacing.pageRhythmFormInnerGap),
            VitInput(
              controller: _passwordController,
              fieldKey: RegisterTabletPage.passwordFieldKey,
              label: 'Mật khẩu',
              hintText: 'Tối thiểu 8 ký tự',
              prefix: const Icon(Icons.lock_outline_rounded),
              obscureText: true,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSpacing.pageRhythmFormInnerGap),
            VitInput(
              controller: _confirmController,
              fieldKey: RegisterTabletPage.confirmFieldKey,
              label: 'Xác nhận mật khẩu',
              hintText: 'Nhập lại mật khẩu',
              prefix: const Icon(Icons.lock_reset_outlined),
              obscureText: true,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSpacing.pageRhythmFormInnerGap),
            VitInput(
              controller: _referralController,
              fieldKey: RegisterTabletPage.referralFieldKey,
              label: 'Mã giới thiệu (không bắt buộc)',
              hintText: 'Nhập nếu có',
              prefix: const Icon(Icons.card_giftcard_outlined),
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: AppSpacing.pageRhythmFormInnerGap),
            CheckboxListTile(
              key: RegisterTabletPage.agreementKey,
              value: _agreed,
              onChanged: (value) => setState(() => _agreed = value ?? false),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text(
                'Tôi đồng ý với Điều khoản dịch vụ và Chính sách bảo mật.',
                style: AppTextStyles.caption,
              ),
            ),
            if (_error.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.pageRhythmFormInnerGap),
              AuthTabletErrorBanner(message: _error),
            ],
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            VitCtaButton(
              key: RegisterTabletPage.submitKey,
              onPressed: _submitting ? null : _submit,
              loading: _submitting,
              variant: VitCtaButtonVariant.auth,
              child: const Text('Tạo tài khoản'),
            ),
            const SizedBox(height: AppSpacing.pageRhythmFormInnerGap),
            TextButton(
              onPressed: _submitting
                  ? null
                  : () => context.go(AppRoutePaths.authLogin),
              child: const Text('Đã có tài khoản? Đăng nhập'),
            ),
          ],
        ),
      ),
    );
  }
}
