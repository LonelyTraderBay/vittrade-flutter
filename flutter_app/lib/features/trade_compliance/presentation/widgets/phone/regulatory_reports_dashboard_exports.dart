part of '../../phone/pages/hub/regulatory_reports_dashboard_page.dart';

class _ExportsTab extends StatelessWidget {
  const _ExportsTab({required this.onNotice});

  final ValueChanged<String> onNotice;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Export Reports',
      density: VitDensity.tool,
      children: [
        _ExportCard(
          title: 'Xuất ISO 20022 XML',
          subtitle: 'Định dạng quy định chuẩn',
          icon: Icons.description_outlined,
          color: _dashPrimary,
          onTap: () => onNotice('XML export đã được xếp hàng.'),
        ),
        _ExportCard(
          title: 'Báo cáo tuân thủ (PDF)',
          subtitle: 'Tóm tắt điều hành',
          icon: Icons.bar_chart_rounded,
          color: _dashGreen,
          onTap: () => onNotice('PDF export đã được xếp hàng.'),
        ),
        _ExportCard(
          title: 'Xuất dữ liệu thô (CSV)',
          subtitle: 'Tất cả trường, tất cả báo cáo',
          icon: Icons.storage_outlined,
          color: _dashAmber,
          onTap: () => onNotice('CSV export đã được xếp hàng.'),
        ),
      ],
    );
  }
}

class _ExportCard extends StatelessWidget {
  const _ExportCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotInnerPanelPadding,
      borderColor: _dashBorder.withValues(alpha: .7),
      onTap: onTap,
      child: Row(
        children: [
          // card-tile: allow-start — fixed surface, not horizontal strip tile
          VitCard(
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.tight,
            width: TradeSpacingTokens.tradeBotQuestionIconBox,
            height: TradeSpacingTokens.tradeBotQuestionIconBox,
            alignment: Alignment.center,
            borderColor: color.withValues(alpha: .18),
            child: Icon(
              icon,
              color: color,
              size: TradeSpacingTokens.tradeBotActionIcon,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: VitPageContent(
              rhythm: VitPageRhythm.standard,
              padding: VitContentPadding.none,
              density: VitDensity.tool,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.download_rounded,
            color: AppColors.text3,
            size: TradeSpacingTokens.tradeBotActionIcon,
          ),
        ],
      ),
    );
  }
}
