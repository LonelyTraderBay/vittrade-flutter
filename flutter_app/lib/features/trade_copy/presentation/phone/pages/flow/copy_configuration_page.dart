import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_copy_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/entities/trade_copy_entities.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/controllers/trade_copy_controller_models.dart';

part '../../../widgets/flow/copy_configuration_provider_capital_mode.dart';
part '../../../widgets/flow/copy_configuration_risk_summary.dart';
part '../../../widgets/flow/copy_configuration_validation_common.dart';

const _configurationPrimary = AppColors.primary;
const _configurationGreen = AppColors.buy;
const _configurationRed = AppColors.sell;
const _configurationSpace = AppSpacing.x2;
const _configurationCardSpace = AppSpacing.x3;
const _configurationProgressHeight =
    TradeSpacingTokens.copyConfigurationProgressHeight;
const _configurationPresetHeight =
    TradeSpacingTokens.copyConfigurationPresetHeight;
const _configurationButtonHeight = AppSpacing.searchBarCompactHeight;
const _configurationDescriptionLineHeight = 1.24;

class CopyConfigurationPage extends ConsumerStatefulWidget {
  const CopyConfigurationPage({
    super.key,
    required this.providerId,
    this.backPath,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc072_copy_configuration_content');
  static const confirmKey = Key('sc072_copy_configuration_confirm');
  static const capitalFieldKey = Key('sc072_copy_configuration_capital');

  static Key modeKey(TradeCopyConfigurationMode mode) =>
      Key('sc072_copy_configuration_mode_${mode.name}');

  final String providerId;
  final String? backPath;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<CopyConfigurationPage> createState() =>
      _CopyConfigurationPageState();
}

class _CopyConfigurationPageState extends ConsumerState<CopyConfigurationPage> {
  final TextEditingController _capitalController = TextEditingController();
  TradeCopyConfigurationDraft? _draft;
  String? _draftProviderId;

  @override
  void dispose() {
    _capitalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(
      tradeCopyConfigurationProvider(widget.providerId),
    );

    return snapshotAsync.when(
      loading: () => _scaffold(context, const [VitSkeletonList()]),
      error: (error, stackTrace) => _scaffold(context, [
        VitErrorState(
          title: 'Không tải được cấu hình copy',
          message: 'Vui lòng kiểm tra kết nối và thử lại.',
          actionLabel: 'Thử lại',
          onAction: () =>
              ref.invalidate(tradeCopyConfigurationProvider(widget.providerId)),
        ),
      ]),
      data: (snapshot) {
        if (snapshot.isNotFound) {
          return const VitPageLayout(
            variant: VitPageVariant.flush,
            semanticLabel: 'Cấu hình Copy',
            semanticIdentifier: 'SC-072',
            child: SizedBox.expand(),
          );
        }

        _ensureDraft(snapshot);
        final draft = _draft!;
        final controllerAsync = ref.watch(
          tradeCopyConfigurationControllerProvider((
            providerId: widget.providerId,
            draft: draft,
          )),
        );

        return controllerAsync.when(
          loading: () => _scaffold(context, const [VitSkeletonList()]),
          error: (error, stackTrace) => _scaffold(context, [
            VitErrorState(
              title: 'Không tải được xem trước cấu hình',
              message: 'Vui lòng kiểm tra kết nối và thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(
                tradeCopyConfigurationControllerProvider((
                  providerId: widget.providerId,
                  draft: draft,
                )),
              ),
            ),
          ]),
          data: (controller) =>
              _scaffold(context, _body(context, snapshot, draft, controller)),
        );
      },
    );
  }

  Widget _scaffold(BuildContext context, List<Widget> children) {
    final resolvedBackPath = resolveSafeBackPath(
      candidate: widget.backPath,
      fallbackPath: AppRoutePaths.tradeCopyProvider(widget.providerId),
      allowedPrefixes: const [AppRoutePaths.trade],
    );

    return VitTradeDetailScaffold(
      title: 'Cấu hình Copy',
      semanticLabel: 'Cấu hình Copy',
      semanticIdentifier: 'SC-072',
      contentKey: CopyConfigurationPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      useCopyTradingInset: true,
      activeProductId: 'copy',
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: resolvedBackPath,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: children,
    );
  }

  List<Widget> _body(
    BuildContext context,
    TradeCopyConfigurationSnapshot snapshot,
    TradeCopyConfigurationDraft draft,
    TradeCopyConfigurationController controller,
  ) {
    final preview = controller.state.preview;
    final provider = snapshot.provider!;
    final allocationPercent = draft.copyCapital / snapshot.totalPortfolio * 100;

    return [
      _CapitalSection(
        controller: _capitalController,
        allocationPercent: allocationPercent,
        availableCapital: snapshot.availableCapital,
        totalPortfolio: snapshot.totalPortfolio,
        onChanged: _updateCapital,
        onPreset: (percent) =>
            _setCapitalPercent(percent, snapshot.totalPortfolio),
      ),
      VitTradeSection(
        title: 'Provider',
        child: _ProviderCard(provider: provider),
      ),
      _ModeSection(
        selected: draft.copyMode,
        copyRatio: draft.copyRatio,
        onModeChanged: _setMode,
        onRatioChanged: _setCopyRatio,
      ),
      _RiskSection(draft: draft, onDraftChanged: _setDraft),
      _FeeSection(preview: preview),
      if (preview.validations.isNotEmpty)
        _ValidationList(items: preview.validations),
      _SummaryCard(draft: draft),
      const VitHighRiskStatePanel(
        state: VitHighRiskUiState.riskReview,
        title: 'Xem lại cấu hình copy',
        message:
            'Tóm tắt provider, phân bổ vốn, chế độ copy, kiểm soát rủi ro, phí dự kiến và thông báo xác thực hiển thị trước khi xác nhận.',
        contractId: 'SC-072',
        density: VitDensity.tool,
      ),
      VitCtaButton(
        key: CopyConfigurationPage.confirmKey,
        onPressed: preview.hasBlockingErrors
            ? null
            : () => context.push(
                AppRoutePaths.tradeCopyProviderConfirmation(widget.providerId),
              ),
        variant: VitCtaButtonVariant.auth,
        density: VitDensity.tool,
        height: _configurationButtonHeight,
        trailing: const Icon(Icons.chevron_right_rounded),
        child: const Text('Xem xác nhận'),
      ),
    ];
  }

  void _ensureDraft(TradeCopyConfigurationSnapshot snapshot) {
    if (_draftProviderId == snapshot.providerId) return;
    _draftProviderId = snapshot.providerId;
    _draft = snapshot.defaultDraft;
    _capitalController.text = snapshot.defaultDraft.copyCapital.toStringAsFixed(
      0,
    );
  }

  void _setDraft(TradeCopyConfigurationDraft draft) {
    setState(() => _draft = draft);
  }

  void _updateCapital(String rawValue) {
    final value = double.tryParse(rawValue);
    if (value == null) return;
    _setDraft(_draft!.copyWith(copyCapital: value));
  }

  void _setCapitalPercent(double percent, double totalPortfolio) {
    final capital = totalPortfolio * percent / 100;
    _capitalController.text = capital.toStringAsFixed(0);
    _setDraft(_draft!.copyWith(copyCapital: capital));
  }

  void _setMode(TradeCopyConfigurationMode mode) {
    _setDraft(_draft!.copyWith(copyMode: mode));
  }

  void _setCopyRatio(double ratio) {
    _setDraft(_draft!.copyWith(copyRatio: ratio));
  }
}
