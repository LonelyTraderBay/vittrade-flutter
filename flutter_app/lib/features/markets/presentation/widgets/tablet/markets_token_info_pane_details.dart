part of 'markets_token_info_pane.dart';

// Copy chuẩn widget của part family Phone (`token_info_market_widgets.dart` /
// `token_info_detail_widgets.dart`) phần ATH/ATL + ChartLink + On-chain +
// Dự án — cùng quy tắc port: chuỗi đủ dấu, gap token đổi rhythm token.

class _DonutPainter extends CustomPainter {
  const _DonutPainter(this.distribution);

  final List<SupplyDistributionDraft> distribution;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    var start = -math.pi / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.butt;
    for (final item in distribution) {
      final sweep = math.pi * 2 * (item.percentage / 100);
      canvas.drawArc(
        rect.deflate(8),
        start,
        sweep,
        false,
        paint..color = item.color.resolve(),
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.distribution != distribution;
  }
}

class _AthAtlCards extends StatelessWidget {
  const _AthAtlCards({
    required this.fundamentals,
    required this.athDropPct,
    required this.atlGainPct,
  });

  final TokenFundamentalsDraft fundamentals;
  final double athDropPct;
  final double atlGainPct;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _PriceRecordCard(
            label: 'ATH',
            icon: Icons.trending_up_rounded,
            color: AppColors.buy,
            value: formatMarketPriceFixed2(fundamentals.allTimeHigh),
            date: fundamentals.allTimeHighDate,
            delta: '${athDropPct.toStringAsFixed(1)}% so với ATH',
            deltaColor: AppColors.sell,
          ),
        ),
        const SizedBox(width: AppSpacing.pageRhythmCompactInnerGap),
        Expanded(
          child: _PriceRecordCard(
            label: 'ATL',
            icon: Icons.trending_down_rounded,
            color: AppColors.sell,
            value: formatMarketPriceFixed2(fundamentals.allTimeLow),
            date: fundamentals.allTimeLowDate,
            delta: '+${atlGainPct.toStringAsFixed(1)}% so với ATL',
            deltaColor: AppColors.buy,
          ),
        ),
      ],
    );
  }
}

class _PriceRecordCard extends StatelessWidget {
  const _PriceRecordCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.value,
    required this.date,
    required this.delta,
    required this.deltaColor,
  });

  final String label;
  final IconData icon;
  final Color color;
  final String value;
  final String date;
  final String delta;
  final Color deltaColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
      borderColor: color.withValues(alpha: 0.12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: AppSpacing.iconSm, color: color),
              const SizedBox(width: AppSpacing.x1),
              Text(
                label,
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          Text(
            date,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            delta,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: deltaColor,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartLink extends StatelessWidget {
  const _ChartLink({required this.pairId});

  final String pairId;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: MarketsTabletKeys.tokenChartLink,
      onTap: () =>
          openMarketsDetailRoute(context, AppRoutePaths.pairDetail(pairId)),
      padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.buttonCompact,
            height: AppSpacing.buttonCompact,
            child: Material(
              // Surface lồng trong card 16 — quy tắc khung lồng −8 ⇒ 8.
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: AppRadii.smRadius,
              child: const Icon(
                Icons.bar_chart_rounded,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Xem biểu đồ & giao dịch',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Chart, sổ lệnh, giao dịch gần đây',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.text3),
        ],
      ),
    );
  }
}

class _OnchainTab extends StatelessWidget {
  const _OnchainTab({required this.snapshot});

