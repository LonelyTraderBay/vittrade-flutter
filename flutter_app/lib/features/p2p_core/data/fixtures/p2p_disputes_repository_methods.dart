part of '../repositories/mock_p2p_repository.dart';

mixin _MockP2PRepositoryDisputesMethods on _MockP2PRepositoryBase {
  @override
  Future<P2PDisputeDetailSnapshot> getDisputeDetail(String disputeId) async {
    await _simulateNetwork();
    return P2PDisputeDetailSnapshot(
      endpoint: '/api/mobile/p2p/p2p-dispute-detail-$disputeId',
      actionDraft:
          'POST /p2p/* workflow action where applicable; POST /p2p/disputes/:id/evidence|resolve',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      dispute: const P2PDisputeDraft(
        id: 'disp001',
        orderId: 'p2p006',
        orderNumber: 'VT-P2P-20240219-006',
        status: P2PDisputeStatus.underReview,
        statusLabel: 'Đang xem xét',
        reason: 'Đã thanh toán nhưng người bán không xác nhận',
        description:
            'Tôi đã chuyển khoản 20,280,000 VND qua Vietcombank lúc 08:15 nhưng người bán NewTrader01 không xác nhận sau 30 phút.',
        currentLevel: 2,
      ),
      levels: _p2pDisputeLevels,
      evidence: _p2pDisputeEvidence,
      timeline: _p2pDisputeTimeline,
      supportMessages: _p2pDisputeSupportMessages,
      emptyTitle: 'Không tìm thấy tranh chấp',
      emptySubtitle: 'Case này có thể đã được đóng hoặc thiếu quyền truy cập.',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  Future<P2PDisputeEvidenceSnapshot> getDisputeEvidence(
    String disputeId,
  ) async {
    await _simulateNetwork();
    return P2PDisputeEvidenceSnapshot(
      endpoint: '/api/mobile/p2p/p2p-dispute-evidence-$disputeId',
      actionDraft:
          'POST /p2p/* workflow action where applicable; POST /p2p/disputes/:id/evidence|resolve',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      disputeId: disputeId,
      title: 'Dispute #$disputeId',
      subtitle: 'Upload tài liệu chứng minh',
      documents: _p2pDisputeEvidenceDocuments,
      emptyTitle: 'Chưa có loại bằng chứng',
      emptySubtitle: 'Hệ thống sẽ hiển thị checklist tài liệu cần bổ sung.',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  Future<P2PDisputeResolutionSnapshot> getDisputeResolution(
    String disputeId,
  ) async {
    await _simulateNetwork();
    return P2PDisputeResolutionSnapshot(
      endpoint: '/api/mobile/p2p/p2p-dispute-resolution-$disputeId',
      actionDraft:
          'POST /p2p/* workflow action where applicable; POST /p2p/disputes/:id/evidence|resolve',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      disputeId: disputeId,
      resultTitle: 'Quyết định: Bên mua thắng',
      disputeLabel: 'Dispute #$disputeId',
      refundAmountLabel: '24.000.000',
      reason:
          'Seller không release sau khi buyer đã thanh toán. Evidence cho thấy buyer đã chuyển đúng số tiền.',
      mediator: 'Support Team #A5',
      resolvedAt: '2026-03-05 16:00',
      appealDeadline: '2026-03-07 16:00',
      emptyTitle: 'Chưa có kết quả giải quyết',
      emptySubtitle: 'Mediator sẽ cập nhật quyết định khi review hoàn tất.',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
      highRiskContractId: HighRiskFlowContractIds.p2pEscrowOrder,
    );
  }

  @override
  Future<P2PDisputeOpenSnapshot> getDisputeOpen(String orderId) async {
    await _simulateNetwork();
    return P2PDisputeOpenSnapshot(
      endpoint: '/api/mobile/p2p/p2p-dispute-$orderId',
      actionDraft:
          'POST /p2p/* workflow action where applicable; POST /p2p/disputes/:id/evidence|resolve',
      supportedStates: const [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ],
      orderId: orderId,
      title: 'Mở tranh chấp',
      subtitle: 'Order #. Vui lòng cung cấp bằng chứng đầy đủ.',
      reasons: _p2pDisputeReasons,
      descriptionLabel: 'Mô tả chi tiết',
      descriptionPlaceholder:
          'Mô tả vấn đề, bao gồm: thời gian, số tiền, bằng chứng...',
      uploadTitle: 'Upload bằng chứng',
      uploadSubtitle: 'Screenshots, chat logs, payment receipts',
      targetDisputeId: 'sample',
      emptyTitle: 'Không thể mở tranh chấp',
      emptySubtitle: 'Đơn hàng này có thể chưa đủ điều kiện khiếu nại.',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }

  @override
  Future<P2PDisputesSnapshot> getDisputes() async {
    await _simulateNetwork();
    return const P2PDisputesSnapshot(
      endpoint: '/api/mobile/p2p/p2p-disputes',
      actionDraft:
          'POST /p2p/* workflow action where applicable; POST /p2p/disputes/:id/evidence|resolve',
      supportedStates: [
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ],
      disputes: _p2pDisputeList,
      noticeTitle: 'Quy trình xử lý tranh chấp',
      notice:
          'Mọi tranh chấp được xử lý qua hệ thống 4 cấp: AI tự động -> Nhân viên hỗ trợ -> Trọng tài -> Ban giám đốc. Trung bình giải quyết trong 2-24 giờ.',
      guideTitle: 'Cách mở tranh chấp',
      guideSteps: _p2pDisputeGuideSteps,
      emptyTitle: 'Chưa có tranh chấp nào',
      emptySubtitle: 'Tất cả giao dịch P2P của bạn đều suôn sẻ',
      contractNotes: 'P2P requires escrow, fraud, KYC, payment-state clarity.',
    );
  }
}
