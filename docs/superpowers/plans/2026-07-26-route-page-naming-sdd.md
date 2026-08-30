# Plan — Route/Page naming standardization (SDD)

**Date:** 2026-07-26  
**Base:** `main` (post #82)  
**Branch:** `feature/route-page-naming-standardize`
**Ledger:** `.superpowers/sdd/progress-route-page-naming.md`

## Goal

Chuẩn hóa kết nối route ↔ page theo AGENTS: screen = `*Page` /
`*_page.dart` dưới `presentation/pages/`; gate/shell chỉ là wrapper.
Không đổi UX/business logic. Không bịa remote.

## Tasks

### B0 — Audit evidence `Wrapper>Child`

Cập nhật `route_coverage_audit.dart` `_directRouteEvidence` để ghi
`InternalSurfaceGate>AdminHome` / `AuthRouteShell>LoginPage` (không chỉ outer).
Regenerate Truth Table + CSV by-module.

### B1a — Admin naming

Rename `AdminHome`→`AdminHomePage`, dashboards tương tự, files → `*_page.dart`.
Update routes/tests. ≤10 files nếu thiếu thì split.

### B1b — OnboardingFlow → OnboardingFlowPage + file rename

### B1c — DCA non-Page builders → `*Page` (+ file nếu cần)

`DCARebalanceConfig`, `DCAPortfolioOptimizer`, `DCADynamicAmount`,
`DCAScheduleConfig`, `DCAScheduleAnalytics`, `DCARebalanceDashboard`, …
Batch ≤10 files; thêm batch nếu cần.

### B1d — Cross-module dashboards → `*Page`

`UnifiedPortfolioDashboard`, `CrossModuleAnalytics`, `SmartAlertCenter`,
`TaxReportCenter` (+ files).

### B2 — Alias cleanup (safe only)

Chỉ path trùng builder 100% rõ ràng → `redirect`. Cancel-ok nếu rủi ro deep-link.

### B3 — Tab/part move khỏi `pages/`

**Deferred** (chỉ khi chạm file) — ghi ledger, không force wave này.

## Verify mỗi task code

```text
cd flutter_app
flutter analyze
dart run tool/route_coverage_audit.dart --check
# focused tests touched modules
```

## SDD

1 implementer → 1 reviewer · dùng phiên Codex hiện tại · no commit trừ user yêu cầu.
