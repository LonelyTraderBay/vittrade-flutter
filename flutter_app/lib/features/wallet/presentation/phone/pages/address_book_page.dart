import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/core/utils/data_masking.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_page_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

part '../../widgets/address/wallet_address_book_controls.dart';
part '../../widgets/address/wallet_address_book_security.dart';
part '../../widgets/address/wallet_address_book_list.dart';

double _bookScrollBottomInset(BuildContext context, ShellRenderMode mode) {
  return (mode.usesVisualQaFrame
          ? WalletSpacingTokens.walletVisualChromePad
          : WalletSpacingTokens.walletNativeChromePad) +
      MediaQuery.paddingOf(context).bottom;
}

String _maskAddress(String address) => maskAddress(address);

class AddressBookPage extends ConsumerStatefulWidget {
  const AddressBookPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc144_address_book_content');
  static const searchKey = Key('sc144_address_book_search');
  static const addKey = Key('sc144_address_book_add');
  static const whitelistModeKey = Key('sc144_address_book_whitelist_mode');
  static Key filterKey(String filter) =>
      Key('sc144_address_book_filter_$filter');
  static Key copyKey(String id) => Key('sc144_address_book_copy_$id');
  static Key favoriteKey(String id) => Key('sc144_address_book_favorite_$id');
  static Key editKey(String id) => Key('sc144_address_book_edit_$id');
  static Key deleteKey(String id) => Key('sc144_address_book_delete_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AddressBookPage> createState() => _AddressBookPageState();
}

class _AddressBookPageState extends ConsumerState<AddressBookPage> {
  // STATE-S23: addresses sống ở AddressBookStateController (một nguồn sự
  // thật) — hết `late List` seed từ ref.read + setState.
  final TextEditingController _searchController = TextEditingController();
  String _networkFilter = 'Tất cả';
  String? _copiedId;
  bool _whitelistOnly = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addressBookAsync = ref.watch(walletAddressBookProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset = _bookScrollBottomInset(context, mode);

    return VitAutoHidePageScaffold(
      semanticLabel: 'Sổ địa chỉ - quản lý địa chỉ ví đã lưu',
      semanticIdentifier: 'SC-144',
      header: VitHeader(
        title: 'Sổ địa chỉ',
        subtitle: 'Quản lý · Wallet',
        showBack: true,
        onBack: () => context.go(AppRoutePaths.wallet),
        actions: [
          VitHeaderActionItem(
            key: AddressBookPage.addKey,
            type: VitHeaderActionType.add,
            tooltip: 'Thêm địa chỉ',
            onPressed: () => context.go(AppRoutePaths.walletAddressBookAdd),
          ),
        ],
      ),
      body: VitInsetScrollView(
        key: AddressBookPage.contentKey,
        bottomInset: bottomInset,
        child: VitPageContent(
          rhythm: VitPageRhythm.standard,
          padding: VitContentPadding.compact,
          density: VitDensity.compact,
          gap: VitContentGap.tight,
          children: [
            ...addressBookAsync.when(
              loading: () => const [VitSkeletonList()],
              error: (error, stackTrace) => [
                VitErrorState(
                  title: 'Không tải được sổ địa chỉ',
                  message: 'Vui lòng kiểm tra kết nối và thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () => ref.invalidate(walletAddressBookProvider),
                ),
              ],
              data: (snapshot) {
                final viewState = ref.watch(addressBookStateControllerProvider);
                final filtered = _filteredAddresses(viewState.addresses);
                final favorites = filtered
                    .where((address) => address.isFavorite)
                    .toList();
                final others = filtered
                    .where((address) => !address.isFavorite)
                    .toList();
                return [
                  _WhitelistModeCard(
                    enabled: _whitelistOnly,
                    onTap: () =>
                        setState(() => _whitelistOnly = !_whitelistOnly),
                  ),
                  _AddressStats(addresses: viewState.addresses),
                  _SearchBox(
                    controller: _searchController,
                    onChanged: () => setState(() {}),
                  ),
                  _NetworkFilterBar(
                    filters: snapshot.networkFilters,
                    active: _networkFilter,
                    onChanged: (filter) =>
                        setState(() => _networkFilter = filter),
                  ),
                  if (favorites.isNotEmpty)
                    VitPageSection(
                      label: 'Yêu thích',
                      headerIcon: Icons.star_rounded,
                      headerIconColor: AppColors.caution,
                      accentColor: AppColors.caution,
                      headerVariant: VitSectionHeaderVariant.plain,
                      headerDensity: VitDensity.compact,
                      innerGap: AppSpacing.pageRhythmStandardInnerGap,
                      children: [
                        for (final address in favorites)
                          _AddressCard(
                            address: address,
                            copied: _copiedId == address.id,
                            onCopy: () => _copyAddress(address),
                            onFavorite: () => _toggleFavorite(address.id),
                            onEdit: () => _showActionNotice(
                              'Chỉnh sửa địa chỉ sẽ mở trong bước kế tiếp',
                            ),
                            onDelete: () => unawaited(_confirmDelete(address)),
                          ),
                      ],
                    ),
                  if (others.isNotEmpty)
                    VitPageSection(
                      label: 'Tất cả địa chỉ',
                      headerIcon: Icons.list_alt_rounded,
                      headerVariant: VitSectionHeaderVariant.plain,
                      headerDensity: VitDensity.compact,
                      innerGap: AppSpacing.pageRhythmStandardInnerGap,
                      children: [
                        for (final address in others)
                          _AddressCard(
                            address: address,
                            copied: _copiedId == address.id,
                            onCopy: () => _copyAddress(address),
                            onFavorite: () => _toggleFavorite(address.id),
                            onEdit: () => _showActionNotice(
                              'Chỉnh sửa địa chỉ sẽ mở trong bước kế tiếp',
                            ),
                            onDelete: () => unawaited(_confirmDelete(address)),
                          ),
                      ],
                    ),
                  if (filtered.isEmpty)
                    _EmptyAddressState(
                      onAdd: () =>
                          context.go(AppRoutePaths.walletAddressBookAdd),
                    ),
                  const VitPageSection(
                    label: 'B\u1EA3o m\u1EADt \u0111\u1ECBa ch\u1EC9',
                    headerIcon: Icons.shield_outlined,
                    headerIconColor: AppColors.primary,
                    innerGap: AppSpacing.pageRhythmStandardInnerGap,
                    children: [_SecurityTip()],
                  ),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }

  List<WalletSavedAddress> _filteredAddresses(
    List<WalletSavedAddress> addresses,
  ) {
    final query = _searchController.text.trim().toLowerCase();
    return addresses.where((address) {
      final matchesNetwork =
          _networkFilter == 'Tất cả' || address.network == _networkFilter;
      final matchesSearch =
          query.isEmpty ||
          address.label.toLowerCase().contains(query) ||
          address.address.toLowerCase().contains(query);
      final matchesWhitelist = !_whitelistOnly || address.isWhitelisted;
      return matchesNetwork && matchesSearch && matchesWhitelist;
    }).toList();
  }

  Future<void> _copyAddress(WalletSavedAddress address) async {
    await Clipboard.setData(ClipboardData(text: address.address));
    if (!mounted) return;
    setState(() => _copiedId = address.id);
  }

  void _toggleFavorite(String addressId) {
    ref
        .read(addressBookStateControllerProvider.notifier)
        .toggleFavorite(addressId);
  }

  void _showActionNotice(String message) {
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Thông báo',
        message: message,
      ),
    );
  }

  Future<void> _confirmDelete(WalletSavedAddress address) async {
    final confirmed = await showVitConfirmDialog(
      context: context,
      title: 'Xóa địa chỉ',
      message:
          'Bạn có chắc muốn xóa địa chỉ "${address.label}" '
          '(${_maskAddress(address.address)})?',
      confirmLabel: 'Xóa',
      confirmVariant: VitCtaButtonVariant.destructive,
    );
    if (!confirmed || !mounted) return;
    ref
        .read(addressBookStateControllerProvider.notifier)
        .deleteAddress(address.id);
    await showVitNoticeSheet(
      context: context,
      title: 'Đã xóa địa chỉ',
      message: 'Đã xóa "${address.label}" khỏi sổ địa chỉ.',
      variant: VitBannerVariant.success,
      ctaVariant: VitCtaButtonVariant.success,
    );
  }
}
