import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/profile_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_motion.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/profile_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_pane_scaffold.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_tablet_keys.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/vip_history_widgets.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Tablet VIP detail pane (SC-164) for the Profile master-detail shell — a
/// public port of the phone `VIPPage`'s content (tier hero, Tổng quan /
/// Đặc quyền / Lịch sử segment tabs, progress-to-next-tier card, tier
/// comparison table, per-tier benefit cards and upgrade CTA) into
/// [ProfilePaneScaffold], per R2. The history tab reuses the already-public
/// [VipHistoryTab] directly. Same [profileVipSnapshotProvider] data.
class ProfileVipPane extends ConsumerStatefulWidget {
  const ProfileVipPane({super.key});

  @override
  ConsumerState<ProfileVipPane> createState() => _ProfileVipPaneState();
}

enum _VipTab { overview, benefits, history }

class _ProfileVipPaneState extends ConsumerState<ProfileVipPane> {
  _VipTab _selectedTab = _VipTab.overview;

  static const _vipAccent = AppColors.primary;
  static const _vipGold = AppColors.moduleAccentAmber;
  static const _vipSuccess = AppColors.buy;
  static const _vipMuted = AppColors.text3;
  static const _vipProfileAccent = AppModuleAccents.profile;

  Future<void> _refresh() async {
    ref.invalidate(profileVipSnapshotProvider);
    await ref.read(profileVipSnapshotProvider.future);
  }

  void _openTrade() {
    unawaited(HapticFeedback.selectionClick());
    unawaited(context.push(AppRoutePaths.tradePair('btcusdt')));
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(profileVipSnapshotProvider);

    return ProfilePaneScaffold(
      title: 'Chương trình VIP',
      subtitle: 'VIP · cấp độ · đặc quyền',
      onBack: () => context.go(AppRoutePaths.profile),
      onRefresh: _refresh,
      scrollKey: ProfileTabletKeys.vipPane,
      children: snapshotAsync.when(
        loading: () => const [VitSkeletonList(rows: 5)],
        error: (error, stackTrace) => [
          VitErrorState(
            key: ProfileTabletKeys.vipPaneError,
            title: 'Không tải được dữ liệu',
            message: 'Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: _refresh,
          ),
        ],
        data: (snapshot) => [
          // Top-level blocks stay flat: the standard Tablet rhythm inside
          // ProfilePaneScaffold already inserts one 12dp section gap between
          // each pair of children. A manual separator would stack onto it.
          _VipHero(snapshot: snapshot),
          _VipTabs(
            active: _selectedTab,
            onChanged: (tab) => setState(() => _selectedTab = tab),
          ),
          AnimatedSwitcher(
            duration: AppMotion.element,
            child: switch (_selectedTab) {
              _VipTab.overview => _VipOverviewTab(
                key: const ValueKey('overview'),
                snapshot: snapshot,
              ),
              _VipTab.benefits => _BenefitsTab(
                key: const ValueKey('benefits'),
                snapshot: snapshot,
                onTrade: _openTrade,
              ),
              _VipTab.history => VipHistoryTab(
                key: const ValueKey('history'),
                snapshot: snapshot,
              ),
            },
          ),
        ],
      ),
    );
  }
}

class _VipHero extends StatelessWidget {
  const _VipHero({required this.snapshot});

