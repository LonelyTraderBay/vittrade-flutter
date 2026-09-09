import 'package:vit_trade_flutter/features/cross_module/domain/entities/cross_module_analytics_entities.dart';
import 'package:vit_trade_flutter/features/cross_module/domain/repositories/cross_module_analytics_repository.dart';

final class MockCrossModuleAnalyticsRepository
    implements CrossModuleAnalyticsRepository {
  const MockCrossModuleAnalyticsRepository({
    this.simulateError = false,
    this.loadDelay = const Duration(milliseconds: 300),
  });

  final bool simulateError;
  final Duration loadDelay;

  Future<void> _simulateNetwork() async {
    if (loadDelay > Duration.zero) {
      await Future<void>.delayed(loadDelay);
    }
    if (simulateError) {
      throw StateError('cross_module_analytics_mock_fetch_failed');
    }
  }

  @override
  Future<CrossModuleAnalyticsSnapshot> getAnalytics() async {
    await _simulateNetwork();
    return const CrossModuleAnalyticsSnapshot(
      endpoint: '/api/mobile/cross-module/cross-module-analytics',
      actionDraft: 'read-only or local navigation action',
      title: 'Cross-Module Analytics',
      backRoute: '/home',
      tabs: [
        CrossModuleAnalyticsTabDraft(
          tab: CrossModuleAnalyticsTab.performance,
          label: 'Hieu suat',
        ),
        CrossModuleAnalyticsTabDraft(
          tab: CrossModuleAnalyticsTab.metrics,
          label: 'Chi so',
        ),
        CrossModuleAnalyticsTabDraft(
          tab: CrossModuleAnalyticsTab.comparison,
          label: 'So sanh',
        ),
      ],
      modules: [
        CrossModuleMetricDraft(
          id: AnalyticsModuleId.trading,
          name: 'Giao dịch Spot',
          roi: 12.5,
          totalTrades: 245,
          winRate: 62,
          avgTradeSize: 850,
          totalVolume: 208250,
          activeTimeHours: 48,
          riskScore: 65,
        ),
        CrossModuleMetricDraft(
          id: AnalyticsModuleId.p2p,
          name: 'Giao dịch P2P',
          roi: 1.2,
          totalTrades: 28,
          winRate: 96,
          avgTradeSize: 1200,
          totalVolume: 33600,
          activeTimeHours: 12,
          riskScore: 35,
        ),
        CrossModuleMetricDraft(
          id: AnalyticsModuleId.predictions,
          name: 'Thị trường dự đoán',
          roi: 18.3,
          totalTrades: 87,
          winRate: 58,
          avgTradeSize: 320,
          totalVolume: 27840,
          activeTimeHours: 24,
          riskScore: 72,
        ),
        CrossModuleMetricDraft(
          id: AnalyticsModuleId.dca,
          name: 'Chiến lược DCA',
          roi: 9.8,
          totalTrades: 12,
          winRate: 100,
          avgTradeSize: 1000,
          totalVolume: 12000,
          activeTimeHours: 6,
          riskScore: 25,
        ),
      ],
      monthlyPerformance: [
        CrossModuleMonthlyPerformanceDraft(
          month: 'Jan',
          trading: 8,
          p2p: 1,
          predictions: 15,
          dca: 9,
        ),
        CrossModuleMonthlyPerformanceDraft(
          month: 'Feb',
          trading: 10,
          p2p: 1.5,
          predictions: 12,
          dca: 9.5,
        ),
        CrossModuleMonthlyPerformanceDraft(
          month: 'Mar',
          trading: 9,
          p2p: .8,
          predictions: 20,
          dca: 10,
        ),
        CrossModuleMonthlyPerformanceDraft(
          month: 'Apr',
          trading: 11,
          p2p: 1.2,
          predictions: 16,
          dca: 9.8,
        ),
        CrossModuleMonthlyPerformanceDraft(
          month: 'May',
          trading: 13,
          p2p: 1.4,
          predictions: 19,
          dca: 10.2,
        ),
        CrossModuleMonthlyPerformanceDraft(
          month: 'Jun',
          trading: 12.5,
          p2p: 1.2,
          predictions: 18.3,
          dca: 9.8,
        ),
      ],
      contractNotes:
          'Cross-module analytics compares value-based modules only. Open Arena is points-only and stays outside financial analytics.',
      supportedStates: {
        CrossModuleAnalyticsScreenState.loading,
        CrossModuleAnalyticsScreenState.empty,
        CrossModuleAnalyticsScreenState.error,
        CrossModuleAnalyticsScreenState.offline,
        CrossModuleAnalyticsScreenState.realtimeRefresh,
      },
    );
  }
}
