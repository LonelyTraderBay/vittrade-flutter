import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/phone/arena_viewport_padding.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/arena_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/arena_spacing_tokens.dart';

const _arenaAccent = AppModuleAccents.arena;
const _resolutionBodyLineRatio =
    ArenaSpacingTokens.arenaResolutionBodyLineHeight;

class ArenaResolutionCenterPage extends ConsumerWidget {
  const ArenaResolutionCenterPage({super.key, this.shellRenderMode});

  final ShellRenderMode? shellRenderMode;

  static const emptyKey = Key('sc192_resolution_empty');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(arenaResolutionCenterSnapshotProvider);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final footerPadding = arenaFooterPadding(
      context,
      mode,
      visualExtra: AppSpacing.x3,
      nativeExtra: AppSpacing.x2,
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Trung tâm chốt kết quả thử thách trong Open Arena',
      semanticIdentifier: 'SC-192',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Chốt kết quả',
            subtitle: 'Resolution · Open Arena',
            showBack: true,
            onBack: () {
              if (context.canPop()) {
                context.pop();
                return;
              }
              context.go(AppRoutePaths.arena);
            },
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
                    physics: const ClampingScrollPhysics(),
                    padding: ArenaSpacingTokens.arenaBottomScrollPadding(
                      footerPadding,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      padding: VitContentPadding.compact,
                      gap: VitContentGap.tight,
                      children: snapshotAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được Trung tâm chốt kết quả',
                            message: 'Vui lòng kiểm tra kết nối và thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              arenaResolutionCenterSnapshotProvider,
                            ),
                          ),
                        ],
                        data: (snapshot) => [
                          VitCard(
                            padding: AppSpacing.zeroInsets,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: VitEmptyState(
                                key: emptyKey,
                                icon: Icons.warning_amber_rounded,
                                title: snapshot.emptyTitle,
                                message: snapshot.emptySubtitle,
                              ),
                            ),
                          ),
                          const _ResolutionStatusCard(
                            icon: Icons.rule_folder_outlined,
                            title: 'Phạm vi chốt kết quả',
                            body:
                                'Bằng chứng creator, rà soát oracle và kết quả kiểm duyệt được gom tại đây khi thử thách cần quyết định cuối.',
                          ),
                          const _ResolutionStatusCard(
                            icon: Icons.verified_user_outlined,
                            title: 'Toàn vẹn điểm Arena',
                            body:
                                'Open Arena tạm dừng thay đổi điểm cho đến khi rà soát kết thúc và ghi quyết định cuối vào sổ điểm.',
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

class _ResolutionStatusCard extends StatelessWidget {
  const _ResolutionStatusCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: _arenaAccent,
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.accent, size: AppSpacing.iconMd),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const Padding(padding: ArenaSpacingTokens.arenaTopPaddingX1),
                Text(
                  body,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: _resolutionBodyLineRatio,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
