part of '../../phone/pages/safety/copy_audit_log_page.dart';

class _AuditEventCard extends StatelessWidget {
  const _AuditEventCard({super.key, required this.event});

  final TradeCopyAuditEvent event;

  @override
  Widget build(BuildContext context) {
    final color = _eventColor(event);
    return VitCard(
      radius: VitCardRadius.tight,
      padding: VitDensity.tool.cardPadding,
      borderColor: AppColors.cardBorder,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // card-tile: allow-start — fixed surface, not horizontal strip tile
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.tight,
            width: AppSpacing.buttonCompact,
            height: AppSpacing.buttonCompact,
            alignment: Alignment.center,
            borderColor: color,
            child: Icon(
              _eventIcon(event),
              color: color,
              size: AppSpacing.iconMd,
            ),
          ),
          const SizedBox(width: _auditSpace),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.medium,
                    height: _auditTitleLineHeight,
                  ),
                ),
                const SizedBox(height: _auditTinySpace),
                Text(
                  event.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.medium,
                    height: _auditBodyLineHeight,
                  ),
                ),
                const SizedBox(height: _auditSpace),
                _EventMetaRow(event: event, color: color),
                if (_hasVisibleMetadata(event)) ...[
                  const SizedBox(height: _auditSpace),
                  _EventMetadataPanel(event: event),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EventMetaRow extends StatelessWidget {
  const _EventMetaRow({required this.event, required this.color});

  final TradeCopyAuditEvent event;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.access_time_rounded,
          color: AppColors.text3,
          size: AppSpacing.rowGapRegular,
        ),
        const SizedBox(width: AppSpacing.x2),
        Text(
          event.timestamp,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: _auditMetaLineHeight,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Text(
          '•',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: _auditMetaLineHeight,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        _TypeBadge(type: event.type, color: color),
      ],
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type, required this.color});

  final TradeCopyAuditEventType type;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(label: _eventTypeLabel(type), accentColor: color);
  }
}

class _EventMetadataPanel extends StatelessWidget {
  const _EventMetadataPanel({required this.event});

  final TradeCopyAuditEvent event;

  @override
  Widget build(BuildContext context) {
    final metadata = event.metadata!;
    if (event.type == TradeCopyAuditEventType.config) {
      // card-tile: allow-start — fixed surface, not horizontal strip tile
      return VitCard(
        variant: VitCardVariant.inner,
        radius: VitCardRadius.tight,
        height: AppSpacing.buttonCompact,
        width: double.infinity,
        alignment: Alignment.centerLeft,
        padding: TradeSpacingTokens.copyAuditMetadataConfigPadding,
        child: Text(
          '${metadata.oldValue} → ${metadata.newValue}',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: _auditMetaLineHeight,
          ),
        ),
      );
    }

    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      width: double.infinity,
      padding: TradeSpacingTokens.copyAuditMetadataPanelPadding,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _MetadataValue(
                  label: 'Provider Price',
                  value: _formatUsd(metadata.providerPrice ?? 0),
                ),
              ),
              Expanded(
                child: _MetadataValue(
                  label: 'Your Price',
                  value: _formatUsd(metadata.yourPrice ?? 0),
                ),
              ),
            ],
          ),
          const SizedBox(height: _auditSpace),
          Row(
            children: [
              Expanded(
                child: _MetadataValue(
                  label: 'Slippage',
                  value: '${(metadata.slippagePct ?? 0).toStringAsFixed(2)}%',
                  valueColor: _auditAmber,
                ),
              ),
              if (metadata.pnl != null)
                Expanded(
                  child: _MetadataValue(
                    label: 'P/L',
                    value: _formatSignedUsd(metadata.pnl!),
                    valueColor: metadata.pnl! >= 0
                        ? AppColors.buy
                        : AppColors.sell,
                  ),
                )
              else
                const Expanded(child: SizedBox.shrink()),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetadataValue extends StatelessWidget {
  const _MetadataValue({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: _auditMetaLineHeight,
          ),
        ),
        const SizedBox(height: _auditTinySpace),
        Text(
          value,
          style: AppTextStyles.numericMicro.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _EmptyAuditState extends StatelessWidget {
  const _EmptyAuditState({required this.searching});

  final bool searching;

  @override
  Widget build(BuildContext context) {
    return VitEmptyState(
      key: CopyAuditLogPage.emptyStateKey,
      title: searching ? 'Không tìm thấy event phù hợp' : 'Chưa có event nào',
      icon: Icons.description_outlined,
    );
  }
}
