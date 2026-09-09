part of 'trade_bots_tablet_pages.dart';

/// SC-138: Đường vốn bot.
class BotEquityCurveTabletPage extends ConsumerWidget {
  const BotEquityCurveTabletPage({super.key});

  static const contentKey = Key('sc138_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeBotEquityCurveProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-138',
        semanticLabel: 'Đường vốn bot',
        title: 'Đường vốn',
        subtitle: 'Bot vs giữ nguyên',
        contentKey: BotEquityCurveTabletPage.contentKey,
        children: [
          _tbpError(
            'Không tải được đường vốn',
            () => ref.invalidate(tradeBotEquityCurveProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-138',
        semanticLabel: 'Đường vốn bot',
        title: 'Đường vốn',
        subtitle: 'Alpha ${_tbpPct(snapshot.summary.alphaPct, 2)}',
        contentKey: BotEquityCurveTabletPage.contentKey,
        children: [
          _tbpSection(
            title: 'Tổng quan',
            rows: _tbpRows([
              ('Lợi suất bot', _tbpPct(snapshot.summary.botReturnPct, 2)),
              ('Giữ nguyên', _tbpPct(snapshot.summary.buyHoldReturnPct, 2)),
              ('Alpha', _tbpPct(snapshot.summary.alphaPct, 2)),
            ]),
          ),

          _tbpSection(
            title: 'Lợi suất theo tháng',
            rows: [
              for (final monthly in snapshot.monthlyReturns)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      SizedBox(
                        width: TabletSpacingTokens.x7,
                        child: Text(
                          monthly.month,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Bot ${_tbpPct(monthly.botReturn, 2)} · Thị trường ${_tbpPct(monthly.marketReturn, 2)}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                      ),
                      Text(
                        _tbpPct(monthly.alpha, 2),
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: AppTextStyles.bold,
                          color: monthly.alpha >= 0
                              ? AppColors.buy
                              : AppColors.sell,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          _tbpSection(
            title: 'Thống kê hiệu suất',
            rows: _tbpRows([
              for (final stat in snapshot.performanceStats)
                (stat.label, stat.value),
            ]),
          ),
        ],
      ),
    );
  }
}

/// SC-139: Hướng dẫn bot.
class BotGuideTabletPage extends ConsumerWidget {
  const BotGuideTabletPage({super.key});

  static const contentKey = Key('sc139_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeBotGuideProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-139',
        semanticLabel: 'Hướng dẫn bot',
        title: 'Hướng dẫn bot',
        subtitle: 'Chiến lược · Thực hành',
        contentKey: BotGuideTabletPage.contentKey,
        children: [
          _tbpError(
            'Không tải được hướng dẫn',
            () => ref.invalidate(tradeBotGuideProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-139',
        semanticLabel: 'Hướng dẫn bot',
        title: 'Hướng dẫn bot',
        subtitle: '${snapshot.strategies.length} chiến lược',
        contentKey: BotGuideTabletPage.contentKey,
        children: [
          for (final strategy in snapshot.strategies) ...[
            _tbpSection(
              title: '${strategy.name} (${strategy.difficulty})',
              rows: [
                _tbpBody(strategy.description),
                ..._tbpBullets(strategy.howItWorks),
                ..._tbpBullets([
                  for (final pro in strategy.pros) 'Ưu điểm: $pro',
                  for (final con in strategy.cons) 'Hạn chế: $con',
                ]),
                _tbpBody('Phù hợp: ${strategy.bestFor}'),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
          ],

          _tbpSection(
            title: 'Thực hành tốt',
            rows: [
              for (final practice in snapshot.bestPractices)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        practice.title,
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: AppTextStyles.bold,
                          color: AppColors.text1,
                        ),
                      ),
                      Text(
                        practice.description,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          _tbpSection(
            title: 'Lỗi thường gặp',
            rows: [
              for (final mistake in snapshot.mistakes)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mistake.mistake,
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: AppTextStyles.bold,
                          color: AppColors.sell,
                        ),
                      ),
                      Text(
                        'Vì sao: ${mistake.why}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                          height: 1.3,
                        ),
                      ),
                      Text(
                        'Khắc phục: ${mistake.fix}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// SC-140: Câu hỏi thường gặp bot.
class BotFaqTabletPage extends ConsumerWidget {
  const BotFaqTabletPage({super.key});

  static const contentKey = Key('sc140_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeBotFaqProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-140',
        semanticLabel: 'Hỏi đáp bot',
        title: 'Hỏi đáp',
        subtitle: 'Theo chủ đề',
        contentKey: BotFaqTabletPage.contentKey,
        children: [
          _tbpError(
            'Không tải được hỏi đáp',
            () => ref.invalidate(tradeBotFaqProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-140',
        semanticLabel: 'Hỏi đáp bot',
        title: 'Hỏi đáp',
        subtitle: '${snapshot.categories.length} chủ đề',
        contentKey: BotFaqTabletPage.contentKey,
        children: [
          for (final category in snapshot.categories) ...[
            _tbpSection(
              title: category.label,
              rows: [
                for (final item in category.items)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.question,
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: AppTextStyles.bold,
                            color: AppColors.text1,
                          ),
                        ),
                        Text(
                          item.answer,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
          ],
        ],
      ),
    );
  }
}

/// SC-141: Báo cáo thuế bot.
class BotTaxReportingTabletPage extends ConsumerWidget {
  const BotTaxReportingTabletPage({super.key});

  static const contentKey = Key('sc141_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeBotTaxReportingProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-141',
        semanticLabel: 'Báo cáo thuế bot',
        title: 'Báo cáo thuế',
        subtitle: snapshotAsync.value?.defaultYear ?? 'Tổng hợp',
        contentKey: BotTaxReportingTabletPage.contentKey,
        children: [
          _tbpError(
            'Không tải được báo cáo thuế',
            () => ref.invalidate(tradeBotTaxReportingProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-141',
        semanticLabel: 'Báo cáo thuế bot',
        title: 'Báo cáo thuế',
        subtitle:
            'Năm ${snapshot.defaultYear} · ${snapshot.defaultCostBasisMethod}',
        contentKey: BotTaxReportingTabletPage.contentKey,
        children: [
          _tbpSection(
            title: 'Tổng hợp thuế',
            rows: _tbpRows([
              ('Tổng số lệnh', '${snapshot.summary.totalTrades}'),
              (
                'Lãi đã thực hiện',
                VitFormat.usd(snapshot.summary.realizedGains),
              ),
              (
                'Lỗ đã thực hiện',
                VitFormat.usd(snapshot.summary.realizedLosses),
              ),
              ('Ròng', VitFormat.usdSigned(snapshot.summary.netGainLoss)),
              ('Ngắn hạn', VitFormat.usd(snapshot.summary.shortTermGains)),
              ('Dài hạn', VitFormat.usd(snapshot.summary.longTermGains)),
              ('Tổng phí', VitFormat.usd(snapshot.summary.totalFees)),
            ]),
          ),

          _tbpSection(
            title: 'Loại báo cáo',
            rows: [
              for (final reportType in snapshot.reportTypes)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${reportType.name} (${reportType.format})',
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: AppTextStyles.bold,
                                color: AppColors.text1,
                              ),
                            ),
                            Text(
                              reportType.description,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (reportType.recommended)
                        const VitStatusPill(
                          label: 'Đề xuất',
                          status: VitStatusPillStatus.info,
                          size: VitStatusPillSize.sm,
                        ),
                    ],
                  ),
                ),
            ],
          ),

          _tbpSection(
            title: snapshot.breakdown.shortTermLabel,
            rows: [_tbpBody(snapshot.breakdown.shortTermDescription)],
          ),

          _tbpSection(
            title: snapshot.breakdown.longTermLabel,
            rows: [
              _tbpBody(snapshot.breakdown.longTermDescription),
              ..._tbpBullets(snapshot.taxNotes),
            ],
          ),
        ],
      ),
    );
  }
}

/// SC-142: Tài liệu API bot.
class BotApiDocumentationTabletPage extends ConsumerWidget {
  const BotApiDocumentationTabletPage({super.key});

  static const contentKey = Key('sc142_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeBotApiDocumentationProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-142',
        semanticLabel: 'Tài liệu API bot',
        title: 'Tài liệu API',
        subtitle: 'Endpoint · WebSocket',
        contentKey: BotApiDocumentationTabletPage.contentKey,
        children: [
          _tbpError(
            'Không tải được tài liệu API',
            () => ref.invalidate(tradeBotApiDocumentationProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-142',
        semanticLabel: 'Tài liệu API bot',
        title: 'Tài liệu API',
        subtitle:
            '${snapshot.endpoints.length} endpoint · ${snapshot.tabs.length} tab',
        contentKey: BotApiDocumentationTabletPage.contentKey,
        children: [
          _tbpSection(
            title: 'Endpoint',
            rows: [
              for (final endpoint in snapshot.endpoints)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${endpoint.method} ${endpoint.path}',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: AppTextStyles.bold,
                          color: AppColors.primary,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                      Text(
                        endpoint.description,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          _tbpSection(
            title: 'WebSocket',
            rows: [
              _tbpBody(snapshot.websocketUrl),
              for (final event in snapshot.websocketEvents)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.event,
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: AppTextStyles.bold,
                          color: AppColors.text1,
                        ),
                      ),
                      Text(
                        event.description,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          _tbpSection(
            title: 'Giới hạn tần suất',
            rows: _tbpRows([
              for (final limit in snapshot.rateLimits)
                (limit.label, limit.value),
              ('Xác thực', snapshot.authenticationHeader),
            ]),
          ),
        ],
      ),
    );
  }
}
