import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/widgets/ads/p2p_create_ad_sections.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/vit_p2p_flow_scaffold.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

part '../../../widgets/ads/p2p_create_ad_page_sections.dart';

const double _p2pCreateVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pCreateNativeNavClearance =
    _p2pCreateVisualNavClearance - AppSpacing.x4;
const double _p2pCreateVisualClearance = AppSpacing.x3;
const double _p2pCreateNativeClearance = AppSpacing.x2;
const double _p2pCreateGroupGap = AppSpacing.x3;
const double _p2pCreateFieldGap = AppSpacing.x2;
const double _p2pCreateColumnGap = AppSpacing.x2;
const double _p2pCreateSegmentHeight = AppSpacing.buttonCompact;

class P2PCreateAdPage extends ConsumerStatefulWidget {
  const P2PCreateAdPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc226_p2p_create_content');
  static const priceFieldKey = P2PCreateAdUiKeys.priceFieldKey;
  static const marginFieldKey = P2PCreateAdUiKeys.marginFieldKey;
  static const totalFieldKey = P2PCreateAdUiKeys.totalFieldKey;
  static const minFieldKey = P2PCreateAdUiKeys.minFieldKey;
  static const maxFieldKey = P2PCreateAdUiKeys.maxFieldKey;
  static const publishButtonKey = P2PCreateAdUiKeys.publishButtonKey;
  static const confirmPublishKey = P2PCreateAdUiKeys.confirmPublishKey;

  static Key adTypeKey(P2PTradeType type) => P2PCreateAdUiKeys.adTypeKey(type);
  static Key assetKey(String asset) => P2PCreateAdUiKeys.assetKey(asset);
  static Key currencyKey(String currency) =>
      P2PCreateAdUiKeys.currencyKey(currency);
  static Key priceTypeKey(String type) => P2PCreateAdUiKeys.priceTypeKey(type);
  static Key paymentKey(String payment) =>
      P2PCreateAdUiKeys.paymentKey(payment);
  static Key paymentWindowKey(int minutes) =>
      P2PCreateAdUiKeys.paymentWindowKey(minutes);

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PCreateAdPage> createState() => _P2PCreateAdPageState();
}

class _P2PCreateAdPageState extends ConsumerState<P2PCreateAdPage> {
  final _priceController = TextEditingController();
  final _marginController = TextEditingController();
  final _totalController = TextEditingController();
  final _minController = TextEditingController();
  final _maxController = TextEditingController();
  final _minTradesController = TextEditingController();
  final _minDaysController = TextEditingController();
  final _termsController = TextEditingController();
  final _autoReplyController = TextEditingController();

  P2PTradeType _adType = P2PTradeType.sell;
  String _asset = 'USDT';
  String _currency = 'VND';
  String _priceType = 'fixed';
  int _paymentWindow = 15;
  String _tradingHours = '24/7';
  bool _requireKyc = false;
  String _requiredKycLevel = '1';
  bool _submitting = false;
  bool _previewExpanded = false;
  final Set<String> _selectedPayments = {};

