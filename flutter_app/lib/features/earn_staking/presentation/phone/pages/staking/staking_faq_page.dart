import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
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

class StakingFAQPage extends ConsumerStatefulWidget {
  const StakingFAQPage({super.key, this.shellRenderMode});

  static const searchFieldKey = Key('sc370_search_field');
  static const tabsKey = Key('sc370_tabs');
  static const faqListKey = Key('sc370_faq_list');
  static const firstFaqKey = Key('sc370_first_faq');
  static const emptyKey = Key('sc370_empty');
  static const supportKey = Key('sc370_support');

  static Key categoryKey(String id) => Key('sc370_category_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingFAQPage> createState() => _StakingFAQPageState();
}

class _StakingFAQPageState extends ConsumerState<StakingFAQPage> {
  StakingFAQCategory _category = StakingFAQCategory.general;
  String _query = '';
  final Set<String> _expandedIds = <String>{};

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(stakingFAQSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Giải đáp yield và rủi ro staking',
      semanticIdentifier: 'SC-370',
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
              onAction: () => ref.invalidate(stakingFAQSnapshotProvider),
            ),
          ),
          data: (snapshot) {
            final mode = widget.shellRenderMode ?? defaultShellRenderMode();
            final bottomInset =
                (mode.usesVisualQaFrame
                    ? DeviceMetrics.bottomChrome + AppSpacing.x7
                    : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
                MediaQuery.paddingOf(context).bottom;
            final filtered = _filteredItems(snapshot.items, _category, _query);

            return VitAutoHideHeaderScaffold(
              header: VitTopChrome(
                type: VitTopChromeType.detail,
                title: snapshot.title,
                subtitle: 'Giải đáp yield và rủi ro staking',
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
                          _SearchField(
                            placeholder: snapshot.searchPlaceholder,
                            onChanged: (value) =>
                                setState(() => _query = value),
                          ),
                          _CategoryTabs(
                            active: _category,
                            onChanged: (category) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _category = category);
                            },
                          ),
                          if (_query.trim().isNotEmpty)
                            Text(
                              'Tìm thấy ${filtered.length} kết quả',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                              ),
                            ),
                          if (filtered.isEmpty)
                            _EmptyResults(
                              onReset: () => setState(() => _query = ''),
                            )
                          else
                            _FAQList(
                              items: filtered,
                              expandedIds: _expandedIds,
                              onToggle: (id) {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() {
                                  if (!_expandedIds.add(id)) {
                                    _expandedIds.remove(id);
                                  }
                                });
                              },
                            ),
                          _SupportPanel(snapshot: snapshot),
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

class _SearchField extends StatelessWidget {
  const _SearchField({required this.placeholder, required this.onChanged});

  final String placeholder;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitSearchBar(
      fieldKey: StakingFAQPage.searchFieldKey,
      placeholder: placeholder,
      variant: VitSearchBarVariant.compact,
      onChanged: onChanged,
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs({required this.active, required this.onChanged});

  final StakingFAQCategory active;
  final ValueChanged<StakingFAQCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      key: StakingFAQPage.tabsKey,
      color: AppColors.surface,
      child: Padding(
        padding: EarnSpacingTokens.earnHorizontalPaddingX3.copyWith(
          top: AppSpacing.x4,
        ),
        child: VitTabBar(
          variant: VitTabBarVariant.underline,
          activeKey: active.name,
          onChanged: (key) => onChanged(
            StakingFAQCategory.values.firstWhere(
              (category) => category.name == key,
            ),
          ),
          tabs: [
            for (final category in StakingFAQCategory.values)
              VitTabItem(key: category.name, label: _categoryLabel(category)),
          ],
        ),
      ),
    );
  }
}

class _FAQList extends StatelessWidget {
  const _FAQList({
    required this.items,
    required this.expandedIds,
    required this.onToggle,
  });

  final List<StakingFAQItemDraft> items;
  final Set<String> expandedIds;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingFAQPage.faqListKey,
      children: [
        for (final item in items) ...[
          _FAQCard(
            key: item == items.first ? StakingFAQPage.firstFaqKey : null,
            item: item,
            expanded: expandedIds.contains(item.id),
            onTap: () => onToggle(item.id),
          ),
          if (item != items.last)
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ],
      ],
    );
  }
}

class _FAQCard extends StatelessWidget {
  const _FAQCard({
    super.key,
    required this.item,
    required this.expanded,
    required this.onTap,
  });

  final StakingFAQItemDraft item;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _categoryColor(item.category);
    return VitCard(
      radius: VitCardRadius.large,
      padding: AppSpacing.zeroInsets,
      clip: true,
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: EarnSpacingTokens.earnCardPaddingX4,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.help_outline_rounded,
                  color: color,
                  size: AppSpacing.iconMd,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    item.question,
                    style: AppTextStyles.baseMedium.copyWith(
                      height: EarnSpacingTokens
                          .stakingCommunityFaqQuestionLineHeight,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 180),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.text3,
                    size: AppSpacing.iconMd,
                  ),
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: EarnSpacingTokens.earnContentHorizontalPadding.copyWith(
                left: AppSpacing.x7,
                top: AppSpacing.zero,
                bottom: AppSpacing.x4,
              ),
              child: Text(
                item.answer,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: EarnSpacingTokens.stakingCommunityFaqAnswerLineHeight,
                ),
              ),
            ),
            crossFadeState: expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 180),
          ),
        ],
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return VitEmptyState(
      key: StakingFAQPage.emptyKey,
      icon: Icons.help_outline_rounded,
      title: 'Không tìm thấy câu hỏi phù hợp',
      actionLabel: 'Xóa tìm kiếm',
      onAction: onReset,
    );
  }
}

class _SupportPanel extends StatelessWidget {
  const _SupportPanel({required this.snapshot});

  final StakingFAQSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingFAQPage.supportKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(snapshot.supportTitle, style: AppTextStyles.baseMedium),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            snapshot.supportBody,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: VitCtaButton(
                  onPressed: () {
                    unawaited(HapticFeedback.selectionClick());
                    context.go(snapshot.supportRoute);
                  },
                  child: const Text('Live Chat'),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: VitCtaButton(
                  variant: VitCtaButtonVariant.secondary,
                  onPressed: () {
                    unawaited(HapticFeedback.selectionClick());
                    context.go(snapshot.supportRoute);
                  },
                  child: const Text('Email Support'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

List<StakingFAQItemDraft> _filteredItems(
  List<StakingFAQItemDraft> items,
  StakingFAQCategory category,
  String query,
) {
  final normalized = query.trim().toLowerCase();
  return [
    for (final item in items)
      if (item.category == category &&
          (normalized.isEmpty ||
              item.question.toLowerCase().contains(normalized) ||
              item.answer.toLowerCase().contains(normalized)))
        item,
  ];
}

String _categoryLabel(StakingFAQCategory category) {
  return switch (category) {
    StakingFAQCategory.general => 'Cơ bản',
    StakingFAQCategory.technical => 'Kỹ thuật',
    StakingFAQCategory.fees => 'Phí',
    StakingFAQCategory.risks => 'Rủi ro',
    StakingFAQCategory.advanced => 'Nâng cao',
  };
}

Color _categoryColor(StakingFAQCategory category) {
  return switch (category) {
    StakingFAQCategory.general => AppModuleAccents.earn,
    StakingFAQCategory.technical => AppModuleAccents.earn,
    StakingFAQCategory.fees => AppColors.warn,
    StakingFAQCategory.risks => AppColors.sell,
    StakingFAQCategory.advanced => AppColors.buy,
  };
}
