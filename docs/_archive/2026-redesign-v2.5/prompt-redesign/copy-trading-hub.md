# Execution Prompt — Redesign UI Copy Trading Hub (SC-063)

**Version:** 1.0 · **Batch:** `RD-T05` · **Screen:** `sc063CopyTrading` · `/trade/copy-trading`  
**Accent:** Pre-copy assessment, provider risk, trust — Trade orange  
**Shell contract:** [AI_PROMPT_SHELL.md](../../01_AI_RULES/AI_PROMPT_SHELL.md) — không lặp boilerplate shell.

**Design authority:**

| File | Vai trò |
| --- | --- |
| [AGENTS.md](../../../AGENTS.md) | Product, UI rules, financial safety |
| [DESIGN.md](../../../DESIGN.md) | Tokens, component ladder |
| [Flutter-Native-Design-Standard.md](../standards/Flutter-Native-Design-Standard.md) | Trust-first, no dark patterns |
| [HomePage-Flutter-Native-Standard.md](../../04_SCREEN_REFERENCES/home/HomePage-Flutter-Native-Standard.md) | SC-007 visual standard |
| [trading-bots-hub.md](trading-bots-hub.md) | Tier A reference (SC-059) |

**Phase 2 handoff:** copy khối cuối file sau Phase 1 pass gate.

---

## Design North Star

> **“Đánh giá trước khi copy — rủi ro provider rõ ràng, không hype leaderboard.”**

Hub Copy Trading phải cảm giác như **copy product fintech compliant** (eToro / Binance Copy — **pattern**, không copy brand):

- Quét **≤3 giây**: portfolio summary, risk warning, bước đánh giá.
- **Pre-copy assessment** above fold — không nhảy thẳng “Copy ngay”.
- **Provider cards:** risk tier, drawdown, tenure — **không** leaderboard casino (neon rank, “Top 1”, FOMO).
- **Trust-first:** `CopyTradingRiskWarningCard` + risk review panel luôn visible.

---

## Personas & hành trình

| Persona | Mục tiêu | ≤3 bước tap |
| --- | --- | --- |
| **Người mới** | Hiểu rủi ro trước copy | Risk warning → risk review → provider → detail |
| **User thường** | Sort + mở provider | Sort chip → trader card → detail |
| **User nâng cao** | Scan portfolio copy | Hero metrics → sort → active copies link |

**Empty:** no match filter → reset + education link.

---

## Mục tiêu

1. Audit SC-063 theo North Star + anti-patterns.
2. Redesign hierarchy như Home; **de-hype** leaderboard trên hub.
3. Giữ `Vit*`, tokens, keys `sc063_*`, copy-trading safety.
4. Before/after spec + verify 360px.

---

## Anti-patterns — phải loại bỏ

