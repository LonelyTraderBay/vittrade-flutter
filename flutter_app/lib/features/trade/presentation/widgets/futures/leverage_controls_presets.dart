part of '../../phone/pages/futures/leverage_page.dart';

class _LeverageSlider extends StatelessWidget {
  const _LeverageSlider({
    required this.leverage,
    required this.stops,
    required this.riskColor,
    required this.onChanged,
  });

  final int leverage;
  final List<int> stops;
  final Color riskColor;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Kéo để điều chỉnh',
          style: AppTextStyles.caption.copyWith(fontWeight: AppTextStyles.bold),
        ),
        const SizedBox(height: _leverageSpace),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: AppSpacing.hairlineStroke * 2,
            activeTrackColor: riskColor,
            inactiveTrackColor: AppColors.medalSilverMuted,
            thumbColor: riskColor,
            overlayColor: riskColor.withValues(alpha: .12),
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: AppSpacing.x3,
            ),
            overlayShape: const RoundSliderOverlayShape(
              overlayRadius: AppSpacing.ctaLoadingIcon,
            ),
          ),
          child: Slider(
            key: LeveragePage.sliderKey,
            min: 1,
            max: 100,
            divisions: 99,
            value: leverage.toDouble(),
            onChanged: (value) => onChanged(value.round()),
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        VitPresetChipRow<int>(
          selectedValue: leverage,
          onTap: onChanged,
          gap: WalletSpacingTokens.transferCardGap,
          height: TradeSpacingTokens.tradeBotQuestionIconBox,
          padding: AppSpacing.zeroInsets,
          items: [
            for (final stop in stops)
              VitPresetChipItem(
                key: LeveragePage.stopKey(stop),
                value: stop,
                label: '${stop}x',
                semanticLabel: 'Chọn mức đòn bẩy ${stop}x',
              ),
          ],
        ),
      ],
    );
  }
}

class _PresetGrid extends StatelessWidget {
  const _PresetGrid({
    required this.presets,
    required this.active,
    required this.onChanged,
  });

  final List<int> presets;
  final int active;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Chọn nhanh',
          style: AppTextStyles.caption.copyWith(fontWeight: AppTextStyles.bold),
        ),
        const SizedBox(height: _leverageSpace),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: AppSpacing.zeroInsets,
          itemCount: presets.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: TradeSpacingTokens.leveragePresetGridColumns,
            crossAxisSpacing: WalletSpacingTokens.transferCardGap,
            mainAxisSpacing: _leverageSpace,
            childAspectRatio: TradeSpacingTokens.leveragePresetGridAspectRatio,
          ),
          itemBuilder: (context, index) {
            final leverage = presets[index];
            return _PresetButton(
              leverage: leverage,
              active: leverage == active,
              onTap: () => onChanged(leverage),
            );
          },
        ),
      ],
    );
  }
}

class _PresetButton extends StatelessWidget {
  const _PresetButton({
    required this.leverage,
    required this.active,
    required this.onTap,
  });

  final int leverage;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      key: LeveragePage.presetKey(leverage),
      label: '${leverage}x',
      selected: active,
      onTap: onTap,
      fullWidth: true,
      height: TradeSpacingTokens.tradeBotQuestionIconBox,
      padding: AppSpacing.zeroInsets,
      semanticLabel: 'Chọn nhanh đòn bẩy ${leverage}x',
    );
  }
}
