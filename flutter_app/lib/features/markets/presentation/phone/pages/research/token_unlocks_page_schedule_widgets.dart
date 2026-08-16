part of 'token_unlocks_page.dart';

class _DilutionRow extends StatelessWidget {
  const _DilutionRow({required this.index, required this.unlock});

  final int index;
  final TokenUnlockDraft unlock;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: MarketsSpacingTokens.tokenUnlocksDilutionRowPadding,
      child: Row(
        children: [
          SizedBox(
            width: MarketsSpacingTokens.tokenUnlocksDilutionRankWidth,
            child: Text(
              '${index + 1}',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          const SizedBox(
            width: MarketsSpacingTokens.tokenUnlocksDilutionRankGap,
          ),
          _TokenAvatar(
            unlock: unlock,
            size: MarketsSpacingTokens.tokenUnlocksAvatarSm,
          ),
          const SizedBox(width: MarketsSpacingTokens.tokenUnlocksCardGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  unlock.symbol,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  '${unlock.daysUntil} ngày nữa',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${unlock.unlockPctCirculating.toStringAsFixed(1)}%',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.sell,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(
                'lưu thông',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UnlockWarningCard extends StatelessWidget {
  const _UnlockWarningCard();

  @override
  Widget build(BuildContext context) {
    return const VitBanner(
      variant: VitBannerVariant.warning,
      icon: Icons.warning_amber_rounded,
      message: 'Lưu ý quan trọng',
      detail:
          'Token unlock không đồng nghĩa token sẽ bị bán. Tuy nhiên, unlock lớn thường tạo áp lực bán tiềm ẩn. Dữ liệu chỉ mang tính tham khảo.',
    );
  }
}

class _ScheduleList extends StatelessWidget {
  const _ScheduleList({required this.snapshot});

  final MarketTokenUnlocksSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final unlocks = [...snapshot.unlocks]
      ..sort((a, b) => a.daysUntil.compareTo(b.daysUntil));

    return Column(
      children: [
        for (final unlock in unlocks) ...[
          _ScheduleCard(
            unlock: unlock,
            categoryConfig: snapshot.categoryConfigs[unlock.category]!,
          ),
          if (unlock != unlocks.last)
            const SizedBox(height: _unlockScheduleGap),
        ],
      ],
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({required this.unlock, required this.categoryConfig});

  final TokenUnlockDraft unlock;
  final UnlockCategoryConfig categoryConfig;

  @override
  Widget build(BuildContext context) {
    final supplyPct = unlock.circulatingSupply / unlock.totalSupply;

    return VitCard(
      padding: MarketsSpacingTokens.tokenUnlocksScheduleCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _TokenAvatar(
                unlock: unlock,
                size: MarketsSpacingTokens.tokenUnlocksAvatarMd,
              ),
              const SizedBox(width: MarketsSpacingTokens.tokenUnlocksCardGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          unlock.symbol,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(width: _unlockScheduleGap),
                        _TinyBadge(
                          label: _shortVestingTypeLabel(unlock.vestingType),
                          color: categoryConfig.color.resolve(),
                        ),
                      ],
                    ),
                    Text(
                      unlock.name,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatPriceUsd(unlock.currentPrice),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  Text(
                    '${_formatPct(unlock.priceChange7d)} 7d',
                    style: AppTextStyles.micro.copyWith(
                      color: unlock.priceChange7d >= 0
                          ? AppColors.buy
                          : AppColors.sell,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: _unlockScheduleSupplyGap),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Lưu thông / Tổng cung',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              Text(
                '${(supplyPct * 100).toStringAsFixed(1)}%',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
            ],
          ),
          const SizedBox(height: _unlockScheduleProgressGap),
          ClipRRect(
            borderRadius: AppRadii.xsRadius,
            child: LinearProgressIndicator(
              value: supplyPct,
              minHeight: _unlockCategoryProgressHeight,
              backgroundColor: AppColors.surface2,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppAssetColors.forSymbol(unlock.symbol),
              ),
            ),
          ),
          const SizedBox(height: _unlockScheduleTitleGap),
          Text(
            'Lịch mở khóa',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: _unlockScheduleGap),
          for (var index = 0; index < unlock.vestingSchedule.length; index += 1)
            _VestingEventRow(
              event: unlock.vestingSchedule[index],
              color: AppAssetColors.forSymbol(unlock.symbol),
              isFirst: index == 0,
              isLast: index == unlock.vestingSchedule.length - 1,
            ),
        ],
      ),
    );
  }
}

class _VestingEventRow extends StatelessWidget {
  const _VestingEventRow({
    required this.event,
    required this.color,
    required this.isFirst,
    required this.isLast,
  });

  final TokenVestingEventDraft event;
  final Color color;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: MarketsSpacingTokens.tokenUnlocksVestingMarker / 2,
                backgroundColor: isFirst ? color : color.withValues(alpha: .12),
                child: Icon(
                  isFirst ? Icons.lock_open_rounded : Icons.lock_rounded,
                  size: isFirst
                      ? MarketsSpacingTokens.tokenUnlocksVestingIconOpen
                      : MarketsSpacingTokens.tokenUnlocksVestingIconLocked,
                  color: isFirst ? AppColors.text1 : color,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: SizedBox(
                    width: MarketsSpacingTokens.tokenUnlocksVestingLine,
                    child: ColoredBox(color: color.withValues(alpha: .12)),
                  ),
                ),
            ],
          ),
          const SizedBox(
            width: MarketsSpacingTokens.tokenUnlocksVestingContentGap,
          ),
          Expanded(
            child: Padding(
              padding: isLast
                  ? AppSpacing.zeroInsets
                  : MarketsSpacingTokens.tokenUnlocksVestingEventPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          event.date,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      Text(
                        '${event.pct.toStringAsFixed(1)}%',
                        style: AppTextStyles.caption.copyWith(
                          color: event.pct > 5
                              ? AppColors.sell
                              : event.pct > 2
                              ? AppColors.warn
                              : AppColors.buy,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    event.label,
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

class _TokenAvatar extends StatelessWidget {
  const _TokenAvatar({required this.unlock, required this.size});

  final TokenUnlockDraft unlock;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = AppAssetColors.forSymbol(unlock.symbol);
    return VitAssetAvatar(
      label: unlock.symbol,
      accentColor: color,
      size: size,
      radius: AppRadii.avatarRadius,
      maxChars: 2,
      fillAlpha: .14,
    );
  }
}

class _TinyBadge extends StatelessWidget {
  const _TinyBadge({
    required this.label,
    required this.color,
    this.bold = false,
  });

  final String label;
  final Color color;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(
      label: label,
      accentColor: color,
      size: VitStatusPillSize.sm,
      semanticStatus: bold ? VitStatusPillStatus.warning : null,
    );
  }
}
