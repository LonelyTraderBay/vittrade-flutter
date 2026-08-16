import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
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

class StakingWebhooksPage extends ConsumerWidget {
  const StakingWebhooksPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc393_webhooks_hero');
  static const createKey = Key('sc393_create_webhook');
  static const activeKey = Key('sc393_active_webhooks');
  static const eventsKey = Key('sc393_available_events');
  static const createSheetKey = Key('sc393_create_sheet');
  static const urlFieldKey = Key('sc393_webhook_url_field');

  static Key webhookKey(String id) => Key('sc393_webhook_$id');

  static Key webhookDeleteKey(String id) => Key('sc393_delete_$id');

  static Key eventKey(String id) => Key('sc393_event_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingWebhooksSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Quản lý webhook thông báo sự kiện staking',
      semanticIdentifier: 'SC-393',
      child: Material(
        color: AppColors.bg,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earn),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earn),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(stakingWebhooksSnapshotProvider),
            ),
          ),
          data: (snapshot) {
            final mode = shellRenderMode ?? defaultShellRenderMode();
            final bottomInset =
                (mode.usesVisualQaFrame
                    ? DeviceMetrics.bottomChrome + AppSpacing.x7
                    : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
                MediaQuery.paddingOf(context).bottom;

            return VitAutoHideHeaderScaffold(
              header: VitTopChrome(
                type: VitTopChromeType.detail,
                title: snapshot.title,
                subtitle: 'Webhook staking — dữ liệu tham khảo',
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
                        bottomInset,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.defaultPadding,
                        gap: VitContentGap.defaultGap,
                        children: [
                          _WebhooksHero(snapshot: snapshot),
                          VitCtaButton(
                            key: createKey,
                            onPressed: () =>
                                _showCreateSheet(context, snapshot),
                            leading: const Icon(Icons.add_rounded),
                            child: Text(snapshot.createLabel),
                          ),
                          _ActiveWebhooks(snapshot: snapshot),
                          _AvailableEvents(snapshot: snapshot),
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

  void _showCreateSheet(
    BuildContext context,
    StakingWebhooksSnapshot snapshot,
  ) {
    unawaited(
      showVitBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.transparent,
        builder: (context) =>
            _SheetFrame(child: _CreateWebhookSheet(snapshot: snapshot)),
      ),
    );
  }
}

class _WebhooksHero extends StatelessWidget {
  const _WebhooksHero({required this.snapshot});

  final StakingWebhooksSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingWebhooksPage.heroKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      borderColor: AppColors.accent30,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            snapshot.heroTitle,
            style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            snapshot.heroBody,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: EarnSpacingTokens.stakingCommunityBodyLineHeight,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveWebhooks extends StatelessWidget {
  const _ActiveWebhooks({required this.snapshot});

  final StakingWebhooksSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingWebhooksPage.activeKey,
      label: snapshot.activeTitle,
      children: [
        for (final webhook in snapshot.webhooks) _WebhookCard(webhook: webhook),
      ],
    );
  }
}

class _WebhookCard extends StatelessWidget {
  const _WebhookCard({required this.webhook});

  final StakingWebhookDraft webhook;

  @override
  Widget build(BuildContext context) {
    final statusColor = webhook.active ? AppColors.buy : AppColors.sell;
    return VitCard(
      key: StakingWebhooksPage.webhookKey(webhook.id),
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3X4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      webhook.url,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Row(
                      children: [
                        Icon(
                          webhook.active
                              ? Icons.check_circle_outline_rounded
                              : Icons.cancel_outlined,
                          color: statusColor,
                          size: AppSpacing.iconSm,
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Expanded(
                          child: Text(
                            'Last: ${webhook.lastTriggered}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              VitIconButton(
                key: StakingWebhooksPage.webhookDeleteKey(webhook.id),
                icon: Icons.delete_outline_rounded,
                tooltip: 'Xóa webhook',
                variant: VitIconButtonVariant.danger,
                size: VitIconButtonSize.sm,
                onPressed: () {
                  unawaited(HapticFeedback.selectionClick());
                  unawaited(
                    showVitNoticeSheet(
                      context: context,
                      title: 'Sẽ sớm ra mắt',
                      message: 'Xóa webhook sẽ sớm ra mắt',
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final event in webhook.events)
                _EventChip(
                  key: StakingWebhooksPage.eventKey('${webhook.id}_$event'),
                  label: event,
                  selected: false,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AvailableEvents extends StatelessWidget {
  const _AvailableEvents({required this.snapshot});

  final StakingWebhooksSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingWebhooksPage.eventsKey,
      label: snapshot.eventsTitle,
      children: [
        VitCard(
          radius: VitCardRadius.large,
          padding: EarnSpacingTokens.earnCardPaddingX4,
          child: Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final event in snapshot.availableEvents)
                _EventChip(
                  key: StakingWebhooksPage.eventKey(event),
                  label: event,
                  selected: true,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EventChip extends StatelessWidget {
  const _EventChip({
    super.key,
    required this.label,
    required this.selected,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: label,
      selected: selected,
      onTap: onTap,
      padding: EarnSpacingTokens.earnSmallPillPadding,
      semanticLabel: 'Loại sự kiện webhook $label',
    );
  }
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EarnSpacingTokens.earnContentMargin,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.88,
          ),
          child: DecoratedBox(
            decoration: const ShapeDecoration(
              color: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadii.cardLargeRadius,
              ),
            ),
            child: Padding(
              padding: EarnSpacingTokens.earnCardPaddingX5,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _CreateWebhookSheet extends StatefulWidget {
  const _CreateWebhookSheet({required this.snapshot});

  final StakingWebhooksSnapshot snapshot;

  @override
  State<_CreateWebhookSheet> createState() => _CreateWebhookSheetState();
}

class _CreateWebhookSheetState extends State<_CreateWebhookSheet> {
  late final TextEditingController _controller;
  late final Set<String> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _selectedEvents = widget.snapshot.availableEvents.take(1).toSet();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final events = widget.snapshot.availableEvents.take(4).toList();
    return SingleChildScrollView(
      key: StakingWebhooksPage.createSheetKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.snapshot.sheetTitle,
            style: AppTextStyles.sectionTitle.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          VitInput(
            controller: _controller,
            fieldKey: StakingWebhooksPage.urlFieldKey,
            label: widget.snapshot.urlLabel,
            hintText: widget.snapshot.urlPlaceholder,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Text(
            widget.snapshot.eventsLabel,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final event in events)
                _EventChip(
                  key: StakingWebhooksPage.eventKey('sheet_$event'),
                  label: event,
                  selected: _selectedEvents.contains(event),
                  onTap: () {
                    setState(() {
                      if (_selectedEvents.contains(event)) {
                        _selectedEvents.remove(event);
                      } else {
                        _selectedEvents.add(event);
                      }
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          VitCtaButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(widget.snapshot.createLabel),
          ),
        ],
      ),
    );
  }
}
