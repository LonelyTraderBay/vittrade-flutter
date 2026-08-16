part of '../phone/pages/topic_hub_page.dart';

List<Widget> _withSectionGaps(List<Widget> children) {
  if (children.isEmpty) return const [];
  return [
    for (var i = 0; i < children.length; i++) ...[
      if (i > 0) const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
      children[i],
    ],
  ];
}

class _StatusMini extends StatelessWidget {
  const _StatusMini({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: .12),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      ),
      child: Padding(
        padding: LaunchpadSpacingTokens.discoveryMiniBadgePadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

Color _accentForTopic(DiscoveryTopicDraft topic) {
  return switch (topic.id) {
    'crypto' => AppModuleAccents.arena,
    'macro' => AppModuleAccents.predictions,
    'sports' => AppColors.buy,
    'tech' || 'ai' => AppModuleAccents.markets,
    _ => AppColors.text2,
  };
}

IconData _iconForTopic(DiscoveryTopicDraft topic) {
  return switch (topic.iconKey) {
    'fire' => Icons.local_fire_department_rounded,
    'bank' => Icons.account_balance_rounded,
    'arena' => Icons.bolt_rounded,
    'price' => Icons.swap_vert_rounded,
    'news' => Icons.article_rounded,
    _ => Icons.auto_awesome_rounded,
  };
}
