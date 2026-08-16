part of '../../phone/pages/hub/copy_settings_page.dart';

class _EmergencyContactCard extends StatelessWidget {
  const _EmergencyContactCard({
    required this.email,
    required this.phone,
    required this.onEmailChanged,
    required this.onPhoneChanged,
  });

  final String email;
  final String phone;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPhoneChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: AppColors.warn15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppColors.warn,
                size: WalletSpacingTokens.walletTokenApprovalActionIcon,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  'Người liên hệ khẩn cấp sẽ được thông báo nếu tài khoản của bạn có hoạt động bất thường hoặc kích hoạt circuit breaker.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.warn,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _SettingsTextField(
            label: 'Email',
            initialValue: email,
            hint: 'emergency@example.com',
            keyboardType: TextInputType.emailAddress,
            onChanged: onEmailChanged,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _SettingsTextField(
            label: 'Số điện thoại',
            initialValue: phone,
            hint: '+84 xxx xxx xxx',
            keyboardType: TextInputType.phone,
            onChanged: onPhoneChanged,
          ),
        ],
      ),
    );
  }
}

class _SettingsTextField extends StatefulWidget {
  const _SettingsTextField({
    required this.label,
    required this.initialValue,
    required this.hint,
    required this.keyboardType,
    required this.onChanged,
  });

  final String label;
  final String initialValue;
  final String hint;
  final TextInputType keyboardType;
  final ValueChanged<String> onChanged;

  @override
  State<_SettingsTextField> createState() => _SettingsTextFieldState();
}

class _SettingsTextFieldState extends State<_SettingsTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant _SettingsTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VitInput(
      controller: _controller,
      label: widget.label,
      hintText: widget.hint,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
    );
  }
}

class _PrivacyCard extends StatelessWidget {
  const _PrivacyCard({required this.active, required this.onChanged});

  final bool active;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      child: Row(
        children: [
          Icon(
            active ? Icons.visibility_rounded : Icons.visibility_off_rounded,
            color: active ? _settingsPrimary : AppColors.text3,
            size: WalletSpacingTokens.walletTokenApprovalActionIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hiển thị portfolio công khai', style: _cardTitleStyle()),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  'Cho phép người khác xem portfolio copy của bạn (không hiện số tiền cụ thể)',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.cardGap),
          _ToggleSwitch(value: active, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.saved, required this.onTap});

  final bool saved;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: CopySettingsPage.saveKey,
      onPressed: onTap,
      variant: saved
          ? VitCtaButtonVariant.success
          : VitCtaButtonVariant.primary,
      density: VitDensity.tool,
      leading: Icon(saved ? Icons.shield_rounded : Icons.settings_rounded),
      child: Text(saved ? 'Đã lưu!' : 'Lưu cài đặt'),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      child: child,
    );
  }
}

TextStyle _cardTitleStyle() {
  return AppTextStyles.caption.copyWith(
    color: AppColors.text1,
    fontWeight: AppTextStyles.bold,
  );
}

String _modeLabel(TradeCopySettingsMode mode) {
  return switch (mode) {
    TradeCopySettingsMode.mirror => 'Mirror',
    TradeCopySettingsMode.fixed => 'Fixed',
    TradeCopySettingsMode.smart => 'Smart',
  };
}
