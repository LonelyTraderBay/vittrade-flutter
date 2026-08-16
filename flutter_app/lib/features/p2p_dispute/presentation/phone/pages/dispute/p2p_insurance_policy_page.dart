import 'package:flutter/material.dart';
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
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

class P2PInsurancePolicyPage extends ConsumerWidget {
  const P2PInsurancePolicyPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc241_p2p_insurance_policy_hero');
  static const noticeKey = Key('sc241_p2p_insurance_policy_notice');
  static const sectionsKey = Key('sc241_p2p_insurance_policy_sections');
  static const privacyKey = Key('sc241_p2p_insurance_policy_privacy');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pInsurancePolicyProvider);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Điều khoản Bảo hiểm P2P',
      semanticIdentifier: 'SC-241',
      child: Material(
        type: MaterialType.transparency,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2pInsurance),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2pInsurance),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(p2pInsurancePolicyProvider),
            ),
          ),
          data: (snapshot) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Điều khoản Bảo hiểm P2P',
              subtitle: 'Bảo hiểm · P2P',
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
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
                      padding: P2PSpacingTokens.p2pDocumentScrollPadding(
                        bottomInset,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.none,
                        fullBleed: true,
                        gap: VitContentGap.tight,
                        children: [
                          _PolicyHeroCard(snapshot: snapshot),
                          _PolicyNoticeCard(text: snapshot.notice),
                          _PolicySectionList(sections: snapshot.sections),
                          _PrivacyNoticeCard(text: snapshot.privacyNotice),
                          const VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Xem lại điều khoản bảo hiểm',
                            message:
                                'Phiên bản chính sách, thông báo phạm vi, điều khoản từng mục, quyền riêng tư và trạng thái hiện tại được xem lại trước quyết định bảo hiểm.',
                            contractId: 'SC-241',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PolicyHeroCard extends StatelessWidget {
  const _PolicyHeroCard({required this.snapshot});

  final P2PInsurancePolicySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PInsurancePolicyPage.heroKey,
      radius: VitCardRadius.large,
      padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox.square(
                dimension: AppSpacing.x6,
                child: Material(
                  color: AppColors.primary12,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadii.lgRadius,
                    side: BorderSide(color: AppColors.primary20),
                  ),
                  child: Icon(
                    Icons.shield_outlined,
                    color: AppModuleAccents.p2p,
                    size: AppSpacing.iconSm,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      snapshot.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Wrap(
            spacing: AppSpacing.x3,
            runSpacing: AppSpacing.x1,
            children: [
              _PolicyMetaChip(
                icon: Icons.description_outlined,
                label: 'Phiên bản ${snapshot.version}',
                color: AppColors.text3,
              ),
              _PolicyMetaChip(
                icon: Icons.check_circle_outline_rounded,
                label: 'Cập nhật: ${snapshot.lastUpdated}',
                color: AppColors.buy,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PolicyMetaChip extends StatelessWidget {
  const _PolicyMetaChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: P2PSpacingTokens.p2pDocumentTinyIcon),
        const SizedBox(width: AppSpacing.x2),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _PolicyNoticeCard extends StatelessWidget {
  const _PolicyNoticeCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PInsurancePolicyPage.noticeKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      borderColor: AppColors.primary30,
      padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppModuleAccents.p2p,
            size: P2PSpacingTokens.p2pDocumentRowIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: AppModuleAccents.p2p,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PolicySectionList extends StatelessWidget {
  const _PolicySectionList({required this.sections});

  final List<P2PInsurancePolicySectionDraft> sections;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PInsurancePolicyPage.sectionsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < sections.length; i++) ...[
          _PolicySectionCard(section: sections[i]),
          if (i != sections.length - 1)
            const SizedBox(height: AppSpacing.rowGap),
        ],
      ],
    );
  }
}

class _PolicySectionCard extends StatelessWidget {
  const _PolicySectionCard({required this.section});

  final P2PInsurancePolicySectionDraft section;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.title,
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          for (final item in section.content) ...[
            _PolicyBullet(text: item),
            if (item != section.content.last)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
        ],
      ),
    );
  }
}

class _PolicyBullet extends StatelessWidget {
  const _PolicyBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: P2PSpacingTokens.p2pDocumentBulletTopPadding,
          child: SizedBox.square(
            dimension: P2PSpacingTokens.p2pDocumentBullet,
            child: Material(color: AppColors.text3, shape: CircleBorder()),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

class _PrivacyNoticeCard extends StatelessWidget {
  const _PrivacyNoticeCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PInsurancePolicyPage.privacyKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lock_outline_rounded,
            color: AppColors.text3,
            size: P2PSpacingTokens.p2pDocumentSmallIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: P2PSpacingTokens.p2pDocumentPrivacyLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
