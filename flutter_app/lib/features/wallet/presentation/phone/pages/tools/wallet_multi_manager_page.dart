import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/tools/wallet_multi_manager_sections.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

const _tabAll = 'T\u1EA5t c\u1EA3';
const _tabGroups = 'Nh\u00F3m';
const _tabActivity = 'Ho\u1EA1t \u0111\u1ED9ng';

double _managerScrollBottomInset(BuildContext context, ShellRenderMode mode) {
  return (mode.usesVisualQaFrame
          ? WalletSpacingTokens.walletVisualChromePad
          : WalletSpacingTokens.walletNativeChromePad) +
      MediaQuery.paddingOf(context).bottom;
}

class WalletMultiManagerPage extends ConsumerStatefulWidget {
  const WalletMultiManagerPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc148_multi_manager_content');
  static const addWalletKey = Key('sc148_multi_manager_add_wallet');
  static const addWalletNoticeKey = Key(
    'sc148_multi_manager_add_wallet_notice',
  );
  static const securityNoteKey = Key('sc148_multi_manager_security_note');
  static Key tabKey(String label) => Key('sc148_multi_manager_tab_$label');
  static Key walletKey(String id) => Key('sc148_multi_manager_wallet_$id');
  static Key revealKey(String id) => Key('sc148_multi_manager_reveal_$id');
  static Key copyKey(String id) => Key('sc148_multi_manager_copy_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<WalletMultiManagerPage> createState() =>
      _WalletMultiManagerPageState();
}

class _WalletMultiManagerPageState
    extends ConsumerState<WalletMultiManagerPage> {
  String _tab = _tabAll;
  String _selectedWalletId = 'w1';
  final Set<String> _revealedWalletIds = <String>{};
  String? _copiedWalletId;
  String? _actionNotice;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(walletMultiManagerProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset = _managerScrollBottomInset(context, mode);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Quản lý đa ví - kiểm soát địa chỉ và sao chép',
      semanticIdentifier: 'SC-148',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitTopChrome(
            type: VitTopChromeType.detail,
            title: 'Quản lý đa ví',
            subtitle: 'Địa chỉ ẩn mặc định · kiểm soát sao chép',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.wallet),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: VitInsetScrollView(
                  key: WalletMultiManagerPage.contentKey,
                  bottomInset: bottomInset,
                  physics: const ClampingScrollPhysics(),
                  child: VitPageContent(
                    rhythm: VitPageRhythm.standard,
                    padding: VitContentPadding.compact,
                    density: VitDensity.compact,
                    gap: VitContentGap.tight,
                    children: [
                      ...snapshotAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được dữ liệu đa ví',
                            message: 'Vui lòng kiểm tra kết nối và thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () =>
                                ref.invalidate(walletMultiManagerProvider),
                          ),
                        ],
                        data: (snapshot) => [
                          PortfolioSummaryCard(snapshot: snapshot),
                          const VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Bảo mật địa chỉ ví',
                            message:
                                'Chỉ hiện hoặc sao chép địa chỉ khi bạn tin tưởng đích đến và bước tiếp theo.',
                            density: VitDensity.compact,
                          ),
                          WalletManagerTabs(
                            activeTab: _tab,
                            onChanged: (tab) => setState(() => _tab = tab),
                          ),
                          _contentForTab(snapshot),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contentForTab(WalletMultiManagerSnapshot snapshot) {
    final tabContent = switch (_tab) {
      _tabGroups => WalletGroupsTab(snapshot: snapshot),
      _tabActivity => WalletActivityTab(snapshot: snapshot),
      _ => WalletAllWalletsTab(
        snapshot: snapshot,
        selectedWalletId: _selectedWalletId,
        revealedWalletIds: _revealedWalletIds,
        copiedWalletId: _copiedWalletId,
        actionNotice: _actionNotice,
        onSelectWallet: (walletId) =>
            setState(() => _selectedWalletId = walletId),
        onRevealWallet: _toggleReveal,
        onCopyWallet: _copyWallet,
        onAddWallet: _showActionNotice,
      ),
    };

    return tabContent;
  }

  void _toggleReveal(String walletId) {
    setState(() {
      if (_revealedWalletIds.contains(walletId)) {
        _revealedWalletIds.remove(walletId);
      } else {
        _revealedWalletIds.add(walletId);
      }
    });
  }

  Future<void> _copyWallet(WalletManagerItem wallet) async {
    await Clipboard.setData(ClipboardData(text: wallet.address));
    if (!mounted) return;
    setState(() => _copiedWalletId = wallet.id);
  }

  void _showActionNotice() {
    setState(() {
      _actionNotice = 'Chưa kết nối tạo ví mới.';
    });
  }
}
