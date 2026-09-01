import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/phone/arena_viewport_padding.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/arena_controller_providers.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';
import 'package:vit_trade_flutter/app/theme/spacing/arena_spacing_tokens.dart';

const _blockedBodyLineRatio = ArenaSpacingTokens.arenaBlockedBodyLineHeight;
const _blockedDividerExtent = ArenaSpacingTokens.arenaPointsDividerHeight;
const _blockedTinyGap = ArenaSpacingTokens.arenaBlockedTinyGap;

class ArenaBlockedUsersPage extends ConsumerStatefulWidget {
  const ArenaBlockedUsersPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc203_blocked_content');
  static const emptyKey = Key('sc203_blocked_empty');

  static Key userKey(String id) => Key('sc203_blocked_user_$id');

  static Key unblockKey(String id) => Key('sc203_unblock_$id');

  static Key viewProfileKey(String id) => Key('sc203_view_profile_$id');

  static Key confirmUnblockKey(String id) => Key('sc203_confirm_unblock_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaBlockedUsersPage> createState() =>
      _ArenaBlockedUsersPageState();
}

class _ArenaBlockedUsersPageState extends ConsumerState<ArenaBlockedUsersPage> {
  // STATE-S23: danh sách chặn sống ở ArenaBlockedUsersStateController (một
  // nguồn sự thật) — hết `late List` seed từ snapshot + setState.

  @override
  Widget build(BuildContext context) {
    // Bẫy 21 (GD4 Playbook mục 9): Notifier vẫn sync (biến thể A) — trang
    // PHẢI tự gate qua provider snapshot gốc, nếu không sẽ render fallback
    // rỗng suốt cửa sổ loading.
    final snapshotAsync = ref.watch(arenaBlockedUsersSnapshotProvider);

    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final footerPadding = arenaFooterPadding(
      context,
      mode,
      visualExtra: AppSpacing.x3,
      nativeExtra: AppSpacing.x2,
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Danh sách người dùng đã chặn trong Open Arena',
      semanticIdentifier: 'SC-203',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Người đã chặn',
            subtitle: 'An toàn · Open Arena',
            showBack: true,
            onBack: () => _close(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: ArenaBlockedUsersPage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: ArenaSpacingTokens.arenaBottomScrollPadding(
                      footerPadding,
                    ),
                    child: snapshotAsync.when(
                      loading: () => const VitSkeletonList(),
                      error: (error, stackTrace) => VitErrorState(
                        title: 'Không tải được danh sách chặn',
                        message: 'Vui lòng kiểm tra kết nối và thử lại.',
                        actionLabel: 'Thử lại',
                        onAction: () =>
                            ref.invalidate(arenaBlockedUsersSnapshotProvider),
                      ),
                      data: (_) {
                        final viewState = ref.watch(
                          arenaBlockedUsersStateControllerProvider,
                        );
                        final snapshot = viewState.snapshot;
                        return viewState.users.isEmpty
                            ? VitPageContent(
                                rhythm: VitPageRhythm.standard,
                                key: ArenaBlockedUsersPage.emptyKey,
                                padding: VitContentPadding.none,
                                children: [
                                  VitEmptyState(
                                    icon: Icons.shield_outlined,
                                    title: snapshot.emptyTitle,
                                    message: snapshot.emptySubtitle,
                                  ),
                                ],
                              )
                            : VitPageContent(
                                padding: VitContentPadding.compact,
                                gap: VitContentGap.tight,
                                children: [
                                  _BlockInfoBanner(snapshot: snapshot),
                                  _BlockedUsersCard(
                                    users: viewState.users,
                                    onUnblock: (user) => _requestUnblock(user),
                                    onViewProfile: (user) {
                                      unawaited(
                                        HapticFeedback.selectionClick(),
                                      );
                                      context.go(
                                        AppRoutePaths.arenaCreator(user.id),
                                      );
                                    },
                                  ),
                                  Text(
                                    '${viewState.users.length} người đã bị chặn',
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.text3,
                                    ),
                                  ),
                                ],
                              );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _requestUnblock(ArenaBlockedUserDraft user) async {
    unawaited(HapticFeedback.mediumImpact());
    final confirmed = await showVitConfirmDialog(
      context: context,
      title: 'Bỏ chặn ${user.name}?',
      message:
          'Người này sẽ có thể thấy và tương tác với bạn trong Open Arena. Bạn có thể chặn lại bất cứ lúc nào.',
      confirmLabel: 'Bỏ chặn',
      cancelLabel: 'Giữ chặn',
      confirmVariant: VitCtaButtonVariant.destructive,
      confirmKey: ArenaBlockedUsersPage.confirmUnblockKey(user.id),
    );
    if (!confirmed || !mounted) return;

    ref
        .read(arenaBlockedUsersStateControllerProvider.notifier)
        .unblockUser(user.id);
  }

  static void _close(BuildContext context) {
    unawaited(HapticFeedback.selectionClick());
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.arenaSafety);
  }
}

class _BlockInfoBanner extends StatelessWidget {
  const _BlockInfoBanner({required this.snapshot});

  final ArenaBlockedUsersSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: ArenaSpacingTokens.arenaBlockedCardPadding,
      borderColor: AppColors.primary20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _ToneIcon(icon: Icons.info_outline, color: AppColors.primary),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.bannerTitle,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.bannerDescription,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: _blockedBodyLineRatio,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BlockedUsersCard extends StatelessWidget {
  const _BlockedUsersCard({
    required this.users,
    required this.onUnblock,
    required this.onViewProfile,
  });

  final List<ArenaBlockedUserDraft> users;
  final ValueChanged<ArenaBlockedUserDraft> onUnblock;
  final ValueChanged<ArenaBlockedUserDraft> onViewProfile;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      clip: true,
      padding: AppSpacing.zeroInsets,
      child: Column(
        children: [
          for (var index = 0; index < users.length; index++)
            _BlockedUserRow(
              key: ArenaBlockedUsersPage.userKey(users[index].id),
              user: users[index],
              isLast: index == users.length - 1,
              onUnblock: () => onUnblock(users[index]),
              onViewProfile: () => onViewProfile(users[index]),
            ),
        ],
      ),
    );
  }
}

class _BlockedUserRow extends StatelessWidget {
  const _BlockedUserRow({
    super.key,
    required this.user,
    required this.isLast,
    required this.onUnblock,
    required this.onViewProfile,
  });

  final ArenaBlockedUserDraft user;
  final bool isLast;
  final VoidCallback onUnblock;
  final VoidCallback onViewProfile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: ArenaSpacingTokens.arenaBlockedRowPadding,
          child: Row(
            children: [
              _BlockedAvatar(user: user),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: _blockedTinyGap),
                    Text(
                      user.reason,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    const SizedBox(height: _blockedTinyGap),
                    Text(
                      '${user.blockedAt} · ${_sourceLabel(user.source)}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _SmallActionButton(
                    key: ArenaBlockedUsersPage.unblockKey(user.id),
                    label: 'Bỏ chặn',
                    accentColor: AppColors.warn,
                    onTap: onUnblock,
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                  _SmallActionButton(
                    key: ArenaBlockedUsersPage.viewProfileKey(user.id),
                    label: 'Xem hồ sơ',
                    accentColor: AppColors.text2,
                    onTap: onViewProfile,
                  ),
                ],
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(
            height: _blockedDividerExtent,
            color: AppColors.divider,
          ),
      ],
    );
  }
}

class _BlockedAvatar extends StatelessWidget {
  const _BlockedAvatar({required this.user});

