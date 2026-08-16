import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/earn_savings_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_smart_suggestions_common.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_smart_suggestions_summary.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_smart_suggestions_suggestions.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_smart_suggestions_trends.dart';
import 'package:vit_trade_flutter/features/earn_core/presentation/widgets/earn_custody_risk_banner.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_error_state.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_skeleton.dart';

class SavingsSmartSuggestionsPage extends ConsumerStatefulWidget {
  const SavingsSmartSuggestionsPage({super.key, this.shellRenderMode});

  static const summaryKey = SavingsSmartSuggestionsKeys.summary;
  static const suggestionsListKey = SavingsSmartSuggestionsKeys.suggestionsList;
  static const trendsListKey = SavingsSmartSuggestionsKeys.trendsList;
  static const signalsListKey = SavingsSmartSuggestionsKeys.signalsList;

  static Key filterKey(String id) => SavingsSmartSuggestionsKeys.filter(id);
  static Key suggestionKey(String id) =>
      SavingsSmartSuggestionsKeys.suggestion(id);
  static Key actionKey(String id) => SavingsSmartSuggestionsKeys.action(id);
  static Key helpfulKey(String id) => SavingsSmartSuggestionsKeys.helpful(id);
  static Key dismissKey(String id) => SavingsSmartSuggestionsKeys.dismiss(id);

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsSmartSuggestionsPage> createState() =>
      _SavingsSmartSuggestionsPageState();
}

class _SavingsSmartSuggestionsPageState
    extends ConsumerState<SavingsSmartSuggestionsPage> {
  String? _tab;
  String _filter = 'all';
  final Set<String> _dismissed = {};
  final Set<String> _helpful = {};

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(savingsSmartSuggestionsSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Gợi ý thông minh',
      semanticIdentifier: 'SC-347',
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
              onAction: () =>
                  ref.invalidate(savingsSmartSuggestionsSnapshotProvider),
            ),
          ),
          data: (snapshot) {
            final activeTab = _tab ?? snapshot.defaultTab;
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
                      child: SavingsSmartTabs(
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
                          VitCard(
                            variant: VitCardVariant.standard,
                            radius: VitCardRadius.standard,
                            padding: AppSpacing.zeroInsets,
                            child: SavingsSmartSummary(snapshot: snapshot),
                          ),
                          if (activeTab == 'suggestions') ...[
                            SavingsSmartPriorityFilters(
                              filters: snapshot.filters,
                              active: _filter,
                              onChanged: (filter) {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() => _filter = filter);
                              },
                            ),
                            SavingsSmartSuggestionList(
                              suggestions: _filteredSuggestions(snapshot),
                              helpful: _helpful,
                              onHelpful: _markHelpful,
                              onDismiss: _dismissSuggestion,
                            ),
                          ] else if (activeTab == 'trends')
                            SavingsSmartTrendList(trends: snapshot.trends)
                          else
                            SavingsSmartSignalList(signals: snapshot.signals),
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

  List<SavingsSuggestionDraft> _filteredSuggestions(
    SavingsSmartSuggestionsSnapshot snapshot,
  ) {
    final active = snapshot.suggestions.where(
      (suggestion) => !_dismissed.contains(suggestion.id),
    );
    if (_filter == 'all') return active.toList();

    return active
        .where((suggestion) => suggestion.priority.name == _filter)
        .toList();
  }

  void _markHelpful(String id) {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      if (_helpful.contains(id)) {
        _helpful.remove(id);
      } else {
        _helpful.add(id);
      }
    });
  }

  void _dismissSuggestion(String id) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _dismissed.add(id));
  }
}
