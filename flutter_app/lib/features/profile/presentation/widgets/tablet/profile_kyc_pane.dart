import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/profile_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/profile_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_pane_scaffold.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Tablet KYC detail pane (SC-159) for the Profile master-detail shell — a
/// public port of the phone `KYCPage`'s content (status card, risk-review
/// panel, expandable level cards, privacy note) into
/// [ProfilePaneScaffold], per R2: the phone page and its `part` family stay
/// untouched. Data comes from the same [profileKycSnapshotProvider].
class ProfileKycPane extends ConsumerStatefulWidget {
  const ProfileKycPane({super.key});

  @override
  ConsumerState<ProfileKycPane> createState() => _ProfileKycPaneState();
}

class _ProfileKycPaneState extends ConsumerState<ProfileKycPane> {
  int? _expandedLevel;
  bool _submitting = false;

  static const _kycGreen = AppColors.buy;
  static const _kycPrimary = AppColors.primary;
  static const _kycMuted = AppColors.text3;

  Future<void> _refresh() async {
    ref.invalidate(profileKycSnapshotProvider);
    await ref.read(profileKycSnapshotProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(profileKycSnapshotProvider);

    return ProfilePaneScaffold(
      title: 'Xác minh danh tính',
      subtitle: 'KYC · cấp độ và hạn mức',
      onBack: () => context.go(AppRoutePaths.profile),
      onRefresh: _refresh,
      scrollKey: ProfileTabletKeys.kycPane,
      children: snapshotAsync.when(
        loading: () => const [VitSkeletonList(rows: 5)],
        error: (error, stackTrace) => [
          VitErrorState(
            key: ProfileTabletKeys.kycPaneError,
            title: 'Không tải được dữ liệu',
            message: 'Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: _refresh,
          ),
        ],
        data: (snapshot) => [
          _KycStatusCard(snapshot: snapshot),
          VitHighRiskStatePanel(
            state: _submitting
                ? VitHighRiskUiState.submitting
                : VitHighRiskUiState.riskReview,
            title: _submitting
                ? 'Đang gửi hồ sơ xác minh'
                : 'Rà soát xác minh danh tính',
            message:
                'Kiểm tra cấp KYC, giới hạn giao dịch và tính năng mở khóa trước khi nộp.',
            contractId: 'Cấp hiện tại: ${snapshot.currentLevel}',
            density: VitDensity.compact,
          ),
          if (snapshot.levels.isEmpty)
            const VitEmptyState(
              title: 'Chưa có cấp KYC',
              message: 'Các cấp xác minh sẽ hiển thị sau khi đồng bộ.',
              icon: Icons.verified_user_outlined,
            )
          else
            for (final level in snapshot.levels)
              _KycLevelCard(
                level: level,
                done: snapshot.currentLevel >= level.level,
                expanded: _expandedLevel == level.level,
                currentLevel: snapshot.currentLevel,
                submitting: _submitting,
                onTap: () {
                  unawaited(HapticFeedback.selectionClick());
                  setState(
                    () => _expandedLevel = _expandedLevel == level.level
                        ? null
                        : level.level,
                  );
                },
                onStart: () => _startVerification(level.level),
              ),
          const _KycPrivacyCard(),
        ],
      ),
    );
  }

  Future<void> _startVerification(int level) async {
    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 320));
    if (!mounted) return;
    setState(() => _submitting = false);
  }
}

class _KycStatusCard extends StatelessWidget {
  const _KycStatusCard({required this.snapshot});

  final ProfileKycSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ProfileTabletKeys.kycStatusCard,
      density: VitDensity.compact,
      borderColor: _ProfileKycPaneState._kycGreen.withValues(alpha: .45),
      child: VitIconListRow(
        gap: ProfileSpacingTokens.kycStatusGap,
        leading: SizedBox(
          width: ProfileSpacingTokens.kycStatusIconBox,
          height: ProfileSpacingTokens.kycStatusIconBox,
          child: Material(
            color: _ProfileKycPaneState._kycGreen.withValues(alpha: .2),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.cardLargeRadius,
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: _ProfileKycPaneState._kycGreen,
              size: ProfileSpacingTokens.kycStatusIcon,
            ),
          ),
        ),
        title: Text(
          snapshot.statusTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.baseMedium.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        subtitle: Row(
          children: [
            Flexible(
              child: Text(
                snapshot.statusDescription,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: _ProfileKycPaneState._kycGreen,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
            ),
            const SizedBox(width: ProfileSpacingTokens.kycStatusCheckGap),
            const Icon(
              Icons.check_rounded,
              color: _ProfileKycPaneState._kycGreen,
              size: ProfileSpacingTokens.kycStatusCheckIcon,
            ),
          ],
        ),
      ),
    );
  }
}

class _KycLevelCard extends StatelessWidget {
  const _KycLevelCard({
    required this.level,
    required this.done,
    required this.expanded,
    required this.currentLevel,
    required this.submitting,
    required this.onTap,
    required this.onStart,
  });

  final ProfileKycLevel level;
  final bool done;
  final bool expanded;
  final int currentLevel;
  final bool submitting;
  final VoidCallback onTap;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final accent = Color(level.colorHex);
    final border = done ? accent.withValues(alpha: .44) : AppColors.borderSolid;

