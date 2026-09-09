part of 'trade_bots_tablet_pages.dart';

/// SC-127: Đánh giá phù hợp trước khi dùng bot.
class BotSuitabilityAssessmentTabletPage extends ConsumerWidget {
  const BotSuitabilityAssessmentTabletPage({super.key});

  static const contentKey = Key('sc127_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      tradeBotSuitabilityAssessmentSnapshotProvider,
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-127',
        semanticLabel: 'Đánh giá phù hợp bot',
        title: snapshotAsync.value?.infoTitle ?? 'Đánh giá phù hợp',
        subtitle: 'Câu hỏi · Kết quả',
        contentKey: BotSuitabilityAssessmentTabletPage.contentKey,
        children: [
          _tbpError(
            'Không tải được đánh giá phù hợp',
            () => ref.invalidate(tradeBotSuitabilityAssessmentSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-127',
        semanticLabel: 'Đánh giá phù hợp bot',
        title: snapshot.infoTitle,
        subtitle: snapshot.infoDescription,
        contentKey: BotSuitabilityAssessmentTabletPage.contentKey,
        children: [
          _tbpSection(
            title: 'Câu hỏi đánh giá',
            rows: [
              for (final question in snapshot.questions)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.question,
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: AppTextStyles.bold,
                          color: AppColors.text1,
                        ),
                      ),
                      ..._tbpBullets([
                        for (final o in question.options) o.text,
                      ]),
                    ],
                  ),
                ),
            ],
          ),

          _tbpSection(
            title: snapshot.regulatoryTitle,
            rows: [
              _tbpBody(snapshot.regulatoryDescription),
              _tbpBody('Hoàn tất: ${snapshot.completionPath}'),
            ],
          ),
        ],
      ),
    );
  }
}

/// SC-128: Bảng điều khiển rủi ro bot.
class BotRiskDashboardTabletPage extends ConsumerWidget {
  const BotRiskDashboardTabletPage({super.key});

  static const contentKey = Key('sc128_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeBotRiskDashboardProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-128',
        semanticLabel: 'Bảng rủi ro bot',
        title: 'Rủi ro bot',
        subtitle: snapshotAsync.value?.riskLabel ?? 'Điểm rủi ro',
        contentKey: BotRiskDashboardTabletPage.contentKey,
        children: [
          _tbpError(
            'Không tải được rủi ro bot',
            () => ref.invalidate(tradeBotRiskDashboardProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-128',
        semanticLabel: 'Bảng rủi ro bot',
        title: 'Rủi ro bot',
        subtitle: '${snapshot.riskLabel} · ${snapshot.runningBots} bot',
        contentKey: BotRiskDashboardTabletPage.contentKey,
        children: [
          _tbpSection(
            title: 'Giới hạn và mức hiện tại',
            rows: _tbpRows([
              ('Điểm rủi ro', '${snapshot.riskScore} — ${snapshot.riskLabel}'),
              ('Sụt giảm hiện tại', _tbpPct(snapshot.currentDrawdown, 2)),
              ('Trần sụt giảm', _tbpPct(snapshot.maxDrawdownLimit, 2)),
              ('Lỗ trong ngày', VitFormat.usdSigned(snapshot.dailyLoss)),
              ('Trần lỗ ngày', VitFormat.usd(snapshot.dailyLossLimit.abs())),
              ('Tổng tiếp xúc', VitFormat.usd(snapshot.totalExposure)),
              ('Trần tiếp xúc', VitFormat.usd(snapshot.maxExposure)),
              ('VaR 95%', VitFormat.usd(snapshot.var95)),
            ]),
          ),

          _tbpSection(
            title: 'Tiếp xúc theo tài sản',
            rows: [
              for (final exposure in snapshot.exposures)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          exposure.asset,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                          ),
                        ),
                      ),
                      Text(
                        '${VitFormat.usd(exposure.exposure)} · ${exposure.percentage}%',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          _tbpSection(
            title: 'Lịch sử VaR',
            rows: _tbpRows([
              for (final point in snapshot.varHistory.take(6))
                (point.label, VitFormat.usd(point.value)),
            ]),
          ),
        ],
      ),
    );
  }
}

/// SC-129: Dừng khẩn cấp bot.
class BotEmergencyStopTabletPage extends ConsumerWidget {
  const BotEmergencyStopTabletPage({super.key});

