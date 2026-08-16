import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header_action_button.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/arena_controller_providers.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/challenge/arena_navigation_actions.dart';
import 'package:vit_trade_flutter/app/theme/spacing/arena_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

part 'arena_home_page_hero_and_templates.dart';
part 'arena_home_page_modes_and_rooms_section.dart';
part 'arena_home_page_search_and_shared_widgets.dart';

const _arenaAccent = AppModuleAccents.arena;
const _arenaHomeHeroTitleLineHeight = 1.06;
const _arenaHomeTemplateTitleLineHeight = 1.12;
const _arenaHomeTemplateDescriptionLineHeight = 1.18;
const _arenaHomeModeTitleLineHeight = 1.12;
const _arenaHomeVerifiedLineHeight = 1.2;
const _arenaHomeFooterLineHeight = 1.22;
const _arenaHomeCountBadgeLineHeight = 1.0;
const _arenaHomeRoomProgressHeight = 4.0;
const _arenaHomeTools =
    <({String id, String label, IconData icon, String route})>[
      (
        id: 'guide',
        label: 'Hướng dẫn',
        icon: Icons.menu_book_outlined,
        route: AppRoutePaths.arenaGuide,
      ),
      (
        id: 'leaderboard',
        label: 'Bảng xếp hạng',
        icon: Icons.emoji_events_outlined,
        route: AppRoutePaths.arenaLeaderboard,
      ),
      (
        id: 'studio',
        label: 'Studio',
        icon: Icons.auto_awesome_rounded,
        route: AppRoutePaths.arenaStudio,
      ),
      (
        id: 'presets',
        label: 'Thư viện preset',
        icon: Icons.dashboard_customize_outlined,
        route: AppRoutePaths.arenaStudioPresets,
      ),
      (
        id: 'smart_rules',
        label: 'Luật thông minh',
        icon: Icons.rule_folder_outlined,
        route: AppRoutePaths.arenaStudioSmartRules,
      ),
    ];

class ArenaHomePage extends ConsumerStatefulWidget {
  const ArenaHomePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc184_arena_home_content');
  static const createChallengeKey = Key('sc184_create_challenge');
  static const exploreModeKey = Key('sc184_explore_mode');
  static const searchKey = Key('sc184_search');
  static const quickGuideKey = Key('sc184_quick_guide');
  static const quickRewardsKey = Key('sc184_quick_rewards');
  static const quickLeaderboardKey = Key('sc184_quick_leaderboard');
  static const quickMyArenaKey = Key('sc184_quick_my_arena');
  static const myArenaHeaderKey = Key('sc184_my_arena_header');
  static const toolsActionKey = Key('sc184_tools_action');
  static const toolsSheetKey = Key('sc184_tools_sheet');
  static const verifiedTeaserKey = Key('sc184_verified_teaser');

  static Key templateKey(String id) => Key('sc184_template_$id');
  static Key modeKey(String id) => Key('sc184_mode_$id');
  static Key roomKey(String id) => Key('sc184_room_$id');
  static Key creatorKey(String id) => Key('sc184_creator_$id');
  static Key toolKey(String id) => Key('sc184_tool_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaHomePage> createState() => _ArenaHomePageState();
}
