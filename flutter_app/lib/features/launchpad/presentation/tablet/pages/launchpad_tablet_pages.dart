import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part 'launchpad_tablet_pages_tools.dart';
part 'launchpad_tablet_pages_ops.dart';

Widget _lpdFrame({
  required BuildContext context,
  required String semanticIdentifier,
  required String semanticLabel,
  required String title,
  required String subtitle,
  required Widget child,
  Key? contentKey,
}) {
  final showBack = context.canPop();
  return VitPageLayout(
    variant: VitPageVariant.flush,
    semanticLabel: semanticLabel,
    semanticIdentifier: semanticIdentifier,
    child: Column(
      children: [
        VitHeader(
          title: title,
          subtitle: subtitle,
          showBack: showBack,
          onBack: showBack
              ? () => goBackOrFallback(
                  context,
                  fallbackPath: AppRoutePaths.launchpad,
                  mode: BackNavigationMode.historyThenFallback,
                )
              : null,
        ),
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1080),
              child: SingleChildScrollView(
                key: contentKey,
                padding: const EdgeInsets.fromLTRB(
                  TabletSpacingTokens.x6,
                  TabletSpacingTokens.x4,
                  TabletSpacingTokens.x6,
                  TabletSpacingTokens.x6,
                ),
                child: child,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _lpdError(String title, VoidCallback onRetry) {
  return VitErrorState(
    title: title,
    message: 'Vui lòng kiểm tra kết nối và thử lại.',
    actionLabel: 'Thử lại',
    onAction: onRetry,
  );
}

Widget _lpdSection({required String title, required List<Widget> rows}) {
  return VitCard(
    radius: VitCardRadius.tight,
    padding: TabletSpacingTokens.cardPaddingCompact,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.control.copyWith(
            fontWeight: AppTextStyles.bold,
            color: AppColors.text1,
          ),
        ),
        const SizedBox(height: TabletSpacingTokens.x2),
        ...rows,
      ],
    ),
  );
}

List<Widget> _lpdRows(List<(String, String)> pairs) {
  return [
    for (final (label, value) in pairs)
      Padding(
        padding: TabletSpacingTokens.tableCellPaddingV,
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
          ],
        ),
      ),
  ];
}

Widget _lpdBody(String text) {
  return Text(
    text,
    style: AppTextStyles.caption.copyWith(color: AppColors.text2, height: 1.3),
  );
}

/// SC-360: Hub Launchpad.
class LaunchpadHomeTabletPage extends ConsumerWidget {
  const LaunchpadHomeTabletPage({super.key});

