import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_staking_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class StakingDeveloperConsolePage extends ConsumerStatefulWidget {
  const StakingDeveloperConsolePage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc396_console_hero');
  static const statsKey = Key('sc396_console_stats');
  static const tabsKey = Key('sc396_console_tabs');
  static const keysKey = Key('sc396_console_keys');
  static const logsKey = Key('sc396_console_logs');
  static const docsKey = Key('sc396_console_docs');
  static const createKey = Key('sc396_create_api_key');

  static Key apiKeyCardKey(String id) => Key('sc396_api_key_$id');

  static Key requestKey(int index) => Key('sc396_request_$index');

  static Key docKey(String title) => Key('sc396_doc_$title');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingDeveloperConsolePage> createState() =>
      _StakingDeveloperConsolePageState();
}

class _StakingDeveloperConsolePageState
    extends ConsumerState<StakingDeveloperConsolePage> {
  // Bẫy 14 (GD4 playbook): repo giờ đã async — seed 1 lần trong nhánh
  // data: bên dưới thay vì initState.
  String? _tab;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(stakingDeveloperConsoleSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel:
          'Console API dành cho nhà phát triển — quản lý khóa API, nhật ký yêu cầu và tài liệu tích hợp staking',
      semanticIdentifier: 'SC-396',
      child: Material(
        color: AppColors.bg,
        child: snapshotAsync.when(
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
                  ref.invalidate(stakingDeveloperConsoleSnapshotProvider),
            ),
          ),
          data: (snapshot) {
            _tab ??= snapshot.defaultTab;
            final mode = widget.shellRenderMode ?? defaultShellRenderMode();
            final bottomInset =
                (mode.usesVisualQaFrame
                    ? DeviceMetrics.bottomChrome + AppSpacing.x7
                    : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
                MediaQuery.paddingOf(context).bottom;

            return VitAutoHideHeaderScaffold(
              header: VitTopChrome(
                type: VitTopChromeType.detail,
                title: snapshot.title,
                subtitle: 'Console API staking Earn',
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
                          _ConsoleHero(snapshot: snapshot),
                          _StatsCard(stats: snapshot.stats),
                          ColoredBox(
                            key: StakingDeveloperConsolePage.tabsKey,
                            color: AppColors.surface,
                            child: Padding(
                              padding: EarnSpacingTokens.earnSurfaceTabsPadding,
                              child: VitTabBar(
                                tabs: [
                                  for (final tab in snapshot.tabs)
                                    VitTabItem(key: tab.id, label: tab.label),
                                ],
                                activeKey: _tab!,
                                onChanged: (tab) => setState(() => _tab = tab),
                                variant: VitTabBarVariant.underline,
                              ),
                            ),
                          ),
                          if (_tab == 'keys')
                            _ApiKeysTab(snapshot: snapshot)
                          else if (_tab == 'logs')
                            _LogsTab(snapshot: snapshot)
                          else
                            _DocsTab(snapshot: snapshot),
                          const VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Developer API access review',
                            message:
                                'API keys, production request volume, uptime, docs, audit logs, and create-key confirmation remain reviewed before Earn automation access changes.',
                            contractId: 'SC-396',
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
}

class _ConsoleHero extends StatelessWidget {
  const _ConsoleHero({required this.snapshot});

  final StakingDeveloperConsoleSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingDeveloperConsolePage.heroKey,
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
              height: EarnSpacingTokens.stakingDeveloperConsoleBodyLineHeight,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.stats});

  final List<StakingConsoleStatDraft> stats;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingDeveloperConsolePage.statsKey,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Row(
        children: [
          for (final stat in stats) ...[
            Expanded(child: _StatTile(stat: stat)),
            if (stat != stats.last) const SizedBox(width: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.stat});

  final StakingConsoleStatDraft stat;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(stat.tone);
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3X4,
      borderColor: stat.tone == 'success' ? AppColors.primary20 : null,
      child: Column(
        children: [
          if (stat.id == 'requests')
            const Icon(
              Icons.monitor_heart_outlined,
              color: AppColors.text3,
              size: AppSpacing.iconSm,
            )
          else
            const SizedBox(height: AppSpacing.iconSm),
          if (stat.id == 'requests') const SizedBox(height: AppSpacing.x1),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              stat.value,
              style: AppTextStyles.sectionTitle.copyWith(
                color: color,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            stat.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _ApiKeysTab extends StatelessWidget {
  const _ApiKeysTab({required this.snapshot});

  final StakingDeveloperConsoleSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingDeveloperConsolePage.keysKey,
      label: snapshot.keysTitle,
      children: [
        for (final apiKey in snapshot.apiKeys) _ApiKeyCard(apiKey: apiKey),
        VitCtaButton(
          key: StakingDeveloperConsolePage.createKey,
          onPressed: () =>
              _showComingSoon(context, 'Tạo API Key sẽ sớm ra mắt'),
          child: Text(snapshot.createKeyLabel),
        ),
      ],
    );
  }
}

class _ApiKeyCard extends StatelessWidget {
  const _ApiKeyCard({required this.apiKey});

  final StakingApiKeyDraft apiKey;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingDeveloperConsolePage.apiKeyCardKey(apiKey.id),
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            apiKey.name,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            apiKey.keyPreview,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: _ApiKeyMeta(label: 'Created', value: apiKey.created),
              ),
              Expanded(
                child: _ApiKeyMeta(label: 'Last Used', value: apiKey.lastUsed),
              ),
              Expanded(
                child: _ApiKeyMeta(
                  label: 'Requests',
                  value: VitFormat.count(apiKey.requests),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ApiKeyMeta extends StatelessWidget {
  const _ApiKeyMeta({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
      ],
    );
  }
}

class _LogsTab extends StatelessWidget {
  const _LogsTab({required this.snapshot});

  final StakingDeveloperConsoleSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingDeveloperConsolePage.logsKey,
      label: snapshot.logsTitle,
      children: [
        for (var i = 0; i < snapshot.recentRequests.length; i++)
          _RequestCard(request: snapshot.recentRequests[i], index: i),
      ],
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.request, required this.index});

  final StakingApiRequestDraft request;
  final int index;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingDeveloperConsolePage.requestKey(index),
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.buttonStandard,
            child: Text(
              request.status.toString(),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.buy,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              request.endpoint,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text1),
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            request.time,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            request.timestamp,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _DocsTab extends StatelessWidget {
  const _DocsTab({required this.snapshot});

  final StakingDeveloperConsoleSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingDeveloperConsolePage.docsKey,
      label: snapshot.docsTitle,
      children: [for (final doc in snapshot.docs) _DocCard(doc: doc)],
    );
  }
}

class _DocCard extends StatelessWidget {
  const _DocCard({required this.doc});

  final StakingConsoleDocDraft doc;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingDeveloperConsolePage.docKey(doc.title),
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      onTap: () => _showComingSoon(context, 'Xem tài liệu sẽ sớm ra mắt'),
      child: Row(
        children: [
          const Icon(
            Icons.code_rounded,
            color: AppModuleAccents.earn,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  doc.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _showComingSoon(BuildContext context, String message) {
  unawaited(HapticFeedback.selectionClick());
  unawaited(
    showVitNoticeSheet(
      context: context,
      title: 'Sẽ sớm ra mắt',
      message: message,
    ),
  );
}

Color _toneColor(String tone) {
  return switch (tone) {
    'success' => AppColors.buy,
    _ => AppColors.text1,
  };
}
