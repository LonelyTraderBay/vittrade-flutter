import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/widgets/wallet_tablet_detail_surface.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Independent Tablet composition for wallet multi-manager SC-148.
class WalletMultiManagerTabletPage extends ConsumerStatefulWidget {
  const WalletMultiManagerTabletPage({super.key});

  static const contentKey = Key('sc148_multi_manager_tablet_content');
  static const addWalletKey = Key('sc148_multi_manager_add_wallet_tablet');
  static const addWalletNoticeKey = Key(
    'sc148_multi_manager_add_wallet_notice_tablet',
  );
  static Key tabKey(String label) =>
      Key('sc148_multi_manager_tab_tablet_$label');
  static Key walletKey(String id) =>
      Key('sc148_multi_manager_wallet_tablet_$id');
  static Key revealKey(String id) =>
      Key('sc148_multi_manager_reveal_tablet_$id');
  static Key copyKey(String id) => Key('sc148_multi_manager_copy_tablet_$id');

  @override
  ConsumerState<WalletMultiManagerTabletPage> createState() =>
      _WalletMultiManagerTabletPageState();
}

class _WalletMultiManagerTabletPageState
    extends ConsumerState<WalletMultiManagerTabletPage> {
  static const _all = 'all';
  static const _groups = 'groups';
  static const _activity = 'activity';

  String _tab = _all;
  String _selectedWalletId = 'w1';
  final Set<String> _revealedWalletIds = <String>{};
  String? _notice;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(walletMultiManagerProvider);
    return snapshotAsync.when(
      loading: () => _frame(
        primary: const VitSkeletonList(),
        secondary: const SizedBox.shrink(),
      ),
      error: (error, stackTrace) => _frame(
        primary: VitErrorState(
          title: 'Không tải được dữ liệu đa ví',
          message: 'Vui lòng kiểm tra kết nối và thử lại.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(walletMultiManagerProvider),
        ),
        secondary: const SizedBox.shrink(),
      ),
      data: (snapshot) => _frame(
        primary: _buildPrimary(snapshot),
        secondary: _buildSecondary(snapshot),
      ),
    );
  }

  Widget _frame({required Widget primary, required Widget secondary}) {
    return WalletTabletDetailSurface(
      semanticLabel: 'Quản lý đa ví trên tablet',
      semanticIdentifier: 'SC-148-TABLET',
      title: 'Quản lý đa ví',
      subtitle: 'Tài sản, nhóm ví và hoạt động',
      onBack: () => context.go(AppRoutePaths.wallet),
      primary: primary,
      secondary: secondary,
    );
  }

  Widget _buildPrimary(WalletMultiManagerSnapshot snapshot) {
    return Column(
      key: WalletMultiManagerTabletPage.contentKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          variant: VitCardVariant.hero,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tổng giá trị danh mục'),
                    const SizedBox(height: TabletSpacingTokens.x4),
                    Text(
                      VitFormat.usd(snapshot.totalBalance),
                      style: AppTextStyles.heroNumber.copyWith(
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
              VitMetricDeltaPill(
                label: VitFormat.signedPercent(
                  snapshot.totalChangePct,
                  fractionDigits: 2,
                ),
                tone: snapshot.totalChangePct >= 0
                    ? VitMetricDeltaTone.positive
                    : VitMetricDeltaTone.negative,
              ),
            ],
          ),
        ),
        VitPageSection(
          innerGap: TabletSpacingTokens.x4,
          label: 'Danh sách quản lý',
          headerIcon: Icons.account_balance_wallet_outlined,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.standard,
          children: [
            VitTabBar(
              tabs: const [
                VitTabItem(key: _all, label: 'Tất cả'),
                VitTabItem(key: _groups, label: 'Nhóm'),
                VitTabItem(key: _activity, label: 'Hoạt động'),
              ],
              activeKey: _tab,
              onChanged: (tab) => setState(() => _tab = tab),
              variant: VitTabBarVariant.pill,
            ),
          ],
        ),
        _tab == _groups
            ? _buildGroups(snapshot)
            : _tab == _activity
            ? _buildActivity(snapshot)
            : _buildWallets(snapshot),
      ],
    );
  }

  Widget _buildWallets(WalletMultiManagerSnapshot snapshot) {
    return VitPageSection(
      innerGap: TabletSpacingTokens.x4,
      label: 'Tất cả ví',
      headerIcon: Icons.wallet_outlined,
      headerIconColor: AppColors.primary,
      headerVariant: VitSectionHeaderVariant.plain,
      accentColor: AppColors.primary,
      rhythm: VitPageRhythm.standard,
      children: [for (final wallet in snapshot.wallets) _walletCard(wallet)],
    );
  }

  Widget _walletCard(WalletManagerItem wallet) {
    final revealed = _revealedWalletIds.contains(wallet.id);
    return VitCard(
      key: WalletMultiManagerTabletPage.walletKey(wallet.id),
      variant: VitCardVariant.inner,
      onTap: () => setState(() => _selectedWalletId = wallet.id),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VitAssetAvatar(
            label: wallet.name,
            accentColor: Color(wallet.accentColorHex),
            size: TabletSpacingTokens.iconLg,
          ),
          const SizedBox(width: TabletSpacingTokens.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(wallet.name)),
                    Text(
                      VitFormat.usd(wallet.balanceUsd),
                      style: AppTextStyles.baseMedium.copyWith(
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TabletSpacingTokens.x4),
                Text(
                  '${wallet.type} · ${VitFormat.signedPercent(wallet.change24hPct, fractionDigits: 2)}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: TabletSpacingTokens.x4),
                Text(
                  revealed ? wallet.address : wallet.maskedAddress,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: TabletSpacingTokens.x4),
          Column(
            children: [
              IconButton(
                key: WalletMultiManagerTabletPage.revealKey(wallet.id),
                tooltip: revealed
                    ? 'Ẩn địa chỉ ${wallet.name}'
                    : 'Hiện địa chỉ ${wallet.name}',
                onPressed: () => setState(() {
                  if (revealed) {
                    _revealedWalletIds.remove(wallet.id);
                  } else {
                    _revealedWalletIds.add(wallet.id);
                  }
                }),
                icon: Icon(
                  revealed
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
              IconButton(
                key: WalletMultiManagerTabletPage.copyKey(wallet.id),
                tooltip: 'Sao chép địa chỉ ${wallet.name}',
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: wallet.address));
                  if (!mounted) return;
                  setState(
                    () => _notice = 'Đã sao chép địa chỉ ${wallet.name}.',
                  );
                },
                icon: const Icon(Icons.copy_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGroups(WalletMultiManagerSnapshot snapshot) {
    return VitPageSection(
      innerGap: TabletSpacingTokens.x4,
      label: 'Nhóm ví',
      headerIcon: Icons.folder_copy_outlined,
      headerIconColor: AppColors.primary,
      headerVariant: VitSectionHeaderVariant.plain,
      accentColor: AppColors.primary,
      rhythm: VitPageRhythm.standard,
      children: [
        for (final group in snapshot.groups)
          VitCard(
            variant: VitCardVariant.inner,
            child: VitInfoRow(
              label: group.name,
              value: VitFormat.usd(group.totalValueUsd),
              leading: VitAssetAvatar(
                label: group.name,
                accentColor: Color(group.colorHex),
                size: TabletSpacingTokens.iconLg,
              ),
              density: VitDensity.compact,
              showDivider: false,
            ),
          ),
      ],
    );
  }

  Widget _buildActivity(WalletMultiManagerSnapshot snapshot) {
    return const VitPageSection(
      innerGap: TabletSpacingTokens.x4,
      label: 'Hoạt động gần đây',
      headerIcon: Icons.history_rounded,
      headerIconColor: AppColors.primary,
      headerVariant: VitSectionHeaderVariant.plain,
      accentColor: AppColors.primary,
      rhythm: VitPageRhythm.standard,
      children: [
        VitCard(
          variant: VitCardVariant.inner,
          child: VitEmptyState(
            title: 'Hoạt động ví được bảo vệ',
            message:
                'Các thao tác quản lý sẽ hiển thị cùng thời điểm và ví liên quan.',
            icon: Icons.security_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildSecondary(WalletMultiManagerSnapshot snapshot) {
    final selected = snapshot.wallets.firstWhere(
      (wallet) => wallet.id == _selectedWalletId,
      orElse: () => snapshot.wallets.first,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitHighRiskStatePanel(
          state: VitHighRiskUiState.riskReview,
          title: 'Bảo mật địa chỉ ví',
          message:
              'Chỉ hiện hoặc sao chép địa chỉ khi bạn tin tưởng đích đến và bước tiếp theo.',
          contractId: 'Quản lý đa ví',
          density: VitDensity.compact,
        ),
        VitPageSection(
          innerGap: TabletSpacingTokens.x4,
          label: 'Ví đang chọn',
          headerIcon: Icons.account_balance_outlined,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.standard,
          children: [
            VitCard(
              variant: VitCardVariant.inner,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(selected.name, style: AppTextStyles.sectionTitle),
                  const SizedBox(height: TabletSpacingTokens.x4),
                  Text(
                    '${selected.lastActiveLabel} · ${selected.assets.length} tài sản',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                  const SizedBox(height: TabletSpacingTokens.x4),
                  for (var i = 0; i < selected.assets.length; i++)
                    VitInfoRow(
                      label: selected.assets[i].symbol,
                      value: VitFormat.usd(selected.assets[i].valueUsd),
                      density: VitDensity.compact,
                      showDivider: i != selected.assets.length - 1,
                    ),
                ],
              ),
            ),
          ],
        ),
        VitCtaButton(
          key: WalletMultiManagerTabletPage.addWalletKey,
          onPressed: () => setState(() => _notice = 'Chưa kết nối tạo ví mới.'),
          variant: VitCtaButtonVariant.secondary,
          leading: const Icon(Icons.add_rounded),
          child: const Text('Thêm ví'),
        ),
        if (_notice != null)
          VitStatusPill(
            key: WalletMultiManagerTabletPage.addWalletNoticeKey,
            label: _notice!,
            status: VitStatusPillStatus.info,
            icon: Icons.info_outline_rounded,
            size: VitStatusPillSize.sm,
          ),
      ],
    );
  }
}
