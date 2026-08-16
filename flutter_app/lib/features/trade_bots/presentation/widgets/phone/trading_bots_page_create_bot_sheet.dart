part of '../../phone/pages/hub/trading_bots_page.dart';

class _StrategyCard extends StatelessWidget {
  const _StrategyCard({required this.strategy, required this.onCreate});

  final TradeBotStrategy strategy;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final color = Color(strategy.colorHex);
    return VitCard(
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotStrategyCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VitAccentIconBox(icon: _botIconData(strategy.icon), color: color),
              const SizedBox(width: TradeSpacingTokens.tradeBotCardIconGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            strategy.name,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.baseMedium.copyWith(
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: TradeSpacingTokens.tradeBotInlineIconGap,
                        ),
                        VitStatusPill(
                          label: _riskStyle(strategy.risk).$1,
                          status: _riskStatus(strategy.risk),
                          size: VitStatusPillSize.sm,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Text(
                      strategy.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              VitAccentPill(
                label: strategy.avgReturn,
                accentColor: AppColors.buy,
                size: VitStatusPillSize.sm,
              ),
              VitAccentPill(
                label: strategy.suitableFor,
                accentColor: AppColors.text2,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCtaButton(
            key: TradingBotsPage.strategyCreateKey(strategy.id),
            onPressed: onCreate,
            density: VitDensity.tool,
            height: TradeSpacingTokens.tradeBotSheetActionHeight,
            leading: const Icon(Icons.add_rounded),
            child: const Text('Tạo bot'),
          ),
        ],
      ),
    );
  }
}

class _EmptyBots extends StatelessWidget {
  const _EmptyBots({
    required this.suggestedStrategies,
    required this.onAdd,
    required this.onCreateSuggested,
  });

  final List<TradeBotStrategy> suggestedStrategies;
  final VoidCallback onAdd;
  final ValueChanged<TradeBotStrategy> onCreateSuggested;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitEmptyState(
          title: 'Chưa có bot nào',
          message: 'Khám phá chiến lược phù hợp để khởi chạy bot đầu tiên.',
          icon: Icons.smart_toy_outlined,
          actionLabel: 'Khám phá chiến lược',
          actionKey: TradingBotsPage.addBotKey,
          onAction: onAdd,
        ),
        if (suggestedStrategies.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          const VitSectionHeader(
            title: 'Gợi ý bắt đầu',
            variant: VitSectionHeaderVariant.plain,
            density: VitDensity.tool,
            bottomGap: AppSpacing.x2,
          ),
          for (final strategy in suggestedStrategies) ...[
            _StrategyCard(
              strategy: strategy,
              onCreate: () => onCreateSuggested(strategy),
            ),
            if (strategy != suggestedStrategies.last)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
        ],
      ],
    );
  }
}

class _CreateBotSheet extends StatefulWidget {
  const _CreateBotSheet({required this.strategy});

  final TradeBotStrategy strategy;

  @override
  State<_CreateBotSheet> createState() => _CreateBotSheetState();
}

