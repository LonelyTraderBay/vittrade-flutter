import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

part '../../../widgets/security/p2p_tax_reporting_page_sections.dart';
part '../../../widgets/security/p2p_tax_reporting_page_common.dart';

const double _p2pTaxVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pTaxNativeNavClearance =
    _p2pTaxVisualNavClearance - AppSpacing.x5 + AppSpacing.x1;
const double _p2pTaxVisualClearance = AppSpacing.x3;
const double _p2pTaxNativeClearance = AppSpacing.x2;
const double _p2pTaxSectionGap = AppSpacing.x2;
const double _p2pTaxIconBox = AppSpacing.searchBarCompactHeight;
const double _p2pTaxNoticeLineHeight = 1.35;

class P2PTaxReportingPage extends ConsumerStatefulWidget {
  const P2PTaxReportingPage({
    super.key,
    this.initialYear,
    this.shellRenderMode,
  });

  static const heroKey = Key('sc272_p2p_tax_hero');
  static const yearsKey = Key('sc272_p2p_tax_years');
  static const jurisdictionsKey = Key('sc272_p2p_tax_jurisdictions');
  static const summaryKey = Key('sc272_p2p_tax_summary');
  static const documentsKey = Key('sc272_p2p_tax_documents');
  static const disclaimerKey = Key('sc272_p2p_tax_disclaimer');
  static const detailCtaKey = Key('sc272_p2p_tax_detail_cta');

  static Key yearKey(int year) => Key('sc272_p2p_tax_year_$year');

  static Key jurisdictionKey(String code) =>
      Key('sc272_p2p_tax_jurisdiction_$code');

  final int? initialYear;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PTaxReportingPage> createState() =>
      _P2PTaxReportingPageState();
}

class _P2PTaxReportingPageState extends ConsumerState<P2PTaxReportingPage> {
  int _selectedYear = 2025;
  String _jurisdiction = 'US';

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialYear ?? _selectedYear;
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(
      p2pTaxReportingProvider((
        selectedYear: _selectedYear,
        selectedJurisdiction: _jurisdiction,
      )),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pTaxVisualNavClearance + _p2pTaxVisualClearance
            : _p2pTaxNativeNavClearance + _p2pTaxNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Báo cáo thuế P2P',
      semanticIdentifier: 'SC-272',
      child: Material(
        type: MaterialType.transparency,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2p),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2p),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(
                p2pTaxReportingProvider((
                  selectedYear: _selectedYear,
                  selectedJurisdiction: _jurisdiction,
                )),
              ),
            ),
          ),
          data: (snapshot) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: P2PSpacingTokens.p2pTaxScrollPadding(
                        scrollEndPadding,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.none,
                        fullBleed: true,
                        gap: VitContentGap.tight,
                        children: [
                          _TaxHero(snapshot: snapshot),
                          _YearSelector(
                            years: snapshot.years,
                            selectedYear: _selectedYear,
                            onChanged: (year) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _selectedYear = year);
                            },
                          ),
                          _JurisdictionSelector(
                            jurisdictions: snapshot.jurisdictions,
                            selectedCode: _jurisdiction,
                            onChanged: (code) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _jurisdiction = code);
                            },
                          ),
                          _TaxSummary(snapshot: snapshot),
                          _TaxDocuments(snapshot: snapshot),
                          _TaxDisclaimer(snapshot: snapshot),
                          VitCtaButton(
                            key: P2PTaxReportingPage.detailCtaKey,
                            onPressed: () {
                              unawaited(HapticFeedback.selectionClick());
                              context.go(snapshot.detailRoute);
                            },
                            child: const Text('View Detailed Tax Report'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
