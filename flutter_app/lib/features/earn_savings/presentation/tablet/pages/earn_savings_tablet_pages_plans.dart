part of 'earn_savings_tablet_pages.dart';

/// SC-330/331/332: Chi tiết sản phẩm · Rút vốn · Biên lai (bộ ba mẫu).
class SavingsProductSampleTabletPage extends ConsumerWidget {
  const SavingsProductSampleTabletPage({super.key});

  static const contentKey = Key('sc330_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      savingsProductDetailSnapshotProvider('sample'),
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-330',
        semanticLabel: 'Chi tiết sản phẩm tiết kiệm',
        title: 'Sản phẩm tiết kiệm',
        subtitle: 'Chi tiết · Điều khoản',
        contentKey: SavingsProductSampleTabletPage.contentKey,
        child: _esvError(
          'Không tải được sản phẩm',
          () => ref.invalidate(savingsProductDetailSnapshotProvider('sample')),
        ),
      ),
      data: (snapshot) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-330',
        semanticLabel: 'Chi tiết sản phẩm tiết kiệm',
        title: snapshot.title,
        subtitle: snapshot.product?.name ?? snapshot.productId,
        contentKey: SavingsProductSampleTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (snapshot.product != null)
              _esvSection(
                title: 'Thông tin sản phẩm',
                rows: _esvRows([
                  ('Tài sản', snapshot.product!.asset),
                  ('APY', snapshot.product!.apy),
                  ('Đã tham gia', snapshot.product!.totalSubscribed),
                  ('Hạn mức còn', snapshot.product!.remainingQuota),
                  (
                    'Tiến độ',
                    VitFormat.percent(
                      snapshot.product!.progress,
                      fractionDigits: 0,
                    ),
                  ),
                ]),
              )
            else
              _esvSection(
                title: 'Không tìm thấy',
                rows: [_esvBody(snapshot.notFoundMessage)],
              ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _esvSection(
              title: 'Điều khoản hợp đồng',
              rows: [_esvBody(snapshot.contractNotes)],
            ),
          ],
        ),
      ),
    );
  }
}

class SavingsRedeemTabletPage extends ConsumerWidget {
  const SavingsRedeemTabletPage({super.key});

  static const contentKey = Key('sc331_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(savingsRedeemSnapshotProvider('pos001'));

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-331',
        semanticLabel: 'Rút vốn tiết kiệm',
        title: 'Rút vốn',
        subtitle: 'Xem trước · Xác nhận',
        contentKey: SavingsRedeemTabletPage.contentKey,
        child: _esvError(
          'Không tải được thông tin rút vốn',
          () => ref.invalidate(savingsRedeemSnapshotProvider('pos001')),
        ),
      ),
      data: (snapshot) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-331',
        semanticLabel: 'Rút vốn tiết kiệm',
        title: snapshot.title,
        subtitle: 'Vị thế ${snapshot.positionId}',
        contentKey: SavingsRedeemTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (snapshot.position != null)
              _esvSection(
                title: 'Xem trước rút vốn',
                rows: _esvRows([
                  ('Sản phẩm', snapshot.position!.product),
                  ('Tài sản', snapshot.position!.asset),
                  ('Số tiền', snapshot.position!.amount),
                  ('Đã kiếm', snapshot.position!.earned),
                  ('APY', snapshot.position!.apy),
                  ('Bắt đầu', snapshot.position!.startDate),
                ]),
              )
            else
              _esvSection(
                title: 'Không tìm thấy',
                rows: [_esvBody(snapshot.notFoundMessage)],
              ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _esvSection(
              title: 'Điều khoản rút',
              rows: [_esvBody(snapshot.contractNotes)],
            ),
          ],
        ),
      ),
    );
  }
}

class SavingsReceiptTabletPage extends ConsumerWidget {
  const SavingsReceiptTabletPage({super.key});

  static const contentKey = Key('sc332_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(savingsReceiptSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-332',
        semanticLabel: 'Biên lai tiết kiệm',
        title: 'Biên lai',
        subtitle: 'Giao dịch gần nhất',
        contentKey: SavingsReceiptTabletPage.contentKey,
        child: _esvError(
          'Không tải được biên lai',
          () => ref.invalidate(savingsReceiptSnapshotProvider),
        ),
      ),
      data: (snapshot) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-332',
        semanticLabel: 'Biên lai tiết kiệm',
        title: snapshot.title,
        subtitle: 'Giao dịch đã xác nhận',
        contentKey: SavingsReceiptTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (snapshot.receipt != null)
              _esvSection(
                title: 'Chi tiết biên lai',
                rows: _esvRows([
                  ('Mã tham chiếu', snapshot.receipt!.referenceId),
                  ('Loại', snapshot.receipt!.type),
                  ('Sản phẩm', snapshot.receipt!.product),
                  ('Tài sản', snapshot.receipt!.asset),
                  ('Số tiền', snapshot.receipt!.amount),
                  ('Thời điểm', snapshot.receipt!.timestamp),
                ]),
              )
            else
              _esvSection(
                title: 'Trống',
                rows: [_esvBody(snapshot.emptyMessage)],
              ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _esvSection(
              title: 'Ghi chú hợp đồng',
              rows: [_esvBody(snapshot.contractNotes)],
            ),
          ],
        ),
      ),
    );
  }
}
