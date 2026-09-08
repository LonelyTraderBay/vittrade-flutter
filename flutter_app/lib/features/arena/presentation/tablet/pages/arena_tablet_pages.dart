import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/arena_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part 'arena_tablet_pages_studio.dart';
part 'arena_tablet_pages_play.dart';
part 'arena_tablet_pages_points.dart';

Widget _ardFrame({
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
                  fallbackPath: AppRoutePaths.arena,
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

Widget _ardError(String title, VoidCallback onRetry) {
  return VitErrorState(
    title: title,
    message: 'Vui lòng kiểm tra kết nối và thử lại.',
    actionLabel: 'Thử lại',
    onAction: onRetry,
  );
}

Widget _ardSection({required String title, required List<Widget> rows}) {
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

List<Widget> _ardBullets(List<String> notes) {
  return [
    for (final note in notes)
      Padding(
        padding: TabletSpacingTokens.tableCellPaddingV,
        child: VitBulletRow(text: note),
      ),
  ];
}

Widget _ardBody(String text) {
  return Text(
    text,
    style: AppTextStyles.caption.copyWith(color: AppColors.text2, height: 1.3),
  );
}

Widget _ardQuickLinks(BuildContext context, List<(String, String)> links) {
  return Wrap(
    spacing: TabletSpacingTokens.x2,
    runSpacing: TabletSpacingTokens.x2,
    children: [
      for (final (label, path) in links)
        VitFilterChip(
          label: label,
          active: false,
          color: AppColors.primary,
          onTap: () => context.go(path),
        ),
    ],
  );
}

/// SC-184: Hub Open Arena.
class ArenaHomeTabletPage extends ConsumerWidget {
  const ArenaHomeTabletPage({super.key});

  static const contentKey = Key('sc184_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(arenaHomeSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _ardFrame(
        context: context,
        semanticIdentifier: 'SC-184',
        semanticLabel: 'Đấu trường mở',
        title: 'Open Arena',
        subtitle: 'Thử thách · Điểm Arena',
        contentKey: ArenaHomeTabletPage.contentKey,
        child: _ardError(
          'Không tải được Open Arena',
          () => ref.invalidate(arenaHomeSnapshotProvider),
        ),
      ),
      data: (snapshot) => _ardFrame(
        context: context,
        semanticIdentifier: 'SC-184',
        semanticLabel: 'Đấu trường mở',
        title: 'Open Arena',
        subtitle: '${snapshot.liveRooms.length} phòng đang chạy',
        contentKey: ArenaHomeTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ardSection(
              title: 'Phòng đang chạy',
              rows: [
                for (final room in snapshot.liveRooms.take(8))
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Material(
                      color: AppColors.transparent,
                      child: InkWell(
                        onTap: () =>
                            context.go(AppRoutePaths.arenaChallenge(room.id)),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                room.title,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text1,
                                ),
                              ),
                            ),
                            Text(
                              room.format,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _ardSection(
              title: 'Chế độ nổi bật',
              rows: [
                for (final mode in snapshot.featuredModes.take(8))
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Material(
                      color: AppColors.transparent,
                      child: InkWell(
                        onTap: () =>
                            context.go(AppRoutePaths.arenaMode(mode.id)),
                        child: Text(
                          mode.id,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _ardSection(
              title: 'Khám phá',
              rows: [
                _ardQuickLinks(context, [
                  ('Hướng dẫn', AppRoutePaths.arenaGuide),
                  ('Studio', AppRoutePaths.arenaStudio),
                  ('Bảng xếp hạng', AppRoutePaths.arenaLeaderboard),
                  ('Thử thách đã xác thực', AppRoutePaths.arenaVerified),
                  ('Điểm Arena', AppRoutePaths.arenaPoints),
                  ('Sổ điểm', AppRoutePaths.arenaLedger),
                  ('Arena của tôi', AppRoutePaths.arenaMy),
                  ('Báo cáo của tôi', AppRoutePaths.arenaMyReports),
                  ('Sơ đồ luồng', AppRoutePaths.arenaFlowMap),
                  ('Trung tâm an toàn', AppRoutePaths.arenaSafety),
                  ('Trung tâm phân định', AppRoutePaths.arenaResolution),
                  ('Cầu nối Prediction', AppRoutePaths.arenaBridge),
                  ('Hệ sinh thái', AppRoutePaths.arenaEcosystem),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-209: Hướng dẫn Arena.
class ArenaGuideTabletPage extends ConsumerWidget {
  const ArenaGuideTabletPage({super.key});

  static const contentKey = Key('sc209_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(arenaGuideSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _ardFrame(
        context: context,
        semanticIdentifier: 'SC-209',
        semanticLabel: 'Hướng dẫn đấu trường',
        title: snapshotAsync.value?.heroTitle ?? 'Hướng dẫn',
        subtitle: 'Tạo · Tham gia',
        contentKey: ArenaGuideTabletPage.contentKey,
        child: _ardError(
          'Không tải được hướng dẫn',
          () => ref.invalidate(arenaGuideSnapshotProvider),
        ),
      ),
      data: (snapshot) => _ardFrame(
        context: context,
        semanticIdentifier: 'SC-209',
        semanticLabel: 'Hướng dẫn đấu trường',
        title: snapshot.heroTitle,
        subtitle: snapshot.heroSubtitle,
        contentKey: ArenaGuideTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ardSection(
              title: 'Các bước tạo',
              rows: _ardBullets([
                for (final step in snapshot.createSteps) step.title,
              ]),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _ardSection(
              title: 'Các bước tham gia',
              rows: _ardBullets([
                for (final step in snapshot.joinSteps) step.title,
              ]),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _ardSection(
              title: 'Mẹo an toàn',
              rows: _ardBullets([
                for (final tip in snapshot.safetyTips) tip.title,
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
