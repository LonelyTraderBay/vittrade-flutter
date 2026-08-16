part of '../../phone/pages/settings/bot_emergency_stop_page.dart';

class _EmergencyOpening extends StatelessWidget {
  const _EmergencyOpening({
    required this.snapshot,
    required this.reasonSelected,
    required this.confirmed,
  });

  final TradeBotEmergencyStopSnapshot snapshot;
  final bool reasonSelected;
  final bool confirmed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitBotSubpageHero(
          primaryLabel: 'Bot cần dừng',
          primaryValue: '${snapshot.bots.length}',
          primaryColor: _stopRed,
          secondaryLabel: 'Lý do',
          secondaryValue: reasonSelected ? 'Đã chọn' : '—',
          secondaryColor: reasonSelected ? _stopGreen : AppColors.text3,
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Wrap(
          spacing: TradeSpacingTokens.tradeBotInlineIconGap,
          runSpacing: TradeSpacingTokens.tradeBotTinyGap,
          children: [
            VitStatusPill(
              label: reasonSelected ? '1. Lý do ✓' : '1. Chọn lý do',
              status: reasonSelected
                  ? VitStatusPillStatus.success
                  : VitStatusPillStatus.warning,
              size: VitStatusPillSize.sm,
            ),
            VitStatusPill(
              label: confirmed ? '2. Xác nhận ✓' : '2. Xác nhận',
              status: confirmed
                  ? VitStatusPillStatus.success
                  : VitStatusPillStatus.neutral,
              size: VitStatusPillSize.sm,
            ),
            const VitStatusPill(
              label: '3. Gửi',
              status: VitStatusPillStatus.info,
              size: VitStatusPillSize.sm,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        _WarningBanner(snapshot: snapshot),
      ],
    );
  }
}

class _WarningBanner extends StatelessWidget {
  const _WarningBanner({required this.snapshot});

  final TradeBotEmergencyStopSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: const Key('sc121_bot_emergency_stop_warning'),
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: TradeSpacingTokens.tradeBotCompactCardPadding,
      borderColor: _stopRed.withValues(alpha: .55),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VitAccentIconBox(
            icon: Icons.priority_high_rounded,
            color: _stopRed,
          ),
          const SizedBox(width: TradeSpacingTokens.tradeBotCardIconGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.warningTitle,
                  style: AppTextStyles.caption.copyWith(
                    color: _stopRed,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: TradeSpacingTokens.tradeBotTinyGap),
                Text(
                  snapshot.warningDescription,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BotCard extends StatelessWidget {
  const _BotCard({required this.bot});

  final TradeBotEmergencyBot bot;

  @override
  Widget build(BuildContext context) {
    final profitColor = bot.profit >= 0 ? _stopGreen : _stopRed;
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: TradeSpacingTokens.tradeBotCompactCardPadding,
      borderColor: AppColors.cardBorder,
      child: Row(
        children: [
          const VitAccentIconBox(
            icon: Icons.smart_toy_outlined,
            color: _stopPrimary,
          ),
          const SizedBox(width: TradeSpacingTokens.tradeBotCardIconGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  bot.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: TradeSpacingTokens.tradeBotTinyGap),
                Text(
                  bot.pair,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: TradeSpacingTokens.tradeBotTinyGap),
          VitStatusPill(
            label: bot.statusLabel,
            status: VitStatusPillStatus.success,
            size: VitStatusPillSize.sm,
          ),
          const SizedBox(width: TradeSpacingTokens.tradeBotCardGap),
          Text(
            _formatSignedMoney(bot.profit),
            style: AppTextStyles.caption.copyWith(
              color: profitColor,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReasonOption extends StatelessWidget {
  const _ReasonOption({
    required this.reason,
    required this.selected,
    required this.onTap,
  });

  final TradeBotEmergencyReason reason;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = _reasonColor(reason);
    return VitCard(
      key: BotEmergencyStopPage.reasonKey(reason.id),
      onTap: onTap,
      density: VitDensity.tool,
      variant: selected ? VitCardVariant.ghost : VitCardVariant.standard,
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotCompactCardPadding,
      borderColor: selected ? _stopRed : _stopOptionBorder,
      child: Row(
        children: [
          TradeBotRadioIcon(
            selected: selected,
            activeColor: _stopRed,
            inactiveColor: _stopOptionBorder,
          ),
          const SizedBox(width: TradeSpacingTokens.tradeBotCardGap),
          VitAccentIconBox(icon: _reasonIcon(reason.iconName), color: accent),
          const SizedBox(width: TradeSpacingTokens.tradeBotCardGap),
          Expanded(
            child: Text(
              reason.label,
              style: AppTextStyles.caption.copyWith(
                color: selected ? _stopRed : AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckActionCard extends StatelessWidget {
  const _CheckActionCard({
    super.key,
    required this.selected,
    required this.title,
    required this.description,
    required this.danger,
    required this.onTap,
  });

  final bool selected;
  final String title;
  final String description;
  final bool danger;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = danger ? _stopRed : _stopPrimary;
    return VitCard(
      onTap: onTap,
      density: VitDensity.tool,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotCompactCardPadding,
      borderColor: danger
          ? _stopRed.withValues(alpha: .48)
          : AppColors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CheckboxMark(selected: selected, color: activeColor),
          const SizedBox(width: TradeSpacingTokens.tradeBotCardGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: danger ? _stopRed : AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: TradeSpacingTokens.tradeBotTinyGap),
                Text(
                  description,
                  style: AppTextStyles.caption.copyWith(
                    color: danger ? AppColors.text2 : AppColors.text3,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImpactSummaryCard extends StatelessWidget {
  const _ImpactSummaryCard({
    required this.botCount,
    required this.reasonLabel,
    required this.closePositions,
    required this.confirmed,
  });

  final int botCount;
  final String? reasonLabel;
  final bool closePositions;
  final bool confirmed;

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Sẽ dừng', '$botCount bot'),
      ('Lý do', reasonLabel ?? 'Chưa chọn'),
      ('Đóng vị thế', closePositions ? 'Có' : 'Không'),
      ('Xác nhận', confirmed ? 'Đã đánh dấu' : 'Chưa'),
    ];
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: TradeSpacingTokens.tradeBotCompactCardPadding,
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    rows[i].$1,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
                const SizedBox(width: TradeSpacingTokens.tradeBotTinyGap),
                Flexible(
                  child: Text(
                    rows[i].$2,
                    textAlign: TextAlign.right,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (i != rows.length - 1)
              const SizedBox(height: TradeSpacingTokens.tradeBotCardGap),
          ],
        ],
      ),
    );
  }
}

class _SupportNotice extends StatelessWidget {
  const _SupportNotice({
    required this.snapshot,
    required this.expanded,
    required this.onToggle,
  });

  final TradeBotEmergencyStopSnapshot snapshot;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: TradeSpacingTokens.tradeBotCompactCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: AppRadii.smRadius,
            child: Row(
              children: [
                const VitAccentIconBox(
                  icon: Icons.shield_outlined,
                  color: AppColors.text2,
                ),
                const SizedBox(width: TradeSpacingTokens.tradeBotCardIconGap),
                Expanded(
                  child: Text(
                    snapshot.supportTitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                Icon(
                  expanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.iconSm,
                ),
              ],
            ),
          ),
          if (expanded) ...[
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            Text(
              snapshot.supportDescription,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                height: 1.35,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
