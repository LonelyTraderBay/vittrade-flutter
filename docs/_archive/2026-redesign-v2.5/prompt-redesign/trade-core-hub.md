# Execution Prompt — Redesign UI Trade Core Hub (SC-048)

**Version:** 1.0 · **Batch:** `RD-T01` · **Screen:** `sc048Trade` · `/trade`  
**Accent:** Action, precision, risk — Trade orange (`AppModuleAccents.trade`)  
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

> **“Hành động rõ, số liệu chính xác, rủi ro luôn hiển thị.”**

Hub Trade Core phải cảm giác như **terminal spot fintech tier-1** (Binance / Coinbase Advanced — **pattern**, không copy brand):

- Quét **≤3 giây**: cặp, giá, side MUA/BÁN, số dư, bước tiếp theo.
- **Một hành động chính** mỗi vùng — form order không wall of inputs.
- **Precision-first:** tabular figures, `VitPresetChipRow`, confirm sheet trước submit.
- **Risk visible:** phí, available balance, disclaimer — không ẩn để UI “sạch”.

---

## Personas & hành trình

| Persona | Mục tiêu | ≤3 bước tap |
| --- | --- | --- |
| **Người mới** | Mua spot lần đầu | MUA → amount/preset → confirm → submit |
| **User thường** | Đổi side nhanh | BÁN → preset 25% → submit |
| **User nâng cao** | Chuyển product | Quick nav spot/convert/futures → form giữ side |

**Edge:** low balance → hint + link nạp; submit fail → toast, giữ input.

---

## Mục tiêu

1. Audit SC-048 theo North Star + anti-patterns.
2. Redesign hierarchy như Home, density thấp hơn hiện tại.
3. Giữ `Vit*`, tokens, keys `sc048_*`, financial safety.
4. Before/after spec + verify 360px.

---

## Anti-patterns — phải loại bỏ

| Anti-pattern | Hướng sửa |
| --- | --- |
| Custom MUA/BÁN thay `VitSegmentedChoice` | Segmented only; keys `sc048_trade_active_*_side` |
| Card trong card trên order form | Flat sections + divider |
| >2 CTA cùng hàng | 1 submit; secondary → quick nav |
| Ẩn phí / available balance | Luôn hiển thị trên hero hoặc form |
| Preset không dùng `VitPresetChipRow` | Shared chip row; keys `sc048_pct_*` |
| Local widget trùng `Vit*` | Shared primitive |
| Magic spacing/radius | `AppSpacing` / `AppRadii` only |

---

## Phạm vi (scope)

### Trong scope — Phase 1 (`RD-T01`)

| Mục | Path |
| --- | --- |
| Hub | `trade_page.dart`, `trade_page_part_01.dart` |
| Widgets (nếu block) | `vit_trade_simple_shell.dart`, `vit_trade_simple_hero.dart`, `vit_trade_simple_order_form.dart` |
| Test | `test/features/trade/trade_page_test.dart` |

### Ngoài scope Phase 1

Trade sub-routes (futures, convert, chart L2…) — liệt kê link từ quick nav; batch riêng.

### Không được làm

Pub mới · đổi route/repository/order logic · xóa `sc048_*` keys · redesign 91 màn trade một chat · dark patterns.

---

## Home → Trade Core map

| Home (SC-007) | Trade Core (SC-048) |
| --- | --- |
| Hero summary | Pair + last price + available balance |
| Primary CTA | Submit MUA/BÁN — `VitCtaButton` |
| Product strip | Quick nav — keys `sc048_quick_*` |
| Segmented choice | **MUA \| BÁN** — `VitSegmentedChoice`; không bọc tab trong `VitCard` border |
| Preset shortcuts | `VitPresetChipRow` 25/50/75/100% |
| Section rhythm | ≤3 above fold: Hero → Side+Form → Quick nav |

**Component ladder:** `VitSegmentedChoice`, `VitPresetChipRow`, `VitCtaButton`, `VitInput`, `VitCard`, `VitStatusPill`.

**Skills:** `vittrade-ui-checklists`, `vittrade-minimal-review`, `ui-ux-pro-max` (fintech only).

---

## IA & content hierarchy (360px)

```text
1. Header: pair + subtitle Trade
2. Hero: price + 24h change + available balance
3. Quick nav (spot / convert / futures)
4. VitSegmentedChoice MUA | BÁN
5. Form: amount + preset + fee/estimate
6. Primary submit
7. Footer risk micro-line (text3)
```

**Form target:** amount row → preset row → estimate+fee → **1** submit.

---

## Copy & tone (tiếng Việt)

- Headline hành động (“Giao dịch Spot”), không tên module kỹ thuật.
- Side: “MUA” / “BÁN”; semantic `buy`/`sell`.
- Risk factual: “Giá thị trường có thể thay đổi”.
- CTA verb-first: “Xác nhận MUA”, “Đặt lệnh BÁN”.
- Tránh: “Lãi ngay”, “All-in”, emoji casino.

---

## Financial safety

- Confirm sheet (`sc048_trade_confirm_sheet`) bắt buộc; giữ `VitTradeConfirmKeys`.
- Balance, total, fee trước confirm; preset % không vượt balance.
- Optimistic UI ok nếu test pass.

---

## Quy trình thực thi

### STEP 0 — Khám phá

GitNexus `query`/`context` `TradePage`. Baseline:

```bash
cd flutter_app && flutter test test/features/trade/trade_page_test.dart --reporter=compact
```

### STEP 1 — Audit

Bảng issues + **clutter score before (1–10)**. Nhóm: North Star, anti-patterns, Home map, MUA/BÁN, confirm, a11y, keys. **Chuyển STEP 2 ngay.**

### STEP 2 — Design spec

Wireframe + before/after (3 bullet) + persona 3/3 + component map.

### STEP 3 — Implementation

`impact()` trước edit. Minimal diff; giữ controller + confirm behavior. Verify 360px.

### STEP 4 — Verification

```bash
dart format --output=none --set-exit-if-changed lib/features/trade/presentation/pages/trade_page*.dart test/features/trade/trade_page_test.dart
flutter analyze
flutter test test/features/trade/trade_page_test.dart --reporter=compact
```

**Test keys (giữ):** `sc048_trade_active_*_side`, preset, confirm sheet, quick nav, bottom nav.

### STEP 5 — Self-check

`vittrade-minimal-review` · clutter after ≤4/10 · max 5–10 files/chat · Codex session only.

---

## Acceptance criteria (Phase 1 gate)

- [ ] Audit + spec + before/after + persona 3/3.
- [ ] Clutter after ≤4/10.
- [ ] MUA/BÁN = `VitSegmentedChoice`; preset = `VitPresetChipRow`.
- [ ] Risk/fee/balance visible; confirm sheet intact.
- [ ] 100% `Vit*` + tokens; analyze clean; `trade_page_test.dart` pass.

**Completion line:** `TRADE CORE HUB UI REDESIGN DONE — RD-T01`

---

## Phase 2 handoff prompt

```markdown
RESUME FROM: Phase 2 — Trade Core sub-pages
Shell: docs/01_AI_RULES/AI_PROMPT_SHELL.md
Parent: docs/02_FLUTTER_MIGRATION/prompt-redesign/trade-core-hub.md
Apply: North Star, anti-patterns, Home map.
Scope: <2–4 trade sub-route + tests>
Completion: TRADE CORE SUB-PAGES UI REDESIGN DONE — <batch_id>
```

**Bắt đầu:** STEP 0 → STEP 5 liên tục đến pass gate hoặc `RESUME FROM: Phase 1 — STEP <n>`.
