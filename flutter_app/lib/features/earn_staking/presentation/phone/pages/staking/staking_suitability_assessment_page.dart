import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
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

part '../../../widgets/staking/staking_suitability_assessment_page_sections.dart';
part '../../../widgets/staking/staking_suitability_assessment_page_common.dart';

const double _stakingSuitabilityFooterVisualClearance = 72;
const double _stakingSuitabilityFooterNativeClearance = 56;
const double _stakingSuitabilityScoreRing = 104;
const double _stakingSuitabilityBodyLineHeight = 1.24;
const double _stakingSuitabilityFooterLineHeight = 1.2;
const double _stakingSuitabilityQuestionLineHeight = 1.16;
const double _stakingSuitabilityOptionLineHeight = 1.18;
const EdgeInsetsDirectional _stakingSuitabilityCardPadding =
    EdgeInsetsDirectional.all(AppSpacing.x3);
const EdgeInsetsDirectional _stakingSuitabilityOptionPadding =
    EdgeInsetsDirectional.symmetric(
      horizontal: AppSpacing.x3,
      vertical: AppSpacing.x3,
    );

class StakingSuitabilityAssessmentPage extends ConsumerStatefulWidget {
  const StakingSuitabilityAssessmentPage({super.key, this.shellRenderMode});

  static const progressKey = Key('sc376_progress');
  static const questionCardKey = Key('sc376_question_card');
  static const infoKey = Key('sc376_info');
  static const previousButtonKey = Key('sc376_previous_button');
  static const nextButtonKey = Key('sc376_next_button');
  static const resultCardKey = Key('sc376_result_card');
  static const exploreButtonKey = Key('sc376_explore_button');
  static const resetButtonKey = Key('sc376_reset_button');

  static Key optionKey(String questionId, int index) {
    return Key('sc376_option_${questionId}_$index');
  }

  static Key quizOptionKey(int questionIndex, int optionIndex) {
    return Key('sc376_quiz_${questionIndex}_$optionIndex');
  }

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingSuitabilityAssessmentPage> createState() =>
      _StakingSuitabilityAssessmentPageState();
}

class _StakingSuitabilityAssessmentPageState
    extends ConsumerState<StakingSuitabilityAssessmentPage> {
  int _step = 0;
  bool _showResult = false;
  final Map<String, int> _answers = {};
  final Map<int, int> _quizAnswers = {};

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(stakingSuitabilityControllerProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final safeAreaEnd = MediaQuery.paddingOf(context).bottom;
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        safeAreaEnd;
    final scrollEndPadding = bottomInset;
    final footerEndPadding =
        (mode.usesVisualQaFrame
            ? _stakingSuitabilityFooterVisualClearance
            : _stakingSuitabilityFooterNativeClearance) +
        safeAreaEnd;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Đánh giá mức độ phù hợp trước khi staking',
      semanticIdentifier: 'SC-376',
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
                  ref.invalidate(stakingSuitabilityAssessmentSnapshotProvider),
            ),
          ),
          data: (controller) {
            final snapshot = controller.state.snapshot;
            return VitAutoHideHeaderScaffold(
              header: VitTopChrome(
                type: VitTopChromeType.detail,
                title: _showResult ? snapshot.resultTitle : snapshot.title,
                subtitle: 'Đánh giá phù hợp trước khi stake',
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
                        scrollEndPadding,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.compact,
                        density: VitDensity.compact,
                        children: _showResult
                            ? [
                                _ResultView(
                                  snapshot: snapshot,
                                  profile: controller.profileForScore(
                                    controller.score(
                                      answers: _answers,
                                      quizAnswers: _quizAnswers,
                                    ),
                                  ),
                                  score: controller.score(
                                    answers: _answers,
                                    quizAnswers: _quizAnswers,
                                  ),
                                  onReset: _reset,
                                ),
                              ]
                            : [
                                _ProgressHeader(
                                  current: _step,
                                  total: snapshot.questions.length,
                                ),
                                const VitHighRiskStatePanel(
                                  density: VitDensity.compact,
                                  state: VitHighRiskUiState.riskReview,
                                  title: 'Đánh giá phù hợp sản phẩm',
                                  message:
                                      'Câu trả lời được đối chiếu với kinh nghiệm, thanh khoản, thu nhập, phân bổ và giới hạn kiến thức trước khi stake.',
                                  contractId: 'staking-suitability-assessment',
                                ),
                                _QuestionCard(
                                  question: snapshot.questions[_step],
                                  selected:
                                      _answers[snapshot.questions[_step].id],
                                  quizAnswers: _quizAnswers,
                                  onSelect: _selectAnswer,
                                  onQuizSelect: _selectQuizAnswer,
                                ),
                                if (_step == 0)
                                  VitInfoCallout(
                                    key: StakingSuitabilityAssessmentPage
                                        .infoKey,
                                    title: snapshot.infoTitle,
                                    message: snapshot.infoBody,
                                    icon: Icons.shield_outlined,
                                    accentColor: AppColors.primarySoft,
                                    padding: _stakingSuitabilityCardPadding,
                                  ),
                              ],
                      ),
                    ),
                  ),
                  if (!_showResult)
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                        bottom: footerEndPadding,
                      ),
                      child: VitStickyFooter(
                        child: Row(
                          children: [
                            if (_step > 0) ...[
                              Expanded(
                                child: VitCtaButton(
                                  key: StakingSuitabilityAssessmentPage
                                      .previousButtonKey,
                                  variant: VitCtaButtonVariant.secondary,
                                  density: VitDensity.compact,
                                  onPressed: _previous,
                                  child: const Text('Previous'),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.x3),
                            ],
                            Expanded(
                              child: VitCtaButton(
                                key: StakingSuitabilityAssessmentPage
                                    .nextButtonKey,
                                density: VitDensity.compact,
                                onPressed:
                                    _isAnswered(
                                      controller,
                                      snapshot.questions[_step],
                                    )
                                    ? () => _next(snapshot)
                                    : null,
                                child: Text(
                                  _step == snapshot.questions.length - 1
                                      ? 'Submit'
                                      : 'Next',
                                ),
                              ),
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

  void _selectAnswer(String questionId, int value) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _answers[questionId] = value);
  }

  void _selectQuizAnswer(int questionIndex, int optionIndex) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _quizAnswers[questionIndex] = optionIndex);
  }

  bool _isAnswered(
    StakingSuitabilityController controller,
    StakingSuitabilityQuestionDraft question,
  ) {
    return controller.isAnswered(
      question,
      answers: _answers,
      quizAnswers: _quizAnswers,
    );
  }

  void _next(StakingSuitabilityAssessmentSnapshot snapshot) {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      if (_step < snapshot.questions.length - 1) {
        _step += 1;
        _quizAnswers.clear();
      } else {
        _showResult = true;
      }
    });
  }

  void _previous() {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      if (_step > 0) _step -= 1;
    });
  }

  void _reset() {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _step = 0;
      _showResult = false;
      _answers.clear();
      _quizAnswers.clear();
    });
  }
}
