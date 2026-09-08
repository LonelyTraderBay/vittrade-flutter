# Tablet Port Execution Ledger — mục tiêu 412/412 composition thật

> **Sổ cái thực thi cho agent.** Mỗi phiên làm việc: đọc file này → chọn batch
> unchecked ĐẦU TIÊN theo thứ tự → chạy đúng Recipe → tick checkbox → cập nhật
> bảng Trạng thái → commit. KHÔNG dừng hỏi user giữa chạy (trừ lỗi chặn thật sự).
> Chuẩn kỹ thuật nguồn: `Tablet-Adaptive-Standard.md`, `AGENTS.md` UI Rules,
> memory `tablet-port-audit-traps` + `tablet-porting-playbook`.

## 1. Trạng thái hiện tại (GĐ1→GĐ7 HOÀN THÀNH 412/412; GĐ8 wiring pass HOÀN THÀNH 2026-09-09)

| Mốc | Số route thật | Ghi chú |
| --- | ---: | --- |
| Baseline snapshot (2026-09-05) | 57/412 | auth 6, home 1, markets 4, trade 13, wallet 21, profile 12 |
| + GĐ1.1 Trade terminal | 66/412 | +9 (SC-055/060/061/062/088/089/091/092/401) |
| + GĐ1.2 Markets tools | 84/412 | +18 (SC-009→026 trừ pair panes cũ) |
| + GĐ1.3 Đuôi lõi | 88/412 | +4 (SC-047 News, SC-319 Rewards, SC-405/406 Profile) |
| + GĐ2 P2P batch A1 (Home) | 89/412 | SC-282 |
| + GĐ2 P2P batch A2 (order-book/dashboard/express/confirm) | 93/412 | SC-273/274/211/210 |
| + GĐ2 P2P batch B (create/my-ads/ad/ad-analytics) | 97/412 | SC-226/225/224/223 |
| + GĐ2 P2P batch C (my-orders/order×5) | 103/412 | SC-281/216/212/213/214/215 |
| + GĐ2 P2P batch D (chat/wallet/transfer/fund-lock×2) | 108/412 | SC-217/264/261/262/263 |
| + GĐ2 P2P batch E (merchant-apply/profile/report) | 111/412 | SC-227/228/229 |
| + GĐ2 P2P batch F (kyc requirements/status/identity/verify/address/selfie/face-match/video) | 119/412 | SC-247/248/249/402/250/251/403/252 |
| + GĐ2 P2P batch G (payment-methods/add/verification/ownership/cooling/history) | 125/412 | SC-237/232/233/234/235/236 |
| + GĐ2 P2P batch H (disputes/dispute/detail/evidence/resolution) | 130/412 | SC-222/221/218/219/220 |
| + GĐ2 P2P batch I (insurance/certificate/score/policy/claim) | 135/412 | SC-238/239/240/241/243 |
| + GĐ2 P2P batch J (security center/2fa/devices/anti-phishing/login/suspicious/whitelist) | 142/412 | SC-253/254/255/256/257/258/404 |
| + GĐ2 P2P batch K (reviews/contribution/blacklist×2/e2e/fraud/achievements) | 149/412 | SC-231/242/277/276/259/260/275 |
| + GĐ2 P2P batch L (limits/tracker/compliance/aml/source/large-tx/risk) | 156/412 | SC-266/265/267/268/269/270/271 |
| + GĐ2 P2P batch M (trading-level/guide/settings/notifications/tax×2) | 162/412 | SC-230/279/278/280/272 |
| + GĐ3-COPY-1 hub SC-063 | 163/412 | copy_trading_tablet_page.dart |
| + GĐ3-COPY-2 core 6 trang (active/settings/notifications/leaderboard/education/safety-center) | 169/412 | copy_trading_core_tablet_pages.dart |
| + GĐ3-COPY-3 SC-084 regulatory hub | 170/412 | regulatory_disclosures_tablet_page.dart |
| + GĐ3-COPY-4 flow 5 trang (provider-detail/assessment/configuration/confirmation/performance) | 175/412 | copy_flow_tablet_pages.dart |
| + GĐ3-COPY-5 extended 8 trang (apply/comparison/risk-analysis/governance/dispute-resolution/audit-log/trader/attrib) | 178/412 | copy_trading_extended_tablet_pages.dart |
| + GĐ3-CMP-1 compliance 6 trang (client-money/cass/investor-comp/slippage/complaints×2) | 184/412 | compliance_tablet_pages.dart |
| + GĐ3-CMP-2 reports/arm/inspection/tracking/ombudsman/categorization/product-governance | 191/412 | compliance_reports_tablet_pages.dart |
| + GĐ3-CMP-3 costs 6 trang (ex-ante/RIY/ex-post/KID/perf-scenarios/risk-indicator) | 197/412 | costs_disclosure_tablet_pages.dart |
| + GĐ3-DCA 13 trang (hub/rebalance×3/schedule×2/optimizer/dynamic/backtester/multi-asset/compare/smart-rules/edit/history) | 210/412 | dca_tablet_pages.dart |
| + GĐ3-ĐUÔI 10 trang (SC-075 attribution, SC-080 safety, SC-093 transaction-reporting, SC-096 best-execution, SC-097 venue-analysis, SC-101/415 target-market×2, SC-115 audit-trail, SC-411 opt-up, SC-416 complaint-detail; hiệu chỉnh −1 attrib bị đếm trùng ở COPY-5) | 219/412 | copy_remaining_tablet_pages.dart + compliance_regulatory_tablet_pages.dart(+_governance) |
| + GĐ3-BOTS 19 trang (hub SC-124, terms SC-125, risk-disclosure SC-126, suitability SC-127, risk-dashboard SC-128, emergency-stop SC-129, security SC-130, history SC-131, performance SC-132, backtesting SC-133, strategy-compare SC-134, optimization SC-135, portfolio SC-136, drawdown SC-137, equity-curve SC-138, guide SC-139, faq SC-140, tax SC-141, api-doc SC-142) | 238/412 | trade_bots_tablet_pages.dart + 3 part (_analytics/_risk/_docs) |
| + GĐ4-SAV 24 trang (SC-296→317 hub/portfolio/history/guide/faq/notifications/recommendations/risk-assessment/comparison/auto-compound/goals/analytics/rebalance/notif-pref/dca/smart-suggestions/export/backtest/autopilot/ladder/whatif + SC-330/331/332 product-sample/redeem/receipt) | 262/412 | earn_savings_tablet_pages.dart + 4 part (_tools/_alerts/_plans/_more) |
| + GĐ4-STK 46 trang (SC-257→300: earn hub/dashboard/analytics/history/calendar/terms/risk-disclosure/tax-guide/risk-assessment/suitability/emergency/contingency/withdrawal-policy/validator×2/auto-compound/liquid/advanced-orders/multi-chain/institutional/insurance×2/risk-dashboard/risk-score/slashing/guide/faq/notifications/recommendations/regulatory/audit/custody/proof-of-reserves/transaction-reporting/webhooks/data-export/third-party/developer-console/api-doc/social-feed/community-governance/proposals/voting×2/forum) | 308/412 | staking_tablet_pages.dart + 8 part |
| + GĐ5-PRED 18 trang (SC-208→225: home/search/breaking/event-detail/portfolio/rewards/leaderboard/global-activity/risk-calculator/market-maker/portfolio-analyzer/event-calendar/social/advanced-chart/tournaments×2/data-integration/order-receipt) | 326/412 | predictions_tablet_pages.dart + 2 part (_explore/_explore2) |
| + GĐ5-LPD 24 trang (SC-360→386: hub/portfolio/performance/launchpool/detail/receipt/contract/ido-bridge/bridge-compare/bridge-order/claim-receipt/batch-claim/notif-sound/event-log/abi-diff/address-book/webhooks/gas-tracker/rebalance/multisig/swap-aggregator/limit-orders/dca-builder/risk-analytics) | 350/412 | launchpad_tablet_pages.dart + 2 part (_tools/_ops) |
| + GĐ5-ARENA 25 trang (SC-184→208: home/guide/studio/smart-rules/presets/governance/mode-detail/challenge-detail/join/creator/resolution/leaderboard/verified/points/flow-map/safety/blocked/my-reports/my/production/bridge/ecosystem/trust/ledger-entry/ledger/report-case) | 375/412 | arena_tablet_pages.dart + 3 part (_studio/_play/_points) |
| + GĐ6 26 trang (support×3, admin×5, enterprise-states, unified-portfolio, cross-module-analytics, smart-alerts, tax-reports, notifications, search, topics×2, referral×4, dev×5: route-checker/perf-monitor/showcase/design-system/dca-demo + onboarding + p2p-escrow + referral-friend) | 401+/412 | cross_module_tablet_pages.dart + 2 part (_modules/_dev) + misc_gate_tablet_pages.dart |
| + GĐ7 gate test toàn route (443 probe path) + 2 quyết định chính sách | **412/412** | tablet_full_route_gate_test.dart; part-split 24 file + density re-baseline 0→8 |
| + GĐ8 wiring pass (2026-09-09): nối luồng điều hướng + dữ liệu thật cho module port giai đoạn sau | 412/412 (không thêm route) | xem mục 4a |

