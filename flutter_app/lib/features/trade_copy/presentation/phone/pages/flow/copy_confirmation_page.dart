import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_copy_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_hero.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/widgets/trade_copy_consent_card.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/entities/trade_copy_entities.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/controllers/trade_copy_controller_models.dart';

part '../../../widgets/flow/copy_confirmation_page_sections.dart';
part '../../../widgets/flow/copy_confirmation_page_common.dart';

const _confirmationPrimary = AppColors.primary;
const _confirmationGreen = AppColors.buy;
const _confirmationRed = AppColors.sell;

class CopyConfirmationPage extends ConsumerStatefulWidget {
  const CopyConfirmationPage({
    super.key,
    required this.providerId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc073_copy_confirmation_content');
  static const submitKey = Key('sc073_copy_confirmation_submit');
  static const suitabilityKey = Key('sc073_copy_confirmation_suitability');

  static Key consentKey(String id) =>
      Key('sc073_copy_confirmation_consent_$id');

  final String providerId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<CopyConfirmationPage> createState() =>
      _CopyConfirmationPageState();
}

class _CopyConfirmationPageState extends ConsumerState<CopyConfirmationPage> {
  final Set<String> _acceptedConsentIds = <String>{};
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(
      tradeCopyConfirmationControllerProvider((
        providerId: widget.providerId,
        acceptedConsentIds: _acceptedConsentIds.toList(growable: false),
      )),
    );

    return controllerAsync.when(
      loading: () => _scaffold(context, const [VitSkeletonList()]),
      error: (error, stackTrace) => _scaffold(context, [
        VitErrorState(
          title: 'Không tải được xác nhận copy',
          message: 'Vui lòng kiểm tra kết nối và thử lại.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(
            tradeCopyConfirmationControllerProvider((
              providerId: widget.providerId,
              acceptedConsentIds: _acceptedConsentIds.toList(growable: false),
            )),
          ),
        ),
      ]),
      data: (controller) {
        final snapshot = controller.state.snapshot;

        if (snapshot.isNotFound) {
          return const VitPageLayout(
            variant: VitPageVariant.flush,
            semanticLabel: 'Xác nhận Copy',
            semanticIdentifier: 'SC-073',
            child: SizedBox.expand(),
          );
        }

        final allRequiredAccepted = controller.allRequiredAccepted;

        return _scaffold(
          context,
          _body(context, snapshot, allRequiredAccepted, controller),
        );
      },
    );
  }

  Widget _scaffold(BuildContext context, List<Widget> children) {
    return VitTradeDetailScaffold(
      title: 'Xác nhận Copy',
      semanticLabel: 'Xác nhận Copy',
      semanticIdentifier: 'SC-073',
      contentKey: CopyConfirmationPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      useCopyTradingInset: true,
      showProductTabs: false,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeCopyProviderConfiguration(
          widget.providerId,
        ),
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: children,
    );
  }

