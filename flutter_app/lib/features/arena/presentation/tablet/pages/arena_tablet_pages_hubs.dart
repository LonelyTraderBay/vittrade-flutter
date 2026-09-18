part of 'arena_tablet_pages.dart';

// Bước 2 rải pattern flagship (2026-09-09, sau khi user chấm đạt SC-184):
// 5 hub của module Arena — Guide, Points, Studio, MyArena, Leaderboard —
// cùng một ngôn ngữ composition: header + VitTwoColumnTabletDashboard,
// hero KPI / section giàu thông tin ở cột chính, panel điều hướng + số liệu
// ở cột phụ. Tái dùng widget của trang Home (cùng library): _ArenaHeroKpi,
// _ArenaRoomTile, _ArenaQuickActionRow, _statePillStatus.

/// Vỏ section chuẩn cho hub: header tự khai gap 12 (Luật 12dp) + nội dung.
class _ArenaHubSection extends StatelessWidget {
  const _ArenaHubSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitModuleSectionHeader(
          title: title,
          accentColor: AppModuleAccents.arena,
          density: VitDensity.compact,
          bottomGap: TabletSpacingTokens.x4,
        ),
        child,
      ],
    );
  }
}

/// Panel cột phụ: tiêu đề control đậm + nội dung, cùng khuôn panel Home.
class _ArenaHubPanel extends StatelessWidget {
  const _ArenaHubPanel({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: AppTextStyles.control.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          ...children,
        ],
      ),
    );
  }
}

/// Bước quy trình có đánh số: icon + "Bước n · tiêu đề" + mô tả + mẹo.
class _ArenaStepRow extends StatelessWidget {
  const _ArenaStepRow({
    required this.stepNumber,
    required this.title,
    required this.description,
    this.tip,
  });

  final int stepNumber;
  final String title;
  final String description;
  final String? tip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        vertical: TabletSpacingTokens.x3,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VitAccentIconBox(
            icon: Icons.directions_run_rounded,
            color: AppModuleAccents.arena,
          ),
          const SizedBox(width: TabletSpacingTokens.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bước $stepNumber · $title',
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                    color: AppColors.text1,
                  ),
                ),
                const SizedBox(height: TabletSpacingTokens.x1),
                Text(
                  description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.3,
                  ),
                ),
                if (tip != null && tip!.isNotEmpty) ...[
                  const SizedBox(height: TabletSpacingTokens.x1),
                  Text(
                    'Mẹo: $tip',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Hàng icon + tiêu đề + mô tả (mẹo an toàn, tín hiệu, nháp…).
class _ArenaIconTextRow extends StatelessWidget {
  const _ArenaIconTextRow({
    required this.icon,
    required this.color,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        vertical: TabletSpacingTokens.x3,
      ),
      child: Row(
        children: [
          VitAccentIconBox(icon: icon, color: color),
          const SizedBox(width: TabletSpacingTokens.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  const SizedBox(height: TabletSpacingTokens.x1),
                  Text(
                    subtitle!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: TabletSpacingTokens.x2),
            trailing!,
          ],
        ],
      ),
    );
  }
}

/// Hàng checklist (đánh dấu trước khi đấu).
class _ArenaCheckRow extends StatelessWidget {
  const _ArenaCheckRow(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        vertical: TabletSpacingTokens.x2,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VitAccentIconBox(
            icon: Icons.check_circle_outline_rounded,
            color: AppColors.successAccentBright,
          ),
          const SizedBox(width: TabletSpacingTokens.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

/// Khung trang hub: header + loading/error/dashboard — dùng chung 5 hub.
class _ArenaHubScaffold extends StatelessWidget {
  const _ArenaHubScaffold({
    required this.semanticIdentifier,
    required this.semanticLabel,
    required this.title,
    required this.subtitle,
    required this.snapshotAsync,
    required this.onRetry,
    required this.buildDashboard,
  });

  final String semanticIdentifier;
  final String semanticLabel;
  final String title;
  final String subtitle;
  final AsyncValue<Object?> snapshotAsync;
  final VoidCallback onRetry;
  final Widget Function() buildDashboard;

  @override
  Widget build(BuildContext context) {
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
            child: snapshotAsync.when(
              loading: () => const Center(child: VitSkeletonList(rows: 8)),
              error: (error, stackTrace) => SingleChildScrollView(
                child: _ardError('Không tải được $title', onRetry),
              ),
              data: (_) => buildDashboard(),
            ),
          ),
        ],
      ),
    );
  }
}

/// SC-209: Hướng dẫn Arena — quy trình tạo/tham gia ở cột chính, mẹo an
/// toàn + checklist + lối tắt ở cột phụ.
class ArenaGuideTabletPage extends ConsumerWidget {
  const ArenaGuideTabletPage({super.key});

  static const contentKey = Key('sc209_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(arenaGuideSnapshotProvider);

    return _ArenaHubScaffold(
      semanticIdentifier: 'SC-209',
      semanticLabel: 'Hướng dẫn đấu trường',
      title: 'Hướng dẫn',
      subtitle: 'Tạo · Tham gia · An toàn',
      snapshotAsync: snapshotAsync,
      onRetry: () => ref.invalidate(arenaGuideSnapshotProvider),
      buildDashboard: () {
        final snapshot = snapshotAsync.value as ArenaGuideSnapshot;
        return VitTwoColumnTabletDashboard(
          primaryChildren: [
            _ArenaHubSection(
              title: 'Các bước tạo thử thách',
              child: VitCard(
                radius: VitCardRadius.tight,
                padding: TabletSpacingTokens.cardPaddingCompact,
                child: Column(
                  children: [
                    for (final step in snapshot.createSteps)
                      _ArenaStepRow(
                        stepNumber: step.step,
                        title: step.title,
                        description: step.description,
                        tip: step.tip,
                      ),
                  ],
                ),
              ),
            ),
            _ArenaHubSection(
              title: 'Các bước tham gia',
              child: VitCard(
                radius: VitCardRadius.tight,
                padding: TabletSpacingTokens.cardPaddingCompact,
                child: Column(
                  children: [
                    for (final step in snapshot.joinSteps)
                      _ArenaStepRow(
                        stepNumber: step.step,
                        title: step.title,
                        description: step.description,
                        tip: step.tip,
                      ),
                  ],
                ),
              ),
            ),
          ],
          secondaryChildren: [
            _ArenaHubPanel(
              title: 'Mẹo an toàn',
              children: [
                for (final tip in snapshot.safetyTips)
                  _ArenaIconTextRow(
                    icon: Icons.shield_outlined,
                    color: AppColors.warn,
                    title: tip.title,
                    subtitle: tip.description,
                  ),
              ],
            ),
            if (snapshot.checklist.isNotEmpty)
              _ArenaHubPanel(
                title: 'Rà soát trước khi đấu',
                children: [
                  for (final item in snapshot.checklist) _ArenaCheckRow(item),
                ],
              ),
            _ArenaQuickActions(
              pendingNotifications: 0,
              onNavigate: (path) => context.push(path),
              overrides: const [
                (
                  icon: Icons.auto_awesome_rounded,
                  label: 'Tạo thử thách trong Studio',
                  path: AppRoutePaths.arenaStudio,
                ),
                (
                  icon: Icons.emoji_events_outlined,
                  label: 'Bảng xếp hạng',
                  path: AppRoutePaths.arenaLeaderboard,
                ),
                (
                  icon: Icons.stars_outlined,
                  label: 'Điểm Arena',
                  path: AppRoutePaths.arenaLedger,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
