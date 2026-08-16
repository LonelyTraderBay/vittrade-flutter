import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/referral_controller_providers.dart';

class ReferralFriendDetailPage extends ConsumerWidget {
  const ReferralFriendDetailPage({super.key, required this.friendId});

  static const contentKey = Key('sc289_referral_friend_detail_content');
  static const emptyKey = Key('sc289_referral_friend_detail_empty');
  static const listButtonKey = Key('sc289_back_to_friend_list');

  final String friendId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(
      referralFriendDetailSnapshotProvider(friendId),
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Chi tiết bạn bè',
      semanticIdentifier: 'SC-289',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Chi tiết bạn bè',
            subtitle: 'Bạn bè · Referral',
            showBack: true,
            onBack: () => context.go(
              detailAsync.value?.backRoute ?? AppRoutePaths.referralHistory,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                key: ReferralFriendDetailPage.contentKey,
                child: VitPageContent(
                  rhythm: VitPageRhythm.standard,
                  padding: VitContentPadding.compact,
                  children: detailAsync.when(
                    loading: () => const [VitSkeletonList()],
                    error: (error, stackTrace) => [
                      VitErrorState(
                        title: 'Không tải được chi tiết bạn bè',
                        message: 'Thử lại sau hoặc quay lại danh sách.',
                        actionLabel: 'Thử lại',
                        onAction: () => ref.invalidate(
                          referralFriendDetailSnapshotProvider(friendId),
                        ),
                      ),
                    ],
                    data: (snapshot) => [
                      VitEmptyState(
                        key: ReferralFriendDetailPage.emptyKey,
                        icon: Icons.person_search_rounded,
                        title: snapshot.emptyTitle,
                        message: snapshot.emptyMessage,
                        actionLabel: 'Quay lại danh sách',
                        actionKey: ReferralFriendDetailPage.listButtonKey,
                        onAction: () => context.go(snapshot.listRoute),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