Chỉ báo nhanh: `grep -c "if (path ==" lib/app/router/tablet/tablet_route_tree.dart`
(= 418 hiện tại); số construction utility còn lại = 0 (GĐ7).

## 2. Recipe chuẩn mỗi batch (áp nguyên khối, không suy biến)

1. **Survey nội bộ (nếu chưa có)** — xác định page class phone, provider
   (đọc typedef nếu family), snapshot entity + fields, có widget public không.
   P2P/Copy/Earn/Launchpad/Arena/Bots: KHÔNG có widget public — mọi section là
   `part` của phone page ⇒ tablet page dựng lại từ entity bằng Vit* shared.
2. **Viết trang tablet** — vị trí file:
   - Dashboard 2 cột (hub/monitor): `features/<f>/presentation/tablet/pages/<x>_tablet_page.dart`,
     dùng `VitTwoColumnTabletDashboard` (banner strip mỏng, primary = vùng làm
     việc, secondary = panel phụ) + `VitHeader` promoted sibling (R9).
   - Detail/flow nhạy cảm: surface riêng kiểu `WalletTabletDetailSurface` hoặc
     1 cột `VitPageContent` + sticky CTA (financial safety: preview/confirm).
   - Nội dung tuyến tính (guide/FAQ/receipt/policy): port mỏng 1 cột,
     maxWidth 1180, `TabletSpacingTokens` — KHÔNG dùng placeholder.
   - Markets-style pane trong shell có sẵn: `widgets/tablet/` + `MarketsPaneScaffold`.
