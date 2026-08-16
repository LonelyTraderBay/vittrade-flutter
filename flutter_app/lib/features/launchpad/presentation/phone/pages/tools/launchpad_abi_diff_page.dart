import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/core/utils/data_masking.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';

part '../../../widgets/tools/launchpad_abi_diff_summary.dart';
part '../../../widgets/tools/launchpad_abi_diff_entries.dart';
part '../../../widgets/tools/launchpad_abi_diff_extensions.dart';

class LaunchpadAbiDiffPage extends ConsumerStatefulWidget {
  const LaunchpadAbiDiffPage({
    super.key,
    this.contractId = 'contract001',
    this.shellRenderMode,
  });

  static const contentKey = Key('sc308_launchpad_abi_diff_content');
  static const heroKey = Key('sc308_launchpad_abi_diff_hero');
  static const statsKey = Key('sc308_launchpad_abi_diff_stats');
  static const metadataKey = Key('sc308_launchpad_abi_diff_metadata');
  static const functionsOnlyKey = Key(
    'sc308_launchpad_abi_diff_functions_only',
  );
  static const entriesKey = Key('sc308_launchpad_abi_diff_entries');
  static const warningKey = Key('sc308_launchpad_abi_diff_warning');

  static Key statKey(String value) =>
      Key('sc308_launchpad_abi_diff_stat_$value');
  static Key entryKey(String name) =>
      Key('sc308_launchpad_abi_diff_entry_$name');
  static Key expandKey(String name) =>
      Key('sc308_launchpad_abi_diff_expand_$name');
  static Key copyKey(String label) =>
      Key('sc308_launchpad_abi_diff_copy_$label');

  final String contractId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadAbiDiffPage> createState() =>
      _LaunchpadAbiDiffPageState();
}

class _LaunchpadAbiDiffPageState extends ConsumerState<LaunchpadAbiDiffPage> {
  LaunchpadAbiChangeType? _filter;
  var _functionsOnly = false;
  String? _expandedEntry;
  String? _copiedField;

  @override
  Widget build(BuildContext context) {
    final abiDiffAsync = ref.watch(
      launchpadAbiDiffSnapshotProvider(widget.contractId),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollTailReserve =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome
            : DeviceMetrics.nativeBottomChrome) +
        MediaQuery.paddingOf(context).bottom +
        AppSpacing.x3;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'So sánh thay đổi ABI hợp đồng thông minh',
      semanticIdentifier: 'SC-308',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          bottomInset: scrollTailReserve,
          semanticLabel: 'So sánh thay đổi ABI hợp đồng thông minh',
          semanticIdentifier: 'SC-308',
          header: VitHeader(
            title: 'ABI Diff',
            subtitle: 'So sánh ABI contract · Xem trước thay đổi',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.launchpad),
          ),
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              key: LaunchpadAbiDiffPage.contentKey,
              physics: const ClampingScrollPhysics(),
              child: VitPageContent(
                rhythm: VitPageRhythm.standard,
                padding: VitContentPadding.compact,
                gap: VitContentGap.tight,
                children: [
                  ...abiDiffAsync.when(
                    loading: () => const [VitSkeletonList()],
                    error: (error, stackTrace) => [
                      VitErrorState(
                        title: 'Không tải được ABI diff',
                        message: 'Vui lòng kiểm tra kết nối và thử lại.',
                        actionLabel: 'Thử lại',
                        onAction: () => ref.invalidate(
                          launchpadAbiDiffSnapshotProvider(widget.contractId),
                        ),
                      ),
                    ],
                    data: (snapshot) {
                      final diff = snapshot.diff;
                      final entries = _filteredEntries(diff.entries);
                      return [
                        _RiskHero(diff: diff),
                        _SummaryStats(
                          diff: diff,
                          activeFilter: _filter,
                          onChanged: (filter) => setState(() {
                            _filter = _filter == filter ? null : filter;
                          }),
                        ),
                        _UpgradeMetadata(
                          diff: diff,
                          copiedField: _copiedField,
                          onCopy: _copyField,
                        ),
                        _FilterRow(
                          active: _functionsOnly,
                          count: entries.length,
                          onChanged: () =>
                              setState(() => _functionsOnly = !_functionsOnly),
                        ),
                        VitPageSection(
                          label: 'ABI Changes',
                          accentColor: AppColors.accent,
                          children: [
                            Column(
                              key: LaunchpadAbiDiffPage.entriesKey,
                              children: [
                                for (final entry in entries)
                                  _AbiEntryCard(
                                    entry: entry,
                                    expanded: _expandedEntry == entry.name,
                                    onToggle: () => setState(() {
                                      _expandedEntry =
                                          _expandedEntry == entry.name
                                          ? null
                                          : entry.name;
                                    }),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        const _RiskWarning(),
                      ];
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<LaunchpadAbiDiffEntryDraft> _filteredEntries(
    List<LaunchpadAbiDiffEntryDraft> entries,
  ) {
    return entries.where((entry) {
      if (_filter != null && entry.changeType != _filter) {
        return false;
      }
      if (_functionsOnly && entry.type != 'function') {
        return false;
      }
      return true;
    }).toList();
  }

  Future<void> _copyField(String label, String value) async {
    setState(() => _copiedField = label);
    try {
      await Clipboard.setData(ClipboardData(text: value));
    } catch (_) {
      // Test and embedded shells can omit platform clipboard support.
    }
  }
}
