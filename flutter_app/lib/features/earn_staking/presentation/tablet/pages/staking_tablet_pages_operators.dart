part of 'staking_tablet_pages.dart';

/// SC-269: Chọn validator.
class StakingValidatorSelectionTabletPage extends ConsumerWidget {
  const StakingValidatorSelectionTabletPage({super.key});

  static const contentKey = Key('sc269_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingValidatorSelectionSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-269',
        semanticLabel: 'Chọn validator',
        title: snapshotAsync.value?.infoTitle ?? 'Chọn validator',
        subtitle: 'Uptime · Hoa hồng',
        contentKey: StakingValidatorSelectionTabletPage.contentKey,
        child: _stkError(
          'Không tải được validator',
          () => ref.invalidate(stakingValidatorSelectionSnapshotProvider),
        ),
      ),
      data: (snapshot) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-269',
        semanticLabel: 'Chọn validator',
        title: snapshot.infoTitle,
        subtitle: snapshot.infoBody,
        contentKey: StakingValidatorSelectionTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _stkSection(
              title: 'Validator',
              rows: [
                for (final validator in snapshot.validators)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                validator.name,
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                  color: AppColors.text1,
                                ),
                              ),
                              Text(
                                'Hoa hồng ${validator.commission.toStringAsFixed(1)}% · uptime ${validator.uptime.toStringAsFixed(1)}% · ${validator.delegators} delegator',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text2,
                                  fontFeatures: AppTextStyles.tabularFigures,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          _stkPct(validator.apy),
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: AppTextStyles.bold,
                            color: AppColors.buy,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _stkSection(title: 'Lưu ý', rows: [_stkBody(snapshot.footerNote)]),
          ],
        ),
      ),
    );
  }
}

/// SC-270: Giám sát sức khoẻ validator.
class StakingValidatorHealthMonitorTabletPage extends ConsumerWidget {
  const StakingValidatorHealthMonitorTabletPage({super.key});

