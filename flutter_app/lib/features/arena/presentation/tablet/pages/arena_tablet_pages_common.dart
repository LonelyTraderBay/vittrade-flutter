part of 'arena_tablet_pages.dart';

// Helper widget dùng chung các cụm tablet Arena (tách từ _play theo vai
// trò common khi file vượt trần 1200 dòng — Debt-A).

// Cụm Play (Đợt 1 redesign tablet Arena 2026-09-19): SC-189 Mode detail,
// SC-190 Challenge detail, SC-191 Join, SC-193 Creator — re-compose từ nội
// dung phone theo idiom workspace 2 cột (VitTabletPaneWorkspace), đầy đủ dữ
// liệu snapshot (không take-N), nối controller read-model.

// ---------------------------------------------------------------------------
// Helper dùng chung cụm play.

String _playChallengeStateLabel(ArenaChallengeState state) {
  return switch (state) {
    ArenaChallengeState.open => 'Đang mở',
    ArenaChallengeState.full => 'Đã đủ chỗ',
    ArenaChallengeState.live => 'Đang diễn ra',
    ArenaChallengeState.pendingResult => 'Chờ kết quả',
    ArenaChallengeState.resolved => 'Đã phân xử',
    ArenaChallengeState.canceled => 'Đã huỷ',
  };
}

VitStatusPillStatus _playChallengeStatePill(ArenaChallengeState state) {
  return switch (state) {
    ArenaChallengeState.open => VitStatusPillStatus.info,
    ArenaChallengeState.full => VitStatusPillStatus.neutral,
    ArenaChallengeState.live => VitStatusPillStatus.success,
    ArenaChallengeState.pendingResult => VitStatusPillStatus.warning,
    ArenaChallengeState.resolved => VitStatusPillStatus.neutral,
    ArenaChallengeState.canceled => VitStatusPillStatus.error,
  };
}

VitStatusPillStatus _playMetricPill(VitArenaMetricStatus status) {
  return switch (status) {
    VitArenaMetricStatus.success => VitStatusPillStatus.success,
    VitArenaMetricStatus.warning => VitStatusPillStatus.warning,
    VitArenaMetricStatus.info => VitStatusPillStatus.info,
    VitArenaMetricStatus.neutral => VitStatusPillStatus.neutral,
  };
}

/// Dòng label → value dùng trong card thông tin (đủ số liệu, không cắt).
class _PlayInfoRow extends StatelessWidget {
  const _PlayInfoRow({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
        const SizedBox(width: TabletSpacingTokens.x3),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: color ?? AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

/// Card danh sách dòng label → value (điều khoản, chỉ số, quy tắc tóm tắt).
class _PlayInfoCard extends StatelessWidget {
  const _PlayInfoCard({required this.title, required this.rows, this.icon});

  final String title;
  final List<Widget> rows;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              if (icon != null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    end: TabletSpacingTokens.x2,
                  ),
                  child: Icon(
                    icon,
                    size: TabletSpacingTokens.iconSm,
                    color: AppColors.text2,
                  ),
                ),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.control.copyWith(
                    fontWeight: AppTextStyles.bold,
                    color: AppColors.text1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x3),
          for (var i = 0; i < rows.length; i++) ...[
            rows[i],
            if (i < rows.length - 1)
              const SizedBox(height: TabletSpacingTokens.x3),
          ],
        ],
      ),
    );
  }
}

/// Danh sách quy tắc đánh số (đủ nội dung, không take).
class _PlayRuleList extends StatelessWidget {
  const _PlayRuleList({required this.rules});

  final List<String> rules;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < rules.length; i++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: TabletSpacingTokens.x5,
                  child: Text(
                    '${i + 1}.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppModuleAccents.arena,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    rules[i],
                    style: AppTextStyles.body.copyWith(color: AppColors.text1),
                  ),
                ),
              ],
            ),
            if (i < rules.length - 1)
              const SizedBox(height: TabletSpacingTokens.x3),
          ],
        ],
      ),
    );
  }
}

/// Tile danh sách phòng/mode bấm được — cùng idiom card zeroInsets + divider
/// như section "Phòng đang mở" của hub home.
class _PlayListSection extends StatelessWidget {
  const _PlayListSection({
    required this.title,
    required this.itemCount,
    required this.itemBuilder,
    this.emptyMessage,
  });

  final String title;
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0) {
      return emptyMessage == null
          ? const SizedBox.shrink()
          : VitCard(
              radius: VitCardRadius.tight,
              padding: TabletSpacingTokens.cardPaddingCompact,
              child: Text(
                emptyMessage!,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            );
    }
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.zeroInsets,
      clip: true,
      child: Column(
        children: [
          Padding(
            padding: TabletSpacingTokens.cardPaddingCompact,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.control.copyWith(
                      fontWeight: AppTextStyles.bold,
                      color: AppColors.text1,
                    ),
                  ),
                ),
                Text(
                  '$itemCount',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
          for (var i = 0; i < itemCount; i++) ...[
            itemBuilder(context, i),
            if (i < itemCount - 1)
              const Divider(
                height: TabletSpacingTokens.dividerHairline,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}