3. **Quy ước cứng trong file mới:**
   - Padding: `TabletSpacingTokens.tableCellPaddingV / tableCellPadding /
     tableCellPaddingTall / tilePadding / cardPaddingCompact` — 0 literal
     `EdgeInsets.(all|symmetric|only|fromLTR)(` trong file dưới
     `presentation/widgets/` (home-reference audit); file trong
     `presentation/tablet/pages/` được miễn nhưng vẫn ưu tiên token.
   - Không `Container(`/`BoxDecoration(`/`BorderRadius.circular(` — dùng
     `VitCard`, `AppRadii.*Radius/Corner`.
   - Không `Icon` trần đứng ĐẦU `children:` của Row (AIB-R6b) — Icon cuối Row
     hoặc `VitAccentIconBox`.
   - Private class đặt tên có ngữ cảnh trang (`_CopyXxx`, `_EarnXxx` — ratchet
     duplicate-private 195 chỉ-giảm; check: `_MetricsCard/_PositionCard/...`
     đã bị chiếm).
   - Copy tiếng Việt có dấu; KHÔNG nhét điều kiện English vào `'${...}'`.
   - Entity là part file ⇒ import library cha (`market_entities.dart`,
     `p2p_shared_entities.dart`...) — hoặc bỏ import nếu providers barrel đã
     export (analyzer sẽ báo unnecessary_import).
   - Provider family: đọc typedef trước (`({...})` record) — seed giá trị mặc
     định giống phone state (VD P2P home: `USDT/VND/buy`).
4. **Wire route** — thêm `if (path == AppRoutePaths.x) return const XTabletPage();`
   trong `_buildTabletPage` (tablet_route_tree.dart); xóa branch utility/
   tailored tương ứng trong `_tabletUtilityTitle`/`_p2pUtilityForRoute`/
   `_profileUtilityForRoute` nếu có; import trang mới (anchor: sau import
   `markets_token_info_pane.dart`).
5. **Verify batch** — chạy nguyên Chuỗi verify (mục 3). Sai chỗ nào sửa chỗ đó,
   không bỏ qua.
6. **Test đồng bộ:**
   - Test khuôn mới nếu batch ≥3 trang (pump router tablet, assert byType +
     findsNothing TradeTabletUtilityPage/VitTabletUtilityPage).
   - Cập nhật `test/features/shared/tablet_utility_route_test.dart` +
     `test/features/*/profile_tablet_utility_page_test.dart`: SC trong batch
     đổi từ assert placeholder → assert trang thật (quy tắc migrate).
   - `i18n_vi_only_baseline.txt` / `ui_density_p0_allowlist_baseline.txt`: chỉ
     đụng khi chuỗi bị sửa/dịch (baseline chỉ được giảm).
