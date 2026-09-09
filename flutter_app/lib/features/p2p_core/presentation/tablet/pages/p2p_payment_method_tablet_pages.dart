import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/p2p_formatters.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_section_frame.dart';
part 'p2p_payment_method_tablet_pages_sections.dart';

Widget _paymentError(String title, VoidCallback onRetry) {
  return VitErrorState(
    title: title,
    message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
    actionLabel: 'Thử lại',
    onAction: onRetry,
  );
}

/// SC-237: Danh sách phương thức thanh toán đã lưu.
class P2PPaymentMethodsTabletPage extends ConsumerWidget {
  const P2PPaymentMethodsTabletPage({super.key});

  static const contentKey = Key('sc237_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pPaymentMethodsProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-237',
        semanticLabel: 'Phương thức thanh toán P2P',
        title: 'Phương thức thanh toán',
        subtitle: 'Ngân hàng · Ví điện tử',
        contentKey: P2PPaymentMethodsTabletPage.contentKey,
        children: [
          _paymentError(
            'Không tải được phương thức thanh toán',
            () => ref.invalidate(p2pPaymentMethodsProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-237',
        semanticLabel: 'Phương thức thanh toán P2P',
        title: 'Phương thức thanh toán',
        subtitle: 'Ngân hàng · Ví điện tử',
        contentKey: P2PPaymentMethodsTabletPage.contentKey,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  snapshot.methods.isEmpty
                      ? snapshot.emptyTitle
                      : '${snapshot.methods.length} phương thức đã lưu',
                  style: AppTextStyles.control.copyWith(
                    fontWeight: AppTextStyles.bold,
                    color: AppColors.text1,
                  ),
                ),
              ),
              VitCtaButton(
                fullWidth: false,
                onPressed: () => context.push(snapshot.addBankRoute),
                child: const Text('Thêm ngân hàng'),
              ),
              const SizedBox(width: TabletSpacingTokens.x3),
              VitCtaButton(
                fullWidth: false,
                variant: VitCtaButtonVariant.secondary,
                onPressed: () => context.push(snapshot.addEwalletRoute),
                child: const Text('Thêm ví điện tử'),
              ),
            ],
          ),

