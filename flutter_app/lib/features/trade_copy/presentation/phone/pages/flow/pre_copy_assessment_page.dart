import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_copy_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/widgets/phone/copy_trading_list.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/entities/trade_copy_entities.dart';

const _assessmentPrimary = AppColors.primary;

class PreCopyAssessmentPage extends ConsumerStatefulWidget {
  const PreCopyAssessmentPage({
    super.key,
    required this.providerId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc071_pre_copy_assessment_content');
  static const startKey = Key('sc071_pre_copy_assessment_start');
  static const continueKey = Key('sc071_pre_copy_assessment_continue');

  final String providerId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PreCopyAssessmentPage> createState() =>
      _PreCopyAssessmentPageState();
}

class _PreCopyAssessmentPageState extends ConsumerState<PreCopyAssessmentPage> {
  bool _started = false;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(
      tradePreCopyAssessmentProvider(widget.providerId),
    );

    return snapshotAsync.when(
      loading: () => VitTradeDetailScaffold(
        title: 'Đánh giá rủi ro',
        semanticLabel: 'Đánh giá rủi ro trước khi copy',
        semanticIdentifier: 'SC-071',
        contentKey: PreCopyAssessmentPage.contentKey,
        shellRenderMode: widget.shellRenderMode,
        useCopyTradingInset: true,
        showProductTabs: false,
        onBack: () => goBackOrFallback(
          context,
          fallbackPath: AppRoutePaths.tradeCopyProvider(widget.providerId),
          mode: BackNavigationMode.historyThenFallback,
        ),
        children: const [VitSkeletonList()],
      ),
      error: (error, stackTrace) => VitTradeDetailScaffold(
        title: 'Đánh giá rủi ro',
        semanticLabel: 'Đánh giá rủi ro trước khi copy',
        semanticIdentifier: 'SC-071',
        contentKey: PreCopyAssessmentPage.contentKey,
        shellRenderMode: widget.shellRenderMode,
        useCopyTradingInset: true,
        showProductTabs: false,
        onBack: () => goBackOrFallback(
          context,
          fallbackPath: AppRoutePaths.tradeCopyProvider(widget.providerId),
          mode: BackNavigationMode.historyThenFallback,
        ),
        children: [
          VitErrorState(
            title: 'Không tải được đánh giá rủi ro',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(
              tradePreCopyAssessmentProvider(widget.providerId),
            ),
          ),
        ],
      ),
      data: (snapshot) {
        if (snapshot.isNotFound) {
          return const VitPageLayout(
            variant: VitPageVariant.flush,
            semanticLabel: 'Đánh giá rủi ro trước khi copy',
            semanticIdentifier: 'SC-071',
            child: SizedBox.expand(),
          );
        }

        return VitTradeDetailScaffold(
          title: _started ? 'Câu hỏi đánh giá' : 'Đánh giá rủi ro',
          semanticLabel: 'Đánh giá rủi ro trước khi copy',
          semanticIdentifier: 'SC-071',
          contentKey: PreCopyAssessmentPage.contentKey,
          shellRenderMode: widget.shellRenderMode,
          useCopyTradingInset: true,
          showProductTabs: false,
          onBack: () => goBackOrFallback(
            context,
            fallbackPath: AppRoutePaths.tradeCopyProvider(widget.providerId),
            mode: BackNavigationMode.historyThenFallback,
          ),
          children: [
            _started
                ? VitTradeSection(
                    title: 'Câu hỏi',
                    child: _QuestionsSummary(snapshot: snapshot),
                  )
                : VitTradeSection(
                    title: 'Bắt đầu',
                    child: _WelcomeAssessment(
                      snapshot: snapshot,
                      onStart: () => setState(() => _started = true),
                    ),
                  ),
          ],
        );
      },
    );
  }
}

class _WelcomeAssessment extends StatelessWidget {
  const _WelcomeAssessment({required this.snapshot, required this.onStart});

