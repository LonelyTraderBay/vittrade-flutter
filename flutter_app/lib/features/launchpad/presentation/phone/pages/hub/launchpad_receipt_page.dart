import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

part '../../../widgets/phone/launchpad_receipt_states_success.dart';
part '../../../widgets/phone/launchpad_receipt_details_next_steps.dart';

class LaunchpadReceiptPage extends ConsumerWidget {
  const LaunchpadReceiptPage({
    super.key,
    this.subscriptionId = 'sub001',
    this.shellRenderMode,
  });

  static const contentKey = Key('sc301_launchpad_receipt_content');
  static const errorKey = Key('sc301_launchpad_receipt_error');
  static const portfolioButtonKey = Key('sc301_launchpad_receipt_portfolio');
  static const launchpadButtonKey = Key('sc301_launchpad_receipt_launchpad');

  final String subscriptionId;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiptAsync = ref.watch(
      launchpadReceiptSnapshotProvider(subscriptionId),
    );
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? SharedSpacingTokens.bottomNavVisualClearance
        : SharedSpacingTokens.bottomNavNativeClearance;
    final scrollEndPadding =
        navClearance + MediaQuery.paddingOf(context).bottom;

    // GD4-F4: title/nội dung phụ thuộc snapshot.subscription (nullable) nên
    // bọc CẢ scaffold.
    return receiptAsync.when(
      loading: () => VitPageLayout(
        variant: VitPageVariant.flush,
        semanticLabel: 'Biên lai đăng ký tham gia IDO',
        semanticIdentifier: 'SC-301',
        child: Material(
          type: MaterialType.transparency,
          child: VitAutoHideHeaderScaffold(
            semanticLabel: 'Biên lai đăng ký – vùng cuộn nội dung',
            semanticIdentifier: 'SC-301',
            header: VitHeader(
              title: 'Biên lai',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.launchpadPortfolio),
            ),
            child: const VitSkeletonList(),
          ),
        ),
      ),
      error: (error, stackTrace) => VitPageLayout(
        variant: VitPageVariant.flush,
        semanticLabel: 'Biên lai đăng ký tham gia IDO',
        semanticIdentifier: 'SC-301',
        child: Material(
          type: MaterialType.transparency,
          child: VitAutoHideHeaderScaffold(
            semanticLabel: 'Biên lai đăng ký – vùng cuộn nội dung',
            semanticIdentifier: 'SC-301',
            header: VitHeader(
              title: 'Biên lai',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.launchpadPortfolio),
            ),
            child: VitErrorState(
              title: 'Không tải được dữ liệu',
              message: 'Vui lòng kiểm tra kết nối và thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(
                launchpadReceiptSnapshotProvider(subscriptionId),
              ),
            ),
          ),
        ),
      ),
      data: (snapshot) {
        final hasSubscription = snapshot.subscription != null;
        return VitPageLayout(
          variant: VitPageVariant.flush,
          semanticLabel: 'Biên lai đăng ký tham gia IDO',
          semanticIdentifier: 'SC-301',
          child: Material(
            type: MaterialType.transparency,
            child: VitAutoHideHeaderScaffold(
              semanticLabel: 'Biên lai đăng ký – vùng cuộn nội dung',
              semanticIdentifier: 'SC-301',
              header: VitHeader(
                title: hasSubscription ? 'Biên lai đăng ký' : snapshot.title,
                subtitle: hasSubscription ? 'Xác nhận tham gia IDO' : null,
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
              ),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: contentKey,
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsetsDirectional.only(bottom: scrollEndPadding),
                  child: VitPageContent(
                    rhythm: VitPageRhythm.standard,
                    padding: VitContentPadding.compact,
                    density: VitDensity.compact,
                    children: [
                      if (!hasSubscription)
                        const _ReceiptErrorState()
                      else
                        ..._receiptSuccessChildren(context, snapshot),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
