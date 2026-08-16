part of '../../phone/pages/hub/launchpad_page.dart';

class _MiniPill extends StatelessWidget {
  const _MiniPill({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: background,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      ),
      child: Padding(
        padding: LaunchpadSpacingTokens.launchpadInlinePillPadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: _launchpadLineHeightCompact,
          ),
        ),
      ),
    );
  }
}
