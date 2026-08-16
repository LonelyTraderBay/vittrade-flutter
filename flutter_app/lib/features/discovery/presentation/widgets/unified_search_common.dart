part of '../phone/pages/unified_search_page.dart';

List<Widget> _unifiedSearchPageChildren({
  required UnifiedSearchSnapshot snapshot,
  required ValueChanged<String> onQuerySelected,
  required VoidCallback onRetry,
}) {
  return switch (snapshot.currentState) {
    DiscoveryScreenState.loading => [
      const VitSkeletonList(key: UnifiedSearchPage.loadingKey, rows: 4),
    ],
    DiscoveryScreenState.error => [
      VitErrorState(
        key: UnifiedSearchPage.errorKey,
        title: 'Không tải được dữ liệu khám phá',
        message: snapshot.staleMessage,
        actionLabel: 'Thử lại',
        onAction: onRetry,
      ),
    ],
    DiscoveryScreenState.empty when !snapshot.hasCachedContent => [
      const VitEmptyState(
        icon: Icons.explore_rounded,
        title: 'Chưa có gợi ý khám phá',
        message: 'Hãy thử lại sau hoặc tìm kiếm trực tiếp.',
      ),
    ],
    _ when snapshot.hasQuery => [_ResultsState(snapshot: snapshot)],
    _ => [_NoQueryState(snapshot: snapshot, onQuerySelected: onQuerySelected)],
  };
}

class _BoundaryDisclosure extends StatelessWidget {
  const _BoundaryDisclosure({required this.notes});

  final String notes;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: UnifiedSearchPage.disclosureKey,
      variant: VitCardVariant.inner,
      padding: LaunchpadSpacingTokens.discoveryCardPadding,
      child: Text(
        'Lưu ý: Prediction Markets sử dụng USDT thật. Arena Challenges chỉ dùng Arena Points (không liên quan ví). Đây là trang khám phá, không phải trang giao dịch.\n$notes',
        textAlign: TextAlign.center,
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      ),
    );
  }
}

IconData _iconForKey(String key) {
  return switch (key) {
    'coin' => Icons.currency_exchange_rounded,
    'price' => Icons.swap_vert_rounded,
    'bank' => Icons.account_balance_rounded,
    'arena' => Icons.bolt_rounded,
    'fire' => Icons.local_fire_department_rounded,
    'news' => Icons.article_rounded,
    'prediction' => Icons.track_changes_rounded,
    'topic' => Icons.auto_awesome_rounded,
    _ => Icons.search_rounded,
  };
}

Color _accentForKey(String key) {
  return switch (key) {
    'bank' || 'topic' => AppColors.buy,
    'arena' || 'fire' => AppModuleAccents.arena,
    'prediction' || 'coin' || 'price' => AppModuleAccents.predictions,
    'news' => AppColors.text2,
    _ => AppColors.primary,
  };
}

Color _accentForModule(DiscoveryModuleKind kind) {
  return switch (kind) {
    DiscoveryModuleKind.prediction => AppModuleAccents.predictions,
    DiscoveryModuleKind.arena => AppModuleAccents.arena,
    DiscoveryModuleKind.topic => AppColors.buy,
  };
}
