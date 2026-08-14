# Execution Prompt — Redesign UI Wallet Hub (SC-135)

**Version:** 1.0  
**Batch:** `RD-W01`  
**Hub screen:** `sc135Wallet`  
**Accent:** Assets, trust, security  
**Shell contract:** [AI_PROMPT_SHELL.md](../01_AI_RULES/AI_PROMPT_SHELL.md) — không lặp boilerplate shell.

**Design authority:**

| File | Vai trò |
| --- | --- |
| [AGENTS.md](../../AGENTS.md) | Product, UI rules, financial safety |
| [DESIGN.md](../../DESIGN.md) | Tokens, component ladder |
| [Flutter-Native-Design-Standard.md](../standards/Flutter-Native-Design-Standard.md) | Trust-first, no dark patterns |
| [HomePage-Flutter-Native-Standard.md](../../04_SCREEN_REFERENCES/home/HomePage-Flutter-Native-Standard.md) | Chuẩn SC-007 |
| [trading-bots-hub.md](trading-bots-hub.md) | Tier A reference |
| `flutter_app/lib/features/home/presentation/pages/home_page.dart` | Reference implementation |

**Phase 2 handoff:** copy khối cuối file vào chat mới sau khi Phase 1 pass gate.

---

## Design North Star

> **“Tài sản rõ ràng, bảo mật minh bạch, hành động có kiểm soát.”**

Hub Wallet như ví tier-1 (Coinbase/Binance Funding — **pattern**, không copy brand): quét **≤3 giây** (total, change, next step); **một CTA chính**/vùng; allocation/DCA/health sau section/tab; **trust-first** — security/unavailable banner rõ. Người mới: “Nạp tiền” CTA; balance mask **optional**; asset row 3 cột scan (name, balance, fiat).

---

## Personas & hành trình bắt buộc

| Persona | Mục tiêu | ≤3 bước tap |
| --- | --- | --- |
| **Người mới** | Nạp tài sản đầu tiên | Hub → Nạp → deposit route |
| **User thường** | Kiểm tra balance + lịch sử | Hub → mask toggle → asset → detail |
| **User nâng cao** | Portfolio overview | Hub → analytics → multi-manager / health |

**Empty state:** asset list rỗng — icon + headline + “Nạp tiền” + “Mua crypto” (nếu route có).

---

## Mục tiêu

1. Audit UI batch RD-W01 theo North Star + anti-patterns.
2. Redesign hub + trang tài sản cốt lõi — hierarchy như Home, density thấp.
3. Giữ `Vit*`, tokens, test keys, financial safety.
4. Before/after spec + verify 360px.

---

## Anti-patterns — phải loại bỏ (module Wallet)

| Anti-pattern | Vì sao xấu | Hướng sửa |
| --- | --- | --- |
| Card trong card trên balance hero | Visual noise | 1 hero; flat stats below |
| >3 quick actions hero row | Overload | 2 primary (Nạp/Rút) + overflow |
| Balance full — không toggle | Privacy fail | `sc135_wallet_balance_toggle` reachable |
| Ẩn số dư nhỏ inflate total | Trust fail | Hiển thị đúng; note dust nếu cần |
| Asset row >3 metric @360px | Khó đọc | Name + balance + fiat; detail sau tap |
| Search/filter cạnh tranh hero | Clutter | 1 compact row dưới hero |
| Unavailable banner dismiss che | Trust fail | Persistent banner khi blocked |
| Tab groups trong `VitCard` border | Drift AGENTS | Tab ngoài card |
| Hub withdraw không qua preview flow | Financial safety | Navigate only; preview ở `withdraw_page` |
| Full address trên hub list | Security leak | Mask/truncate; full ở detail |
| Hype P/L neon hero | Casino feel | Semantic buy/sell; tabular |
| Local duplicate `Vit*` | Enterprise fail | Shared primitive |
| Magic spacing/radius | Drift | `AppSpacing` / `AppRadii` only |

---

## Phạm vi (scope)

### Trong scope — Phase 1 (`RD-W01`)

| Mục | Path |
| --- | --- |
| Hub | `lib/features/wallet/presentation/pages/wallet_page.dart` |
| Hub widgets | `widgets/wallet_page_sections.dart`, `wallet_page_balance_sections.dart`, `wallet_page_asset_sections.dart`, `wallet_page_allocation_sections.dart`, `wallet_page_dca_tool_sections.dart` |
| Hub test | `test/features/wallet/wallet_page_test.dart` |
| Tx history | `pages/transaction_history_page.dart` + widgets |
| Asset detail | `pages/asset_detail_page.dart` + widgets |
| Portfolio analytics | `pages/portfolio_analytics_page.dart` + widgets |
| Multi manager | `pages/wallet_multi_manager_page.dart` + widgets |
| Health score | `pages/wallet_health_score_page.dart` + widgets |

Paths relative `flutter_app/lib/features/wallet/presentation/`. **Giữ keys:** `sc135_*`, `sc136_*`, `sc147_*`, `sc142_*`, `sc148_*`, `sc151_*`.

### Ngoài scope Phase 1

