import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
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

class StakingForumPage extends ConsumerWidget {
  const StakingForumPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc392_forum_hero');
  static const categoriesKey = Key('sc392_forum_categories');
  static const threadsKey = Key('sc392_forum_threads');
  static const createKey = Key('sc392_create_thread');

  static Key categoryKey(String name) => Key('sc392_category_$name');

  static Key threadKey(int index) => Key('sc392_thread_$index');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingForumSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Diễn đàn cộng đồng stake',
      semanticIdentifier: 'SC-392',
      child: Material(
        color: AppColors.bg,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnCommunityGovernance),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnCommunityGovernance),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(stakingForumSnapshotProvider),
            ),
          ),
          data: (snapshot) {
            final mode = shellRenderMode ?? defaultShellRenderMode();
            final bottomInset =
                (mode.usesVisualQaFrame
                    ? DeviceMetrics.bottomChrome + AppSpacing.x7
                    : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
                MediaQuery.paddingOf(context).bottom;

            return VitAutoHideHeaderScaffold(
              header: VitTopChrome(
                type: VitTopChromeType.detail,
                title: snapshot.title,
                subtitle: 'Diễn đàn cộng đồng stake',
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
                        gap: VitContentGap.defaultGap,
                        children: [
                          _ForumHero(snapshot: snapshot),
                          _CategoryGrid(
                            title: snapshot.categoriesTitle,
                            categories: snapshot.categories,
                          ),
                          _TrendingThreads(
                            title: snapshot.threadsTitle,
                            threads: snapshot.threads,
                          ),
                          VitCtaButton(
                            key: StakingForumPage.createKey,
                            onPressed: () => _showComingSoon(
                              context,
                              'Tạo chủ đề sẽ sớm ra mắt',
                            ),
                            child: Text(snapshot.createLabel),
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
}

class _ForumHero extends StatelessWidget {
  const _ForumHero({required this.snapshot});

  final StakingForumSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingForumPage.heroKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      borderColor: AppColors.accent30,
      padding: EarnSpacingTokens.earnCardPaddingX4,
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
              height: EarnSpacingTokens.stakingCommunityBodyLineHeight,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({required this.title, required this.categories});

  final String title;
  final List<StakingForumCategoryDraft> categories;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingForumPage.categoriesKey,
      label: title,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: EarnSpacingTokens.stakingCommunityGridColumns,
            crossAxisSpacing: AppSpacing.x3,
            mainAxisSpacing: AppSpacing.x3,
            childAspectRatio: EarnSpacingTokens.stakingCommunityForumGridAspect,
          ),
          itemBuilder: (context, index) =>
              _CategoryCard(category: categories[index]),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category});

  final StakingForumCategoryDraft category;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingForumPage.categoryKey(category.name),
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      onTap: () => _showComingSoon(context, 'Xem danh mục sẽ sớm ra mắt'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            category.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            '${category.threads} threads - ${category.posts} posts',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _TrendingThreads extends StatelessWidget {
  const _TrendingThreads({required this.title, required this.threads});

  final String title;
  final List<StakingForumThreadDraft> threads;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingForumPage.threadsKey,
      label: title,
      children: [
        for (var index = 0; index < threads.length; index++)
          _ThreadCard(thread: threads[index], index: index),
      ],
    );
  }
}

class _ThreadCard extends StatelessWidget {
  const _ThreadCard({required this.thread, required this.index});

  final StakingForumThreadDraft thread;
  final int index;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingForumPage.threadKey(index),
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3X4,
      onTap: () => _showComingSoon(context, 'Xem chủ đề sẽ sớm ra mắt'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (thread.pinned) ...[
                const Icon(
                  Icons.push_pin_outlined,
                  color: AppColors.warn,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
              ],
              Expanded(
                child: Text(
                  thread.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Wrap(
            spacing: AppSpacing.x3,
            runSpacing: AppSpacing.x1,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                thread.author,
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
              _ThreadMetric(
                icon: Icons.mode_comment_outlined,
                value: thread.replies.toString(),
              ),
              _ThreadMetric(
                icon: Icons.trending_up_rounded,
                value: thread.views.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void _showComingSoon(BuildContext context, String message) {
  unawaited(HapticFeedback.selectionClick());
  unawaited(
    showVitNoticeSheet(
      context: context,
      title: 'Sẽ sớm ra mắt',
      message: message,
    ),
  );
}

class _ThreadMetric extends StatelessWidget {
  const _ThreadMetric({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: AppSpacing.iconSm, color: AppColors.text3),
        const SizedBox(width: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}
