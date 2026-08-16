import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

part '../../../widgets/transfer/withdraw_limits_page_sections.dart';
part '../../../widgets/transfer/withdraw_limits_page_common.dart';

const _limitsGap = AppSpacing.x3;
const _limitsTinyGap = AppSpacing.x1;
const _limitsInlineGap = AppSpacing.x3;
const _limitsIconBox = AppSpacing.buttonCompact;
const _limitsProgressHeight = AppSpacing.x2 + AppSpacing.dividerHairline;

double _limitsScrollBottomInset(BuildContext context, ShellRenderMode mode) {
  return (mode.usesVisualQaFrame
          ? WalletSpacingTokens.walletVisualChromePad
          : WalletSpacingTokens.walletNativeChromePad) +
      MediaQuery.paddingOf(context).bottom;
}

class WithdrawLimitsPage extends ConsumerWidget {
  const WithdrawLimitsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc153_withdraw_limits_content');
  static const currentTierKey = Key('sc153_withdraw_limits_current_tier');
  static const dailyUsageKey = Key('sc153_withdraw_limits_daily_usage');
  static const monthlyUsageKey = Key('sc153_withdraw_limits_monthly_usage');
  static const upgradeKycKey = Key('sc153_withdraw_limits_upgrade_kyc');
  static Key tierKey(int level) => Key('sc153_withdraw_limits_tier_$level');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(walletWithdrawLimitsProvider);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset = _limitsScrollBottomInset(context, mode);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Hạn mức rút tiền theo cấp KYC',
      semanticIdentifier: 'SC-153',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'H\u1EA1n m\u1EE9c r\u00FAt ti\u1EC1n',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.wallet),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: VitInsetScrollView(
                  key: WithdrawLimitsPage.contentKey,
                  bottomInset: bottomInset,
                  physics: const ClampingScrollPhysics(),
                  child: VitPageContent(
                    rhythm: VitPageRhythm.form,
                    padding: VitContentPadding.compact,
                    density: VitDensity.compact,
                    gap: VitContentGap.tight,
                    children: [
                      ...snapshotAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title:
                                'Kh\u00F4ng t\u1EA3i \u0111\u01B0\u1EE3c h\u1EA1n m\u1EE9c',
                            message:
                                'Vui l\u00F2ng ki\u1EC3m tra k\u1EBFt n\u1ED1i v\u00E0 th\u1EED l\u1EA1i.',
                            actionLabel: 'Th\u1EED l\u1EA1i',
                            onAction: () =>
                                ref.invalidate(walletWithdrawLimitsProvider),
                          ),
                        ],
                        data: (snapshot) => [
                          _CurrentTierCard(snapshot: snapshot),
                          _QuickStats(tier: snapshot.currentTier),
                          const _LimitWarning(),
                          VitPageSection(
                            label:
                                'So s\u00E1nh h\u1EA1n m\u1EE9c theo c\u1EA5p KYC',
                            headerIcon: Icons.verified_user_outlined,
                            headerVariant: VitSectionHeaderVariant.accentBar,
                            headerDensity: VitDensity.compact,
                            innerGap: AppSpacing.pageRhythmFormInnerGap,
                            children: [
                              for (final tier in snapshot.tiers)
                                _KycTierCard(
                                  tier: tier,
                                  currentLevel: snapshot.currentLevel,
                                ),
                            ],
                          ),
                          VitPageSection(
                            label:
                                'C\u00E2u h\u1ECFi th\u01B0\u1EDDng g\u1EB7p',
                            headerIcon: Icons.help_outline_rounded,
                            headerVariant: VitSectionHeaderVariant.plain,
                            innerGap: AppSpacing.pageRhythmFormInnerGap,
                            children: [_FaqCard(faqs: snapshot.faqs)],
                          ),
                        ],
                      ),
                    ],
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
