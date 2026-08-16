part of '../../phone/pages/orders/p2p_order_page.dart';

class _P2POrderPageState extends ConsumerState<P2POrderPage> {
  _P2POrderUiStep _step = _P2POrderUiStep.payment;
  String? _copiedField;
  bool _showQr = true;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pOrderProvider(widget.orderId));
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pOrderVisualNavClearance + _p2pOrderVisualClearance
            : _p2pOrderNativeNavClearance + _p2pOrderNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Chi tiết đơn hàng P2P',
      semanticIdentifier: 'SC-216',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Chi tiết đơn hàng',
            subtitle: 'Đơn hàng - P2P',
            showBack: true,
            onBack: () =>
                goBackOrFallback(context, fallbackPath: AppRoutePaths.p2p),
          ),
          child: snapshotAsync.when(
            loading: () => const VitSkeletonList(),
            error: (error, stackTrace) => VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(p2pOrderProvider(widget.orderId)),
            ),
            data: (snapshot) {
              final controller = P2POrderController(
                state: P2POrderViewState(snapshot: snapshot),
              );
              final paidPreview = controller.paidPreview();
              final order = snapshot.order;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _StatusBanner(
                    label: _step == _P2POrderUiStep.payment
                        ? order.statusLabel
                        : paidPreview.statusLabel,
                    countdown: _step == _P2POrderUiStep.payment
                        ? order.countdownLabel
                        : paidPreview.countdownLabel,
                    color: _step == _P2POrderUiStep.payment
                        ? AppColors.warn
                        : AppColors.primary,
                  ),
                  _OrderStepper(step: _step),
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(
                        context,
                      ).copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        key: P2POrderPage.contentKey,
                        physics: const ClampingScrollPhysics(),
                        padding: P2PSpacingTokens.p2pOrderScrollPadding(
                          scrollEndPadding,
                        ),
                        child: VitPageContent(
                          rhythm: VitPageRhythm.standard,
                          padding: VitContentPadding.none,
                          gap: VitContentGap.tight,
                          fullBleed: true,
                          children: [
                            _SafetyBanner(
                              title: snapshot.safetyTitle,
                              bullets: snapshot.safetyBullets,
                            ),
                            _EscrowBanner(
                              order: order,
                              onTap: () =>
                                  context.go(AppRoutePaths.p2pEscrow(order.id)),
                            ),
                            _OrderInfoCard(order: order),
                            if (_step == _P2POrderUiStep.payment)
                              _PaymentInfoCard(
                                order: order,
                                fields: snapshot.paymentFields,
                                showQr: _showQr,
                                copiedField: _copiedField,
                                warningTitle: snapshot.transferWarningTitle,
                                warning: snapshot.transferWarning,
                                onToggleQr: () {
                                  unawaited(HapticFeedback.selectionClick());
                                  setState(() => _showQr = !_showQr);
                                },
                                onCopyAll: () => _markCopied('all'),
                                onCopy: _markCopied,
                              ),
                            _ProofCard(
                              step: _step,
                              onUpload: () => context.go(
                                AppRoutePaths.p2pOrderProof(order.id),
                              ),
                            ),
                            _TimelineCard(timeline: snapshot.timeline),
                            _PaymentWarning(message: snapshot.paymentWarning),
                            _PrimaryActions(
                              step: _step,
                              onChat: () =>
                                  context.go(AppRoutePaths.p2pChat(order.id)),
                              onPaid: _markPaid,
                            ),
                            if (_step == _P2POrderUiStep.payment)
                              _TextActionButton(
                                key: P2POrderPage.disputeKey,
                                onPressed: () => context.go(
                                  AppRoutePaths.p2pDispute(order.id),
                                ),
                                icon: const Icon(
                                  Icons.gavel_outlined,
                                  size: AppSpacing.iconSm,
                                ),
                                label: 'Mở khiếu nại',
                                color: AppColors.warn,
                              ),
                            if (_step == _P2POrderUiStep.payment)
                              _TextActionButton(
                                key: P2POrderPage.cancelKey,
                                onPressed: () => context.go(
                                  AppRoutePaths.p2pOrderCancel(order.id),
                                ),
                                icon: const Icon(
                                  Icons.close_rounded,
                                  size: AppSpacing.iconSm,
                                ),
                                label: 'Hủy đơn hàng',
                                color: AppColors.sell,
                              ),
                            _QuickActions(actions: snapshot.quickActions),
                            const VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'Xem lại trạng thái đơn P2P',
                              message:
                                  'Bộ đếm trạng thái, số tiền escrow, chi tiết thanh toán, tải bằng chứng, timeline, cảnh báo, trò chuyện, trạng thái đã trả, lộ trình hủy và thao tác nhanh vẫn hiển thị trước khi đơn chuyển bước.',
                              contractId: 'SC-216',
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

  void _markCopied(String field) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _copiedField = field);
    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (!mounted || _copiedField != field) return;
      setState(() => _copiedField = null);
    });
  }

  void _markPaid() {
    unawaited(HapticFeedback.mediumImpact());
    setState(() => _step = _P2POrderUiStep.confirm);
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({
    required this.label,
    required this.countdown,
    required this.color,
  });

  final String label;
  final String countdown;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: .08),
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.contentPad,
          vertical: AppSpacing.x2,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            Text(
              countdown,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontFeatures: AppTextStyles.tabularFigures,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderStepper extends StatelessWidget {
  const _OrderStepper({required this.step});

  final _P2POrderUiStep step;

  @override
  Widget build(BuildContext context) {
    final activeIndex = step == _P2POrderUiStep.payment ? 1 : 2;
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.contentPad,
        vertical: AppSpacing.x1,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (var index = 0; index < 3; index++) ...[
            Expanded(
              child: _StepperNode(
                index: index,
                label: const ['Đặt lệnh', 'Thanh toán', 'Nhận tiền'][index],
                activeIndex: activeIndex,
              ),
            ),
            if (index < 2)
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: AppSpacing.x2,
                ),
                child: SizedBox(
                  width: AppSpacing.x3,
                  height: _p2pOrderStepperConnectorHeight,
                  child: ColoredBox(
                    color: index < activeIndex - 1
                        ? AppModuleAccents.p2p
                        : AppColors.borderSolid,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _StepperNode extends StatelessWidget {
  const _StepperNode({
    required this.index,
    required this.label,
    required this.activeIndex,
  });

  final int index;
  final String label;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final isCompleted = index < activeIndex;
    final color = isCompleted ? AppModuleAccents.p2p : AppColors.text3;
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: isCompleted ? AppColors.warn10 : AppColors.surface2,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.pillRadius,
          side: BorderSide(
            color: isCompleted ? AppModuleAccents.p2p : AppColors.borderSolid,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isCompleted
                ? const Icon(
                    Icons.check_rounded,
                    color: AppModuleAccents.p2p,
                    size: AppSpacing.iconSm,
                  )
                : Text(
                    '${index + 1}',
                    style: AppTextStyles.micro.copyWith(
                      color: color,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
            const SizedBox(width: AppSpacing.x1),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontWeight: isCompleted
                      ? AppTextStyles.bold
                      : AppTextStyles.medium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SafetyBanner extends StatelessWidget {
  const _SafetyBanner({required this.title, required this.bullets});

  final String title;
  final List<String> bullets;

  @override
  Widget build(BuildContext context) {
    final safetyCopy = bullets.join(' · ');
    return VitCard(
      borderColor: AppColors.sell20,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Material(
            color: AppColors.sell10,
            shape: CircleBorder(),
            child: SizedBox(
              width: _p2pOrderSafetyIconBox,
              height: _p2pOrderSafetyIconBox,
              child: Center(
                child: Icon(
                  Icons.shield_outlined,
                  color: AppColors.sell,
                  size: AppSpacing.iconSm,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.sell,
                    fontWeight: AppTextStyles.bold,
                    height: AppTextStyles.numericMicro.height,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  safetyCopy,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.sell,
                    height: AppTextStyles.numericMicro.height,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EscrowBanner extends StatelessWidget {
  const _EscrowBanner({required this.order, required this.onTap});

  final P2POrderDetailDraft order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2POrderPage.escrowKey,
      onTap: onTap,
      borderColor: AppColors.buy20,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.lock_outline_rounded,
            color: AppColors.buy,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Escrow: ${_formatCrypto(order.escrowAmount)} ${order.asset} đã khóa',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  'Tài sản được bảo vệ cho đến khi xác nhận thanh toán',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: AppTextStyles.numericMicro.height,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Material(
            color: AppColors.buy10,
            borderRadius: AppRadii.inputRadius,
            child: Padding(
              padding: P2PSpacingTokens.p2pOrderEscrowActionPadding,
              child: Row(
                children: [
                  Text(
                    'Chi tiết',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.buy,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.buy,
                    size: AppSpacing.iconSm,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderInfoCard extends StatelessWidget {
  const _OrderInfoCard({required this.order});

  final P2POrderDetailDraft order;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: P2PSpacingTokens.p2pOrderCompactCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Đơn hàng',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _SmallPill(
                icon: Icons.copy_rounded,
                label: order.orderNumber,
                color: AppColors.text2,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          _InfoLine(
            label: 'Giao dịch',
            value: [
              order.typeLabel,
              _formatCrypto(order.amount),
              order.asset,
            ].join(' '),
            emphasis: true,
          ),
          _InfoLine(
            label: 'Giá',
            value: '${_formatVnd(order.priceVnd)} VND/${order.asset}',
          ),
          _InfoLine(
            label: 'Cần thanh toán',
            value: '${_formatVnd(order.totalVnd)} ${order.currency}',
            emphasis: true,
          ),
          _InfoLine(label: 'Thanh toán qua', value: order.paymentMethod),
          _InfoLine(label: 'Người bán', value: order.merchant),
          _InfoLine(label: 'Phí', value: order.feeLabel, isLast: true),
        ],
      ),
    );
  }
}
