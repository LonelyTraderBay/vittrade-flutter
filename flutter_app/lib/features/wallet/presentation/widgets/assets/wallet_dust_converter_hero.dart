part of '../../phone/pages/assets/dust_converter_page.dart';

class _DustHero extends StatelessWidget {
  const _DustHero({
    required this.snapshot,
    required this.targetSymbol,
    required this.foundCount,
    required this.selectedCount,
    required this.selectedValue,
  });

  final WalletDustConverterSnapshot snapshot;
  final String targetSymbol;
  final int foundCount;
  final int selectedCount;
  final double selectedValue;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      clip: true,
      density: VitDensity.compact,
      borderColor: AppColors.primary20,
      background: const VitHeroGlow(),
      child: Column(
        children: [
          Row(
            children: [
              // card-tile: allow-start — fixed surface, not horizontal strip tile
              VitCard(
                width: _dustHeroIconBox,
                height: _dustHeroIconBox,
                variant: VitCardVariant.ghost,
                radius: VitCardRadius.standard,
                borderColor: _dustAmber.withValues(alpha: .5),
                background: ColoredBox(
                  color: _dustAmber.withValues(alpha: .14),
                ),
                clip: true,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: _dustAmber,
                  size: AppSpacing.iconMd,
                ),
              ),
              const SizedBox(width: _dustInlineGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'D\u1ECDn d\u1EB9p v\u00ED',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: AppTextStyles.bold,
                        color: AppColors.onAccent,
                      ),
                    ),
                    const SizedBox(height: _dustTinyGap),
                    Text(
                      'Chuy\u1EC3n \u0111\u1ED5i s\u1ED1 d\u01B0 nh\u1ECF (d\u01B0\u1EDBi ${_formatUsd(snapshot.dustThresholdUsd)}) sang $targetSymbol',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.onAccent.withValues(alpha: .68),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: _dustGap),
          Row(
            children: [
              _HeroStat(
                value: foundCount.toString(),
                label: 'Dust t\u00ECm th\u1EA5y',
                color: _dustAmber,
              ),
              const SizedBox(width: _dustTinyGap),
              _HeroStat(
                value: selectedCount.toString(),
                label: '\u0110\u00E3 ch\u1ECDn',
                color: AppColors.primary,
              ),
              const SizedBox(width: _dustTinyGap),
              _HeroStat(
                value: _formatUsd(selectedValue),
                label: 'Gi\u00E1 tr\u1ECB',
                color: AppColors.buy,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: VitCard(
        density: VitDensity.tool,
        variant: VitCardVariant.inner,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            const SizedBox(height: _dustTinyGap),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.onAccent.withValues(alpha: .68),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
