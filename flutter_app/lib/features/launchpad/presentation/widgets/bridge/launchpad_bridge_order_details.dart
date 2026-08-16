part of '../../phone/pages/bridge/launchpad_bridge_order_page.dart';

class _BridgeDetails extends StatelessWidget {
  const _BridgeDetails({required this.order});

  final LaunchpadBridgeOrderDraft order;

  @override
  Widget build(BuildContext context) {
    final rows = [
      _DetailRow('Dự án', order.projectName),
      _DetailRow('Route', order.routeProvider),
      _DetailRow('Hops', '${order.routeHops} bước'),
      _DetailRow('Slippage', '${_trimDouble(order.slippage)}%'),
      _DetailRow(
        'Price Impact',
        '${_trimDouble(order.priceImpact)}%',
        color: order.priceImpact > 1 ? AppColors.warn : AppColors.buy,
      ),
      _DetailRow('Gas', order.gasCost),
      _DetailRow('Tổng phí', order.totalFee),
      _DetailRow('Source Tx', order.sourceTxHash, monospace: true),
    ];

    return VitCard(
      key: LaunchpadBridgeOrderPage.detailsKey,
      radius: VitCardRadius.large,
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppColors.text2,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Chi tiết đơn',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          for (final row in rows) _DetailsRow(row: row),
        ],
      ),
    );
  }
}

class _DetailRow {
  const _DetailRow(
    this.label,
    this.value, {
    this.color,
    this.monospace = false,
  });

  final String label;
  final String value;
  final Color? color;
  final bool monospace;
}

class _DetailsRow extends StatelessWidget {
  const _DetailsRow({required this.row});

  final _DetailRow row;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: LaunchpadSpacingTokens.launchpadVerticalPaddingX2,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  row.label,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Flexible(
                child: Text(
                  row.value,
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: row.color ?? AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: row.monospace
                        ? AppTextStyles.tabularFigures
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: AppSpacing.hairlineStroke),
      ],
    );
  }
}

class _SimulationDisclosure extends StatelessWidget {
  const _SimulationDisclosure();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadBridgeOrderPage.safetyKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      borderColor: AppColors.primary.withValues(alpha: .16),
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primary,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              'Đây là chế độ mô phỏng. Trạng thái được cập nhật tự động mỗi vài giây. Giao dịch không được gửi lên blockchain thật.',
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _BridgeSupportAction extends StatelessWidget {
  const _BridgeSupportAction({required this.supportRoute});

  final String supportRoute;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadBridgeOrderPage.supportKey,
      onTap: () => context.go(supportRoute),
      radius: VitCardRadius.large,
      borderColor: AppColors.primary20,
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      child: Row(
        children: [
          const Icon(
            Icons.support_agent_rounded,
            color: AppColors.primary,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cần hỗ trợ bridge?',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Mở hồ sơ support kèm tx, route và trạng thái bridge.',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          VitCtaButton(
            fullWidth: false,
            height: AppSpacing.buttonCompact,
            padding: LaunchpadSpacingTokens.launchpadSupportButtonPadding,
            onPressed: () => context.go(supportRoute),
            trailing: const Icon(Icons.chevron_right_rounded),
            child: const Text('Hỗ trợ'),
          ),
        ],
      ),
    );
  }
}

Color _statusColor(LaunchpadBridgeOrderStatus status) {
  return switch (status) {
    LaunchpadBridgeOrderStatus.initiated => AppColors.primary,
    LaunchpadBridgeOrderStatus.approved => AppColors.accent,
    LaunchpadBridgeOrderStatus.bridging => AppColors.warn,
    LaunchpadBridgeOrderStatus.confirming => AppColors.primarySoft,
    LaunchpadBridgeOrderStatus.swapping => AppColors.sell,
    LaunchpadBridgeOrderStatus.finalizing => AppColors.buy,
    LaunchpadBridgeOrderStatus.completed => AppColors.buy,
    LaunchpadBridgeOrderStatus.failed => AppColors.sell,
  };
}

IconData _statusIcon(LaunchpadBridgeOrderStatus status) {
  return switch (status) {
    LaunchpadBridgeOrderStatus.initiated => Icons.bolt_rounded,
    LaunchpadBridgeOrderStatus.approved => Icons.sync_rounded,
    LaunchpadBridgeOrderStatus.bridging => Icons.account_tree_outlined,
    LaunchpadBridgeOrderStatus.confirming => Icons.schedule_rounded,
    LaunchpadBridgeOrderStatus.swapping => Icons.sync_rounded,
    LaunchpadBridgeOrderStatus.finalizing => Icons.hourglass_top_rounded,
    LaunchpadBridgeOrderStatus.completed => Icons.check_circle_outline_rounded,
    LaunchpadBridgeOrderStatus.failed => Icons.error_outline_rounded,
  };
}

String _heroTitle(LaunchpadBridgeOrderStatus status) {
  return switch (status) {
    LaunchpadBridgeOrderStatus.completed => 'Bridge hoàn tất!',
    LaunchpadBridgeOrderStatus.failed => 'Bridge thất bại',
    _ => 'Đang xử lý bridge...',
  };
}

int _statusIndex(LaunchpadBridgeOrderStatus status) {
  return switch (status) {
    LaunchpadBridgeOrderStatus.initiated => 0,
    LaunchpadBridgeOrderStatus.approved => 1,
    LaunchpadBridgeOrderStatus.bridging => 2,
    LaunchpadBridgeOrderStatus.confirming => 3,
    LaunchpadBridgeOrderStatus.swapping => 4,
    LaunchpadBridgeOrderStatus.finalizing => 5,
    LaunchpadBridgeOrderStatus.completed => 6,
    LaunchpadBridgeOrderStatus.failed => 7,
  };
}

Color _eventColor(LaunchpadBridgeEventLevel level) {
  return switch (level) {
    LaunchpadBridgeEventLevel.info => AppColors.primary,
    LaunchpadBridgeEventLevel.success => AppColors.buy,
    LaunchpadBridgeEventLevel.warning => AppColors.warn,
    LaunchpadBridgeEventLevel.error => AppColors.sell,
    LaunchpadBridgeEventLevel.debug => AppColors.text3,
    LaunchpadBridgeEventLevel.system => AppColors.accent,
  };
}

String _eventLabel(LaunchpadBridgeEventLevel level) {
  return switch (level) {
    LaunchpadBridgeEventLevel.info => 'INFO',
    LaunchpadBridgeEventLevel.success => 'SUCC',
    LaunchpadBridgeEventLevel.warning => 'WARN',
    LaunchpadBridgeEventLevel.error => 'ERR',
    LaunchpadBridgeEventLevel.debug => 'DEBG',
    LaunchpadBridgeEventLevel.system => 'SYS',
  };
}

String _formatUsd(double value) {
  if (value == value.roundToDouble()) {
    return '\$${value.toInt().toString()}';
  }
  return '\$${value.toStringAsFixed(2)}';
}

String _formatNumber(num value) {
  final parts = value.toString().split('.');
  final integer = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < integer.length; i++) {
    final remaining = integer.length - i;
    buffer.write(integer[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  if (parts.length > 1 && int.parse(parts.last) != 0) {
    buffer.write('.');
    buffer.write(parts.last.replaceFirst(RegExp(r'0+$'), ''));
  }
  return buffer.toString();
}

String _trimDouble(double value) {
  if (value == value.roundToDouble()) return value.toInt().toString();
  return value.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '');
}
