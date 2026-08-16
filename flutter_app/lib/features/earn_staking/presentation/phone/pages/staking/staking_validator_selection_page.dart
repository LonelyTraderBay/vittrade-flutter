import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/earn_staking_controller_providers.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/widgets/staking/staking_validator_selection_common.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/widgets/staking/staking_validator_selection_detail.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/widgets/staking/staking_validator_selection_filters.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/widgets/staking/staking_validator_selection_list.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/widgets/staking/staking_validator_selection_summary.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class StakingValidatorSelectionPage extends ConsumerStatefulWidget {
  const StakingValidatorSelectionPage({super.key, this.shellRenderMode});

  static const infoKey = StakingValidatorSelectionKeys.info;
  static const summaryKey = StakingValidatorSelectionKeys.summary;
  static const searchKey = StakingValidatorSelectionKeys.search;
  static const filterButtonKey = StakingValidatorSelectionKeys.filterButton;
  static const filterPanelKey = StakingValidatorSelectionKeys.filterPanel;
  static const resultCountKey = StakingValidatorSelectionKeys.resultCount;
  static const detailKey = StakingValidatorSelectionKeys.detail;
  static const footerKey = StakingValidatorSelectionKeys.footer;

  static Key validatorKey(String id) =>
      StakingValidatorSelectionKeys.validator(id);

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingValidatorSelectionPage> createState() =>
      _StakingValidatorSelectionPageState();
}

class _StakingValidatorSelectionPageState
    extends ConsumerState<StakingValidatorSelectionPage> {
  final _searchController = TextEditingController();
  StakingValidatorSort _sort = StakingValidatorSort.apy;
  StakingValidatorTier? _tierFilter;
  String _query = '';
  bool _showFilters = false;
  StakingValidatorDraft? _selected;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(stakingValidatorSelectionSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Chọn validator cho staking',
      semanticIdentifier: 'SC-362',
      child: Material(
        color: AppColors.bg,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnStaking),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnStaking),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () =>
                  ref.invalidate(stakingValidatorSelectionSnapshotProvider),
            ),
          ),
          data: (snapshot) {
            final validators = _filtered(snapshot.validators);
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
                subtitle: snapshot.infoTitle,
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
                        padding: VitContentPadding.compact,
                        gap: VitContentGap.defaultGap,
                        children: [
                          StakingValidatorSelectionInfoBanner(
                            snapshot: snapshot,
                          ),
                          StakingValidatorSelectionStatsSummary(
                            snapshot: snapshot,
                          ),
                          StakingValidatorSelectionSearchAndFilter(
                            controller: _searchController,
                            filterActive:
                                _showFilters ||
                                _tierFilter != null ||
                                _sort != StakingValidatorSort.apy,
                            onQueryChanged: (query) => setState(() {
                              _query = query;
                              _selected = null;
                            }),
                            onFilter: () {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _showFilters = !_showFilters);
                            },
                          ),
                          if (_showFilters)
                            StakingValidatorSelectionFilterPanel(
                              key: StakingValidatorSelectionPage.filterPanelKey,
                              sort: _sort,
                              tier: _tierFilter,
                              onSortChanged: (sort) {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() => _sort = sort);
                              },
                              onTierChanged: (tier) {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() => _tierFilter = tier);
                              },
                              onClear: _clearFilters,
                            ),
                          StakingValidatorSelectionResultsHeader(
                            count: validators.length,
                            total: snapshot.validators.length,
                            filtered:
                                validators.length !=
                                    snapshot.validators.length ||
                                _query.isNotEmpty,
                            sort: _sort,
                            onClear: _clearFilters,
                          ),
                          if (_selected != null)
                            StakingValidatorSelectionDetailCard(
                              key: StakingValidatorSelectionPage.detailKey,
                              validator: _selected!,
                              onClose: () => setState(() => _selected = null),
                              onSelect: () => _confirmSelection(_selected!),
                            ),
                          StakingValidatorSelectionValidatorList(
                            validators: validators,
                            onTap: (validator) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _selected = validator);
                            },
                          ),
                          StakingValidatorSelectionFooterNote(
                            snapshot: snapshot,
                          ),
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

  List<StakingValidatorDraft> _filtered(
    List<StakingValidatorDraft> validators,
  ) {
    final query = _query.trim().toLowerCase();
    final result = [
      for (final validator in validators)
        if ((_tierFilter == null || validator.tier == _tierFilter) &&
            (query.isEmpty ||
                validator.name.toLowerCase().contains(query) ||
                validator.address.toLowerCase().contains(query)))
          validator,
    ];

    result.sort((a, b) {
      return switch (_sort) {
        StakingValidatorSort.apy => b.apy.compareTo(a.apy),
        StakingValidatorSort.uptime => b.uptime.compareTo(a.uptime),
        StakingValidatorSort.commission => a.commission.compareTo(b.commission),
        StakingValidatorSort.staked => b.totalStaked.compareTo(a.totalStaked),
      };
    });
    return result;
  }

  void _confirmSelection(StakingValidatorDraft validator) {
    unawaited(HapticFeedback.mediumImpact());
    setState(() => _selected = null);
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Đã xác nhận',
        message: 'Đã chọn ${validator.name} làm validator',
      ),
    );
  }

  void _clearFilters() {
    unawaited(HapticFeedback.selectionClick());
    _searchController.clear();
    setState(() {
      _query = '';
      _sort = StakingValidatorSort.apy;
      _tierFilter = null;
      _selected = null;
    });
  }
}
