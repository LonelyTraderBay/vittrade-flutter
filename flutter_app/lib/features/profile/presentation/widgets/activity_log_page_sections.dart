part of '../phone/pages/activity_log_page.dart';

class _ActivityFilterRow extends StatelessWidget {
  const _ActivityFilterRow({
    required this.filters,
    required this.activeFilter,
    required this.onChanged,
  });

  final List<ProfileActivityFilter> filters;
  final String activeFilter;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final filter in filters) ...[
          VitChoicePill(
            key: ActivityLogPage.filterKey(filter.id),
            label: filter.label,
            selected: filter.id == activeFilter,
            onTap: () => onChanged(filter.id),
            height: VitDensity.compact.controlHeight,
            padding: ProfileSpacingTokens.profileActivityFilterChipPadding,
            accentColor: _activityPrimary,
          ),
          if (filter != filters.last)
            const SizedBox(
              width: ProfileSpacingTokens.profileActivityFilterChipGap,
            ),
        ],
      ],
    );
  }
}

class _SuspiciousBanner extends StatelessWidget {
  const _SuspiciousBanner({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ActivityLogPage.warningKey,
      density: VitDensity.compact,
      borderColor: _activityAmber.withValues(alpha: .34),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _activityAmber,
            size: ProfileSpacingTokens.profileActivityBannerIcon,
          ),
          const SizedBox(
            width: ProfileSpacingTokens.profileActivityBannerIconGap,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ph\u00E1t hi\u1EC7n $count ho\u1EA1t \u0111\u1ED9ng \u0111\u00E1ng ng\u1EDD',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: _activityAmber,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Vui l\u00F2ng ki\u1EC3m tra v\u00E0 \u0111\u1ED5i m\u1EADt kh\u1EA9u n\u1EBFu kh\u00F4ng ph\u1EA3i b\u1EA1n',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: _activityAmber),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.log});

  final ProfileActivityLog log;

  @override
  Widget build(BuildContext context) {
    final type = _typeConfig(log.type);
    final status = _statusConfig(log.status);
    final suspicious = log.status == 'suspicious';

    return VitCard(
      key: ActivityLogPage.logKey(log.id),
      density: VitDensity.compact,
      borderColor: suspicious
          ? _activityAmber.withValues(alpha: .32)
          : _activityBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ActivityIcon(config: type),
              const SizedBox(
                width: ProfileSpacingTokens.profileActivityIconGap,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            type.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: ProfileSpacingTokens
                              .profileActivityTitleStatusGap,
                        ),
                        VitAccentPill(
                          label: status.label,
                          accentColor: status.color,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      log.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
              if (suspicious) ...[
                const SizedBox(
                  width: ProfileSpacingTokens.profileActivityWarningGap,
                ),
                const Icon(
                  Icons.warning_amber_rounded,
                  color: _activityAmber,
                  size: ProfileSpacingTokens.profileActivityWarningIcon,
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _ActivityDetails(log: log),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          const Divider(
            height: AppSpacing.dividerHairline,
            color: _activityDivider,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            log.timestamp,
            style: AppTextStyles.micro.copyWith(color: _activityMuted),
          ),
        ],
      ),
    );
  }
}

class _ActivityIcon extends StatelessWidget {
  const _ActivityIcon({required this.config});

  final _ActivityTypeConfig config;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ProfileSpacingTokens.profileActivityIconBox,
      height: ProfileSpacingTokens.profileActivityIconBox,
      child: Material(
        color: config.color.withValues(alpha: .16),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.lgRadius),
        child: Icon(
          config.icon,
          color: config.color,
          size: ProfileSpacingTokens.profileActivityIcon,
        ),
      ),
    );
  }
}

class _ActivityDetails extends StatelessWidget {
  const _ActivityDetails({required this.log});

  final ProfileActivityLog log;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _activityPanel2.withValues(alpha: .72),
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
      child: Padding(
        padding: ProfileSpacingTokens.profileActivityDetailsPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: _DetailBlock(
                    icon: Icons.location_on_outlined,
                    label: 'V\u1ECA TR\u00CD',
                    value: log.location,
                  ),
                ),
                const SizedBox(
                  width: ProfileSpacingTokens.profileActivityDetailsColumnGap,
                ),
                Expanded(
                  child: _DetailBlock(
                    icon: Icons.desktop_windows_outlined,
                    label: 'THI\u1EBET B\u1ECA',
                    value: log.device,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            _DetailBlock(label: 'IP ADDRESS', value: log.ipAddress),
          ],
        ),
      ),
    );
  }
}
