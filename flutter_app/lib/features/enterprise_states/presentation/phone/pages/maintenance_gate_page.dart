import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// AppRoutePaths là part của app_router — import vòng theo đúng khuôn các
// route group hiện có (hợp lệ Dart, không có chu trình giá trị const), xem
// route_error_page.dart.
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// GĐ4-F1 kill-switch: trang chặn toàn cục hiển thị khi
/// `AppConfig.maintenanceMode` bật (đọc qua `RuntimeConfigSource`, hôm nay
/// là dart-define — chỗ cắm remote-config server-side sau DEC-backend).
/// `root_routes.dart` redirect mọi route khác về đây trong lúc cờ còn bật,
/// và tự đưa người dùng ra khỏi trang khi cờ tắt — xem `redirect` trong
/// `createAppRouter`.
class MaintenanceGatePage extends StatelessWidget {
  const MaintenanceGatePage({super.key});

  static const contentKey = Key('sc417_maintenance_gate_content');
  static const retryButtonKey = Key('sc417_maintenance_gate_retry');

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Hệ thống đang bảo trì',
      semanticIdentifier: 'SC-417',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            const VitHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: VitPageContent(
                  rhythm: VitPageRhythm.standard,
                  children: [
                    _GateCard(
                      key: contentKey,
                      icon: Icons.engineering_outlined,
                      title: 'Hệ thống đang bảo trì',
                      message:
                          'VitTrade đang nâng cấp hạ tầng. Vui lòng quay lại '
                          'sau ít phút.',
                      buttonKey: retryButtonKey,
                      buttonLabel: 'Thử lại',
                      // Redirect toàn cục sẽ giữ người dùng lại ở trang này
                      // nếu maintenanceMode vẫn còn bật.
                      onPressed: () => context.go(AppRoutePaths.home),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GateCard extends StatelessWidget {
  const _GateCard({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.buttonKey,
    required this.buttonLabel,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String message;
  final Key buttonKey;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.cardRadius,
          side: BorderSide(color: AppColors.divider),
        ),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.all(AppSpacing.x5),
        child: Column(
          children: [
            Icon(icon, color: AppColors.warn, size: AppSpacing.iconLg),
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.baseMedium.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            VitCtaButton(
              key: buttonKey,
              onPressed: onPressed,
              child: Text(buttonLabel),
            ),
          ],
        ),
      ),
    );
  }
}
