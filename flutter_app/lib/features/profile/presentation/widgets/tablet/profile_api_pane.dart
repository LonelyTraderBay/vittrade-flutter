import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/profile_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/profile_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_pane_navigation.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_pane_scaffold.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part 'profile_api_pane_sections.dart';

/// Tablet API-management detail pane (SC-163) for the Profile master-detail
/// shell — a public port of the phone `ApiManagementPage`'s content
/// (risk-review panel, per-key cards with active toggle / masked key + secret
/// reveal & copy / permission pills / usage, regenerate stub, delete confirm,
/// docs card) into [ProfilePaneScaffold], per R2: the phone page and its
/// `part` family stay untouched. Same [profileApiManagementSnapshotProvider]
/// data as the phone page; the header "+" action pushes the create-key pane
/// (SC-162) inside the shell.
class ProfileApiPane extends ConsumerStatefulWidget {
  const ProfileApiPane({super.key});

  @override
  ConsumerState<ProfileApiPane> createState() => _ProfileApiPaneState();
}

class _ProfileApiPaneState extends ConsumerState<ProfileApiPane> {
  bool _initialized = false;
  List<ProfileApiKey> _keys = const [];
  String? _showSecretId;
  String? _copiedId;

  Future<void> _refresh() async {
    ref.invalidate(profileApiManagementSnapshotProvider);
    await ref.read(profileApiManagementSnapshotProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(profileApiManagementSnapshotProvider);

    return ProfilePaneScaffold(
      title: 'Quản lý API',
      subtitle: 'Khóa API · quyền · hoạt động',
      onBack: () => context.go(AppRoutePaths.profile),
      onRefresh: _refresh,
      headerActions: [
        VitHeaderActionItem(
          key: ProfileTabletKeys.apiCreate,
          type: VitHeaderActionType.add,
          tooltip: 'Tạo API key',
          onPressed: _createApiKey,
        ),
      ],
      scrollKey: ProfileTabletKeys.apiPane,
      children: snapshotAsync.when(
        loading: () => const [VitSkeletonList(rows: 5)],
        error: (error, stackTrace) => [
          VitErrorState(
            key: ProfileTabletKeys.apiPaneError,
            title: 'Không tải được dữ liệu',
            message: 'Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: _refresh,
          ),
        ],
        data: (snapshot) {
          _initializeFrom(snapshot);
          return [
            VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              title: 'Rà soát quyền truy cập API',
              message:
                  'Kiểm tra quyền giao dịch, IP whitelist, secret và key đang bật trước khi tiếp tục.',
              contractId:
                  'Key đang bật: ${_keys.where((key) => key.isActive).length}/${_keys.length}',
              density: VitDensity.compact,
            ),
            if (_keys.isEmpty)
              const VitEmptyState(
                title: 'Chưa có API key',
                message: 'Tạo key mới và chỉ cấp quyền thật sự cần.',
                icon: Icons.key_off_outlined,
              )
            else
              for (final apiKey in _keys)
                _ApiPaneKeyCard(
                  apiKey: apiKey,
                  showSecret: _showSecretId == apiKey.id,
                  copiedId: _copiedId,
                  onToggle: () => _toggleKey(apiKey.id),
                  onReveal: () => _toggleSecret(apiKey.id),
                  onCopy: _copyText,
                  onDelete: () => _confirmDelete(apiKey),
                ),
            const _ApiDocsCard(),
          ];
        },
      ),
    );
  }

  void _initializeFrom(ProfileApiManagementSnapshot snapshot) {
    if (_initialized) return;
    _keys = List<ProfileApiKey>.of(snapshot.keys);
    _initialized = true;
  }

  void _createApiKey() {
    unawaited(HapticFeedback.selectionClick());
    openProfileDetailRoute(context, AppRoutePaths.profileApiCreate);
  }

  void _toggleKey(String id) {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _keys = [
        for (final apiKey in _keys)
          if (apiKey.id == id)
            apiKey.copyWith(isActive: !apiKey.isActive)
          else
            apiKey,
      ];
    });
  }

  void _toggleSecret(String id) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _showSecretId = _showSecretId == id ? null : id);
  }

  Future<void> _copyText(String id, String value) async {
    unawaited(HapticFeedback.selectionClick());
    await Clipboard.setData(ClipboardData(text: value));
    if (!mounted) return;
    setState(() => _copiedId = id);
  }

  Future<void> _confirmDelete(ProfileApiKey apiKey) async {
    unawaited(HapticFeedback.selectionClick());
    final confirmed = await showVitConfirmDialog(
      context: context,
      title: 'Xóa API Key?',
      message:
          'Thao tác này không thể hoàn tác. Tất cả kết nối sử dụng key này '
          'sẽ ngừng hoạt động.',
      confirmLabel: 'Xóa',
      confirmVariant: VitCtaButtonVariant.destructive,
    );
    if (!confirmed || !mounted) return;
    setState(() => _keys = _keys.where((key) => key.id != apiKey.id).toList());
    await showVitNoticeSheet(
      context: context,
      title: 'Đã xóa API key',
      message: 'Key "${apiKey.name}" đã bị xóa và ngừng hoạt động.',
      variant: VitBannerVariant.success,
      ctaVariant: VitCtaButtonVariant.success,
    );
  }
}
