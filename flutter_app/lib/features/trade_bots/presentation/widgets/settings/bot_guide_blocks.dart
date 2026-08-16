part of '../../phone/pages/settings/bot_guide_page.dart';

class _StepsBlock extends StatelessWidget {
  const _StepsBlock({required this.color, required this.steps});

  final Color color;
  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      density: VitDensity.tool,
      children: [
        Text(
          'Cách hoạt động:',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        for (var i = 0; i < steps.length; i++)
          _StepRow(index: i, color: color, text: steps[i]),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.index,
    required this.color,
    required this.text,
  });

  final int index;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: AppSpacing.contentPad,
          child: Text(
            '${index + 1}.',
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
      ],
    );
  }
}

class _BulletsBlock extends StatelessWidget {
  const _BulletsBlock({
    required this.title,
    required this.titleColor,
    required this.items,
  });

  final String title;
  final Color titleColor;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      variant: VitCardVariant.inner,
      child: VitPageContent(
        rhythm: VitPageRhythm.standard,
        padding: VitContentPadding.none,
        density: VitDensity.tool,
        children: [
          Text(
            title,
            style: AppTextStyles.micro.copyWith(
              color: titleColor,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          for (final item in items) _BulletRow(item: item, color: titleColor),
        ],
      ),
    );
  }
}

class _BulletRow extends StatelessWidget {
  const _BulletRow({required this.item, required this.color});

  final String item;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitBulletRow(
      text: item,
      color: color,
      iconSize: AppSpacing.x2,
      textStyle: AppTextStyles.micro,
    );
  }
}

class _BestForBlock extends StatelessWidget {
  const _BestForBlock({required this.text});

  final String text;

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
          Text(
            'PHÙ HỢP VỚI:',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.medium,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExampleBlock extends StatelessWidget {
  const _ExampleBlock({required this.color, required this.example});

  final Color color;
  final TradeBotGuideExample example;

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Thiết lập:', example.setup, AppColors.text1),
      ('Thời gian:', example.duration, AppColors.text1),
      ('Kết quả:', example.result, AppColors.text1),
      ('Lợi nhuận:', example.profit, _guideGreen),
    ];
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      variant: VitCardVariant.inner,
      borderColor: color.withValues(alpha: .30),
      child: VitPageContent(
        padding: VitContentPadding.none,
        density: VitDensity.tool,
        children: [
          Text(
            'Ví dụ',
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          for (var i = 0; i < rows.length; i++) ...[
            if (i == 3)
              const Divider(
                height: AppSpacing.x3,
                thickness: AppSpacing.dividerHairline,
                color: AppColors.divider,
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: AppSpacing.x7,
                  child: Text(
                    rows[i].$1,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ),
                Expanded(
                  child: Text(
                    rows[i].$2,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.micro.copyWith(
                      color: rows[i].$3,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
