// Spot/futures/margin risk-management controller/view-state model. Split
// out from `trade_risk_bot_controller_models.dart` (trade_bots extraction,
// Batch 4 of Phase 3 of the trade module split) — this file previously also
// held the trading-bots domain classes (`TradeBotEmergencyStop*`,
// `TradeBotSecuritySettings*`, `TradeBotSuitability*`, `TradeBotsViewState`),
// which moved to
// `features/trade_bots/presentation/controllers/trade_bots_controller_models.dart`.
// `TradeRiskManagementViewState`/`Controller` stayed behind since OCO orders
// and position sizing belong to `trade`'s core risk-management flows, not
// trading bots.
import 'package:vit_trade_flutter/features/trade_core/domain/entities/trade_core_entities.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_read_model.dart'
    show TradeHighRiskFlowStatus, TradeHighRiskFlowStatusX;
import 'package:vit_trade_flutter/features/trade_terminal/domain/entities/trade_terminal_entities.dart';
import 'package:vit_trade_flutter/features/trade_terminal/domain/repositories/spot_trade_repository.dart';

final class TradeRiskManagementViewState {
  const TradeRiskManagementViewState({
    required this.snapshot,
    this.status = TradeHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final TradeRiskManagementSnapshot snapshot;
  final TradeHighRiskFlowStatus status;
  final String? errorMessage;
}

final class TradeRiskManagementController {
  const TradeRiskManagementController({
    required this.state,
    required this._repository,
  });

  final TradeRiskManagementViewState state;
  final SpotTradeRepository _repository;

  Future<TradeOcoOrderResult> submitOcoOrder(TradeOcoOrderDraft draft) {
    return _repository.submitOcoOrder(draft);
  }

  String? ocoValidationMessage(TradeOcoOrderDraft draft) {
    if (state.status == TradeHighRiskFlowStatus.offline) {
      return 'Mất kết nối: kết nối lại trước khi xem trước lệnh OCO này.';
    }
    if (state.status.isBusy) {
      return 'Xác nhận lệnh quản trị rủi ro đang được xử lý.';
    }
    if (draft.symbol.trim().isEmpty) {
      return 'Select a symbol before OCO preview.';
    }
    if (draft.quantity <= 0 ||
        draft.limitPrice <= 0 ||
        draft.takeProfitPrice <= 0 ||
        draft.stopPrice <= 0) {
      return 'Nhập khối lượng, giá giới hạn, giá chốt lời và giá dừng hợp lệ.';
    }
    if (draft.side == TradeOrderSide.buy &&
        draft.takeProfitPrice <= draft.limitPrice) {
      return 'Giá chốt lời phải cao hơn giá mua giới hạn.';
    }
    if (draft.side == TradeOrderSide.sell &&
        draft.stopPrice >= draft.limitPrice) {
      return 'Giá dừng phải thấp hơn giá bán giới hạn.';
    }
    return null;
  }

  Future<TradePositionSizeResult> calculatePositionSize(
    TradePositionSizeRequest request,
  ) {
    return _repository.calculatePositionSize(request);
  }

  String? positionSizeValidationMessage(TradePositionSizeRequest request) {
    if (state.status == TradeHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before calculating position size.';
    }
    if (request.accountBalance <= 0 || request.riskPct <= 0) {
      return 'Nhập số dư và phần trăm rủi ro hợp lệ trước khi tính toán.';
    }
    if (request.entryPrice <= 0 || request.stopPrice <= 0) {
      return 'Nhập giá vào lệnh và giá dừng hợp lệ trước khi tính toán.';
    }
    if (request.entryPrice == request.stopPrice) {
      return 'Giá vào lệnh và giá dừng phải khác nhau.';
    }
    return null;
  }
}
