import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/trade_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/phone/vit_trade_confirm_sheet.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/phone/vit_trade_simple_shell.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/convert/convert_page_widgets.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';

part '../../widgets/convert/convert_page_common.dart';
part '../../widgets/convert/convert_page_sections.dart';
part '../../widgets/convert/convert_page_amount_widgets.dart';

const _tradePrimary = AppColors.primary;

// GD4 Cụm F3: `previewConvert` giờ Future<T> — quote đọc theo 1 request tạm
// thời (mỗi keystroke đổi amount), fallback rỗng chỉ chạm tới ở frame đầu
// tiên trước khi provider resolve (mục 5, "2 async song song trên 1 trang").
const _emptyConvertQuote = TradeConvertQuote(
  fromSymbol: '',
  toSymbol: '',
  fromAmount: 0,
  toAmount: 0,
  feeUsd: 0,
  rate: 0,
  quoteLabel: '',
  validSeconds: 0,
  canSubmit: false,
);

bool _convertSnapshotIsOffline(TradeConvertSnapshot snapshot) {
  return snapshot.lastUpdatedLabel.toLowerCase().contains('offline');
}

bool _convertSnapshotHasError(TradeConvertSnapshot snapshot) {
  return snapshot.lastUpdatedLabel.toLowerCase().contains('error');
}

enum _ConvertMode { market }

class ConvertPage extends ConsumerStatefulWidget {
  const ConvertPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc056_convert_scroll_content');
  static const backKey = Key('sc056_back');
  static const swapKey = Key('sc056_swap');
  static const fromAssetKey = Key('sc056_from_asset');
  static const toAssetKey = Key('sc056_to_asset');
  static const amountFieldKey = Key('sc056_amount_field');
  static const submitKey = Key('sc056_submit');

  static Key favoriteKey(String label) => Key('sc056_favorite_$label');
  static Key pctKey(int pct) => Key('sc056_pct_$pct');
  static Key assetOptionKey(String side, String symbol) =>
      Key('sc056_asset_${side}_$symbol');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ConvertPage> createState() => _ConvertPageState();
}

