import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/home_action_tokens.dart';
import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

/// Tablet sidebar renders «Gần đây» as full-width vertical rows — a
/// horizontal fixed-width strip inside a narrow scrolling sidebar is the
/// phone idiom (nested scroll axes, only ~2 cards visible). Phone keeps its
/// horizontal strip; each surface owns its composition.
class HomeRecentProductsSection extends StatelessWidget {
  const HomeRecentProductsSection({
    super.key,
    required this.recentProducts,
    required this.onNavigate,
    required this.density,
  });

  final List<HomeRecentProduct> recentProducts;
  final ValueChanged<String> onNavigate;
  final VitDensity density;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: HomeTabletKeys.recentProductsSection,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitSectionHeader(
          title: 'Gần đây',
          bottomGap: TabletSpacingTokens.x4,
          density: density,
        ),
        if (recentProducts.isEmpty)
          VitEmptyState(
            title: 'Chưa có hoạt động gần đây',
            message: 'Các sản phẩm bạn vừa dùng sẽ hiện ở đây.',
            icon: Icons.history_rounded,
            actionLabel: 'Khám phá thị trường',
            onAction: () => onNavigate('/markets'),
          )
        else
          VitCard(
            padding: TabletSpacingTokens.zeroInsets,
            key: HomeTabletKeys.recentProducts,
            clip: true,
            child: Column(
              children: [
                for (var i = 0; i < recentProducts.length; i++) ...[
                  _HomeRecentProductRow(
                    product: recentProducts[i],
                    onTap: () => onNavigate(recentProducts[i].routePath),
                  ),
                  if (i < recentProducts.length - 1)
                    const Divider(
                      height: TabletSpacingTokens.dividerHairline,
                      thickness: TabletSpacingTokens.dividerHairline,
                      color: AppColors.divider,
                    ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _HomeRecentProductRow extends StatelessWidget {
  const _HomeRecentProductRow({required this.product, required this.onTap});

  final HomeRecentProduct product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitIconListRow(
      key: HomeTabletKeys.recentProduct(product.id),
      onTap: onTap,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: TabletSpacingTokens.x4,
        vertical: TabletSpacingTokens.x3,
      ),
      leading: VitAccentIconBox(
        icon: HomeActionTokens.icon(product.icon),
        color: HomeActionTokens.accent(product.accentKey),
      ),
      title: Text(
        product.label,
        style: AppTextStyles.body.copyWith(color: AppColors.text1),
      ),
      subtitle: Text(
        product.contextLabel,
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          VitStatusPill(label: product.stateLabel, size: VitStatusPillSize.sm),
          const SizedBox(width: TabletSpacingTokens.x4),
          const Icon(
            Icons.chevron_right_rounded,
            size: SharedSpacingTokens.homeSectionActionChevronSize,
            color: AppColors.text3,
          ),
        ],
      ),
    );
  }
}
