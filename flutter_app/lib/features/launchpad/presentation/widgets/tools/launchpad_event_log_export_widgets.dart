part of '../../phone/pages/tools/launchpad_event_log_page.dart';

class _ExportSheet extends StatelessWidget {
  const _ExportSheet({
    required this.formats,
    required this.activeFormat,
    required this.count,
    required this.copied,
    required this.onFormatChanged,
    required this.onClose,
    required this.onCopy,
  });

  final List<LaunchpadEventLogExportFormatDraft> formats;
  final String activeFormat;
  final int count;
  final bool copied;
  final ValueChanged<String> onFormatChanged;
  final VoidCallback onClose;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      key: LaunchpadEventLogPage.exportSheetKey,
      color: AppColors.dynamicIslandBg.withValues(alpha: .72),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: LaunchpadSpacingTokens.launchpadSheetMaxWidth,
          ),
          child: SizedBox(
            width: double.infinity,
            child: DecoratedBox(
              decoration: const ShapeDecoration(
                color: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadii.cardLargeRadius,
                ),
              ),
              child: Padding(
                padding: LaunchpadSpacingTokens.launchpadConfirmSheetPadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: SizedBox(
                        width: LaunchpadSpacingTokens.launchpadBox44,
                        height: AppSpacing.x1,
                        child: DecoratedBox(
                          decoration: ShapeDecoration(
                            color: AppColors.borderSolid,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadii.xlRadius,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardSectionGap,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Export Event Log',
                            style: AppTextStyles.base.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.extraBold,
                            ),
                          ),
                        ),
                        VitIconButton(
                          onPressed: onClose,
                          icon: Icons.close_rounded,
                          tooltip: 'Dong export event log',
                          variant: VitIconButtonVariant.transparent,
                          size: VitIconButtonSize.md,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardInnerGap,
                    ),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            '$count',
                            style: AppTextStyles.pageTitle.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.heavy,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),
                          Text(
                            'events se duoc export',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardSectionGap,
                    ),
                    Text(
                      'Dinh dang',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Row(
                      children: [
                        for (final format in formats) ...[
                          Expanded(
                            child: _ExportFormatTile(
                              key: LaunchpadEventLogPage.formatKey(
                                format.value,
                              ),
                              format: format,
                              active: activeFormat == format.value,
                              onTap: () => onFormatChanged(format.value),
                            ),
                          ),
                          if (format != formats.last)
                            const SizedBox(width: AppSpacing.x2),
                        ],
                      ],
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardSectionGap,
                    ),
                    VitCard(
                      variant: VitCardVariant.inner,
                      padding: LaunchpadSpacingTokens.launchpadPaddingX3,
                      child: Text(
                        _previewFor(activeFormat, count),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          height:
                              LaunchpadSpacingTokens.launchpadLineHeightShort,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardSectionGap,
                    ),
                    VitCtaButton(
                      key: LaunchpadEventLogPage.copyButtonKey,
                      onPressed: onCopy,
                      variant: copied
                          ? VitCtaButtonVariant.success
                          : VitCtaButtonVariant.primary,
                      leading: Icon(
                        copied ? Icons.check_rounded : Icons.copy_rounded,
                        color: AppColors.onAccent,
                        size: LaunchpadSpacingTokens.launchpadIcon2xl,
                      ),
                      child: Text(
                        copied
                            ? 'Da copy vao clipboard'
                            : 'Copy $count events (${activeFormat.toUpperCase()})',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _previewFor(String format, int count) {
    return switch (format) {
      'json' => '{"count": $count, "entries": [...]}',
      'csv' => 'timestamp,level,source,message\n23:36:08,info,Bridge,...',
      _ =>
        '=== Launchpad Event Log ===\n[23:36:08] [INFO] Bridge\n  Bridge transaction initiated',
    };
  }
}

class _ExportFormatTile extends StatelessWidget {
  const _ExportFormatTile({
    super.key,
    required this.format,
    required this.active,
    required this.onTap,
  });

  final LaunchpadEventLogExportFormatDraft format;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppModuleAccents.launchpad : AppColors.text3;
    return VitCard(
      onTap: onTap,
      variant: active ? VitCardVariant.inner : VitCardVariant.standard,
      radius: VitCardRadius.standard,
      borderColor: active ? AppColors.primary30 : AppColors.cardBorder,
      padding: LaunchpadSpacingTokens.launchpadMetricCardPadding,
      child: Column(
        children: [
          Icon(
            _formatIcon(format.iconKey),
            color: color,
            size: LaunchpadSpacingTokens.launchpadIcon3xl,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            format.label,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: active
                  ? AppTextStyles.extraBold
                  : AppTextStyles.medium,
            ),
          ),
        ],
      ),
    );
  }
}
