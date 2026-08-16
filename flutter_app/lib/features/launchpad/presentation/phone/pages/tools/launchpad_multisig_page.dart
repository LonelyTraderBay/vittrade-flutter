import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';

part '../../../widgets/tools/launchpad_multisig_page_chrome.dart';
part '../../../widgets/tools/launchpad_multisig_queue_history.dart';
part '../../../widgets/tools/launchpad_multisig_owners.dart';
part '../../../widgets/tools/launchpad_multisig_tx_card.dart';
part '../../../widgets/tools/launchpad_multisig_tx_details.dart';
part '../../../widgets/tools/launchpad_multisig_create_sheet.dart';

enum _MultisigTab { queue, history, safes }

class LaunchpadMultisigPage extends ConsumerStatefulWidget {
  const LaunchpadMultisigPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc313_launchpad_multisig_content');
  static const safeSelectorKey = Key('sc313_launchpad_multisig_safes');
  static const statsKey = Key('sc313_launchpad_multisig_stats');
  static const tabsKey = Key('sc313_launchpad_multisig_tabs');
  static const createKey = Key('sc313_launchpad_multisig_create');
  static const queueKey = Key('sc313_launchpad_multisig_queue');
  static const historyKey = Key('sc313_launchpad_multisig_history');
  static const ownersKey = Key('sc313_launchpad_multisig_owners');
  static const noticeKey = Key('sc313_launchpad_multisig_notice');
  static const createSheetKey = Key('sc313_launchpad_multisig_create_sheet');
  static const submitCreateKey = Key('sc313_launchpad_multisig_submit');
  static const cancelCreateKey = Key('sc313_launchpad_multisig_cancel');
  static const signKey = Key('sc313_launchpad_multisig_sign');
  static const executeKey = Key('sc313_launchpad_multisig_execute');

  static Key safeKey(String address) =>
      Key('sc313_launchpad_multisig_safe_$address');
  static Key txKey(String id) => Key('sc313_launchpad_multisig_tx_$id');
  static Key txToggleKey(String id) =>
      Key('sc313_launchpad_multisig_toggle_$id');
  static Key copyKey(String id, String field) =>
      Key('sc313_launchpad_multisig_copy_${id}_$field');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadMultisigPage> createState() =>
      _LaunchpadMultisigPageState();
}

class _LaunchpadMultisigPageState extends ConsumerState<LaunchpadMultisigPage> {
  // STATE-S23: transactions sống ở LaunchpadMultisigStateController (một
  // nguồn sự thật) — hết `late List` seed từ ref.read + setState.
  // GD4-F4 bẫy 14: initState() không còn seed từ getter đồng bộ — hạt
  // giống 1 lần trong nhánh `data:` qua `_selectedSafeAddress ??= ...`.
  String? _selectedSafeAddress;
  var _activeTab = _MultisigTab.queue;
  String? _expandedTxId;
  String? _copiedField;
  var _showCreate = false;

