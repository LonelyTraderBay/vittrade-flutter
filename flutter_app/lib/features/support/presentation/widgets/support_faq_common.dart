part of '../phone/pages/support_page.dart';

class _FaqPanel extends StatelessWidget {
  const _FaqPanel({
    required this.items,
    required this.expandedIndex,
    required this.onToggle,
  });

  final List<SupportFaqDraft> items;
  final int? expandedIndex;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(
              Icons.help_outline_rounded,
              color: AppModuleAccents.support,
              size: AppSpacing.iconMd,
            ),
            const SizedBox(width: AppSpacing.x3),
            Text(
              'Câu hỏi thường gặp',
              style: AppTextStyles.baseMedium.copyWith(
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitFaqList(
          items: [
            for (var i = 0; i < items.length; i++)
              VitFaqItem(
                question: items[i].question,
                answer: items[i].answer,
                widgetKey: SupportPage.faqKey(i),
              ),
          ],
          expandedIndex: expandedIndex,
          onToggle: onToggle,
          accentColor: AppModuleAccents.support,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitCard(
          variant: VitCardVariant.inner,
          padding: SupportSpacingTokens.supportCardPadding,
          borderColor: AppColors.primary20,
          child: Text(
            'Không tìm thấy câu trả lời? Hãy tạo ticket hoặc liên hệ support qua email/hotline.',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
      ],
    );
  }
}

class _StatusLabel extends StatelessWidget {
  const _StatusLabel({required this.style});

  final _SupportLabelStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(style.icon, color: style.color, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x2),
        Text(
          style.label,
          style: AppTextStyles.navLabel.copyWith(
            color: style.color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

final class _SupportLabelStyle {
  const _SupportLabelStyle({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;
}

_SupportLabelStyle _statusStyle(SupportTicketStatus status) {
  return switch (status) {
    SupportTicketStatus.open => const _SupportLabelStyle(
      label: 'Mở',
      color: AppModuleAccents.support,
      icon: Icons.access_time_rounded,
    ),
    SupportTicketStatus.inProgress => const _SupportLabelStyle(
      label: 'Đang xử lý',
      color: AppColors.warn,
      icon: Icons.error_outline_rounded,
    ),
    SupportTicketStatus.resolved => const _SupportLabelStyle(
      label: 'Đã giải quyết',
      color: AppColors.buy,
      icon: Icons.check_circle_outline_rounded,
    ),
    SupportTicketStatus.closed => const _SupportLabelStyle(
      label: 'Đã đóng',
      color: AppColors.text2,
      icon: Icons.cancel_outlined,
    ),
  };
}

_SupportLabelStyle _priorityStyle(SupportTicketPriority priority) {
  return switch (priority) {
    SupportTicketPriority.low => const _SupportLabelStyle(
      label: 'Thấp',
      color: AppColors.text2,
      icon: Icons.low_priority_rounded,
    ),
    SupportTicketPriority.medium => const _SupportLabelStyle(
      label: 'Trung bình',
      color: AppModuleAccents.support,
      icon: Icons.flag_outlined,
    ),
    SupportTicketPriority.high => const _SupportLabelStyle(
      label: 'Cao',
      color: AppColors.warn,
      icon: Icons.priority_high_rounded,
    ),
    SupportTicketPriority.urgent => const _SupportLabelStyle(
      label: 'Khẩn cấp',
      color: AppColors.sell,
      icon: Icons.warning_amber_rounded,
    ),
  };
}

String _categoryLabel(SupportTicketCategory category) {
  return switch (category) {
    SupportTicketCategory.technical => 'Kỹ thuật',
    SupportTicketCategory.trading => 'Giao dịch',
    SupportTicketCategory.deposit => 'Nạp tiền',
    SupportTicketCategory.withdraw => 'Rút tiền',
    SupportTicketCategory.kyc => 'KYC',
    SupportTicketCategory.other => 'Khác',
  };
}
