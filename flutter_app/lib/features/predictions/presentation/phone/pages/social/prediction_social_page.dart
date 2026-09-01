import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
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
import 'package:vit_trade_flutter/app/providers/predictions_controller_providers.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/controllers/predictions_controller.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/social/prediction_social_support_widgets.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/phone/prediction_enum_tab_bar.dart';
import 'package:vit_trade_flutter/app/theme/spacing/predictions_spacing_tokens.dart';

part '../../../widgets/social/prediction_social_header_comments.dart';
part '../../../widgets/social/prediction_social_comment_list.dart';
part '../../../widgets/social/prediction_social_analysis_share.dart';

const _predictionPrimary = AppColors.primary;

enum _SocialTab { comments, analysis, share }

class PredictionSocialPage extends ConsumerStatefulWidget {
  const PredictionSocialPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc040_social_content');
  static const commentsTabKey = Key('sc040_tab_comments');
  static const analysisTabKey = Key('sc040_tab_analysis');
  static const shareTabKey = Key('sc040_tab_share');
  static const commentFieldKey = Key('sc040_comment_field');
  static const copyLinkKey = Key('sc040_copy_link');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PredictionSocialPage> createState() =>
      _PredictionSocialPageState();
}

class _PredictionSocialPageState extends ConsumerState<PredictionSocialPage> {
  _SocialTab _activeTab = _SocialTab.comments;
  PredictionSocialStance _selectedStance = PredictionSocialStance.neutral;
  late final TextEditingController _commentController;
  bool _copied = false;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController()..addListener(_refresh);
  }

  @override
  void dispose() {
    _commentController
      ..removeListener(_refresh)
      ..dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final socialAsync = ref.watch(predictionsSocialSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final footerChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final footerPadding =
        footerChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? AppSpacing.x5 : AppSpacing.x4);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Thảo luận xã hội về sự kiện dự đoán',
      semanticIdentifier: 'SC-040',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Social & Discussion',
            subtitle: 'Thảo luận · Prediction',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.marketsPredictions),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SocialTabBar(
                activeTab: _activeTab,
                onChanged: (tab) => setState(() => _activeTab = tab),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: PredictionSocialPage.contentKey,
                    padding:
                        PredictionsSpacingTokens.predictionSocialScrollPadding(
                          footerPadding,
                        ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      density: VitDensity.compact,
                      children: socialAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được nội dung thảo luận',
                            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              predictionsSocialSnapshotProvider,
                            ),
                          ),
                        ],
                        data: (snapshot) => [
                          ...switch (_activeTab) {
                            _SocialTab.comments => [
                              _EventInfoCard(snapshot: snapshot),
                              _NewCommentCard(
                                controller: _commentController,
                                selectedStance: _selectedStance,
                                onStanceChanged: (stance) =>
                                    setState(() => _selectedStance = stance),
                              ),
                              _CommentsSection(snapshot: snapshot),
                              const _CommentDisclaimer(),
                            ],
                            _SocialTab.analysis => [
                              _SentimentCard(snapshot: snapshot),
                              _ContributorsSection(snapshot: snapshot),
                              const _SentimentTrendCard(),
                            ],
                            _SocialTab.share => [
                              _SocialShareButtons(snapshot: snapshot),
                              _CopyLinkCard(
                                snapshot: snapshot,
                                copied: _copied,
                                onCopy: () {
                                  unawaited(
                                    Clipboard.setData(
                                      ClipboardData(text: snapshot.shareUrl),
                                    ),
                                  );
                                  setState(() => _copied = true);
                                },
                              ),
                              const _ShareStatsCard(),
                              _SharePreviewCard(snapshot: snapshot),
                            ],
                          },
                          const VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Prediction social review',
                            message:
                                'Comment stance, moderation context, sentiment analysis, contributor signals, share/copy feedback, and disclaimer states are reviewed before social trading signals influence a prediction decision.',
                            contractId: 'SC-040',
                            density: VitDensity.compact,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
