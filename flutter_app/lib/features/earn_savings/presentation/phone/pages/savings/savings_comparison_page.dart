import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_savings_controller_providers.dart';
import 'package:vit_trade_flutter/features/earn_core/presentation/widgets/earn_custody_risk_banner.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

part '../../../widgets/phone/earn_comparison_summary.dart';
part '../../../widgets/phone/earn_comparison_table.dart';
part '../../../widgets/phone/earn_comparison_chart.dart';

class SavingsComparisonPage extends ConsumerStatefulWidget {
  const SavingsComparisonPage({super.key, this.shellRenderMode});

  static const selectedProductsKey = Key('sc340_selected_products');
  static const comparisonTableKey = Key('sc340_comparison_table');
  static const addProductButtonKey = Key('sc340_add_product_button');
  static const emptyStateKey = Key('sc340_empty_state');
  static const disclaimerKey = Key('sc340_disclaimer');

  static Key productChipKey(String productId) => Key('sc340_chip_$productId');
  static Key removeProductKey(String productId) =>
      Key('sc340_remove_$productId');
  static Key pickerOptionKey(String productId) =>
      Key('sc340_picker_$productId');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsComparisonPage> createState() =>
      _SavingsComparisonPageState();
}

class _SavingsComparisonPageState extends ConsumerState<SavingsComparisonPage> {
  List<String>? _selectedIds;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(savingsComparisonSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'So sánh sản phẩm',
      semanticIdentifier: 'SC-340',
      child: Material(
        color: AppColors.bg,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnSavings),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnSavings),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(savingsComparisonSnapshotProvider),
            ),
          ),
          data: (snapshot) {
            final selectedIds = _selectedIds ?? snapshot.defaultProductIds;
            final selectedProducts = _selectedProducts(snapshot, selectedIds);
            final availableProducts = snapshot.products
                .where((product) => !selectedIds.contains(product.id))
                .toList();
            final mode = widget.shellRenderMode ?? defaultShellRenderMode();
            final bottomInset =
                (mode.usesVisualQaFrame
                    ? DeviceMetrics.bottomChrome + AppSpacing.x7
                    : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
                MediaQuery.paddingOf(context).bottom;

            return VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: snapshot.title,
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: EarnSpacingTokens.earnBottomInsetPadding(
                        bottomInset,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.compact,
                        gap: VitContentGap.defaultGap,
                        children: [
                          VitPageSection(
                            label: 'Sản phẩm đã chọn',
                            accentColor: AppColors.primary,
                            children: [
                              _SelectedProducts(
                                selectedProducts: selectedProducts,
                                selectedCount: selectedIds.length,
                                maxCompare: snapshot.maxCompare,
                                canAdd:
                                    selectedIds.length < snapshot.maxCompare,
                                onRemove: _removeProduct,
                                onAdd: () => _openPicker(
                                  snapshot,
                                  availableProducts,
                                  selectedIds.length,
                                ),
                              ),
                            ],
                          ),
                          if (selectedProducts.length >= 2) ...[
                            VitPageSection(
                              label: 'So sánh chi tiết',
                              accentColor: AppColors.buy,
                              children: [
                                _ComparisonTable(
                                  products: selectedProducts,
                                  details: snapshot.details,
                                ),
                              ],
                            ),
                            VitPageSection(
                              label: 'Tính năng nổi bật',
                              accentColor: AppColors.accent,
                              children: [
                                for (final product in selectedProducts)
                                  _FeatureCard(
                                    product: product,
                                    detail: snapshot.details[product.id],
                                  ),
                              ],
                            ),
                          ] else
                            _EmptyComparisonState(
                              onAdd: () => _openPicker(
                                snapshot,
                                availableProducts,
                                selectedIds.length,
                              ),
                            ),
                          _ComparisonDisclaimer(text: snapshot.disclaimer),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<SavingsProductDraft> _selectedProducts(
    SavingsComparisonSnapshot snapshot,
    List<String> selectedIds,
  ) {
    return [
      for (final id in selectedIds)
        for (final product in snapshot.products)
          if (product.id == id) product,
    ];
  }

  void _removeProduct(String productId) {
    unawaited(HapticFeedback.selectionClick());
    // Bẫy 15 (GD4 playbook): repo trong event handler — đọc lười qua
    // `.value` (đã có sẵn vì nút này chỉ render trong nhánh data:).
    final snapshot = ref.read(savingsComparisonSnapshotProvider).value;
    if (snapshot == null) return;
    setState(() {
      final selectedIds = List<String>.of(_selectedIds ?? const []);
      final baseline = selectedIds.isEmpty
          ? snapshot.defaultProductIds
          : selectedIds;
      _selectedIds = baseline.where((id) => id != productId).toList();
    });
  }

  Future<void> _openPicker(
    SavingsComparisonSnapshot snapshot,
    List<SavingsProductDraft> availableProducts,
    int selectedCount,
  ) async {
    unawaited(HapticFeedback.selectionClick());
    await showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (sheetContext) {
        return FractionallySizedBox(
          heightFactor: 0.72,
          child: VitSheetSurface(
            color: AppColors.surface,
            borderRadius: AppRadii.sheetTopLargeRadius,
            padding: AppSpacing.zeroInsets,
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: EarnSpacingTokens.earnSheetContentPadding,
                child: _ProductPickerSheet(
                  availableProducts: availableProducts,
                  selectedCount: selectedCount,
                  maxCompare: snapshot.maxCompare,
                  onAdd: (productId) => _addProduct(sheetContext, productId),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _addProduct(BuildContext sheetContext, String productId) {
    unawaited(HapticFeedback.selectionClick());
    // Bẫy 15: xem _removeProduct ở trên.
    final snapshot = ref.read(savingsComparisonSnapshotProvider).value;
    if (snapshot == null) return;
    setState(() {
      final baseline = _selectedIds ?? snapshot.defaultProductIds;
      if (baseline.contains(productId)) return;
      _selectedIds = [...baseline, productId];
    });
    Navigator.of(sheetContext).pop();
  }
}
