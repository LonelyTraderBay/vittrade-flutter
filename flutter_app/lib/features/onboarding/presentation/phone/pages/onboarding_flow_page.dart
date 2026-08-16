import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/onboarding_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/core/storage/key_value_store.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/onboarding_spacing_tokens.dart';

part 'onboarding_flow_page_state.dart';
part '../../widgets/onboarding_step_screens.dart';
part '../../widgets/onboarding_shared_components.dart';

class OnboardingFlowPage extends ConsumerStatefulWidget {
  const OnboardingFlowPage({super.key});

  static const welcomeKey = Key('sc397_onboarding_welcome');
  static const modulesKey = Key('sc397_onboarding_modules');
  static const boundariesKey = Key('sc397_onboarding_boundaries');
  static const trustKey = Key('sc397_onboarding_trust');
  static const goalsKey = Key('sc397_onboarding_goals');
  static const completeKey = Key('sc397_onboarding_complete');
  static const startButtonKey = Key('sc397_onboarding_start');
  static const skipButtonKey = Key('sc397_onboarding_skip');
  static const nextButtonKey = Key('sc397_onboarding_next');
  static const backButtonKey = Key('sc397_onboarding_back');
  static const homeButtonKey = Key('sc397_onboarding_home');
  static const loadingKey = Key('sc397_onboarding_loading');
  static const emptyKey = Key('sc397_onboarding_empty');
  static const errorKey = Key('sc397_onboarding_error');
  static const offlineKey = Key('sc397_onboarding_offline');
  static Key featureKey(String id) => Key('sc397_feature_$id');
  static Key moduleDotKey(String id) => Key('sc397_module_dot_$id');
  static Key boundaryKey(String id) => Key('sc397_boundary_$id');
  static Key goalKey(OnboardingUserGoalDraft id) => Key('sc397_goal_$id');

  @override
  ConsumerState<OnboardingFlowPage> createState() => _OnboardingFlowPageState();
}
