part of '../phone/pages/sub_account_page.dart';

class _CreateSubAccountButton extends StatelessWidget {
  const _CreateSubAccountButton({required this.isOpen, required this.onTap});

  final bool isOpen;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: SubAccountPage.createButtonKey,
      onPressed: onTap,
      variant: VitCtaButtonVariant.secondary,
      density: VitDensity.compact,
      leading: Icon(isOpen ? Icons.close_rounded : Icons.add_rounded),
      child: Text(
        isOpen
            ? '\u0110\u00F3ng bi\u1EC3u m\u1EABu'
            : 'T\u1EA1o t\u00E0i kho\u1EA3n ph\u1EE5 m\u1EDBi',
      ),
    );
  }
}

class _CreateSubAccountForm extends StatefulWidget {
  const _CreateSubAccountForm();

  @override
  State<_CreateSubAccountForm> createState() => _CreateSubAccountFormState();
}

class _CreateSubAccountFormState extends State<_CreateSubAccountForm> {
  String _accountType = 'Spot';

  static const _accountTypes = [
    'Spot',
    'Margin',
    'Futures',
    'T\u1EA5t c\u1EA3',
  ];

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SubAccountPage.createFormKey,
      density: VitDensity.compact,
      borderColor: AppColors.cardBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'T\u1EA1o t\u00E0i kho\u1EA3n ph\u1EE5',
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.extraBold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          const _FormFieldPreview(
            label: 'T\u00EAn t\u00E0i kho\u1EA3n',
            value: 'VD: Grid Bot #2',
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lo\u1EA1i t\u00E0i kho\u1EA3n',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              VitPresetChipRow<String>(
                gap: ProfileSpacingTokens.profileSubAccountFormPillGap,
                selectedValue: _accountType,
                onTap: (value) => setState(() => _accountType = value),
                items: [
                  for (final type in _accountTypes)
                    VitPresetChipItem<String>(value: type, label: type),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          const _FormPermissionPreview(),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCtaButton(
            onPressed: _submitCreate,
            density: VitDensity.compact,
            child: const Text('T\u1EA1o t\u00E0i kho\u1EA3n'),
          ),
        ],
      ),
    );
  }

  void _submitCreate() {
    unawaited(HapticFeedback.selectionClick());
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Sắp ra mắt',
        message: 'Tạo tài khoản phụ sẽ sớm ra mắt',
      ),
    );
  }
}

class _FormPermissionPreview extends StatelessWidget {
  const _FormPermissionPreview();

  static const _permissions = [
    'Spot',
    'Margin',
    'Futures',
    'Chuy\u1EC3n',
    'R\u00FAt',
    'Xem',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quy\u1EC1n h\u1EA1n',
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Wrap(
          spacing: ProfileSpacingTokens.profileSubAccountFormPillGap,
          runSpacing: ProfileSpacingTokens.profileSubAccountFormPillGap,
          children: [
            for (final permission in _permissions)
              VitAccentPill(label: permission, accentColor: AppColors.primary),
          ],
        ),
      ],
    );
  }
}

class _FormFieldPreview extends StatelessWidget {
  const _FormFieldPreview({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: VitDensity.compact.controlHeight,
          ),
          child: Material(
            color: AppColors.surface2,
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.inputRadius,
              side: BorderSide(color: AppColors.borderSolid),
            ),
            child: Padding(
              padding: ProfileSpacingTokens.profileSubAccountFormInputPadding,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: AppTextStyles.body.copyWith(color: AppColors.text3),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