class _ConvertPageState extends ConsumerState<ConvertPage> {
  final _amountController = TextEditingController();
  static const _ConvertMode _mode = _ConvertMode.market;
  static const double _slippage = .5;
  // GD4 Cụm F3: `getConvert` giờ Future<T> — `initState()` không thể await,
  // nên seed lười trong nhánh `data:` của `.when()` (chỉ seed lần đầu qua
  // `??=`, xem `_buildContent`).
  String? _fromSymbol;
  String? _toSymbol;
  TradeConvertReceipt? _receipt;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(tradeConvertSnapshotProvider);
    return snapshotAsync.when(
      loading: () => const VitSkeletonList(),
      error: (error, stackTrace) => VitErrorState(
        title: 'Không tải được màn hình Convert',
        message: 'Vui lòng kiểm tra kết nối và thử lại.',
        actionLabel: 'Thử lại',
        onAction: () => ref.invalidate(tradeConvertSnapshotProvider),
      ),
      data: _buildContent,
    );
  }

  Widget _buildContent(TradeConvertSnapshot snapshot) {
    _fromSymbol ??= snapshot.fromAsset.symbol;
    _toSymbol ??= snapshot.toAsset.symbol;
    final fromAsset = _asset(snapshot, _fromSymbol!);
    final toAsset = _asset(snapshot, _toSymbol!);
    final amount = double.tryParse(_amountController.text) ?? 0;
    final request = TradeConvertRequest(
      fromSymbol: fromAsset.symbol,
      toSymbol: toAsset.symbol,
      amount: amount,
      slippagePct: _slippage,
      mode: _mode.name,
    );
    // Quote là async PHỤ (mục 5) — trang đã chặn toàn bộ qua
    // `tradeConvertSnapshotProvider.when()` ở `build()`; không lồng thêm
    // `.when()` thứ hai ở đây (tránh 2 lớp skeleton chồng nhau).
    final quote =
        ref.watch(tradeConvertQuoteProvider(request)).value ??
        _emptyConvertQuote;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final isOffline = _convertSnapshotIsOffline(snapshot);
    final hasError = _convertSnapshotHasError(snapshot);

    return VitTradeSimpleShell(
      title: 'Chuyển đổi',
      subtitle: 'Đổi tài sản nhanh',
      semanticLabel: 'Chuyển đổi tài sản',
      semanticIdentifier: 'SC-056',
      contentKey: ConvertPage.contentKey,
      shellRenderMode: mode,
      showBack: true,
      backKey: ConvertPage.backKey,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.trade,
        mode: BackNavigationMode.historyThenFallback,
      ),
      activeProductId: 'convert',
      productPair: snapshot.trade.pair,
      quickNavKey: TradePage.quickNavKey,
      headerActions: [
        VitHeaderActionItem(
          type: VitHeaderActionType.settings,
          tooltip: 'Cài đặt giao dịch',
          onPressed: _openSettings,
        ),
      ],
      children: [
        if (isOffline)
          const VitOfflineBanner(
            message: 'Mất kết nối. Đang hiển thị tỷ giá đã lưu.',
            detail: 'Thử làm mới sau khi có mạng.',
          ),
        if (!isOffline && hasError)
          const VitBanner(
            variant: VitBannerVariant.error,
            icon: Icons.error_outline_rounded,
            message: 'Không thể làm mới tỷ giá.',
            detail: 'Đang hiển thị báo giá gần nhất.',
          ),
        VitTradeSection(
          title: 'Đổi $_fromSymbol sang $_toSymbol',
          child: _ConvertHeroCard(
            fromAsset: fromAsset,
            toAsset: toAsset,
            amountController: _amountController,
            quoteAmount: quote.toAmount,
            quoteLabel: quote.quoteLabel,
            countdown: '${quote.validSeconds}s',
            favoritePairs: snapshot.favoritePairs,
            activeFrom: fromAsset.symbol,
            activeTo: toAsset.symbol,
            onFromChanged: () => setState(() => _receipt = null),
            onFromAssetTap: () => _showAssetPicker('from', snapshot.assets),
            onToAssetTap: () => _showAssetPicker('to', snapshot.assets),
            onPercent: (pct) => _setPercentAmount(fromAsset, pct),
            onSwap: _swapAssets,
            onFavoriteSelected: _selectFavoritePair,
          ),
        ),
        _ConvertRiskReviewPanel(
          quote: quote,
          fromSymbol: fromAsset.symbol,
          toSymbol: toAsset.symbol,
          slippage: _slippage,
        ),
        _SubmitButton(
          enabled: quote.canSubmit && !isOffline,
          receipt: _receipt,
          onPressed: () =>
              _submitWithConfirm(request, quote, fromAsset, toAsset),
        ),
        VitTradeSection(
          title: 'Giao dịch gần đây',
          actionLabel: 'Xem tất cả',
          onAction: () {},
          child: _HistoryList(records: snapshot.history),
        ),
      ],
    );
  }

  TradeConvertAsset _asset(TradeConvertSnapshot snapshot, String symbol) {
    return snapshot.assets.firstWhere(
      (asset) => asset.symbol == symbol,
      orElse: () => snapshot.assets.first,
    );
  }

  void _selectFavoritePair(TradeConvertFavoritePair pair) {
    setState(() {
      _fromSymbol = pair.fromSymbol;
      _toSymbol = pair.toSymbol;
      _receipt = null;
    });
  }

  void _swapAssets() {
    setState(() {
      final currentFrom = _fromSymbol;
      _fromSymbol = _toSymbol;
      _toSymbol = currentFrom;
      _receipt = null;
    });
  }

  void _setPercentAmount(TradeConvertAsset asset, int pct) {
    final amount = asset.balance * pct / 100;
    setState(() {
      _amountController.text = formatConvertInputAmount(amount);
      _receipt = null;
    });
  }

  Future<void> _showAssetPicker(
    String side,
    List<TradeConvertAsset> assets,
  ) async {
    final selected = await showVitBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      barrierColor: AppColors.modalScrim,
      builder: (_) => ConvertAssetSheet(
        side: side,
        assets: assets,
        // Non-null: `_showAssetPicker` chỉ được gọi từ cây widget của
        // `_buildContent`, tại đó `_fromSymbol`/`_toSymbol` đã seed.
        selectedSymbol: (side == 'from' ? _fromSymbol : _toSymbol)!,
        excludedSymbol: (side == 'from' ? _toSymbol : _fromSymbol)!,
        optionKeyBuilder: ConvertPage.assetOptionKey,
      ),
    );
    if (selected == null || !mounted) return;
    setState(() {
      if (side == 'from') {
        _fromSymbol = selected;
      } else {
        _toSymbol = selected;
      }
      _receipt = null;
    });
  }

  void _openSettings() {
    unawaited(context.push(AppRoutePaths.tradeSettings));
  }

  Future<void> _submitWithConfirm(
    TradeConvertRequest request,
    TradeConvertQuote quote,
    TradeConvertAsset fromAsset,
    TradeConvertAsset toAsset,
  ) async {
    if (request.amount <= 0) return;
    final confirmed = await showVitTradeConfirmSheet(
      context: context,
      title: 'Xem lại chuyển đổi',
      lines: [
        VitTradeConfirmLine(
          label: 'Từ',
          value: '${request.amount} ${fromAsset.symbol}',
        ),
        VitTradeConfirmLine(label: 'Sang', value: toAsset.symbol),
        VitTradeConfirmLine(
          label: 'Nhận ước tính',
          value: quote.toAmount.toStringAsFixed(6),
        ),
        VitTradeConfirmLine(label: 'Tỷ giá', value: quote.quoteLabel),
        VitTradeConfirmLine(
          label: 'Phí ước tính',
          value: '\$${quote.feeUsd.toStringAsFixed(2)}',
        ),
      ],
    );
    if (!confirmed || !mounted) return;
    await _submit(request);
  }

  Future<void> _submit(TradeConvertRequest request) async {
    if (request.amount <= 0) return;
    final receipt = await ref
        .read(tradeReadModelControllerProvider)
        .submitConvert(request);
    if (!mounted) return;
    setState(() => _receipt = receipt);
    if (!mounted) return;
    await showVitNoticeSheet(
      context: context,
      title: 'Đã gửi chuyển đổi',
      message: 'Đã tạo ${receipt.convertId}',
      variant: VitBannerVariant.success,
    );
  }
}
