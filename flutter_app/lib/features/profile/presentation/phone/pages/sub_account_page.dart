import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_page_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/profile_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/profile_spacing_tokens.dart';

part '../../widgets/profile_sub_account_summary.dart';
part '../../widgets/profile_sub_account_primitives.dart';
part '../../widgets/profile_sub_account_create.dart';
part '../../widgets/profile_sub_account_card_details.dart';
part '../../widgets/profile_sub_account_cards.dart';
part '../../widgets/profile_sub_account_formatters.dart';

class SubAccountPage extends ConsumerStatefulWidget {
  const SubAccountPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc166_sub_accounts_content');
  static const loadingKey = Key('sc166_sub_accounts_loading');
  static const errorKey = Key('sc166_sub_accounts_error');
  static const offlineKey = Key('sc166_sub_accounts_offline');
  static const emptyKey = Key('sc166_sub_accounts_empty');
  static const summaryKey = Key('sc166_sub_accounts_summary');
  static const createButtonKey = Key('sc166_sub_accounts_create_button');
  static const createFormKey = Key('sc166_sub_accounts_create_form');
  static const balanceToggleKey = Key('sc166_sub_accounts_balance_toggle');

  static Key accountCardKey(String id) => Key('sc166_sub_account_card_$id');
  static Key expandKey(String id) => Key('sc166_sub_account_expand_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SubAccountPage> createState() => _SubAccountPageState();
}

class _SubAccountPageState extends ConsumerState<SubAccountPage> {
  bool _isBalanceHidden = false;
  bool _showCreate = false;
  String? _expandedId;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(profileSubAccountsSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollClearance =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome +
                  AppSpacing.x7 +
                  AppSpacing.x6 +
                  AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x6) +
        MediaQuery.paddingOf(context).bottom;

    return VitAutoHidePageScaffold(
      semanticLabel: 'Quản lý tài khoản phụ',
      semanticIdentifier: 'SC-166',
      header: VitHeader(
        title: 'T\u00E0i kho\u1EA3n ph\u1EE5',
        subtitle: 'T\u00E0i kho\u1EA3n \u00B7 Profile',
        showBack: true,
        onBack: _close,
      ),
      body: SingleChildScrollView(
        key: SubAccountPage.contentKey,
        physics: const ClampingScrollPhysics(),
        padding: ProfileSpacingTokens.profileSubAccountScrollPadding(
          scrollClearance,
        ),
        child: VitPageContent(
          rhythm: VitPageRhythm.standard,
          padding: VitContentPadding.none,
          density: VitDensity.compact,
          fullBleed: true,
          children: snapshotAsync.when(
            loading: () => const [
              VitSkeletonList(key: SubAccountPage.loadingKey),
            ],
            error: (error, stackTrace) => [
              VitErrorState(
                key: SubAccountPage.errorKey,
                title: 'Không tải được dữ liệu',
                message: 'Vui lòng thử lại.',
                actionLabel: 'Thử lại',
                onAction: () =>
                    ref.invalidate(profileSubAccountsSnapshotProvider),
              ),
            ],
            data: (snapshot) => _subAccountPageChildren(
              context: context,
              snapshot: snapshot,
              isBalanceHidden: _isBalanceHidden,
              showCreate: _showCreate,
              expandedId: _expandedId,
              onToggleBalance: _toggleBalance,
              onToggleCreateForm: _toggleCreateForm,
              onToggleExpanded: _toggleExpanded,
            ),
          ),
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

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.profile);
  }
}
