part of 'p2p_insurance_fund_page.dart';

class _OverviewContent extends StatelessWidget {
  const _OverviewContent({required this.snapshot});

  final P2PInsuranceFundSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.compact,
      children: [
        _FundSummaryCard(snapshot: snapshot),
        _EligibilityCard(items: snapshot.eligibilityItems),
        _FundHealthCard(snapshot: snapshot),
        _FundChartCard(snapshot: snapshot),
        _CoverageCard(snapshot: snapshot),
        _CoverageTierCard(tiers: snapshot.coverageTiers),
        _NotificationCard(prefs: snapshot.notificationPrefs),
        const _HowItWorksCard(),
        _ClaimCalculatorCard(coveragePct: snapshot.userCoveragePct),
        _PlatformStatsCard(snapshot: snapshot),
      ],
    );
  }
}

class _FundSummaryCard extends StatelessWidget {
  const _FundSummaryCard({required this.snapshot});

  final P2PInsuranceFundSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      borderColor: AppColors.warningBorder,
      padding: P2PSpacingTokens.p2pTrustProgressCompactPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.health_and_safety_outlined,
                color: AppModuleAccents.p2p,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Quỹ bảo hiểm P2P',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                  ),
                ),
              ),
              const VitStatusPill(
                label: 'Đang bảo vệ',
                status: VitStatusPillStatus.orange,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          Text(
            '${_formatVnd(snapshot.totalFund)} đ',
            style: AppTextStyles.heroNumber.copyWith(
              color: AppModuleAccents.p2p,
            ),
          ),
          Text(
            'Tổng quỹ hiện có để bảo vệ giao dịch P2P gặp sự cố.',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          Row(
            children: [
              Expanded(
                child: _MiniMetric(
                  label: 'Claim đang xử lý',
                  value: '${snapshot.activeClaims}',
                ),
              ),
              Expanded(
                child: _MiniMetric(
                  label: 'Đã đóng góp',
                  value: _formatCompactVnd(snapshot.totalContributed),
                ),
              ),
              Expanded(
                child: _MiniMetric(
                  label: 'Đã chi trả',
                  value: _formatCompactVnd(snapshot.totalPaid),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EligibilityCard extends StatelessWidget {
  const _EligibilityCard({required this.items});

  final List<P2PInsuranceEligibilityItemDraft> items;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.standard,
      padding: P2PSpacingTokens.p2pTrustProgressCompactPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _CardTitle(
            icon: Icons.check_circle_outline_rounded,
            title: 'Điều kiện bồi thường',
          ),
          for (final item in items) _EligibilityRow(item: item),
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.standard,
            padding: P2PSpacingTokens.p2pTrustProgressChipPadding,
            borderColor: AppColors.buy20,
            child: Text(
              'Bạn đủ điều kiện gửi yêu cầu bồi thường',
              textAlign: TextAlign.center,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.buy,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FundHealthCard extends StatelessWidget {
  const _FundHealthCard({required this.snapshot});

  final P2PInsuranceFundSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.standard,
      padding: P2PSpacingTokens.p2pTrustProgressCompactPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Expanded(
                child: _CardTitle(
                  icon: Icons.favorite_border_rounded,
                  title: 'Sức khỏe quỹ',
                ),
              ),
              VitStatusPill(
                label: 'Khỏe mạnh',
                status: VitStatusPillStatus.success,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          Text(
            'Quỹ đủ khả năng chi trả toàn bộ claims đang xử lý',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          _TwoColumnInfo(
            label: 'Tỷ lệ thanh khoản',
            value: '${snapshot.solvencyRatio}x',
            tone: AppColors.buy,
          ),
          _TwoColumnInfo(
            label: 'Claims chưa giải quyết',
            value: '${_formatVnd(snapshot.outstandingClaimsAmount)} đ',
          ),
          _TwoColumnInfo(
            label: 'Tỷ lệ duyệt',
            value: '${snapshot.approvalRate}%',
          ),
          _TwoColumnInfo(
            label: 'Thời gian xử lý TB',
            value: '${snapshot.avgResolutionHours}h',
          ),
          _TwoColumnInfo(
            label: 'Hạn mức/30 ngày',
            value: '${_formatVnd(snapshot.maxClaimPerPeriod)} đ',
          ),
          VitCard(
            key: P2PInsuranceFundPage.certificateKey,
            variant: VitCardVariant.inner,
            radius: VitCardRadius.standard,
            padding: P2PSpacingTokens.p2pTrustProgressCompactPadding,
            onTap: () => context.go(snapshot.certificateRoute),
            child: Row(
              children: [
                const SizedBox.square(
                  dimension: _p2pInsuranceIconBox,
                  child: Material(
                    color: AppColors.primary12,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.smRadius,
                      side: BorderSide(color: AppColors.primary20),
                    ),
                    child: Icon(
                      Icons.verified_user_outlined,
                      color: AppModuleAccents.p2p,
                      size: AppSpacing.iconMd,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chứng minh dự trữ',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      Text(
                        'Kiểm toán gần nhất: ${snapshot.lastAuditDate}\n${snapshot.auditorName} · Kỳ tiếp theo: ${snapshot.nextAuditDate}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          height: _p2pInsuranceCaptionLineHeight,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.open_in_new_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.iconSm,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FundChartCard extends StatelessWidget {
  const _FundChartCard({required this.snapshot});

  final P2PInsuranceFundSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.standard,
      padding: P2PSpacingTokens.p2pTrustProgressCompactPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(
                child: _CardTitle(
                  icon: Icons.trending_up_rounded,
                  title: 'Biến động quỹ',
                ),
              ),
              Text(
                '+37.6%',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          Text(
            'Số dư quỹ bảo hiểm (triệu VND)',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const Row(
            children: [
              _RangeChip(label: '7 ngày'),
              SizedBox(width: AppSpacing.x2),
              _RangeChip(label: '30 ngày', active: true),
              SizedBox(width: AppSpacing.x2),
              _RangeChip(label: '90 ngày'),
            ],
          ),
          SizedBox(
            height: _p2pInsuranceChartHeight,
            child: CustomPaint(
              painter: _FundTrendPainter(snapshot.chartPoints),
              child: const SizedBox.expand(),
            ),
          ),
          const Row(
            children: [
              Expanded(
                child: _LegendDot(label: 'Dòng tiền 30d', color: AppColors.buy),
              ),
              _LegendDot(label: '+240M', color: AppColors.buy),
              SizedBox(width: AppSpacing.x3),
              _LegendDot(label: '-47M', color: AppModuleAccents.p2p),
            ],
          ),
        ],
      ),
    );
  }
}

class _CoverageCard extends StatelessWidget {
  const _CoverageCard({required this.snapshot});

  final P2PInsuranceFundSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.standard,
      padding: P2PSpacingTokens.p2pTrustProgressCompactPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Mức bảo hiểm của bạn',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                  ),
                ),
              ),
              Text(
                '${snapshot.userCoveragePct}%',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppModuleAccents.p2p,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          _TwoColumnInfo(label: 'Hạng merchant', value: snapshot.tierName),
          _TwoColumnInfo(
            label: 'Đóng góp/giao dịch',
            value: snapshot.contributionRate,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.standard,
            padding: P2PSpacingTokens.p2pTrustProgressCompactPadding,
            onTap: () => context.go(snapshot.contributionHistoryRoute),
            child: Row(
              children: [
                const Icon(
                  Icons.history_rounded,
                  color: AppColors.buy,
                  size: AppSpacing.iconMd,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    'Xem lịch sử đóng góp quỹ',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.iconMd,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CoverageTierCard extends StatelessWidget {
  const _CoverageTierCard({required this.tiers});

  final List<P2PInsuranceCoverageTierDraft> tiers;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.standard,
      padding: P2PSpacingTokens.p2pTrustProgressCompactPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(
            icon: Icons.info_outline_rounded,
            title: 'Bảng bảo hiểm theo tier',
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (final tier in tiers) _TierRow(tier: tier),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.prefs});

  final List<P2PInsuranceNotificationPrefDraft> prefs;

  @override
  Widget build(BuildContext context) {
    final enabled = prefs.where((item) => item.enabled).length;
    return VitCard(
      radius: VitCardRadius.standard,
      padding: P2PSpacingTokens.p2pTrustProgressCompactPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: _CardTitle(
                  icon: Icons.notifications_none_rounded,
                  title: 'Thông báo bảo hiểm',
                ),
              ),
              Text(
                '$enabled/${prefs.length} bật',
                style: AppTextStyles.micro.copyWith(
                  color: AppModuleAccents.p2p,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (final pref in prefs) _NotificationRow(pref: pref),
        ],
      ),
    );
  }
}

class _HowItWorksCard extends StatelessWidget {
  const _HowItWorksCard();

  @override
  Widget build(BuildContext context) {
    return const VitCard(
      radius: VitCardRadius.standard,
      padding: P2PSpacingTokens.p2pTrustProgressCompactPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardTitle(icon: Icons.route_rounded, title: 'Cách hoạt động'),
          SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _StepRow(
            index: '1',
            title: 'Đóng góp',
            subtitle: '0.1% mỗi giao dịch được trích vào quỹ bảo hiểm chung',
          ),
          _StepRow(
            index: '2',
            title: 'Claim',
            subtitle: 'Nếu bị fraud/chargeback, submit claim trong 7 ngày',
          ),
          _StepRow(
            index: '3',
            title: 'Bồi thường',
            subtitle: 'Review trong 48h, chi trả trong 72h',
          ),
        ],
      ),
    );
  }
}
