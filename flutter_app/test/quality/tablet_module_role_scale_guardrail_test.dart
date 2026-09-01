// Guardrail: Tablet module and shared-widget spacing must resolve through the
// Tablet Base-8-derived namespace. Module token files remain shared with Phone
// where necessary, so Tablet call sites are locked here against accidental
// Phone-token leakage.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

void main() {
  tearDown(() {
    TabletSpacingTokens.tabletSurfaceActive = false;
  });

  test('Markets and Wallet Tablet roles stay mapped to Tablet tokens', () {
    expect(
      MarketsSpacingTokens.pairPaneChildFlushPadding,
      const EdgeInsets.symmetric(horizontal: TabletSpacingTokens.contentPad),
    );
    expect(MarketsSpacingTokens.pairDeskGutter, TabletSpacingTokens.cardGap);
    expect(
      MarketsSpacingTokens.pairDeskFooterPadding,
      const EdgeInsets.fromLTRB(
        TabletSpacingTokens.contentPad,
        TabletSpacingTokens.x2,
        TabletSpacingTokens.contentPad,
        TabletSpacingTokens.x2,
      ),
    );
    expect(MarketsSpacingTokens.pairDeskFooterGap, TabletSpacingTokens.x3);
    expect(MarketsSpacingTokens.pairIndicatorDot, TabletSpacingTokens.x1);
    expect(
      WalletSpacingTokens.walletAddressTabletFilterPadding,
      const EdgeInsets.symmetric(horizontal: TabletSpacingTokens.x4),
    );
    expect(
      WalletSpacingTokens.walletTabletAllocationChartInset,
      TabletSpacingTokens.x3,
    );
    expect(
      WalletSpacingTokens.walletTabletHistoryDividerHeight,
      TabletSpacingTokens.dividerHairline,
    );
    expect(
      TabletSpacingTokens.profileDeviceLogoutButtonPadding,
      const EdgeInsets.symmetric(horizontal: TabletSpacingTokens.x3),
    );
  });

  test('shared Home widgets resolve their Tablet roles through the bridge', () {
    TabletSpacingTokens.tabletSurfaceActive = true;

    expect(
      AppSurfaceSpacing.homeCardPaddingDefault,
      TabletSpacingTokens.cardPaddingStandardDensity,
    );
    expect(
      AppSurfaceSpacing.homeAnnouncementCardPaddingCompact,
      TabletSpacingTokens.cardPaddingCompactDensity,
    );
    expect(AppSurfaceSpacing.homeAnnouncementIconGap, TabletSpacingTokens.x3);
    expect(AppSurfaceSpacing.homeNextActionIconGap, TabletSpacingTokens.x3);
    expect(
      AppSurfaceSpacing.homeNextActionTitleSubtitleGap,
      TabletSpacingTokens.x3,
    );
    expect(AppSurfaceSpacing.homeNextActionCardPadding, 16);
    expect(AppSurfaceSpacing.homeNextActionChevronGap, TabletSpacingTokens.x1);
  });

  test(
    'Tablet compositions do not reference known Phone-only spacing roles',
    () {
      const forbidden = <String>[
        'SharedSpacingTokens.homeCardPaddingDefault',
        'SharedSpacingTokens.homeNextActionCardPadding',
        'SharedSpacingTokens.homeAnnouncementCardPaddingCompact',
        'HomeSpacingTokens.homeListRowPadding',
        'ProfileSpacingTokens.profileMenuGap',
        'ProfileSpacingTokens.profileProductGridGap',
        'ProfileSpacingTokens.profileProductGap',
        'ProfileSpacingTokens.profileHeroPillGap',
        'ProfileSpacingTokens.profileHeroPillRunGap',
        'ProfileSpacingTokens.profileHeroPadding',
        'ProfileSpacingTokens.profileHeroInfoPadding',
        'ProfileSpacingTokens.kycStatusGap',
        'ProfileSpacingTokens.kycLevelRowGap',
        'ProfileSpacingTokens.profileApiCreateExpirySpacing',
        'ProfileSpacingTokens.profileApiCreateIpChipGap',
        'ProfileSpacingTokens.profileDevicesMetaSpacing',
        'ProfileSpacingTokens.profileDevicesMetaRunSpacing',
        'ProfileSpacingTokens.profileSubAccountPermissionGap',
        'ProfileSpacingTokens.profileActivityFilterChipGap',
        'ProfileSpacingTokens.profileActivityFilterChipPadding',
        'ProfileSpacingTokens.securityRowGap',
        'ProfileSpacingTokens.securityDevicePadding',
        'ProfileSpacingTokens.settingsCurrencyChipGap',
      ];
      final violations = <String>[];
      for (final entity in Directory(
        'lib/features',
      ).listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        final path = entity.path.replaceAll('\\', '/');
        final fileName = path.split('/').last;
        if (!path.contains('/tablet/') && !fileName.contains('tablet')) {
          continue;
        }
        final source = entity.readAsStringSync();
        for (final token in forbidden) {
          if (source.contains(token)) violations.add('$path: $token');
        }
      }
      expect(violations, isEmpty, reason: violations.join('\n'));
    },
  );
}
