part of '../../phone/pages/hub/trading_bots_page.dart';

(String, Color, Color) _riskStyle(TradeBotRisk risk) {
  return switch (risk) {
    TradeBotRisk.low => (
      'Thấp',
      AppColors.buy.withValues(alpha: .12),
      AppColors.buy,
    ),
    TradeBotRisk.medium => (
      'Trung bình',
      AppColors.warn.withValues(alpha: .12),
      AppColors.warn,
    ),
    TradeBotRisk.high => (
      'Cao',
      AppColors.sell.withValues(alpha: .10),
      AppColors.sell,
    ),
  };
}

VitStatusPillStatus _riskStatus(TradeBotRisk risk) {
  return switch (risk) {
    TradeBotRisk.low => VitStatusPillStatus.success,
    TradeBotRisk.medium => VitStatusPillStatus.warning,
    TradeBotRisk.high => VitStatusPillStatus.error,
  };
}

String _formatWholeNumber(double value) => VitFormat.count(value.round());

String _formatSignedMoney(double value) => VitFormat.usdSigned(value);
