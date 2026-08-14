# IA Route Entry Point Map — Index

Generated: 2026-07-13 · **Readiness pack updated: 2026-07-22**

## Readiness status (2026-07-22 · PROGRAM COMPLETE)

| Gate | Result |
|------|--------|
| Evidence pack | **SPEC DEPTH READY** (P0 done) |
| Code phases | **P0–P6 done** |
| Progress | **51 / 51** STEPs (100%) — see [playbook §1](../../../_archive/2026-ia-ux-reorg/UI-UX-FULL-REORG-EXECUTION-PLAYBOOK.md#1-progress-dashboard-ai-cập-nhật-sau-mỗi-step) |
| Badge | **`UI/UX REORG PROGRAM COMPLETE`** |
| Route + navigation audits | **PASS** (P6.5 gate) |
| Sparse P0 | **0** |
| Button wiring | **broken=0** |
| Visual QA | **33/33 GIỮ** · 65 phone QA @360×800 |
| Full test | **3534** PASS |
| **Execution playbook (chi tiết + tiến độ)** | [UI-UX-FULL-REORG-EXECUTION-PLAYBOOK.md](../../../_archive/2026-ia-ux-reorg/UI-UX-FULL-REORG-EXECUTION-PLAYBOOK.md) (archived) |
| Short outline | [UI-UX-REORG-MASTER-PLAN.md](./UI-UX-REORG-MASTER-PLAN.md) |

> Program complete. Next human action: open PR `ia-ux-readiness-pack` → `main`. D1–D6 locked; RG-12 closed (Referral → Profile tab, 2026-07-23).

Generated: 2026-07-13  
Source: ``Flutter-Route-Coverage-Truth-Table.md`` (413 ``real_page`` routes)  
Phân loại + **Menu UI đề xuất** theo quy tắc IA (chỉnh tay khi product đổi).

## Legend — Phân loại

| Phân loại | Ý nghĩa |
|-----------|---------|
| **GIỮ** | Entry point — hiển thị nav / Home / header |
| **HUB** | Màn cấp 2 trong hub cha (tile / tab / section) |
| **ẨN** | Flow step, dynamic `:id`, receipt, confirm |
| **GOM** | Gộp menu Pháp lý & báo cáo / Nâng cao |
| **DEV** | Nội bộ / QA / admin |

## Legend — Menu UI đề xuất

| Vị trí menu | Mô tả |
|-------------|-------|
| **Bottom Nav → *** | 5 tab chính (Home, Markets, Trade, Wallet, Profile) |
| **Header → *** | Search, Notifications; News trên Home header |
| **Home Hero / Next action** | Nạp, Rút — CTA ưu tiên |
| **Home → Sản phẩm Giao dịch** | Spot-adjacent: Margin, Convert, P2P |
| **Home → Discovery** | Predictions & Arena (tách biệt product) |
| **Profile → *** | Account, KYC, Support, Referral, Pháp lý |
| **Trade header** | Lệnh / Vị thế (D5) |
| **Wallet tools** | History, Address book, Health (D6) + overflow |

## Hub wireframes (P0 depth)

| # | File |
|---|------|
| 17 | [17-HOME-PROFILE-MENU-WIREFRAME.md](./17-HOME-PROFILE-MENU-WIREFRAME.md) |
| 18 | [18-APP-SHELL-BOTTOM-NAV-SPEC.md](./18-APP-SHELL-BOTTOM-NAV-SPEC.md) |
| 19 | [19-MARKETS-HUB-WIREFRAME.md](./19-MARKETS-HUB-WIREFRAME.md) |
| 20 | [20-TRADE-HUB-WIREFRAME.md](./20-TRADE-HUB-WIREFRAME.md) |
| 21 | [21-WALLET-HUB-WIREFRAME.md](./21-WALLET-HUB-WIREFRAME.md) |
| 22 | [22-EARN-SAVINGS-HUB-WIREFRAME.md](./22-EARN-SAVINGS-HUB-WIREFRAME.md) |
| 23 | [23-P2P-HUB-WIREFRAME.md](./23-P2P-HUB-WIREFRAME.md) |
| 24 | [24-PREDICTIONS-ARENA-DISCOVERY-WIREFRAME.md](./24-PREDICTIONS-ARENA-DISCOVERY-WIREFRAME.md) |
| 25 | [25-AUTH-ONBOARDING-SHELL-SPEC.md](./25-AUTH-ONBOARDING-SHELL-SPEC.md) |
| 26 | [26-CROSS-SHELL-NAV-EDGE-MATRIX.md](./26-CROSS-SHELL-NAV-EDGE-MATRIX.md) |

## Ledgers & gates

- [Reachability-Gap-Report.md](./Reachability-Gap-Report.md)
- [Sparse-Screen-Watchlist.md](./Sparse-Screen-Watchlist.md)
- [State-Coverage-by-Archetype.md](./State-Coverage-by-Archetype.md)
- [Button-Wiring-Baseline-Ledger.md](./Button-Wiring-Baseline-Ledger.md)
- [Visual-QA-Route-Manifest.md](./Visual-QA-Route-Manifest.md)
- [Home-Profile-IA-Delta-Checklist.md](../../../_archive/2026-ia-ux-reorg/Home-Profile-IA-Delta-Checklist.md) (archived)
- [UI-UX-Pre-Implementation-Gate.md](../../../_archive/2026-ia-ux-reorg/UI-UX-Pre-Implementation-Gate.md) (archived)
- [UI-UX-FULL-REORG-EXECUTION-PLAYBOOK.md](../../../_archive/2026-ia-ux-reorg/UI-UX-FULL-REORG-EXECUTION-PLAYBOOK.md) (archived)
- [99-ALL-ROUTES.md](./99-ALL-ROUTES.md)
- [UX-Evidence-Matrix.csv](./UX-Evidence-Matrix.csv)

## Entry-point map (EP summary)

| EP | Path | Primary entry |
|----|------|---------------|
| EP-01 | `/home` | Bottom Nav Home |
| EP-02 | `/markets` | Bottom Nav Markets |
| EP-03 | `/trade` | Bottom Nav Trade |
| EP-04 | `/wallet` | Bottom Nav Wallet |
| EP-05 | `/profile` | Bottom Nav Profile |
| EP-06 | `/search` | Header Search |
| EP-07 | `/notifications` | Header Notifications |
| EP-08 | `/wallet/deposit` | Home / Wallet |
| EP-09 | `/wallet/withdraw` | Home / Wallet |
| EP-11 | `/trade/margin` | Home product / Trade switcher |
| EP-12 | `/trade/convert` | Home quick / product |
| EP-13 | `/trade/copy-trading` | Home product / Trade |
| EP-14 | `/trade/bots` | Home product / Trade |
| EP-15 | `/earn` | Home product (D1→Trade tab) |
| EP-16 | `/earn/savings` | Home product |
| EP-17 | `/p2p` | Home quick / product |
| EP-18 | `/dca` | Home product |
| EP-19 | `/launchpad` | Home product / Khám phá |
| EP-20 | `/markets/predictions` | Home Discovery Predictions |
| EP-21 | `/arena` | Home Discovery Arena |
| EP-22 | `/rewards` | Home product / Khám phá |
| EP-23 | `/referral` | Profile menu |
| EP-24 | `/support` | Profile menu |
| EP-26 | `/trade/orders-history` | Trade header Lệnh |
| EP-27 | `/trade/positions` | Trade header Vị thế |
| EP-28 | `/earn/dashboard` | Earn hub |
| EP-29 | `/earn/savings/portfolio` | Savings hub |
| EP-30 | `/news` | Home header News |
| EP-31 | `/topics` | Home / Khám phá |
| EP-32 | `/settings/security` | Profile |
| EP-33 | `/profile/kyc` | Profile KYC banner |
| EP-34 | `/unified-portfolio` | Profile advanced |
| EP-35 | `/auth/login` | Auth shell (no bottom nav) |
