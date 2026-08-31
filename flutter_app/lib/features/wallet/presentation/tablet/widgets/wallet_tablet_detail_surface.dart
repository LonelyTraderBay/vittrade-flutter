import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';

/// Tablet-only detail frame for Wallet money-movement flows.
///
/// It owns the wide-screen column relationship. The Phone pages do not import
/// this boundary; data, controllers and financial contracts remain shared.
class WalletTabletDetailSurface extends StatelessWidget {
  const WalletTabletDetailSurface({
    super.key,
    required this.semanticLabel,
    required this.semanticIdentifier,
    required this.title,
    required this.subtitle,
    required this.primary,
    required this.secondary,
    required this.onBack,
  });

  final String semanticLabel;
  final String semanticIdentifier;
  final String title;
  final String subtitle;
  final Widget primary;
  final Widget secondary;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: semanticLabel,
      semanticIdentifier: semanticIdentifier,
      child: Column(
        children: [
          VitHeader(
            title: title,
            subtitle: subtitle,
            showBack: true,
            onBack: onBack,
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 900;
                return SingleChildScrollView(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                    AppSpacing.x6,
                    AppSpacing.pageRhythmStandardSectionGap,
                    AppSpacing.x6,
                    AppSpacing.x7,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1180),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.none,
                        fullBleed: true,
                        children: [
                          if (wide)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(flex: 7, child: primary),
                                const SizedBox(width: AppSpacing.x4),
                                Expanded(flex: 5, child: secondary),
                              ],
                            )
                          else ...[
                            primary,
                            const SizedBox(height: AppSpacing.x4),
                            secondary,
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
