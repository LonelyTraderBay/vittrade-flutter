part of '../../phone/pages/disclosures/regulatory_disclosures_page.dart';

class _DisclosureCard extends StatelessWidget {
  const _DisclosureCard({
    required this.block,
    this.color,
    this.tint,
    this.icon,
    this.numbered = false,
  });

  final TradeRegulatoryDisclosureBlock block;
  final Color? color;
  final Color? tint;
  final IconData? icon;
  final bool numbered;

  @override
  Widget build(BuildContext context) {
    final accent = color ?? AppColors.text1;
    return VitCard(
      width: double.infinity,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      variant: tint == null ? VitCardVariant.standard : VitCardVariant.inner,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: accent,
                  size: TradeSpacingTokens.tradeBotSmallIcon,
                ),
                const SizedBox(width: AppSpacing.x2),
              ],
              Expanded(
                child: Text(
                  block.title,
                  style: AppTextStyles.caption.copyWith(
                    color: accent,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          if (block.body.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.x1),
            Text(
              block.body,
              style: AppTextStyles.micro.copyWith(
                color: color ?? AppColors.text3,
              ),
            ),
          ],
          if (block.items.isNotEmpty) ...[
            if (block.body.isNotEmpty) const SizedBox(height: AppSpacing.x1),
            for (var index = 0; index < block.items.length; index++) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      numbered || block.items[index].startsWith(RegExp(r'\d\.'))
                          ? block.items[index]
                          : '* ${block.items[index]}',
                      style: AppTextStyles.micro.copyWith(
                        color: color ?? AppColors.text3,
                      ),
                    ),
                  ),
                ],
              ),
              if (index != block.items.length - 1)
                const SizedBox(height: AppSpacing.x1),
            ],
          ],
        ],
      ),
    );
  }
}

class _CommitmentCard extends StatelessWidget {
  const _CommitmentCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      borderColor: _legalPrimary,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: _legalPrimary,
            size: TradeSpacingTokens.tradeBotSmallIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: _legalPrimary,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningList extends StatelessWidget {
  const _WarningList({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      borderColor: AppColors.warningBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: _legalAmber,
                size: TradeSpacingTokens.tradeBotSmallIcon,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                title,
                style: AppTextStyles.micro.copyWith(
                  color: _legalAmber,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x1),
          for (final item in items) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    '* $item',
                    style: AppTextStyles.micro.copyWith(color: _legalAmber),
                  ),
                ),
              ],
            ),
            if (item != items.last) const SizedBox(height: AppSpacing.x1),
          ],
        ],
      ),
    );
  }
}

class _LeverageRules extends StatelessWidget {
  const _LeverageRules({required this.rules});

  final List<TradeRegulatoryDisclosureBlock> rules;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Leverage Restrictions by Region',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          for (final rule in rules) ...[
            Text(
              rule.title,
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              rule.body,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            if (rule != rules.last)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
        ],
      ),
    );
  }
}
