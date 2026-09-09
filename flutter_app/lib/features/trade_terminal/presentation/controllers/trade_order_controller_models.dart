import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_read_model.dart'
    show TradeHighRiskFlowStatus, TradeHighRiskFlowStatusX;
import 'package:vit_trade_flutter/features/trade_terminal/domain/entities/trade_terminal_entities.dart';
import 'package:vit_trade_flutter/features/trade_terminal/domain/repositories/spot_trade_repository.dart';

// TradeOrderViewState/Controller and TradeOrdersHistoryViewState/Controller
// moved to `features/trade/presentation/controllers/trade_order_controller_models.dart`
// (only `trade`'s own pages used them). This file keeps only the classes
// `trade_terminal`'s own advanced-tools pages still use.

final class TradeAdvancedToolsViewState {
  const TradeAdvancedToolsViewState({
    required this.snapshot,
    this.status = TradeHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final TradeAdvancedToolsSnapshot snapshot;
  final TradeHighRiskFlowStatus status;
  final String? errorMessage;
}

final class TradeAdvancedToolsController {
  const TradeAdvancedToolsController({
    required this.state,
    required this._repository,
  });

  final TradeAdvancedToolsViewState state;
  final SpotTradeRepository _repository;

  Future<TradeAdvancedToolActionResult> submitAction(
    TradeAdvancedToolActionRequest request,
  ) {
    return _repository.submitAdvancedToolAction(request);
  }

  String? actionValidationMessage(TradeAdvancedToolActionRequest request) {
    if (state.status == TradeHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before submitting this trading action.';
    }
    if (state.status.isBusy) {
      return 'Trading action is already in progress.';
    }
    if (request.toolId.trim().isEmpty || request.action.trim().isEmpty) {
      return 'Select a tool action before confirmation.';
    }
    if (request.orderIds.isEmpty) {
      return 'Chọn ít nhất một lệnh trước khi xác nhận.';
    }
    return null;
  }

  Future<TradeOrderAmendmentResult> amendOrder(
    TradeOrderAmendmentRequest request,
  ) {
    return _repository.amendOrder(request);
  }

  String? amendmentValidationMessage(TradeOrderAmendmentRequest request) {
    if (state.status == TradeHighRiskFlowStatus.offline) {
      return 'Mất kết nối: kết nối lại trước khi sửa lệnh này.';
    }
    if (state.status.isBusy) {
      return 'Yêu cầu sửa lệnh đang được xử lý.';
    }
    if (request.orderId.trim().isEmpty) {
      return 'Chọn một lệnh trước khi xem trước sửa lệnh.';
    }
    if (request.newPrice <= 0 || request.newAmount <= 0) {
      return 'Nhập giá và khối lượng sửa lệnh hợp lệ trước khi xem trước.';
    }
    return null;
  }
}