  @override
  Widget build(BuildContext context) {
    final multisigAsync = ref.watch(launchpadMultisigSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollTailReserve =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome
            : DeviceMetrics.nativeBottomChrome) +
        MediaQuery.paddingOf(context).bottom +
        AppSpacing.x3;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Quản lý giao dịch đa chữ ký multisig',
      semanticIdentifier: 'SC-313',
      child: Material(
        type: MaterialType.transparency,
        child: multisigAsync.when(
          loading: () => Stack(
            children: [
              VitAutoHideHeaderScaffold(
                bottomInset: scrollTailReserve,
                semanticLabel: 'Quản lý giao dịch đa chữ ký multisig',
                semanticIdentifier: 'SC-313',
                header: VitHeader(
                  title: 'Multi-sig',
                  showBack: true,
                  onBack: () => context.go(AppRoutePaths.launchpad),
                ),
                child: const VitSkeletonList(),
              ),
            ],
          ),
          error: (error, stackTrace) => Stack(
            children: [
              VitAutoHideHeaderScaffold(
                bottomInset: scrollTailReserve,
                semanticLabel: 'Quản lý giao dịch đa chữ ký multisig',
                semanticIdentifier: 'SC-313',
                header: VitHeader(
                  title: 'Multi-sig',
                  showBack: true,
                  onBack: () => context.go(AppRoutePaths.launchpad),
                ),
                child: VitErrorState(
                  title: 'Không tải được dữ liệu',
                  message: 'Vui lòng kiểm tra kết nối và thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () =>
                      ref.invalidate(launchpadMultisigSnapshotProvider),
                ),
              ),
            ],
          ),
          data: (_) {
            final viewState = ref.watch(
              launchpadMultisigStateControllerProvider,
            );
            final snapshot = viewState.snapshot;
            final selectedSafeAddress = _selectedSafeAddress ??=
                snapshot.defaultSafeAddress;
            final selectedSafe = snapshot.safes.firstWhere(
              (safe) => safe.address == selectedSafeAddress,
              orElse: () => snapshot.safes.first,
            );
            final queueTxs = _queueTxs(
              viewState.transactions,
              selectedSafe.address,
            );
            final historyTxs = _historyTxs(
              viewState.transactions,
              selectedSafe.address,
            );

            return Stack(
              children: [
                VitAutoHideHeaderScaffold(
                  bottomInset: scrollTailReserve,
                  semanticLabel: 'Quản lý giao dịch đa chữ ký multisig',
                  semanticIdentifier: 'SC-313',
                  header: VitHeader(
                    title: snapshot.title,
                    subtitle: 'Hàng đợi multisig · Xác nhận đa chữ ký',
                    showBack: true,
                    onBack: () => context.go(snapshot.backRoute),
                  ),
                  child: Column(
                    children: [
                      _SafeSelector(
                        safes: snapshot.safes,
                        selectedAddress: selectedSafeAddress,
                        onChanged: (address) {
                          setState(() {
                            _selectedSafeAddress = address;
                            _expandedTxId = null;
                          });
                        },
                      ),
                      _StatsStrip(safe: selectedSafe, pending: queueTxs.length),
                      ColoredBox(
                        key: LaunchpadMultisigPage.tabsKey,
                        color: AppColors.surface,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Divider(height: AppSpacing.hairlineStroke),
                            Padding(
                              padding: LaunchpadSpacingTokens
                                  .launchpadHorizontalContentPadding,
                              child: VitTabBar(
                                tabs: const [
                                  VitTabItem(key: 'queue', label: 'Hàng đợi'),
                                  VitTabItem(key: 'history', label: 'Lịch sử'),
                                  VitTabItem(key: 'safes', label: 'Safes'),
                                ],
                                activeKey: _activeTab.name,
                                onChanged: (key) => setState(
                                  () => _activeTab = _MultisigTab.values.byName(
                                    key,
                                  ),
                                ),
                                variant: VitTabBarVariant.underline,
                              ),
                            ),
                            const Divider(height: AppSpacing.hairlineStroke),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(
                            context,
                          ).copyWith(scrollbars: false),
                          child: SingleChildScrollView(
                            key: LaunchpadMultisigPage.contentKey,
                            physics: const ClampingScrollPhysics(),
                            child: VitPageContent(
                              rhythm: VitPageRhythm.standard,
                              padding: VitContentPadding.compact,
                              gap: VitContentGap.tight,
                              children: [
                                if (_activeTab == _MultisigTab.queue) ...[
                                  _CreateTxCard(
                                    onTap: () =>
                                        setState(() => _showCreate = true),
                                  ),
                                  _QueueSection(
                                    txs: queueTxs,
                                    expandedTxId: _expandedTxId,
                                    copiedField: _copiedField,
                                    onToggle: _toggleTx,
                                    onCopy: _copyField,
                                    onSign: _signTx,
                                    onExecute: _executeTx,
                                  ),
                                ] else if (_activeTab ==
                                    _MultisigTab.history) ...[
                                  _HistorySection(
                                    txs: historyTxs,
                                    expandedTxId: _expandedTxId,
                                    copiedField: _copiedField,
                                    onToggle: _toggleTx,
                                    onCopy: _copyField,
                                  ),
                                ] else ...[
                                  _OwnersSection(
                                    safe: selectedSafe,
                                    copiedField: _copiedField,
                                    onCopy: _copyField,
                                  ),
                                ],
                                _SecurityNotice(safe: selectedSafe),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_showCreate)
                  Positioned.fill(
                    child: _CreateTxSheet(
                      safe: selectedSafe,
                      onClose: () => setState(() => _showCreate = false),
                      onCreate: (tx) {
                        ref
                            .read(
                              launchpadMultisigStateControllerProvider.notifier,
                            )
                            .createTx(tx);
                        setState(() {
                          _expandedTxId = tx.id;
                          _showCreate = false;
                        });
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<LaunchpadMultisigTxDraft> _queueTxs(
    List<LaunchpadMultisigTxDraft> transactions,
    String safeAddress,
  ) {
    return transactions
        .where(
          (tx) =>
              tx.safeAddress == safeAddress &&
              {
                LaunchpadMultisigTxStatus.draft,
                LaunchpadMultisigTxStatus.pendingSignatures,
                LaunchpadMultisigTxStatus.ready,
                LaunchpadMultisigTxStatus.executing,
              }.contains(tx.status),
        )
        .toList();
  }

  List<LaunchpadMultisigTxDraft> _historyTxs(
    List<LaunchpadMultisigTxDraft> transactions,
    String safeAddress,
  ) {
    return transactions
        .where(
          (tx) =>
              tx.safeAddress == safeAddress &&
              {
                LaunchpadMultisigTxStatus.executed,
                LaunchpadMultisigTxStatus.expired,
                LaunchpadMultisigTxStatus.cancelled,
              }.contains(tx.status),
        )
        .toList();
  }

  void _toggleTx(String id) {
    setState(() => _expandedTxId = _expandedTxId == id ? null : id);
  }

  void _copyField(String text, String field) {
    unawaited(Clipboard.setData(ClipboardData(text: text)));
    setState(() => _copiedField = field);
  }

  void _signTx(String id) {
    ref.read(launchpadMultisigStateControllerProvider.notifier).signTx(id);
  }

  void _executeTx(String id) {
    ref.read(launchpadMultisigStateControllerProvider.notifier).executeTx(id);
  }
}
