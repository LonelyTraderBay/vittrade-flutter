import 'package:flutter/material.dart';
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
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_bots_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_bots/domain/entities/trade_bots_entities.dart';

part '../../../widgets/settings/bot_terms_of_service_page_sections.dart';
part '../../../widgets/settings/bot_terms_of_service_page_common.dart';

const _termsPrimary = AppColors.primary;
const _termsAmber = AppColors.caution;
const _termsRed = AppColors.sell;
const double _termsSpace = AppSpacing.x2;
const double _termsTinySpace = AppSpacing.x1;
const double _termsInfoMinExtent =
    TradeSpacingTokens.copyConfigurationBottomInsetVisual;
// No sanctioned token matches 360 exactly; the closest named token
// (TradeSpacingTokens.tradeBotTermsCardHeight = 575) was verified to break
// the "first viewport previews agreement card" guardrail
// (test/features/trade/bot_terms_of_service_page_test.dart) when swapped
// in, so this stays a page-local literal pending a token correction outside
// this file's scope.
const double _termsCardExtent = 360;
const double _termsWarningMinExtent =
    TradeSpacingTokens.tradeBotQuestionIconBox;
const double _termsAgreementMinExtent =
    TradeSpacingTokens.tradeBotResultIconBox;
const double _termsComplianceMinExtent = AppSpacing.buttonHero;
const double _termsLineTight = 1.05;
const double _termsLineShort = 1.15;
const double _termsLineCaption = 1.2;
const double _termsLineBody = 1.26;
const double _termsLineReadable = 1.34;
const double _termsLineLegal = 1.42;

class BotTermsOfServicePage extends ConsumerStatefulWidget {
  const BotTermsOfServicePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc117_bot_terms_content');
  static const termsScrollKey = Key('sc117_bot_terms_inner_scroll');
  static const agreementKey = Key('sc117_bot_terms_agreement');
  static const ctaKey = Key('sc117_bot_terms_cta');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotTermsOfServicePage> createState() =>
      _BotTermsOfServicePageState();
}

class _BotTermsOfServicePageState extends ConsumerState<BotTermsOfServicePage> {
  final ScrollController _termsController = ScrollController();
  bool _readToEnd = false;
  bool _agreed = false;

  @override
  void initState() {
    super.initState();
    _termsController.addListener(_markReadAtBottom);
  }

  @override
  void dispose() {
    _termsController
      ..removeListener(_markReadAtBottom)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(tradeBotTermsOfServiceProvider);
    return VitTradeHubScaffold(
      title: 'Điều khoản Bot giao dịch',
      subtitle: 'Điều khoản sử dụng bot giao dịch',
      semanticLabel: 'Điều khoản dịch vụ bot giao dịch',
      semanticIdentifier: 'SC-117',
      contentKey: BotTermsOfServicePage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      activeProductId: 'bots',
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeBots,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: snapshotAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được điều khoản bot',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradeBotTermsOfServiceProvider),
          ),
        ],
        data: (snapshot) => [
          VitTradeSection(
            title: 'Thông tin',
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: _termsInfoMinExtent),
              child: VitInfoCallout(
                title: snapshot.infoTitle,
                message: snapshot.infoDescription,
                icon: Icons.description_outlined,
                accentColor: _termsPrimary,
                padding: TradeSpacingTokens.tradeBotCardPaddingLoose,
              ),
            ),
          ),
          VitTradeSection(
            title: 'Điều khoản',
            child: _TermsCard(snapshot: snapshot, controller: _termsController),
          ),
          VitTradeSection(
            title: snapshot.acceptSectionLabel,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!_readToEnd) _ScrollWarning(snapshot: snapshot),
                _AgreementCard(
                  snapshot: snapshot,
                  enabled: _readToEnd,
                  agreed: _agreed,
                  onTap: _toggleAgreement,
                ),
                _TermsCta(
                  snapshot: snapshot,
                  agreed: _agreed,
                  onPressed: _acceptTerms,
                ),
              ],
            ),
          ),
          VitTradeSection(
            title: 'Tuân thủ',
            child: _ComplianceNote(snapshot: snapshot),
          ),
          const VitBotRiskReviewFooter(
            title: 'Xem lại việc chấp nhận điều khoản',
            message:
                'Trạng thái đọc hết, ô đồng ý, giới hạn phù hợp và bước xác nhận tiếp theo được xem lại trước khi cấp quyền truy cập bot.',
            contractId: 'bot-terms-acceptance-review',
          ),
        ],
      ),
    );
  }

  void _markReadAtBottom() {
    if (_readToEnd || !_termsController.hasClients) return;
    final position = _termsController.position;
    if (position.pixels + position.viewportDimension >=
        position.maxScrollExtent -
            TradeSpacingTokens.tradeBotTermsReadThreshold) {
      setState(() => _readToEnd = true);
    }
  }

  void _toggleAgreement() {
    if (!_readToEnd) return;
    setState(() => _agreed = !_agreed);
  }

  void _acceptTerms() {
    if (!_agreed) return;
    context.go(AppRoutePaths.tradeBots);
  }
}
