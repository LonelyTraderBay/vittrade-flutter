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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_staking_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

part '../../../widgets/staking/staking_risk_assessment_page_sections.dart';
part '../../../widgets/staking/staking_risk_assessment_page_common.dart';

class StakingRiskAssessmentPage extends ConsumerStatefulWidget {
  const StakingRiskAssessmentPage({super.key, this.shellRenderMode});

  static const questionCardKey = Key('sc357_question_card');
  static const firstOptionKey = Key('sc357_first_option');
  static const previousButtonKey = Key('sc357_previous_button');
  static const resultCardKey = Key('sc357_result_card');
  static const exploreButtonKey = Key('sc357_explore_button');
  static const resetButtonKey = Key('sc357_reset_button');

  static Key optionKey(String questionId, int value) {
    return Key('sc357_option_${questionId}_$value');
  }

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingRiskAssessmentPage> createState() =>
      _StakingRiskAssessmentPageState();
}

class _StakingRiskAssessmentPageState
    extends ConsumerState<StakingRiskAssessmentPage> {
  int _currentQuestion = 0;
  bool _showResult = false;
  final Map<String, int> _answers = {};

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(stakingRiskAssessmentControllerProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollTailReserve =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Đánh giá rủi ro trước khi chọn sản phẩm staking',
      semanticIdentifier: 'SC-357',
      child: Material(
        color: AppColors.bg,
        child: controllerAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnStaking),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnStaking),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () =>
                  ref.invalidate(stakingRiskAssessmentSnapshotProvider),
            ),
          ),
          data: (controller) {
            final snapshot = controller.state.snapshot;
            return VitAutoHideHeaderScaffold(
              header: VitTopChrome(
                type: VitTopChromeType.detail,
                title: _showResult ? snapshot.resultTitle : snapshot.title,
                subtitle: _showResult
                    ? snapshot.footerDisclaimer
                    : 'Đánh giá trước khi chọn sản phẩm stake',
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: EarnSpacingTokens.earnBottomInsetPadding(
                        scrollTailReserve,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.compact,
                        gap: VitContentGap.tight,
                        children: _showResult
                            ? [
                                _ResultView(
                                  snapshot: snapshot,
                                  result: controller.resultForAnswers(_answers),
                                  score: controller.score(_answers),
                                  maxScore: controller.state.maxScore,
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
                                  title: 'Đánh giá rủi ro staking',
                                  message:
                                      'Câu trả lời phân loại kiến thức, nhu cầu thanh khoản, phản ứng rủi ro và giới hạn phân bổ trước khi chọn sản phẩm.',
                                  contractId: 'staking-risk-assessment',
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
                                  icon: Icons.info_outline_rounded,
                                  accentColor: AppColors.primary,
                                  padding: EarnSpacingTokens.earnCardPaddingX3,
                                ),
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

  void _selectOption(StakingRiskQuestionDraft question, int value) {
    unawaited(HapticFeedback.selectionClick());
    // Bẫy 15 (GD4 playbook): repo trong event handler — đọc lười qua
    // `.value` (đã có sẵn vì câu hỏi chỉ render trong nhánh data:).
    final questionsLength = ref
        .read(stakingRiskAssessmentSnapshotProvider)
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
