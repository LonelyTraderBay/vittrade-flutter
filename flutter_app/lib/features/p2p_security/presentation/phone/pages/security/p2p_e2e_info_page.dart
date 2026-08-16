import 'package:flutter/material.dart';
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
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

const double _p2pE2EHeroIconExtent = AppSpacing.inputHeight + AppSpacing.x2;
const double _p2pE2EEndpointAvatarExtent =
    AppSpacing.inputHeight - AppSpacing.pageRhythmStandardInnerGap;
const double _p2pE2EConnectorExtent = AppSpacing.x3;
const double _p2pE2EConnectorThickness = AppSpacing.hairlineStroke;
const double _p2pE2ELockExtent = AppSpacing.x7;
const double _p2pE2ELockIconExtent = P2PSpacingTokens.p2pHomeInlineIcon;
const double _p2pE2EBodyLineHeight = 1.45;
const double _p2pE2EFingerprintLineHeight = 1.55;
const double _p2pE2EFingerprintLetterSpacing = AppSpacing.hairlineStroke;
const EdgeInsets _p2pE2ECardPadding =
    P2PSpacingTokens.p2pWalletCompactCardPadding;
const EdgeInsets _p2pE2EServerPadding = P2PSpacingTokens.p2pWalletNoticePadding;

class P2PE2EInfoPage extends ConsumerWidget {
  const P2PE2EInfoPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc259_p2p_e2e_hero');
  static const diagramKey = Key('sc259_p2p_e2e_diagram');
  static const infoItemsKey = Key('sc259_p2p_e2e_info_items');
  static const fingerprintKey = Key('sc259_p2p_e2e_fingerprint');
  static const stepsKey = Key('sc259_p2p_e2e_steps');
  static const serverKey = Key('sc259_p2p_e2e_server');

  static Key infoItemKey(String id) => Key('sc259_p2p_e2e_info_$id');

