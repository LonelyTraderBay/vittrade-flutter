part of '../../phone/pages/settings/bot_guide_page.dart';

class _BestPracticesView extends StatelessWidget {
  const _BestPracticesView({required this.items});

  final List<TradeBotGuidePractice> items;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Phương pháp tốt nhất',
      density: VitDensity.tool,
      children: [
        for (final item in items)
          _InfoCard(
            icon: _practiceIcon(item.iconKey),
            iconColor: _guidePrimary,
            title: item.title,
            description: item.description,
          ),
      ],
    );
  }
}

class _MistakesView extends StatelessWidget {
  const _MistakesView({required this.items});

  final List<TradeBotGuideMistake> items;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Sai lầm thường gặp cần tránh',
      density: VitDensity.tool,
      children: [for (final item in items) _MistakeCard(item: item)],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: AppSpacing.inputPrefixIcon),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  description,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MistakeCard extends StatelessWidget {
  const _MistakeCard({required this.item});

  final TradeBotGuideMistake item;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      child: VitPageContent(
        rhythm: VitPageRhythm.standard,
        padding: VitContentPadding.none,
        density: VitDensity.tool,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.cancel_outlined,
                color: _guideRed,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  item.mistake,
                  style: AppTextStyles.caption.copyWith(
                    color: _guideRed,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: AppSpacing.x6),
              Expanded(
                child: VitPageContent(
                  rhythm: VitPageRhythm.standard,
                  padding: VitContentPadding.none,
                  density: VitDensity.tool,
                  children: [
                    Text(
                      'TẠI SAO SAI:',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    Text(
                      item.why,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                    VitCard(
                      radius: VitCardRadius.tight,
                      density: VitDensity.tool,
                      padding: AppSpacing.cardPaddingCompact,
                      variant: VitCardVariant.inner,
                      borderColor: _guideGreen.withValues(alpha: .24),
                      child: VitPageContent(
                        padding: VitContentPadding.none,
                        density: VitDensity.tool,
                        children: [
                          Text(
                            'CÁCH KHẮC PHỤC:',
                            style: AppTextStyles.micro.copyWith(
                              color: _guideGreen,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          Text(
                            item.fix,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VideoTutorialsCard extends StatelessWidget {
  const _VideoTutorialsCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      variant: VitCardVariant.inner,
      child: VitPageContent(
        padding: VitContentPadding.none,
        density: VitDensity.tool,
        children: [
          Row(
            children: [
              const Icon(
                Icons.play_arrow_outlined,
                color: _guidePrimary,
                size: 22,
              ),
              const SizedBox(width: AppSpacing.x3),
              Text(
                'Video hướng dẫn',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          Text(
            'Xem video hướng dẫn từng bước để nắm vững từng chiến lược bot.',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          VitCtaButton(
            density: VitDensity.tool,
            onPressed: () => _showComingSoon(context),
            child: const Text('Xem tất cả hướng dẫn'),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    unawaited(HapticFeedback.selectionClick());
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Video hướng dẫn',
        message: 'Danh sách hướng dẫn đầy đủ sẽ sớm ra mắt',
      ),
    );
  }
}