  final MarketTokenInfoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final f = snapshot.fundamentals;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.bolt_rounded,
                    color: AppColors.buy,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.pageRhythmCompactInnerGap),
                  Text(
                    'Hoạt động mạng lưới (24h)',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              Row(
                children: [
                  Expanded(
                    child: _MiniStat(
                      label: 'Địa chỉ hoạt động',
                      value: formatMarketCompact(
                        f.activeAddresses24h.toDouble(),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.pageRhythmCompactInnerGap),
                  Expanded(
                    child: _MiniStat(
                      label: 'Giao dịch',
                      value: formatMarketCompact(f.txCount24h.toDouble()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Row(
                children: [
                  Expanded(
                    child: _MiniStat(
                      label: 'Tổng holders',
                      value: formatMarketCompact(f.holders.toDouble()),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.pageRhythmCompactInnerGap),
                  Expanded(
                    child: _MiniStat(
                      label: 'TVL',
                      value: f.tvl == null
                          ? 'Không có'
                          : formatMarketCompact(f.tvl!, prefix: r'$'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactSectionGap),
        const VitSectionHeader(
          title: 'Thông tin mạng lưới',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          accentColor: AppColors.primary,
          variant: VitSectionHeaderVariant.accentBar,
        ),
        _InfoCard(
          rows: [
            _InfoRowData(
              icon: Icons.public_rounded,
              iconColor: AppColors.primary,
              label: 'Mạng lưới',
              value: f.network,
            ),
            _InfoRowData(
              icon: Icons.shield_rounded,
              iconColor: AppColors.accent,
              label: 'Đồng thuận',
              value: f.consensus,
            ),
            const _InfoRowData(
              icon: Icons.info_outline_rounded,
              iconColor: AppColors.warn,
              label: 'Hợp đồng token',
              value: 'Blockchain gốc',
            ),
          ],
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            style: AppTextStyles.amountSm.copyWith(
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectTab extends StatelessWidget {
  const _ProjectTab({required this.snapshot});

  final MarketTokenInfoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final f = snapshot.fundamentals;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.article_outlined,
                    color: AppColors.primary,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.pageRhythmCompactInnerGap),
                  Text(
                    'Giới thiệu',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(f.description, style: AppTextStyles.body),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactSectionGap),
        const VitSectionHeader(
          title: 'Liên kết',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          accentColor: AppColors.primary,
          variant: VitSectionHeaderVariant.accentBar,
        ),
        _ProjectLinks(fundamentals: f),
        const SizedBox(height: AppSpacing.pageRhythmCompactSectionGap),
        const VitSectionHeader(
          title: 'Chỉ số quan trọng',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          accentColor: AppColors.buy,
          variant: VitSectionHeaderVariant.accentBar,
        ),
        _InfoCard(
          rows: [
            _InfoRowData(
              icon: Icons.bar_chart_rounded,
              iconColor: AppColors.primary,
              label: 'Vốn hóa',
              value: formatMarketCompact(snapshot.pair.marketCap, prefix: r'$'),
            ),
            _InfoRowData(
              icon: Icons.layers_rounded,
              iconColor: AppColors.accent,
              label: 'FDV',
              value: formatMarketCompact(f.fullyDilutedValuation, prefix: r'$'),
            ),
            _InfoRowData(
              icon: Icons.token_rounded,
              iconColor: AppColors.warn,
              label: 'Cung lưu hành',
              value: '${formatMarketCompact(f.circulatingSupply)} ${f.symbol}',
            ),
          ],
        ),
      ],
    );
  }
}

class _ProjectLinks extends StatelessWidget {
  const _ProjectLinks({required this.fundamentals});

  final TokenFundamentalsDraft fundamentals;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LinkRow(
          icon: Icons.public_rounded,
          label: 'Website',
          value: fundamentals.website,
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        _LinkRow(
          icon: Icons.description_outlined,
          label: 'Whitepaper',
          value: fundamentals.whitepaper,
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        _LinkRow(
          icon: Icons.code_rounded,
          label: 'GitHub',
          value: fundamentals.github,
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        _LinkRow(
          icon: Icons.alternate_email_rounded,
          label: 'Twitter',
          value: fundamentals.twitter,
        ),
      ],
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: AppSpacing.iconSm + AppSpacing.x1,
          ),
          const SizedBox(width: AppSpacing.pageRhythmCompactInnerGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
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
    );
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer();

  @override
  Widget build(BuildContext context) {
    // VitBanner thay cho khối Material + BorderSide tự vẽ của Phone —
    // tablet files không được giữ raw BorderSide (chuẩn card-border R1–R3).
    return const VitBanner(
      variant: VitBannerVariant.warning,
      icon: Icons.info_outline_rounded,
      message: 'Thông tin mang tính tham khảo, không phải lời khuyên đầu tư.',
      detail: 'Hãy tự nghiên cứu trước khi đưa ra quyết định.',
    );
  }
}