    return VitCard(
      borderColor: border,
      clip: true,
      child: Column(
        children: [
          VitCard(
            key: ProfileTabletKeys.kycLevel(level.level),
            onTap: onTap,
            variant: VitCardVariant.ghost,
            borderColor: AppColors.transparent,
            child: VitIconListRow(
              minHeight: VitDensity.compact.controlHeight + AppSpacing.x5,
              padding: ProfileSpacingTokens.kycLevelRowPadding,
              gap: ProfileSpacingTokens.kycLevelRowGap,
              leading: _LevelIcon(
                level: level.level,
                done: done,
                accent: accent,
              ),
              title: Text(
                level.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.baseMedium.copyWith(
                  color: done ? AppColors.text1 : AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              subtitle: done
                  ? Row(
                      children: [
                        const Icon(
                          Icons.check_rounded,
                          color: _ProfileKycPaneState._kycMuted,
                          size: ProfileSpacingTokens.kycDetailIcon,
                        ),
                        const SizedBox(
                          width:
                              AppSpacing.dividerHairline +
                              AppSpacing.hairlineStroke,
                        ),
                        Text(
                          'Đã hoàn thành',
                          style: AppTextStyles.badge.copyWith(
                            color: _ProfileKycPaneState._kycMuted,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      'Chưa xác minh',
                      style: AppTextStyles.badge.copyWith(
                        color: _ProfileKycPaneState._kycMuted,
                      ),
                    ),
              trailing: AnimatedRotation(
                turns: expanded ? .25 : 0,
                duration: const Duration(milliseconds: 180),
                child: const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.text3,
                  size: ProfileSpacingTokens.kycLevelChevron,
                ),
              ),
            ),
          ),
          if (expanded) ...[
            const Divider(
              height: AppSpacing.dividerHairline,
              color: AppColors.divider,
            ),
            Padding(
              padding: ProfileSpacingTokens.kycLevelDetailsPadding,
              child: _ExpandedLevelDetails(
                level: level,
                done: done,
                currentLevel: currentLevel,
                submitting: submitting,
                onStart: onStart,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LevelIcon extends StatelessWidget {
  const _LevelIcon({
    required this.level,
    required this.done,
    required this.accent,
  });

  final int level;
  final bool done;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ProfileSpacingTokens.kycLevelIconBox,
      height: ProfileSpacingTokens.kycLevelIconBox,
      child: Material(
        color: done ? accent.withValues(alpha: .13) : AppColors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.lgRadius,
          side: BorderSide(
            color: done ? accent : AppColors.borderSolid,
            width: ProfileSpacingTokens.kycLevelIconBorder,
          ),
        ),
        child: Center(
          child: done
              ? Icon(
                  Icons.check_circle_outline_rounded,
                  color: accent,
                  size: ProfileSpacingTokens.kycLevelDoneIcon,
                )
              : Text(
                  '$level',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
        ),
      ),
    );
  }
}

class _ExpandedLevelDetails extends StatelessWidget {
  const _ExpandedLevelDetails({
    required this.level,
    required this.done,
    required this.currentLevel,
    required this.submitting,
    required this.onStart,
  });

  final ProfileKycLevel level;
  final bool done;
  final int currentLevel;
  final bool submitting;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final canStart = !done && level.level == currentLevel + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DetailsBlock(title: 'Giới hạn giao dịch:', lines: level.limits),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        _DetailsBlock(
          title: 'Tính năng mở khóa:',
          lines: level.features,
          done: done,
        ),
        if (canStart) ...[
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCtaButton(
            key: ProfileTabletKeys.kycStart(level.level),
            onPressed: submitting ? null : onStart,
            loading: submitting,
            density: VitDensity.compact,
            child: Text(
              submitting ? 'Đang gửi...' : 'Bắt đầu xác minh ${level.title}',
            ),
          ),
        ],
      ],
    );
  }
}

class _DetailsBlock extends StatelessWidget {
  const _DetailsBlock({
    required this.title,
    required this.lines,
    this.done = true,
  });

  final String title;
  final List<String> lines;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.badge.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        for (final line in lines) ...[
          Row(
            children: [
              if (title.startsWith('T'))
                Icon(
                  Icons.check_circle_rounded,
                  color: done
                      ? _ProfileKycPaneState._kycGreen
                      : AppColors.text3,
                  size: ProfileSpacingTokens.kycDetailIcon,
                )
              else
                Text(
                  '• ',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text1),
                ),
              const SizedBox(width: ProfileSpacingTokens.kycDetailIconGap),
              Expanded(
                child: Text(
                  line,
                  style: AppTextStyles.caption.copyWith(
                    color: done ? AppColors.text1 : AppColors.text3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x1),
        ],
      ],
    );
  }
}

class _KycPrivacyCard extends StatelessWidget {
  const _KycPrivacyCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ProfileTabletKeys.kycPrivacyCard,
      density: VitDensity.compact,
      borderColor: _ProfileKycPaneState._kycPrimary.withValues(alpha: .24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _ProfileKycPaneState._kycPrimary,
            size: ProfileSpacingTokens.kycPrivacyIcon,
          ),
          const SizedBox(width: ProfileSpacingTokens.kycPrivacyGapHorizontal),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bảo mật thông tin cá nhân',
                  style: AppTextStyles.caption.copyWith(
                    color: _ProfileKycPaneState._kycPrimary,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  'Thông tin KYC được mã hóa AES-256. Chúng tôi không chia sẻ với bên thứ ba.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
