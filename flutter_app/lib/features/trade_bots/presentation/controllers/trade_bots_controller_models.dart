// Trading-bots domain controller/view-state models (trade_bots extraction,
// Batch 4 of Phase 3 of the trade module split). Moved from
// `features/trade/presentation/controllers/trade_risk_bot_controller_models.dart`
// unchanged apart from each repository-holding controller's constructor
// parameter narrowing from the old cross-domain union `TradeRepository` to
// [TradingBotsRepository] (the domain interface this file's controllers
// actually call methods on). `TradeRiskManagementViewState`/`Controller`
// stayed behind in that file (renamed
// `trade_risk_management_controller_models.dart`) since they belong to
// spot/futures/margin risk management, not the trading-bots domain.
import 'package:vit_trade_flutter/features/trade_bots/domain/repositories/trading_bots_repository.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_read_model.dart';
import 'package:vit_trade_flutter/features/trade_bots/domain/entities/trade_bots_entities.dart';

final class TradeBotEmergencyStopViewState {
  const TradeBotEmergencyStopViewState({
    required this.snapshot,
    this.status = TradeHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final TradeBotEmergencyStopSnapshot snapshot;
  final TradeHighRiskFlowStatus status;
  final String? errorMessage;
}

final class TradeBotEmergencyStopController {
  const TradeBotEmergencyStopController({
    required this.state,
    required this._repository,
  });

  final TradeBotEmergencyStopViewState state;
  final TradingBotsRepository _repository;

  bool canSubmit({required String? reasonId, required bool confirmed}) {
    return validationMessage(reasonId: reasonId, confirmed: confirmed) == null;
  }

  String? validationMessage({
    required String? reasonId,
    required bool confirmed,
  }) {
    if (state.status == TradeHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before stopping trading bots.';
    }
    if (state.status.isBusy) {
      return 'Emergency stop confirmation is already in progress.';
    }
    if (reasonId == null || reasonId.trim().isEmpty) {
      return 'Select an emergency-stop reason before confirmation.';
    }
    if (!confirmed) {
      return 'Xác nhận đã đọc cảnh báo dừng khẩn cấp trước.';
    }
    return null;
  }

  Future<TradeBotEmergencyStopResult> submit(TradeBotEmergencyStopDraft draft) {
    return _repository.submitBotEmergencyStop(draft);
  }
}

final class TradeBotSecuritySettingsViewState {
  const TradeBotSecuritySettingsViewState({
    required this.snapshot,
    this.status = TradeHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final TradeBotSecuritySettingsSnapshot snapshot;
  final TradeHighRiskFlowStatus status;
  final String? errorMessage;
}

final class TradeBotSecuritySettingsController {
  const TradeBotSecuritySettingsController({
    required this.state,
    required this._repository,
  });

  final TradeBotSecuritySettingsViewState state;
  final TradingBotsRepository _repository;

  Future<TradeBotSecuritySettingsResult> saveTwoFa(bool enabled) {
    return _repository.patchBotSecuritySettings(
      TradeBotSecuritySettingsDraft(twoFaEnabled: enabled),
    );
  }

  String? saveValidationMessage() {
    if (state.status == TradeHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before saving bot security settings.';
    }
    if (state.status.isBusy) {
      return 'Cập nhật bảo mật bot đang được xử lý.';
    }
    return null;
  }
}

final class TradeBotSuitabilityViewState {
  const TradeBotSuitabilityViewState({
    required this.snapshot,
    this.status = TradeHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final TradeBotSuitabilityAssessmentSnapshot snapshot;
  final TradeHighRiskFlowStatus status;
  final String? errorMessage;
}

final class TradeBotSuitabilityController {
  const TradeBotSuitabilityController({required this.state});

  final TradeBotSuitabilityViewState state;

  int score(Map<String, String> answers) {
    var total = 0;
    for (final entry in answers.entries) {
      final question = state.snapshot.questions.firstWhere(
        (question) => question.id == entry.key,
      );
      final option = question.options.firstWhere(
        (option) => option.id == entry.value,
      );
      total += option.score;
    }
    return total;
  }

  String completionPathFor(TradeBotSuitabilityOutcomeCopy result) {
    return result.outcome == TradeBotSuitabilityOutcome.fail
        ? ''
        : state.snapshot.completionPath;
  }
}

final class TradeBotsViewState {
  const TradeBotsViewState({
    required this.snapshot,
    this.status = TradeHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final TradeBotsSnapshot snapshot;
  final TradeHighRiskFlowStatus status;
  final String? errorMessage;

  TradeBotsViewState copyWith({
    TradeBotsSnapshot? snapshot,
    TradeHighRiskFlowStatus? status,
    String? errorMessage,
  }) {
    return TradeBotsViewState(
      snapshot: snapshot ?? this.snapshot,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Validation for a bot toggle/pause/delete action, independent of any
  /// specific controller implementation.
  String? botActionValidationMessage({
    required String botId,
    required String action,
  }) {
    if (status == TradeHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before changing this bot.';
    }
    if (status.isBusy) {
      return 'Bot action is already in progress.';
    }
    if (botId.trim().isEmpty || action.trim().isEmpty) {
      return 'Select a bot action before confirmation.';
    }
    return null;
  }

  String? createValidationMessage(TradeBotCreateRequest request) {
    if (status == TradeHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before creating a trading bot.';
    }
    if (status.isBusy) {
      return 'Bot creation is already in progress.';
    }
    if (request.strategyId.trim().isEmpty) {
      return 'Select a strategy before creating a trading bot.';
    }
    if (request.params.isEmpty) {
      return 'Review bot parameters before creation.';
    }
    return null;
  }
}
