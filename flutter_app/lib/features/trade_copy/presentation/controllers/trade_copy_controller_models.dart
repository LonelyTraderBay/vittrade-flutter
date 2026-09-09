// Copy-trading domain controller/view-state models (trade_copy extraction,
// Batch 4 of Phase 2 of the trade module split). Moved from
// `features/trade/presentation/controllers/trade_copy_controller_models.dart`
// unchanged apart from each repository-holding controller's constructor
// parameter narrowing from the old cross-domain union `TradeRepository` to
// [TradeCopyTradingRepository] (the domain interface this file's
// controllers actually call methods on).
import 'package:vit_trade_flutter/features/trade_copy/domain/repositories/trade_copy_trading_repository.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_read_model.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/entities/trade_copy_entities.dart';

final class TradeCopyConfirmationViewState {
  const TradeCopyConfirmationViewState({
    required this.snapshot,
    required this.acceptedConsentIds,
    this.status = TradeHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final TradeCopyConfirmationSnapshot snapshot;
  final Set<String> acceptedConsentIds;
  final TradeHighRiskFlowStatus status;
  final String? errorMessage;
}

final class TradeCopyConfirmationController {
  const TradeCopyConfirmationController({
    required this.state,
    required this._repository,
  });

  final TradeCopyConfirmationViewState state;
  final TradeCopyTradingRepository _repository;

  bool get canSubmit => validationMessage() == null;

  String? validationMessage() {
    if (state.status == TradeHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before confirming this copy setup.';
    }
    if (state.status.isBusy) {
      return 'Copy confirmation is already in progress.';
    }
    if (!allRequiredAccepted) {
      return 'Chấp nhận toàn bộ xác nhận phù hợp và rủi ro bắt buộc trước.';
    }
    return null;
  }

  bool get allRequiredAccepted {
    return state.snapshot.consentItems
        .where((item) => item.required)
        .every((item) => state.acceptedConsentIds.contains(item.id));
  }

  Future<TradeCopyConfirmationResult> submit() {
    return _repository.submitCopyConfirmation(
      TradeCopyConfirmationRequest(
        providerId: state.snapshot.providerId,
        configuration: state.snapshot.configuration,
        acceptedConsentIds: state.acceptedConsentIds.toList(growable: false),
      ),
    );
  }
}

final class TradeActiveCopiesViewState {
  const TradeActiveCopiesViewState({
    required this.snapshot,
    this.status = TradeHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final TradeActiveCopiesSnapshot snapshot;
  final TradeHighRiskFlowStatus status;
  final String? errorMessage;
}

final class TradeActiveCopiesController {
  const TradeActiveCopiesController({
    required this.state,
    required this._repository,
  });

  final TradeActiveCopiesViewState state;
  final TradeCopyTradingRepository _repository;

  bool hasRiskAlert(List<TradeActiveCopy> copies) {
    return copies.any(
      (copy) => copy.status == TradeActiveCopyStatus.active && copy.pnlPct < -5,
    );
  }

  Future<TradeCopyActionResult> submitCopyAction({
    required String providerId,
    required String action,
  }) {
    return _repository.submitCopyTradingAction(
      TradeCopyActionRequest(providerId: providerId, action: action),
    );
  }

  String? actionValidationMessage({
    required String providerId,
    required String action,
  }) {
    if (state.status == TradeHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before changing this copy setup.';
    }
    if (state.status.isBusy) {
      return 'Copy action is already in progress.';
    }
    if (providerId.trim().isEmpty || action.trim().isEmpty) {
      return 'Select a copy action before confirmation.';
    }
    return null;
  }
}

final class TradeCopySettingsViewState {
  const TradeCopySettingsViewState({
    required this.snapshot,
    this.status = TradeHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final TradeCopySettingsSnapshot snapshot;
  final TradeHighRiskFlowStatus status;
  final String? errorMessage;
}

final class TradeCopySettingsController {
  const TradeCopySettingsController({
    required this.state,
    required this._repository,
  });

  final TradeCopySettingsViewState state;
  final TradeCopyTradingRepository _repository;

  Future<TradeCopySettingsSaveResult> save(TradeCopySettings settings) {
    return _repository.patchCopySettings(settings);
  }

  String? saveValidationMessage(TradeCopySettings settings) {
    if (state.status == TradeHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before saving copy settings.';
    }
    if (state.status.isBusy) {
      return 'Đang lưu cài đặt sao chép.';
    }
    if (settings.defaultCopyRatio <= 0) {
      return 'Enter a valid default copy ratio before saving.';
    }
    if (settings.maxPortfolioAllocation <= 0) {
      return 'Enter a valid portfolio allocation limit before saving.';
    }
    if (settings.enableCircuitBreaker &&
        settings.circuitBreakerThreshold <= 0) {
      return 'Enter a valid circuit-breaker limit before saving.';
    }
    return null;
  }
}

final class TradeCopyConfigurationViewState {
  const TradeCopyConfigurationViewState({
    required this.snapshot,
    required this.draft,
    required this.preview,
    this.status = TradeHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final TradeCopyConfigurationSnapshot snapshot;
  final TradeCopyConfigurationDraft draft;
  final TradeCopyConfigurationPreview preview;
  final TradeHighRiskFlowStatus status;
  final String? errorMessage;
}

final class TradeCopyConfigurationController {
  const TradeCopyConfigurationController({required this.state});

  final TradeCopyConfigurationViewState state;

  bool get canContinue => validationMessage() == null;

  String? validationMessage() {
    if (state.status == TradeHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before previewing copy configuration.';
    }
    if (state.status.isBusy) {
      return 'Copy configuration is already in progress.';
    }
    if (state.draft.copyCapital <= 0) {
      return 'Nhập số tiền sao chép hợp lệ trước khi xem trước.';
    }
    if (state.draft.copyCapital > state.snapshot.availableCapital) {
      return 'Số tiền sao chép vượt quá vốn khả dụng.';
    }
    if (state.preview.hasBlockingErrors) {
      return 'Resolve blocking suitability or limit checks before continuing.';
    }
    return null;
  }
}

final class TradeProviderApplicationViewState {
  const TradeProviderApplicationViewState({
    required this.snapshot,
    this.status = TradeHighRiskFlowStatus.ready,
    this.errorMessage,
  });

  final TradeProviderApplicationSnapshot snapshot;
  final TradeHighRiskFlowStatus status;
  final String? errorMessage;
}

final class TradeProviderApplicationController {
  const TradeProviderApplicationController({
    required this.state,
    required this._repository,
  });

  final TradeProviderApplicationViewState state;
  final TradeCopyTradingRepository _repository;

  Future<TradeProviderApplicationResult> submit(
    TradeProviderApplicationDraft draft,
  ) {
    return _repository.submitProviderApplication(draft);
  }

  String? validationMessage(TradeProviderApplicationDraft draft) {
    if (state.status == TradeHighRiskFlowStatus.offline) {
      return 'Offline: reconnect before submitting this provider application.';
    }
    if (state.status.isBusy) {
      return 'Provider application is already in progress.';
    }
    if (!draft.hasKyc) {
      return 'Complete identity verification before applying as provider.';
    }
    if (draft.tradingMonths < 6) {
      return 'Đơn đăng ký nhà cung cấp yêu cầu tối thiểu 6 tháng lịch sử giao dịch.';
    }
    if (draft.minCapital <= 0 || draft.performanceFee < 0) {
      return 'Nhập vốn và chi tiết phí hợp lệ trước khi gửi.';
    }
    if (draft.strategyDescription.trim().isEmpty) {
      return 'Describe the strategy before submitting the application.';
    }
    if (!draft.agreedToDisclosure ||
        !draft.agreedToFiduciary ||
        !draft.agreedToTerms) {
      return 'Chấp nhận toàn bộ điều khoản công bố thông tin và phù hợp trước khi gửi.';
    }
    return null;
  }
}
