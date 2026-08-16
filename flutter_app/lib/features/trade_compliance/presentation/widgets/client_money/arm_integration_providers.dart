part of '../../phone/pages/client_money/arm_integration_status_page.dart';

class _OperationalAlert extends StatelessWidget {
  const _OperationalAlert();

  @override
  Widget build(BuildContext context) {
    return const VitHighRiskStatePanel(
      state: VitHighRiskUiState.success,
      density: VitDensity.tool,
      title: 'All Systems Operational',
      message:
          '3/3 ARM providers online. Failover ready. Average uptime: 99.5%.',
    );
  }
}

class _ArmProviderCard extends StatelessWidget {
  const _ArmProviderCard({
    required this.connection,
    required this.isTesting,
    required this.onTest,
  });

  final TradeArmConnection connection;
  final bool isTesting;
  final VoidCallback onTest;

  @override
  Widget build(BuildContext context) {
    final style = _statusStyle(connection.status);
    return VitCard(
      key: ArmIntegrationStatusPage.connectionKey(connection.id),
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: _armBorder.withValues(alpha: .72),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // card-tile: allow-start — fixed surface, not horizontal strip tile
              VitCard(
                variant: VitCardVariant.inner,
                radius: VitCardRadius.tight,
                width: AppSpacing.inputHeight - AppSpacing.x3,
                height: AppSpacing.inputHeight - AppSpacing.x3,
                borderColor: style.color.withValues(alpha: .28),
                alignment: Alignment.center,
                child: Icon(
                  style.icon,
                  color: style.color,
                  size: AppSpacing.iconMd,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            connection.provider,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        if (connection.isPrimary) ...[
                          const SizedBox(width: AppSpacing.x3),
                          const VitAccentPill(
                            label: 'PRIMARY',
                            accentColor: _armPrimary,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      connection.region,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              VitAccentPill(
                label: style.label,
                accentColor: style.color,
                size: VitStatusPillSize.md,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _MetricBox(
                  label: 'Uptime',
                  value: '${connection.uptime.toStringAsFixed(2)}%',
                  color: _armGreen,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _MetricBox(
                  label: 'Avg Latency',
                  value: '${connection.avgLatency}ms',
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _MetricBox(
                  label: 'Current',
                  value: '${connection.currentLatency}ms',
                  color: connection.currentLatency > 60
                      ? _armRed
                      : AppColors.text1,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _ConnectionDetails(connection: connection),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _TestButton(
                  connectionId: connection.id,
                  isTesting: isTesting,
                  onTap: onTest,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              const _LogsButton(),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConnectionDetails extends StatelessWidget {
  const _ConnectionDetails({required this.connection});

  final TradeArmConnection connection;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        children: [
          _DetailRow(
            label: 'Endpoint:',
            value: connection.endpoint,
            mono: true,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          _DetailRow(label: 'Last Check:', value: connection.lastCheck),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          _DetailRow(label: 'Cert Expiry:', value: connection.certExpiry),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.mono = false,
  });

  final String label;
  final String value;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: mono
                ? AppTextStyles.monoCode.copyWith(color: AppColors.text2)
                : AppTextStyles.micro.copyWith(color: AppColors.text2),
          ),
        ),
      ],
    );
  }
}

class _TestButton extends StatelessWidget {
  const _TestButton({
    required this.connectionId,
    required this.isTesting,
    required this.onTap,
  });

  final String connectionId;
  final bool isTesting;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: ArmIntegrationStatusPage.testKey(connectionId),
      onPressed: isTesting ? null : onTap,
      variant: VitCtaButtonVariant.secondary,
      density: VitDensity.tool,
      leading: Icon(
        isTesting ? Icons.sync_rounded : Icons.bolt_rounded,
        color: isTesting ? AppColors.text3 : _armPrimary,
        size: AppSpacing.iconSm,
      ),
      child: Text(
        isTesting ? 'Testing...' : 'Test Connection',
        style: AppTextStyles.caption.copyWith(
          color: isTesting ? AppColors.text3 : _armPrimary,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _LogsButton extends StatelessWidget {
  const _LogsButton();

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      onPressed: () => _showComingSoon(context),
      variant: VitCtaButtonVariant.secondary,
      fullWidth: false,
      density: VitDensity.tool,
      leading: const Icon(
        Icons.open_in_new_rounded,
        color: AppColors.text2,
        size: AppSpacing.iconSm,
      ),
      child: Text(
        'Logs',
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text2,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    unawaited(HapticFeedback.selectionClick());
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Logs',
        message: 'Nhật ký kết nối sẽ sớm ra mắt',
      ),
    );
  }
}