          if (snapshot.methods.isEmpty)
            const VitEmptyState(
              icon: Icons.credit_card_off_outlined,
              title: 'Chưa có phương thức',
              message: 'Thêm ngân hàng hoặc ví điện tử để nhận thanh toán.',
            )
          else
            VitCard(
              radius: VitCardRadius.tight,
              padding: TabletSpacingTokens.zeroInsets,
              clip: true,
              child: Column(
                children: [
                  for (var i = 0; i < snapshot.methods.length; i++) ...[
                    Padding(
                      padding: TabletSpacingTokens.tableCellPaddingTall,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.methods[i].name,
                                  style: AppTextStyles.caption.copyWith(
                                    fontWeight: AppTextStyles.bold,
                                    color: AppColors.text1,
                                  ),
                                ),
                                Text(
                                  snapshot.methods[i].accountNumber,
                                  style: AppTextStyles.micro.copyWith(
                                    color: AppColors.text3,
                                    fontFeatures: AppTextStyles.tabularFigures,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              snapshot.methods[i].accountName,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (snapshot.methods[i].isDefault)
                            const VitStatusPill(
                              label: 'Mặc định',
                              status: VitStatusPillStatus.info,
                              size: VitStatusPillSize.sm,
                            )
                          else if (snapshot.methods[i].isVerified)
                            const VitStatusPill(
                              label: 'Đã xác minh',
                              status: VitStatusPillStatus.success,
                              size: VitStatusPillSize.sm,
                            ),
                        ],
                      ),
                    ),
                    if (i < snapshot.methods.length - 1)
                      const Divider(
                        height: TabletSpacingTokens.dividerHairline,
                        thickness: TabletSpacingTokens.dividerHairline,
                        color: AppColors.divider,
                      ),
                  ],
                ],
              ),
            ),

          const VitHighRiskStatePanel(
            state: VitHighRiskUiState.riskReview,
            title: 'Thay đổi phương thức thanh toán',
            message:
                'Thêm/xóa phương thức ảnh hưởng đến lệnh P2P đang chạy. Xóa luôn yêu cầu xác nhận.',
            contractId: 'p2p-payment-methods-tablet',
          ),

          Text(
            snapshot.securityNote,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

/// SC-232: Thêm phương thức thanh toán.
class P2PPaymentMethodAddTabletPage extends ConsumerStatefulWidget {
  const P2PPaymentMethodAddTabletPage({super.key});

  static const contentKey = Key('sc232_tablet_content');
  static const submitKey = Key('sc232_tablet_submit');

  @override
  ConsumerState<P2PPaymentMethodAddTabletPage> createState() =>
      _P2PPaymentMethodAddTabletPageState();
}

class _P2PPaymentMethodAddTabletPageState
    extends ConsumerState<P2PPaymentMethodAddTabletPage> {
  final TextEditingController _ownerController = TextEditingController();
  final TextEditingController _bankAccountController = TextEditingController();
  final TextEditingController _ewalletAccountController =
      TextEditingController();
  String? _selectedBank;
  String? _selectedEwallet;

  @override
  void dispose() {
    _ownerController.dispose();
    _bankAccountController.dispose();
    _ewalletAccountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final snapshotAsync = ref.watch(p2pPaymentMethodAddProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-232',
        semanticLabel: 'Thêm phương thức thanh toán P2P',
        title: 'Thêm phương thức',
        subtitle: 'Ngân hàng · Ví điện tử',
        contentKey: P2PPaymentMethodAddTabletPage.contentKey,
        children: [
          _paymentError(
            'Không tải được biểu mẫu',
            () => ref.invalidate(p2pPaymentMethodAddProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-232',
        semanticLabel: 'Thêm phương thức thanh toán P2P',
        title: 'Thêm phương thức thanh toán',
        subtitle: 'Thông tin chủ thẻ · Xác minh',
        contentKey: P2PPaymentMethodAddTabletPage.contentKey,
        children: [
          _FormCard(
            title: 'Ngân hàng',
            child: Wrap(
              spacing: TabletSpacingTokens.x3,
              runSpacing: TabletSpacingTokens.x2,
              children: [
                for (final bank in snapshot.bankOptions)
                  VitFilterChip(
                    label: bank,
                    onTap: () => setState(() => _selectedBank = bank),
                    active: bank == _selectedBank,
                    color: AppColors.primary,
                  ),
              ],
            ),
          ),

          _FormCard(
            title: 'Ví điện tử',
            child: Wrap(
              spacing: TabletSpacingTokens.x3,
              runSpacing: TabletSpacingTokens.x2,
              children: [
                for (final ewallet in snapshot.ewalletOptions)
                  VitFilterChip(
                    label: ewallet,
                    onTap: () => setState(() => _selectedEwallet = ewallet),
                    active: ewallet == _selectedEwallet,
                    color: AppColors.primary,
                  ),
              ],
            ),
          ),

          _FormCard(
            title: 'Thông tin tài khoản',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                VitInput(
                  controller: _ownerController,
                  semanticLabel: 'Tên chủ tài khoản',
                  hintText: snapshot.ownerNameHint,
                ),
                const SizedBox(height: TabletSpacingTokens.x2),
                VitInput(
                  controller: _bankAccountController,
                  semanticLabel: 'Số tài khoản ngân hàng',
                  hintText: snapshot.defaultBankAccountHint,
                ),
                const SizedBox(height: TabletSpacingTokens.x2),
                VitInput(
                  controller: _ewalletAccountController,
                  semanticLabel: 'Tài khoản ví điện tử',
                  hintText: snapshot.defaultEwalletAccountHint,
                ),
              ],
            ),
          ),

          const VitHighRiskStatePanel(
            state: VitHighRiskUiState.riskReview,
            title: 'Xem trước khi lưu',
            message:
                'Tên chủ tài khoản phải trùng với danh tính đã xác minh. Phương thức mới vào thời gian chờ trước khi dùng.',
            contractId: 'p2p-payment-add-tablet',
          ),

          Text(
            snapshot.securityNote,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.3,
            ),
          ),

          const SizedBox(height: TabletSpacingTokens.x4),

          VitCtaButton(
            key: P2PPaymentMethodAddTabletPage.submitKey,
            onPressed: () => context.push(snapshot.saveRoute),
            child: const Text('Lưu phương thức'),
          ),
        ],
      ),
    );
  }
}

