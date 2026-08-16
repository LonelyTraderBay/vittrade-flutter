part of 'p2p_claim_detail_page.dart';

class _P2PClaimDetailPageState extends ConsumerState<P2PClaimDetailPage> {
  _ClaimDetailSection _section = _ClaimDetailSection.timeline;
  // GD4 bẫy 14: initState-seed từ getter giờ-đã-async — bỏ initState, dùng
  // field nullable + `??=` trong nhánh data:.
  bool? _notificationsEnabled;
  String? _feedback;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pClaimDetailProvider(widget.claimId));

    return snapshotAsync.when(
      loading: () => VitP2PFlowScaffold(
        title: 'Đang tải…',
        onBack: () => context.go(AppRoutePaths.p2pInsurance),
        children: const [VitSkeletonList()],
      ),
      error: (error, stackTrace) => VitP2PFlowScaffold(
        title: 'Không tải được',
        onBack: () => context.go(AppRoutePaths.p2pInsurance),
        children: [
          VitErrorState(
            title: 'Không tải được',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () =>
                ref.invalidate(p2pClaimDetailProvider(widget.claimId)),
          ),
        ],
      ),
      data: (snapshot) {
        _notificationsEnabled ??= snapshot.claim.notificationsEnabled;
        final notificationsEnabled = _notificationsEnabled!;
        final claim = snapshot.claim;

        return VitP2PFlowScaffold(
          title: claim.claimCode,
          subtitle: 'Bảo hiểm · P2P',
          semanticLabel: 'Chi tiết yêu cầu bảo hiểm P2P',
          semanticIdentifier: 'SC-243',
          shellRenderMode: widget.shellRenderMode,
          onBack: () => context.go(snapshot.parentRoute),
          headerActions: [
            VitHeaderActionItem(
              type: VitHeaderActionType.notifications,
              tooltip: 'Thông báo claim P2P',
              active: notificationsEnabled,
              onPressed: () {
                unawaited(HapticFeedback.selectionClick());
                setState(() {
                  _notificationsEnabled = !notificationsEnabled;
                  _feedback = !notificationsEnabled
                      ? 'Đã bật thông báo claim'
                      : 'Đã tắt thông báo claim';
                });
              },
            ),
          ],
          children: [
            _ClaimHeroCard(claim: claim),
            _ClaimBenchmarksCard(snapshot: snapshot),
            _DescriptionCard(description: claim.description),
            _ClaimSectionTabs(
              active: _section,
              claim: claim,
              onChanged: (section) {
                unawaited(HapticFeedback.selectionClick());
                setState(() => _section = section);
              },
            ),
            _ClaimSectionBody(section: _section, claim: claim),
            _NotificationsCard(
              enabled: notificationsEnabled,
              onChanged: (value) {
                unawaited(HapticFeedback.selectionClick());
                setState(() {
                  _notificationsEnabled = value;
                  _feedback = value
                      ? 'Đã bật thông báo claim'
                      : 'Đã tắt thông báo claim';
                });
              },
            ),
            _ActionRow(
              key: P2PClaimDetailPage.orderLinkKey,
              icon: Icons.open_in_new_rounded,
              title: 'Xem đơn hàng gốc',
              onTap: () {
                unawaited(HapticFeedback.selectionClick());
                context.go(snapshot.orderRoute);
              },
            ),
            _ActionRow(
              key: P2PClaimDetailPage.supportLinkKey,
              icon: Icons.help_outline_rounded,
              title: 'Liên hệ hỗ trợ',
              onTap: () {
                unawaited(HapticFeedback.selectionClick());
                context.go(snapshot.supportRoute);
              },
            ),
            if (_feedback != null) _FeedbackBanner(message: _feedback!),
            if (claim.status == P2PInsuranceClaimStatus.paid)
              VitCtaButton(
                key: P2PClaimDetailPage.receiptKey,
                variant: VitCtaButtonVariant.success,
                density: VitDensity.compact,
                leading: const Icon(Icons.download_rounded),
                onPressed: () {
                  unawaited(HapticFeedback.selectionClick());
                  setState(
                    () => _feedback = 'Đã chuẩn bị biên lai ${claim.claimCode}',
                  );
                },
                child: const Text('Tải biên lai'),
              ),
            const VitHighRiskStatePanel(
              density: VitDensity.compact,
              state: VitHighRiskUiState.riskReview,
              title: 'Xem lại chi tiết claim',
              message:
                  'Trạng thái claim, số tiền bảo hiểm, bằng chứng, thông báo, biên lai và bước hỗ trợ tiếp theo được xem lại trước thao tác tiếp.',
              contractId: 'p2p-claim-detail-review',
            ),
          ],
        );
      },
    );
  }
}

class _ClaimHeroCard extends StatelessWidget {
  const _ClaimHeroCard({required this.claim});