  static const contentKey = Key('sc270_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      stakingValidatorHealthMonitorSnapshotProvider,
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-270',
        semanticLabel: 'Giám sát validator',
        title: 'Giám sát validator',
        subtitle: 'Uptime · Trạng thái',
        contentKey: StakingValidatorHealthMonitorTabletPage.contentKey,
        child: _stkError(
          'Không tải được giám sát validator',
          () => ref.invalidate(stakingValidatorHealthMonitorSnapshotProvider),
        ),
      ),
      data: (snapshot) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-270',
        semanticLabel: 'Giám sát validator',
        title: snapshot.title,
        subtitle: '${snapshot.validators.length} validator',
        contentKey: StakingValidatorHealthMonitorTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _stkSection(
              title: 'Trạng thái',
              rows: [
                for (final validator in snapshot.validators)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                validator.name,
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                  color: AppColors.text1,
                                ),
                              ),
                              Text(
                                'Uptime ${validator.uptime.toStringAsFixed(1)}% · APR ${validator.apr.toStringAsFixed(1)}%',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text2,
                                  fontFeatures: AppTextStyles.tabularFigures,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          validator.status,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _stkSection(
              title: snapshot.actionTitle,
              rows: [_stkBody(snapshot.actionBody)],
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-271: Gộp lãi staking.
class StakingAutoCompoundTabletPage extends ConsumerWidget {
  const StakingAutoCompoundTabletPage({super.key});

  static const contentKey = Key('sc271_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingAutoCompoundSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-271',
        semanticLabel: 'Gộp lãi staking',
        title: snapshotAsync.value?.infoTitle ?? 'Gộp lãi',
        subtitle: 'Tần suất · Vị thế',
        contentKey: StakingAutoCompoundTabletPage.contentKey,
        child: _stkError(
          'Không tải được gộp lãi',
          () => ref.invalidate(stakingAutoCompoundSnapshotProvider),
        ),
      ),
      data: (snapshot) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-271',
        semanticLabel: 'Gộp lãi staking',
        title: snapshot.infoTitle,
        subtitle: snapshot.infoBody,
        contentKey: StakingAutoCompoundTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _stkSection(
              title: 'Vị thế',
              rows: [
                for (final position in snapshot.positions)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${position.product} (${position.asset})',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        Text(
                          '${_stkUsd(position.amount)} · ${position.autoCompound ? "gộp tự động" : "thủ công"}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _stkSection(
              title: 'Tần suất',
              rows: _stkTitleBody([
                for (final frequency in snapshot.frequencies)
                  (frequency.label, frequency.description),
              ]),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _stkSection(
              title: 'Khuyến nghị',
              rows: [_stkBody(snapshot.suggestion)],
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-272: Staking lỏng.
class StakingLiquidStakingTabletPage extends ConsumerWidget {
  const StakingLiquidStakingTabletPage({super.key});

  static const contentKey = Key('sc272_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingLiquidStakingSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-272',
        semanticLabel: 'Staking lỏng',
        title: snapshotAsync.value?.infoTitle ?? 'Staking lỏng',
        subtitle: 'Token lỏng · Tỷ giá',
        contentKey: StakingLiquidStakingTabletPage.contentKey,
        child: _stkError(
          'Không tải được staking lỏng',
          () => ref.invalidate(stakingLiquidStakingSnapshotProvider),
        ),
      ),
      data: (snapshot) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-272',
        semanticLabel: 'Staking lỏng',
        title: snapshot.infoTitle,
        subtitle: snapshot.infoBody,
        contentKey: StakingLiquidStakingTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _stkSection(
              title: 'Token lỏng',
              rows: [
                for (final token in snapshot.tokens)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${token.name} (${token.symbol})',
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                  color: AppColors.text1,
                                ),
                              ),
                              Text(
                                'Tài sản gốc ${token.underlyingAsset} · TVL ${_stkUsd(token.tvl)}',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          _stkPct(token.apy),
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: AppTextStyles.bold,
                            color: AppColors.buy,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-273: Lệnh staking nâng cao.
class StakingAdvancedOrdersTabletPage extends ConsumerWidget {
  const StakingAdvancedOrdersTabletPage({super.key});

  static const contentKey = Key('sc273_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingAdvancedOrdersSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-273',
        semanticLabel: 'Lệnh staking nâng cao',
        title: snapshotAsync.value?.infoTitle ?? 'Lệnh nâng cao',
        subtitle: 'Lệnh · Thống kê',
        contentKey: StakingAdvancedOrdersTabletPage.contentKey,
        child: _stkError(
          'Không tải được lệnh nâng cao',
          () => ref.invalidate(stakingAdvancedOrdersSnapshotProvider),
        ),
      ),
      data: (snapshot) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-273',
        semanticLabel: 'Lệnh staking nâng cao',
        title: snapshot.infoTitle,
        subtitle: snapshot.infoBody,
        contentKey: StakingAdvancedOrdersTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _stkSection(
              title: 'Thống kê',
              rows: _stkRows([
                for (final stat in snapshot.statCards) (stat.label, stat.value),
              ]),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _stkSection(
              title: 'Lệnh đang chạy',
              rows: [
                for (final order in snapshot.activeOrders)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Lệnh ${order.type.name} · ${order.asset} ${_stkDec(order.amount, 4)} · kích hoạt ${_stkDec(order.trigger)}',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        Text(
                          order.status.name,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-274: Đa chuỗi.
class StakingMultiChainTabletPage extends ConsumerWidget {
  const StakingMultiChainTabletPage({super.key});

  static const contentKey = Key('sc274_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingMultiChainSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-274',
        semanticLabel: 'Staking đa chuỗi',
        title: snapshotAsync.value?.infoTitle ?? 'Staking đa chuỗi',
        subtitle: 'Chuỗi · Vị thế',
        contentKey: StakingMultiChainTabletPage.contentKey,
        child: _stkError(
          'Không tải được đa chuỗi',
          () => ref.invalidate(stakingMultiChainSnapshotProvider),
        ),
      ),
      data: (snapshot) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-274',
        semanticLabel: 'Staking đa chuỗi',
        title: snapshot.infoTitle,
        subtitle:
            '${snapshot.activeChains} chuỗi · ${_stkUsd(snapshot.totalValue)}',
        contentKey: StakingMultiChainTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _stkSection(
              title: 'Vị thế theo chuỗi',
              rows: [
                for (final chain in snapshot.positions)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${chain.chain} · ${chain.asset}',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        Text(
                          '${_stkUsd(chain.value)} · APY ${_stkPct(chain.apy)}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
