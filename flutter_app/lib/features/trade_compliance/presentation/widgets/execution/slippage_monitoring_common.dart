part of '../../phone/pages/execution/slippage_monitoring_page.dart';

class _SidePill extends StatelessWidget {
  const _SidePill({required this.side});

  final String side;

  @override
  Widget build(BuildContext context) {
    final buy = side == 'buy';
    return VitStatusPill(
      label: side.toUpperCase(),
      status: buy ? VitStatusPillStatus.success : VitStatusPillStatus.error,
      size: VitStatusPillSize.sm,
    );
  }
}

class _SeverityPill extends StatelessWidget {
  const _SeverityPill({required this.style});

  final _SeverityStyle style;

  @override
  Widget build(BuildContext context) {
    return VitStatusPill(
      label: style.label,
      icon: style.icon,
      status: switch (style.label) {
        'Critical' => VitStatusPillStatus.error,
        'Warning' => VitStatusPillStatus.warning,
        _ => VitStatusPillStatus.success,
      },
      size: VitStatusPillSize.sm,
    );
  }
}

class _SwitchVisual extends StatelessWidget {
  const _SwitchVisual({required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return VitTogglePill(
      enabled: enabled,
      activeColor: _slipPrimary,
      inactiveColor: _slipPanel2,
    );
  }
}

class _SeverityStyle {
  const _SeverityStyle({
    required this.color,
    required this.label,
    required this.icon,
  });

  final Color color;
  final String label;
  final IconData icon;
}

_SeverityStyle _severityStyle(String severity) {
  return switch (severity) {
    'critical' => const _SeverityStyle(
      color: _slipRed,
      label: 'Critical',
      icon: Icons.cancel_outlined,
    ),
    'warning' => const _SeverityStyle(
      color: _slipAmber,
      label: 'Warning',
      icon: Icons.warning_amber_rounded,
    ),
    _ => const _SeverityStyle(
      color: _slipGreen,
      label: 'Normal',
      icon: Icons.check_circle_outline,
    ),
  };
}

String _formatPrice(double value) {
  if (value < 1000 && value != value.roundToDouble()) {
    return '\$${value.toStringAsFixed(1)}';
  }
  return '\$${_formatInt(value)}';
}

String _formatInt(num value) => formatTradeInt(value.round());
