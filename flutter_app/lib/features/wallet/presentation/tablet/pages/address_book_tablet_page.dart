import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/utils/data_masking.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/widgets/wallet_tablet_detail_surface.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

/// Independent Tablet composition for the wallet address book SC-144.
class AddressBookTabletPage extends ConsumerStatefulWidget {
  const AddressBookTabletPage({super.key});

  static const contentKey = Key('sc144_address_book_tablet_content');
  static const searchKey = Key('sc144_address_book_search');
  static const addKey = Key('sc144_address_book_add');
  static const whitelistModeKey = Key('sc144_address_book_whitelist_mode');
  static Key filterKey(String filter) =>
      Key('sc144_address_book_filter_$filter');
  static Key copyKey(String id) => Key('sc144_address_book_copy_$id');
  static Key favoriteKey(String id) => Key('sc144_address_book_favorite_$id');
  static Key editKey(String id) => Key('sc144_address_book_edit_$id');
  static Key deleteKey(String id) => Key('sc144_address_book_delete_$id');

  @override
  ConsumerState<AddressBookTabletPage> createState() =>
      _AddressBookTabletPageState();
}

class _AddressBookTabletPageState extends ConsumerState<AddressBookTabletPage> {
  final TextEditingController _searchController = TextEditingController();
  String _networkFilter = 'Tất cả';
  bool _whitelistOnly = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addressBookAsync = ref.watch(walletAddressBookProvider);

