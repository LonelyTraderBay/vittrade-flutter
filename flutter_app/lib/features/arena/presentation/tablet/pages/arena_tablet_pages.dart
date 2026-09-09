import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/arena_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_motion.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_section_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_two_column_tablet_dashboard.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part 'arena_tablet_pages_studio.dart';
part 'arena_tablet_pages_play.dart';
part 'arena_tablet_pages_points.dart';
part 'arena_tablet_pages_home.dart';
part 'arena_tablet_pages_hubs.dart';
part 'arena_tablet_pages_hubs_extra.dart';

Widget _ardError(String title, VoidCallback onRetry) {
  return VitErrorState(
    title: title,
    message: 'Vui lòng kiểm tra kết nối và thử lại.',
    actionLabel: 'Thử lại',
    onAction: onRetry,
  );
}

Widget _ardSection({required String title, required List<Widget> rows}) {
  return VitCard(
    radius: VitCardRadius.tight,
    padding: TabletSpacingTokens.cardPaddingCompact,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.control.copyWith(
            fontWeight: AppTextStyles.bold,
            color: AppColors.text1,
          ),
        ),
        const SizedBox(height: TabletSpacingTokens.x2),
        ...rows,
      ],
    ),
  );
}

List<Widget> _ardBullets(List<String> notes) {
  return [
    for (final note in notes)
      Padding(
        padding: TabletSpacingTokens.tableCellPaddingV,
        child: VitBulletRow(text: note),
      ),
  ];
}

Widget _ardBody(String text) {
  return Text(
    text,
    style: AppTextStyles.caption.copyWith(color: AppColors.text2, height: 1.3),
  );
}

Widget _ardQuickLinks(BuildContext context, List<(String, String)> links) {
  return Wrap(
    spacing: TabletSpacingTokens.x2,
    runSpacing: TabletSpacingTokens.x2,
    children: [
      for (final (label, path) in links)
        VitFilterChip(
          label: label,
          active: false,
          color: AppColors.primary,
          onTap: () => context.push(path),
        ),
    ],
  );
}
