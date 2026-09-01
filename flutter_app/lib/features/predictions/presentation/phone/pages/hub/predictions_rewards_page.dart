import 'dart:async';

import 'package:flutter/material.dart';
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
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/predictions_controller_providers.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/controllers/predictions_controller.dart';
import 'package:vit_trade_flutter/app/theme/spacing/predictions_spacing_tokens.dart';

part '../../../widgets/phone/predictions_rewards_hero_filters.dart';
part '../../../widgets/phone/predictions_rewards_table.dart';
part '../../../widgets/phone/predictions_rewards_arena_common.dart';

const _predictionPrimary = AppColors.primary;

class PredictionsRewardsPage extends ConsumerStatefulWidget {
  const PredictionsRewardsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc032_predictions_rewards_content');
  static const allFilterKey = Key('sc032_filter_all');
  static const liveCryptoFilterKey = Key('sc032_filter_live_crypto');
  static const favoritesFilterKey = Key('sc032_filter_favorites');
  static const riskExplainerKey = Key('sc032_risk_explainer');
  static const arenaBridgeKey = Key('sc032_arena_bridge');

  static Key rewardKey(String id) => Key('sc032_reward_$id');
  static Key favoriteKey(String id) => Key('sc032_favorite_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PredictionsRewardsPage> createState() =>
      _PredictionsRewardsPageState();
}

class _PredictionsRewardsPageState
    extends ConsumerState<PredictionsRewardsPage> {
  String _category = 'All';
  bool _favoritesOnly = false;
  // GD4-F5 (bẫy 14): seed lười trong nhánh `data:` — thay initState đọc repo
  // giờ đã async; `??=` chỉ seed 1 lần, không ghi đè khi user đã chỉnh.
  Set<String>? _favorites;

  @override
  Widget build(BuildContext context) {
    final rewardsAsync = ref.watch(predictionsRewardsSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final scrollEndPadding =
        navClearance +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : AppSpacing.contentPad);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Phần thưởng hằng ngày của thị trường dự đoán',
      semanticIdentifier: 'SC-032',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Daily Rewards',
            subtitle: 'Phần thưởng · Prediction',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.marketsPredictions),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: PredictionsRewardsPage.contentKey,
                    padding:
                        PredictionsSpacingTokens.predictionRewardsScrollPadding(
                          scrollEndPadding,
                        ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.compact,
                      density: VitDensity.compact,
                      children: rewardsAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được phần thưởng',
                            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              predictionsRewardsSnapshotProvider,
                            ),
                          ),
                        ],
                        data: (snapshot) {
                          _favorites ??= snapshot.rewards
                              .where((reward) => reward.isFavorite)
                              .map((reward) => reward.id)
                              .toSet();
                          final favorites = _favorites!;
                          final rewards = snapshot.rewards.where((reward) {
                            final categoryMatch =
                                _category == 'All' ||
                                reward.category == _category;
                            final favoriteMatch =
                                !_favoritesOnly ||
                                favorites.contains(reward.id);
                            return categoryMatch && favoriteMatch;
                          }).toList();

                          return [
                            _RewardsHero(snapshot: snapshot),
                            const _HowItWorksNote(),
                            _CategoryFilters(
                              categories: ['All', ...snapshot.categories],
                              activeCategory: _category,
                              favoritesOnly: _favoritesOnly,
                              onCategoryChanged: (value) => setState(() {
                                _category = value;
                              }),
                              onFavoritesToggle: () => setState(() {
                                _favoritesOnly = !_favoritesOnly;
                              }),
                            ),
                            _RewardsTable(
                              snapshot: snapshot,
                              rewards: rewards,
                              favorites: favorites,
                              onFavoriteToggle: (id) => setState(() {
                                if (!favorites.add(id)) favorites.remove(id);
                              }),
                            ),
                            _RiskLink(onTap: () => _showRiskSheet(context)),
                            _ArenaRooms(snapshot: snapshot),
                          ];
                        },
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

  void _showRiskSheet(BuildContext context) {
    unawaited(
      showVitBottomSheet<void>(
        context: context,
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadii.sheetTopRadius,
        ),
        builder: (context) {
          return Padding(
            padding: PredictionsSpacingTokens.predictionRewardsSheetPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reward không phải lợi nhuận đảm bảo',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  'Daily rewards phụ thuộc điều kiện spread, min shares, thời '
                  'gian giữ lệnh và thanh khoản thị trường.',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
