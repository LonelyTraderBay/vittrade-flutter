import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/predictions_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/predictions/domain/entities/predictions_entities.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_pane_workspace.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part 'prediction_market_maker_tablet_tabs.dart';

/// SC-217: Tạo lập thị trường dự đoán trên tablet — công cụ sống như phone
/// SC-037: 3 tab Cung cấp / Vị thế / Thu nhập, form thêm thanh khoản với
/// chọn spread (bps) và ước tính lợi nhuận realtime.
class PredictionMarketMakerTabletPage extends ConsumerStatefulWidget {
  const PredictionMarketMakerTabletPage({super.key});

  static const contentKey = Key('sc217_tablet_content');
  static const controlPaneKey = Key('sc217_tablet_control_pane');
  static const provideTabKey = Key('sc217_tab_provide');
  static const positionsTabKey = Key('sc217_tab_positions');
  static const earningsTabKey = Key('sc217_tab_earnings');
  static const amountFieldKey = Key('sc217_field_amount');
  static const addLiquidityKey = Key('sc217_add_liquidity');

  @override
  ConsumerState<PredictionMarketMakerTabletPage> createState() =>
      _PredictionMarketMakerTabletPageState();
}

enum _Sc217Tab { provide, positions, earnings }

class _PredictionMarketMakerTabletPageState
    extends ConsumerState<PredictionMarketMakerTabletPage> {
  _Sc217Tab _activeTab = _Sc217Tab.provide;
  // Controller dựng lười trong nhánh `data:` (GD4-F5 bẫy 14).
  TextEditingController? _eventController;
  TextEditingController? _amountController;
  TextEditingController? _minDepthController;
  int _spreadBps = 50;

  void _ensureControllers(PredictionMarketMakerSnapshot snapshot) {
    if (_eventController != null) return;
    _spreadBps = snapshot.defaultSpreadBps;
    _eventController = TextEditingController(text: snapshot.defaultEventName);
    _amountController = TextEditingController();
    _minDepthController = TextEditingController(
      text: _sc217FormatInput(snapshot.defaultMinDepth),
    );
    _amountController!.addListener(_refresh);
  }

  @override
  void dispose() {
    _amountController?.removeListener(_refresh);
    _amountController?.dispose();
    _eventController?.dispose();
    _minDepthController?.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final marketMakerAsync = ref.watch(predictionsMarketMakerSnapshotProvider);

    return marketMakerAsync.when(
      loading: () =>
          _frame(context, body: _statusBody(const [VitSkeletonList(rows: 6)])),
      error: (error, stackTrace) => _frame(
        context,
        body: _statusBody([
          VitErrorState(
            title: 'Không tải được market maker',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () =>
                ref.invalidate(predictionsMarketMakerSnapshotProvider),
          ),
        ]),
      ),
      data: (snapshot) {
        _ensureControllers(snapshot);
        final amount = double.tryParse(_amountController!.text) ?? 0;
        final tabBar = VitTabBar(
          variant: VitTabBarVariant.segment,
          activeKey: switch (_activeTab) {
            _Sc217Tab.provide => 'provide',
            _Sc217Tab.positions => 'positions',
            _Sc217Tab.earnings => 'earnings',
          },
          onChanged: (key) => setState(() {
            _activeTab = _Sc217Tab.values.byName(key);
          }),
          tabs: const [
            VitTabItem(
              key: 'provide',
              label: 'Cung cấp',
              widgetKey: PredictionMarketMakerTabletPage.provideTabKey,
            ),
            VitTabItem(
              key: 'positions',
              label: 'Vị thế',
              widgetKey: PredictionMarketMakerTabletPage.positionsTabKey,
            ),
            VitTabItem(
              key: 'earnings',
              label: 'Thu nhập',
              widgetKey: PredictionMarketMakerTabletPage.earningsTabKey,
            ),
          ],
        );
        final provideForm = _Sc217AddLiquidityForm(
          eventController: _eventController!,
          amountController: _amountController!,
          minDepthController: _minDepthController!,
          spreadBps: _spreadBps,
          onSpreadChanged: (value) => setState(() => _spreadBps = value),
          // Tầng workspace: ước tính tách lên panel phải.
          showEstimate: false,
        );
        final overview = _Sc217LiquidityOverview(snapshot: snapshot);
        final warning = const _Sc217LiquidityWarning();
        return _frame(
          context,
          body: VitTabletPaneWorkspace(
            contentKey: PredictionMarketMakerTabletPage.contentKey,
            secondaryContentKey: PredictionMarketMakerTabletPage.controlPaneKey,
            // Khuôn Cụm D "form trái — kết quả phải": form + cảnh báo cột
            // chính, ước tính realtime + tổng quan thanh khoản ghim panel.
            primaryChildren: [
              tabBar,
              if (_activeTab == _Sc217Tab.provide)
                provideForm
              else if (_activeTab == _Sc217Tab.positions)
                _Sc217PositionsTab(snapshot: snapshot)
              else
                _Sc217EarningsTab(snapshot: snapshot),
            ],
            secondaryChildren: [
              if (_activeTab == _Sc217Tab.provide && amount > 0)
                _Sc217EstimatedReturns(amount: amount),
              overview,
              if (_activeTab == _Sc217Tab.provide) warning,
            ],
            narrowChildren: [
              tabBar,
              if (_activeTab == _Sc217Tab.provide) ...[
                _Sc217AddLiquidityForm(
                  eventController: _eventController!,
                  amountController: _amountController!,
                  minDepthController: _minDepthController!,
                  spreadBps: _spreadBps,
                  onSpreadChanged: (value) =>
                      setState(() => _spreadBps = value),
                ),
                overview,
                warning,
              ] else if (_activeTab == _Sc217Tab.positions)
                _Sc217PositionsTab(snapshot: snapshot)
              else
                _Sc217EarningsTab(snapshot: snapshot),
            ],
          ),
        );
      },
    );
  }

  /// Thân một cột cho trạng thái loading/error — recipe cột hẹp workspace.
  Widget _statusBody(List<Widget> children) {
    return SingleChildScrollView(
      key: PredictionMarketMakerTabletPage.contentKey,
      padding: const EdgeInsetsDirectional.only(
        bottom: TabletSpacingTokens.pageEndBreathing,
      ),
      child: VitPageContent(
        padding: VitContentPadding.compact,
        fullBleed: true,
        rhythm: VitPageRhythm.standard,
        children: children,
      ),
    );
  }

  Widget _frame(BuildContext context, {required Widget body}) {
    final showBack = context.canPop();
    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Tạo lập thị trường dự đoán',
      semanticIdentifier: 'SC-217',
      child: Column(
        children: [
          VitHeader(
            title: 'Market Maker',
            subtitle: 'Thanh khoản · Prediction',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.marketsPredictions,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}

class _Sc217AddLiquidityForm extends StatelessWidget {
  const _Sc217AddLiquidityForm({
    required this.eventController,
    required this.amountController,
    required this.minDepthController,
    required this.spreadBps,
    required this.onSpreadChanged,
    this.showEstimate = true,
  });

  final TextEditingController eventController;
  final TextEditingController amountController;
  final TextEditingController minDepthController;
  final int spreadBps;
  final ValueChanged<int> onSpreadChanged;

  /// Tầng hẹp nhúng ước tính trong form (phone-parity); tầng workspace tách
  /// ước tính lên panel phải — truyền `false`.
  final bool showEstimate;

  @override
  Widget build(BuildContext context) {
    final hasAmount = amountController.text.trim().isNotEmpty;
    final amount = double.tryParse(amountController.text) ?? 0;

    return VitPageSection(
      label: 'Thêm thanh khoản',
      accentColor: AppColors.primary,
      innerGap: TabletSpacingTokens.x4,
      children: [
        VitCard(
          density: VitDensity.compact,
          child: Column(
            children: [
              _Sc217MarketInput(
                label: 'Số tiền thanh khoản (USD)',
                controller: amountController,
                fieldKey: PredictionMarketMakerTabletPage.amountFieldKey,
                hintText: '0.00',
                numeric: true,
              ),
              const SizedBox(height: TabletSpacingTokens.x4),
              _Sc217MarketInput(
                label: 'Chọn sự kiện',
                controller: eventController,
              ),
              const SizedBox(height: TabletSpacingTokens.x4),
              _Sc217SpreadSelector(
                value: spreadBps,
                onChanged: onSpreadChanged,
              ),
              const SizedBox(height: TabletSpacingTokens.x4),
              _Sc217MarketInput(
                label: 'Độ sâu tối thiểu (USD)',
                controller: minDepthController,
                numeric: true,
              ),
              const SizedBox(height: TabletSpacingTokens.x1),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'Thanh khoản tối thiểu mỗi bên',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              if (showEstimate && hasAmount) ...[
                const SizedBox(height: TabletSpacingTokens.x3),
                _Sc217EstimatedReturns(amount: amount),
              ],
              const SizedBox(height: TabletSpacingTokens.x4),
              VitCtaButton(
                key: PredictionMarketMakerTabletPage.addLiquidityKey,
                // Flow thanh khoản đầy đủ chưa mở — thông báo minh bạch
                // theo pattern coming-soon sẵn có của feature.
                onPressed: hasAmount
                    ? () {
                        unawaited(
                          showVitNoticeSheet(
                            context: context,
                            title: 'Sắp ra mắt',
                            message: 'Thêm thanh khoản sẽ sớm ra mắt.',
                          ),
                        );
                      }
                    : null,
                density: VitDensity.compact,
                leading: const Icon(Icons.add_rounded),
                child: const Text('Thêm thanh khoản'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Sc217MarketInput extends StatelessWidget {
  const _Sc217MarketInput({
    required this.label,
    required this.controller,
    this.fieldKey,
    this.hintText = '',
    this.numeric = false,
  });

  final String label;
  final TextEditingController controller;
  final Key? fieldKey;
  final String hintText;
  final bool numeric;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AppTextStyles.badge.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: TabletSpacingTokens.x3),
        VitInput(
          fieldKey: fieldKey,
          controller: controller,
          keyboardType: numeric
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          inputFormatters: numeric
              ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
              : null,
          semanticLabel: label,
          hintText: hintText,
          textStyle: AppTextStyles.body.copyWith(
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _Sc217SpreadSelector extends StatelessWidget {
  const _Sc217SpreadSelector({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Spread (basis points)',
          style: AppTextStyles.badge.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: TabletSpacingTokens.x1),
        Row(
          children: [
            for (final bps in [25, 50, 100, 200]) ...[
              Expanded(
                child: VitChoicePill(
                  key: Key('sc217_spread_$bps'),
                  label: '$bps',
                  selected: value == bps,
                  onTap: () => onChanged(bps),
                  accentColor: AppColors.primary,
                  fullWidth: true,
                ),
              ),
              if (bps != 200) const SizedBox(width: TabletSpacingTokens.x2),
            ],
          ],
        ),
        const SizedBox(height: TabletSpacingTokens.x1),
        Text(
          'Hiệu giá bid/ask: ${(value / 100).toStringAsFixed(2)}%',
          style: AppTextStyles.numericMicro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _Sc217EstimatedReturns extends StatelessWidget {
  const _Sc217EstimatedReturns({required this.amount});

  final double amount;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.buy20,
      density: VitDensity.compact,
      child: Row(
        children: [
          Expanded(
            child: _Sc217OverviewMetric(
              label: 'Phí hàng ngày',
              value: VitFormat.usd(amount * .0012),
              valueColor: AppColors.buy,
              small: true,
            ),
          ),
          const SizedBox(width: TabletSpacingTokens.x3),
          const Expanded(
            child: _Sc217OverviewMetric(
              label: 'APR ước tính',
              value: '~22.5%',
              valueColor: AppColors.buy,
              small: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _Sc217LiquidityOverview extends StatelessWidget {
  const _Sc217LiquidityOverview({required this.snapshot});

  final PredictionMarketMakerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox.square(
                dimension: TabletSpacingTokens.accentIconBoxSize,
                child: Material(
                  color: AppColors.primary08,
                  borderRadius: AppRadii.inputRadius,
                  child: Icon(
                    Icons.water_drop_outlined,
                    color: AppColors.primary,
                    size: TabletSpacingTokens.iconMd,
                  ),
                ),
              ),
              const SizedBox(width: TabletSpacingTokens.x2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Người cung cấp thanh khoản',
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: TabletSpacingTokens.x1),
                    Text(
                      'Thu nhập từ phí giao dịch',
                      style: AppTextStyles.badge.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
          Row(
            children: [
              Expanded(
                child: _Sc217OverviewMetric(
                  label: 'Tổng đã cung cấp',
                  value: VitFormat.usd(snapshot.totalLiquidity),
                ),
              ),
              Expanded(
                child: _Sc217OverviewMetric(
                  label: 'APR trung bình',
                  value: VitFormat.percent(
                    snapshot.averageApr,
                    fractionDigits: 1,
                  ),
                  valueColor: AppColors.buy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Sc217OverviewMetric extends StatelessWidget {
  const _Sc217OverviewMetric({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.small = false,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.numericMicro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: TabletSpacingTokens.x1),
        Text(
          value,
          style: (small ? AppTextStyles.caption : AppTextStyles.baseMedium)
              .copyWith(
                color: valueColor,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
        ),
      ],
    );
  }
}

class _Sc217LiquidityWarning extends StatelessWidget {
  const _Sc217LiquidityWarning();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.warningBorder,
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox.square(
            dimension: TabletSpacingTokens.iconSm,
            child: Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warn,
              size: TabletSpacingTokens.iconSm,
            ),
          ),
          const SizedBox(width: TabletSpacingTokens.x2),
          Expanded(
            child: Text(
              'Cung cấp thanh khoản có rủi ro tổn thất tạm thời. Phí kiếm '
              'được có thể không bù đắp hết mức sụt giá.',
              style: AppTextStyles.numericMicro.copyWith(
                color: AppColors.text2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
