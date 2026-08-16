part of '../../phone/pages/security/p2p_login_history_page.dart';

class _LoginEventList extends StatelessWidget {
  const _LoginEventList({
    required this.events,
    required this.expandedEventId,
    required this.onToggle,
  });

  final List<P2PLoginEventDraft> events;
  final String? expandedEventId;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PLoginHistoryPage.eventsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < events.length; index++) ...[
          _LoginEventCard(
            event: events[index],
            expanded: expandedEventId == events[index].id,
            onTap: () => onToggle(events[index].id),
          ),
          if (index != events.length - 1)
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ],
      ],
    );
  }
}

class _LoginEventCard extends StatelessWidget {
  const _LoginEventCard({
    required this.event,
    required this.expanded,
    required this.onTap,
  });

  final P2PLoginEventDraft event;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(event.status);

    return VitCard(
      key: P2PLoginHistoryPage.eventKey(event.id),
      radius: VitCardRadius.large,
      borderColor: event.status == 'suspicious' ? AppColors.warn : null,
      padding: AppSpacing.zeroInsets,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _EventIcon(event: event, color: color),
                const SizedBox(width: AppSpacing.x3),
                Expanded(child: _EventMainInfo(event: event)),
                const SizedBox(width: AppSpacing.x2),
                _EventTrailing(event: event, expanded: expanded),
              ],
            ),
          ),
          if (expanded) _ExpandedDetails(event: event),
        ],
      ),
    );
  }
}

class _EventIcon extends StatelessWidget {
  const _EventIcon({required this.event, required this.color});

  final P2PLoginEventDraft event;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: P2PSpacingTokens.p2pLoginHistoryIconBox,
      child: Material(
        type: MaterialType.transparency,
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.lgRadius,
        child: Icon(
          _deviceIcon(event.deviceType),
          color: color,
          size: P2PSpacingTokens.p2pLoginHistoryEventIcon,
        ),
      ),
    );
  }
}

class _EventMainInfo extends StatelessWidget {
  const _EventMainInfo({required this.event});

  final P2PLoginEventDraft event;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                event.deviceName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            if (event.isCurrent) ...[
              const SizedBox(width: AppSpacing.x2),
              const _SmallBadge(label: 'Hiện tại', color: AppColors.buy),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          '${event.os} · ${event.browser}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x1,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _InlineMeta(
              icon: Icons.location_on_outlined,
              text: '${event.city}, ${event.country}',
            ),
            Text(
              '·',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            _InlineMeta(icon: Icons.access_time_rounded, text: event.timestamp),
          ],
        ),
      ],
    );
  }
}

class _EventTrailing extends StatelessWidget {
  const _EventTrailing({required this.event, required this.expanded});

  final P2PLoginEventDraft event;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: P2PSpacingTokens.p2pLoginHistoryTrailingMaxWidth,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _StatusBadge(event: event),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          AnimatedRotation(
            turns: expanded ? .5 : 0,
            duration: const Duration(milliseconds: 180),
            child: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.text3,
              size: P2PSpacingTokens.p2pLoginHistoryExpandIcon,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandedDetails extends StatelessWidget {
  const _ExpandedDetails({required this.event});

  final P2PLoginEventDraft event;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: AppSpacing.dividerHairline,
          child: ColoredBox(color: AppColors.divider),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _DetailValue(label: 'Địa chỉ IP', value: event.ip),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: _DetailValue(
                      label: 'Phương thức đăng nhập',
                      value: event.methodLabel,
                    ),
                  ),
                ],
              ),
              if (event.status == 'suspicious') ...[
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                Material(
                  type: MaterialType.transparency,
                  color: AppColors.warn10,
                  borderRadius: AppRadii.mdRadius,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.all(AppSpacing.x2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: AppColors.warn,
                          size: AppSpacing.iconSm,
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Đăng nhập đáng ngờ',
                                style: AppTextStyles.micro.copyWith(
                                  color: AppColors.warn,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.x1),
                              Text(
                                'Vị trí không quen thuộc. Nếu không phải bạn, hãy đổi mật khẩu ngay.',
                                style: AppTextStyles.micro.copyWith(
                                  color: AppColors.text2,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