  @override
  void dispose() {
    _priceController.dispose();
    _marginController.dispose();
    _totalController.dispose();
    _minController.dispose();
    _maxController.dispose();
    _minTradesController.dispose();
    _minDaysController.dispose();
    _termsController.dispose();
    _autoReplyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pCreateAdProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pCreateVisualNavClearance + _p2pCreateVisualClearance
            : _p2pCreateNativeNavClearance + _p2pCreateNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return snapshotAsync.when(
      loading: () => VitP2PFlowScaffold(
        semanticLabel: 'Đăng quảng cáo P2P',
        semanticIdentifier: 'SC-226',
        title: 'Đang tải…',
        onBack: () => context.go(AppRoutePaths.p2pMyAds),
        children: const [VitSkeletonList()],
      ),
      error: (error, stackTrace) => VitP2PFlowScaffold(
        semanticLabel: 'Đăng quảng cáo P2P',
        semanticIdentifier: 'SC-226',
        title: 'Không tải được',
        onBack: () => context.go(AppRoutePaths.p2pMyAds),
        children: [
          VitErrorState(
            title: 'Không tải được',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(p2pCreateAdProvider),
          ),
        ],
      ),
      data: (snapshot) {
        final formController = P2PCreateAdController(
          state: P2PCreateAdViewState(snapshot: snapshot),
        );
        final draft = _draft();
        final preview = formController.preview(draft);
        final publishBlockers = [
          ...formController.publishBlockers(draft),
          if (_submitting) 'Đang đăng quảng cáo',
        ];
        final canPublish = preview.canPublish && !_submitting;
        return VitP2PFlowScaffold(
          semanticLabel: 'Đăng quảng cáo P2P',
          semanticIdentifier: 'SC-226',
          title: 'Đăng quảng cáo P2P',
          subtitle: 'Tạo mới · P2P',
          onBack: () => context.go(AppRoutePaths.p2pMyAds),
          contentKey: P2PCreateAdPage.contentKey,
          shellRenderMode: mode,
          bottomInset: scrollEndPadding,
          rhythm: VitPageRhythm.form,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding:
                      P2PSpacingTokens.p2pMerchantCommerceSectionLabelPadding,
                  child: VitSectionHeader(
                    title: 'Loại quảng cáo',
                    titleColor: AppColors.text2,
                    titleFontWeight: AppTextStyles.normal,
                  ),
                ),
                _TradeTypePicker(
                  value: _adType,
                  onChanged: (type) => setState(() => _adType = type),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _ChipGroup(
                    label: 'Tài sản',
                    values: snapshot.assets,
                    selected: _asset,
                    keyBuilder: P2PCreateAdPage.assetKey,
                    onSelected: (value) {
                      unawaited(HapticFeedback.selectionClick());
                      setState(() => _asset = value);
                    },
                  ),
                ),
                const SizedBox(width: _p2pCreateColumnGap),
                Expanded(
                  child: _ChipGroup(
                    label: 'Tiền tệ',
                    values: snapshot.currencies,
                    selected: _currency,
                    keyBuilder: P2PCreateAdPage.currencyKey,
                    onSelected: (value) {
                      unawaited(HapticFeedback.selectionClick());
                      setState(() => _currency = value);
                    },
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding:
                      P2PSpacingTokens.p2pMerchantCommerceSectionLabelPadding,
                  child: VitSectionHeader(
                    title: 'Loại giá',
                    titleColor: AppColors.text2,
                    titleFontWeight: AppTextStyles.normal,
                  ),
                ),
                _PriceTypePicker(
                  value: _priceType,
                  onChanged: (value) {
                    unawaited(HapticFeedback.selectionClick());
                    setState(() => _priceType = value);
                  },
                ),
                const SizedBox(height: _p2pCreateGroupGap),
                if (_priceType == 'fixed')
                  _InputBlock(
                    label: 'Giá ($_currency/$_asset) *',
                    hint:
                        'Giá thị trường: ${preview.marketPriceLabel} $_currency',
                    child: VitInput(
                      controller: _priceController,
                      fieldKey: P2PCreateAdPage.priceFieldKey,
                      hintText: preview.marketPriceLabel,
                      keyboardType: TextInputType.number,
                      suffix: Text(
                        _currency,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  )
                else
                  P2PCreateAdFloatingPriceBlock(
                    controller: _marginController,
                    preview: preview,
                    onChanged: () => setState(() {}),
                  ),
                if (preview.effectivePrice > 0) ...[
                  const SizedBox(height: _p2pCreateFieldGap),
                  Text(
                    preview.priceDiffLabel,
                    style: AppTextStyles.micro.copyWith(
                      color: preview.priceDiffPercent >= 0
                          ? AppColors.buy
                          : AppColors.sell,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ],
            ),
            _InputBlock(
              label: 'Tổng $_asset giao dịch *',
              child: VitInput(
                controller: _totalController,
                fieldKey: P2PCreateAdPage.totalFieldKey,
                hintText: '0.00',
                keyboardType: TextInputType.number,
                suffix: Text(
                  _asset,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: _InputBlock(
                    label: 'Tối thiểu ($_currency) *',
                    child: VitInput(
                      controller: _minController,
                      fieldKey: P2PCreateAdPage.minFieldKey,
                      hintText: '500,000',
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ),
                const SizedBox(width: _p2pCreateColumnGap),
                Expanded(
                  child: _InputBlock(
                    label: 'Tối đa ($_currency) *',
                    child: VitInput(
                      controller: _maxController,
                      fieldKey: P2PCreateAdPage.maxFieldKey,
                      hintText: '50,000,000',
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ),
              ],
            ),
            P2PCreateAdPaymentsBlock(
              options: snapshot.paymentOptions,
              selected: _selectedPayments,
              onToggle: _togglePayment,
            ),
            P2PCreateAdPaymentWindowBlock(
              values: snapshot.paymentWindows,
              selected: _paymentWindow,
              onSelected: (value) {
                unawaited(HapticFeedback.selectionClick());
                setState(() => _paymentWindow = value);
              },
            ),
            _ChipGroup(
              label: 'Giờ giao dịch',
              values: snapshot.tradingHours,
              selected: _tradingHours,
              keyBuilder: (value) => Key('sc226_hours_$value'),
              onSelected: (value) {
                unawaited(HapticFeedback.selectionClick());
                setState(() => _tradingHours = value);
              },
            ),
            P2PCreateAdRequirementCard(
              requireKyc: _requireKyc,
              requiredKycLevel: _requiredKycLevel,
              minTradesController: _minTradesController,
              minDaysController: _minDaysController,
              onKycChanged: (value) {
                unawaited(HapticFeedback.selectionClick());
                setState(() => _requireKyc = value);
              },
              onLevelChanged: (value) {
                unawaited(HapticFeedback.selectionClick());
                setState(() => _requiredKycLevel = value);
              },
            ),
            P2PCreateAdMultilineBlock(
              label: 'Điều kiện giao dịch (tuỳ chọn)',
              controller: _termsController,
              hintText: 'VD: Chỉ giao dịch với tài khoản đã xác minh KYC...',
            ),
            P2PCreateAdMultilineBlock(
              label: 'Tin nhắn tự động (tuỳ chọn)',
              controller: _autoReplyController,
              hintText:
                  'VD: Cảm ơn bạn! Vui lòng chuyển khoản theo thông tin bên dưới.',
              hint: 'Gửi tự động khi đối tác tạo đơn.',
            ),
            P2PCreateAdWarningCard(text: snapshot.warningNote),
            P2PCreateAdLivePreviewCard(
              expanded: _previewExpanded,
              onTap: () => setState(() => _previewExpanded = !_previewExpanded),
              preview: preview,
            ),
            const VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              title: 'P2P ad publish review',
              message:
                  'Đã xem giá, hạn mức, phương thức thanh toán, kiểm tra escrow, xem trước phí/rủi ro, hộp thoại xác nhận và kết quả đăng trước khi niêm yết.',
              contractId: 'p2p-create-ad-review',
            ),
            _buildPublishActionSection(
              context: context,
              preview: preview,
              blockers: publishBlockers,
              canPublish: canPublish,
            ),
          ],
        );
      },
    );
  }

  Widget _buildPublishActionSection({
    required BuildContext context,
    required P2PCreateAdPreview preview,
    required List<String> blockers,
    required bool canPublish,
  }) {
    return Semantics(
      container: true,
      label: 'Thao tác đăng quảng cáo P2P',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (blockers.isNotEmpty) ...[
            _PublishReadinessPanel(blockers: blockers),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
          VitCtaButton(
            key: P2PCreateAdPage.publishButtonKey,
            onPressed: canPublish
                ? () => _confirmPublish(context, preview)
                : null,
            variant: _adType == P2PTradeType.buy
                ? VitCtaButtonVariant.success
                : VitCtaButtonVariant.danger,
            loading: _submitting,
            child: Text(_submitting ? 'Đang đăng...' : preview.publishLabel),
          ),
        ],
      ),
    );
  }

  P2PCreateAdDraft _draft() {
    return P2PCreateAdDraft(
      adType: _adType,
      asset: _asset,
      currency: _currency,
      priceType: _priceType,
      paymentWindow: _paymentWindow,
      tradingHours: _tradingHours,
      requireKyc: _requireKyc,
      requiredKycLevel: _requiredKycLevel,
      selectedPayments: _selectedPayments,
      priceText: _priceController.text,
      marginText: _marginController.text,
      totalText: _totalController.text,
      minLimitText: _minController.text,
      maxLimitText: _maxController.text,
    );
  }

  void _togglePayment(String payment) {
    unawaited(HapticFeedback.selectionClick());
    // GD4 bẫy 15: repo trong event handler — đọc lười qua `.value` (đã có
    // sẵn vì nút này chỉ render trong nhánh data:).
    final snapshot = ref.read(p2pCreateAdProvider).value;
    if (snapshot == null) return;
    final formController = P2PCreateAdController(
      state: P2PCreateAdViewState(snapshot: snapshot),
    );
    final nextPayments = formController.toggledPayments(
      _selectedPayments,
      payment,
    );
    setState(() {
      _selectedPayments
        ..clear()
        ..addAll(nextPayments);
    });
  }

  Future<void> _confirmPublish(
    BuildContext context,
    P2PCreateAdPreview preview,
  ) async {
    final confirmed = await showVitPreviewConfirmSheet(
      context: context,
      title: 'Xác nhận đăng quảng cáo',
      confirmKey: P2PCreateAdPage.confirmPublishKey,
      confirmLabel: 'Đăng',
      confirmVariant: _adType == P2PTradeType.buy
          ? VitCtaButtonVariant.success
          : VitCtaButtonVariant.danger,
      items: [
        VitFinancialSafetyItem(label: 'Loại', value: preview.typeLabel),
        VitFinancialSafetyItem(
          label: 'Tài sản',
          value: preview.totalAmountLabel,
        ),
        VitFinancialSafetyItem(
          label: 'Giá',
          value: '${preview.priceLabel}/$_asset',
        ),
        VitFinancialSafetyItem(
          label: 'Thanh toán',
          value: preview.paymentSummary,
        ),
        VitFinancialSafetyItem(label: 'Limit', value: preview.limitSummary),
        VitFinancialSafetyItem(label: 'Fee', value: preview.feeReviewLabel),
      ],
      footer: '${preview.escrowReviewLabel}\n${preview.riskReviewLabel}',
    );
    if (!confirmed || !context.mounted) return;
    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (!context.mounted) return;
    setState(() => _submitting = false);
    await showVitNoticeSheet(
      context: context,
      title: 'Đã đăng quảng cáo',
      message: 'Quảng cáo của bạn đã hiển thị trong danh sách.',
      variant: VitBannerVariant.success,
      ctaVariant: VitCtaButtonVariant.success,
      onPrimary: () {
        if (context.mounted) context.go(AppRoutePaths.p2pMyAds);
      },
    );
  }
}
