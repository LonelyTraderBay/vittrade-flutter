part of 'profile_api_create_pane.dart';

class _ApiCreateDoneButton extends StatelessWidget {
  const _ApiCreateDoneButton();

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: ProfileTabletKeys.apiCreateDone,
      onPressed: () =>
          openProfileDetailRoute(context, AppRoutePaths.profileApi),
      variant: VitCtaButtonVariant.auth,
      density: VitDensity.compact,
      child: const Text('Đã lưu, quay lại'),
    );
  }
}

class _CreateFieldSection extends StatelessWidget {
  const _CreateFieldSection({
    required this.label,
    required this.child,
    this.required = false,
    this.optional,
  });

  final String label;
  final Widget child;
  final bool required;
  final String? optional;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: AppColors.cardBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                label.toUpperCase(),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              if (required) ...[
                const SizedBox(width: AppSpacing.x4),
                Text(
                  '*',
                  style: AppTextStyles.caption.copyWith(color: AppColors.sell),
                ),
              ] else if (optional != null) ...[
                const SizedBox(width: AppSpacing.x4),
                Text(
                  optional!,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          child,
        ],
      ),
    );
  }
}

class _PermissionCard extends StatelessWidget {
  const _PermissionCard({
    required this.permission,
    required this.selected,
    required this.onTap,
  });

  final ProfileApiPermission permission;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = Color(permission.colorHex);

    return VitCard(
      key: ProfileTabletKeys.apiCreatePermission(permission.id),
      onTap: onTap,
      density: VitDensity.compact,
      variant: selected ? VitCardVariant.standard : VitCardVariant.inner,
      borderColor: selected
          ? accent.withValues(alpha: .34)
          : AppColors.cardBorder,
      child: Row(
        children: [
          SizedBox(
            width: ProfileSpacingTokens.profileApiCreatePermissionIconBox,
            height: ProfileSpacingTokens.profileApiCreatePermissionIconBox,
            child: VitCard(
              variant: VitCardVariant.ghost,
              radius: VitCardRadius.tight,
              clip: true,
              padding: EdgeInsets.zero,
              borderColor: selected
                  ? accent.withValues(alpha: .22)
                  : AppColors.cardBorder,
              background: ColoredBox(
                color: selected
                    ? accent.withValues(alpha: .12)
                    : AppColors.surface2,
              ),
              child: Icon(
                switch (permission.iconKey) {
                  'eye' => Icons.visibility_outlined,
                  'refresh' => Icons.sync_rounded,
                  'lock' => Icons.lock_outline_rounded,
                  _ => Icons.check_circle_outline_rounded,
                },
                color: selected ? accent : AppColors.text3,
                size: ProfileSpacingTokens.profileApiCreatePermissionIcon,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        permission.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: selected ? AppColors.text1 : AppColors.text2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (permission.required)
                      Text(
                        ' (bắt buộc)',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x4),
                Text(
                  permission.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          SizedBox(
            width: ProfileSpacingTokens.profileApiCreatePermissionCheck,
            height: ProfileSpacingTokens.profileApiCreatePermissionCheck,
            child: Material(
              color: selected ? accent : AppColors.surface3,
              shape: const CircleBorder(),
              child: selected
                  ? const Icon(
                      Icons.check_rounded,
                      color: AppColors.onAccent,
                      size: ProfileSpacingTokens
                          .profileApiCreatePermissionCheckIcon,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurityTipsCard extends StatelessWidget {
  const _SecurityTipsCard({required this.tips});

  final List<String> tips;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: AppColors.cardBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                color: AppColors.primary,
                size: ProfileSpacingTokens.profileApiCreateTipsIcon,
              ),
              const SizedBox(width: AppSpacing.x4),
              Text(
                'Mẹo bảo mật',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          for (var i = 0; i < tips.length; i++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: ProfileSpacingTokens.profileApiCreateTipsBullet,
                  height: ProfileSpacingTokens.profileApiCreateTipsBullet,
                  child: Material(
                    color: AppColors.primary.withValues(alpha: .14),
                    shape: const CircleBorder(),
                    child: Center(
                      child: Text(
                        '${i + 1}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x4),
                Expanded(
                  child: Text(
                    tips[i],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
            if (i != tips.length - 1) const SizedBox(height: AppSpacing.x4),
          ],
        ],
      ),
    );
  }
}

class _CreateSummaryCard extends StatelessWidget {
  const _CreateSummaryCard({required this.rows});

  final List<ProfileInfoRow> rows;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: AppColors.cardBorder,
      clip: true,
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++)
            VitInfoRow(
              label: rows[i].label,
              value: rows[i].value,
              density: VitDensity.compact,
              showDivider: i != rows.length - 1,
            ),
        ],
      ),
    );
  }
}

enum _CreateWarningTone { amber, danger }

class _CreateWarningCard extends StatelessWidget {
  const _CreateWarningCard({
    required this.text,
    this.tone = _CreateWarningTone.amber,
  });

  final String text;
  final _CreateWarningTone tone;

  @override
  Widget build(BuildContext context) {
    final color = tone == _CreateWarningTone.danger
        ? AppColors.sell
        : AppColors.warn;
    return VitCard(
      density: VitDensity.compact,
      borderColor: color.withValues(alpha: .22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            tone == _CreateWarningTone.danger
                ? Icons.error_outline_rounded
                : Icons.warning_amber_rounded,
            color: color,
            size: ProfileSpacingTokens.profileApiCreateTipsIcon,
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class _KeyResultCard extends StatelessWidget {
  const _KeyResultCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      variant: VitCardVariant.inner,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}
