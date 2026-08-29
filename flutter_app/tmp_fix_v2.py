# -*- coding: utf-8 -*-
"""V2 fixes: toolbar 2 hàng trong panel (chống tràn cột hẹp) + Mid ellipsis."""
import io

# 1. Chart toolbar: tách 2 hàng — hàng interval + hàng indicator; bỏ divider dọc.
p = 'lib/features/markets/presentation/widgets/tablet/markets_pair_detail_pane_chart.dart'
src = io.open(p, encoding='utf-8').read()

old = '''          Padding(
            padding: MarketsSpacingTokens.pairChartToolbarPadding,
            child: Row(
              children: [
                for (final tf in ['15m', '1H', '4H', '1D', '1W', '1M']) ...[
                  _PairIntervalButton(
                    label: tf,
                    active: tf == timeframe,
                    onTap: () => onTimeframeChanged(tf),
                  ),
                  const SizedBox(width: MarketsSpacingTokens.pairIntervalGap),
                ],
                Container(
                  width: AppSpacing.hairlineStroke,
                  height: MarketsSpacingTokens.pairIntervalDividerHeight,
                  color: AppColors.divider,
                ),
                const SizedBox(width: MarketsSpacingTokens.pairIntervalGap),
                for (final item in ['MA', 'Vol']) ...[
                  _PairIndicatorButton(
                    label: item,
                    active: indicators.contains(item),
                    onTap: () => onIndicatorToggle(item),
                  ),
                  const SizedBox(width: MarketsSpacingTokens.pairIntervalGap),
                ],
                _PairIndicatorButton(
                  label: 'Nâng cao',
                  active: true,
                  warning: true,
                  onTap: onAdvanced,
                ),
              ],
            ),
          ),'''
new = '''          Padding(
            padding: MarketsSpacingTokens.pairChartToolbarPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hàng 1: khung giờ — 6 nút text phẳng (không pill).
                Row(
                  children: [
                    for (final tf
                        in ['15m', '1H', '4H', '1D', '1W', '1M']) ...[
                      _PairIntervalButton(
                        label: tf,
                        active: tf == timeframe,
                        onTap: () => onTimeframeChanged(tf),
                      ),
                      const SizedBox(
                        width: MarketsSpacingTokens.pairIntervalGap,
                      ),
                    ],
                  ],
                ),
                // Hàng 2: chỉ báo MA/Vol + Nâng cao — cùng panel, gọn dưới
                // hàng khung giờ (cột desk ~400dp không đủ 1 hàng cho tất
                // cả; Binance-mobile cũng dùng 2 hàng trong header chart).
                Row(
                  children: [
                    for (final item in ['MA', 'Vol']) ...[
                      _PairIndicatorButton(
                        label: item,
                        active: indicators.contains(item),
                        onTap: () => onIndicatorToggle(item),
                      ),
                      const SizedBox(
                        width: MarketsSpacingTokens.pairIntervalGap,
                      ),
                    ],
                    _PairIndicatorButton(
                      label: 'Nâng cao',
                      active: true,
                      warning: true,
                      onTap: onAdvanced,
                    ),
                  ],
                ),
              ],
            ),
          ),'''
assert old in src, 'toolbar'
src = src.replace(old, new)
io.open(p, 'w', encoding='utf-8', newline='').write(src)

# 2. Book panel: Mid text nằm trong Expanded + ellipsis (chống tràn 300dp).
p2 = 'lib/features/markets/presentation/widgets/tablet/markets_pair_detail_pane_sections.dart'
src2 = io.open(p2, encoding='utf-8').read()
old2 = '''                const Spacer(),
                Text(
                  'Mid \${formatMarketPriceFixed2(widget.snapshot.depth.midPrice)}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),'''
new2 = '''                const Spacer(),
                Expanded(
                  child: Text(
                    'Mid \${formatMarketPriceFixed2(widget.snapshot.depth.midPrice)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                    ),
                  ),
                ),'''
assert old2 in src2, 'mid'
src2 = src2.replace(old2, new2)
io.open(p2, 'w', encoding='utf-8', newline='').write(src2)
print('OK both fixes')
