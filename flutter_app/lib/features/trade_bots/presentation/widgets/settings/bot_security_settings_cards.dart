part of '../../phone/pages/settings/bot_security_settings_page.dart';

class _TwoFaCard extends StatelessWidget {
  const _TwoFaCard({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Row(
        children: [
          Icon(
            Icons.smartphone_rounded,
            color: enabled ? _securityGreen : AppColors.text3,
            size: TradeSpacingTokens.tradeBotCheckbox,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Xác thực 2 lớp cho hành động Bot',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Bắt buộc khi tạo/xoá bot',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          _Switch(
            key: BotSecuritySettingsPage.twoFaToggleKey,
            enabled: enabled,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

class _ApiKeyCard extends StatelessWidget {
  const _ApiKeyCard({required this.apiKey});

  final TradeBotApiKey apiKey;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  apiKey.name,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Row(
                  children: [
                    VitStatusPill(
                      label: apiKey.permissions,
                      status: VitStatusPillStatus.info,
                      size: VitStatusPillSize.sm,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Flexible(
                      child: Text(
                        'Đã tạo ${apiKey.created}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  'Lần dùng cuối: ${apiKey.lastUsed}',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          const Icon(
            Icons.delete_outline_rounded,
            color: _securityRed,
            size: TradeSpacingTokens.tradeBotQuestionIcon,
          ),
        ],
      ),
    );
  }
}

class _IpCard extends StatelessWidget {
  const _IpCard({required this.entry});

  final TradeBotIpWhitelistEntry entry;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  entry.ip,
                  style: AppTextStyles.monoCode.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${entry.label} - Đã thêm ${entry.added}',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.delete_outline_rounded,
            color: _securityRed,
            size: AppSpacing.iconSm,
          ),
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.activities});

  final List<TradeBotSecurityActivity> activities;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: VitPageContent(
        rhythm: VitPageRhythm.standard,
        padding: VitContentPadding.none,
        fullBleed: true,
        density: VitDensity.tool,
        children: [
          for (final activity in activities) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.action,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.medium,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        activity.time,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.circle,
                  color:
                      activity.status == TradeBotSecurityActivityStatus.success
                      ? _securityGreen
                      : _securityAmber,
                  size: TradeSpacingTokens.tradeBotSmallGap,
                ),
              ],
            ),
            if (activity != activities.last)
              const Divider(
                color: AppColors.borderSolid,
                height: AppSpacing.dividerHairline,
              ),
          ],
        ],
      ),
    );
  }
}

class _SecurityTipsCard extends StatelessWidget {
  const _SecurityTipsCard({required this.tips});

  final List<String> tips;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      variant: VitCardVariant.inner,
      child: VitPageContent(
        rhythm: VitPageRhythm.standard,
        padding: VitContentPadding.none,
        fullBleed: true,
        density: VitDensity.tool,
        children: [
          Text(
            'Phương pháp bảo mật tốt nhất',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          for (final tip in tips) _SecurityTipRow(tip: tip),
        ],
      ),
    );
  }
}

class _SecurityTipRow extends StatelessWidget {
  const _SecurityTipRow({required this.tip});

  final String tip;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '-',
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            tip,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ),
      ],
    );
  }
}
