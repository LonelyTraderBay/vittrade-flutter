import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/home_action_tokens.dart';
import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class HomeNextActionSection extends StatelessWidget {
  const HomeNextActionSection({
    super.key,
    required this.nextAction,
    required this.onNavigate,
    required this.onDismiss,
  });

  final HomeNextAction nextAction;
  final ValueChanged<String> onNavigate;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitSectionHeader(title: 'Tiếp theo', bottomGap: AppSpacing.x4),
        VitNextActionCard(
          key: HomeTabletKeys.nextAction,
          icon: HomeActionTokens.icon(nextAction.icon),
          title: nextAction.title,
          subtitle: nextAction.subtitle,
          statusLabel: nextAction.stateLabel,
          ctaLabel: nextAction.ctaLabel,
          accentColor: HomeActionTokens.accent(nextAction.accentKey),
          onTap: () => onNavigate(nextAction.routePath),
          onDismiss: onDismiss,
        ),
      ],
    );
  }
}