  List<Widget> _body(
    BuildContext context,
    TradeCopyConfirmationSnapshot snapshot,
    bool allRequiredAccepted,
    TradeCopyConfirmationController controller,
  ) {
    return [
      VitTradeSection(
        title: 'Cảnh báo',
        child: VitTradeComplianceHero(
          title: 'Cảnh báo rủi ro quan trọng',
          description:
              'Copy Trading có rủi ro cao. Bạn có thể mất toàn bộ số tiền '
              '\$${snapshot.configuration.copyCapital.toStringAsFixed(0)} đã cam kết.',
          icon: Icons.warning_amber_rounded,
          accentColor: _confirmationRed,
        ),
      ),
      VitTradeSection(
        title: 'Provider',
        child: _ProviderSummary(provider: snapshot.provider!),
      ),
      _SuitabilityReviewCard(snapshot: snapshot),
      _ConfigurationSummary(snapshot: snapshot),
      _FeeBreakdown(snapshot: snapshot),
      _ScenarioSection(scenarios: snapshot.scenarios),
      VitTradeSection(
        title: 'Mất vốn tối đa',
        child: _MaxLossCard(snapshot: snapshot),
      ),
      VitFinancialSafetySummary(
        title: 'Xem lại trước khi copy',
        contractId: 'SC-073 Copy confirmation',
        density: VitDensity.tool,
        footer:
            'Xác nhận vốn có thể mất, phí, mất vốn tối đa, đồng ý bắt buộc và thời gian chờ trước khi bắt đầu copy trading.',
        items: [
          VitFinancialSafetyItem(
            label: 'Vốn có thể mất',
            value: '\$${snapshot.configuration.copyCapital.toStringAsFixed(0)}',
            leading: const Icon(Icons.account_balance_wallet_outlined),
            valueColor: _confirmationRed,
          ),
          VitFinancialSafetyItem(
            label: 'Kịch bản mất vốn tối đa',
            value: '\$${snapshot.maxLossAmount.toStringAsFixed(0)}',
            leading: const Icon(Icons.trending_down_rounded),
            valueColor: _confirmationRed,
          ),
          VitFinancialSafetyItem(
            label: 'Phí cố định (tháng 1)',
            value: '\$${snapshot.feePreview.totalFixedFees.toStringAsFixed(2)}',
            leading: const Icon(Icons.receipt_long_outlined),
            valueColor: AppColors.text2,
          ),
          VitFinancialSafetyItem(
            label: 'Thời gian chờ',
            value: '${snapshot.coolingOffHours} giờ',
            leading: const Icon(Icons.schedule_rounded),
            valueColor: _confirmationPrimary,
          ),
          VitFinancialSafetyItem(
            label: 'Đồng ý bắt buộc',
            value: allRequiredAccepted ? 'Đã đủ' : 'Chưa đủ',
            leading: const Icon(Icons.verified_user_outlined),
            valueColor: allRequiredAccepted ? AppColors.buy : AppColors.warn,
          ),
        ],
      ),
      _ConsentSection(
        items: snapshot.consentItems,
        acceptedIds: _acceptedConsentIds,
        onToggle: _toggleConsent,
      ),
      VitTradeSection(
        title: 'Cooling-off',
        child: _CoolingOffCard(hours: snapshot.coolingOffHours),
      ),
      VitTradeSection(
        title: 'Bước tiếp theo',
        child: _NextStepsCard(snapshot: snapshot),
      ),
      const VitHighRiskStatePanel(
        state: VitHighRiskUiState.riskReview,
        title: 'Xem lại trước khi xác nhận copy',
        message:
            'Cảnh báo quan trọng, đánh giá phù hợp, phí, kịch bản, mất vốn tối đa, đồng ý bắt buộc, thời gian chờ và bước tiếp theo hiển thị trước khi bắt đầu copy trading.',
        contractId: 'SC-073',
        density: VitDensity.tool,
      ),
      Column(
        children: [
          VitCtaButton(
            key: CopyConfirmationPage.submitKey,
            onPressed: allRequiredAccepted && !_submitting
                ? () => _submit(context, controller)
                : null,
            loading: _submitting,
            variant: VitCtaButtonVariant.danger,
            density: VitDensity.tool,
            leading: const Icon(Icons.shield_outlined),
            child: const Text('Xác nhận & Bắt đầu Copy'),
          ),
          if (!allRequiredAccepted) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            Text(
              'Bạn cần đồng ý với tất cả điều khoản để tiếp tục',
              textAlign: TextAlign.center,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ],
      ),
    ];
  }

  void _toggleConsent(String id) {
    setState(() {
      if (_acceptedConsentIds.contains(id)) {
        _acceptedConsentIds.remove(id);
      } else {
        _acceptedConsentIds.add(id);
      }
    });
  }

  Future<void> _submit(
    BuildContext context,
    TradeCopyConfirmationController controller,
  ) async {
    setState(() => _submitting = true);
    final result = await controller.submit();
    await Future<void>.delayed(const Duration(milliseconds: 180));
    if (!context.mounted) return;
    if (result.status == 'pending_cooling_off') {
      context.go(result.activeCopiesPath);
    } else {
      setState(() => _submitting = false);
    }
  }
}
