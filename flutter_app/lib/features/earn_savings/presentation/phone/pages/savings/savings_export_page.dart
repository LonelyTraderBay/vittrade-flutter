import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_savings_controller_providers.dart';
import 'package:vit_trade_flutter/features/earn_core/presentation/widgets/earn_custody_risk_banner.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

part '../../../widgets/savings/savings_export_config_widgets.dart';
part '../../../widgets/savings/savings_export_option_widgets.dart';
part '../../../widgets/savings/savings_export_summary_widgets.dart';

TextStyle get _captionBold =>
    AppTextStyles.caption.copyWith(fontWeight: AppTextStyles.bold);
TextStyle get _microBold =>
    AppTextStyles.micro.copyWith(fontWeight: AppTextStyles.bold);

class SavingsExportPage extends ConsumerStatefulWidget {
  const SavingsExportPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc348_summary');
  static const reportTypesKey = Key('sc348_report_types');
  static const formatsKey = Key('sc348_formats');
  static const periodsKey = Key('sc348_periods');
  static const scopesKey = Key('sc348_scopes');
  static const optionsKey = Key('sc348_options');
  static const summaryRowsKey = Key('sc348_summary_rows');
  static const exportButtonKey = Key('sc348_export_button');
  static const previewBannerKey = Key('sc348_preview_banner');
  static const historyListKey = Key('sc348_history_list');

