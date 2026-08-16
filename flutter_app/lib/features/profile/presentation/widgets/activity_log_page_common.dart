part of '../phone/pages/activity_log_page.dart';

class _DetailBlock extends StatelessWidget {
  const _DetailBlock({required this.label, required this.value, this.icon});

  final IconData? icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: _activityMuted,
                size: ProfileSpacingTokens.profileActivityDetailIcon,
              ),
              const SizedBox(
                width: ProfileSpacingTokens.profileActivityDetailIconGap,
              ),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: _activityMuted),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _EmptyActivity extends StatelessWidget {
  const _EmptyActivity();

  @override
  Widget build(BuildContext context) {
    return const VitEmptyState(
      title: 'Kh\u00F4ng c\u00F3 ho\u1EA1t \u0111\u1ED9ng n\u00E0o',
      message:
          'Nh\u1EADt k\u00FD \u0111\u0103ng nh\u1EADp, b\u1EA3o m\u1EADt v\u00E0 API s\u1EBD hi\u1EC3n th\u1ECB t\u1EA1i \u0111\u00E2y.',
      icon: Icons.shield_outlined,
    );
  }
}

class _ActivityFooter extends StatelessWidget {
  const _ActivityFooter();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: _activityDivider,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: _activityPrimary,
            size: ProfileSpacingTokens.profileActivityFooterIcon,
          ),
          const SizedBox(width: ProfileSpacingTokens.profileActivityFooterGap),
          Expanded(
            child: Text(
              'Nh\u1EADt k\u00FD ho\u1EA1t \u0111\u1ED9ng gi\u00FAp b\u1EA1n theo d\u00F5i t\u1EA5t c\u1EA3 thao t\u00E1c tr\u00EAn t\u00E0i kho\u1EA3n. N\u1EBFu\n'
              'ph\u00E1t hi\u1EC7n ho\u1EA1t \u0111\u1ED9ng \u0111\u00E1ng ng\u1EDD, vui l\u00F2ng \u0111\u1ED5i m\u1EADt kh\u1EA9u ngay l\u1EADp t\u1EE9c.',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _ActivityTypeConfig {
  const _ActivityTypeConfig({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}

final class _ActivityStatusConfig {
  const _ActivityStatusConfig({required this.label, required this.color});

  final String label;
  final Color color;
}

_ActivityTypeConfig _typeConfig(String type) {
  return switch (type) {
    'logout' => const _ActivityTypeConfig(
      label: '\u0110\u0103ng xu\u1EA5t',
      icon: Icons.check_circle_outline_rounded,
      color: _activityGray,
    ),
    'password_change' => const _ActivityTypeConfig(
      label: '\u0110\u1ED5i m\u1EADt kh\u1EA9u',
      icon: Icons.shield_outlined,
      color: _activityPrimary,
    ),
    '2fa_enable' => const _ActivityTypeConfig(
      label: 'B\u1EADt 2FA',
      icon: Icons.shield_outlined,
      color: _activityGreen,
    ),
    '2fa_disable' => const _ActivityTypeConfig(
      label: 'T\u1EAFt 2FA',
      icon: Icons.warning_amber_rounded,
      color: _activityRed,
    ),
    'kyc_submit' => const _ActivityTypeConfig(
      label: 'N\u1ED9p KYC',
      icon: Icons.check_circle_outline_rounded,
      color: _activityPrimary,
    ),
    'api_create' => const _ActivityTypeConfig(
      label: 'T\u1EA1o API Key',
      icon: Icons.check_circle_outline_rounded,
      color: _activityPurple,
    ),
    'api_delete' => const _ActivityTypeConfig(
      label: 'X\u00F3a API Key',
      icon: Icons.cancel_outlined,
      color: _activityRed,
    ),
    _ => const _ActivityTypeConfig(
      label: '\u0110\u0103ng nh\u1EADp',
      icon: Icons.check_circle_outline_rounded,
      color: _activityGreen,
    ),
  };
}

_ActivityStatusConfig _statusConfig(String status) {
  return switch (status) {
    'failed' => const _ActivityStatusConfig(
      label: 'Th\u1EA5t b\u1EA1i',
      color: _activityRed,
    ),
    'suspicious' => const _ActivityStatusConfig(
      label: '\u0110\u00E1ng ng\u1EDD',
      color: _activityAmber,
    ),
    _ => const _ActivityStatusConfig(
      label: 'Th\u00E0nh c\u00F4ng',
      color: _activityGreen,
    ),
  };
}
