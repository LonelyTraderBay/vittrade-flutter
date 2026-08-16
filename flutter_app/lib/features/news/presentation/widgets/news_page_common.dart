part of '../phone/pages/news_page.dart';

class _ArticleSheet extends StatelessWidget {
  const _ArticleSheet({required this.article});

  final NewsArticle article;

  @override
  Widget build(BuildContext context) {
    final type = article.type;
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: NewsSpacingTokens.newsSheetMaxWidth,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight:
                MediaQuery.sizeOf(context).height *
                NewsSpacingTokens.newsSheetMaxHeightFactor,
          ),
          child: VitSheetSurface(
            color: AppColors.bg,
            borderRadius: AppRadii.sheetTopLargeRadius,
            padding: AppSpacing.zeroInsets,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: NewsSpacingTokens.newsSheetHandleMargin,
                  child: SizedBox(
                    width: NewsSpacingTokens.newsSheetHandleWidth,
                    height: NewsSpacingTokens.newsSheetHandleHeight,
                    child: DecoratedBox(
                      decoration: ShapeDecoration(
                        color: AppColors.borderSolid,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadii.pillRadius,
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: NewsSpacingTokens.newsSheetPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(type.emoji, style: AppTextStyles.sectionTitle),
                            const SizedBox(width: AppSpacing.rowGap),
                            VitAccentPill(
                              label: type.label,
                              accentColor: type.color,
                              size: VitStatusPillSize.sm,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: AppSpacing.pageRhythmCompactInnerGap,
                        ),
                        Text(
                          article.title,
                          style: AppTextStyles.sectionTitle.copyWith(
                            height: NewsSpacingTokens.newsSheetTitleLineHeight,
                          ),
                        ),
                        const SizedBox(
                          height: AppSpacing.pageRhythmStandardInnerGap,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_rounded,
                              size: NewsSpacingTokens.newsSheetCalendarIconSize,
                              color: AppColors.text2,
                            ),
                            const SizedBox(width: AppSpacing.formFieldLabelGap),
                            Text(
                              article.publishedAtLabel,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: AppSpacing.pageRhythmStandardInnerGap,
                        ),
                        VitCard(
                          width: double.infinity,
                          density: VitDensity.compact,
                          variant: VitCardVariant.inner,
                          borderColor: AppColors.primary.withValues(alpha: .12),
                          child: Text(
                            article.summary,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.text2,
                              fontStyle: FontStyle.italic,
                              height:
                                  NewsSpacingTokens.newsSheetSummaryLineHeight,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: AppSpacing.pageRhythmStandardInnerGap,
                        ),
                        Text(
                          article.content,
                          style: AppTextStyles.body.copyWith(
                            height: NewsSpacingTokens.newsSheetBodyLineHeight,
                          ),
                        ),
                        const SizedBox(
                          height: NewsSpacingTokens.newsSectionBreak,
                        ),
                        Wrap(
                          spacing: AppSpacing.x3,
                          runSpacing: AppSpacing.x3,
                          children: [
                            for (final tag in article.tags)
                              VitStatusPill(
                                label: tag,
                                status: VitStatusPillStatus.neutral,
                                size: VitStatusPillSize.sm,
                                icon: Icons.sell_outlined,
                              ),
                          ],
                        ),
                        const SizedBox(
                          height: AppSpacing.pageRhythmStandardSectionGap,
                        ),
                        VitCtaButton(
                          key: NewsPage.closeSheetKey,
                          height: VitDensity.compact.controlHeight,
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Đóng',
                            style: AppTextStyles.control.copyWith(
                              color: AppColors.onAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
