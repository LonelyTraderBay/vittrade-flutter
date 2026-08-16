part of '../../phone/pages/governance/client_categorization_page.dart';

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({
    required this.categories,
    required this.currentCategoryId,
  });

  final List<TradeClientCategoryInfo> categories;
  final String currentCategoryId;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.tool,
      children: [
        VitPageSection(
          label: 'Hạng khách hàng',
          density: VitDensity.tool,
          children: [
            for (final category in categories)
              _CategoryCard(
                category: category,
                isCurrent: category.id == currentCategoryId,
              ),
          ],
        ),
        const VitPageSection(
          label: 'Muốn hạng chuyên nghiệp?',
          density: VitDensity.tool,
          children: [_OptUpCard()],
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category, required this.isCurrent});

  final TradeClientCategoryInfo category;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final style = _categoryStyle(category.id);
    return VitCard(
      key: ClientCategorizationPage.categoryKey(category.id),
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      child: VitPageContent(
        rhythm: VitPageRhythm.standard,
        padding: VitContentPadding.none,
        fullBleed: true,
        density: VitDensity.tool,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CategoryIcon(
                style: style,
                size: TradeSpacingTokens.tradeBotClientCategoryIcon,
                iconSize: TradeSpacingTokens.tradeBotClientCategoryIconGlyph,
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
                            category.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        if (isCurrent) ...[
                          const SizedBox(width: AppSpacing.x2),
                          Icon(
                            Icons.check_circle_outline,
                            color: style.color,
                            size:
                                TradeSpacingTokens.tradeBotSectionMarkerHeight,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      category.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _MetricBox(
                  label: 'Bảo vệ',
                  value: '${category.protections.length} đang áp dụng',
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MetricBox(
                  label: 'Yêu cầu',
                  value: '${category.requirements.length} tiêu chí',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OptUpCard extends StatelessWidget {
  const _OptUpCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      child: VitPageContent(
        rhythm: VitPageRhythm.standard,
        padding: VitContentPadding.none,
        fullBleed: true,
        density: VitDensity.tool,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _CategoryIcon(
                style: _CategoryStyle(
                  color: _clientPrimary,
                  icon: Icons.trending_up_rounded,
                ),
                size: TradeSpacingTokens.tradeBotClientCategoryIcon,
                iconSize: TradeSpacingTokens.tradeBotClientCategoryIconGlyph,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: VitPageContent(
                  padding: VitContentPadding.none,
                  fullBleed: true,
                  density: VitDensity.tool,
                  children: [
                    Text(
                      'Yêu cầu hạng khách hàng chuyên nghiệp',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      'Nếu bạn đáp ứng tiêu chí, có thể yêu cầu được đối xử như khách hàng chuyên nghiệp với yêu cầu quy định giảm.',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          VitCard(
            variant: VitCardVariant.inner,
            density: VitDensity.tool,
            radius: VitCardRadius.tight,
            borderColor: _clientAmber.withValues(alpha: .24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: _clientAmber,
                  size: TradeSpacingTokens.tradeBotSectionMarkerHeight,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.micro.copyWith(color: _clientAmber),
                      children: [
                        TextSpan(
                          text: 'Cảnh báo: ',
                          style: AppTextStyles.micro.copyWith(
                            color: _clientAmber,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const TextSpan(
                          text:
                              'Nâng hạng nghĩa là bạn từ bỏ một số bảo vệ nhà đầu tư. Việc đảo ngược không dễ.',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          VitCtaButton(
            key: ClientCategorizationPage.optUpKey,
            density: VitDensity.tool,
            leading: const Icon(Icons.description_outlined),
            trailing: const Icon(Icons.chevron_right_rounded),
            onPressed: () =>
                context.go(AppRoutePaths.tradeCopyClientOptUpRequest),
            child: const Text('Bắt đầu đơn nâng hạng'),
          ),
        ],
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}
