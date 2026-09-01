import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_bots_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_bots/domain/entities/trade_bots_entities.dart';

part '../../../widgets/settings/bot_suitability_questions_info.dart';
part '../../../widgets/settings/bot_suitability_result_score.dart';
part '../../../widgets/settings/bot_suitability_breakdown_common.dart';

const _assessmentPanel2 = AppColors.surface2;
const _assessmentPrimary = AppColors.primary;
const _assessmentOptionBorder = AppColors.borderSolid;
const _assessmentGreen = AppColors.buy;
const _assessmentAmber = AppColors.caution;
const _assessmentRed = AppColors.sell;

class BotSuitabilityAssessmentPage extends ConsumerStatefulWidget {
  const BotSuitabilityAssessmentPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc119_bot_suitability_content');
  static const resultContentKey = Key('sc119_bot_suitability_result_content');
  static const resultCtaKey = Key('sc119_bot_suitability_result_cta');
  static const infoKey = Key('sc119_bot_suitability_info');

  static Key optionKey(String questionId, String optionId) =>
      Key('sc119_bot_suitability_option_${questionId}_$optionId');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotSuitabilityAssessmentPage> createState() =>
      _BotSuitabilityAssessmentPageState();
}

class _BotSuitabilityAssessmentPageState
    extends ConsumerState<BotSuitabilityAssessmentPage> {
  int _currentQuestion = 0;
  bool _showResult = false;
  final Map<String, String> _answers = {};

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(tradeBotSuitabilityControllerProvider);
    return VitTradeHubScaffold(
      title: _showResult ? 'Kết quả đánh giá' : 'Đánh giá mức độ phù hợp',
      subtitle: 'Đánh giá mức độ phù hợp với bot',
      semanticLabel: 'Đánh giá mức độ phù hợp trước khi dùng bot',
      semanticIdentifier: 'SC-119',
      contentKey: _showResult
          ? BotSuitabilityAssessmentPage.resultContentKey
          : BotSuitabilityAssessmentPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      activeProductId: 'bots',
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeBots,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: controllerAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được đánh giá phù hợp',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () =>
                ref.invalidate(tradeBotSuitabilityAssessmentSnapshotProvider),
          ),
        ],
        data: (controller) {
          final snapshot = controller.state.snapshot;
          return [
            if (!_showResult)
              VitBotSubpageHero(
                primaryLabel: 'Câu hỏi',
                primaryValue:
                    '${_currentQuestion + 1}/${snapshot.questions.length}',
                secondaryLabel: 'Đã trả lời',
                secondaryValue: '${_answers.length}',
              ),
            if (_showResult)
              VitTradeSection(
                title: 'Kết quả',
                child: _ResultView(
                  snapshot: snapshot,
                  score: controller.score(_answers),
                  answers: _answers,
                  onComplete: _handleComplete,
                ),
              )
            else
              VitTradeSection(
                title: 'Câu hỏi',
                child: _QuestionView(
                  snapshot: snapshot,
                  currentQuestion: _currentQuestion,
                  answers: _answers,
                  onAnswer: _handleAnswer,
                ),
              ),
            const VitBotRiskReviewFooter(
              title: 'Xem lại rủi ro phù hợp với Bot',
              message:
                  'Xác nhận kiến thức, giới hạn rủi ro, mức độ tiếp xúc với tự động hoá, và bước tiếp theo trước khi bật Bot giao dịch.',
            ),
          ];
        },
      ),
    );
  }

  void _handleAnswer(String optionId) {
    final snapshot = ref
        .read(tradeBotSuitabilityControllerProvider)
        .value!
        .state
        .snapshot;
    final question = snapshot.questions[_currentQuestion];

    setState(() {
      _answers[question.id] = optionId;
      if (_currentQuestion < snapshot.questions.length - 1) {
        _currentQuestion += 1;
      } else {
        _showResult = true;
      }
    });
  }

  void _handleComplete(TradeBotSuitabilityOutcomeCopy result) {
    if (result.outcome == TradeBotSuitabilityOutcome.fail) return;
    final path = ref
        .read(tradeBotSuitabilityControllerProvider)
        .value!
        .completionPathFor(result);
    if (path.isNotEmpty) context.go(path);
  }
}
