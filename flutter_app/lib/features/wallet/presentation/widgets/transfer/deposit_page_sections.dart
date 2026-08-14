part of '../../phone/pages/deposit_page.dart';

class _NetworkSelector extends StatelessWidget {
  const _NetworkSelector({
    required this.asset,
    required this.selected,
    required this.onTap,
  });

  final String asset;
  final WalletDepositNetwork selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // card-tile: allow-start — fixed surface, not horizontal strip tile
        VitCard(
          key: DepositPage.networkSelectorKey,
          variant: VitCardVariant.inner,
          radius: VitCardRadius.standard,
          height: _depositSelectorHeight,
          density: VitDensity.tool,
          borderColor: _depositPrimary,
          onTap: onTap,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selected.name,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: _depositTinyGap),
                    Text(
                      'Phí: ${selected.fee} · Nạp tối thiểu: ${_formatDeposit(selected.minDeposit)} $asset',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        fontWeight: AppTextStyles.medium,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.text2,
                size: AppSpacing.iconMd,
              ),
            ],
          ),
        ),
        const SizedBox(height: _depositTinyGap),
        Row(
          children: [
            const SizedBox(
              width: _depositStatusDotSize,
              height: _depositStatusDotSize,
              child: ClipOval(child: ColoredBox(color: _depositGreen)),
            ),
            const SizedBox(width: _depositTinyGap),
            Expanded(
              child: Text(
                'Mạng hoạt động tốt  ·  ${selected.arrivalTime}  ·  ${selected.confirmations} xác nhận',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.asset, required this.network});

  final String asset;
  final WalletDepositNetwork network;

  @override
  Widget build(BuildContext context) {
    final warningItems = [
      'Chỉ gửi $asset qua mạng ${network.name}',
      'Gửi sai mạng sẽ mất tiền vĩnh viễn, không thể khôi phục',
      'Nạp tối thiểu: ${_formatDeposit(network.minDeposit)} $asset',
      'Cần ${network.confirmations} xác nhận blockchain',
    ];

    return VitCard(
      constraints: const BoxConstraints(minHeight: 0),
      density: VitDensity.compact,
      borderColor: _depositRed.withValues(alpha: .38),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _depositRed,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: _depositInlineGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quan trọng — Đọc trước khi nạp',
                  style: AppTextStyles.body.copyWith(
                    color: _depositRed,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: _depositTinyGap),
                for (final item in warningItems) ...[
                  Text(
                    '• $item',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.sell,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                  const SizedBox(height: _depositTinyGap),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QrAddressCard extends StatelessWidget {
  const _QrAddressCard({
    required this.asset,
    required this.network,
    required this.copied,
    required this.onCopy,
  });

  final String asset;
  final WalletDepositNetwork network;
  final bool copied;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        children: [
          _QrCode(address: network.address),
          const SizedBox(height: _depositGap),
          Text(
            'Địa chỉ $asset (${network.name.split(' ').first})',
            style: AppTextStyles.micro.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: _depositTinyGap),
          Text(
            _maskDepositAddress(network.address),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: _depositGap),
          Tooltip(
            message: copied
                ? 'Đã sao chép địa chỉ nạp'
                : 'Sao chép địa chỉ nạp',
            child: Semantics(
              button: true,
              liveRegion: copied,
              label: copied
                  ? 'Đã sao chép địa chỉ nạp'
                  : 'Sao chép địa chỉ nạp',
              child: VitCtaButton(
                key: DepositPage.copyAddressKey,
                onPressed: onCopy,
                height: _depositCopyButtonHeight,
                density: VitDensity.compact,
                variant: copied
                    ? VitCtaButtonVariant.success
                    : VitCtaButtonVariant.primary,
                leading: Icon(
                  copied ? Icons.check_circle_outline : Icons.copy_rounded,
                  size: AppSpacing.iconSm,
                ),
                child: Text(
                  copied ? 'Đã sao chép địa chỉ!' : 'Sao chép địa chỉ',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QrCode extends StatelessWidget {
  const _QrCode({required this.address});

  final String address;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _depositQrSize,
      height: _depositQrSize,
      child: Material(
        color: AppColors.onAccent,
        elevation: 2,
        shadowColor: AppColors.dynamicIslandBg.withValues(alpha: .32),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.lgRadius),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: VitDensity.compact.cardPadding,
          child: CustomPaint(painter: _QrPainter(address)),
        ),
      ),
    );
  }
}

class _QrPainter extends CustomPainter {
  const _QrPainter(this.address);

  final String address;

  @override
  void paint(Canvas canvas, Size size) {
    final seed = address.codeUnits.fold<int>(0, (sum, code) => sum + code);
    final cell = size.width / 21;
    final fill = Paint()..color = AppColors.qrDark;
    final stroke = Paint()
      ..color = AppColors.qrDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(.5, cell * .08);

    for (var row = 0; row < 21; row++) {
      for (var col = 0; col < 21; col++) {
        final finder =
            (row < 7 && col < 7) ||
            (row < 7 && col > 13) ||
            (row > 13 && col < 7);
        final filled = finder || ((seed * (row + 1) * (col + 1)) % 7) < 3;
        if (!filled) continue;
        canvas.drawRect(
          Rect.fromLTWH(col * cell, row * cell, cell, cell),
          fill,
        );
      }
    }

    void finder(double x, double y) {
      canvas.drawRect(Rect.fromLTWH(x, y, cell * 7, cell * 7), stroke);
      canvas.drawRect(
        Rect.fromLTWH(x + cell, y + cell, cell * 5, cell * 5),
        stroke,
      );
      canvas.drawRect(
        Rect.fromLTWH(x + cell * 2, y + cell * 2, cell * 3, cell * 3),
        fill,
      );
    }

    finder(0, 0);
    finder(cell * 14, 0);
    finder(0, cell * 14);
  }

  @override
  bool shouldRepaint(covariant _QrPainter oldDelegate) =>
      oldDelegate.address != address;
}
