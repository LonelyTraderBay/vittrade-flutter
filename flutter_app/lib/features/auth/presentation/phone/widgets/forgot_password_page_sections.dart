part of '../pages/forgot_password_page.dart';

class _EmailStep extends StatelessWidget {
  const _EmailStep({
    required this.controller,
    required this.error,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String error;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.center,
          child: AuthHeroIconBox(
            dimension: AuthSpacingTokens.authHeroIconBoxSm,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadii.cardRadius,
              side: BorderSide(
                color: _authPrimary30,
                width: AppSpacing.borderWidth,
              ),
            ),
            fillColor: _authPrimary10,
            child: Center(
              child: CustomPaint(
                size: Size(
                  AuthSpacingTokens.authHeroPainterSize,
                  AuthSpacingTokens.authHeroPainterSize,
                ),
                painter: _KeyIconPainter(),
              ),
            ),
          ),
        ),
        const Padding(padding: AuthSpacingTokens.authTopGapX5),
        const Text(
          'Đặt lại mật khẩu',
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle,
        ),
        const Padding(padding: AuthSpacingTokens.authTopGapX3),
        Text(
          'Nhập email đã đăng ký. Chúng tôi sẽ gửi mã xác minh để đặt lại\n'
          'mật khẩu.',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            height: AuthSpacingTokens.authReadableLineHeight,
          ),
        ),
        const Padding(padding: AuthSpacingTokens.authInputTopPadding),
        VitInput(
          controller: controller,
          fieldKey: ForgotPasswordPage.emailFieldKey,
          label: 'Email đăng ký',
          hintText: 'you@example.com',
          prefix: const Icon(Icons.mail_outline_rounded),
          errorText: error.isEmpty ? null : error,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.email, AutofillHints.username],
          onChanged: (_) => onChanged(),
        ),
      ],
    );
  }
}

