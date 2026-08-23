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
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_pane_scaffold.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part 'profile_sub_accounts_pane_sections.dart';

/// Tablet sub-accounts detail pane (SC-166) for the Profile master-detail
/// shell — a public port of the phone `SubAccountPage`'s content (total
/// balance hero with hide toggle, risk-review panel, create form preview,
/// expandable per-account cards with 30d metrics/permissions/actions, info
/// note) into [ProfilePaneScaffold], per R2: the phone page and its `part`
/// family stay untouched. Same [profileSubAccountsSnapshotProvider] data as
/// the phone page.
class ProfileSubAccountsPane extends ConsumerStatefulWidget {
  const ProfileSubAccountsPane({super.key});

  @override
  ConsumerState<ProfileSubAccountsPane> createState() =>
      _ProfileSubAccountsPaneState();
}

class _ProfileSubAccountsPaneState
    extends ConsumerState<ProfileSubAccountsPane> {
  bool _isBalanceHidden = false;
  bool _showCreate = false;
  String? _expandedId;

  Future<void> _refresh() async {
    ref.invalidate(profileSubAccountsSnapshotProvider);
    await ref.read(profileSubAccountsSnapshotProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(profileSubAccountsSnapshotProvider);

    return ProfilePaneScaffold(
      title: 'Tài khoản phụ',
      subtitle: 'Quyền truy cập · hạn mức · hoạt động',
      onBack: () => context.go(AppRoutePaths.profile),
      onRefresh: _refresh,
      scrollKey: ProfileTabletKeys.subAccountsPane,
      children: snapshotAsync.when(
        loading: () => const [VitSkeletonList(rows: 4)],
        error: (error, stackTrace) => [
          VitErrorState(
            key: ProfileTabletKeys.subAccountsPaneError,
            title: 'Không tải được tài khoản phụ',
            message: 'Kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: _refresh,
          ),
        ],
        data: (snapshot) => _subsPaneChildren(
          snapshot: snapshot,
          isBalanceHidden: _isBalanceHidden,
          showCreate: _showCreate,
          expandedId: _expandedId,
          onToggleBalance: _toggleBalance,
          onToggleCreateForm: _toggleCreateForm,
          onToggleExpanded: _toggleExpanded,
        ),
      ),
    );
  }

  void _toggleBalance() {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _isBalanceHidden = !_isBalanceHidden);
  }

  void _toggleCreateForm() {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _showCreate = !_showCreate);
  }

  void _toggleExpanded(String id) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _expandedId = _expandedId == id ? null : id);
  }
}
