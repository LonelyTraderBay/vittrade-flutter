part of '../phone/pages/api_management_page.dart';

class _ApiDocsCard extends StatelessWidget {
  const _ApiDocsCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: () {
        unawaited(HapticFeedback.selectionClick());
        unawaited(
          showVitNoticeSheet(
            context: context,
            title: 'Sắp ra mắt',
            message: 'Tài liệu API sẽ sớm ra mắt',
          ),
        );
      },
      density: VitDensity.compact,
      borderColor: _apiBorder,
      child: VitIconListRow(
        gap: AppSpacing.x3,
        leading: SizedBox(
          width: ProfileSpacingTokens.profileApiDocsIconBox,
          height: ProfileSpacingTokens.profileApiDocsIconBox,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: _apiPrimary.withValues(alpha: .1),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.cardRadius,
              ),
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: _apiPrimary,
              size: ProfileSpacingTokens.profileApiDocsIcon,
            ),
          ),
        ),
        title: Text(
          'T\u00E0i li\u1EC7u API',
          style: AppTextStyles.body.copyWith(
            fontWeight: AppTextStyles.extraBold,
          ),
        ),
        subtitle: Text(
          'Xem h\u01B0\u1EDBng d\u1EABn t\u00EDch h\u1EE3p v\u00E0 endpoint',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: _apiMuted),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: _apiMuted,
          size: ProfileSpacingTokens.profileApiDocsChevron,
        ),
      ),
    );
  }
}

String _maskedKey(String value) {
  if (value.length <= 18) return value;
  return '${value.substring(0, 12)}\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022${value.substring(value.length - 6)}';
}

String _permissionLabel(String id) {
  return switch (id) {
    'trade' => 'Giao d\u1ECBch',
    'withdraw' => 'R\u00FAt ti\u1EC1n',
    _ => '\u0110\u1ECDc',
  };
}

Color _permissionColor(String id) {
  return switch (id) {
    'trade' => _apiAmber,
    'withdraw' => _apiRed,
    _ => _apiPrimary,
  };
}

String _formatInt(int value) => VitFormat.count(value);
