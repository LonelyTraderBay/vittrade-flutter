import 'dart:async';

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/referral_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/referral_spacing_tokens.dart';

part 'referral_rewards_page_state.dart';
part 'referral_rewards_page_ledger_sections.dart';
part 'referral_rewards_page_dispute_widgets.dart';

class ReferralRewardsPage extends ConsumerStatefulWidget {
  const ReferralRewardsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc287_referral_rewards_content');
  static const heroKey = Key('sc287_referral_rewards_hero');
  static const chartKey = Key('sc287_referral_rewards_chart');
  static const tabsKey = Key('sc287_referral_rewards_tabs');
  static const sortKey = Key('sc287_referral_rewards_sort');
  static const ledgerKey = Key('sc287_referral_rewards_ledger');
  static const emptyKey = Key('sc287_referral_rewards_empty');
  static const exportKey = Key('sc287_export_report');
  static const disputeHistoryKey = Key('sc287_dispute_history');

  static Key tabKey(ReferralRewardFilter filter) =>
      Key('sc287_tab_${filter.name}');
  static Key sortOptionKey(ReferralRewardSort sort) =>
      Key('sc287_sort_${sort.name}');
  static Key recordKey(String id) => Key('sc287_record_$id');
  static Key reportKey(String id) => Key('sc287_report_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ReferralRewardsPage> createState() =>
      _ReferralRewardsPageState();
}