  static const contentKey = Key('sc129_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeBotEmergencyStopSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-129',
        semanticLabel: 'Dừng khẩn bot',
        title: snapshotAsync.value?.warningTitle ?? 'Dừng khẩn cấp',
        subtitle: 'Hành động rủi ro cao',
        contentKey: BotEmergencyStopTabletPage.contentKey,
        children: [
          _tbpError(
            'Không tải được dừng khẩn cấp',
            () => ref.invalidate(tradeBotEmergencyStopSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-129',
        semanticLabel: 'Dừng khẩn bot',
        title: snapshot.warningTitle,
        subtitle: snapshot.warningDescription,
        contentKey: BotEmergencyStopTabletPage.contentKey,
        children: [
          _tbpSection(
            title: 'Bot sẽ dừng',
            rows: [
              for (final bot in snapshot.bots)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${bot.name} · ${bot.pair}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                          ),
                        ),
                      ),
                      Text(
                        '${VitFormat.usdSigned(bot.profit)} · ${bot.statusLabel}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          _tbpSection(
            title: 'Lý do dừng',
            rows: _tbpBullets([
              for (final reason in snapshot.reasons) reason.label,
            ]),
          ),

          _tbpSection(
            title: snapshot.closePositionsTitle,
            rows: [
              _tbpBody(snapshot.closePositionsDescription),
              _tbpBody(snapshot.confirmationDescription),
              _tbpBody(
                '${snapshot.supportTitle}: ${snapshot.supportDescription}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// SC-130: Cài đặt bảo mật bot.
class BotSecuritySettingsTabletPage extends ConsumerWidget {
  const BotSecuritySettingsTabletPage({super.key});

  static const contentKey = Key('sc130_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeBotSecuritySettingsSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-130',
        semanticLabel: 'Bảo mật bot',
        title: 'Bảo mật bot',
        subtitle: 'Khoá API · IP · 2FA',
        contentKey: BotSecuritySettingsTabletPage.contentKey,
        children: [
          _tbpError(
            'Không tải được bảo mật bot',
            () => ref.invalidate(tradeBotSecuritySettingsSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-130',
        semanticLabel: 'Bảo mật bot',
        title: 'Bảo mật bot',
        subtitle: snapshot.twoFaEnabled ? '2FA đang bật' : '2FA đang tắt',
        contentKey: BotSecuritySettingsTabletPage.contentKey,
        children: [
          _tbpSection(
            title: 'Khoá API',
            rows: [
              for (final key in snapshot.apiKeys)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              key.name,
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: AppTextStyles.bold,
                                color: AppColors.text1,
                              ),
                            ),
                            Text(
                              key.permissions,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        key.lastUsed,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          _tbpSection(
            title: 'Danh sách IP tin cậy',
            rows: _tbpRows([
              for (final entry in snapshot.ipWhitelist)
                (entry.ip, '${entry.label} · ${entry.added}'),
            ]),
          ),

          _tbpSection(
            title: 'Hoạt động gần đây',
            rows: [
              for (final activity in snapshot.recentActivity)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          activity.action,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                          ),
                        ),
                      ),
                      Text(
                        '${activity.status.name} · ${activity.time}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          _tbpSection(
            title: 'Lời khuyên bảo mật',
            rows: _tbpBullets(snapshot.securityTips),
          ),
        ],
      ),
    );
  }
}

/// SC-131: Lịch sử lệnh bot.
class BotHistoryTabletPage extends ConsumerWidget {
  const BotHistoryTabletPage({super.key});

  static const contentKey = Key('sc131_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeBotHistoryProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-131',
        semanticLabel: 'Lịch sử bot',
        title: 'Lịch sử bot',
        subtitle: 'Lệnh đã khớp',
        contentKey: BotHistoryTabletPage.contentKey,
        children: [
          _tbpError(
            'Không tải được lịch sử',
            () => ref.invalidate(tradeBotHistoryProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-131',
        semanticLabel: 'Lịch sử bot',
        title: 'Lịch sử bot',
        subtitle: '${snapshot.trades.length} lệnh',
        contentKey: BotHistoryTabletPage.contentKey,
        children: [
          _tbpSection(
            title: 'Lệnh gần đây',
            rows: [
              for (final trade in snapshot.trades.take(12))
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${trade.botName} · ${trade.pair}',
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: AppTextStyles.bold,
                                color: AppColors.text1,
                              ),
                            ),
                            Text(
                              '${trade.side.name} ${_tbpDec(trade.qty, 4)} @ ${_tbpDec(trade.price, 2)} · phí ${_tbpDec(trade.fee, 4)} · ${trade.timestamp}',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                                fontFeatures: AppTextStyles.tabularFigures,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        VitFormat.usdSigned(trade.pnl),
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: AppTextStyles.bold,
                          color: trade.pnl >= 0
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
        ],
      ),
    );
  }
}

/// SC-132: Phân tích hiệu suất bot.
class BotPerformanceAnalyticsTabletPage extends ConsumerWidget {
  const BotPerformanceAnalyticsTabletPage({super.key});

  static const contentKey = Key('sc132_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeBotPerformanceAnalyticsProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-132',
        semanticLabel: 'Hiệu suất bot',
        title: 'Hiệu suất bot',
        subtitle: 'Chỉ số · Theo chiến lược',
        contentKey: BotPerformanceAnalyticsTabletPage.contentKey,
        children: [
          _tbpError(
            'Không tải được hiệu suất',
            () => ref.invalidate(tradeBotPerformanceAnalyticsProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-132',
        semanticLabel: 'Hiệu suất bot',
        title: 'Hiệu suất bot',
        subtitle: '${snapshot.metrics.totalTrades} lệnh',
        contentKey: BotPerformanceAnalyticsTabletPage.contentKey,
        children: [
          _tbpSection(
            title: 'Chỉ số chính',
            rows: _tbpRows([
              (
                'Tổng lợi nhuận',
                VitFormat.usdSigned(snapshot.metrics.totalPnl),
              ),
              ('Tỷ lệ thắng', _tbpPct(snapshot.metrics.winRate, 1)),
              ('Sharpe', _tbpDec(snapshot.metrics.sharpeRatio)),
              ('Lãi trung bình', VitFormat.usdSigned(snapshot.metrics.avgWin)),
              ('Lỗ trung bình', VitFormat.usdSigned(snapshot.metrics.avgLoss)),
              ('Profit factor', _tbpDec(snapshot.metrics.profitFactor)),
              (
                'Lệnh tốt nhất',
                VitFormat.usdSigned(snapshot.metrics.bestTrade),
              ),
              (
                'Lệnh tệ nhất',
                VitFormat.usdSigned(snapshot.metrics.worstTrade),
              ),
            ]),
          ),

          _tbpSection(
            title: 'Hiệu suất theo chiến lược',
            rows: [
              for (final strategy in snapshot.strategyPerformance)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          strategy.strategy,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                          ),
                        ),
                      ),
                      Text(
                        VitFormat.usdSigned(strategy.pnl),
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: AppTextStyles.bold,
                          color: strategy.pnl >= 0
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
            title: 'Phân bố thời gian giữ lệnh',
            rows: _tbpRows([
              for (final bucket in snapshot.durationDistribution)
                (bucket.duration, '${bucket.count} lệnh'),
            ]),
          ),
        ],
      ),
    );
  }
}
