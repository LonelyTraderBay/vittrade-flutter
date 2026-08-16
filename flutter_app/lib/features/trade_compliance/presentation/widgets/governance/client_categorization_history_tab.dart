part of '../../phone/pages/governance/client_categorization_page.dart';

class _HistoryTab extends StatelessWidget {
  const _HistoryTab({required this.categories, required this.history});

  final List<TradeClientCategoryInfo> categories;
  final List<TradeClientCategoryHistory> history;

  @override
  Widget build(BuildContext context) {
    String labelFor(String id) =>
        categories.firstWhere((item) => item.id == id).label;
    return VitPageSection(
      label: 'Lịch sử hạng',
      density: VitDensity.tool,
      children: [
        for (final entry in history)
          VitCard(
            density: VitDensity.tool,
            radius: VitCardRadius.tight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _CategoryIcon(
                  style: _CategoryStyle(
                    color: _clientPrimary,
                    icon: Icons.schedule_rounded,
                  ),
                  size: TradeSpacingTokens.tradeBotClientHistoryIcon,
                  iconSize: TradeSpacingTokens.tradeBotClientHistoryIconGlyph,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: VitPageContent(
                    rhythm: VitPageRhythm.standard,
                    padding: VitContentPadding.none,
                    fullBleed: true,
                    density: VitDensity.tool,
                    children: [
                      Text(
                        _historyActionLabel(entry.action),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      if (entry.fromCategoryId != null)
                        Text(
                          '${labelFor(entry.fromCategoryId!)} → ${labelFor(entry.toCategoryId)}',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      Text(
                        entry.reason,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      Text(
                        _formatHistoryDate(entry.date),
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

String _historyActionLabel(String action) {
  return switch (action) {
    'opt-up-requested' => 'Đã gửi yêu cầu nâng hạng',
    'opt-up-approved' => 'Đã duyệt nâng hạng',
    'opt-down' => 'Đã hạ hạng',
    _ => 'Phân loại ban đầu',
  };
}

String _formatHistoryDate(String date) {
  return switch (date) {
    '2026-03-08' => '8 tháng 3, 2026',
    '2025-12-15' => '15 tháng 12, 2025',
    _ => date,
  };
}
