import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_copy_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/widgets/trade_copy_consent_card.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/entities/trade_copy_entities.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/controllers/trade_copy_controller_models.dart';

part '../../../widgets/provider/provider_application_progress_intro.dart';
part '../../../widgets/provider/provider_application_steps.dart';
part '../../../widgets/provider/provider_application_common.dart';

const _providerPrimary = AppColors.primary;
const _providerGreen = AppColors.buy;
const _providerWarning = AppColors.caution;
const _providerField = AppColors.surface3;

class ProviderApplicationPage extends ConsumerStatefulWidget {
  const ProviderApplicationPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc069_provider_application_scroll_content');
  static const nextKey = Key('sc069_provider_application_next');
  static const submitKey = Key('sc069_provider_application_submit');
  static const kycKey = Key('sc069_provider_application_kyc');
  static const disclosureKey = Key('sc069_provider_application_disclosure');
  static const fiduciaryKey = Key('sc069_provider_application_fiduciary');
  static const termsKey = Key('sc069_provider_application_terms');
  static const monthsFieldKey = Key('sc069_provider_application_months');
  static const strategyFieldKey = Key('sc069_provider_application_strategy');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ProviderApplicationPage> createState() =>
      _ProviderApplicationPageState();
}

class _ProviderApplicationPageState
    extends ConsumerState<ProviderApplicationPage> {
  TradeProviderApplicationStep? _step;
  TradeProviderApplicationDraft? _draft;
  late final TextEditingController _monthsController;
  late final TextEditingController _strategyController;
  bool _controllersReady = false;

  @override
  void dispose() {
    if (_controllersReady) {
      _monthsController.dispose();
      _strategyController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(
      tradeProviderApplicationControllerProvider,
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();

    return controllerAsync.when(
      loading: () => _shell(context, mode, const [VitSkeletonList()], null),
      error: (error, stackTrace) => _shell(context, mode, [
        VitErrorState(
          title: 'Không tải được đơn đăng ký provider',
          message: 'Vui lòng kiểm tra kết nối và thử lại.',
          actionLabel: 'Thử lại',
          onAction: () =>
              ref.invalidate(tradeProviderApplicationControllerProvider),
        ),
      ], null),
      data: (controller) {
        final snapshot = controller.state.snapshot;
        _step ??= snapshot.defaultStep;
        _draft ??= snapshot.defaultDraft;
        if (!_controllersReady) {
          _monthsController = TextEditingController(
            text: _draft!.tradingMonths.toString(),
          );
          _strategyController = TextEditingController(
            text: _draft!.strategyDescription,
          );
          _controllersReady = true;
        }

        final step = _step!;
        final draft = _draft!;
        final footer = SizedBox(
          width: double.infinity,
          child: Padding(
            padding: TradeSpacingTokens.providerApplicationFooterPadding(
              tradeScrollBottomInset(context, shellRenderMode: mode),
            ),
            child: VitStickyFooter(
              backgroundColor: AppColors.bg,
              child: _FooterButton(
                step: step,
                enabled: _canProceed(step, draft),
                onPressed: () => unawaited(_handlePrimaryAction(controller)),
              ),
            ),
          ),
        );

        return _shell(context, mode, _steps(step, draft, snapshot), footer);
      },
    );
  }

  Widget _shell(
    BuildContext context,
    ShellRenderMode mode,
    List<Widget> children,
    Widget? footer,
  ) {
    return ColoredBox(
      color: AppColors.bg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: VitTradeDetailScaffold(
              title: 'Đăng ký Provider',
              semanticLabel: 'Đăng ký Provider',
              semanticIdentifier: 'SC-069',
              contentKey: ProviderApplicationPage.contentKey,
              shellRenderMode: mode,
              activeProductId: 'copy',
              onBack: () => goBackOrFallback(
                context,
                fallbackPath: AppRoutePaths.tradeCopyTrading,
                mode: BackNavigationMode.historyThenFallback,
              ),
              children: children,
            ),
          ),
          ?footer,
        ],
      ),
    );
  }

  List<Widget> _steps(
    TradeProviderApplicationStep step,
    TradeProviderApplicationDraft draft,
    TradeProviderApplicationSnapshot snapshot,
  ) {
    return [
      VitTradeSection(
        title: 'Tiến trình',
        child: _ProgressBars(steps: snapshot.steps, activeStep: step),
      ),
      VitTradeSection(
        title: _stepTitle(step),
        child: switch (step) {
          TradeProviderApplicationStep.intro => _IntroStep(snapshot: snapshot),
          TradeProviderApplicationStep.requirements => _RequirementsStep(
            draft: draft,
            onChanged: _updateDraft,
            monthsController: _monthsController,
          ),
          TradeProviderApplicationStep.disclosure => _DisclosureStep(
            draft: draft,
            onChanged: _updateDraft,
          ),
          TradeProviderApplicationStep.fees => _FeesStep(
            draft: draft,
            onChanged: _updateDraft,
            strategyController: _strategyController,
          ),
          TradeProviderApplicationStep.review => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ReviewStep(draft: draft, onChanged: _updateDraft),
              VitFinancialSafetySummary(
                title: 'Xem lại đơn đăng ký provider',
                contractId: 'SC-069 Provider application',
                density: VitDensity.tool,
                footer:
                    'Xác nhận KYC, công bố thông tin, nghĩa vụ ủy thác, giới hạn phí và điều khoản trước khi gửi đơn.',
                items: [
                  VitFinancialSafetyItem(
                    label: 'KYC đã xác minh',
                    value: draft.hasKyc ? 'Có' : 'Chờ xử lý',
                    leading: const Icon(Icons.verified_user_outlined),
                    valueColor: draft.hasKyc ? AppColors.buy : AppColors.warn,
                  ),
                  VitFinancialSafetyItem(
                    label: 'Công bố thông tin',
                    value: draft.agreedToDisclosure && draft.agreedToFiduciary
                        ? 'Đã đủ'
                        : 'Chưa đủ',
                    leading: const Icon(Icons.description_outlined),
                    valueColor:
                        draft.agreedToDisclosure && draft.agreedToFiduciary
                        ? AppColors.buy
                        : AppColors.warn,
                  ),
                  VitFinancialSafetyItem(
                    label: 'Phí hiệu suất',
                    value: '${draft.performanceFee.toStringAsFixed(0)}%',
                    leading: const Icon(Icons.percent_rounded),
                    valueColor: AppColors.text2,
                  ),
                  VitFinancialSafetyItem(
                    label: 'Điều khoản',
                    value: draft.agreedToTerms ? 'Đã đồng ý' : 'Bắt buộc',
                    leading: const Icon(Icons.gavel_outlined),
                    valueColor: draft.agreedToTerms
                        ? AppColors.buy
                        : AppColors.sell,
                  ),
                ],
              ),
            ],
          ),
        },
      ),
    ];
  }

  String _stepTitle(TradeProviderApplicationStep step) {
    return switch (step) {
      TradeProviderApplicationStep.intro => 'Giới thiệu',
      TradeProviderApplicationStep.requirements => 'Kiểm tra điều kiện',
      TradeProviderApplicationStep.disclosure => 'Công bố',
      TradeProviderApplicationStep.fees => 'Phí & chiến lược',
      TradeProviderApplicationStep.review => 'Xem lại',
    };
  }

  void _updateDraft(TradeProviderApplicationDraft draft) {
    setState(() => _draft = draft);
  }

  bool _canProceed(
    TradeProviderApplicationStep step,
    TradeProviderApplicationDraft draft,
  ) {
    return switch (step) {
      TradeProviderApplicationStep.intro => true,
      TradeProviderApplicationStep.requirements =>
        draft.hasKyc && draft.tradingMonths >= 6 && draft.minCapital >= 10000,
      TradeProviderApplicationStep.disclosure =>
        draft.agreedToDisclosure && draft.agreedToFiduciary,
      TradeProviderApplicationStep.fees =>
        draft.performanceFee >= 0 &&
            draft.performanceFee <= 30 &&
            draft.strategyDescription.length >= 100,
      TradeProviderApplicationStep.review => draft.agreedToTerms,
    };
  }

  Future<void> _handlePrimaryAction(
    TradeProviderApplicationController controller,
  ) async {
    final step = _step!;
    final draft = _draft!;
    if (!_canProceed(step, draft)) return;

    switch (step) {
      case TradeProviderApplicationStep.intro:
        setState(() => _step = TradeProviderApplicationStep.requirements);
      case TradeProviderApplicationStep.requirements:
        setState(() => _step = TradeProviderApplicationStep.disclosure);
      case TradeProviderApplicationStep.disclosure:
        setState(() => _step = TradeProviderApplicationStep.fees);
      case TradeProviderApplicationStep.fees:
        setState(() => _step = TradeProviderApplicationStep.review);
      case TradeProviderApplicationStep.review:
        final result = await controller.submit(draft);
        if (!mounted) return;
        await showVitNoticeSheet(
          context: context,
          title: 'Đã gửi đơn đăng ký',
          message:
              'Mã đơn ${result.applicationId}. Thời gian xét duyệt: '
              '${result.reviewWindow}.',
          variant: VitBannerVariant.success,
          ctaVariant: VitCtaButtonVariant.success,
          onPrimary: () {
            if (mounted) context.go(AppRoutePaths.tradeCopyTrading);
          },
        );
    }
  }
}
