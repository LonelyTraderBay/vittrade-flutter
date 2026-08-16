part of '../../phone/pages/tools/network_status_page.dart';

class _LegendCard extends StatelessWidget {
  const _LegendCard();

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('operational', 'Ho\u1EA1t \u0111\u1ED9ng t\u1ED1t'),
      ('degraded', 'Ch\u1EADm'),
      ('congested', 'T\u1EAFc ngh\u1EBDn'),
      ('down', 'B\u1EA3o tr\u00EC'),
    ];
    return VitCard(
      padding: VitDensity.compact.cardPadding,
      borderColor: _networkBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ch\u00FA th\u00EDch tr\u1EA1ng th\u00E1i',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: _networkCardGap),
          Wrap(
            spacing: _networkTinyGap,
            runSpacing: _networkTinyGap,
            children: [
              for (final row in rows)
                VitStatusPill(
                  label: row.$2,
                  status: _healthStatus(row.$1),
                  icon: _healthIcon(row.$1),
                  size: VitStatusPillSize.sm,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DisclaimerCard extends StatelessWidget {
  const _DisclaimerCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: VitDensity.compact.cardPadding,
      borderColor: AppColors.primary20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.primary,
            size: WalletSpacingTokens.walletTokenNoticeIcon,
          ),
          const SizedBox(width: _networkInlineGap),
          Expanded(
            child: Text(
              'D\u1EEF li\u1EC7u tr\u1EA1ng th\u00E1i m\u1EA1ng \u0111\u01B0\u1EE3c c\u1EADp nh\u1EADt t\u1EF1 \u0111\u1ED9ng. Th\u1EDDi gian x\u00E1c nh\u1EADn th\u1EF1c t\u1EBF c\u00F3 th\u1EC3 kh\u00E1c t\u00F9y thu\u1ED9c v\u00E0o ph\u00ED gas v\u00E0 m\u1EE9c t\u1EA3i m\u1EA1ng t\u1EA1i th\u1EDDi \u0111i\u1EC3m giao d\u1ECBch.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TokenLogo extends StatelessWidget {
  const _TokenLogo({required this.symbol, required this.color});

  final String symbol;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      height: _networkLogoSize,
      width: _networkLogoSize,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      background: ColoredBox(color: color.withValues(alpha: .1)),
      clip: true,
      alignment: Alignment.center,
      child: Text(
        symbol,
        maxLines: 1,
        overflow: TextOverflow.clip,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _HealthPill extends StatelessWidget {
  const _HealthPill({required this.health});

  final String health;

  @override
  Widget build(BuildContext context) {
    return VitStatusPill(
      label: _healthLabel(health),
      status: _healthStatus(health),
      icon: _healthIcon(health),
      size: VitStatusPillSize.sm,
    );
  }
}

String _healthLabel(String health) {
  return switch (health) {
    'operational' => 'Ho\u1EA1t \u0111\u1ED9ng t\u1ED1t',
    'degraded' => 'Ch\u1EADm',
    'congested' => 'T\u1EAFc ngh\u1EBDn',
    'down' => 'B\u1EA3o tr\u00EC',
    _ => health,
  };
}

Color _healthColor(String health) {
  return switch (health) {
    'operational' => _networkGreen,
    'degraded' => _networkAmber,
    'congested' => _networkOrange,
    'down' => _networkRed,
    _ => _networkMuted,
  };
}

VitStatusPillStatus _healthStatus(String health) {
  return switch (health) {
    'operational' => VitStatusPillStatus.success,
    'degraded' => VitStatusPillStatus.warning,
    'congested' => VitStatusPillStatus.orange,
    'down' => VitStatusPillStatus.error,
    _ => VitStatusPillStatus.neutral,
  };
}

IconData _healthIcon(String health) {
  return switch (health) {
    'operational' => Icons.check_circle_outline_rounded,
    'degraded' => Icons.access_time_rounded,
    'congested' => Icons.warning_amber_rounded,
    'down' => Icons.wifi_off_rounded,
    _ => Icons.info_outline_rounded,
  };
}

Color _congestionColor(int pct) {
  if (pct > 70) return _networkOrange;
  if (pct > 40) return _networkAmber;
  return _networkGreen;
}

String _congestionLabel(int pct) {
  if (pct > 70) return 'T\u1EAFc ngh\u1EBDn';
  if (pct > 40) return 'Cao';
  if (pct > 15) return 'B\u00ECnh th\u01B0\u1EDDng';
  return 'Th\u1EA5p';
}

int _networkPriority(WalletNetworkInfo network) {
  return switch (network.health) {
    'down' => 0,
    'congested' => 1,
    'degraded' => 2,
    _ => 3,
  };
}

String _formatInt(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    if (i > 0 && (raw.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(raw[i]);
  }
  return buffer.toString();
}
