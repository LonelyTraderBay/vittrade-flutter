import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_savings_controller_providers.dart';
import 'package:vit_trade_flutter/features/earn_core/presentation/widgets/earn_custody_risk_banner.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

part '../../../widgets/savings/savings_risk_assessment_questions.dart';
part '../../../widgets/savings/savings_risk_assessment_result.dart';
part '../../../widgets/savings/savings_risk_assessment_products_common.dart';

class SavingsRiskAssessmentPage extends ConsumerStatefulWidget {
  const SavingsRiskAssessmentPage({super.key, this.shellRenderMode});

  static const questionCardKey = Key('sc339_question_card');
  static const firstOptionKey = Key('sc339_first_option');
  static const previousButtonKey = Key('sc339_previous_button');
  static const resultCardKey = Key('sc339_result_card');
  static const recommendationsButtonKey = Key('sc339_recommendations_button');
  static const productsButtonKey = Key('sc339_products_button');
  static const resetButtonKey = Key('sc339_reset_button');

  static Key optionKey(String questionId, int value) {
    return Key('sc339_option_${questionId}_$value');
  }

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsRiskAssessmentPage> createState() =>
      _SavingsRiskAssessmentPageState();
}

class _SavingsRiskAssessmentPageState
    extends ConsumerState<SavingsRiskAssessmentPage> {
  int _currentQuestion = 0;
  bool _showResult = false;
  final Map<String, int> _answers = {};

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(savingsRiskAssessmentControllerProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollTailReserve =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x3
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x3) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Đánh giá Rủi ro',
      semanticIdentifier: 'SC-339',
      child: Material(
        color: AppColors.bg,
        child: controllerAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnSavings),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnSavings),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () =>
                  ref.invalidate(savingsRiskAssessmentSnapshotProvider),
            ),
          ),
          data: (controller) {
            final snapshot = controller.state.snapshot;
            return VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: _showResult ? snapshot.resultTitle : snapshot.title,
                subtitle: kSavingsToolsHeaderSubtitle,
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: EdgeInsetsDirectional.only(
                        bottom: scrollTailReserve,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.compact,
                        gap: VitContentGap.tight,
                        children: [
                          ...(_showResult
                              ? [
                                  _ResultView(
                                    snapshot: snapshot,
                                    result: controller.resultForAnswers(
                                      _answers,
                                    ),
                                    score: controller.score(_answers),
                                    onReset: _reset,
                                  ),
                                ]
                              : [
                                  _ProgressHeader(
                                    currentQuestion: _currentQuestion,
                                    totalQuestions: snapshot.questions.length,
                                  ),
                                  const VitHighRiskStatePanel(
                                    state: VitHighRiskUiState.riskReview,
                                    title: 'Risk assessment in review',
                                    message:
                                        'Answers are used only to classify suitability, risk tolerance, lockup comfort and next-step product review.',
                                    contractId: 'savings-risk-assessment',
                                  ),
                                  _QuestionCard(
                                    question:
                                        snapshot.questions[_currentQuestion],
                                    index: _currentQuestion,
                                    selectedValue:
                                        _answers[snapshot
                                            .questions[_currentQuestion]
                                            .id],
                                    onSelected: _selectOption,
                                    onPrevious: _previous,
                                  ),
                                  VitInfoCallout(
                                    message: snapshot.infoText,
                                    padding:
                                        EarnSpacingTokens.earnCardPaddingX3,
                                  ),
                                ]),
                          const SavingsToolsYieldFooter(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _selectOption(SavingsRiskQuestionDraft question, int value) {
    unawaited(HapticFeedback.selectionClick());
    // Bẫy 15 (GD4 playbook): repo trong event handler — đọc lười qua
    // `.value` (đã có sẵn vì câu hỏi chỉ render trong nhánh data:).
    final questionsLength = ref
        .read(savingsRiskAssessmentSnapshotProvider)
        .value
        ?.questions
        .length;
    if (questionsLength == null) return;
    setState(() {
      _answers[question.id] = value;
      if (_currentQuestion < questionsLength - 1) {
        _currentQuestion += 1;
      } else {
        _showResult = true;
      }
    });
  }

  void _previous() {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      if (_currentQuestion > 0) _currentQuestion -= 1;
    });
  }

  void _reset() {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _currentQuestion = 0;
      _showResult = false;
      _answers.clear();
    });
  }
}
