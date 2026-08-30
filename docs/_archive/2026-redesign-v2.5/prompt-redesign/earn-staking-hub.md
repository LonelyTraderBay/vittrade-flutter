# Execution Prompt — Redesign UI Earn / Staking Hub (SC-327)

**Version:** 1.0 · **Batch:** `RD-E01` · **Screen:** `sc327StakingEarn` · `/earn`  
**Accent:** Yield + risk transparency — Earn green (`AppModuleAccents.earn`)  
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

> **“Minh bạch lợi suất và rủi ro — không ngôn ngữ cam kết lợi nhuận.”**

Hub Earn / Staking phải cảm giác như **yield product fintech tier-1** (Binance Earn / Coinbase Staking — **pattern**, không copy brand):

- Quét **≤3 giây**: tổng earn, APY range, tab Sản phẩm / Vị thế, filter.
- **Yield transparency:** APY “ước tính” / “tham khảo”; lock period + risk tier trên card.
- **Risk visible:** Fixed / Flexible / DeFi distinction rõ; disclaimer không ẩn.
- **No guaranteed return** — không “chắc chắn”, “lợi nhuận cố định”, “không rủi ro”.

---

## Personas & hành trình

| Persona | Mục tiêu | ≤3 bước tap |
| --- | --- | --- |
| **Người mới** | Tìm fixed an toàn | Tab Sản phẩm → filter Fixed → product card |
| **User thường** | Xem vị thế stake | Tab Vị thế → scan → savings CTA |
| **User nâng cao** | So sánh DeFi vs Fixed | Filter DeFi → compare cards → detail |

**Empty:** tab Vị thế trống → CTA sang Sản phẩm.

---

## Mục tiêu

1. Audit SC-327 theo North Star + anti-patterns.
2. Redesign hierarchy như Home; yield/risk legible 360px.
3. Giữ `Vit*`, tokens, keys `sc327_*`, earn safety copy.
4. Before/after spec + verify 360px.

---

## Anti-patterns — phải loại bỏ

| Anti-pattern | Hướng sửa |
| --- | --- |
| “APY guaranteed” / “Lợi nhuận chắc chắn” | “APY ước tính”, “có thể thay đổi” |
| APY neon không lock/risk | APY + lock days + risk pill |
| Ẩn disclaimer | Footer + product hints |
| Tab/filter trong `VitCard` border | Tab/chip ngoài card |
| Filter bọc `VitCard(inner+border)` | `VitPresetChipRow` naked |
| Card trong card / >2 CTA | Flat card; 1 primary CTA |
| Magic spacing/radius | `AppSpacing` / `AppRadii` only |

---

## Phạm vi (scope)

### Trong scope — Phase 1 (`RD-E01`)

| Mục | Path |
| --- | --- |
| Hub | `staking_earn_page.dart` |
| Parts | `staking_earn_hero_tabs.dart`, `staking_earn_products.dart`, `staking_earn_positions_common.dart` |
| Test | `test/features/earn/staking_earn_page_test.dart` |

### Ngoài scope Phase 1

Earn sub-routes (detail, redeem, DeFi vaults…) — batch `RD-E02+`.

### Không được làm

Pub mới · đổi route/repository/staking logic · xóa `sc327_*` keys · redesign 70 màn earn một chat · guaranteed-yield dark patterns.

---

## Home → Earn Staking map

| Home (SC-007) | Earn Staking (SC-327) |
| --- | --- |
| Hero summary | Total staked + est. APY (2 KPI, labeled) |
| Primary CTA | Savings — `sc327_savings_button` |
| Tab bar | Sản phẩm \| Vị thế — `sc327_tab_*` |
| Filter row | All/Fixed/Flexible/DeFi — `sc327_filter_*` |
| Product list | Uniform cards — `sc327_product_*` |
| Empty + CTA | Empty positions → tab Products |

**Component ladder:** `VitTabBar`, `VitPresetChipRow`, `VitCard`, `VitCtaButton`, `VitStatusPill`, `VitPageLayout`.

Earn accent: module green — không dùng buy-green cho “guaranteed profit” semantics.

---

## IA & content hierarchy (360px)

```text
1. Header Earn title + subtitle
2. Hero: total staked + est. APY (labeled)
3. Tab Sản phẩm | Vị thế
4. Filter chips (products tab)
5. Product / position list
6. Savings CTA (if applicable)
7. Footer: yield variable, principal risk
```

**Product card:** asset + type pill → APY estimate + lock → **1** CTA.

---

## Copy & tone (tiếng Việt)

- “Kiếm thêm từ tài sản nhàn rỗi” — không “Lãi cao nhất”.
- APY: “ước tính”, “tham khảo (có thể thay đổi)”.
- Risk: “Giá tài sản và APY có thể biến động”; DeFi = “Rủi ro smart contract”.
- CTA: “Stake”, “Xem chi tiết”, “Khám phá sản phẩm”.
- Tránh: “Lợi nhuận đảm bảo”, “Không rủi ro”, “X2 tài sản”.

---

## Financial safety

- APY always qualified — never guaranteed language.
- Lock period + redeem rules on card or detail entry.
- DeFi: risk tier + disclaimer before stake (sub-flow).
- Redeem preview/confirm on sub-pages — list in Phase 2 audit.

---

## Quy trình thực thi

### STEP 0 — Khám phá


```bash
cd flutter_app && flutter test test/features/earn/staking_earn_page_test.dart --reporter=compact
```

### STEP 1 — Audit

Bảng + **clutter before** + **guaranteed-language audit** (violating strings). **Chuyển STEP 2 ngay.**

### STEP 2 — Design spec

Wireframe + before/after (3 bullet) + persona 3/3 + component map.

### STEP 3 — Implementation

`impact()` trước edit. Giữ `stakingEarnRepositoryProvider`, tab/filter, back route. Verify 360px.

### STEP 4 — Verification

```bash
dart format --output=none --set-exit-if-changed lib/features/earn/presentation/pages/staking_earn_page.dart lib/features/earn/presentation/widgets/staking_earn_*.dart test/features/earn/staking_earn_page_test.dart
flutter analyze
flutter test test/features/earn/staking_earn_page_test.dart --reporter=compact
```

**Test keys (giữ):** tab switch, filter tap, product card, savings button, bottom nav.

### STEP 5 — Self-check

`vittrade-minimal-review` · clutter ≤4 · zero guaranteed strings · max 5–10 files/chat.

---

## Acceptance criteria (Phase 1 gate)

- [ ] Audit + spec + before/after + persona 3/3.
- [ ] APY labeled estimate; no guaranteed return on hub.
- [ ] Risk/disclaimer visible; DeFi/Fixed distinction clear.
- [ ] Tab + filter comply AGENTS (no tab-in-card border).
- [ ] Empty positions CTA; 100% `Vit*` + tokens; test pass.

**Completion line:** `EARN STAKING HUB UI REDESIGN DONE — RD-E01`

---

## Phase 2 handoff prompt

```markdown
RESUME FROM: Phase 2 — Earn Staking sub-pages
Shell: docs/01_AI_RULES/AI_PROMPT_SHELL.md
Parent: docs/02_FLUTTER_MIGRATION/prompt-redesign/earn-staking-hub.md
Apply: North Star, Copy, Financial — no guaranteed yield on earn surfaces.
Scope: <2–4 earn sub-route + tests>
Completion: EARN STAKING SUB-PAGES UI REDESIGN DONE — <batch_id>
```

**Bắt đầu:** STEP 0 → STEP 5 liên tục đến pass gate hoặc `RESUME FROM: Phase 1 — STEP <n>`.