/// SC-233: Xác minh phương thức thanh toán.
class P2PPaymentMethodVerificationTabletPage extends ConsumerWidget {
  const P2PPaymentMethodVerificationTabletPage({
    super.key,
    required this.methodId,
  });

  static const contentKey = Key('sc233_tablet_content');

  final String methodId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      p2pPaymentMethodVerificationProvider(methodId),
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-233',
        semanticLabel: 'Xác minh phương thức P2P',
        title: 'Xác minh phương thức',
        subtitle: methodId,
        contentKey: P2PPaymentMethodVerificationTabletPage.contentKey,
        children: [
          _paymentError(
            'Không tải được xác minh',
            () =>
                ref.invalidate(p2pPaymentMethodVerificationProvider(methodId)),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-233',
        semanticLabel: 'Xác minh phương thức P2P',
        title: 'Xác minh phương thức',
        subtitle: 'Chọn kênh xác minh',
        contentKey: P2PPaymentMethodVerificationTabletPage.contentKey,
        children: [
          for (final method in snapshot.methods)
            Padding(
              padding: const EdgeInsets.only(bottom: TabletSpacingTokens.x3),
              child: VitCard(
                radius: VitCardRadius.tight,
                padding: TabletSpacingTokens.cardPaddingCompact,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            method.label,
                            style: AppTextStyles.control.copyWith(
                              fontWeight: AppTextStyles.bold,
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        if (method.recommended)
                          const VitStatusPill(
                            label: 'Đề xuất',
                            status: VitStatusPillStatus.success,
                            size: VitStatusPillSize.sm,
                          ),
                      ],
                    ),
                    const SizedBox(height: TabletSpacingTokens.x1),
                    Text(
                      method.description,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: TabletSpacingTokens.x1),
                    Text(
                      'Thời gian: ${method.duration}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          _sectionCard(
            title: 'Micro-deposit',
            rows: [
              ..._bulletList(
                snapshot.microDepositSteps,
                Icons.account_balance_wallet_outlined,
                AppColors.primary,
              ),
            ],
          ),

          const VitHighRiskStatePanel(
            state: VitHighRiskUiState.riskReview,
            title: 'Xem lại xác minh',
            message:
                'Micro-deposit chỉ đọc được trong vài ngày. Kiểm tra sao kê trước khi nhập số tiền xác minh.',
            contractId: 'p2p-payment-verify-tablet',
          ),

          Text(
            snapshot.warningNote,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.3,
            ),
          ),

          const SizedBox(height: TabletSpacingTokens.x4),

          VitCtaButton(
            onPressed: () => context.push(snapshot.saveRoute),
            child: const Text('Gửi xác minh'),
          ),
        ],
      ),
    );
  }
}

Widget _sectionCard({required String title, required List<Widget> rows}) {
  return VitCard(
    radius: VitCardRadius.tight,
    padding: TabletSpacingTokens.cardPaddingCompact,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.control.copyWith(
            fontWeight: AppTextStyles.bold,
            color: AppColors.text1,
          ),
        ),
        const SizedBox(height: TabletSpacingTokens.x2),
        ...rows,
      ],
    ),
  );
}

List<Widget> _bulletList(List<String> notes, IconData icon, Color color) {
  return [
    for (final note in notes)
      Padding(
        padding: TabletSpacingTokens.tableCellPaddingV,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.zero,
              child: Icon(icon, size: TabletSpacingTokens.iconSm, color: color),
            ),
            const SizedBox(width: TabletSpacingTokens.x2),
            Expanded(
              child: Text(
                note,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
  ];
}