7. **Cập nhật ledger** — tick checkbox, sửa bảng mục 1, commit
   (message tiếng Việt, không prefix; preflight trước push).

## 3. Chuỗi verify bắt buộc (mỗi batch — chạy đủ, không rút gọn)

```bash
cd flutter_app
dart format lib/features/ lib/app/ test/features/ --output=none --set-exit-if-changed .
flutter analyze lib/features/ lib/app/ test/features/
# chuỗi regen artifact theo thứ tự phụ thuộc (20 tool + 1):
for t in body_component_consistency_audit page_rhythm_audit page_rhythm_manifest \
  home_reference_consistency_audit page_content_width_audit navigation_edge_audit \
  back_navigation_behavior_audit card_tile_audit card_tile_manifest \
  duplicate_private_widget_audit home_entry_back_navigation_audit \
  design_token_consistency_audit segment_pill_audit segment_pill_manifest \
  top_header_action_audit top_header_behavior_audit \
  top_header_visual_archetype_audit top_header_global_access_policy_audit \
  route_coverage_audit generate_tablet_route_manifest tablet_card_border_audit; do \
  dart run tool/$t.dart > /dev/null 2>&1 || echo "REGEN FAIL: $t"; done
flutter test test/features/<feature-batch>/ test/features/shared/ \
  test/quality/accent_leading_icon_guardrail_test.dart \
  test/quality/home_reference_consistency_guardrail_test.dart \
  test/quality/architecture_size_style_debt_guardrails_test.dart \
  test/quality/duplicate_private_widget_guardrail_test.dart \
  --reporter compact
```

Đúng chuẩn: analyze 0 issue; regen 0 FAIL; test chỉ còn fail golden có sẵn
(danh sách mục 6). Cuối GĐ (không phải mỗi batch): `dart run tool/preflight_check.dart`.

## 4. Batches còn lại — tick khi xong

### GĐ2 · P2P (75 route còn / ~70 trang riêng, 13 batch)

Không có widget public nào (mọi `presentation/widgets/**` p2p là part của
phone page). Dùng được: `VitP2PFlowScaffold`, `P2PNoticeCard`, `P2PHelpBullet`,
`p2p_formatters.dart` (`formatP2PVnd`, `formatP2PCrypto`), mọi provider +
snapshot entity. Alias trùng trang: kyc/verify→Identity, kyc/face-match→Selfie,
wallet/history→FundLock, tax-report/detailed/:year→TaxReporting.

- [x] **P2P-A** còn 4: /p2p/order-book, /p2p/dashboard, /p2p/express,
  /p2p/express/confirm — providers `p2pOrderBookProvider(family)`,
  `p2pDashboardProvider(family)`, `p2pExpressProvider`,
  `p2pExpressConfirmProvider`; entities P2POrderBook/P2PDashboard/
  P2PExpress/P2PExpressConfirm Snapshot (p2p_dashboard_ux, p2p_orders entities).
- [x] **P2P-B** 4: /p2p/create, /p2p/my-ads, /p2p/ad/:adId,
  /p2p/ad-analytics/:adId — p2pCreateAdProvider, p2pMyAdsProvider,
  p2pAdDetailProvider(family), p2pAdAnalyticsProvider(family);
  P2PCreateAd/MyAds/AdDetail/AdAnalyticsSnapshot (p2p_ads_entities.dart).
- [x] **P2P-C** 6: /p2p/my-orders, /p2p/order/:orderId,
  /p2p/order/timeline/:orderId, /p2p/order/rate/:orderId,
  /p2p/order/cancel/:orderId, /p2p/order/proof/:orderId — p2pMyOrdersProvider,
  p2pOrderProvider(family), p2pOrderTimeline/Rate/Cancel/ProofProvider(family);
  P2PMyOrders/Order/Timeline/Rate/Cancel/ProofSnapshot (p2p_orders_entities).
  Order flow = wizard sticky CTA; cancel giữ requiresConfirmation.
- [x] **P2P-D** 5: /p2p/chat/:orderId, /p2p/wallet, /p2p/wallet/transfer,
  /p2p/wallet/fund-lock-history, /p2p/wallet/history — p2pChatProvider(family),
  p2pWalletProvider, p2pWalletTransferProvider(family),
  p2pFundLockHistoryProvider(family<bool>).
