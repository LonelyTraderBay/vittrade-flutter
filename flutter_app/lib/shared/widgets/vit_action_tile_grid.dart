import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_module_components.dart';

/// Builds one tile at [index] inside a [VitActionTileGrid], given the
/// resolved tile [VitServiceTileDensity].
typedef VitActionTileBuilder =
    Widget Function(
      BuildContext context,
      int index,
      VitServiceTileDensity density,
    );

/// Fixed-column, non-scrolling grid of action tiles built via
/// [VitActionTileBuilder], with density- and count-driven sizing.
class VitActionTileGrid extends StatelessWidget {
  const VitActionTileGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.density = VitDensity.standard,
    this.crossAxisCount,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.childAspectRatio,
    this.maxVisibleItems,
    this.shrinkWrap = true,
    this.physics = const NeverScrollableScrollPhysics(),
  });

  final int itemCount;
  final VitActionTileBuilder itemBuilder;
  final VitDensity density;
  final int? crossAxisCount;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;
  final double? childAspectRatio;
  final int? maxVisibleItems;
  final bool shrinkWrap;
  final ScrollPhysics physics;

  VitServiceTileDensity get _tileDensity {
    return density == VitDensity.compact
        ? VitServiceTileDensity.compact
        : VitServiceTileDensity.standard;
  }

  double get _childAspectRatio {
    return childAspectRatio ??
        (density == VitDensity.compact
            ? AppSurfaceSpacing.serviceTileGridAspectCompact
            : AppSurfaceSpacing.serviceTileGridAspectStandard);
  }

  int get _resolvedItemCount {
    final maxItems = maxVisibleItems;
    if (maxItems == null) return itemCount;
    if (maxItems < 0) return 0;
    return itemCount < maxItems ? itemCount : maxItems;
  }

  @override
  Widget build(BuildContext context) {
    final tileDensity = _tileDensity;
    final resolvedItemCount = _resolvedItemCount;
    final resolvedCrossAxisCount =
        crossAxisCount ?? AppSurfaceSpacing.serviceTileCrossAxisCount;
    final resolvedCrossAxisSpacing =
        crossAxisSpacing ?? AppSurfaceSpacing.gridGap;
    final resolvedMainAxisSpacing =
        mainAxisSpacing ?? AppSurfaceSpacing.gridGap;
    return GridView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: resolvedCrossAxisCount,
        crossAxisSpacing: resolvedCrossAxisSpacing,
        mainAxisSpacing: resolvedMainAxisSpacing,
        childAspectRatio: _childAspectRatio,
      ),
      itemCount: resolvedItemCount,
      itemBuilder: (context, index) {
        return itemBuilder(context, index, tileDensity);
      },
    );
  }
}
