part of 'p2p_claim_detail_page.dart';

class _ReviewerNoteCard extends StatelessWidget {
  const _ReviewerNoteCard({required this.note});

  final P2PClaimReviewerNoteDraft note;

  @override
  Widget build(BuildContext context) {
    final isSystem = note.role == 'Tự động';
    return VitCard(
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pClaimCompactCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: AppSpacing.x5,
            backgroundColor: isSystem ? AppColors.buy10 : AppColors.primary12,
            child: Icon(
              isSystem ? Icons.settings_outlined : Icons.person_outline_rounded,
              color: isSystem ? AppColors.buy : AppModuleAccents.p2p,
              size: AppSpacing.iconSm,
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
                        note.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    VitStatusPill(
                      label: note.role,
                      status: isSystem
                          ? VitStatusPillStatus.success
                          : VitStatusPillStatus.info,
                      size: VitStatusPillSize.sm,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  note.content,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: _p2pClaimBodyLine,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  note.timestamp,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationsCard extends StatelessWidget {
  const _NotificationsCard({required this.enabled, required this.onChanged});

  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PClaimDetailPage.notificationsKey,
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pClaimCompactCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: _p2pClaimIconBoxExtent,
            height: _p2pClaimIconBoxExtent,
            child: Material(
              color: AppColors.primary12,
              shape: CircleBorder(),
              child: Icon(
                Icons.notifications_none_rounded,
                color: AppModuleAccents.p2p,
                size: AppSpacing.iconSm,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thông báo cập nhật',
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  enabled
                      ? 'Đang bật, nhận push khi có thay đổi'
                      : 'Đang tắt thông báo claim này',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                const _CheckBullet(text: 'Thay đổi trạng thái claim'),
                const _CheckBullet(text: 'Ghi chú mới từ reviewer'),
                const _CheckBullet(text: 'Yêu cầu bổ sung bằng chứng'),
                const _CheckBullet(text: 'Chi trả hoàn tất'),
              ],
            ),
          ),
          Switch(
            value: enabled,
            activeThumbColor: AppColors.text1,
            activeTrackColor: AppModuleAccents.p2p,
            inactiveThumbColor: AppColors.text3,
            inactiveTrackColor: AppColors.surface3,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _CheckBullet extends StatelessWidget {
  const _CheckBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: P2PSpacingTokens.p2pClaimChecklistPadding,
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.buy,
            size: P2PSpacingTokens.p2pClaimSmallIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pClaimActionPadding,
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: AppColors.text2, size: AppSpacing.iconSm),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.baseMedium.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconMd,
          ),
        ],
      ),
    );
  }
}

class _FeedbackBanner extends StatelessWidget {
  const _FeedbackBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return VitInfoCallout(
      key: P2PClaimDetailPage.feedbackKey,
      message: message,
      icon: Icons.check_circle_outline_rounded,
      accentColor: AppColors.buy,
      iconSize: P2PSpacingTokens.p2pClaimFeedbackIcon,
      padding: P2PSpacingTokens.p2pClaimCompactCardPadding,
      messageColor: AppColors.text1,
      messageWeight: AppTextStyles.medium,
    );
  }
}

VitStatusPillStatus _statusPill(P2PInsuranceClaimStatus status) {
  return switch (status) {
    P2PInsuranceClaimStatus.pending => VitStatusPillStatus.warning,
    P2PInsuranceClaimStatus.reviewing => VitStatusPillStatus.info,
    P2PInsuranceClaimStatus.approved => VitStatusPillStatus.success,
    P2PInsuranceClaimStatus.rejected => VitStatusPillStatus.error,
    P2PInsuranceClaimStatus.paid => VitStatusPillStatus.success,
  };
}

IconData _statusIcon(P2PInsuranceClaimStatus status) {
  return switch (status) {
    P2PInsuranceClaimStatus.pending => Icons.schedule_rounded,
    P2PInsuranceClaimStatus.reviewing => Icons.manage_search_rounded,
    P2PInsuranceClaimStatus.approved => Icons.check_circle_outline_rounded,
    P2PInsuranceClaimStatus.rejected => Icons.cancel_outlined,
    P2PInsuranceClaimStatus.paid => Icons.attach_money_rounded,
  };
}

Color _stepColor(int index) {
  return switch (index) {
    0 => AppColors.text3,
    1 => AppModuleAccents.p2p,
    2 => AppColors.buy,
    _ => AppColors.buy,
  };
}

Color _timelineColor(String statusKey) {
  return switch (statusKey) {
    'submitted' => AppColors.text3,
    'evidence_added' => AppColors.accent,
    'reviewing' => AppModuleAccents.p2p,
    'note_added' => AppColors.accent,
    'approved' => AppColors.buy,
    'rejected' => AppColors.sell,
    'paid' => AppColors.buy,
    _ => AppColors.text3,
  };
}

IconData _timelineIcon(String statusKey) {
  return switch (statusKey) {
    'submitted' => Icons.send_outlined,
    'evidence_added' => Icons.upload_file_rounded,
    'reviewing' => Icons.search_rounded,
    'note_added' => Icons.message_outlined,
    'approved' => Icons.check_circle_outline_rounded,
    'rejected' => Icons.cancel_outlined,
    'paid' => Icons.attach_money_rounded,
    _ => Icons.schedule_rounded,
  };
}

IconData _benchmarkIcon(String id) {
  return switch (id) {
    'amount' => Icons.attach_money_rounded,
    'resolution' => Icons.schedule_rounded,
    'coverage' => Icons.verified_user_outlined,
    _ => Icons.bar_chart_rounded,
  };
}

Color _toneColor(String toneKey) {
  return switch (toneKey) {
    'buy' => AppColors.buy,
    'warn' => AppColors.warn,
    'accent' => AppColors.accent,
    _ => AppModuleAccents.p2p,
  };
}

Color _statusBackground(Color color) {
  if (color == AppColors.buy) return AppColors.buy10;
  if (color == AppColors.sell) return AppColors.sell10;
  if (color == AppColors.accent) return AppColors.accent10;
  if (color == AppModuleAccents.p2p) return AppColors.primary12;
  return AppColors.surface2;
}

String _formatVnd(int value) => formatP2PVnd(value);
