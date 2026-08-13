// Phone-specific home recent-products section.
import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/home_action_tokens.dart';
import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';
import 'package:vit_trade_flutter/features/home/presentation/pages/phone/home_page.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/home_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

const double _recentProductExtent = SharedSpacingTokens.homeRecentProductHeight;
const double _recentProductWidth = HomeSpacingTokens.homeRecentProductWidth;

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
      key: HomePage.recentProductsSectionKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitSectionHeader(
          title: 'Gần đây',
          bottomGap: AppSpacing.pageRhythmCompactInnerGap,
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
          SizedBox(
            key: HomePage.recentProductsKey,
            height: _recentProductExtent,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemCount: recentProducts.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.x3),
              itemBuilder: (context, index) {
                final product = recentProducts[index];
                return _HomeRecentProductTile(
                  product: product,
                  onTap: () => onNavigate(product.routePath),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _HomeRecentProductTile extends StatelessWidget {
  const _HomeRecentProductTile({required this.product, required this.onTap});

  final HomeRecentProduct product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _recentProductWidth,
      height: _recentProductExtent,
      child: VitCompactProductCard(
        key: HomePage.recentProductKey(product.id),
        icon: HomeActionTokens.icon(product.icon),
        title: product.label,
        subtitle: product.contextLabel,
        accentColor: HomeActionTokens.accent(product.accentKey),
        badgeLabel: product.stateLabel,
        onTap: onTap,
      ),
    );
  }
}
