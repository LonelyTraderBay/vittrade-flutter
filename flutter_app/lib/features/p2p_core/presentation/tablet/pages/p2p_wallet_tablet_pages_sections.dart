part of 'p2p_wallet_tablet_pages.dart';

class _P2PWalletTransferTabletPageState
    extends ConsumerState<P2PWalletTransferTabletPage> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final request = (asset: widget.asset, type: widget.type);
    final snapshotAsync = ref.watch(p2pWalletTransferProvider(request));
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Chuyển nội bộ Ví P2P',
      semanticIdentifier: 'SC-261',
      child: Column(
        children: [
          VitHeader(
            title: 'Chuyển nội bộ',
            subtitle: 'Ví P2P · Xem trước trước khi gửi',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.p2pWallet,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
          ),
          Expanded(
            child: snapshotAsync.when(
              loading: () => const Center(child: VitSkeletonList(rows: 6)),
              error: (error, stackTrace) => SingleChildScrollView(
                child: VitErrorState(
                  title: 'Không tải được chuyển nội bộ',
                  message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () =>
                      ref.invalidate(p2pWalletTransferProvider(request)),
                ),
              ),
              data: (snapshot) => VitTabletSectionBody(
                contentKey: P2PWalletTransferTabletPage.contentKey,
                children: [
                  VitCard(
                    radius: VitCardRadius.tight,
                    padding: TabletSpacingTokens.cardPaddingCompact,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Số tiền chuyển (${snapshot.defaultAsset})',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: AppTextStyles.bold,
                            color: AppColors.text1,
                          ),
                        ),
                        const SizedBox(height: TabletSpacingTokens.x2),
                        VitInput(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          semanticLabel: 'Số tiền chuyển',
                          hintText: 'Nhập số tiền',
                        ),
                      ],
                    ),
                  ),

                  VitCard(
                    radius: VitCardRadius.tight,
                    padding: TabletSpacingTokens.zeroInsets,
                    clip: true,
                    child: Column(
                      children: [
                        for (var i = 0; i < snapshot.balances.length; i++) ...[
                          Padding(
                            padding: TabletSpacingTokens.tableCellPadding,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    snapshot.balances[i].walletLabel,
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.text2,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    snapshot.balances[i].asset,
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.text2,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    formatP2PCrypto(
                                      snapshot.balances[i].available,
                                    ),
                                    textAlign: TextAlign.end,
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.text1,
                                      fontWeight: AppTextStyles.bold,
                                      fontFeatures:
                                          AppTextStyles.tabularFigures,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (i < snapshot.balances.length - 1)
                            const Divider(
                              height: TabletSpacingTokens.dividerHairline,
                              thickness: TabletSpacingTokens.dividerHairline,
                              color: AppColors.divider,
                            ),
                        ],
                      ],
                    ),
                  ),

                  VitCard(
                    radius: VitCardRadius.tight,
                    padding: TabletSpacingTokens.cardPaddingCompact,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final (label, note) in [
                          ('Phí', snapshot.feeLabel),
                          ('Thời gian xử lý', snapshot.processingLabel),
                        ])
                          Padding(
                            padding: TabletSpacingTokens.tableCellPaddingV,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    label,
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.text2,
                                    ),
                                  ),
                                ),
                                Text(
                                  note,
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.text1,
                                    fontWeight: AppTextStyles.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  const VitHighRiskStatePanel(
                    state: VitHighRiskUiState.riskReview,
                    title: 'Xem lại chuyển nội bộ',
                    message:
                        'Kiểm tra số tiền và ví đích. Chuyển nội bộ không thể hoàn tác sau khi gửi.',
                    contractId: 'p2p-wallet-transfer-tablet',
                  ),

                  const SizedBox(height: TabletSpacingTokens.x4),

                  VitCtaButton(
                    key: P2PWalletTransferTabletPage.submitKey,
                    onPressed: () => context.push(AppRoutePaths.p2pWallet),
                    child: const Text('Xem trước & gửi'),
                  ),

                  Text(
                    snapshot.escrowNote,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: 1.3,
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

/// Lịch sử fund lock (SC-262) — dùng chung cho /p2p/wallet/fund-lock-history
/// (alias=false) và /p2p/wallet/history (alias=true) như trang phone.
class P2PFundLockHistoryTabletPage extends ConsumerWidget {
  const P2PFundLockHistoryTabletPage({
    super.key,
    this.walletHistoryAlias = false,
  });

  static const contentKey = Key('sc262_tablet_content');

  final bool walletHistoryAlias;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      p2pFundLockHistoryProvider(walletHistoryAlias),
    );
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Lịch sử fund lock P2P',
      semanticIdentifier: walletHistoryAlias ? 'SC-263' : 'SC-262',
      child: Column(
        children: [
          VitHeader(
            title: walletHistoryAlias
                ? 'Lịch sử giao dịch ví'
                : 'Lịch sử fund lock',
            subtitle: walletHistoryAlias
                ? 'Giao dịch · Ví P2P'
                : 'Khoá mở · Ví P2P',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.p2pWallet,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
          ),
          Expanded(
            child: snapshotAsync.when(
              loading: () => const Center(child: VitSkeletonList(rows: 6)),
              error: (error, stackTrace) => SingleChildScrollView(
                child: VitErrorState(
                  title: 'Không tải được lịch sử',
                  message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () => ref.invalidate(
                    p2pFundLockHistoryProvider(walletHistoryAlias),
                  ),
                ),
              ),
              data: (snapshot) => VitTabletSectionBody(
                contentKey: P2PFundLockHistoryTabletPage.contentKey,
                children: [
                  VitCard(
                    radius: VitCardRadius.tight,
                    padding: TabletSpacingTokens.cardPaddingCompact,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.heroTitle,
                                style: AppTextStyles.control.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                  color: AppColors.text1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (snapshot.records.isEmpty)
                    VitEmptyState(
                      icon: Icons.lock_outline_rounded,
                      title: snapshot.emptyTitle,
                      message: snapshot.subtitle,
                    )
                  else
                    VitCard(
                      radius: VitCardRadius.tight,
                      padding: TabletSpacingTokens.zeroInsets,
                      clip: true,
                      child: Column(
                        children: [
                          for (var i = 0; i < snapshot.records.length; i++) ...[
                            Padding(
                              padding: TabletSpacingTokens.tableCellPadding,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      snapshot.records[i].type,
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.text2,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      snapshot.records[i].asset,
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.text2,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      formatP2PCrypto(
                                        snapshot.records[i].amount,
                                      ),
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.text1,
                                        fontWeight: AppTextStyles.bold,
                                        fontFeatures:
                                            AppTextStyles.tabularFigures,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      snapshot.records[i].reason,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.micro.copyWith(
                                        color: AppColors.text3,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      snapshot.records[i].timestamp,
                                      textAlign: TextAlign.end,
                                      style: AppTextStyles.micro.copyWith(
                                        color: AppColors.text3,
                                        fontFeatures:
                                            AppTextStyles.tabularFigures,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (i < snapshot.records.length - 1)
                              const Divider(
                                height: TabletSpacingTokens.dividerHairline,
                                thickness: TabletSpacingTokens.dividerHairline,
                                color: AppColors.divider,
                              ),
                          ],
                        ],
                      ),
                    ),

                  Text(
                    snapshot.contractNotes,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
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
