part of '../../phone/pages/payment/p2p_payment_methods_page.dart';

class _ComplianceLinksRow extends StatelessWidget {
  const _ComplianceLinksRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitCtaButton(
            variant: VitCtaButtonVariant.secondary,
            onPressed: () => context.go(AppRoutePaths.p2pPaymentMethodHistory),
            leading: const Icon(Icons.history_rounded, size: AppSpacing.iconSm),
            child: const Text('Lịch sử'),
          ),
        ),
        const SizedBox(width: AppSpacing.rowGap),
        Expanded(
          child: VitCtaButton(
            variant: VitCtaButtonVariant.secondary,
            onPressed: () =>
                context.go(AppRoutePaths.p2pPaymentMethodCoolingPeriod),
            leading: const Icon(
              Icons.schedule_rounded,
              size: AppSpacing.iconSm,
            ),
            child: const Text('Thời gian chờ'),
          ),
        ),
      ],
    );
  }
}

class _AddMethodRow extends StatelessWidget {
  const _AddMethodRow({required this.snapshot});

  final P2PPaymentMethodsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _AddMethodButton(
            key: P2PPaymentMethodsPage.addBankKey,
            icon: Icons.credit_card_rounded,
            label: 'Thêm ngân hàng',
            color: AppModuleAccents.p2p,
            onTap: () {
              unawaited(HapticFeedback.selectionClick());
              context.go(snapshot.addBankRoute);
            },
          ),
        ),
        const SizedBox(width: AppSpacing.rowGap),
        Expanded(
          child: _AddMethodButton(
            key: P2PPaymentMethodsPage.addEwalletKey,
            icon: Icons.phone_android_rounded,
            label: 'Thêm ví điện tử',
            color: AppColors.accent,
            onTap: () {
              unawaited(HapticFeedback.selectionClick());
              context.go(snapshot.addEwalletRoute);
            },
          ),
        ),
      ],
    );
  }
}

class _AddMethodButton extends StatelessWidget {
  const _AddMethodButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: label,
      selected: true,
      onTap: onTap,
      fullWidth: true,
      padding: P2PSpacingTokens.p2pPaymentMethodsListButtonPadding,
      accentColor: color,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.add_rounded),
          const SizedBox(width: AppSpacing.x1),
          Icon(icon),
        ],
      ),
      semanticLabel: label,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.text2, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({
    required this.method,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  final P2PPaymentListMethodDraft method;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  bool get _isBank => method.type == P2PPaymentListMethodType.bank;
  Color get _tone => _isBank ? AppModuleAccents.p2p : AppColors.accent;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      key: P2PPaymentMethodsPage.methodKey(method.id),
      radius: VitCardRadius.standard,
      borderColor: method.isDefault ? AppColors.warningBorder : null,
      constraints: const BoxConstraints(
        minHeight: P2PSpacingTokens.p2pPaymentMethodsListCardMinExtent,
      ),
      padding: P2PSpacingTokens.p2pPaymentMethodsListCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MethodIcon(isBank: _isBank, tone: _tone),
              const SizedBox(width: AppSpacing.rowGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x1,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          method.name,
                          style: AppTextStyles.baseMedium.copyWith(
                            color: AppColors.text1,
                          ),
                        ),
                        if (method.isVerified)
                          const Icon(
                            Icons.shield_outlined,
                            color: AppColors.buy,
                            size: P2PSpacingTokens.p2pPaymentVerifiedIcon,
                          ),
                        if (method.isDefault)
                          const VitStatusPill(
                            label: 'Mặc định',
                            status: VitStatusPillStatus.orange,
                            size: VitStatusPillSize.sm,
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Text(
                      maskAccountNumber(method.accountNumber),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      method.accountName,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Row(
                children: [
                  VitIconButton(
                    key: P2PPaymentMethodsPage.editKey(method.id),
                    icon: Icons.edit_rounded,
                    tooltip: 'Sửa phương thức',
                    size: VitIconButtonSize.sm,
                    variant: VitIconButtonVariant.ghost,
                    onPressed: onEdit,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  VitIconButton(
                    key: P2PPaymentMethodsPage.deleteKey(method.id),
                    icon: Icons.delete_outline_rounded,
                    tooltip: 'Xóa phương thức',
                    size: VitIconButtonSize.sm,
                    variant: VitIconButtonVariant.danger,
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
          if (!method.isDefault) ...[
            const SizedBox(height: AppSpacing.rowGap),
            _SetDefaultButton(methodId: method.id, onTap: onSetDefault),
          ],
          if (!method.isVerified) ...[
            const SizedBox(height: AppSpacing.rowGap),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.warn,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    'Chưa xác minh — Cần xác minh để sử dụng trên P2P',
                    style: AppTextStyles.micro.copyWith(color: AppColors.warn),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _MethodIcon extends StatelessWidget {
  const _MethodIcon({required this.isBank, required this.tone});

  final bool isBank;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: tone == AppColors.accent ? AppColors.accent12 : AppColors.warn10,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      child: Padding(
        padding: const EdgeInsetsDirectional.all(AppSpacing.x2),
        child: Icon(
          isBank ? Icons.credit_card_rounded : Icons.phone_android_rounded,
          color: tone,
          size: AppSpacing.iconSm,
        ),
      ),
    );
  }
}

class _SetDefaultButton extends StatelessWidget {
  const _SetDefaultButton({required this.methodId, required this.onTap});

  final String methodId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: P2PPaymentMethodsPage.defaultKey(methodId),
      variant: VitCtaButtonVariant.secondary,
      onPressed: onTap,
      leading: const Icon(Icons.star_border_rounded, size: AppSpacing.iconSm),
      child: const Text('Đặt làm mặc định'),
    );
  }
}

class _SecurityNotice extends StatelessWidget {
  const _SecurityNotice({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.standard,
      borderColor: AppColors.warningBorder,
      padding: P2PSpacingTokens.p2pPaymentMethodsListCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppModuleAccents.p2p,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppModuleAccents.p2p,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
