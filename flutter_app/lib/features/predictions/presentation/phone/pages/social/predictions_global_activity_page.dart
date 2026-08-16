import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/predictions_controller_providers.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/controllers/predictions_controller.dart';

part '../../../widgets/social/predictions_global_activity_widgets.dart';
part '../../../widgets/social/predictions_global_activity_feed_widgets.dart';

const _predictionPrimary = AppColors.primary;
const double _activityFramedScrollClearance =
    AppSpacing.buttonStandard + AppSpacing.x7;
const double _activityNativeScrollClearance =
    AppSpacing.buttonStandard + AppSpacing.x5;
const double _activityAvatarExtent = AppSpacing.buttonCompact;
const double _activityAmountExtent = AppSpacing.buttonStandard + AppSpacing.x2;

class PredictionsGlobalActivityPage extends ConsumerStatefulWidget {
  const PredictionsGlobalActivityPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc034_predictions_activity_content');
  static const allFilterKey = Key('sc034_filter_all');
  static const amount100FilterKey = Key('sc034_filter_100');
  static const amount500FilterKey = Key('sc034_filter_500');

  static Key activityKey(String id) => Key('sc034_activity_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PredictionsGlobalActivityPage> createState() =>
      _PredictionsGlobalActivityPageState();
}

class _PredictionsGlobalActivityPageState
    extends ConsumerState<PredictionsGlobalActivityPage> {
  double _minAmount = 0;

  @override
  Widget build(BuildContext context) {
    final activityAsync = ref.watch(
      predictionsGlobalActivitySnapshotProvider(_minAmount),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? _activityFramedScrollClearance
            : _activityNativeScrollClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Hoạt động giao dịch dự đoán toàn cầu',
      semanticIdentifier: 'SC-034',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Global Activity',
            subtitle: 'Hoạt động · Prediction',
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
                  child: VitInsetScrollView(
                    key: PredictionsGlobalActivityPage.contentKey,
                    bottomInset: scrollEndClearance,
                    child: VitPageContent(
                      rhythm: VitPageRhythm.compact,
                      padding: VitContentPadding.compact,
                      density: VitDensity.compact,
                      children: activityAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được hoạt động toàn cầu',
                            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              predictionsGlobalActivitySnapshotProvider(
                                _minAmount,
                              ),
                            ),
                          ),
                        ],
                        data: (snapshot) => [
                          _LiveStats(snapshot: snapshot),
                          _AmountFilters(
                            active: _minAmount,
                            onSelected: (value) => setState(() {
                              _minAmount = value;
                            }),
                          ),
                          if (snapshot.activities.isEmpty)
                            const VitEmptyState(
                              title: 'No activity found',
                              message: 'Lower the minimum amount filter',
                              icon: Icons.timeline_rounded,
                            )
                          else
                            _ActivityList(snapshot: snapshot),
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