  static Key tabKey(String id) => Key('sc348_tab_$id');
  static Key reportTypeKey(SavingsExportReportType id) =>
      Key('sc348_report_${id.name}');
  static Key formatKey(SavingsExportFormat id) =>
      Key('sc348_format_${id.name}');
  static Key periodKey(SavingsExportPeriod id) =>
      Key('sc348_period_${id.name}');
  static Key scopeKey(SavingsExportScope id) => Key('sc348_scope_${id.name}');
  static Key optionKey(String id) => Key('sc348_option_$id');
  static Key historyKey(String id) => Key('sc348_history_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsExportPage> createState() => _SavingsExportPageState();
}

class _SavingsExportPageState extends ConsumerState<SavingsExportPage> {
  String? _tab;
  SavingsExportReportType? _reportType;
  SavingsExportFormat? _format;
  SavingsExportPeriod? _period;
  SavingsExportScope? _scope;
  Set<String>? _enabledOptions;
  bool _previewReady = false;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(savingsExportSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Xuất báo cáo',
      semanticIdentifier: 'SC-348',
      child: Material(
        color: AppColors.bg,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnSavings),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnSavings),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(savingsExportSnapshotProvider),
            ),
          ),
          data: (snapshot) {
            final activeTab = _tab ?? snapshot.defaultTab;
            final selectedReport = _reportType ?? snapshot.defaultReportType;
            final selectedFormat = _format ?? snapshot.defaultFormat;
            final selectedPeriod = _period ?? snapshot.defaultPeriod;
            final selectedScope = _scope ?? snapshot.defaultScope;
            final enabledOptions =
                _enabledOptions ?? snapshot.defaultEnabledOptions;
            final mode = widget.shellRenderMode ?? defaultShellRenderMode();
            final bottomInset =
                (mode.usesVisualQaFrame
                    ? DeviceMetrics.bottomChrome + AppSpacing.x7
                    : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
                MediaQuery.paddingOf(context).bottom;

            return VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: snapshot.title,
                subtitle: kSavingsToolsHeaderSubtitle,
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ColoredBox(
                    color: AppColors.surface,
                    child: Padding(
                      padding: EarnSpacingTokens.earnSurfaceTabsPadding,
                      child: _ExportTabs(
                        tabs: snapshot.tabs,
                        active: activeTab,
                        onChanged: (tab) {
                          unawaited(HapticFeedback.selectionClick());
                          setState(() => _tab = tab);
                        },
                      ),
                    ),
                  ),
                  const Divider(
                    height: AppSpacing.dividerHairline,
                    thickness: AppSpacing.dividerHairline,
                    color: AppColors.divider,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: EarnSpacingTokens.earnBottomInsetPadding(
                        bottomInset,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.compact,
                        gap: VitContentGap.defaultGap,
                        children: [
                          _ExportHero(snapshot: snapshot),
                          if (activeTab == 'create') ...[
                            const VitSectionHeader(
                              title: 'Loại báo cáo',
                              variant: VitSectionHeaderVariant.accentBar,
                              accentColor: AppModuleAccents.earn,
                              bottomGap: AppSpacing.pageRhythmStandardInnerGap,
                            ),
                            _ReportTypeList(
                              reports: snapshot.reportTypes,
                              selected: selectedReport,
                              onChanged: (report) {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() {
                                  _reportType = report;
                                  _previewReady = false;
                                });
                              },
                            ),
                            const VitSectionHeader(
                              title: 'Định dạng file',
                              variant: VitSectionHeaderVariant.accentBar,
                              accentColor: AppModuleAccents.earn,
                              bottomGap: AppSpacing.pageRhythmStandardInnerGap,
                            ),
                            _FormatCards(
                              formats: snapshot.formats,
                              selected: selectedFormat,
                              onChanged: (format) {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() {
                                  _format = format;
                                  _previewReady = false;
                                });
                              },
                            ),
                            const VitSectionHeader(
                              title: 'Khoảng thời gian',
                              variant: VitSectionHeaderVariant.accentBar,
                              accentColor: AppModuleAccents.earn,
                              bottomGap: AppSpacing.pageRhythmStandardInnerGap,
                            ),
                            _PeriodChips(
                              periods: snapshot.periods,
                              selected: selectedPeriod,
                              onChanged: (period) {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() {
                                  _period = period;
                                  _previewReady = false;
                                });
                              },
                            ),
                            const VitSectionHeader(
                              title: 'Loại giao dịch',
                              variant: VitSectionHeaderVariant.accentBar,
                              accentColor: AppModuleAccents.earn,
                              bottomGap: AppSpacing.pageRhythmStandardInnerGap,
                            ),
                            _ScopeChips(
                              scopes: snapshot.scopes,
                              selected: selectedScope,
                              onChanged: (scope) {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() {
                                  _scope = scope;
                                  _previewReady = false;
                                });
                              },
                            ),
                            const VitSectionHeader(
                              title: 'Tùy chọn thêm',
                              variant: VitSectionHeaderVariant.accentBar,
                              accentColor: AppModuleAccents.earn,
                              bottomGap: AppSpacing.pageRhythmStandardInnerGap,
                            ),
                            _OptionsList(
                              options: snapshot.options,
                              enabled: enabledOptions,
                              onToggle: _toggleOption,
                            ),
                            _ExportSummary(
                              snapshot: snapshot,
                              selectedReport: selectedReport,
                              selectedFormat: selectedFormat,
                            ),
                            EarnWarningBanner(
                              text: snapshot.sensitiveNotice,
                              lineHeight:
                                  EarnSpacingTokens.earnExportWarningLineHeight,
                            ),
                            VitHighRiskStatePanel(
                              state: _previewReady
                                  ? VitHighRiskUiState.success
                                  : VitHighRiskUiState.riskReview,
                              title: _previewReady
                                  ? 'Đã sẵn sàng xem trước'
                                  : 'Cần xem xét trước khi xuất',
                              message:
                                  'Dữ liệu tài khoản được che, phạm vi báo cáo, định dạng file, phí và khoảng thời gian giao dịch được xem xét trước khi xuất.',
                              contractId:
                                  'savings-export-${selectedReport.name}-${selectedFormat.name}',
                            ),
                            if (_previewReady)
                              _PreviewReadyBanner(format: selectedFormat),
                            VitCtaButton(
                              key: SavingsExportPage.exportButtonKey,
                              onPressed: () => _previewExport(selectedFormat),
                              leading: const Icon(Icons.file_download_outlined),
                              child: Text(
                                'Xem trước & Xuất ${_formatLabel(selectedFormat)}',
                              ),
                            ),
                          ] else
                            _HistoryList(history: snapshot.history),
                          const SavingsToolsYieldFooter(),
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

  void _toggleOption(String id) {
    unawaited(HapticFeedback.selectionClick());
    // Bẫy 15 (GD4 playbook): repo trong event handler — đọc lười qua
    // `.value` thay vì gọi lại repo.
    final snapshot = ref.read(savingsExportSnapshotProvider).value;
    if (snapshot == null) return;
    final next = <String>{
      ...(_enabledOptions ?? snapshot.defaultEnabledOptions),
    };
    if (!next.add(id)) {
      next.remove(id);
    }
    setState(() {
      _enabledOptions = next;
      _previewReady = false;
    });
  }

  void _previewExport(SavingsExportFormat format) {
    unawaited(HapticFeedback.mediumImpact());
    setState(() => _previewReady = true);
  }
}
