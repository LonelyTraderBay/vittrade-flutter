part of '../../phone/pages/assets/dust_converter_page.dart';

class _TargetSelector extends StatelessWidget {
  const _TargetSelector({
    required this.targets,
    required this.selected,
    required this.onSelected,
  });

  final List<WalletDustTarget> targets;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return VitSegmentedChoice.withPrimaryAccent<String>(
      selected: selected,
      onChanged: onSelected,
      height: AppSpacing.buttonCompact,
      options: [
        for (final target in targets)
          VitSegmentedChoiceOption<String>(
            key: DustConverterPage.targetKey(target.symbol),
            value: target.symbol,
            label: target.symbol,
          ),
      ],
    );
  }
}

class _DustAssetList extends StatelessWidget {
  const _DustAssetList({
    required this.assets,
    required this.selectedIds,
    required this.onToggle,
  });

  final List<WalletDustAsset> assets;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      clip: true,
      padding: AppSpacing.zeroInsets,
      child: Column(
        children: [
          for (var i = 0; i < assets.length; i++) ...[
            _DustAssetRow(
              asset: assets[i],
              selected: selectedIds.contains(assets[i].id),
              onTap: () => onToggle(assets[i].id),
            ),
            if (i < assets.length - 1)
              const Divider(
                height: AppSpacing.dividerHairline,
                thickness: AppSpacing.dividerHairline,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}
