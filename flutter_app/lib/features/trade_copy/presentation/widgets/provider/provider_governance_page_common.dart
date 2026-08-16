part of '../../phone/pages/provider/provider_governance_page.dart';

class _MessagePanel extends StatelessWidget {
  const _MessagePanel({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: AppColors.modalScrim,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: VitCard(
            radius: VitCardRadius.standard,
            density: VitDensity.tool,
            child: VitPageContent(
              rhythm: VitPageRhythm.standard,
              padding: VitContentPadding.none,
              density: VitDensity.tool,
              fullBleed: true,
              children: [
                const Text(
                  'Broadcast Message',
                  style: AppTextStyles.baseMedium,
                ),
                Text(
                  'Send announcement to all followers',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
                _RequestButton(onPressed: onClose),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Color _modificationColor(String type) {
  switch (type) {
    case 'fee_structure':
      return AppColors.buy;
    case 'risk_level':
      return AppColors.sell;
    default:
      return _governanceWarning;
  }
}
