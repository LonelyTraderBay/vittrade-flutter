import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_staking_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class StakingDataExportPage extends ConsumerStatefulWidget {
  const StakingDataExportPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc394_export_hero');
  static const quickKey = Key('sc394_quick_exports');
  static const customKey = Key('sc394_custom_export');
  static const startDateKey = Key('sc394_start_date');
  static const endDateKey = Key('sc394_end_date');
  static const formatKey = Key('sc394_format_select');
  static const exportKey = Key('sc394_export_custom');
  static const footerKey = Key('sc394_export_footer');

  static Key quickExportKey(String id) => Key('sc394_quick_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingDataExportPage> createState() =>
      _StakingDataExportPageState();
}

class _StakingDataExportPageState extends ConsumerState<StakingDataExportPage> {
  String? _selectedQuickExport;
  // Bẫy 14 (GD4 playbook): seed từ getter giờ-đã-async — không còn seed ở
  // initState, seed 1 lần trong nhánh data: bên dưới.
  String? _format;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(stakingDataExportSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Xuất dữ liệu stake và yield',
      semanticIdentifier: 'SC-394',
      child: Material(
        color: AppColors.bg,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earn),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earn),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(stakingDataExportSnapshotProvider),
            ),
          ),
          data: (snapshot) {
            _format ??= snapshot.defaultFormat;
            final mode = widget.shellRenderMode ?? defaultShellRenderMode();
            final bottomInset =
                (mode.usesVisualQaFrame
                    ? DeviceMetrics.bottomChrome + AppSpacing.x7
                    : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
                MediaQuery.paddingOf(context).bottom;

            return VitAutoHideHeaderScaffold(
              header: VitTopChrome(
                type: VitTopChromeType.detail,
                title: snapshot.title,
                subtitle: 'Xuất dữ liệu stake và yield',
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: EarnSpacingTokens.earnBottomInsetPadding(
                        bottomInset,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.defaultPadding,
                        gap: VitContentGap.tight,
                        children: [
                          _ExportHero(snapshot: snapshot),
                          _QuickExports(
                            snapshot: snapshot,
                            selectedId: _selectedQuickExport,
                            onSelect: (id) {
                              setState(() => _selectedQuickExport = id);
                            },
                          ),
                          _CustomExport(
                            snapshot: snapshot,
                            format: _format!,
                            onFormatChanged: (value) {
                              setState(() => _format = value);
                            },
                          ),
                          _FooterNote(note: snapshot.footerNote),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ExportHero extends StatelessWidget {
  const _ExportHero({required this.snapshot});

  final StakingDataExportSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingDataExportPage.heroKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      borderColor: AppColors.primary20,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            snapshot.heroTitle,
            style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            snapshot.heroBody,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: EarnSpacingTokens.stakingEarnHeroTabLabelLineHeight,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickExports extends StatelessWidget {
  const _QuickExports({
    required this.snapshot,
    required this.selectedId,
    required this.onSelect,
  });

  final StakingDataExportSnapshot snapshot;
  final String? selectedId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingDataExportPage.quickKey,
      label: snapshot.quickTitle,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.quickExports.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: EarnSpacingTokens.stakingDataExportGridColumns,
            crossAxisSpacing: AppSpacing.x3,
            mainAxisSpacing: AppSpacing.x3,
            childAspectRatio: EarnSpacingTokens.stakingDataExportGridAspect,
          ),
          itemBuilder: (context, index) {
            final item = snapshot.quickExports[index];
            return _QuickExportCard(
              item: item,
              selected: item.id == selectedId,
              onTap: () => onSelect(item.id),
            );
          },
        ),
      ],
    );
  }
}

class _QuickExportCard extends StatelessWidget {
  const _QuickExportCard({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final StakingQuickExportDraft item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingDataExportPage.quickExportKey(item.id),
      radius: VitCardRadius.large,
      borderColor: selected ? AppColors.primary : null,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _iconFor(item.iconKey),
            color: AppColors.text3,
            size: EarnSpacingTokens.stakingDataExportQuickIcon,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            item.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            item.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _CustomExport extends StatelessWidget {
  const _CustomExport({
    required this.snapshot,
    required this.format,
    required this.onFormatChanged,
  });

  final StakingDataExportSnapshot snapshot;
  final String format;
  final ValueChanged<String> onFormatChanged;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingDataExportPage.customKey,
      label: snapshot.customTitle,
      children: [
        VitCard(
          radius: VitCardRadius.large,
          padding: EarnSpacingTokens.earnCardPaddingX3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                snapshot.dateRangeLabel,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Row(
                children: [
                  Expanded(
                    child: _DateField(
                      key: StakingDataExportPage.startDateKey,
                      label: snapshot.startPlaceholder,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: _DateField(
                      key: StakingDataExportPage.endDateKey,
                      label: snapshot.endPlaceholder,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              Text(
                snapshot.formatLabel,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              _FormatSelect(
                format: format,
                options: snapshot.formatOptions,
                onChanged: onFormatChanged,
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              VitCtaButton(
                key: StakingDataExportPage.exportKey,
                onPressed: () {
                  unawaited(HapticFeedback.selectionClick());
                  unawaited(
                    showVitNoticeSheet(
                      context: context,
                      title: 'Sẽ sớm ra mắt',
                      message: 'Xuất dữ liệu sẽ sớm ra mắt',
                    ),
                  );
                },
                height: AppSpacing.buttonStandard,
                child: Text(snapshot.exportLabel),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.buttonStandard,
      child: DecoratedBox(
        decoration: const ShapeDecoration(
          color: AppColors.surface2,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.borderSolid),
            borderRadius: AppRadii.inputRadius,
          ),
        ),
        child: Padding(
          padding: EarnSpacingTokens.earnHorizontalPaddingX3,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              const Icon(
                Icons.calendar_today_outlined,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormatSelect extends StatelessWidget {
  const _FormatSelect({
    required this.format,
    required this.options,
    required this.onChanged,
  });

  final String format;
  final List<String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      key: StakingDataExportPage.formatKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      borderColor: AppColors.borderSolid,
      height: AppSpacing.buttonStandard,
      padding: EarnSpacingTokens.earnHorizontalPaddingX3,
      onTap: () {
        final index = options.indexOf(format);
        final next = options[(index + 1) % options.length];
        onChanged(next);
      },
      child: Row(
        children: [
          Expanded(
            child: Text(
              format,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body.copyWith(color: AppColors.text1),
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.text2,
            size: AppSpacing.iconMd,
          ),
        ],
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingDataExportPage.footerKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: VitRiskDisclaimerNote(
        message: note,
        height: EarnSpacingTokens.stakingEarnHeroTabLabelLineHeight,
      ),
    );
  }
}

IconData _iconFor(String key) {
  return switch (key) {
    'calendar' => Icons.calendar_month_outlined,
    _ => Icons.description_outlined,
  };
}
