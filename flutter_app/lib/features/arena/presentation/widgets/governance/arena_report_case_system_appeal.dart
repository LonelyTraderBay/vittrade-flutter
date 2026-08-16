part of '../../phone/pages/governance/arena_report_case_page.dart';

class _SystemNoteCard extends StatelessWidget {
  const _SystemNoteCard({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return _SectionBlock(
      title: 'Ghi chú hệ thống',
      accentColor: AppColors.text3,
      child: VitCard(
        density: VitDensity.compact,
        child: _SystemNotePanel(note: note),
      ),
    );
  }
}

class _SystemNotePanel extends StatelessWidget {
  const _SystemNotePanel({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      ),
      child: Padding(
        padding: _reportInnerPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline,
              color: AppColors.text3,
              size: _reportSmallIcon,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                note,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: _reportNoticeLineHeight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppealNotice extends StatelessWidget {
  const _AppealNotice({required this.state, required this.onAppeal});

  final ArenaReportReviewState state;
  final VoidCallback onAppeal;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: AppColors.warningBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _ToneIcon(
                icon: Icons.balance_outlined,
                color: AppColors.warn,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      !state.canAppeal
                          ? 'Khiếu nại đã ghi nhận'
                          : 'Bạn có thể khiếu nại',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Nếu cho rằng kết luận chưa chính xác, bạn có thể mở khiếu nại trong 7 ngày kể từ ngày kết luận.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: _reportNoticeLineHeight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          if (!state.canAppeal)
            const VitStatusPill(
              label: 'Đã gửi yêu cầu xem xét',
              status: VitStatusPillStatus.warning,
              size: VitStatusPillSize.md,
            )
          else
            VitCtaButton(
              onPressed: onAppeal,
              variant: VitCtaButtonVariant.ghost,
              fullWidth: false,
              height: _reportAppealCtaHeight,
              child: const Text('Mở khiếu nại'),
            ),
        ],
      ),
    );
  }
}

class _LinkedActionRow extends StatelessWidget {
  const _LinkedActionRow({
    super.key,
    required this.icon,
    required this.title,
    required this.accentColor,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      density: VitDensity.compact,
      child: Row(
        children: [
          Icon(icon, color: accentColor, size: _reportInlineIcon),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.body.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: AppColors.text3,
            size: _reportInlineIcon,
          ),
        ],
      ),
    );
  }
}
