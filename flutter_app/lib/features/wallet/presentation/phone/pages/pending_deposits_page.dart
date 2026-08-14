import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/core/utils/data_masking.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/core/product_flow/contextual_support_contract.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

part '../../widgets/transfer/pending_deposits_page_sections.dart';
part '../../widgets/transfer/pending_deposits_page_common.dart';

const _pendingGap = AppSpacing.x2;
const _pendingTinyGap = AppSpacing.x1;
const _pendingInlineGap = AppSpacing.x2;
const _pendingFilterHeight = AppSpacing.buttonCompact;

bool _isLikelyOffline(Object error) {
  final text = error.toString().toLowerCase();
  return text.contains('socket') ||
      text.contains('network') ||
      text.contains('offline') ||
      text.contains('failed host lookup') ||
      text.contains('clientexception');
}

double _pendingScrollBottomInset(BuildContext context, ShellRenderMode mode) {
  return (mode.usesVisualQaFrame
          ? WalletSpacingTokens.walletPendingBottomInsetVisual
          : WalletSpacingTokens.walletPendingBottomInsetNative) +
      MediaQuery.paddingOf(context).bottom;
}

enum _DepositFilter { all, pending, done }

class PendingDepositsPage extends ConsumerStatefulWidget {
  const PendingDepositsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc152_pending_deposits_content');
  static const refreshKey = Key('sc152_pending_deposits_refresh');
  static Key filterKey(String filter) =>
      Key('sc152_pending_deposits_filter_$filter');
  static Key depositKey(String id) => Key('sc152_pending_deposit_$id');
  static Key copyKey(String id) => Key('sc152_pending_deposit_copy_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PendingDepositsPage> createState() =>
      _PendingDepositsPageState();
}

class _PendingDepositsPageState extends ConsumerState<PendingDepositsPage> {
  _DepositFilter _filter = _DepositFilter.all;
  String? _copiedId;
  Timer? _copiedReset;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(walletPendingDepositsProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset = _pendingScrollBottomInset(context, mode);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Nạp tiền đang chờ xác nhận',
      semanticIdentifier: 'SC-152',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'N\u1EA1p ti\u1EC1n \u0111ang ch\u1EDD',
            subtitle: 'Theo d\u00F5i x\u00E1c nh\u1EADn \u00B7 Wallet',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.wallet),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.primary,
                  backgroundColor: AppColors.surface2,
                  onRefresh: _refreshDeposits,
                  child: VitInsetScrollView(
                    key: PendingDepositsPage.contentKey,
                    bottomInset: bottomInset,
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: ClampingScrollPhysics(),
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      padding: VitContentPadding.compact,
                      density: VitDensity.compact,
                      gap: VitContentGap.tight,
                      children: [
                        ...snapshotAsync.when(
                          loading: () => const [VitSkeletonList()],
                          error: (error, stackTrace) {
                            final offline = _isLikelyOffline(error);
                            return [
                              if (offline)
                                const VitOfflineBanner(
                                  message: 'Mất kết nối mạng',
                                  detail: 'Không tải được nạp tiền đang chờ.',
                                ),
                              VitErrorState(
                                title: offline
                                    ? 'Đang offline'
                                    : 'Không tải được nạp tiền đang chờ',
                                message:
                                    'Vui lòng kiểm tra kết nối và thử lại.',
                                actionLabel: 'Thử lại',
                                onAction: () => ref.invalidate(
                                  walletPendingDepositsProvider,
                                ),
                              ),
                            ];
                          },
                          data: (snapshot) {
                            final deposits = _filteredDeposits(
                              snapshot.deposits,
                            );
                            return [
                              const _TrustReviewNotice(),
                              _SummaryBanner(
                                pendingCount: snapshot.pendingCount,
                                onRefresh: _refreshDeposits,
                              ),
                              _PendingDepositFilters(
                                active: _filter,
                                pendingCount: snapshot.pendingCount,
                                onChanged: (filter) =>
                                    setState(() => _filter = filter),
                              ),
                              VitPageSection(
                                label: 'Danh s\u00E1ch n\u1EA1p',
                                headerIcon: Icons.pending_actions_outlined,
                                headerVariant: VitSectionHeaderVariant.plain,
                                innerGap: AppSpacing.pageRhythmStandardInnerGap,
                                children: [
                                  if (deposits.isEmpty)
                                    _EmptyDeposits(
                                      hasAnyDeposits:
                                          snapshot.deposits.isNotEmpty,
                                      onShowAll: () => setState(
                                        () => _filter = _DepositFilter.all,
                                      ),
                                      onDeposit: () => context.go(
                                        AppRoutePaths.walletDeposit,
                                      ),
                                    )
                                  else
                                    for (final deposit in deposits)
                                      _DepositCard(
                                        key: PendingDepositsPage.depositKey(
                                          deposit.id,
                                        ),
                                        deposit: deposit,
                                        copied: _copiedId == deposit.id,
                                        onCopy: () => _copyHash(deposit),
                                        onSupport: _openSupportForDeposit,
                                      ),
                                ],
                              ),
                              const _InfoNotice(),
                            ];
                          },
                        ),
                      ],
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

  List<WalletPendingDeposit> _filteredDeposits(
    List<WalletPendingDeposit> deposits,
  ) {
    return switch (_filter) {
      _DepositFilter.pending =>
        deposits
            .where(
              (deposit) =>
                  deposit.status == 'confirming' ||
                  deposit.status == 'processing',
            )
            .toList(growable: false),
      _DepositFilter.done =>
        deposits
            .where(
              (deposit) =>
                  deposit.status == 'credited' || deposit.status == 'failed',
            )
            .toList(growable: false),
      _DepositFilter.all => deposits,
    };
  }

  Future<void> _copyHash(WalletPendingDeposit deposit) async {
    _copiedReset?.cancel();
    setState(() => _copiedId = deposit.id);
    await Clipboard.setData(ClipboardData(text: deposit.txHash));
    _copiedReset = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      if (_copiedId == deposit.id) setState(() => _copiedId = null);
    });
  }

  void _openSupportForDeposit(WalletPendingDeposit deposit) {
    final supportContext = ProductSupportContext.fromContract(
      ContextualSupportContracts.contracts.firstWhere(
        (contract) => contract.flow == ContextualSupportFlow.withdrawal,
      ),
      referenceId: deposit.id,
      sourceRoute: AppRoutePaths.walletPendingDeposits,
      issueLabel: 'Nạp ${deposit.asset} thất bại',
    );
    context.go(
      supportContext.toSupportRoute(supportPath: AppRoutePaths.support),
    );
  }

  Future<void> _refreshDeposits() async {
    try {
      ref.invalidate(walletPendingDepositsProvider);
      await ref.read(walletPendingDepositsProvider.future);
    } catch (_) {
      if (!mounted) return;
      await showVitNoticeSheet(
        context: context,
        title: 'Không làm mới được',
        message:
            'Không cập nhật được trạng thái nạp đang chờ. Kiểm tra kết nối và thử lại.',
      );
      return;
    }
    if (!mounted) return;
    await showVitNoticeSheet(
      context: context,
      title: 'Đã làm mới',
      message:
          'Trạng thái nạp tiền đang chờ đã được cập nhật. Kiểm tra lại số xác nhận và mạng trước khi thao tác ví.',
    );
  }

  @override
  void dispose() {
    _copiedReset?.cancel();
    super.dispose();
  }
}
