import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
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
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';
import 'package:vit_trade_flutter/app/theme/spacing/arena_spacing_tokens.dart';

part '../../../widgets/points/arena_points_entry_detail_page_sections.dart';
part '../../../widgets/points/arena_points_entry_detail_page_common.dart';

const _arenaAccent = AppModuleAccents.arena;
const _entryBodyLineRatio = ArenaSpacingTokens.arenaPointsBodyLineHeight;
const _entryNoticeLineRatio = ArenaSpacingTokens.arenaPointsNoticeLineHeight;
const _entrySectionMarkerExtent =
    ArenaSpacingTokens.arenaPointsEntrySectionMarkerHeight;

class ArenaPointsEntryDetailPage extends ConsumerStatefulWidget {
  const ArenaPointsEntryDetailPage({
    super.key,
    required this.entryId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc200_entry_content');
  static const challengeLinkKey = Key('sc200_challenge_link');
  static const modeLinkKey = Key('sc200_mode_link');
  static const copyRefKey = Key('sc200_copy_ref');
  static const supportKey = Key('sc200_support');

  final String entryId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaPointsEntryDetailPage> createState() =>
      _ArenaPointsEntryDetailPageState();
}

class _ArenaPointsEntryDetailPageState
    extends ConsumerState<ArenaPointsEntryDetailPage> {
  bool _copied = false;
  bool _supportOpened = false;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(
      arenaPointsEntryDetailSnapshotProvider(widget.entryId),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final footerPadding = arenaFooterPadding(
      context,
      mode,
      visualExtra: AppSpacing.x3,
      nativeExtra: AppSpacing.x2,
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Chi tiết giao dịch điểm Arena Points trong Open Arena',
      semanticIdentifier: 'SC-200',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Chi tiết giao dịch điểm',
            subtitle: 'Arena Points · Open Arena',
            showBack: true,
            onBack: () => _close(context),
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
                    key: ArenaPointsEntryDetailPage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: ArenaSpacingTokens.arenaBottomScrollPadding(
                      footerPadding,
                    ),
                    child: snapshotAsync.when(
                      loading: () => const VitSkeletonList(),
                      error: (error, stackTrace) => VitErrorState(
                        title: 'Không tải được giao dịch điểm',
                        message: 'Vui lòng kiểm tra kết nối và thử lại.',
                        actionLabel: 'Thử lại',
                        onAction: () => ref.invalidate(
                          arenaPointsEntryDetailSnapshotProvider(
                            widget.entryId,
                          ),
                        ),
                      ),
                      data: (snapshot) => snapshot.entry == null
                          ? VitPageContent(
                              rhythm: VitPageRhythm.standard,
                              padding: VitContentPadding.none,
                              children: [
                                VitEmptyState(
                                  icon: Icons.warning_amber_rounded,
                                  title: snapshot.emptyTitle,
                                  message: snapshot.emptySubtitle,
                                ),
                              ],
                            )
                          : VitPageContent(
                              padding: VitContentPadding.compact,
                              gap: VitContentGap.tight,
                              children: [
                                _AmountHero(entry: snapshot.entry!),
                                _EntryDetails(entry: snapshot.entry!),
                                _BalanceCard(entry: snapshot.entry!),
                                _ReferenceCard(
                                  entry: snapshot.entry!,
                                  copied: _copied,
                                  onCopy: () => _copyReference(snapshot.entry!),
                                ),
                                _AuditNotice(disclaimer: snapshot.disclaimer),
                                if (_supportOpened)
                                  const VitStatusPill(
                                    label: 'Hỗ trợ đã nhận yêu cầu',
                                    status: VitStatusPillStatus.info,
                                    size: VitStatusPillSize.md,
                                  ),
                                _EntryActions(
                                  entry: snapshot.entry!,
                                  onSupport: () {
                                    unawaited(HapticFeedback.selectionClick());
                                    setState(() => _supportOpened = true);
                                  },
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

  void _copyReference(ArenaPointsEntryDraft entry) {
    unawaited(HapticFeedback.selectionClick());
    unawaited(Clipboard.setData(ClipboardData(text: entry.refId)));
    setState(() => _copied = true);
  }

  static void _close(BuildContext context) {
    unawaited(HapticFeedback.selectionClick());
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.arenaLedger);
  }
}
