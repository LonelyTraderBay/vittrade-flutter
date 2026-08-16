import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/p2p_formatters.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

part '../../../widgets/ads/p2p_ad_detail_merchant_info.dart';
part '../../../widgets/ads/p2p_ad_detail_amount_terms.dart';

const double _p2pAdDetailVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pAdDetailNativeNavClearance =
    _p2pAdDetailVisualNavClearance - AppSpacing.x4;
const double _p2pAdDetailVisualClearance = AppSpacing.x3;
const double _p2pAdDetailNativeClearance = AppSpacing.x2;

class P2PAdDetailPage extends ConsumerStatefulWidget {
  const P2PAdDetailPage({super.key, required this.adId, this.shellRenderMode});

  static const contentKey = Key('sc224_p2p_ad_detail_content');
  static const buyButtonKey = Key('sc224_p2p_ad_detail_buy');
  static Key percentKey(int percent) => Key('sc224_percent_$percent');

  final String adId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PAdDetailPage> createState() => _P2PAdDetailPageState();
}

class _P2PAdDetailPageState extends ConsumerState<P2PAdDetailPage> {
  int? _selectedPercent;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pAdDetailProvider(widget.adId));
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pAdDetailVisualNavClearance + _p2pAdDetailVisualClearance
            : _p2pAdDetailNativeNavClearance + _p2pAdDetailNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Chi tiết quảng cáo P2P',
      semanticIdentifier: 'SC-224',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Chi tiết quảng cáo',
            subtitle: 'Quảng cáo · P2P',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.p2p),
          ),
          child: snapshotAsync.when(
            loading: () => const VitSkeletonList(),
            error: (error, stackTrace) => VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(p2pAdDetailProvider(widget.adId)),
            ),
            data: (snapshot) {
              final ad = snapshot.ad;
              final fiatAmount = _selectedPercent == null
                  ? 0
                  : (ad.maxLimit * _selectedPercent! / 100).round();
              final cryptoAmount = fiatAmount == 0
                  ? 0.0
                  : fiatAmount / ad.price;
              final isValid =
                  fiatAmount >= ad.minLimit &&
                  fiatAmount <= ad.maxLimit &&
                  cryptoAmount <= snapshot.availableAmount;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(
                        context,
                      ).copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        key: P2PAdDetailPage.contentKey,
                        physics: const ClampingScrollPhysics(),
                        padding: P2PSpacingTokens.p2pAdDetailFlushScrollPadding(
                          scrollEndPadding,
                        ),
                        child: VitPageContent(
                          rhythm: VitPageRhythm.standard,
                          padding: VitContentPadding.none,
                          fullBleed: true,
                          gap: VitContentGap.tight,
                          children: [
                            _MerchantCard(snapshot: snapshot),
                            _TrustMarketRow(snapshot: snapshot),
                            _SignalChips(snapshot: snapshot),
                            _PriceCard(snapshot: snapshot),
                            _AmountCard(
                              snapshot: snapshot,
                              selectedPercent: _selectedPercent,
                              fiatAmount: fiatAmount,
                              cryptoAmount: cryptoAmount,
                              onPercent: (percent) {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() => _selectedPercent = percent);
                              },
                            ),
                            _RequirementCard(snapshot: snapshot),
                            _TermsCard(snapshot: snapshot),
                            _EscrowCard(
                              snapshot: snapshot,
                              amount: cryptoAmount,
                            ),
                            const VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'P2P order preview review',
                              message:
                                  'Đã xem độ tin cậy merchant, hạn mức, số dư khả dụng, điều khoản thanh toán, bảo vệ escrow và bước đặt lệnh trước khi mua.',
                              contractId: 'p2p-ad-detail-order-review',
                            ),
                            VitCtaButton(
                              key: P2PAdDetailPage.buyButtonKey,
                              onPressed: isValid
                                  ? () => context.go(
                                      AppRoutePaths.p2pOrder(
                                        snapshot.targetOrderId,
                                      ),
                                    )
                                  : null,
                              variant: VitCtaButtonVariant.success,
                              child: Text('Mua ${ad.asset}'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