  final P2PClaimDetailDraft claim;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PClaimDetailPage.heroKey,
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pClaimHeroPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              VitStatusPill(
                label: claim.statusLabel,
                status: _statusPill(claim.status),
                icon: _statusIcon(claim.status),
                size: VitStatusPillSize.lg,
              ),
              const SizedBox(width: AppSpacing.x2),
              VitStatusPill(
                label: claim.claimCode,
                status: VitStatusPillStatus.neutral,
                icon: Icons.content_copy_rounded,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _ClaimProgress(status: claim.status),
          const Divider(
            height: _p2pClaimDividerExtent,
            color: AppColors.divider,
          ),
          VitInfoRow(
            label: 'Lệnh P2P',
            value: claim.orderId,
            valueColor: AppModuleAccents.p2p,
            density: VitDensity.compact,
            trailing: const Icon(
              Icons.open_in_new_rounded,
              color: AppModuleAccents.p2p,
              size: P2PSpacingTokens.p2pClaimInlineIcon,
            ),
          ),
          VitInfoRow(
            label: 'Lý do',
            value: claim.reason,
            density: VitDensity.compact,
          ),
          VitInfoRow(
            label: 'Số tiền yêu cầu',
            value: '${_formatVnd(claim.amount)} đ',
            density: VitDensity.compact,
          ),
          VitInfoRow(
            label: 'Tỷ lệ bảo hiểm',
            value: '${claim.coveragePct}%',
            valueColor: AppModuleAccents.p2p,
            density: VitDensity.compact,
          ),
          const Divider(
            height: _p2pClaimDividerExtent,
            color: AppColors.divider,
          ),
          if (claim.paidAmount != null)
            VitInfoRow(
              label: claim.statusLabel,
              value: '${_formatVnd(claim.paidAmount!)} đ',
              valueColor: AppColors.buy,
              density: VitDensity.compact,
            ),
          VitInfoRow(
            label: 'Ngày gửi',
            value: claim.submittedAt,
            density: VitDensity.compact,
          ),
        ],
      ),
    );
  }
}

class _ClaimProgress extends StatelessWidget {
  const _ClaimProgress({required this.status});

  final P2PInsuranceClaimStatus status;

  @override
  Widget build(BuildContext context) {
    final steps = const ['Gửi', 'Xem xét', 'Duyệt', 'Chi trả'];
    final activeIndex = switch (status) {
      P2PInsuranceClaimStatus.pending => 0,
      P2PInsuranceClaimStatus.reviewing => 1,
      P2PInsuranceClaimStatus.approved => 2,
      P2PInsuranceClaimStatus.paid => 3,
      P2PInsuranceClaimStatus.rejected => 1,
    };

    return Column(
      children: [
        Row(
          children: [
            for (var i = 0; i < steps.length; i++) ...[
              Expanded(
                child: ClipRRect(
                  borderRadius: AppRadii.xsRadius,
                  child: SizedBox(
                    height: _p2pClaimProgressLineExtent,
                    child: ColoredBox(
                      color: i <= activeIndex
                          ? _stepColor(i)
                          : AppColors.surface3,
                    ),
                  ),
                ),
              ),
              if (i != steps.length - 1) const SizedBox(width: AppSpacing.x3),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Row(
          children: [
            for (var i = 0; i < steps.length; i++)
              Expanded(
                child: Text(
                  steps[i],
                  textAlign: TextAlign.center,
                  style: AppTextStyles.micro.copyWith(
                    color: i <= activeIndex ? _stepColor(i) : AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _ClaimBenchmarksCard extends StatelessWidget {
  const _ClaimBenchmarksCard({required this.snapshot});

  final P2PClaimDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PClaimDetailPage.benchmarksKey,
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pClaimCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VitSectionHeader(
            title: 'So sánh với nền tảng',
            bottomGap: AppSpacing.pageRhythmStandardInnerGap,
            icon: Icons.bar_chart_rounded,
            iconColor: AppColors.accent,
            density: VitDensity.compact,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'So sánh claim của bạn với 847 claims đã xử lý',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          for (var i = 0; i < snapshot.benchmarks.length; i++) ...[
            if (i > 0)
              const Divider(
                height: _p2pClaimDividerExtent,
                color: AppColors.divider,
              ),
            _BenchmarkMetricRow(benchmark: snapshot.benchmarks[i]),
          ],
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          const VitSectionHeader(
            title: 'Phân bổ lý do claim',
            bottomGap: AppSpacing.pageRhythmStandardInnerGap,
            icon: Icons.groups_outlined,
            density: VitDensity.compact,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (final row in snapshot.reasonShares) ...[
            _ReasonShareRow(row: row),
            if (row != snapshot.reasonShares.last)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          const Row(
            children: [
              Expanded(
                child: _MiniStatTile(
                  label: 'Tỷ lệ duyệt chung',
                  value: '78.5%',
                ),
              ),
              SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MiniStatTile(label: 'Xử lý nhanh nhất', value: '4h'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BenchmarkMetricRow extends StatelessWidget {
  const _BenchmarkMetricRow({required this.benchmark});

  final P2PClaimBenchmarkDraft benchmark;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(benchmark.toneKey);
    return Padding(
      padding: P2PSpacingTokens.p2pClaimInfoRowPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                _benchmarkIcon(benchmark.id),
                color: AppColors.text3,
                size: P2PSpacingTokens.p2pClaimBenchmarkIcon,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  benchmark.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                benchmark.comparison,
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            benchmark.value,
            style: AppTextStyles.baseMedium.copyWith(
              color: benchmark.toneKey == 'primary' ? AppColors.text1 : color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          VitProgressBar(
            progress: benchmark.progress,
            color: color,
            height: _p2pClaimProgressLineExtent,
            trackColor: AppColors.surface3,
            borderRadius: AppRadii.xsRadius,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            benchmark.caption,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}