    return addressBookAsync.when(
      loading: () => _frame(
        primary: const VitSkeletonList(),
        secondary: const SizedBox.shrink(),
      ),
      error: (error, stackTrace) => _frame(
        primary: VitErrorState(
          title: 'Không tải được sổ địa chỉ',
          message: 'Vui lòng kiểm tra kết nối và thử lại.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(walletAddressBookProvider),
        ),
        secondary: const SizedBox.shrink(),
      ),
      data: (snapshot) {
        final viewState = ref.watch(addressBookStateControllerProvider);
        final filtered = _filteredAddresses(viewState.addresses);
        final favorites = filtered
            .where((address) => address.isFavorite)
            .toList(growable: false);
        final others = filtered
            .where((address) => !address.isFavorite)
            .toList(growable: false);

        return _frame(
          primary: _buildPrimary(snapshot, viewState.addresses, favorites),
          secondary: _buildSecondary(others, filtered.isEmpty),
        );
      },
    );
  }

  Widget _frame({required Widget primary, required Widget secondary}) {
    return WalletTabletDetailSurface(
      semanticLabel: 'Sổ địa chỉ trên tablet',
      semanticIdentifier: 'SC-144-TABLET',
      title: 'Sổ địa chỉ',
      subtitle: 'Quản lý địa chỉ ví · Ví',
      onBack: () => context.go(AppRoutePaths.wallet),
      primary: primary,
      secondary: secondary,
    );
  }

  Widget _buildPrimary(
    WalletAddressBookSnapshot snapshot,
    List<WalletSavedAddress> allAddresses,
    List<WalletSavedAddress> favorites,
  ) {
    return Column(
      key: AddressBookTabletPage.contentKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: VitCtaButton(
            key: AddressBookTabletPage.addKey,
            fullWidth: false,
            leading: const Icon(Icons.add_rounded),
            onPressed: () => context.go(AppRoutePaths.walletAddressBookAdd),
            child: const Text('Thêm địa chỉ'),
          ),
        ),
        VitPageSection(
          innerGap: TabletSpacingTokens.x4,
          label: 'Tổng quan',
          headerIcon: Icons.analytics_outlined,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.standard,
          children: [
            _StatsRow(addresses: allAddresses),
            VitCard(
              key: AddressBookTabletPage.whitelistModeKey,
              variant: VitCardVariant.inner,
              onTap: () => setState(() => _whitelistOnly = !_whitelistOnly),
              child: Row(
                children: [
                  Icon(
                    Icons.verified_user_outlined,
                    color: _whitelistOnly ? AppColors.buy : AppColors.text2,
                  ),
                  const SizedBox(width: TabletSpacingTokens.x4),
                  const Expanded(
                    child: Text('Chỉ hiển thị địa chỉ trong danh sách trắng'),
                  ),
                  VitStatusPill(
                    label: _whitelistOnly ? 'Đang bật' : 'Tất cả',
                    status: _whitelistOnly
                        ? VitStatusPillStatus.success
                        : VitStatusPillStatus.neutral,
                    size: VitStatusPillSize.sm,
                  ),
                ],
              ),
            ),
          ],
        ),
        VitPageSection(
          innerGap: TabletSpacingTokens.x4,
          label: 'Bộ lọc',
          headerIcon: Icons.filter_alt_outlined,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.standard,
          children: [
            VitSearchBar(
              fieldKey: AddressBookTabletPage.searchKey,
              controller: _searchController,
              placeholder: 'Tìm địa chỉ hoặc tên...',
              variant: VitSearchBarVariant.compact,
              onChanged: (_) => setState(() {}),
            ),
            _NetworkFilters(
              filters: snapshot.networkFilters,
              active: _networkFilter,
              onChanged: (filter) => setState(() => _networkFilter = filter),
            ),
          ],
        ),
        if (favorites.isNotEmpty)
          _AddressSection(
            title: 'Yêu thích',
            icon: Icons.star_rounded,
            color: AppColors.caution,
            addresses: favorites,
          ),
      ],
    );
  }

  Widget _buildSecondary(List<WalletSavedAddress> others, bool isEmpty) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (others.isNotEmpty)
          _AddressSection(
            title: 'Tất cả địa chỉ',
            icon: Icons.list_alt_rounded,
            color: AppColors.primary,
            addresses: others,
          )
        else if (isEmpty)
          VitEmptyState(
            title: 'Không tìm thấy địa chỉ',
            message: 'Thêm địa chỉ đã xác minh để rút tiền nhanh hơn.',
            icon: Icons.shield_outlined,
            actionLabel: 'Thêm địa chỉ',
            onAction: () => context.go(AppRoutePaths.walletAddressBookAdd),
          ),
        const VitPageSection(
          innerGap: TabletSpacingTokens.x4,
          label: 'Bảo mật địa chỉ',
          headerIcon: Icons.shield_outlined,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          children: [
            VitBanner(
              variant: VitBannerVariant.info,
              message:
                  'Chỉ lưu địa chỉ đã kiểm tra. Địa chỉ trong danh sách trắng giúp giảm rủi ro gửi nhầm.',
              icon: Icons.security_outlined,
            ),
          ],
        ),
      ],
    );
  }

  List<WalletSavedAddress> _filteredAddresses(
    List<WalletSavedAddress> addresses,
  ) {
    final query = _searchController.text.trim().toLowerCase();
    return addresses
        .where((address) {
          final matchesNetwork =
              _networkFilter == 'Tất cả' || address.network == _networkFilter;
          final matchesSearch =
              query.isEmpty ||
              address.label.toLowerCase().contains(query) ||
              address.address.toLowerCase().contains(query);
          final matchesWhitelist = !_whitelistOnly || address.isWhitelisted;
          return matchesNetwork && matchesSearch && matchesWhitelist;
        })
        .toList(growable: false);
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.addresses});

  final List<WalletSavedAddress> addresses;

  @override
  Widget build(BuildContext context) {
    final stats = [
      (addresses.length.toString(), 'Tổng địa chỉ', AppColors.primary),
      (
        addresses.where((address) => address.isFavorite).length.toString(),
        'Yêu thích',
        AppColors.caution,
      ),
      (
        addresses.where((address) => address.isWhitelisted).length.toString(),
        'Danh sách trắng',
        AppColors.buy,
      ),
    ];
    return Row(
      children: [
        for (var i = 0; i < stats.length; i++) ...[
          Expanded(
            child: VitCard(
              variant: VitCardVariant.inner,
              density: VitDensity.compact,
              child: Column(
                children: [
                  Text(
                    stats[i].$1,
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: stats[i].$3,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  const SizedBox(height: TabletSpacingTokens.x4),
                  Text(
                    stats[i].$2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
          ),
          if (i != stats.length - 1)
            const SizedBox(width: TabletSpacingTokens.x4),
        ],
      ],
    );
  }
}

class _NetworkFilters extends StatelessWidget {
  const _NetworkFilters({
    required this.filters,
    required this.active,
    required this.onChanged,
  });

  final List<String> filters;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: WalletSpacingTokens.walletAddressFilterHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, _) =>
            const SizedBox(width: TabletSpacingTokens.x4),
        itemBuilder: (context, index) {
          final filter = filters[index];
          return VitChoicePill(
            key: AddressBookTabletPage.filterKey(filter),
            label: filter,
            selected: filter == active,
            onTap: () => onChanged(filter),
            height: WalletSpacingTokens.walletAddressFilterHeight,
            accentColor: AppColors.primary,
          );
        },
      ),
    );
  }
}

