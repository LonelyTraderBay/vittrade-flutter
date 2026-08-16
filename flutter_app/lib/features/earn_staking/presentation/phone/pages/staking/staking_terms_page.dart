import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
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

class StakingTermsPage extends ConsumerStatefulWidget {
  const StakingTermsPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc353_terms_hero');
  static const printKey = Key('sc353_terms_print');
  static const downloadKey = Key('sc353_terms_download');
  static const acceptanceKey = Key('sc353_terms_acceptance');
  static const footerKey = Key('sc353_terms_footer');

  static Key sectionKey(String id) => Key('sc353_terms_section_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingTermsPage> createState() => _StakingTermsPageState();
}

class _StakingTermsPageState extends ConsumerState<StakingTermsPage> {
  final Set<String> _expandedSections = {'definitions'};
  bool _accepted = false;
  String? _actionMessage;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(stakingTermsSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Điều khoản dịch vụ staking',
      semanticIdentifier: 'SC-353',
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
              onAction: () => ref.invalidate(stakingTermsSnapshotProvider),
            ),
          ),
          data: (snapshot) {
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
                subtitle: 'Minh bạch điều khoản — không cam kết lợi nhuận',
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
                        padding: VitContentPadding.compact,
                        gap: VitContentGap.defaultGap,
                        children: [
                          _TermsHero(
                            snapshot: snapshot,
                            actionMessage: _actionMessage,
                            onPrint: () => _setAction(
                              'Đang chuẩn bị bản in trang điều khoản.',
                            ),
                            onDownload: () => _setAction(
                              'Tải PDF sẽ sớm ra mắt. Bạn có thể dùng In trang để lưu PDF.',
                            ),
                          ),
                          for (final section in snapshot.sections) ...[
                            _TermsSectionCard(
                              section: section,
                              expanded: _expandedSections.contains(section.id),
                              onTap: () => _toggleSection(section.id),
                            ),
                          ],
                          _AcceptanceCard(
                            accepted: _accepted,
                            snapshot: snapshot,
                            onTap: () {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _accepted = !_accepted);
                            },
                          ),
                          _FooterCard(text: snapshot.footer),
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

  void _toggleSection(String id) {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      if (_expandedSections.contains(id)) {
        _expandedSections.remove(id);
      } else {
        _expandedSections.add(id);
      }
    });
  }

  void _setAction(String message) {
    unawaited(HapticFeedback.mediumImpact());
    setState(() => _actionMessage = message);
  }
}

class _TermsHero extends StatelessWidget {
  const _TermsHero({
    required this.snapshot,
    required this.actionMessage,
    required this.onPrint,
    required this.onDownload,
  });

  final StakingTermsSnapshot snapshot;
  final String? actionMessage;
  final VoidCallback onPrint;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingTermsPage.heroKey,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: EarnSpacingTokens.earnTermsHeroIconBox,
                height: EarnSpacingTokens.earnTermsHeroIconBox,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: AppModuleAccents.earn.withValues(alpha: 0.12),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: AppModuleAccents.earn.withValues(alpha: 0.3),
                        width: EarnSpacingTokens.earnTermsHeroBorderWidth,
                      ),
                      borderRadius: AppRadii.lgRadius,
                    ),
                  ),
                  child: const Icon(
                    Icons.description_outlined,
                    color: AppModuleAccents.earn,
                    size: EarnSpacingTokens.earnTermsHeroIcon,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.documentTitle,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Wrap(
                      spacing: AppSpacing.x3,
                      runSpacing: AppSpacing.x1,
                      children: [
                        _MetaChip(
                          icon: Icons.schedule_outlined,
                          text: 'Cập nhật: ${snapshot.lastUpdated}',
                        ),
                        _MetaChip(text: 'Phiên bản ${snapshot.version}'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _WarningCallout(text: snapshot.warning),
          if (actionMessage != null) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            _ActionStatus(text: actionMessage!),
          ],
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: VitCtaButton(
                  key: StakingTermsPage.printKey,
                  variant: VitCtaButtonVariant.secondary,
                  height: EarnSpacingTokens.earnTermsActionHeight,
                  onPressed: onPrint,
                  leading: const Icon(Icons.print_outlined),
                  child: const Text('In trang'),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: VitCtaButton(
                  key: StakingTermsPage.downloadKey,
                  height: EarnSpacingTokens.earnTermsActionHeight,
                  onPressed: onDownload,
                  leading: const Icon(Icons.download_rounded),
                  child: const Text('Tải PDF'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.text, this.icon});

  final String text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            color: AppColors.text3,
            size: EarnSpacingTokens.earnTermsMetaIcon,
          ),
          const SizedBox(width: AppSpacing.x1),
        ],
        Text(text, style: AppTextStyles.micro.copyWith(color: AppColors.text3)),
      ],
    );
  }
}

class _WarningCallout extends StatelessWidget {
  const _WarningCallout({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      borderColor: AppColors.warn15,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.warn,
            size: EarnSpacingTokens.earnTermsNoticeIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionStatus extends StatelessWidget {
  const _ActionStatus({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.caption.copyWith(color: AppModuleAccents.earn),
    );
  }
}

class _TermsSectionCard extends StatelessWidget {
  const _TermsSectionCard({
    required this.section,
    required this.expanded,
    required this.onTap,
  });

  final StakingTermsSectionDraft section;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingTermsPage.sectionKey(section.id),
      radius: VitCardRadius.large,
      clip: true,
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: EarnSpacingTokens.earnCardPaddingX4,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    section.title,
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: expanded ? .5 : 0,
                  duration: const Duration(milliseconds: 180),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.text3,
                    size: EarnSpacingTokens.earnTermsSectionChevron,
                  ),
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: _SectionContent(section: section),
            crossFadeState: expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 180),
            sizeCurve: Curves.easeOut,
          ),
        ],
      ),
    );
  }
}

class _SectionContent extends StatelessWidget {
  const _SectionContent({required this.section});

  final StakingTermsSectionDraft section;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(
            color: AppColors.divider,
            height: AppSpacing.dividerHairline,
          ),
          Padding(
            padding: EarnSpacingTokens.earnDisclosureDetailsPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final paragraph in section.content) ...[
                  Text(
                    paragraph,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: EarnSpacingTokens.earnTermsParagraphLineHeight,
                    ),
                  ),
                  if (paragraph != section.content.last)
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardInnerGap,
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AcceptanceCard extends StatelessWidget {
  const _AcceptanceCard({
    required this.accepted,
    required this.snapshot,
    required this.onTap,
  });

  final bool accepted;
  final StakingTermsSnapshot snapshot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            key: StakingTermsPage.acceptanceKey,
            width: EarnSpacingTokens.earnTermsAcceptanceBox,
            height: EarnSpacingTokens.earnTermsAcceptanceBox,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: accepted ? AppModuleAccents.earn : AppColors.transparent,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: accepted
                        ? AppModuleAccents.earn
                        : AppColors.borderSolid,
                  ),
                  borderRadius: AppRadii.smRadius,
                ),
              ),
              child: accepted
                  ? const Icon(
                      Icons.check_rounded,
                      color: AppColors.onAccent,
                      size: EarnSpacingTokens.earnTermsAcceptanceIcon,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.acceptanceText,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  snapshot.acceptanceFootnote,
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

class _FooterCard extends StatelessWidget {
  const _FooterCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingTermsPage.footerKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      ),
    );
  }
}
