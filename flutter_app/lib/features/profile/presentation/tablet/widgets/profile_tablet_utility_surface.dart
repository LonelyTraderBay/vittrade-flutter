import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_pane_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';

/// Tablet scaffold for Profile utility routes that still await a real
/// pane port — rides the shared master-detail [ProfilePaneScaffold] so the
/// placeholder keeps the same gutter-flush rhythm, narrow-only back
/// header, and semantics wrapper as the ported panes.
class ProfileTabletUtilitySurface extends StatelessWidget {
  const ProfileTabletUtilitySurface({
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
      child: ProfilePaneScaffold(
        title: title,
        subtitle: subtitle,
        onBack: onBack,
        scrollKey: contentKey,
        rhythm: VitPageRhythm.form,
        padding: VitContentPadding.compact,
        children: children,
      ),
    );
  }
}
