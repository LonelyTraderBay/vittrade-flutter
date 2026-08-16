part of '../../phone/pages/execution/execution_venue_analysis_page.dart';

String _formatSpeed(double value) {
  if (value == .3 || value == .4 || value == .5) {
    return value.toStringAsFixed(1);
  }
  return value.toStringAsFixed(2);
}

String _formatInt(num value) => formatTradeInt(value.round());

String _formatUsd(double value) => formatTradeUsdWhole(value);
