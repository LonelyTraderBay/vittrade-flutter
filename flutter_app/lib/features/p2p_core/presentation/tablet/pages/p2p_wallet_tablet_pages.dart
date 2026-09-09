import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/p2p_formatters.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_two_column_tablet_dashboard.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_section_frame.dart';
part 'p2p_wallet_tablet_pages_sections.dart';

/// Bố cục tablet của Ví P2P (SC-264): banner số dư tổng (mask theo financial
/// safety) + bảng số dư theo tài sản + giao dịch gần đây; quick actions
/// (chuyển / lịch sử / fund-lock / escrow) ở cột phụ.
class P2PWalletTabletPage extends ConsumerWidget {
  const P2PWalletTabletPage({super.key});

  static const contentKey = Key('sc264_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pWalletProvider);
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Ví P2P',
      semanticIdentifier: 'SC-264',
      child: Column(
        children: [
          VitHeader(
            title: 'Ví P2P',
            subtitle: 'Số dư · Escrow · Fund lock',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.p2p,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
          ),
          Expanded(
            child: snapshotAsync.when(
              loading: () => const Center(child: VitSkeletonList(rows: 6)),
              error: (error, stackTrace) => SingleChildScrollView(
                child: VitErrorState(
                  title: 'Không tải được ví P2P',
                  message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () => ref.invalidate(p2pWalletProvider),
                ),
              ),
              data: (snapshot) => VitTwoColumnTabletDashboard(
                onRefresh: () async {
                  ref.invalidate(p2pWalletProvider);
                  await ref.read(p2pWalletProvider.future);
                },
                banner: VitCard(
                  radius: VitCardRadius.tight,
                  padding: TabletSpacingTokens.cardPaddingCompact,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.title,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                            const SizedBox(height: TabletSpacingTokens.x1),
                            Text(
                              snapshot.subtitle,
                              style: AppTextStyles.control.copyWith(
                                fontWeight: AppTextStyles.bold,
                                color: AppColors.text1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      VitCtaButton(
                        fullWidth: false,
                        onPressed: () => context.push(snapshot.transferRoute),
                        child: const Text('Chuyển nội bộ'),
                      ),
                    ],
                  ),
                ),
                primaryChildren: [
                  _BalancesTable(balances: snapshot.balances),
                  _TransactionsCard(transactions: snapshot.transactions),
                ],
                secondaryChildren: [
                  _WalletLinksCard(snapshot: snapshot),
                  VitCard(
                    radius: VitCardRadius.tight,
                    padding: TabletSpacingTokens.cardPaddingCompact,
                    child: Text(
                      snapshot.infoNote,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BalancesTable extends StatelessWidget {
  const _BalancesTable({required this.balances});

  final List<P2PWalletBalanceDraft> balances;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.zeroInsets,
      clip: true,
      child: Column(
        children: [
          for (var i = 0; i < balances.length; i++) ...[
            Padding(
              padding: TabletSpacingTokens.tableCellPaddingTall,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      balances[i].asset,
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: AppTextStyles.bold,
                        color: AppColors.text1,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Khả dụng ${formatP2PCrypto(balances[i].available)}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Escrow ${formatP2PCrypto(balances[i].inEscrow)}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.caution,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Lock ${formatP2PCrypto(balances[i].locked)}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      formatP2PVnd(balances[i].usdValue),
                      textAlign: TextAlign.end,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (i < balances.length - 1)
              const Divider(
                height: TabletSpacingTokens.dividerHairline,
                thickness: TabletSpacingTokens.dividerHairline,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}

class _TransactionsCard extends StatelessWidget {
  const _TransactionsCard({required this.transactions});

  final List<P2PWalletTransactionDraft> transactions;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.zeroInsets,
      clip: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: TabletSpacingTokens.tableCellPadding,
            child: Text(
              'Giao dịch gần đây',
              style: AppTextStyles.control.copyWith(
                fontWeight: AppTextStyles.bold,
                color: AppColors.text1,
              ),
            ),
          ),
          const Divider(
            height: TabletSpacingTokens.dividerHairline,
            thickness: TabletSpacingTokens.dividerHairline,
            color: AppColors.divider,
          ),
          for (final tx in transactions.take(8))
            Padding(
              padding: TabletSpacingTokens.tableCellPadding,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      tx.type,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      formatP2PCrypto(tx.amount),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: VitStatusPill(
                      label: tx.status,
                      status: VitStatusPillStatus.neutral,
                      size: VitStatusPillSize.sm,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      tx.time,
                      textAlign: TextAlign.end,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
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

class _WalletLinksCard extends StatelessWidget {
  const _WalletLinksCard({required this.snapshot});

  final P2PWalletSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (label, route) in [
            ('Lịch sử giao dịch', snapshot.historyRoute),
            ('Lịch sử fund lock', snapshot.parentRoute),
            ('Số dư escrow', snapshot.escrowBalanceRoute),
          ])
            Padding(
              padding: TabletSpacingTokens.tableCellPaddingV,
              child: InkWell(
                onTap: () => context.push(route),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: TabletSpacingTokens.iconMd,
                      color: AppColors.text3,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Chuyển nội bộ Ví P2P (SC-261): form chuyển + số dư khả dụng theo ví.
class P2PWalletTransferTabletPage extends ConsumerStatefulWidget {
  const P2PWalletTransferTabletPage({
    super.key,
    this.asset = 'USDT',
    this.type = 'internal',
  });

  static const contentKey = Key('sc261_tablet_content');
  static const submitKey = Key('sc261_tablet_submit');

  final String asset;
  final String type;

  @override
  ConsumerState<P2PWalletTransferTabletPage> createState() =>
      _P2PWalletTransferTabletPageState();
}