- [x] **P2P-E** 3: /p2p/merchant/apply, /p2p/merchant/:merchantId,
  /p2p/report/:merchantId — p2pMerchantApplyProvider,
  p2pMerchantProfileProvider(family), p2pReportMerchantProvider(family).
- [x] **P2P-F** 8: /p2p/kyc/requirements, /p2p/kyc/status, /p2p/kyc/identity,
  /p2p/kyc/verify (→Identity), /p2p/kyc/address, /p2p/kyc/face-match (→Selfie),
  /p2p/kyc/selfie, /p2p/kyc/video — p2pKyc*Provider,
  p2PSelfieVerificationProvider; wizard KYC trong pane.
- [x] **P2P-G** 6: /p2p/payment-methods, /p2p/payment-method/add,
  /p2p/payment-method/verification/:methodId,
  /p2p/payment-method/ownership/:methodId,
  /p2p/payment-method/cooling-period, /p2p/payment-method/history —
  p2pPaymentMethods/AddProvider, p2pPaymentMethodVerificationProvider(family),
  p2pPaymentMethodOwnership/CoolingPeriod{Controller}Provider,
  p2pPaymentMethodHistoryProvider. Preview/confirm bắt buộc (financial safety).
- [x] **P2P-H** 5: /p2p/disputes, /p2p/dispute/:orderId,
  /p2p/dispute/detail/:disputeId, /p2p/dispute/evidence/:disputeId,
  /p2p/dispute/resolution/:disputeId — p2pDisputesProvider,
  p2pDisputeOpen/DetailProvider(family), p2pDisputeEvidenceControllerProvider,
  p2pDisputeResolutionProvider.
- [x] **P2P-I** 5: /p2p/insurance, /p2p/insurance/certificate,
  /p2p/insurance/score, /p2p/insurance/policy,
  /p2p/insurance/claim/:claimId — p2pInsuranceFund/Certificate/Score/Policy/
  ClaimDetailProvider(family).
- [x] **P2P-J** 7: /p2p/security, /p2p/security/2fa, /p2p/security/devices,
  /p2p/security/anti-phishing, /p2p/security/login-history,
  /p2p/security/suspicious-activity, /p2p/security/whitelist —
  p2pSecurityCenterProvider, p2pTwoFactorSettingsProvider +
  p2p2FASettingsStateControllerProvider, p2pDeviceManagementProvider +
  StateController, p2pAntiPhishingCodeProvider, p2pLoginHistoryProvider,
  p2pSuspiciousActivityProvider. Bỏ tailored branches 2FA/dispute/cancel cũ
  trong `_p2pUtilityForRoute` khi port.
- [x] **P2P-K** 7: /p2p/reviews, /p2p/contribution-history, /p2p/blacklist,
  /p2p/blacklist/add, /p2p/e2e-info, /p2p/fraud-prevention,
  /p2p/achievements — p2pReviews/ContributionHistory/Blacklist/BlacklistAdd/
  E2EInfo/FraudPrevention/AchievementsProvider.
- [x] **P2P-L** 7: /p2p/limits, /p2p/limits/tracker, /p2p/compliance/overview,
  /p2p/compliance/aml-screening, /p2p/compliance/source-of-funds,
  /p2p/compliance/large-transaction,
  /p2p/compliance/risk-assessment — p2pTransactionLimits/LimitTracker/
  ComplianceOverview/AmlScreening/SourceOfFunds/LargeTransactionJustification
  Provider(family<double>)/RiskAssessmentProvider.
- [x] **P2P-M** 6: /p2p/trading-level, /p2p/guide, /p2p/settings,
  /p2p/settings/notifications, /p2p/tax-reporting,
  /p2p/tax-report/detailed/:year — p2pTradingLevelProvider, p2pGuideProvider,
  p2pSettingsProvider, p2pNotificationSettingsProvider,
  p2pTaxReportingProvider(family).

### GĐ3 · Copy Trading + Trading Bots + DCA (80 route)