  static const contentKey = Key('sc360_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(launchpadHomeSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _lpdFrame(
        context: context,
        semanticIdentifier: 'SC-360',
        semanticLabel: 'Sàn phát hành',
        title: snapshotAsync.value?.title ?? 'Launchpad',
        subtitle: 'Dự án · Đăng ký',
        contentKey: LaunchpadHomeTabletPage.contentKey,
        child: _lpdError(
          'Không tải được launchpad',
          () => ref.invalidate(launchpadHomeSnapshotProvider),
        ),
      ),
      data: (snapshot) => _lpdFrame(
        context: context,
        semanticIdentifier: 'SC-360',
        semanticLabel: 'Sàn phát hành',
        title: snapshot.title,
        subtitle: snapshot.subtitle,
        contentKey: LaunchpadHomeTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _lpdSection(
              title: 'Dự án',
              rows: [
                for (final project in snapshot.projects)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${project.name} (${project.symbol})',
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                  color: AppColors.text1,
                                ),
                              ),
                              Text(
                                project.description,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text2,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${project.totalRaise} · ${project.status.name}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _lpdSection(
              title: 'Công cụ nâng cao',
              rows: _lpdRows([
                for (final tool in snapshot.advancedTools)
                  (tool.label, tool.route),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-361: Danh mục launchpad.
class LaunchpadPortfolioTabletPage extends ConsumerWidget {
  const LaunchpadPortfolioTabletPage({super.key});

  static const contentKey = Key('sc361_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(launchpadPortfolioSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _lpdFrame(
        context: context,
        semanticIdentifier: 'SC-361',
        semanticLabel: 'Danh mục launchpad',
        title: 'Đăng ký của bạn',
        subtitle: 'Lịch sử',
        contentKey: LaunchpadPortfolioTabletPage.contentKey,
        child: _lpdError(
          'Không tải được danh mục',
          () => ref.invalidate(launchpadPortfolioSnapshotProvider),
        ),
      ),
      data: (snapshot) => _lpdFrame(
        context: context,
        semanticIdentifier: 'SC-361',
        semanticLabel: 'Danh mục launchpad',
        title: snapshot.title,
        subtitle: '${snapshot.subscriptions.length} đăng ký',
        contentKey: LaunchpadPortfolioTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _lpdSection(
              title: 'Đăng ký',
              rows: [
                for (final sub in snapshot.subscriptions)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${sub.projectName} (${sub.projectSymbol})',
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                  color: AppColors.text1,
                                ),
                              ),
                              Text(
                                '${sub.tokensAllocated} token · phân bổ ${sub.allocationRatio.toStringAsFixed(2)}× · ${sub.timestamp}',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          sub.status.name,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-362: Hiệu suất launchpad.
class LaunchpadPerformanceTabletPage extends ConsumerWidget {
  const LaunchpadPerformanceTabletPage({super.key});

  static const contentKey = Key('sc362_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(launchpadPerformanceSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _lpdFrame(
        context: context,
        semanticIdentifier: 'SC-362',
        semanticLabel: 'Hiệu suất launchpad',
        title: 'Hiệu suất',
        subtitle: 'Dự án quá khứ',
        contentKey: LaunchpadPerformanceTabletPage.contentKey,
        child: _lpdError(
          'Không tải được hiệu suất',
          () => ref.invalidate(launchpadPerformanceSnapshotProvider),
        ),
      ),
      data: (snapshot) => _lpdFrame(
        context: context,
        semanticIdentifier: 'SC-362',
        semanticLabel: 'Hiệu suất launchpad',
        title: snapshot.title,
        subtitle: snapshot.subtitle,
        contentKey: LaunchpadPerformanceTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _lpdSection(
              title: 'Dự án lịch sử',
              rows: [
                for (final project in snapshot.projects)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Text(
                      project.name,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-363: Launchpool staking.
class LaunchpadStakingTabletPage extends ConsumerWidget {
  const LaunchpadStakingTabletPage({super.key});

  static const contentKey = Key('sc363_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(launchpadStakingSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _lpdFrame(
        context: context,
        semanticIdentifier: 'SC-363',
        semanticLabel: 'Bể stake',
        title: 'Launchpool',
        subtitle: 'Pool · Vị thế',
        contentKey: LaunchpadStakingTabletPage.contentKey,
        child: _lpdError(
          'Không tải được launchpool',
          () => ref.invalidate(launchpadStakingSnapshotProvider),
        ),
      ),
      data: (snapshot) => _lpdFrame(
        context: context,
        semanticIdentifier: 'SC-363',
        semanticLabel: 'Bể stake',
        title: snapshot.title,
        subtitle: '${snapshot.pools.length} pool',
        contentKey: LaunchpadStakingTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _lpdSection(
              title: 'Pool',
              rows: [
                for (final pool in snapshot.pools)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Text(
                      pool.id,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-364/365/366/367: Bộ ba chi tiết — sản phẩm, receipt, claim receipt.
class LaunchpadDetailTabletPage extends ConsumerWidget {
  const LaunchpadDetailTabletPage({super.key, required this.projectId});

  static const contentKey = Key('sc364_tablet_content');

  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(launchpadDetailSnapshotProvider(projectId));

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _lpdFrame(
        context: context,
        semanticIdentifier: 'SC-364',
        semanticLabel: 'Chi tiết dự án launchpad',
        title: 'Chi tiết dự án',
        subtitle: projectId,
        contentKey: LaunchpadDetailTabletPage.contentKey,
        child: _lpdError(
          'Không tải được dự án',
          () => ref.invalidate(launchpadDetailSnapshotProvider(projectId)),
        ),
      ),
      data: (snapshot) => _lpdFrame(
        context: context,
        semanticIdentifier: 'SC-364',
        semanticLabel: 'Chi tiết dự án launchpad',
        title: snapshot.title,
        subtitle: snapshot.project?.name ?? snapshot.projectId,
        contentKey: LaunchpadDetailTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (snapshot.project != null)
              _lpdSection(
                title: 'Thông tin dự án',
                rows: _lpdRows([
                  ('Mã', snapshot.project!.symbol),
                  ('Loại', snapshot.project!.type.name),
                  ('Trạng thái', snapshot.project!.status.name),
                  ('Tổng huy động', snapshot.project!.totalRaise),
                ]),
              ),
          ],
        ),
      ),
    );
  }
}

class LaunchpadReceiptTabletPage extends ConsumerWidget {
  const LaunchpadReceiptTabletPage({super.key});

  static const contentKey = Key('sc365_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(launchpadReceiptSnapshotProvider('sub001'));

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _lpdFrame(
        context: context,
        semanticIdentifier: 'SC-365',
        semanticLabel: 'Biên lai đăng ký launchpad',
        title: 'Biên lai đăng ký',
        subtitle: 'sub001',
        contentKey: LaunchpadReceiptTabletPage.contentKey,
        child: _lpdError(
          'Không tải được biên lai',
          () => ref.invalidate(launchpadReceiptSnapshotProvider('sub001')),
        ),
      ),
      data: (snapshot) => _lpdFrame(
        context: context,
        semanticIdentifier: 'SC-365',
        semanticLabel: 'Biên lai đăng ký launchpad',
        title: snapshot.title,
        subtitle: 'Đăng ký ${snapshot.subscriptionId}',
        contentKey: LaunchpadReceiptTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (snapshot.subscription != null)
              _lpdSection(
                title: 'Chi tiết',
                rows: _lpdRows([
                  ('Dự án', snapshot.subscription!.projectName),
                  ('Số tiền', snapshot.subscription!.amount.toStringAsFixed(2)),
                  ('Token nhận', '${snapshot.subscription!.tokensAllocated}'),
                  ('Trạng thái', snapshot.subscription!.status.name),
                ]),
              ),
          ],
        ),
      ),
    );
  }
}

/// SC-368/369/370: Công cụ contract · IDO bridge · ABI diff.
class LaunchpadContractTabletPage extends ConsumerWidget {
  const LaunchpadContractTabletPage({super.key});

  static const contentKey = Key('sc368_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      launchpadContractSnapshotProvider('sample'),
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _lpdFrame(
        context: context,
        semanticIdentifier: 'SC-368',
        semanticLabel: 'Hợp đồng launchpad',
        title: 'Hợp đồng',
        subtitle: 'Hàm · Mô phỏng',
        contentKey: LaunchpadContractTabletPage.contentKey,
        child: _lpdError(
          'Không tải được hợp đồng',
          () => ref.invalidate(launchpadContractSnapshotProvider('sample')),
        ),
      ),
      data: (snapshot) => _lpdFrame(
        context: context,
        semanticIdentifier: 'SC-368',
        semanticLabel: 'Hợp đồng launchpad',
        title: snapshot.title,
        subtitle: '${snapshot.functions.length} hàm',
        contentKey: LaunchpadContractTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _lpdSection(
              title: 'Hàm hợp đồng',
              rows: [
                for (final function in snapshot.functions.take(8))
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Text(
                      function.name,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