  final TradePreCopyAssessmentSnapshot snapshot;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final provider = snapshot.provider!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const CopyTradingRiskWarningCard(
          title: 'Đánh giá bắt buộc trước khi copy',
          message:
              'Copy trading không đảm bảo lợi nhuận. Quá khứ không báo hiệu tương lai.',
          contractId: 'sc071-pre-copy-risk',
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        const _NoticeCard(
          title: 'Đánh giá bắt buộc (MiFID II)',
          text:
              'Chúng tôi cần đánh giá sự phù hợp của Copy Trading với kiến thức, kinh nghiệm và mục tiêu đầu tư của bạn.',
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        VitCard(
          radius: VitCardRadius.tight,
          padding: TradeSpacingTokens.preCopyAssessmentCardPadding,
          child: Row(
            children: [
              VitAssetAvatar(
                label: provider.avatar,
                accentColor: _assessmentPrimary,
                size: AppSpacing.iconLg,
                radius: AppRadii.cardRadius,
                border: true,
              ),
              const SizedBox(width: AppSpacing.pageRhythmFormInnerGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.name,
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.extraBold,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.x1 + AppSpacing.hairlineStroke,
                    ),
                    Text(
                      'Lợi nhuận +${provider.totalPnlPct.toStringAsFixed(1)}% · Drawdown tối đa ${provider.maxDrawdown.toStringAsFixed(1)}%',
                      style: AppTextStyles.navLabel.copyWith(
                        color: AppColors.text3,
                        fontWeight: AppTextStyles.normal,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.ctaLoadingIcon),
        for (final item in [
          (
            'Trả lời câu hỏi',
            '${snapshot.questions.length} câu hỏi về kinh nghiệm và rủi ro',
          ),
          (
            'Đọc tài liệu',
            '${snapshot.educationDocs.length} tài liệu bắt buộc',
          ),
          ('Nhận kết quả', 'Khuyến nghị phân bổ vốn và cooling-off'),
        ]) ...[
          _ProcessRow(title: item.$1, description: item.$2),
          const SizedBox(height: AppSpacing.pageRhythmFormInnerGap),
        ],
        VitCtaButton(
          key: PreCopyAssessmentPage.startKey,
          onPressed: onStart,
          density: VitDensity.tool,
          trailing: const Icon(Icons.chevron_right_rounded, size: 18),
          child: Text(
            'Bắt đầu đánh giá',
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.onAccent,
              fontWeight: AppTextStyles.extraBold,
            ),
          ),
        ),
      ],
    );
  }
}

class _QuestionsSummary extends StatelessWidget {
  const _QuestionsSummary({required this.snapshot});

  final TradePreCopyAssessmentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitHighRiskStatePanel(
          state: VitHighRiskUiState.riskReview,
          title: 'Xác nhận kết quả phù hợp',
          message:
              'Xác nhận rủi ro, giới hạn vốn, thời gian chờ và bước tiếp theo trước khi cấu hình copy trading.',
          density: VitDensity.tool,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        for (final question in snapshot.questions) ...[
          VitCard(
            radius: VitCardRadius.tight,
            padding: TradeSpacingTokens.preCopyAssessmentCardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.question,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.extraBold,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                Text(
                  question.description,
                  style: AppTextStyles.navLabel.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.normal,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmFormInnerGap),
                for (final option in question.options)
                  Padding(
                    padding: TradeSpacingTokens.preCopyAssessmentOptionMargin,
                    child: _OptionRow(option: option),
                  ),
              ],
            ),
          ),
          if (question != snapshot.questions.last)
            const SizedBox(height: AppSpacing.rowGap),
        ],
        const SizedBox(height: TradeSpacingTokens.preCopyAssessmentCtaGap),
        VitCtaButton(
          key: PreCopyAssessmentPage.continueKey,
          onPressed: () => context.push(
            AppRoutePaths.tradeCopyProviderConfiguration(snapshot.providerId),
          ),
          variant: VitCtaButtonVariant.success,
          density: VitDensity.tool,
          trailing: const Icon(Icons.chevron_right_rounded, size: 18),
          child: Text(
            'Tiếp tục cấu hình',
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.onAccent,
              fontWeight: AppTextStyles.extraBold,
            ),
          ),
        ),
      ],
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return VitHighRiskStatePanel(
      state: VitHighRiskUiState.riskReview,
      title: title,
      message: text,
      density: VitDensity.tool,
    );
  }
}

class _ProcessRow extends StatelessWidget {
  const _ProcessRow({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: AppSpacing.pageRhythmStandardSectionGap,
          backgroundColor: AppColors.primary15,
          child: Icon(Icons.check_rounded, color: _assessmentPrimary, size: 17),
        ),
        const SizedBox(width: AppSpacing.pageRhythmFormInnerGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.extraBold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                description,
                style: AppTextStyles.navLabel.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({required this.option});

  final TradePreCopyOption option;

  @override
  Widget build(BuildContext context) {
    return VitCardStat(
      padding: TradeSpacingTokens.preCopyAssessmentOptionCardPadding,
      child: Text(
        option.label,
        style: AppTextStyles.caption.copyWith(color: AppColors.text2),
      ),
    );
  }
}