  final ProfileVipSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final currentTier = snapshot.currentTier;
    return VitModuleHeroCard(
      accentColor: _ProfileVipPaneState._vipGold,
      density: VitDensity.compact,
      child: ClipRRect(
        borderRadius: AppRadii.cardLargeRadius,
        child: Stack(
          children: [
            Positioned.fill(
              child: VitHeroGlow(
                center: const Alignment(.75, -.75),
                radius: 1.2,
                colors: [
                  _ProfileVipPaneState._vipGold.withValues(alpha: .18),
                  AppColors.primary08,
                  AppColors.transparent,
                ],
                stops: const [0, .38, 1],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    _TierIcon(tier: currentTier, large: true),
                    const SizedBox(width: TabletSpacingTokens.x4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.workspace_premium_rounded,
                                color: _ProfileVipPaneState._vipGold,
                                size: ProfileSpacingTokens
                                    .profileVipHeroBadgeIcon,
                              ),
                              const SizedBox(width: TabletSpacingTokens.x4),
                              Flexible(
                                child: Text(
                                  currentTier.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.sectionTitle.copyWith(
                                    color: _ProfileVipPaneState._vipGold,
                                    fontWeight: AppTextStyles.heavy,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: TabletSpacingTokens.x4),
                          Text(
                            'Thành viên từ ${snapshot.memberSince}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.portfolioTextDim,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: TabletSpacingTokens.x4),
                    VitStatusPill(
                      label: currentTier.badge,
                      status: VitStatusPillStatus.orange,
                      outline: true,
                    ),
                  ],
                ),
                const SizedBox(height: TabletSpacingTokens.x4),
                Row(
                  children: [
                    Expanded(
                      child: _HeroFeeBox(
                        label: 'Maker fee',
                        value: _formatFee(currentTier.makerFee),
                      ),
                    ),
                    const SizedBox(width: TabletSpacingTokens.x4),
                    Expanded(
                      child: _HeroFeeBox(
                        label: 'Taker fee',
                        value: _formatFee(currentTier.takerFee),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroFeeBox extends StatelessWidget {
  const _HeroFeeBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      clip: true,
      constraints: BoxConstraints(minHeight: VitDensity.compact.controlHeight),
      borderColor: AppColors.onAccent.withValues(alpha: .12),
      background: ColoredBox(color: AppColors.onAccent.withValues(alpha: .08)),
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.portfolioTextMuted,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: _ProfileVipPaneState._vipSuccess,
              fontWeight: AppTextStyles.heavy,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _VipTabs extends StatelessWidget {
  const _VipTabs({required this.active, required this.onChanged});

  final _VipTab active;
  final ValueChanged<_VipTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.segment,
      activeKey: active.name,
      onChanged: (key) => onChanged(_VipTab.values.byName(key)),
      tabs: [
        VitTabItem(
          key: 'overview',
          label: 'Tổng quan',
          widgetKey: ProfileTabletKeys.vipTab('overview'),
        ),
        VitTabItem(
          key: 'benefits',
          label: 'Đặc quyền',
          widgetKey: ProfileTabletKeys.vipTab('benefits'),
        ),
        VitTabItem(
          key: 'history',
          label: 'Lịch sử',
          widgetKey: ProfileTabletKeys.vipTab('history'),
        ),
      ],
    );
  }
}

class _VipOverviewTab extends StatelessWidget {
  const _VipOverviewTab({super.key, required this.snapshot});

  final ProfileVipSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final nextTier = snapshot.nextTier;
    final children = <Widget>[];
    if (nextTier != null) {
      children.add(_VipProgressCard(snapshot: snapshot, nextTier: nextTier));
      children.add(const SizedBox(height: TabletSpacingTokens.cardGap));
    }
    children.add(_VipTierTable(snapshot: snapshot));
    children.add(const SizedBox(height: TabletSpacingTokens.cardGap));
    children.add(const _FeeSavingsCard());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}

class _VipProgressCard extends StatelessWidget {
  const _VipProgressCard({required this.snapshot, required this.nextTier});

  final ProfileVipSnapshot snapshot;
  final ProfileVipTier nextTier;

  @override
  Widget build(BuildContext context) {
    final volumeProgress = (snapshot.monthlyVolume / nextTier.monthlyVolume)
        .clamp(0.0, 1.0);
    final assetProgress = (snapshot.assetHold / nextTier.assetHold).clamp(
      0.0,
      1.0,
    );

    return VitCard(
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'Tiến độ lên hạng',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              const SizedBox(width: TabletSpacingTokens.x4),
              _TierIcon(tier: nextTier),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Khối lượng 30 ngày',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                  Text(
                    '${_formatUsd(snapshot.monthlyVolume)} / ${_formatUsd(nextTier.monthlyVolume)}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.heavy,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TabletSpacingTokens.x4),
              VitProgressBar(
                progress: volumeProgress,
                color: _ProfileVipPaneState._vipAccent,
                height: TabletSpacingTokens.x3,
                trackColor: AppColors.surface3,
                borderRadius: AppRadii.pillRadius,
              ),
              const SizedBox(height: TabletSpacingTokens.x4),
              Text(
                'Cần thêm ${_formatUsd(nextTier.monthlyVolume - snapshot.monthlyVolume)} để đạt mục tiêu',
                style: AppTextStyles.micro.copyWith(
                  color: _ProfileVipPaneState._vipMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Tài sản đang giữ',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                  Text(
                    '${_formatUsd(snapshot.assetHold)} / ${_formatUsd(nextTier.assetHold)}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.heavy,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TabletSpacingTokens.x4),
              VitProgressBar(
                progress: assetProgress,
                color: _ProfileVipPaneState._vipSuccess,
                height: TabletSpacingTokens.x3,
                trackColor: AppColors.surface3,
                borderRadius: AppRadii.pillRadius,
              ),
              const SizedBox(height: TabletSpacingTokens.x4),
              Text(
                '✓ Điều kiện tài sản đạt ✓',
                style: AppTextStyles.micro.copyWith(
                  color: _ProfileVipPaneState._vipSuccess,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VipTierTable extends StatelessWidget {
  const _VipTierTable({required this.snapshot});

  final ProfileVipSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      clip: true,
      density: VitDensity.compact,
      child: Column(
        children: [
          Padding(
            padding: ProfileSpacingTokens.profileVipTableTitlePadding,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'So sánh các cấp VIP',
                style: AppTextStyles.body.copyWith(
                  fontWeight: AppTextStyles.heavy,
                ),
              ),
            ),
          ),
          const Divider(
            height: TabletSpacingTokens.dividerHairline,
            color: AppColors.divider,
          ),
          const _VipTableHeader(),
          for (final tier in snapshot.tiers) ...[
            const Divider(
              height: TabletSpacingTokens.dividerHairline,
              color: AppColors.divider,
            ),
            _VipTierRow(
              tier: tier,
              active: tier.level == snapshot.currentLevel,
            ),
          ],
        ],
      ),
    );
  }
}

class _VipTableHeader extends StatelessWidget {
  const _VipTableHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ProfileSpacingTokens.profileVipTableHeaderPadding,
      child: Row(
        children: [
          _VipTableCell(flex: 28, child: Text('Cấp độ', style: _headerStyle)),
          _VipTableCell(
            flex: 26,
            child: Text('Volume/tháng', style: _headerStyle),
          ),
          _VipTableCell(flex: 22, child: Text('Maker', style: _headerStyle)),
          _VipTableCell(flex: 22, child: Text('Taker', style: _headerStyle)),
        ],
      ),
    );
  }

  TextStyle get _headerStyle => AppTextStyles.navLabel.copyWith(
    color: _ProfileVipPaneState._vipMuted,
    fontWeight: AppTextStyles.normal,
  );
}

class _VipTierRow extends StatelessWidget {
  const _VipTierRow({required this.tier, required this.active});

  final ProfileVipTier tier;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final textColor = active
        ? _ProfileVipPaneState._vipAccent
        : AppColors.text1;
    return Material(
      key: ProfileTabletKeys.vipTier(tier.level),
      color: active ? AppColors.primary08 : AppColors.transparent,
      child: Padding(
        padding: ProfileSpacingTokens.profileVipTableRowPadding,
        child: Row(
          children: [
            _VipTableCell(
              flex: 28,
              child: Row(
                children: [
                  _TierIcon(tier: tier),
                  const SizedBox(width: TabletSpacingTokens.x4),
                  Flexible(
                    child: Text(
                      tier.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: textColor,
                        fontWeight: active
                            ? AppTextStyles.heavy
                            : AppTextStyles.bold,
                      ),
                    ),
                  ),
                  if (active) ...[
                    const SizedBox(width: TabletSpacingTokens.x4),
                    const SizedBox(
                      width: ProfileSpacingTokens.profileVipActiveDot,
                      height: ProfileSpacingTokens.profileVipActiveDot,
                      child: Material(
                        color: _ProfileVipPaneState._vipAccent,
                        shape: CircleBorder(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            _VipTableCell(
              flex: 26,
              child: Text(
                tier.monthlyVolume == 0
                    ? '-'
                    : _formatCompactUsd(tier.monthlyVolume),
                style: AppTextStyles.micro.copyWith(color: AppColors.text2),
              ),
            ),
            _VipTableCell(
              flex: 22,
              child: Text(_formatFee(tier.makerFee), style: _feeStyle(active)),
            ),
            _VipTableCell(
              flex: 22,
              child: Text(_formatFee(tier.takerFee), style: _feeStyle(active)),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _feeStyle(bool active) {
    return AppTextStyles.micro.copyWith(
      color: active ? _ProfileVipPaneState._vipSuccess : AppColors.text1,
      fontWeight: AppTextStyles.heavy,
      fontFeatures: AppTextStyles.tabularFigures,
    );
  }
}

class _VipTableCell extends StatelessWidget {
  const _VipTableCell({required this.flex, required this.child});

  final int flex;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Expanded(flex: flex, child: child);
  }
}

class _FeeSavingsCard extends StatelessWidget {
  const _FeeSavingsCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: _ProfileVipPaneState._vipSuccess.withValues(alpha: .22),
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.bolt_rounded,
                color: _ProfileVipPaneState._vipSuccess,
                size: ProfileSpacingTokens.profileVipSavingsIcon,
              ),
              const SizedBox(width: TabletSpacingTokens.x4),
              Text(
                'Tiết kiệm phí của bạn',
                style: AppTextStyles.body.copyWith(
                  color: _ProfileVipPaneState._vipSuccess,
                  fontWeight: AppTextStyles.heavy,
                ),
              ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
          const Row(
            children: [
              Expanded(
                child: _SavingBox(
                  label: 'Tháng này',
                  value: '\$12.45',
                  sub: 'vs. Standard rate',
                ),
              ),
              SizedBox(width: TabletSpacingTokens.x4),
              Expanded(
                child: _SavingBox(
                  label: 'Tổng tích lũy',
                  value: '\$89.30',
                  sub: 'từ 15/08/2023',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SavingBox extends StatelessWidget {
  const _SavingBox({
    required this.label,
    required this.value,
    required this.sub,
  });

  final String label;
  final String value;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: _ProfileVipPaneState._vipMuted,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
          Text(
            value,
            style: AppTextStyles.base.copyWith(
              color: _ProfileVipPaneState._vipSuccess,
              fontWeight: AppTextStyles.heavy,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
          Text(
            sub,
            style: AppTextStyles.micro.copyWith(
              color: _ProfileVipPaneState._vipMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _BenefitsTab extends StatelessWidget {
  const _BenefitsTab({
    super.key,
    required this.snapshot,
    required this.onTrade,
  });

  final ProfileVipSnapshot snapshot;
  final VoidCallback onTrade;

  @override
  Widget build(BuildContext context) {
    final nextTier = snapshot.nextTier;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final tier in snapshot.tiers.where((tier) => tier.level > 0)) ...[
          _BenefitTierCard(
            tier: tier,
            unlocked: snapshot.currentLevel >= tier.level,
          ),
          const SizedBox(height: TabletSpacingTokens.cardGap),
        ],
        if (nextTier != null) _UpgradeCta(nextTier: nextTier, onTrade: onTrade),
      ],
    );
  }
}

class _BenefitTierCard extends StatelessWidget {
  const _BenefitTierCard({required this.tier, required this.unlocked});

  final ProfileVipTier tier;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    final accent = unlocked
        ? _ProfileVipPaneState._vipGold
        : _ProfileVipPaneState._vipProfileAccent;
    return Opacity(
      opacity: unlocked ? 1 : .68,
      child: VitCard(
        padding: TabletSpacingTokens.zeroInsets,
        borderColor: accent.withValues(alpha: unlocked ? .34 : .12),
        clip: true,
        child: Column(
          children: [
            Material(
              color: accent.withValues(alpha: unlocked ? .12 : .04),
              child: Padding(
                padding: ProfileSpacingTokens.profileVipBenefitHeaderPadding,
                child: Row(
                  children: [
                    _TierIcon(tier: tier),
                    const SizedBox(width: TabletSpacingTokens.x4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tier.name,
                            style: AppTextStyles.base.copyWith(
                              color: accent,
                              fontWeight: AppTextStyles.heavy,
                            ),
                          ),
                          const SizedBox(height: TabletSpacingTokens.x4),
                          Text(
                            'Volume >= ${_formatUsd(tier.monthlyVolume)}/tháng hoặc Tài sản >= ${_formatUsd(tier.assetHold)}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.micro.copyWith(
                              color: _ProfileVipPaneState._vipMuted,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      unlocked
                          ? Icons.check_circle_outline_rounded
                          : Icons.lock_outline_rounded,
                      color: accent,
                      size: ProfileSpacingTokens.profileVipBenefitStateIcon,
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              height: TabletSpacingTokens.dividerHairline,
              color: AppColors.divider,
            ),
            Padding(
              padding: ProfileSpacingTokens.profileVipBenefitBodyPadding,
              child: Column(
                children: [
                  for (final feature in tier.features) ...[
                    _FeatureLine(
                      text: feature,
                      accent: accent,
                      unlocked: unlocked,
                    ),
                    if (feature != tier.features.last)
                      const SizedBox(height: TabletSpacingTokens.x4),
                  ],
                  const SizedBox(height: TabletSpacingTokens.x4),
                  const Divider(
                    height: TabletSpacingTokens.dividerHairline,
                    color: AppColors.divider,
                  ),
                  const SizedBox(height: TabletSpacingTokens.x4),
                  Row(
                    children: [
                      _BenefitMetric(
                        label: 'Maker',
                        value: _formatFee(tier.makerFee),
                        active: unlocked,
                      ),
                      const SizedBox(width: TabletSpacingTokens.x4),
                      _BenefitMetric(
                        label: 'Taker',
                        value: _formatFee(tier.takerFee),
                        active: unlocked,
                      ),
                      const SizedBox(width: TabletSpacingTokens.x4),
                      Expanded(
                        child: _BenefitMetric(
                          label: 'Hạn mức rút',
                          value:
                              '${_formatCompactUsd(tier.withdrawLimit)}/ngày',
                          active: unlocked,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureLine extends StatelessWidget {
  const _FeatureLine({
    required this.text,
    required this.accent,
    required this.unlocked,
  });

  final String text;
  final Color accent;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: ProfileSpacingTokens.profileVipBenefitFeatureIconBox,
          height: ProfileSpacingTokens.profileVipBenefitFeatureIconBox,
          child: Material(
            color: accent.withValues(alpha: unlocked ? .18 : .07),
            shape: const CircleBorder(),
            child: Icon(
              Icons.check_rounded,
              color: unlocked ? accent : _ProfileVipPaneState._vipMuted,
              size: ProfileSpacingTokens.profileVipBenefitFeatureIcon,
            ),
          ),
        ),
        const SizedBox(width: TabletSpacingTokens.x4),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: unlocked
                  ? AppColors.text1
                  : _ProfileVipPaneState._vipMuted,
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}

class _BenefitMetric extends StatelessWidget {
  const _BenefitMetric({
    required this.label,
    required this.value,
    required this.active,
  });

  final String label;
  final String value;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: _ProfileVipPaneState._vipMuted,
          ),
        ),
        const SizedBox(height: TabletSpacingTokens.x4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: active ? _ProfileVipPaneState._vipSuccess : AppColors.text2,
            fontWeight: AppTextStyles.heavy,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _UpgradeCta extends StatelessWidget {
  const _UpgradeCta({required this.nextTier, required this.onTrade});

  final ProfileVipTier nextTier;
  final VoidCallback onTrade;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: _ProfileVipPaneState._vipAccent.withValues(alpha: .22),
      padding: ProfileSpacingTokens.profileVipUpgradePadding,
      child: Row(
        children: [
          const SizedBox(
            width: ProfileSpacingTokens.profileVipUpgradeIconBox,
            height: ProfileSpacingTokens.profileVipUpgradeIconBox,
            child: Material(
              color: AppColors.primary12,
              shape: RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
              child: Icon(
                Icons.workspace_premium_outlined,
                color: _ProfileVipPaneState._vipAccent,
                size: ProfileSpacingTokens.profileVipUpgradeIcon,
              ),
            ),
          ),
          const SizedBox(width: TabletSpacingTokens.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nâng cấp lên ${nextTier.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.heavy,
                  ),
                ),
                const SizedBox(height: TabletSpacingTokens.x4),
                Text(
                  'Tăng khối lượng giao dịch để tiết kiệm thêm',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
          const SizedBox(width: TabletSpacingTokens.x4),
          VitCtaButton(
            key: ProfileTabletKeys.vipTradeCta,
            onPressed: onTrade,
            fullWidth: false,
            density: VitDensity.compact,
            padding: ProfileSpacingTokens.profileVipUpgradeCtaPadding,
            child: Text(
              'Giao dịch',
              style: AppTextStyles.micro.copyWith(
                fontWeight: AppTextStyles.heavy,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TierIcon extends StatelessWidget {
  const _TierIcon({required this.tier, this.large = false});

  final ProfileVipTier tier;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final size = large
        ? ProfileSpacingTokens.profileVipTierIconLarge
        : ProfileSpacingTokens.profileVipTierIconSmall;
    final iconSize = large
        ? ProfileSpacingTokens.profileVipTierIconGlyphLarge
        : ProfileSpacingTokens.profileVipTierIconGlyphSmall;
    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: _tierAccent(tier).withValues(alpha: large ? .16 : .12),
        shape: RoundedRectangleBorder(
          borderRadius: large ? AppRadii.cardRadius : AppRadii.smRadius,
        ),
        child: Icon(
          _iconForTier(tier.iconKey),
          color: _tierAccent(tier),
          size: iconSize,
        ),
      ),
    );
  }
}

Color _tierAccent(ProfileVipTier tier) {
  if (tier.level == 0) return _ProfileVipPaneState._vipProfileAccent;
  if (tier.level >= 4) return AppColors.accent;
  return _ProfileVipPaneState._vipGold;
}

IconData _iconForTier(String key) {
  return switch (key) {
    'star' => Icons.star_rounded,
    'medal' => Icons.military_tech_rounded,
    'workspace' => Icons.workspace_premium_rounded,
    'diamond' => Icons.diamond_outlined,
    'rocket' => Icons.rocket_launch_rounded,
    _ => Icons.person_outline_rounded,
  };
}

String _formatFee(double value) {
  if (value == 0) return '0%';
  return VitFormat.percent(value);
}

String _formatUsd(double value) => VitFormat.usd(value);

String _formatCompactUsd(double value) =>
    VitFormat.compactSuffix(value, prefix: '\$', stripTrailingZero: true);
