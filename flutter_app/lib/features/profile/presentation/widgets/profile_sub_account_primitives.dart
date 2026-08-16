part of '../phone/pages/sub_account_page.dart';

class _AccountAvatar extends StatelessWidget {
  const _AccountAvatar({required this.initial, required this.color});

  final String initial;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAssetAvatar(
      label: initial,
      accentColor: color,
      size: ProfileSpacingTokens.profileSubAccountAvatarSize,
      radius: AppRadii.cardRadius,
    );
  }
}

class _SubAccountInfoNote extends StatelessWidget {
  const _SubAccountInfoNote();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: AppColors.primary20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.primary,
            size: ProfileSpacingTokens.profileSubAccountInfoNoteIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'M\u1ED7i t\u00E0i kho\u1EA3n ph\u1EE5 c\u00F3 v\u00ED v\u00E0 API ri\u00EAng bi\u1EC7t. B\u1EA1n c\u00F3 th\u1EC3 t\u1EA1o t\u1ED1i \u0111a 20 t\u00E0i kho\u1EA3n ph\u1EE5. T\u00E0i kho\u1EA3n ph\u1EE5 th\u1EEBa h\u01B0\u1EDFng m\u1EE9c VIP c\u1EE7a t\u00E0i kho\u1EA3n ch\u00EDnh.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
