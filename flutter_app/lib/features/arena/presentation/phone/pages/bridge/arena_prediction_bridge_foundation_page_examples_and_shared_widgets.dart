part of 'arena_prediction_bridge_foundation_page.dart';

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({required this.example});

  final ArenaBridgeExampleDraft example;

  @override
  Widget build(BuildContext context) {
    final allowed = example.status == ArenaBridgeExampleStatus.correct;
    final tone = allowed ? ArenaBridgeTone.disclosure : ArenaBridgeTone.blocked;
    final color = _toneColor(tone);
    return VitCard(
      borderColor: color.withValues(alpha: .25),
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                allowed ? Icons.check_rounded : Icons.close_rounded,
                color: color,
                size: ArenaSpacingTokens.arenaBridgeChipIcon,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                allowed ? 'Correct' : 'DO NOT USE',
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            example.title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            example.description,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: _bridgeBodyLineHeight,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _DemoFrame(
            title: example.frameTitle,
            meta: example.evidenceRows.first,
            tone: tone,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (final row in example.evidenceRows) ...[
            _InfoRow(text: row, tone: tone),
            if (row != example.evidenceRows.last)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
        ],
      ),
    );
  }
}

class _DemoFrame extends StatelessWidget {
  const _DemoFrame({
    required this.title,
    required this.meta,
    required this.tone,
  });

  final String title;
  final String meta;
  final ArenaBridgeTone tone;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(tone);
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      borderColor: color.withValues(alpha: .18),
      density: VitDensity.compact,
      child: Row(
        children: [
          _ToneIcon(tone: tone, small: true),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: _bridgeTitleLineHeight,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  meta,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: _bridgeMetricLineHeight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineTitle extends StatelessWidget {
  const _InlineTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: ArenaSpacingTokens.arenaBridgeInlineIcon,
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: ArenaSpacingTokens.arenaBridgeMetricLabelWidth,
          child: Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              height: _bridgeMetricLineHeight,
            ),
          ),
        ),
      ],
    );
  }
}

Widget _bridgeBadge({required String label, required ArenaBridgeTone tone}) {
  return VitStatusPill(
    label: label,
    icon: _toneIcon(tone),
    status: _toneStatus(tone),
    size: VitStatusPillSize.sm,
  );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.text, required this.tone});

  final String text;
  final ArenaBridgeTone tone;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(tone);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          _toneIcon(tone),
          color: color,
          size: ArenaSpacingTokens.arenaBridgeMicroIcon,
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: _bridgeBodyLineHeight,
            ),
          ),
        ),
      ],
    );
  }
}

class _ToneIcon extends StatelessWidget {
  const _ToneIcon({required this.tone, this.small = false});

  final ArenaBridgeTone tone;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(tone);
    final size = small
        ? ArenaSpacingTokens.arenaBridgeCompactIconBox
        : ArenaSpacingTokens.arenaBridgeIconBox;
    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: color.withValues(alpha: .12),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color.withValues(alpha: .20)),
          borderRadius: small ? AppRadii.inputRadius : AppRadii.mdRadius,
        ),
        child: Icon(
          _toneIcon(tone),
          color: color,
          size: small
              ? ArenaSpacingTokens.arenaBridgeCompactGlyph
              : ArenaSpacingTokens.arenaBridgeGlyph,
        ),
      ),
    );
  }
}

class _DisclosureFooter extends StatelessWidget {
  const _DisclosureFooter({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.text3,
            size: ArenaSpacingTokens.arenaBridgeSmallIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: _bridgeBodyLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _SectionConfig {
  const _SectionConfig({
    required this.section,
    required this.id,
    required this.label,
    required this.icon,
  });

  final _BridgeSection section;
  final String id;
  final String label;
  final IconData icon;
}

const _sectionConfigs = [
  _SectionConfig(
    section: _BridgeSection.principles,
    id: 'principles',
    label: 'Principles',
    icon: Icons.menu_book_outlined,
  ),
  _SectionConfig(
    section: _BridgeSection.topics,
    id: 'topics',
    label: 'Topics',
    icon: Icons.layers_outlined,
  ),
  _SectionConfig(
    section: _BridgeSection.boundary,
    id: 'boundary',
    label: 'Boundary',
    icon: Icons.shield_outlined,
  ),
  _SectionConfig(
    section: _BridgeSection.bridge,
    id: 'bridge',
    label: 'Bridge',
    icon: Icons.link_rounded,
  ),
  _SectionConfig(
    section: _BridgeSection.examples,
    id: 'examples',
    label: 'Examples',
    icon: Icons.visibility_outlined,
  ),
];

Color _toneColor(ArenaBridgeTone tone) {
  return switch (tone) {
    ArenaBridgeTone.content => AppColors.primary,
    ArenaBridgeTone.arena => AppModuleAccents.arena,
    ArenaBridgeTone.prediction => AppModuleAccents.predictions,
    ArenaBridgeTone.disclosure => AppColors.buy,
    ArenaBridgeTone.danger => AppColors.sell,
    ArenaBridgeTone.blocked => AppColors.sell,
    ArenaBridgeTone.neutral => AppColors.text2,
  };
}

IconData _toneIcon(ArenaBridgeTone tone) {
  return switch (tone) {
    ArenaBridgeTone.content => Icons.link_rounded,
    ArenaBridgeTone.arena => Icons.sports_esports_outlined,
    ArenaBridgeTone.prediction => Icons.shield_outlined,
    ArenaBridgeTone.disclosure => Icons.info_outline_rounded,
    ArenaBridgeTone.danger => Icons.warning_amber_rounded,
    ArenaBridgeTone.blocked => Icons.close_rounded,
    ArenaBridgeTone.neutral => Icons.shield_outlined,
  };
}

VitStatusPillStatus _toneStatus(ArenaBridgeTone tone) {
  return switch (tone) {
    ArenaBridgeTone.content => VitStatusPillStatus.info,
    ArenaBridgeTone.arena => VitStatusPillStatus.purple,
    ArenaBridgeTone.prediction => VitStatusPillStatus.info,
    ArenaBridgeTone.disclosure => VitStatusPillStatus.success,
    ArenaBridgeTone.danger => VitStatusPillStatus.error,
    ArenaBridgeTone.blocked => VitStatusPillStatus.error,
    ArenaBridgeTone.neutral => VitStatusPillStatus.neutral,
  };
}
