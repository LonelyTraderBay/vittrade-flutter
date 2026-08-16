part of 'arena_challenge_detail_page.dart';

class _SafetySnapshotCard extends StatelessWidget {
  const _SafetySnapshotCard({required this.rows, required this.onSafety});

  final List<ArenaRuleSummaryRow> rows;
  final VoidCallback onSafety;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: _challengeCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.health_and_safety_outlined,
                color: AppColors.buy,
                size: _challengeLgIcon,
              ),
              const SizedBox(width: _challengeTinyGap),
              Expanded(
                child: Text(
                  'An toàn nhanh',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: _challengeGap),
          for (final row in rows)
            _SummaryRow(label: row.label, value: row.value),
          const SizedBox(height: _challengeGap),
          _InlineAction(
            label: 'An toàn & báo cáo',
            icon: Icons.flag_outlined,
            color: AppColors.sell,
            onTap: onSafety,
          ),
        ],
      ),
    );
  }
}

class _ActionStack extends StatelessWidget {
  const _ActionStack({
    required this.onEvidence,
    required this.onReport,
    required this.onBlock,
    required this.onLeave,
  });

  final VoidCallback onEvidence;
  final VoidCallback onReport;
  final VoidCallback onBlock;
  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // card-tile: allow-start — fixed surface, not horizontal strip tile
            VitCard(
              width: _challengeShareSize,
              height: _challengeShareSize,
              radius: VitCardRadius.large,
              onTap: () => HapticFeedback.selectionClick(),
              child: const Center(
                child: Icon(Icons.share_outlined, color: AppColors.text2),
              ),
            ),
            const SizedBox(width: _challengeGap),
            Expanded(
              child: VitCtaButton(
                key: ArenaChallengeDetailPage.evidenceCtaKey,
                onPressed: onEvidence,
                leading: const Icon(Icons.camera_alt_outlined),
                child: const Text('Gửi bằng chứng'),
              ),
            ),
          ],
        ),
        const SizedBox(height: _challengeGap),
        Row(
          children: [
            Expanded(
              child: _SecondaryAction(
                label: 'Rời',
                icon: Icons.cancel_outlined,
                color: AppColors.primary,
                onTap: onLeave,
              ),
            ),
            const SizedBox(width: _challengeTinyGap),
            Expanded(
              child: _SecondaryAction(
                key: ArenaChallengeDetailPage.reportKey,
                label: 'Báo cáo',
                icon: Icons.flag_outlined,
                color: AppColors.sell,
                onTap: onReport,
              ),
            ),
            const SizedBox(width: _challengeTinyGap),
            Expanded(
              child: _SecondaryAction(
                key: ArenaChallengeDetailPage.blockKey,
                label: 'Chặn',
                icon: Icons.block_outlined,
                color: AppColors.text3,
                onTap: onBlock,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RowsSection extends StatelessWidget {
  const _RowsSection({
    required this.title,
    required this.accentColor,
    required this.rows,
  });

  final String title;
  final Color accentColor;
  final List<ArenaRuleSummaryRow> rows;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: title,
      accentColor: accentColor,
      children: [
        VitCard(
          padding: _challengeCardPadding,
          child: Column(
            children: [
              for (final row in rows)
                _SummaryRow(label: row.label, value: row.value),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        vertical: _challengeTinyGap,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: _challengeSummaryLabelWidth,
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          const SizedBox(width: _challengeGap),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                height: AppTextStyles.numericMicro.height,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: _challengeCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VitAccentIconBox(
            icon: icon,
            color: color,
            iconSize: _challengeIconBubbleIcon,
          ),
          const SizedBox(width: _challengeGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: _challengeTinyGap),
                Text(
                  text,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: AppTextStyles.numericMicro.height,
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

class _SecondaryAction extends StatelessWidget {
  const _SecondaryAction({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      onPressed: onTap,
      variant: _secondaryActionVariant(color),
      leading: Icon(icon),
      padding: const EdgeInsetsDirectional.symmetric(horizontal: _challengeGap),
      child: Text(label),
    );
  }
}

class _InlineAction extends StatelessWidget {
  const _InlineAction({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      padding: const EdgeInsetsDirectional.symmetric(
        vertical: AppSpacing.x1 - AppSpacing.dividerHairline,
      ),
      onTap: onTap,
      child: Row(
        children: [
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const SizedBox(width: _challengeTinyGap),
          Icon(icon, color: color, size: _challengeSmallIcon),
        ],
      ),
    );
  }
}

class _SmallIcon extends StatelessWidget {
  const _SmallIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: color, size: _challengeMdIcon);
  }
}

class _InitialBadge extends StatelessWidget {
  const _InitialBadge({required this.name, required this.color});

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();
    return SizedBox(
      width: _challengeInitialBadge,
      height: _challengeInitialBadge,
      child: Material(
        color: color.withValues(alpha: .16),
        borderRadius: AppRadii.xsRadius,
        child: Center(
          child: Text(
            initial,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              height: AppTextStyles.microTiny.height,
            ),
          ),
        ),
      ),
    );
  }
}

class _ArenaFooterNotice extends StatelessWidget {
  const _ArenaFooterNotice();

  @override
  Widget build(BuildContext context) {
    return VitBanner(
      variant: _bannerVariantForColor(_arenaAccent),
      icon: Icons.shield_outlined,
      message:
          'Arena Points chỉ dùng trong Open Arena, không phải tài sản tài chính. Không thỏa thuận giao dịch ngoài nền tảng.',
    );
  }
}

String _formatCompact(int value) {
  if (value >= 1000 && value % 1000 == 0) return '${value ~/ 1000}K';
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
  return '$value';
}

VitBannerVariant _bannerVariantForColor(Color color) {
  if (color == AppColors.warn) {
    return VitBannerVariant.warning;
  }
  if (color == AppColors.sell) {
    return VitBannerVariant.error;
  }
  return VitBannerVariant.info;
}

VitCtaButtonVariant _secondaryActionVariant(Color color) {
  if (color == AppColors.sell) {
    return VitCtaButtonVariant.danger;
  }
  if (color == AppColors.text3) {
    return VitCtaButtonVariant.ghost;
  }
  return VitCtaButtonVariant.secondary;
}