- [x] **GĐ3-COPY-1** Hub + provider detail + active copies + settings +
  configuration/assessment/confirmation flow (≈12 route /trade/copy-trading*
  + /trade/copy-provider/* + /trade/copy-performance/*) — survey providers
  trong `p2p`-style group `trade_copy` (`lib/app/providers/trade_copy_*`).
  Provider detail = analysis-terminal style.
- [x] **GĐ3-COPY-2** 26 route regulatory/compliance (/trade/copy-trading/
  regulatory*, cass, client-money, complaints...) — port mỏng 1 cột, cùng
  khuôn; gộp 13 route/batch.
- [x] **GĐ3-COPY-3** nốt Copy (education, notifications, leaderboard,
  safety, dispute-resolution, audit-log, attribution, demo card đã xong GĐ1.1).
- [x] **GĐ3-BOTS-1** Hub + detail + performance/risk (≈9 route /trade/bots*).
- [x] **GĐ3-BOTS-2** docs/risk/terms/faq/tax/api (≈10 route, port mỏng).
- [x] **GĐ3-DCA-1** Hub + rebalance config/dashboard/edit/history (≈7 route).
- [x] **GĐ3-DCA-2** schedule/optimizer/backtester/multi-asset/compare/
  smart-rules (≈6 route).

### GĐ4 · Earn (70 route)

- [x] **GĐ4-SAV-1** /earn/savings + portfolio + history (3).
- [x] **GĐ4-SAV-2** guide/faq/notifications/recommendations/risk/comparison/
  auto-compound (7, port mỏng).
- [x] **GĐ4-SAV-3** goals/analytics/rebalance/notification-preferences/dca/
  smart-suggestions/export/backtest/autopilot/ladder/what-if (11, port mỏng)
  + product-sample/redeem/receipt (3, có confirm).
- [x] **GĐ4-STK-1** /earn + /earn/staking + dashboard + analytics + history (5).
- [x] **GĐ4-STK-2** terms/risk-disclosure/withdrawal-policy/tax-guide/risk-
  assessment/calendar/validator-selection/auto-compound/liquid-staking (9,
  port mỏng).
- [x] **GĐ4-STK-3** insurance/advanced-orders/multi-chain/institutional/guide/
  faq/notifications/recommendations/regulatory-framework/audit-reports/
  custody/suitability (12, port mỏng).
- [x] **GĐ4-STK-4** insurance-fund-transparency/transaction-reporting/api-doc/
  proof-of-reserves/risk-dashboard/slashing-history/validator-health/risk-score/
  emergency/contingency/social-feed (10) + community-governance/proposals/
  voting(+detail)/forum/webhooks/data-export/third-party/developer-console (8).

### GĐ5 · Predictions + Launchpad + Arena (67 route)

- [x] **GĐ5-PRED-1** /markets/predictions + search + breaking + portfolio +
  rewards + leaderboard + activity (7). Boundary PM: positions/probability/
  receipt OK, không hype/casino.
- [ ] **GĐ5-PRED-2** event/:eventId + receipt + risk-calculator + market-maker +
  portfolio-analyzer + event-calendar + social + advanced-chart + tournaments
  (+detail) + data-integration (11).
- [ ] **GĐ5-LP-1** /launchpad + portfolio + performance + staking (4).
- [ ] **GĐ5-LP-2** detail/ido-bridge/contract/receipt/claim/batch-claim/
  bridge-compare/bridge-order (8).
- [ ] **GĐ5-LP-3** notif-sound/event-log/abi-diff/address-book/webhooks/
  gas-tracker/rebalance/multisig/swap-aggregator/limit-orders/dca-builder/
  risk-analytics (12, port mỏng).
- [x] **GĐ5-ARENA-1** /arena + guide + leaderboard + verified + my (5).
  COPY POINTS-ONLY bắt buộc — cấm payout/wallet/profit/stake-return.
- [x] **GĐ5-ARENA-2** studio (+smart-rules/presets/governance) + mode/challenge/
  join (8).
- [x] **GĐ5-ARENA-3** resolution + creator + flow-map + safety + blocked +
  my-reports + production-ready + bridge + ecosystem + trust + ledger(+entry)
  + report (12).

### GĐ6 · Đuôi dài (32 route — port mỏng, nhanh)

- [ ] **GĐ6-1** Support 3 (/support, /support/help, /support/announcements)
  + Referral 5 (+friend/:id) — 8.
- [ ] **GĐ6-2** Discovery 4 (search/topics/topicCrypto/notifications)
  + Admin 5 — 9.
- [ ] **GĐ6-3** Enterprise/Dev 10 còn lại (unified-portfolio,
  cross-module-analytics, smart-alerts, tax-reports, enterprise-states,
  dev/design-system, dev/dca-overview, dev/showcase, route-checker,
  performance-monitor) — 10.
- [ ] **GĐ6-4** Gates 3 (onboarding/maintenance/force-update) + ROOT/other 1
  (path literal còn sót — tra `tabletRouteManifest` so `_buildTabletPage`) — 4.

### GĐ7 · Cổng hoàn thiện 100% — HOÀN THÀNH 2026-09-06

- [x] **GĐ7-1** Viết test cơ học: duyệt toàn bộ `tabletRouteManifest` (412
  path) + 3 route settings/security — pump từng route ở viewport 1024×768,
  assert KHÔNG render `VitTabletUtilityPage`/`P2PTabletUtilityPage`/
  `TradeTabletUtilityPage`/`ProfileTabletUtilityPage`/`VitWebUtilityPage`.
  Test này là bằng chứng 412/412.
- [x] **GĐ7-2** Xóa `_tabletUtilityTitle`/`_p2pUtilityForRoute`/
  `_profileUtilityForRoute` + branch utility còn sót; đồng bộ 5 construction
  utility về 0 (xem mục 1).
- [x] **GĐ7-3** Chạy `preflight_check.dart` full; cập nhật
  `Flutter-Route-Coverage-Truth-Table.md` + memory roadmap "100%"; báo cáo
  tổng cho user.

### GĐ8 · Wiring pass luồng điều hướng + dữ liệu (2026-09-09) — HOÀN THÀNH

Bối cảnh: báo cáo rà soát 2026-09-09 phát hiện các module port GĐ3–GĐ6 có
**0 lệnh điều hướng trong trang** (tablet 219 nav-edge vs phone 1208) — vào
được hub rồi bế tắc, ~300 route không thể tới bằng thao tác UI; 26+3 trang
GĐ6 render bullet tĩnh không ăn provider; 20 nút bấm rỗng (18 p2p_core +
2 trade_copy).

- [x] **GĐ8.1 Predictions** — event rows (home/search/breaking) → event
  detail; portfolio → receipts; receipt → event; tournament → bảng xếp hạng
  giải; event detail → advanced chart + cộng đồng; hub có 13 quick-links
  (search→data-integration). 134 test pass.
- [x] **GĐ8.2 Arena** — liveRooms/featuredModes → challenge/mode detail;
  challenge → join; creator → trust + phòng live; my/my-reports/report-case
  → detail; ledger entries → entry detail; flow-map routes → go(path);
  podium có creatorId → creator; hub 13 quick-links. 212 test pass.
- [x] **GĐ8.3 Staking** — earn hub 16 quick-links (dashboard→savings);
  proposals → voting proposal detail (family theo id). 266 test pass.
- [x] **GĐ8.4 Savings** — hub 21 quick-links (portfolio→what-if + staking).
  134 test pass.
- [x] **GĐ8.5 Launchpad** — advancedTools (data `.route`) tappable; hub
  quick-links (sample/portfolio/performance/staking/batch-claim). 183 test
  pass.
- [x] **GĐ8.6 Bots** — hub 18 quick-links (history→risk-disclosure). 126
  test pass.
- [x] **GĐ8.7 Copy + DCA + Compliance** — copy hub trader rows → provider
  detail + 12 quick-links secondary; DCA hub 10 quick-links; compliance
  dashboard 20 quick-links. 414 test pass.
- [x] **GĐ8.8 GĐ6 modules** — referral×4 + support×3 + admin home +
  notifications + cross-module-analytics + enterprise-states chuyển từ
  bullet tĩnh sang provider thật (`referralHomeSnapshotProvider`,
  `supportHubSnapshotProvider`, `adminHomeSnapshotProvider`,
  `notificationsSnapshotProvider`, ...); admin dashboards data-links + 4
  quick-links; referral history friend rows → friend detail (route từ
  data). 66 test pass. Còn lại static: admin analytics/abtests/funnels/
  settings, unified-portfolio, smart-alerts, tax-reports, search, topics,
  dev×5 (trang nội bộ/đơn dữ liệu — chấp nhận ở mock stage).
- [x] **GĐ8.9 Sửa 20 nút rỗng** — chat: send append tin nhắn local + quick
  reply điền input; create-ad/payment/compliance/order/dispute/account/
  copy: chuyển stateful + selection thật (`_selectedAsset`, `_selectedBank`,
  `_selectedReason`, `_answers`, `_selectedFormat`...); security setup →
  `p2pSecurity2fa`; whitelist toggle state; nút upload/attach không thể có
  hành vi thật ở mock → `onPressed: null` (render disabled trung thực).
  Kết quả: **0 empty handler trong tablet scope**.
- [x] **GĐ8.10 Khoá chất lượng** — regen 7 artifact audit (nav-edges, page
  rhythm, segment pill, card tile, back nav); test ratchet mới
  `tablet_navigation_parity_guardrail_test.dart`: (a) 10 module GĐ3+ mỗi
  module ≥1 lệnh điều hướng + floor tổng 33, (b) tablet scope 0 nút rỗng.
  Preflight P1+P3 21/21 PASS (P2 chỉ fail drift SDK đã biết).

Lưu ý đo lường: audit navigation-edge chỉ bắt literal `AppRoutePaths.x` —
quick-links dùng biến vòng lặp nên CSV tăng khiêm tốn (219→248 literal) nhưng
số cạnh thực tế mở rộng lớn hơn nhiều (mỗi helper render N chip theo data).

## 5. Chống gián đoạn (chạy một mạch)

1. **Ledger này = nguồn sự thật của tiến độ.** Tick ngay sau khi batch verify
   xanh; commit kèm tick. Phiên mới đọc mục 4, bỏ qua mọi thứ đã tick.
2. **Không có gate user giữa chạy:** port là re-compose nội dung phone đã có,
   không phải redesign — không cần mockup ASCII (gate chỉ áp redesign).
3. **Lỗi không chặn được thì xử lý theo mục 6;** lỗi thật (compile fail không
   rõ nguyên nhân, guardrail đỏ do lỗi mình) — sửa trong batch, không trôi sang
   batch khác.
4. **Quyết định chính sách duy nhất đã treo:** density baseline
   `walletWithdraw max 0` đo nhầm trang phone (artifact lineage stale ở HEAD —
   đã xác minh worktree sạch). Xử lý: KHÔNG ratchet lặng lẽ; ghi vào báo cáo
   cuối GĐ7 để user chốt. Không để nó chặn batch nào.
5. **Context cạn giữa batch:** memory `tablet-completion-roadmap` + ledger này
   đủ để phiên kế tiếp tiếp tục; ưu tiên hoàn thành batch hiện tại trước khi
   kết thúc phiên (không để nửa batch).

## 6. Fail CÓ SẴN đã xác minh — KHÔNG chữa trong port (đừng nhầm là hồi quy)

- ~17 golden (markets 12, profile 4, p2p 1) + trade golden 1 + home 3 + wallet 2
  ...: font Roboto không nạp trên Windows/toolchain local — fail cả ở cây sạch.
- `ui_density_p0_allowlist_guardrail` (walletWithdraw): ĐÃ re-baseline 0→8
  ngày 2026-09-06 (xem trên) — không còn fail.
- `flutter analyze` P2 warning `analysis_options_deprecated_plugins`: analyzer
  local 3.47 > CI 3.41.9.
- Preflight P2/P4 fail drift SDK — P3 (21 audit --check) là gate thực.
- `architecture_size_style_debt_guardrails` — ĐÃ TRẢ (2026-09-06): part-split
  24 file presentation >600 dòng (p2p/trade_copy/trade_compliance/wallet/
  profile/arena/dca, hậu tố vai trò `_extra`/`_sections`, part nằm cùng thư
  mục thư viện cha). over600: 56→32 ≤ 40, over1200 = 2 (đúng trần). 32 file
  data mock/entity >600 dòng GIỮ NGUYÊN (chia data không tăng chất lượng,
  trần có đệm). AIB-R6b map cập nhật 3 key theo move (count không đổi).
- `ui_density_p0_allowlist` walletWithdraw — ĐÃ re-baseline (2026-09-06):
  0→8 kèm ghi lineage trong baseline (audit đo phone withdraw page = 8 cả ở
  HEAD sạch; số 0 là artifact stale từ thời đo tablet page). Ratchet chạy
  tiếp từ 8 — tăng thêm vẫn đỏ.
- `tablet_fullbleed` (p2p_order_book), `tablet_gap_12` (markets_correlations),
  `semantic_label_language` (13 label DCA/P2P), `surface_boundary` (import
  phone trong copy hub), `money_copy` (+1 formatCdUsd), `back_navigation`
  (chat thiếu onBack), `design_token` (3 local TextStyle), AIB-R6b (19 icon
  trần): ĐÃ trả hết trong batch GĐ3-ĐUÔI (2026-09-06).

## 7. Ước lượng

44 batch còn lại (13 P2P + 7 GĐ3 + 7 GĐ4 + 8 GĐ5 + 4 GĐ6 + GĐ7 gộp). Mỗi batch
1 cửa sổ làm việc focused (5–10 file). Nhịp đã xác minh từ GĐ1.1→GĐ2A1: khoảng
3–5 batch/phiên dài nếu verify xanh lần đầu.
