part of '../../phone/pages/tools/launchpad_webhooks_page.dart';

class _SheetInputField extends StatelessWidget {
  const _SheetInputField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.onChanged,
    this.monospace = false,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool monospace;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        VitInput(
          controller: controller,
          onChanged: onChanged,
          semanticLabel: label,
          hintText: hint,
          textStyle:
              (monospace ? AppTextStyles.monoCode : AppTextStyles.caption)
                  .copyWith(color: AppColors.text1),
        ),
      ],
    );
  }
}

class _ChoiceGroup extends StatelessWidget {
  const _ChoiceGroup({
    required this.label,
    required this.items,
    required this.active,
    required this.colorFor,
    required this.onChanged,
  });

  final String label;
  final List<String> items;
  final String active;
  final Color Function(String value) colorFor;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final item in items) ...[
                VitChoicePill(
                  label: item,
                  accentColor: colorFor(item),
                  selected: active == item,
                  onTap: () => onChanged(item),
                  padding: LaunchpadSpacingTokens.launchpadPillPadding,
                ),
                const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
