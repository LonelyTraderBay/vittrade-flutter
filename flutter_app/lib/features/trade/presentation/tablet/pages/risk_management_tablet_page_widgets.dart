part of 'risk_management_tablet_page.dart';

// Padding dùng lại trong library (part của trang SC-060).
const EdgeInsets _cardPad = EdgeInsets.all(TabletSpacingTokens.x4);
const EdgeInsets _rowPadV = EdgeInsets.symmetric(
  vertical: TabletSpacingTokens.x2,
);
const EdgeInsets _positionPad = EdgeInsets.symmetric(
  horizontal: TabletSpacingTokens.x3,
  vertical: TabletSpacingTokens.x3,
);

/// Các card nội dung của bảng Quản lý rủi ro tablet (SC-060) — tách khỏi
/// page để giữ page dưới ngưỡng 600 dòng (size-debt guardrail).

/// Hàng tính năng: icon accent box + tiêu đề + mô tả, cả hàng bấm được.
class _RiskFeatureRow extends StatelessWidget {
  const _RiskFeatureRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
    this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VitAccentIconBox(icon: icon, color: color),
          const SizedBox(width: TabletSpacingTokens.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                    color: AppColors.text1,
                  ),
                ),
                const SizedBox(height: TabletSpacingTokens.x1),
                Text(
                  description,
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
    );
  }
}

/// Tab OCO inline: bảng tham số lệnh mẫu + nút gửi (xem trước trước khi gửi
/// nằm ở panel rủi ro phía trên).
class _OcoCard extends StatelessWidget {
  const _OcoCard({required this.onSubmit});

  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: _cardPad,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Lệnh OCO · BTC/USDT · Mua',
            style: AppTextStyles.control.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x3),
          for (final (label, value) in [
            ('Giá giới hạn', formatTradePrice(69000)),
            ('Chốt lời', formatTradePrice(72000)),
            ('Dừng lỗ', formatTradePrice(66000)),
            ('Khối lượng', '0.015 BTC'),
          ])
            Padding(
              padding: _rowPadV,
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
                    value,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: TabletSpacingTokens.x3),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: VitCtaButton(
              fullWidth: false,
              onPressed: onSubmit,
              child: const Text('Gửi lệnh OCO'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bảng vị thế bảo vệ: cặp | hướng | giá vào | giá hiện tại | PnL.
class _PositionsCard extends StatelessWidget {
  const _PositionsCard({required this.positions});

  final List<TradeRiskPosition> positions;

  @override
  Widget build(BuildContext context) {
    if (positions.isEmpty) {
      return const VitEmptyState(
        icon: Icons.shield_outlined,
        title: 'Chưa có vị thế bảo vệ',
        message: 'Vị thế mở sẽ hiện tại đây cùng PnL dự kiến.',
      );
    }
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.zeroInsets,
      clip: true,
      child: Column(
        children: [
          for (var i = 0; i < positions.length; i++) ...[
            _PositionRow(position: positions[i]),
            if (i < positions.length - 1)
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

class _PositionRow extends StatelessWidget {
  const _PositionRow({required this.position});

  final TradeRiskPosition position;

  @override
  Widget build(BuildContext context) {
    final positive = position.pnl >= 0;
    return Padding(
      padding: _positionPad,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text.rich(
              TextSpan(
                text: position.side == TradeRiskPositionSide.long
                    ? 'LONG '
                    : 'SHORT ',
                style: AppTextStyles.caption.copyWith(
                  color: position.side == TradeRiskPositionSide.long
                      ? AppColors.buy
                      : AppColors.sell,
                  fontWeight: AppTextStyles.bold,
                ),
                children: [
                  TextSpan(
                    text: position.symbol,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              formatTradePrice(position.entryPrice),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              formatTradePrice(position.currentPrice),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              formatTradeSignedUsdRounded(position.pnl),
              style: AppTextStyles.caption.copyWith(
                color: positive ? AppColors.buy : AppColors.sell,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tab máy tính khối lượng: tham số đầu vào mẫu + kết quả gợi ý.
class _CalculatorCard extends StatelessWidget {
  const _CalculatorCard({required this.onApply});

  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: _cardPad,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Máy tính khối lượng · Rủi ro 1%',
            style: AppTextStyles.control.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x3),
          for (final (label, value) in [
            ('Số dư', formatTradeUsd(50000)),
            ('Giá vào lệnh', formatTradePrice(69000)),
            ('Giá dừng', formatTradePrice(67500)),
          ])
            Padding(
              padding: _rowPadV,
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
                    value,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: TabletSpacingTokens.x3),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: VitCtaButton(
              fullWidth: false,
              onPressed: onApply,
              child: const Text('Tính và áp dụng'),
            ),
          ),
        ],
      ),
    );
  }
}
