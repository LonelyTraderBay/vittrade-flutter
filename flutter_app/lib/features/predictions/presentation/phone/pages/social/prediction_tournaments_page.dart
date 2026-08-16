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
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/phone/prediction_enum_tab_bar.dart';
import 'package:vit_trade_flutter/app/theme/spacing/predictions_spacing_tokens.dart';

part '../../../widgets/social/prediction_tournaments_detail.dart';
part '../../../widgets/social/prediction_tournaments_list.dart';
part '../../../widgets/social/prediction_tournaments_stats.dart';
part '../../../widgets/social/prediction_tournaments_empty_leaderboard.dart';

const _predictionPrimary = AppColors.primary;

enum _TournamentTab { active, mine, ended }

class PredictionTournamentsPage extends ConsumerStatefulWidget {
  const PredictionTournamentsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc042_tournaments_content');
  static const activeTabKey = Key('sc042_tab_active');
  static const mineTabKey = Key('sc042_tab_mine');
  static const endedTabKey = Key('sc042_tab_ended');

  static Key tournamentKey(String id) => Key('sc042_tournament_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PredictionTournamentsPage> createState() =>
      _PredictionTournamentsPageState();
}

class _PredictionTournamentsPageState
    extends ConsumerState<PredictionTournamentsPage> {
  _TournamentTab _activeTab = _TournamentTab.active;

  @override
  Widget build(BuildContext context) {
    final tournamentsAsync = ref.watch(predictionsTournamentsSnapshotProvider);
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
      semanticLabel: 'Giải đấu dự đoán',
      semanticIdentifier: 'SC-042',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Tournaments',
            subtitle: 'Giải đấu · Prediction',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.marketsPredictions),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TournamentTabBar(
                activeTab: _activeTab,
                onChanged: (tab) => setState(() => _activeTab = tab),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: PredictionTournamentsPage.contentKey,
                    padding:
                        PredictionsSpacingTokens.predictionTournamentScrollPadding(
                          footerPadding,
                        ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      density: VitDensity.compact,
                      children: tournamentsAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được giải đấu',
                            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              predictionsTournamentsSnapshotProvider,
                            ),
                          ),
                        ],
                        data: (snapshot) => switch (_activeTab) {
                          _TournamentTab.active => [
                            for (final tournament
                                in snapshot.activeTournaments.where(
                                  (item) => item.featured,
                                ))
                              _FeaturedTournamentBlock(tournament: tournament),
                            _TournamentSection(
                              label: 'Tat ca giai dau',
                              tournaments: snapshot.activeTournaments
                                  .where((item) => !item.featured)
                                  .toList(),
                            ),
                            _TournamentSection(
                              label: 'Sap dien ra',
                              tournaments: snapshot.upcomingTournaments,
                            ),
                            const _TournamentInfoCard(),
                          ],
                          _TournamentTab.mine => [
                            _MyTournamentStats(snapshot: snapshot),
                            _TournamentSection(
                              label: 'Giai dau dang tham gia',
                              tournaments: snapshot.myTournaments,
                              empty: const _EmptyTournamentsCard(),
                            ),
                          ],
                          _TournamentTab.ended => [
                            _TournamentSection(
                              label: 'Giai dau da ket thuc',
                              tournaments: snapshot.pastTournaments,
                              empty: const _NoPastTournamentsCard(),
                            ),
                            if (snapshot.pastTournaments.isNotEmpty)
                              _FinalLeaderboard(entries: snapshot.leaderboard),
                          ],
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
}