  final ArenaBlockedUserDraft user;

  @override
  Widget build(BuildContext context) {
    final color = user.source == ArenaBlockedUserSource.reportOutcome
        ? AppColors.sell
        : AppColors.accent;
    final icon = user.source == ArenaBlockedUserSource.reportOutcome
        ? Icons.person_off_outlined
        : Icons.smart_toy_outlined;

    return SizedBox.square(
      dimension: ArenaSpacingTokens.arenaBlockedAvatarBox,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: color.withValues(alpha: 0.12),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
        ),
        child: Center(
          child: Icon(
            icon,
            color: color.withValues(alpha: 0.78),
            size: ArenaSpacingTokens.arenaBlockedAvatarIcon,
          ),
        ),
      ),
    );
  }
}

class _SmallActionButton extends StatelessWidget {
  const _SmallActionButton({
    super.key,
    required this.label,
    required this.accentColor,
    required this.onTap,
  });

  final String label;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: ArenaSpacingTokens.arenaBlockedActionMinWidth,
      ),
      child: VitChoicePill(
        label: label,
        selected: true,
        onTap: onTap,
        accentColor: accentColor,
        padding: ArenaSpacingTokens.arenaBlockedActionPadding,
      ),
    );
  }
}

class _ToneIcon extends StatelessWidget {
  const _ToneIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: ArenaSpacingTokens.arenaBlockedToneIconBox,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: color.withValues(alpha: 0.12),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
        ),
        child: Center(
          child: Icon(
            icon,
            color: color,
            size: ArenaSpacingTokens.arenaBlockedToneIcon,
          ),
        ),
      ),
    );
  }
}

String _sourceLabel(ArenaBlockedUserSource source) {
  return switch (source) {
    ArenaBlockedUserSource.manual => 'Tự chặn',
    ArenaBlockedUserSource.reportOutcome => 'Từ báo cáo',
    ArenaBlockedUserSource.system => 'Hệ thống',
  };
}
