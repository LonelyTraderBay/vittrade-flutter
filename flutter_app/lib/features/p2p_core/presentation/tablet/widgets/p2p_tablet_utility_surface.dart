import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';

/// Tablet-only shell for P2P account, security and dispute utility flows.
class P2PTabletUtilitySurface extends StatelessWidget {
  const P2PTabletUtilitySurface({
    super.key,
    required this.title,
    required this.subtitle,
    required this.semanticLabel,
    required this.semanticIdentifier,
    required this.contentKey,
    required this.children,
    required this.onBack,
  });

  final String title;
  final String subtitle;
  final String semanticLabel;
  final String semanticIdentifier;
  final Key contentKey;
  final List<Widget> children;
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
            // Gutter-flush (S6): shell P2P đã cấp outer margin — header
            // canh 0 thẳng hàng nội dung fullBleed bên dưới.
            horizontalPadding: TabletSpacingTokens.zero,
          ),
          Expanded(
            child: SingleChildScrollView(
              key: contentKey,
              child: VitPageContent(
                rhythm: VitPageRhythm.standard,
                padding: VitContentPadding.compact,
                density: VitDensity.compact,
                fullBleed: true,
                children: children,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
