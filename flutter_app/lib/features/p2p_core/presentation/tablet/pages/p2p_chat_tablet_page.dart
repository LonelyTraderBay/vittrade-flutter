import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Bố cục tablet của Chat P2P (SC-217): luồng tin nhắn full-height bên trái,
/// cột phụ là cảnh báo giao dịch + e2e + quick replies.
class P2PChatTabletPage extends ConsumerStatefulWidget {
  const P2PChatTabletPage({super.key, required this.orderId});

  static const contentKey = Key('sc217_tablet_content');

  final String orderId;

  @override
  ConsumerState<P2PChatTabletPage> createState() => _P2PChatTabletPageState();
}

class _P2PChatTabletPageState extends ConsumerState<P2PChatTabletPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<P2PChatMessageDraft> _sentMessages = [];

  void _sendCurrentMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _sentMessages.add(
        P2PChatMessageDraft(
          id: 'local-${_sentMessages.length}',
          sender: P2PChatSender.me,
          text: text,
          time: 'Vừa gửi',
          isRead: false,
        ),
      );
    });
    _messageController.clear();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pChatProvider(widget.orderId));

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Chat giao dịch P2P',
      semanticIdentifier: 'SC-217',
      child: Column(
        children: [
          VitHeader(
            title: 'Chat giao dịch',
            subtitle: snapshotAsync.value?.orderNumber ?? widget.orderId,
            showBack: context.canPop(),
            onBack: context.canPop()
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.p2pOrder(widget.orderId),
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
          ),
          Expanded(
            child: snapshotAsync.when(
              loading: () => const Center(child: VitSkeletonList(rows: 6)),
              error: (error, stackTrace) => SingleChildScrollView(
                padding: const EdgeInsets.all(TabletSpacingTokens.x6),
                child: VitErrorState(
                  title: 'Không tải được chat',
                  message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () =>
                      ref.invalidate(p2pChatProvider(widget.orderId)),
                ),
              ),
              data: (snapshot) => Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 7,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: TabletSpacingTokens.x6,
                            vertical: TabletSpacingTokens.x2,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  snapshot.merchant,
                                  style: AppTextStyles.control.copyWith(
                                    fontWeight: AppTextStyles.bold,
                                    color: AppColors.text1,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: VitStatusPill(
                                    label: snapshot.encryptionPill,
                                    status: VitStatusPillStatus.success,
                                    size: VitStatusPillSize.sm,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            key: P2PChatTabletPage.contentKey,
                            padding: const EdgeInsets.symmetric(
                              horizontal: TabletSpacingTokens.x6,
                              vertical: TabletSpacingTokens.x3,
                            ),
                            child: Column(
                              children: [
                                for (final message in snapshot.messages)
                                  _MessageBubble(message: message),
                                for (final message in _sentMessages)
                                  _MessageBubble(message: message),
                              ],
                            ),
                          ),
                        ),
                        const Divider(
                          height: TabletSpacingTokens.dividerHairline,
                          thickness: TabletSpacingTokens.dividerHairline,
                          color: AppColors.divider,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: TabletSpacingTokens.x6,
                            vertical: TabletSpacingTokens.x3,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: VitInput(
                                  controller: _messageController,
                                  semanticLabel: 'Tin nhắn giao dịch',
                                  hintText: 'Nhập tin nhắn...',
                                ),
                              ),
                              const SizedBox(width: TabletSpacingTokens.x3),
                              VitCtaButton(
                                fullWidth: false,
                                onPressed: _sendCurrentMessage,
                                child: const Icon(Icons.send_rounded),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(
                    width: TabletSpacingTokens.dividerHairline,
                    thickness: TabletSpacingTokens.dividerHairline,
                    color: AppColors.divider,
                  ),
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(TabletSpacingTokens.x6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'An toàn giao dịch',
                            message:
                                'Chỉ gửi/nhận tiền qua kênh escrow. Không chia sẻ thông tin thanh toán ngoài hệ thống.',
                            contractId: 'p2p-chat-tablet',
                          ),
                          const SizedBox(height: TabletSpacingTokens.x3),
                          VitCard(
                            key: const ValueKey('p2p_chat_e2e'),
                            radius: VitCardRadius.tight,
                            padding: TabletSpacingTokens.cardPaddingCompact,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.e2eTitle,
                                  style: AppTextStyles.caption.copyWith(
                                    fontWeight: AppTextStyles.bold,
                                    color: AppColors.text1,
                                  ),
                                ),
                                const SizedBox(height: TabletSpacingTokens.x1),
                                Text(
                                  snapshot.e2eSubtitle,
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.text2,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: TabletSpacingTokens.x3),
                          Text(
                            'Trả lời nhanh',
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: AppTextStyles.bold,
                              color: AppColors.text1,
                            ),
                          ),
                          const SizedBox(height: TabletSpacingTokens.x2),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (final reply in snapshot.quickReplies)
                                  Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                      end: TabletSpacingTokens.x3,
                                    ),
                                    child: VitFilterChip(
                                      label: reply,
                                      onTap: () =>
                                          _messageController.text = reply,
                                      active: false,
                                      color: AppColors.primary,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final P2PChatMessageDraft message;

  @override
  Widget build(BuildContext context) {
    final isMe = message.sender == P2PChatSender.me;
    final isSystem = message.sender == P2PChatSender.system;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TabletSpacingTokens.x2),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          VitCard(
            constraints: const BoxConstraints(maxWidth: 640),
            padding: const EdgeInsets.all(TabletSpacingTokens.x3),
            radius: VitCardRadius.tight,
            background: ColoredBox(
              color: isMe
                  ? AppColors.primary.withValues(alpha: 0.14)
                  : AppColors.surface2,
            ),
            child: Text(
              message.text,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x1),
          Text(
            '${message.sender == P2PChatSender.me ? 'Bạn' : (isSystem ? 'Hệ thống' : 'Đối tác')} · ${message.time}',
            style: AppTextStyles.microTiny.copyWith(
              color: AppColors.text3,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}
