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
part 'p2p_settings_tablet_pages_extra.dart';

Widget _stSection({required String title, required List<Widget> rows}) {
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

List<Widget> _stRows(List<(String, String)> pairs) {
  return [
    for (final (label, value) in pairs)
      Padding(
        padding: TabletSpacingTokens.tableCellPaddingV,
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
          ],
        ),
      ),
  ];
}

/// SC-230: Cấp độ giao dịch P2P.
class P2PTradingLevelTabletPage extends ConsumerWidget {
  const P2PTradingLevelTabletPage({super.key});

  static const contentKey = Key('sc230_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pTradingLevelProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-230',
        semanticLabel: 'Cấp độ giao dịch P2P',
        title: 'Cấp độ giao dịch',
        subtitle: 'Tiến độ · Hạn mức',
        contentKey: P2PTradingLevelTabletPage.contentKey,
        children: [
          VitErrorState(
            title: 'Không tải được cấp độ giao dịch',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(p2pTradingLevelProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-230',
        semanticLabel: 'Cấp độ giao dịch P2P',
        title: 'Cấp độ giao dịch',
        subtitle: 'Level ${snapshot.userLevel.currentLevel}',
        contentKey: P2PTradingLevelTabletPage.contentKey,
        children: [
          _stSection(
            title: 'Tiến độ của bạn',
            rows: _stRows([
              ('Đơn hoàn tất', '${snapshot.userLevel.completedOrders}'),
              (
                'Khối lượng tích lũy',
                formatP2PVnd(snapshot.userLevel.accumulatedVolume),
              ),
              (
                'Hạn mức ngày đã dùng',
                formatP2PVnd(snapshot.userLevel.dailyUsed),
              ),
            ]),
          ),

          for (final level in snapshot.levels)
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
                            '${level.name} · ${level.nameVi}',
                            style: AppTextStyles.control.copyWith(
                              fontWeight: AppTextStyles.bold,
                              color: level.id == snapshot.userLevel.currentLevel
                                  ? AppColors.primary
                                  : AppColors.text1,
                            ),
                          ),
                        ),
                        Text(
                          'Phí ${level.fee.toStringAsFixed(2)}%',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TabletSpacingTokens.x2),
                    ..._stRows([
                      ('Hạn mức ngày', formatP2PVnd(level.dailyLimit)),
                      ('Hạn mức mỗi lệnh', formatP2PVnd(level.perOrderLimit)),
                    ]),
                  ],
                ),
              ),
            ),

          VitCtaButton(
            onPressed: () => context.push(snapshot.upgradeRoute),
            child: const Text('Nâng cấp hạng'),
          ),
        ],
      ),
    );
  }
}

/// SC-279: Cài đặt P2P.
class P2PSettingsTabletPage extends ConsumerWidget {
  const P2PSettingsTabletPage({super.key});

  static const contentKey = Key('sc279_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pSettingsProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-279',
        semanticLabel: 'Cài đặt P2P',
        title: 'Cài đặt P2P',
        subtitle: 'Giao dịch · Riêng tư',
        contentKey: P2PSettingsTabletPage.contentKey,
        children: [
          VitErrorState(
            title: 'Không tải được cài đặt',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(p2pSettingsProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-279',
        semanticLabel: 'Cài đặt P2P',
        title: snapshot.title,
        subtitle: snapshot.subtitle,
        contentKey: P2PSettingsTabletPage.contentKey,
        children: [
          _stSection(
            title: 'Mặc định giao dịch',
            rows: _stRows([
              ('Tài sản', snapshot.defaultAsset),
              ('Tiền tệ', snapshot.defaultCurrency),
              ('Cửa sổ thanh toán', snapshot.defaultPaymentWindow),
            ]),
          ),

          _stSection(
            title: 'Riêng tư',
            rows: [
              for (final toggle in snapshot.privacyToggles)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          toggle.label,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.toggle_off_outlined,
                        size: TabletSpacingTokens.iconMd,
                        color: AppColors.text3,
                      ),
                    ],
                  ),
                ),
            ],
          ),

          _stSection(
            title: 'Liên kết nhanh',
            rows: [
              Padding(
                padding: TabletSpacingTokens.tableCellPaddingV,
                child: InkWell(
                  onTap: () => context.push(snapshot.notificationsRoute),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Thông báo',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: TabletSpacingTokens.iconMd,
                        color: AppColors.text3,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Text(
            snapshot.contractNotes,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}