| Anti-pattern | Hướng sửa |
| --- | --- |
| Leaderboard hype (podium, “#1”, flame) | Factual rank hoặc bỏ trên hub |
| ROI neon không drawdown context | ROI + max drawdown + risk pill |
| Ẩn risk warning | Giữ `CopyTradingRiskWarningCard` above list |
| Skip pre-copy assessment | Prominent risk review trước copy flow |
| Card trong card / sort trong `VitCard` border | Flat rows; sort ngoài card |
| >2 action / trader card | 1 “Xem chi tiết”; copy → detail |
| Local duplicate `Vit*` | Shared primitive |

---

## Phạm vi (scope)

### Trong scope — Phase 1 (`RD-T05`)

| Mục | Path |
| --- | --- |
| Hub | `copy_trading_page.dart` |
| Parts | `copy_trading_hero.dart`, `copy_trading_metrics_common.dart` |
| List (nếu block) | `copy_trading_list.dart` |
| Test | `test/features/trade/copy_trading_page_test.dart` |

### Ngoài scope Phase 1

Sub-pages (`/active`, `/education`, `/leaderboard`, compliance sc076–sc116…) — batch riêng. Leaderboard redesign = Phase 2; hub chỉ link neutral.

### Không được làm

Pub mới · đổi route/repository/copy logic · xóa `sc063_*` keys · one-chat compliance sweep · guaranteed-return copy.

---

## Home → Copy Trading map

| Home (SC-007) | Copy Trading (SC-063) |
| --- | --- |
| Hero summary | AUM / active copies / P/L (2 KPI max) |
| Primary CTA | “Đánh giá rủi ro” hoặc “Khám phá provider” |
| Announcement | Risk warning — không dismiss vĩnh viễn |
| Section rhythm | ≤3 above fold: Hero → Risk → Provider list |
| Sort/filter | Keys `sc063_sort_*`; không tab trong card border |
| Empty + CTA | No results + reset + education |

**Component ladder:** `VitCard`, `VitCtaButton`, `VitStatusPill`, `VitHighRiskStatePanel`, `VitTradeSection`, `VitIconButton`.

---

## IA & content hierarchy (360px)

```text
1. Header + subtitle
2. Hero (2 KPI portfolio)
3. Risk warning card (persistent)
4. Pre-copy assessment / risk review panel
5. Sort chips (ROI, AUM, drawdown — factual)
6. Provider list — keys sc063_trader_*, sc063_detail_*
7. Footer: copy ≠ guaranteed return
```

**Trader card:** name + risk pill → ROI + drawdown → **1** CTA detail. **No podium / animated rank on hub.**

---

## Copy & tone (tiếng Việt)

- “Sao chép chiến lược có kiểm soát” — không “Top trader”.
- Risk: “Copy trading không đảm bảo lợi nhuận”; “Quá khứ không báo hiệu tương lai”.
- Stats factual: “Drawdown tối đa”, “Thời gian hoạt động”.
- CTA: “Xem chi tiết”, “Đánh giá rủi ro” — không “Copy ngay kiếm tiền”.
- Tránh trophy/flame emoji, “Lãi khủng”, FOMO timer.

---

## Financial safety

- Risk warning + `VitHighRiskStatePanel` trên hub.
- ROI không cherry-pick — luôn kèm drawdown context.
- Copy **không** one-tap từ list — detail + assessment flow.
- Leaderboard link (nếu giữ): neutral framing on hub entry.

---

## Quy trình thực thi

### STEP 0 — Khám phá


```bash
cd flutter_app && flutter test test/features/trade/copy_trading_page_test.dart --reporter=compact
```

### STEP 1 — Audit

Bảng + **clutter before** + **hype score (1–10)** cho leaderboard visuals. **Chuyển STEP 2 ngay.**

### STEP 2 — Design spec

Wireframe + before/after (3 bullet) + persona 3/3 + component map.

### STEP 3 — Implementation

`impact()` trước edit. Giữ `tradeCopyTradingProvider`, sort, back fallback `/trade` (HEB-C02E). Verify 360px.

### STEP 4 — Verification

```bash
dart format --output=none --set-exit-if-changed lib/features/trade/presentation/pages/copy_trading_page.dart lib/features/trade/presentation/widgets/copy_trading_*.dart test/features/trade/copy_trading_page_test.dart
flutter analyze
flutter test test/features/trade/copy_trading_page_test.dart --reporter=compact
```

**Test keys (giữ):** sort reorder, detail nav, bottom nav, risk/hero visible.

### STEP 5 — Self-check

`vittrade-minimal-review` · clutter ≤4 · hype ≤3 · max 5–10 files/chat.

---

## Acceptance criteria (Phase 1 gate)

- [ ] Audit + spec + before/after + persona 3/3.
- [ ] Pre-copy assessment + risk warning above provider list.
- [ ] No hype leaderboard UI on hub.
- [ ] Provider cards: risk + drawdown with ROI.
- [ ] 100% `Vit*` + tokens; analyze clean; test pass.
- [ ] Back nav + Trade parent fallback intact.

**Completion line:** `COPY TRADING HUB UI REDESIGN DONE — RD-T05`

---

## Phase 2 handoff prompt

```markdown
RESUME FROM: Phase 2 — Copy Trading sub-pages
Shell: docs/01_AI_RULES/AI_PROMPT_SHELL.md
Parent: docs/02_FLUTTER_MIGRATION/prompt-redesign/copy-trading-hub.md
Apply: North Star, Copy, Financial — no-hype on sc079 leaderboard.
Scope: <2–4 copy_trading sub-route + tests>
Completion: COPY TRADING SUB-PAGES UI REDESIGN DONE — <batch_id>
```

**Bắt đầu:** STEP 0 → STEP 5 liên tục đến pass gate hoặc `RESUME FROM: Phase 1 — STEP <n>`.