class _AddressSection extends ConsumerWidget {
  const _AddressSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.addresses,
  });

  final String title;
  final IconData icon;
  final Color color;
  final List<WalletSavedAddress> addresses;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return VitPageSection(
      innerGap: TabletSpacingTokens.x4,
      label: title,
      headerIcon: icon,
      headerIconColor: color,
      accentColor: color,
      headerVariant: VitSectionHeaderVariant.plain,
      rhythm: VitPageRhythm.standard,
      children: [
        for (final address in addresses)
          _AddressTabletCard(address: address, ref: ref),
      ],
    );
  }
}

class _AddressTabletCard extends StatelessWidget {
  const _AddressTabletCard({required this.address, required this.ref});

  final WalletSavedAddress address;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    // Phone-anatomy layout (proven at 330px on the phone card): content row
    // with the whitelist pill inline beside the label in a WIDE row, then a
    // full-width action row below. The previous side-by-side shape (actions
    // in a fixed right column) left the left column ~17px narrower than the
    // pill at the 1024-wide two-column tier — caught by the responsive QA
    // matrix's 1024x768 viewport (2026-08-23).
    return VitCard(
      density: VitDensity.compact,
      borderColor: AppColors.overlayStroke,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.shield_outlined,
                color: address.isWhitelisted ? AppColors.buy : AppColors.text3,
              ),
              const SizedBox(width: TabletSpacingTokens.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            address.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.baseMedium.copyWith(
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        if (address.isWhitelisted) ...[
                          const SizedBox(width: TabletSpacingTokens.x4),
                          const VitStatusPill(
                            label: 'Danh sách trắng',
                            icon: Icons.check_rounded,
                            status: VitStatusPillStatus.success,
                            size: VitStatusPillSize.sm,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: TabletSpacingTokens.x4),
                    Text(
                      '${address.network} · ${address.asset}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    const SizedBox(height: TabletSpacingTokens.x4),
                    Text(
                      maskAddress(address.address),
                      style: AppTextStyles.numericMicro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
          Row(
            children: [
              VitChoicePill(
                key: AddressBookTabletPage.copyKey(address.id),
                label: 'Sao chép',
                selected: false,
                onTap: () async {
                  await Clipboard.setData(ClipboardData(text: address.address));
                  if (context.mounted) {
                    unawaited(
                      showVitNoticeSheet(
                        context: context,
                        title: 'Đã sao chép',
                        message: 'Địa chỉ ví đã được sao chép an toàn.',
                      ),
                    );
                  }
                },
                height: WalletSpacingTokens.walletAddressCopyHeight,
                accentColor: AppColors.primary,
              ),
              const Spacer(),
              VitIconButton(
                key: AddressBookTabletPage.favoriteKey(address.id),
                icon: address.isFavorite
                    ? Icons.star_rounded
                    : Icons.star_outline_rounded,
                tooltip: 'Yêu thích địa chỉ',
                onPressed: () => ref
                    .read(addressBookStateControllerProvider.notifier)
                    .toggleFavorite(address.id),
                size: VitIconButtonSize.md,
                variant: address.isFavorite
                    ? VitIconButtonVariant.primary
                    : VitIconButtonVariant.ghost,
              ),
              const SizedBox(width: TabletSpacingTokens.x4),
              VitIconButton(
                key: AddressBookTabletPage.editKey(address.id),
                icon: Icons.edit_rounded,
                tooltip: 'Sửa địa chỉ',
                onPressed: () => showVitNoticeSheet(
                  context: context,
                  title: 'Thông báo',
                  message: 'Chỉnh sửa địa chỉ sẽ mở trong bước kế tiếp.',
                ),
                size: VitIconButtonSize.md,
                variant: VitIconButtonVariant.ghost,
              ),
              const SizedBox(width: TabletSpacingTokens.x4),
              VitIconButton(
                key: AddressBookTabletPage.deleteKey(address.id),
                icon: Icons.delete_outline_rounded,
                tooltip: 'Xóa địa chỉ',
                onPressed: () => _delete(context, ref, address),
                size: VitIconButtonSize.md,
                variant: VitIconButtonVariant.danger,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    WalletSavedAddress address,
  ) async {
    final confirmed = await showVitConfirmDialog(
      context: context,
      title: 'Xóa địa chỉ',
      message: 'Bạn có chắc muốn xóa "${address.label}" không?',
      confirmLabel: 'Xóa',
      confirmVariant: VitCtaButtonVariant.destructive,
    );
    if (!confirmed || !context.mounted) return;
    ref
        .read(addressBookStateControllerProvider.notifier)
        .deleteAddress(address.id);
  }
}