class _CreateBotSheetState extends State<_CreateBotSheet> {
  bool _agreed = false;
  bool _submitting = false;
  late final Map<String, String> _values;
  late final Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _values = {
      for (final param in widget.strategy.params) param.key: param.defaultValue,
    };
    _controllers = {
      for (final param in widget.strategy.params)
        if (param.type == 'number')
          param.key: TextEditingController(text: param.defaultValue),
    };
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strategy = widget.strategy;
    final color = Color(strategy.colorHex);
    return VitSheetPanel(
      title: strategy.name,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                VitAccentIconBox(
                  icon: _botIconData(strategy.icon),
                  color: color,
                ),
                const SizedBox(width: TradeSpacingTokens.tradeBotCardIconGap),
                Expanded(
                  child: Text(
                    strategy.suitableFor,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
                VitIconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icons.close_rounded,
                  tooltip: 'Đóng',
                  variant: VitIconButtonVariant.transparent,
                  size: VitIconButtonSize.md,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            VitCard(
              density: VitDensity.tool,
              radius: VitCardRadius.tight,
              padding: TradeSpacingTokens.tradeBotInnerPanelPadding,
              variant: VitCardVariant.inner,
              borderColor: color.withValues(alpha: .22),
              child: Text(
                strategy.longDescription,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            const VitSectionHeader(
              title: 'Thông số bot',
              variant: VitSectionHeaderVariant.plain,
              density: VitDensity.tool,
              bottomGap: AppSpacing.pageRhythmFormInnerGap,
            ),
            for (final param in strategy.params) ...[
              _ParamEditor(
                param: param,
                color: color,
                value: _values[param.key]!,
                controller: _controllers[param.key],
                onChanged: (value) =>
                    setState(() => _values[param.key] = value),
              ),
              const SizedBox(height: AppSpacing.pageRhythmFormInnerGap),
            ],
            VitCard(
              density: VitDensity.tool,
              radius: VitCardRadius.tight,
              padding: TradeSpacingTokens.tradeBotInnerPanelPadding,
              variant: VitCardVariant.inner,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Xem lại trước khi khởi chạy',
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: AppTextStyles.bold,
                      color: AppColors.text1,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmFormInnerGap),
                  for (final param in strategy.params) ...[
                    VitKeyValueRow(
                      label: param.label,
                      value: _values[param.key] ?? param.defaultValue,
                    ),
                    if (param != strategy.params.last)
                      const SizedBox(
                        height: AppSpacing.pageRhythmCompactInnerGap,
                      ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  key: TradingBotsPage.sheetAgreeKey,
                  value: _agreed,
                  onChanged: _submitting
                      ? null
                      : (value) => setState(() => _agreed = value ?? false),
                  activeColor: color,
                  checkColor: AppColors.onAccent,
                  side: const BorderSide(color: AppColors.borderSolid),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
                const SizedBox(width: TradeSpacingTokens.tradeBotInlineIconGap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tôi hiểu các rủi ro và đồng ý với điều khoản sử dụng Bot',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                      const SizedBox(
                        height: AppSpacing.pageRhythmCompactInnerGap,
                      ),
                      GestureDetector(
                        key: TradingBotsPage.sheetTermsKey,
                        onTap: () {
                          final router = GoRouter.of(context);
                          Navigator.pop(context);
                          router.go(AppRoutePaths.tradeBotTermsOfService);
                        },
                        child: Text(
                          'Xem điều khoản sử dụng',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            VitCtaButton(
              key: TradingBotsPage.sheetCreateKey,
              onPressed: _agreed && !_submitting ? _submit : null,
              loading: _submitting,
              density: VitDensity.tool,
              height: TradeSpacingTokens.tradeBotSheetActionHeight,
              variant: _agreed
                  ? VitCtaButtonVariant.primary
                  : VitCtaButtonVariant.secondary,
              child: Text(
                _agreed
                    ? 'Khởi chạy ${strategy.name}'
                    : 'Đồng ý điều khoản để tiếp tục',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (_submitting) return;
    setState(() => _submitting = true);
    for (final entry in _controllers.entries) {
      _values[entry.key] = entry.value.text.trim();
    }
    Navigator.pop(context, Map<String, String>.from(_values));
  }
}

class _ParamEditor extends StatelessWidget {
  const _ParamEditor({
    required this.param,
    required this.color,
    required this.value,
    required this.onChanged,
    this.controller,
  });

  final TradeBotParam param;
  final Color color;
  final String value;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final label = param.unit == null
        ? param.label
        : '${param.label} (${param.unit})';

    if (param.type == 'select' && param.options.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.formFieldLabelGap),
          VitPresetChipRow<String>(
            key: TradingBotsPage.paramFieldKey(param.key),
            items: [
              for (final option in param.options)
                VitPresetChipItem(value: option, label: option),
            ],
            selectedValue: value,
            accentColor: color,
            onTap: onChanged,
          ),
        ],
      );
    }

    final fieldController = controller;
    if (fieldController == null) {
      return Text(
        '$label: $value',
        style: AppTextStyles.caption.copyWith(color: AppColors.text2),
      );
    }

    return VitInput(
      key: TradingBotsPage.paramFieldKey(param.key),
      controller: fieldController,
      label: label,
      keyboardType: param.type == 'number'
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      onChanged: onChanged,
    );
  }
}