  static Key stepKey(String id) => Key('sc259_p2p_e2e_step_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pE2EInfoProvider);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? SharedSpacingTokens.bottomNavVisualClearance
        : SharedSpacingTokens.bottomNavNativeClearance;
    final scrollEndPadding =
        navClearance + MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Mã hóa đầu cuối P2P',
      semanticIdentifier: 'SC-259',
      child: Material(
        type: MaterialType.transparency,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2pSecurityCenter),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2pSecurityCenter),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(p2pE2EInfoProvider),
            ),
          ),
          data: (snapshot) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Mã hóa đầu cuối',
              subtitle: 'Bảo mật · P2P',
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
                      padding: EdgeInsetsDirectional.only(
                        bottom: scrollEndPadding,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.compact,
                        density: VitDensity.compact,
                        children: [
                          _Hero(snapshot: snapshot),
                          _EncryptionDiagram(snapshot: snapshot),
                          _InfoItems(items: snapshot.infoItems),
                          _FingerprintCard(snapshot: snapshot),
                          _HowItWorks(steps: snapshot.steps),
                          _ServerInfo(snapshot: snapshot),
                          const VitCard(
                            variant: VitCardVariant.inner,
                            padding: P2PSpacingTokens.p2pWalletNoticePadding,
                            child: VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'Rà soát mã hóa đầu cuối',
                              message:
                                  'Sơ đồ mã hóa, mã xác minh bảo mật, các bước hoạt động và lưu ý máy chủ vẫn hiển thị trước khi tin tưởng phiên chat P2P.',
                              contractId: 'SC-259',
                            ),
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

class _Hero extends StatelessWidget {
  const _Hero({required this.snapshot});

  final P2PE2EInfoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PE2EInfoPage.heroKey,
      children: [
        SizedBox(
          width: _p2pE2EHeroIconExtent,
          height: _p2pE2EHeroIconExtent,
          child: Material(
            color: AppColors.buy.withValues(alpha: .12),
            borderRadius: AppRadii.cardLargeRadius,
            child: const Icon(
              Icons.verified_user_outlined,
              color: AppColors.buy,
              size: AppSpacing.iconLg,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        Text(
          snapshot.heroTitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitleSm,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        Text(
          snapshot.heroSubtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.buy,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _EncryptionDiagram extends StatelessWidget {
  const _EncryptionDiagram({required this.snapshot});

  final P2PE2EInfoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PE2EInfoPage.diagramKey,
      radius: VitCardRadius.large,
      borderColor: AppColors.buy20,
      padding: _p2pE2ECardPadding,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _EndpointAvatar(
                label: snapshot.localLabel,
                color: AppColors.accent,
              ),
              const SizedBox(width: AppSpacing.x3),
              const _SecureConnector(),
              const SizedBox(width: AppSpacing.x3),
              _EndpointAvatar(
                label: snapshot.partnerLabel,
                color: AppModuleAccents.p2p,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            snapshot.diagramCaption,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.buy,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _EndpointAvatar extends StatelessWidget {
  const _EndpointAvatar({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _p2pE2EEndpointAvatarExtent,
      height: _p2pE2EEndpointAvatarExtent,
      child: Material(
        color: color,
        shape: const CircleBorder(),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.onAccent,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _SecureConnector extends StatelessWidget {
  const _SecureConnector();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: _p2pE2EConnectorExtent,
          height: _p2pE2EConnectorThickness,
          child: ColoredBox(color: AppColors.buy),
        ),
        SizedBox(
          width: _p2pE2ELockExtent,
          height: _p2pE2ELockExtent,
          child: Material(
            color: AppColors.buy.withValues(alpha: .12),
            shape: const CircleBorder(),
            child: const Icon(
              Icons.lock_outline_rounded,
              color: AppColors.buy,
              size: _p2pE2ELockIconExtent,
            ),
          ),
        ),
        const SizedBox(
          width: _p2pE2EConnectorExtent,
          height: _p2pE2EConnectorThickness,
          child: ColoredBox(color: AppColors.buy),
        ),
      ],
    );
  }
}

class _InfoItems extends StatelessWidget {
  const _InfoItems({required this.items});

  final List<P2PE2EInfoItemDraft> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PE2EInfoPage.infoItemsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < items.length; index++) ...[
          _InfoItemCard(item: items[index]),
          if (index != items.length - 1)
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        ],
      ],
    );
  }
}

class _InfoItemCard extends StatelessWidget {
  const _InfoItemCard({required this.item});

  final P2PE2EInfoItemDraft item;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(item.toneKey);

    return VitCard(
      key: P2PE2EInfoPage.infoItemKey(item.id),
      radius: VitCardRadius.large,
      padding: _p2pE2ECardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: _p2pE2EEndpointAvatarExtent,
            height: _p2pE2EEndpointAvatarExtent,
            child: Material(
              color: color.withValues(alpha: .12),
              borderRadius: AppRadii.lgRadius,
              child: Icon(_infoIcon(item.iconKey), color: color),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                Text(
                  item.description,
                  style: AppTextStyles.navLabel.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.normal,
                    height: _p2pE2EBodyLineHeight,
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

class _FingerprintCard extends StatelessWidget {
  const _FingerprintCard({required this.snapshot});

  final P2PE2EInfoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PE2EInfoPage.fingerprintKey,
      radius: VitCardRadius.large,
      padding: _p2pE2ECardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.fingerprint_rounded,
                color: AppColors.text2,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'MÃ XÁC MINH BẢO MẬT',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            snapshot.fingerprint,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              letterSpacing: _p2pE2EFingerprintLetterSpacing,
              height: _p2pE2EFingerprintLineHeight,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            snapshot.fingerprintHint,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _HowItWorks extends StatelessWidget {
  const _HowItWorks({required this.steps});

  final List<P2PE2EStepDraft> steps;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PE2EInfoPage.stepsKey,
      radius: VitCardRadius.large,
      padding: _p2pE2ECardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Cách hoạt động',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitStepList(
            accentColor: AppColors.buy,
            steps: [
              for (final step in steps)
                VitStepItem(title: step.title, description: step.description),
            ],
          ),
        ],
      ),
    );
  }
}

class _ServerInfo extends StatelessWidget {
  const _ServerInfo({required this.snapshot});

  final P2PE2EInfoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: P2PE2EInfoPage.serverKey,
      color: AppModuleAccents.p2p.withValues(alpha: .08),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.lgRadius,
        side: BorderSide(color: AppModuleAccents.p2p.withValues(alpha: .18)),
      ),
      child: Padding(
        padding: _p2pE2EServerPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.dns_outlined,
              color: AppModuleAccents.p2p,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                snapshot.serverNote,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  height: _p2pE2EBodyLineHeight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _toneColor(String key) {
  return switch (key) {
    'accent' => AppColors.accent,
    'success' => AppColors.buy,
    'warning' => AppColors.warn,
    _ => AppModuleAccents.p2p,
  };
}

IconData _infoIcon(String key) {
  return switch (key) {
    'key' => Icons.vpn_key_outlined,
    'verified' => Icons.verified_user_outlined,
    'warning' => Icons.warning_amber_rounded,
    _ => Icons.lock_outline_rounded,
  };
}