class _KeyIconPainter extends CustomPainter {
  const _KeyIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _authPrimary
      ..strokeWidth = 2.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final center = Offset(size.width * 0.38, size.height * 0.38);
    canvas.drawCircle(center, 5.2, paint);
    final path = Path()
      ..moveTo(center.dx + 4.1, center.dy + 4.1)
      ..lineTo(size.width * 0.68, size.height * 0.68)
      ..lineTo(size.width * 0.68, size.height * 0.8)
      ..moveTo(size.width * 0.68, size.height * 0.68)
      ..lineTo(size.width * 0.8, size.height * 0.68)
      ..moveTo(size.width * 0.56, size.height * 0.56)
      ..lineTo(size.width * 0.43, size.height * 0.69);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _OtpStep extends StatelessWidget {
  const _OtpStep({
    required this.controller,
    required this.email,
    required this.error,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String email;
  final String error;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Nhập mã OTP',
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle,
        ),
        const Padding(padding: AuthSpacingTokens.authTopGapX3),
        Text.rich(
          TextSpan(
            text: 'Mã 6 số đã được gửi đến ',
            children: [
              TextSpan(
                text: email,
                style: AppTextStyles.caption.copyWith(color: AppColors.text1),
              ),
            ],
          ),
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const Padding(padding: AuthSpacingTokens.authTopGapX1),
        Text(
          '(Demo: nhập 123456)',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const Padding(padding: AuthSpacingTokens.authTopGapX6),
        Text(
          'Mã OTP',
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const Padding(padding: AuthSpacingTokens.authCompactTopPadding),
        TextField(
          key: ForgotPasswordPage.otpFieldKey,
          controller: controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          style: AppTextStyles.sectionTitle.copyWith(
            fontWeight: AppTextStyles.bold,
            letterSpacing: 8,
          ),
          cursorColor: _authPrimary,
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: AppColors.surface2,
            contentPadding: AppSpacing.zeroInsets,
            border: _otpBorder(
              error.isEmpty ? AppColors.borderSolid : AppColors.sell,
            ),
            enabledBorder: _otpBorder(
              error.isEmpty ? AppColors.borderSolid : AppColors.sell,
            ),
            focusedBorder: _otpBorder(
              _authPrimary,
              width: AppSpacing.hairlineStroke,
            ),
            errorBorder: _otpBorder(AppColors.sell),
            focusedErrorBorder: _otpBorder(
              AppColors.sell,
              width: AppSpacing.hairlineStroke,
            ),
          ),
          onChanged: onChanged,
        ),
        if (error.isNotEmpty) ...[
          const Padding(padding: AuthSpacingTokens.authTopGapX2),
          Text(
            error,
            style: AppTextStyles.micro.copyWith(color: AppColors.sell),
          ),
        ],
      ],
    );
  }

  OutlineInputBorder _otpBorder(
    Color color, {
    double width = AppSpacing.borderWidth,
  }) {
    return OutlineInputBorder(
      borderRadius: AppRadii.inputRadius,
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

class _ResetStep extends StatelessWidget {
  const _ResetStep({
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.showPassword,
    required this.error,
    required this.onChanged,
    required this.onTogglePassword,
  });

  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final bool showPassword;
  final String error;
  final VoidCallback onChanged;
  final VoidCallback onTogglePassword;

  @override
  Widget build(BuildContext context) {
    final confirmMismatch =
        confirmPasswordController.text.isNotEmpty &&
        confirmPasswordController.text != newPasswordController.text;

    return Column(
      children: [
        const Text(
          'Mật khẩu mới',
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle,
        ),
        const Padding(padding: AuthSpacingTokens.authTopGapX3),
        Text(
          'Tạo mật khẩu mạnh để bảo vệ tài khoản',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const Padding(padding: AuthSpacingTokens.authTopGapX6),
        VitInput(
          controller: newPasswordController,
          fieldKey: ForgotPasswordPage.newPasswordFieldKey,
          label: 'Mật khẩu mới',
          hintText: '••••••••',
          prefix: const Icon(Icons.lock_outline_rounded),
          suffix: VitIconButton(
            key: ForgotPasswordPage.passwordToggleKey,
            icon: showPassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            tooltip: showPassword ? 'Ẩn mật khẩu' : 'Hiện mật khẩu',
            onPressed: onTogglePassword,
            variant: VitIconButtonVariant.transparent,
            size: VitIconButtonSize.sm,
          ),
          obscureText: !showPassword,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.newPassword],
          onChanged: (_) => onChanged(),
        ),
        const Padding(padding: AuthSpacingTokens.authTopGapX4),
        VitInput(
          controller: confirmPasswordController,
          fieldKey: ForgotPasswordPage.confirmPasswordFieldKey,
          label: 'Xác nhận mật khẩu',
          hintText: '••••••••',
          prefix: const Icon(Icons.lock_outline_rounded),
          errorText: confirmMismatch ? 'Mật khẩu không khớp' : null,
          obscureText: !showPassword,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.newPassword],
          onChanged: (_) => onChanged(),
        ),
        if (error.isNotEmpty && !confirmMismatch) ...[
          const Padding(padding: AuthSpacingTokens.authTopGapX3),
          Text(
            error,
            style: AppTextStyles.micro.copyWith(color: AppColors.sell),
          ),
        ],
      ],
    );
  }
}

class _SuccessStep extends StatelessWidget {
  const _SuccessStep();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AuthSpacingTokens.authStateVerticalPadding,
      child: Column(
        children: [
          const SizedBox.square(
            dimension: AuthSpacingTokens.authStateIconBox,
            child: Material(
              color: AppColors.buy15,
              shape: CircleBorder(
                side: BorderSide(
                  color: AppColors.buy20,
                  width: AppSpacing.hairlineStroke,
                ),
              ),
              child: Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.buy,
                size: AuthSpacingTokens.authStateIconLg,
              ),
            ),
          ),
          const Padding(padding: AuthSpacingTokens.authTopGapX6),
          const Text(
            'Thành công!',
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle,
          ),
          const Padding(padding: AuthSpacingTokens.authTopGapX3),
          Text(
            'Mật khẩu của bạn đã được đặt lại thành công.\n'
            'Vui lòng đăng nhập với mật khẩu mới.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text2,
              height: AuthSpacingTokens.authReadableLineHeight,
            ),
          ),
        ],
      ),
    );
  }
}
