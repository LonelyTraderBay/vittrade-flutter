part of '../../phone/pages/orders/p2p_order_page.dart';

class _PaymentInfoCard extends StatelessWidget {
  const _PaymentInfoCard({
    required this.order,
    required this.fields,
    required this.showQr,
    required this.copiedField,
    required this.warningTitle,
    required this.warning,
    required this.onToggleQr,
    required this.onCopyAll,
    required this.onCopy,
  });

  final P2POrderDetailDraft order;
  final List<P2POrderPaymentFieldDraft> fields;
  final bool showQr;
  final String? copiedField;
  final String warningTitle;
  final String warning;
  final VoidCallback onToggleQr;
  final VoidCallback onCopyAll;
  final ValueChanged<String> onCopy;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.primary20,
      padding: P2PSpacingTokens.p2pOrderCompactCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                color: AppModuleAccents.p2p,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Thông tin chuyển khoản',
                  style: AppTextStyles.caption.copyWith(
                    color: AppModuleAccents.p2p,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _CopyButton(
                key: P2POrderPage.copyAllKey,
                label: copiedField == 'all' ? 'Đã copy!' : 'Copy tất cả',
                copied: copiedField == 'all',
                onPressed: onCopyAll,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          VitCard(
            key: P2POrderPage.qrToggleKey,
            onTap: onToggleQr,
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.standard,
            padding: AppSpacing.zeroInsets,
            child: Padding(
              padding: P2PSpacingTokens.p2pOrderQrTogglePadding,
              child: Row(
                children: [
                  const Icon(
                    Icons.qr_code_2_rounded,
                    color: AppModuleAccents.p2p,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      'Mã QR chuyển khoản',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                  Text(
                    showQr ? 'Thu gọn' : 'Hiển thị',
                    style: AppTextStyles.micro.copyWith(
                      color: AppModuleAccents.p2p,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (showQr) ...[
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            _QrPanel(order: order),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
          for (final field in fields)
            _PaymentFieldLine(
              field: field,
              copied: copiedField == field.id,
              onCopy: () => onCopy(field.id),
            ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          _InlineWarning(title: warningTitle, message: warning),
        ],
      ),
    );
  }
}

class _QrPanel extends StatelessWidget {
  const _QrPanel({required this.order});

  final P2POrderDetailDraft order;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.borderSolid,
      padding: P2PSpacingTokens.p2pOrderQrPanelPadding,
      child: Column(
        children: [
          Material(
            color: AppColors.onAccent,
            borderRadius: AppRadii.mdRadius,
            child: Padding(
              padding: P2PSpacingTokens.p2pOrderQrInnerPadding,
              child: CustomPaint(
                painter: _QrPatternPainter(
                  data:
                      '${order.bankName}|${order.accountNumber}|${order.accountName}|${order.totalVnd}|${order.transferContent}',
                ),
                size: const Size(
                  P2PSpacingTokens.p2pOrderQrSize,
                  P2PSpacingTokens.p2pOrderQrSize,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            'Quét mã bằng app ngân hàng',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            '${order.bankName} - ${order.accountName}',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          const _SmallPill(
            icon: Icons.open_in_new_rounded,
            label: 'Mở app ngân hàng',
            color: AppModuleAccents.p2p,
          ),
        ],
      ),
    );
  }
}

class _PaymentFieldLine extends StatelessWidget {
  const _PaymentFieldLine({
    required this.field,
    required this.copied,
    required this.onCopy,
  });

  final P2POrderPaymentFieldDraft field;
  final bool copied;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: P2PSpacingTokens.p2pOrderPaymentFieldPadding,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  field.label,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  field.value,
                  style:
                      (field.emphasis
                              ? AppTextStyles.caption
                              : AppTextStyles.micro)
                          .copyWith(
                            color: AppColors.text1,
                            fontWeight: field.emphasis
                                ? AppTextStyles.bold
                                : AppTextStyles.medium,
                            fontFeatures: field.monospace
                                ? AppTextStyles.tabularFigures
                                : null,
                          ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          _CopyButton(
            key: P2POrderPage.copyKey(field.id),
            label: copied ? 'Đã copy' : 'Copy',
            copied: copied,
            onPressed: onCopy,
          ),
        ],
      ),
    );
  }
}

class _ProofCard extends StatelessWidget {
  const _ProofCard({required this.step, required this.onUpload});

  final _P2POrderUiStep step;
  final VoidCallback onUpload;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: P2PSpacingTokens.p2pOrderCompactCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.upload_file_outlined,
                color: AppColors.text2,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Bằng chứng thanh toán',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              if (step == _P2POrderUiStep.payment)
                _SmallButton(
                  key: P2POrderPage.proofKey,
                  icon: Icons.upload_outlined,
                  label: 'Tải lên',
                  color: AppModuleAccents.p2p,
                  onPressed: onUpload,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            step == _P2POrderUiStep.payment
                ? 'Tải ảnh chụp giao dịch ngân hàng trước khi xác nhận thanh toán'
                : 'Đang chờ merchant xác nhận',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.timeline});

  final List<P2POrderTimelineStepDraft> timeline;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: P2PSpacingTokens.p2pOrderCompactCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                color: AppColors.text2,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Tiến trình giao dịch',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          for (var index = 0; index < timeline.length; index++)
            _TimelineItem(
              item: timeline[index],
              isLast: index == timeline.length - 1,
            ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({required this.item, required this.isLast});

  final P2POrderTimelineStepDraft item;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = _stepColor(item.status);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Material(
              color: _stepBackground(item.status),
              shape: CircleBorder(side: BorderSide(color: color)),
              child: SizedBox(
                width: _p2pOrderTimelineNodeSize,
                height: _p2pOrderTimelineNodeSize,
                child: Center(
                  child: Icon(
                    _timelineIcon(item.iconKey),
                    color: color,
                    size: P2PSpacingTokens.p2pOrderTimelineIcon,
                  ),
                ),
              ),
            ),
            if (!isLast)
              SizedBox(
                width: _p2pOrderDividerHeight,
                height: _p2pOrderTimelineConnectorHeight,
                child: ColoredBox(color: color.withValues(alpha: .35)),
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Padding(
            padding: isLast
                ? AppSpacing.zeroInsets
                : P2PSpacingTokens.p2pOrderTimelineItemPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.label,
                        style: AppTextStyles.caption.copyWith(
                          color: item.status == P2POrderStepStatus.pending
                              ? AppColors.text3
                              : AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    Text(
                      item.time,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
                if (item.description.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    item.description,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PaymentWarning extends StatelessWidget {
  const _PaymentWarning({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return P2PNoticeCard(
      icon: Icons.warning_amber_rounded,
      message: message,
      iconColor: AppColors.sell,
      messageColor: AppColors.sell,
      borderColor: AppColors.sell20,
      variant: VitCardVariant.standard,
      padding: P2PSpacingTokens.p2pOrderCompactCardPadding,
      messageStyle: AppTextStyles.micro.copyWith(
        color: AppColors.sell,
        height: 1.4,
      ),
    );
  }
}

class _PrimaryActions extends StatelessWidget {
  const _PrimaryActions({
    required this.step,
    required this.onChat,
    required this.onPaid,
  });

  final _P2POrderUiStep step;
  final VoidCallback onChat;
  final VoidCallback onPaid;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitCtaButton(
            key: P2POrderPage.chatKey,
            onPressed: onChat,
            variant: VitCtaButtonVariant.ghost,
            leading: const Icon(Icons.chat_bubble_outline_rounded),
            child: const Text('Nhắn tin'),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: VitCtaButton(
            key: P2POrderPage.markPaidKey,
            onPressed: step == _P2POrderUiStep.payment ? onPaid : null,
            variant: VitCtaButtonVariant.success,
            leading: const Icon(Icons.check_circle_outline_rounded),
            child: Text(
              step == _P2POrderUiStep.payment
                  ? 'Đã thanh toán'
                  : 'Chờ xác nhận',
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.actions});

  final List<P2POrderQuickActionDraft> actions;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: P2PSpacingTokens.p2pOrderCompactCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'HÀNH ĐỘNG NHANH',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              for (var index = 0; index < actions.length; index++) ...[
                Expanded(child: _QuickActionButton(action: actions[index])),
                if (index < actions.length - 1)
                  const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
