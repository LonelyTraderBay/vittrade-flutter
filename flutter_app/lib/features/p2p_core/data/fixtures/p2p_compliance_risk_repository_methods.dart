part of '../repositories/mock_p2p_repository.dart';

mixin _MockP2PRepositoryComplianceRiskMethods on _MockP2PRepositoryBase {
  @override
  Future<P2PLimitTrackerSnapshot> getLimitTracker() async {
    await _simulateNetwork();
    return const P2PLimitTrackerSnapshot(
      endpoint: '/api/mobile/p2p/p2p-limits-tracker',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      title: 'Limit Tracker',
      subtitle: 'Hạn mức · P2P',
      usages: _p2pLimitTrackerUsages,
      breakdown: _p2pLimitTrackerBreakdown,
      parentRoute: '/p2p/limits',
      emptyTitle: 'Chưa có dữ liệu hạn mức P2P',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  Future<P2PTransactionLimitsSnapshot> getTransactionLimits() async {
    await _simulateNetwork();
    return const P2PTransactionLimitsSnapshot(
      endpoint: '/api/mobile/p2p/p2p-limits',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      title: 'Transaction Limits',
      subtitle: 'Hạn mức · P2P',
      currentTier: _p2pTransactionLimitTier1,
      nextTier: _p2pTransactionLimitTier2,
      usageItems: _p2pTransactionLimitUsages,
      detailItems: _p2pTransactionLimitDetails,
      infoBullets: _p2pTransactionLimitInfoBullets,
      parentRoute: '/p2p',
      trackerRoute: '/p2p/limits/tracker',
      kycRequirementsRoute: '/p2p/kyc/requirements',
      emptyTitle: 'Chưa có dữ liệu hạn mức giao dịch P2P',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  Future<P2PComplianceOverviewSnapshot> getComplianceOverview() async {
    await _simulateNetwork();
    return const P2PComplianceOverviewSnapshot(
      endpoint: '/api/mobile/p2p/p2p-compliance-overview',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      title: 'Compliance Overview',
      subtitle: 'Tuân thủ · P2P',
      heroTitle: 'Compliance Active',
      heroSubtitle: 'Tài khoản tuân thủ đầy đủ quy định',
      items: _p2pComplianceOverviewItems,
      parentRoute: '/p2p',
      emptyTitle: 'Chưa có dữ liệu tuân thủ P2P',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  Future<P2PAmlScreeningSnapshot> getAmlScreening() async {
    await _simulateNetwork();
    return const P2PAmlScreeningSnapshot(
      endpoint: '/api/mobile/p2p/p2p-compliance-aml-screening',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      title: 'AML Screening',
      subtitle: 'Tuân thủ · P2P',
      statusLabel: 'AML Status: Clear',
      statusDescription: 'Tài khoản đã qua kiểm tra AML',
      lastCheckLabel: 'Kiểm tra gần nhất',
      lastCheckAt: '2026-03-05 10:00',
      nextCheckLabel: 'Kiểm tra tiếp theo',
      nextCheckAt: '2026-03-12 10:00',
      checks: _p2pAmlScreeningChecks,
      infoTitle: 'Về AML Screening',
      infoBody:
          'Chúng tôi thực hiện kiểm tra AML định kỳ để tuân thủ quy định chống rửa tiền. Nếu có vấn đề, team Compliance sẽ liên hệ.',
      parentRoute: '/p2p/compliance/overview',
      emptyTitle: 'Chưa có dữ liệu kiểm tra AML',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  Future<P2PSourceOfFundsSnapshot> getSourceOfFunds() async {
    await _simulateNetwork();
    return const P2PSourceOfFundsSnapshot(
      endpoint: '/api/mobile/p2p/p2p-compliance-source-of-funds',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      title: 'Source of Funds',
      subtitle: 'Tuân thủ · P2P',
      heroTitle: 'Khai báo nguồn vốn',
      heroSubtitle:
          'Yêu cầu cho giao dịch lớn hoặc Tier 3. Thông tin được bảo mật.',
      sourceTitle: 'Nguồn tiền chính',
      inputLabel: 'Chi tiết bổ sung',
      inputPlaceholder: 'VD: Lương từ công ty ABC, vị trí Senior Engineer',
      ctaLabel: 'Gửi khai báo',
      sources: _p2pFundSources,
      parentRoute: '/p2p/compliance/overview',
      successRoute: '/p2p/kyc/status',
      emptyTitle: 'Chưa có khai báo nguồn vốn',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
      highRiskContractId: 'p2p_source_of_funds_review',
    );
  }

  @override
  Future<P2PLargeTransactionJustificationSnapshot>
  getLargeTransactionJustification({double amount = 100000000}) async {
    await _simulateNetwork();
    return P2PLargeTransactionJustificationSnapshot(
      endpoint: '/api/mobile/p2p/p2p-compliance-large-transaction',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      title: 'Large Transaction',
      subtitle: 'Giao dịch · P2P',
      amount: amount,
      heroTitle: 'Giao dịch lớn: ${_formatVndDots(amount)}',
      heroSubtitle: 'Cần giải trình mục đích theo quy định AML/CTF',
      purposeTitle: 'Mục đích giao dịch',
      customPurposeLabel: 'Mục đích cụ thể',
      customPurposePlaceholder: 'Nhập mục đích sử dụng',
      detailsLabel: 'Giải trình chi tiết',
      detailsPlaceholder:
          'VD: Mua BTC để nắm giữ dài hạn, dự kiến hold 1-2 năm...',
      ctaLabel: 'Gửi giải trình',
      purposes: _p2pLargeTransactionPurposes,
      parentRoute: '/p2p/compliance/overview',
      successRoute: '/p2p/my-orders',
      emptyTitle: 'Chưa có giải trình giao dịch lớn',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
      highRiskContractId: 'p2p_large_transaction_review',
    );
  }

  @override
  Future<P2PRiskAssessmentSnapshot> getRiskAssessment() async {
    await _simulateNetwork();
    return const P2PRiskAssessmentSnapshot(
      endpoint: '/api/mobile/p2p/p2p-compliance-risk-assessment',
      actionDraft: 'POST /p2p/* workflow action where applicable',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      title: 'Risk Assessment',
      subtitle: 'Rủi ro · P2P',
      overallRisk: 'low',
      score: 15,
      scoreLabel: 'Low Risk',
      scoreSubtitle: 'Risk Score: 15/100',
      infoText:
          'Risk score được tính dựa trên KYC level, transaction history, AML screening, và behavioral patterns.',
      factorTitle: 'Risk Factors',
      factors: _p2pRiskFactors,
      parentRoute: '/p2p/compliance/overview',
      emptyTitle: 'Chưa có dữ liệu đánh giá rủi ro',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  Future<P2PTaxReportingSnapshot> getTaxReporting({
    int selectedYear = 2025,
    String selectedJurisdiction = 'US',
  }) async {
    await _simulateNetwork();
    final jurisdiction = _p2pTaxJurisdictions.firstWhere(
      (item) => item.code == selectedJurisdiction,
      orElse: () => _p2pTaxJurisdictions.first,
    );

    return P2PTaxReportingSnapshot(
      endpoint: '/api/mobile/p2p/p2p-tax-reporting',
      actionDraft:
          'POST /p2p/* workflow action where applicable; POST /exports',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      title: 'Tax Reporting',
      subtitle: 'Thuế · P2P',
      selectedYear: selectedYear,
      selectedJurisdiction: jurisdiction,
      years: _p2pTaxYears,
      jurisdictions: _p2pTaxJurisdictions,
      summary: _p2pTaxSummary2025,
      documents: _p2pTaxDocuments2025,
      disclaimer:
          'This report is for informational purposes only and should not be considered tax advice. Please consult a qualified tax professional for your specific situation. Cryptocurrency tax laws vary by jurisdiction.',
      parentRoute: '/p2p',
      detailRoute: '/p2p/tax-report/detailed/$selectedYear',
      emptyTitle: 'Chưa có dữ liệu báo cáo thuế P2P',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  Future<P2POrderBookSnapshot> getOrderBook({
    String selectedAsset = 'USDT',
  }) async {
    await _simulateNetwork();
    final selected = _p2pOrderBookMarkets.firstWhere(
      (item) => item.asset == selectedAsset,
      orElse: () => _p2pOrderBookMarkets.first,
    );

    return P2POrderBookSnapshot(
      endpoint: '/api/mobile/p2p/p2p-order-book',
      actionDraft:
          'POST /orders/:id/action where applicable; POST /p2p/* workflow action where applicable',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
        P2PScreenState.realtimeRefresh,
      ],
      title: 'Sổ lệnh P2P',
      subtitle: 'Giao dịch · P2P',
      selectedAsset: selected,
      markets: _p2pOrderBookMarkets,
      bids: _p2pOrderBookBids,
      asks: _p2pOrderBookAsks,
      parentRoute: '/p2p',
      emptyTitle: 'Chưa có dữ liệu sổ lệnh',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }
}