Withdraw/deposit confirm logic, address book, token approval, gas optimizer — audit link; batch `RD-W02+`.

### Không được làm

Pub mới · đổi route/repository · xóa test keys · redesign 21 màn một chat · dark patterns.

---

## Chuẩn thiết kế — map Home → Wallet Hub

| Home (SC-007) | Wallet hub (SC-135) |
| --- | --- |
| Auto-hide header | `VitAutoHideHeaderScaffold` |
| Hero summary | Total + 24h change + mask toggle |
| Primary CTA | Nạp \| Rút (max 2 hero) |
| Recent strip | Asset list — row height đồng nhất |
| Announcement | Unavailable/security banner |
| Section rhythm | ≤3 above fold: Hero → Actions → Assets |
| Tab/segmented | Asset groups — **không** bọc `VitCard` |
| Empty + CTA | Empty wallet + Nạp |
| Typography | Balance `heroNumber`; amounts tabular |

**Component ladder:** `VitCard`, `VitCtaButton`, `VitTabBar`, `VitStatusPill`, `VitSectionHeader`, `VitInsetScrollView` — trước local widget. Radius tokens only.

**Skills:** `vittrade-ui-checklists`, `vittrade-minimal-review`, `ui-ux-pro-max` (fintech only).

---

## IA scroll order (360px)

```text
1. Header "Ví" + subtitle trust value prop
2. Hero: total + change + mask toggle
3. Quick actions: Nạp | Rút (+ overflow)
4. Optional allocation/health hint (collapsed)
5. Search/filter compact
6. Asset tabs (if any)
7. Asset list rows
8. Footer security micro-link (if route)
```

**Asset row target:** icon+symbol → balance + fiat (masked if off) → tap to detail; no inline withdraw.

---

## Copy & tone (tiếng Việt)

Headline lợi ích · security calm · mask neutral · label ≤3 từ · CTA verb-first. Tránh “lãi khủng”, emoji, casino language.

---

## Financial safety (critical)

- **Balance mask toggle:** optional via `balanceToggleKey`; user chọn ẩn/hiện.
- **Withdraw preview elsewhere:** hub navigate only; mọi rút qua `withdraw_page` + preview (fee, address, limit).
- **Trust-first display:** số liệu khớp repo; `wallet_unavailable_banner` khi degraded.
- Mask address/memo/account theo AGENTS.md; deposit/transfer qua flow có preview.

---

## Quy trình thực thi

### STEP 0 — Khám phá

GitNexus `query`/`context` `WalletPage`. Đọc hub widgets + Home tương ứng. Baseline:

```bash
cd flutter_app && flutter test test/features/wallet/wallet_page_test.dart --reporter=compact
```

### STEP 1 — Audit UI

Bảng issues + clutter 1–10 (before). Nhóm: personas, anti-patterns, Home map, `Vit*`, mask/unavailable, a11y, keys. **Không dừng — chuyển STEP 2.**

### STEP 2 — Design spec

Wireframe · before/after (3 bullet) · persona 3/3 · component map.

### STEP 3 — Implementation

`impact()` trước edit. Max 5–10 files/chat. Giữ controllers, toggle behavior, routes. Verify 360px.

### STEP 4 — Verification

Gate: [AI_PROMPT_SHELL.md](../01_AI_RULES/AI_PROMPT_SHELL.md) § Verification (`dart format`, `flutter analyze`, focused tests). Cover: mask toggle, asset list/tap, quick actions nav, empty state, unavailable banner (mock). **Giữ** `sc135_*` keys.

### STEP 5 — Self-check

`vittrade-minimal-review` · clutter after ≤4/10.

---

## Acceptance criteria (Phase 1 gate)

- [ ] Audit + spec + before/after + persona 3/3
- [ ] Clutter after ≤4/10
- [ ] Hub ≤3 sections above fold; asset row ≤2 rows
- [ ] Mask toggle works; trust/unavailable UI intact
- [ ] Empty state + Nạp CTA
- [ ] `Vit*` + tokens; `flutter analyze` clean; hub test pass
- [ ] No navigation regression; withdraw preview flows intact

**Completion line:** `WALLET HUB UI REDESIGN DONE — RD-W01`

---

## Batch discipline

Max 5–10 files/chat · hub trước · Codex · visual QA riêng theo checklist Flutter.

**Bắt đầu ngay:** STEP 0 → 1 → 2 → 3 đến pass gate hoặc `RESUME FROM: Phase 1 — STEP <n> — RD-W01`.

---

## Phase 2 handoff prompt

```markdown
RESUME FROM: Phase 2 — Wallet sub-pages (RD-W02+)

Shell: docs/01_AI_RULES/AI_PROMPT_SHELL.md
Parent: docs/02_FLUTTER_MIGRATION/prompt-redesign/wallet-hub.md (v1)

Apply: North Star, anti-patterns, Home map, Financial safety from parent.
Scope: withdraw/deposit flows, address book, token approval, gas optimizer, dust converter.

Completion: WALLET SUB-PAGES UI REDESIGN DONE — <batch_id>
```
