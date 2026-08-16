import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';
part '../../../widgets/tools/launchpad_address_book_controls.dart';
part '../../../widgets/tools/launchpad_address_book_cards.dart';
part '../../../widgets/tools/launchpad_address_book_sheet_common.dart';

class LaunchpadAddressBookPage extends ConsumerStatefulWidget {
  const LaunchpadAddressBookPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc309_launchpad_address_book_content');
  static const searchKey = Key('sc309_launchpad_address_book_search');
  static const addKey = Key('sc309_launchpad_address_book_add');
  static const statsKey = Key('sc309_launchpad_address_book_stats');
  static const favoritesKey = Key('sc309_launchpad_address_book_favorites');
  static const allKey = Key('sc309_launchpad_address_book_all');
  static const emptyKey = Key('sc309_launchpad_address_book_empty');
  static const addSheetKey = Key('sc309_launchpad_address_book_add_sheet');
  static const addSheetCloseKey = Key(
    'sc309_launchpad_address_book_add_sheet_close',
  );
  static const infoKey = Key('sc309_launchpad_address_book_info');

  static Key filterKey(String chain) =>
      Key('sc309_launchpad_address_book_filter_$chain');
  static Key cardKey(String id) => Key('sc309_launchpad_address_book_card_$id');
  static Key copyKey(String id) => Key('sc309_launchpad_address_book_copy_$id');
  static Key favoriteKey(String id) =>
      Key('sc309_launchpad_address_book_favorite_$id');
  static Key expandKey(String id) =>
      Key('sc309_launchpad_address_book_expand_$id');
  static Key defaultKey(String id) =>
      Key('sc309_launchpad_address_book_default_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadAddressBookPage> createState() =>
      _LaunchpadAddressBookPageState();
}

class _LaunchpadAddressBookPageState
    extends ConsumerState<LaunchpadAddressBookPage> {
  // STATE-S23: addresses sống ở LaunchpadAddressBookStateController (một
  // nguồn sự thật) — hết `late List` seed từ ref.read + setState.
  final _searchController = TextEditingController();
  var _chainFilter = 'all';
  var _searchQuery = '';
  var _showAddSheet = false;
  String? _expandedId;
  String? _copiedId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addressBookAsync = ref.watch(launchpadAddressBookSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollTailReserve =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x3
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x3) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Sổ địa chỉ ví đáng tin cậy trong Launchpad',
      semanticIdentifier: 'SC-309',
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            VitAutoHideHeaderScaffold(
              bottomInset: scrollTailReserve,
              semanticLabel: 'Sổ địa chỉ ví đáng tin cậy trong Launchpad',
              semanticIdentifier: 'SC-309',
              header: VitHeader(
                title: 'So dia chi',
                subtitle: 'Sổ địa chỉ tin cậy · Xác minh trước khi gửi',
                showBack: true,
                onBack: () => context.go(AppRoutePaths.launchpad),
                actions: [
                  VitHeaderActionItem(
                    key: LaunchpadAddressBookPage.addKey,
                    type: VitHeaderActionType.add,
                    onPressed: () => setState(() => _showAddSheet = true),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                key: LaunchpadAddressBookPage.contentKey,
                physics: const ClampingScrollPhysics(),
                child: VitPageContent(
                  rhythm: VitPageRhythm.standard,
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.tight,
                  children: [
                    ...addressBookAsync.when(
                      loading: () => const [VitSkeletonList()],
                      error: (error, stackTrace) => [
                        VitErrorState(
                          title: 'Không tải được sổ địa chỉ',
                          message: 'Vui lòng kiểm tra kết nối và thử lại.',
                          actionLabel: 'Thử lại',
                          onAction: () => ref.invalidate(
                            launchpadAddressBookSnapshotProvider,
                          ),
                        ),
                      ],
                      data: (snapshot) {
                        final viewState = ref.watch(
                          launchpadAddressBookStateControllerProvider,
                        );
                        final filtered = _filteredAddresses(
                          viewState.addresses,
                        );
                        final favorites = filtered
                            .where((address) => address.isFavorite)
                            .toList();
                        final others = filtered
                            .where((address) => !address.isFavorite)
                            .toList();
                        return [
                          _SearchField(
                            controller: _searchController,
                            query: _searchQuery,
                            onChanged: (value) =>
                                setState(() => _searchQuery = value),
                            onClear: () => setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            }),
                          ),
                          _ChainFilters(
                            filters: snapshot.chainFilters,
                            activeFilter: _chainFilter,
                            onChanged: (value) =>
                                setState(() => _chainFilter = value),
                          ),
                          _AddressStats(addresses: viewState.addresses),
                          if (filtered.isEmpty)
                            const VitEmptyState(
                              key: LaunchpadAddressBookPage.emptyKey,
                              title: 'Khong tim thay dia chi',
                              message:
                                  'Thu doi tu khoa tim kiem hoac chon tat ca chain de tiep tuc.',
                              icon: Icons.search_off_rounded,
                            ),
                          if (favorites.isNotEmpty)
                            VitPageSection(
                              key: LaunchpadAddressBookPage.favoritesKey,
                              label: 'Yeu thich',
                              accentColor: AppColors.warn,
                              children: [
                                for (final address in favorites)
                                  _AddressCard(
                                    address: address,
                                    expanded: _expandedId == address.id,
                                    copied: _copiedId == address.id,
                                    onCopy: () => _copyAddress(address),
                                    onFavorite: () =>
                                        _toggleFavorite(address.id),
                                    onDefault: () => _setDefault(address.id),
                                    onExpand: () => setState(() {
                                      _expandedId = _expandedId == address.id
                                          ? null
                                          : address.id;
                                    }),
                                  ),
                              ],
                            ),
                          if (others.isNotEmpty)
                            VitPageSection(
                              key: LaunchpadAddressBookPage.allKey,
                              label: 'Tat ca dia chi',
                              accentColor: AppModuleAccents.launchpad,
                              children: [
                                for (final address in others)
                                  _AddressCard(
                                    address: address,
                                    expanded: _expandedId == address.id,
                                    copied: _copiedId == address.id,
                                    onCopy: () => _copyAddress(address),
                                    onFavorite: () =>
                                        _toggleFavorite(address.id),
                                    onDefault: () => _setDefault(address.id),
                                    onExpand: () => setState(() {
                                      _expandedId = _expandedId == address.id
                                          ? null
                                          : address.id;
                                    }),
                                  ),
                              ],
                            ),
                          const VitInfoCallout(
                            key: LaunchpadAddressBookPage.infoKey,
                            message:
                                'So dia chi duoc luu tren thiet bi. Luon kiem tra lai dia chi truoc khi thuc hien giao dich.',
                            icon: Icons.info_outline_rounded,
                            accentColor: AppColors.primary,
                            padding: LaunchpadSpacingTokens.launchpadPaddingX3,
                          ),
                        ];
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (_showAddSheet)
              Positioned.fill(
                child: _AddAddressSheet(
                  onClose: () => setState(() => _showAddSheet = false),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<LaunchpadWalletAddressDraft> _filteredAddresses(
    List<LaunchpadWalletAddressDraft> addresses,
  ) {
    final query = _searchQuery.trim().toLowerCase();
    final filtered = addresses.where((address) {
      final matchesChain =
          _chainFilter == 'all' || address.chain == _chainFilter;
      final matchesQuery =
          query.isEmpty ||
          address.label.toLowerCase().contains(query) ||
          address.address.toLowerCase().contains(query) ||
          address.chain.toLowerCase().contains(query) ||
          address.tags.any((tag) => tag.toLowerCase().contains(query));
      return matchesChain && matchesQuery;
    }).toList();
    filtered.sort((a, b) {
      if (a.isDefault != b.isDefault) return a.isDefault ? -1 : 1;
      if (a.isFavorite != b.isFavorite) return a.isFavorite ? -1 : 1;
      return b.usageCount.compareTo(a.usageCount);
    });
    return filtered;
  }

  Future<void> _copyAddress(LaunchpadWalletAddressDraft address) async {
    setState(() => _copiedId = address.id);
    try {
      await Clipboard.setData(ClipboardData(text: address.address));
    } catch (_) {
      // Embedded test shells may not expose clipboard support.
    }
  }

  void _toggleFavorite(String id) {
    ref
        .read(launchpadAddressBookStateControllerProvider.notifier)
        .toggleFavorite(id);
  }

  void _setDefault(String id) {
    ref
        .read(launchpadAddressBookStateControllerProvider.notifier)
        .setDefault(id);
  }
}
