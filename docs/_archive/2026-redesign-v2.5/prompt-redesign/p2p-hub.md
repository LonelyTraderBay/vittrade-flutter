# Execution Prompt — Redesign UI P2P Hub (SC-282)

**Version:** 1.0  
**Batch:** `RD-P01`  
**Hub screen:** `sc282P2PHome`  
**Accent:** Escrow, compliance UX  
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

> **“Escrow minh bạch, tuân thủ rõ ràng, giao dịch an toàn.”**

Hub P2P như sàn tier-1 (Binance/OKX P2P — **pattern**, không copy brand): quét **≤3 giây** (tab Mua/Bán, asset, KYC/escrow); **một CTA chính**/vùng; chi tiết merchant/limit sau tap; **compliance-first** — cảnh báo KYC/payment/escrow không dismiss che flow. Người mới: CTA “Bắt đầu mua” + link Guide; escrow giải thích 1 dòng; ad card tối đa 3 tiêu chí scan.

---

## Personas & hành trình bắt buộc

| Persona | Mục tiêu | ≤3 bước tap |
| --- | --- | --- |
| **Người mới** | Mua crypto lần đầu an toàn | Hub → Mua → ad → preview escrow → order |
| **User thường** | Theo dõi order đang chạy | Hub → My Orders → order active |
| **Merchant / nâng cao** | Quản lý ads & stats | Hub → Dashboard → quick actions |

**Empty state:** ad list rỗng — icon + headline + đổi filter + link Guide (`sc280`).

---

## Mục tiêu

1. Audit UI batch RD-P01 theo North Star + anti-patterns.
2. Redesign hub + 5 trang navigation cốt lõi — hierarchy như Home, density thấp.
3. Giữ `Vit*`, tokens, test keys, financial safety.
4. Before/after spec + verify 360px.

---

## Anti-patterns — phải loại bỏ (module P2P)

| Anti-pattern | Vì sao xấu | Hướng sửa |
| --- | --- | --- |
| Card trong card trên ad/order row | Visual noise | 1 `VitCard`/ad; flat stats |
| >2 CTA cùng hàng ad card | Overload | Primary Mua/Bán; secondary → menu |
| Escrow status ẩn/chỉ icon | Mất trust | Status pill + 1 dòng micro-copy |
| KYC warning dismissible | Compliance fail | Blocking banner + CTA KYC; no skip |
| Đổi payment method không confirm | Financial safety | Preview sheet: method, limit, cooling |
| Dispute chỉ trong overflow | User không tìm thấy | Link rõ trên order card + hub shortcut |
| Tab Mua/Bán trong `VitCard` border | Drift AGENTS | `VitSegmentedChoice` ngoài card |
| Merchant rating không kèm completion | Fake trust | Score + “X giao dịch” |
| Countdown / offer giả trên ad | Dark pattern | Bỏ; chỉ limit thật |
| Payment icon wall (>4/hàng) | Khó scan 360px | “+N phương thức” collapse |
| Local duplicate `Vit*` | Enterprise fail | Shared primitive |
| Magic spacing/radius | Drift | `AppSpacing` / `AppRadii` only |

---

## Phạm vi (scope)

### Trong scope — Phase 1 (`RD-P01`)

| Mục | Path |
| --- | --- |
| Hub | `lib/features/p2p/presentation/pages/p2p_home_page.dart` |
| Hub widgets | `widgets/p2p_home_page_part_01.dart` … `part_03.dart` |
| Hub test | `test/features/p2p/p2p_home_page_test.dart` |
| Dashboard | `pages/p2p_dashboard_page.dart` + `p2p_dashboard_page_part_*.dart` |
| Order book | `pages/p2p_order_book_page.dart` + `p2p_order_book_*` widgets |
| My orders | `pages/p2p_my_orders_page.dart` + `p2p_my_orders_page_*` |
| Settings | `pages/p2p_settings_page.dart` + `p2p_settings_*` |
| Guide | `pages/p2p_guide_page.dart` + `p2p_guide_*` |

Paths relative `flutter_app/lib/features/p2p/presentation/`. **Giữ keys:** `sc282_*`, `sc274_*`, `sc273_*`, `sc281_*`, `sc279_*`, `sc280_*`.

### Ngoài scope Phase 1

Express, dispute detail, payment verify, merchant apply, compliance sub-flows — audit link; batch `RD-P02+`.

### Không được làm

Pub mới · đổi route/repository/escrow logic · xóa test keys · redesign 77 màn một chat · dark patterns.

---

## Chuẩn thiết kế — map Home → P2P Hub

| Home (SC-007) | P2P hub (SC-282) |
| --- | --- |
| Auto-hide header | `VitAutoHideHeaderScaffold` |
| Hero summary | Quick hub: escrow hint + asset/fiat (2 KPI max) |
| Primary CTA | “Tạo quảng cáo” / “Bắt đầu mua” |
| Recent strip | Ad list — card height đồng nhất |
| Announcement | KYC/compliance banner khi blocked |
| Section rhythm | ≤3 section above fold: Hero → Tab → Ads |
| Segmented tab | Mua \| Bán — **không** bọc `VitCard` |
| Empty + CTA | Empty ads + Guide link |
| Typography tokens | Giá `numericCode`; score tabular |

**Component ladder:** `VitCard`, `VitCtaButton`, `VitSegmentedChoice`, `VitStatusPill`, `VitIconButton`, `VitPresetChipRow` — trước local widget. Radius: `inputRadius` / `cardRadius` / `pillRadius` only.

**Skills:** `vittrade-ui-checklists`, `vittrade-minimal-review`, `ui-ux-pro-max` (fintech only).

---

## IA scroll order (360px)

```text
1. Header "P2P" + subtitle escrow value prop
2. KYC/compliance banner (non-dismiss if blocked)
3. Asset rail + fiat selector
4. Segmented Mua | Bán
5. Search/filter (1 row)
6. Ad cards
7. Footer escrow disclaimer (text3)
```

**Ad card target:** merchant + price → limit + payments (≤3 icon) → 1 CTA + overflow.

---

## Copy & tone (tiếng Việt)

Headline lợi ích · escrow factual · KYC direct · label ≤3 từ · CTA verb-first. Tránh “deal hot”, emoji, casino language.

---

## Financial safety (critical)

- **Escrow preview** trước confirm: số tiền, phí, thời gian giữ, bước tiếp theo.
- **Payment method confirm:** đổi/thêm → preview sheet + cooling period nếu có.
- **Dispute flow:** entry rõ từ order; giữ timeline/evidence routes.
- **KYC warnings:** không skip/dismiss che flow.
- Mask payment details (account, phone) theo AGENTS.md.

---

## Quy trình thực thi

### STEP 0 — Khám phá


```bash
cd flutter_app && flutter test test/features/p2p/p2p_home_page_test.dart --reporter=compact
```

### STEP 1 — Audit UI

Bảng issues + clutter 1–10 (before). Nhóm: personas, anti-patterns, Home map, `Vit*`, KYC/escrow, a11y, keys. **Không dừng — chuyển STEP 2.**

### STEP 2 — Design spec

Wireframe · before/after (3 bullet) · persona 3/3 · component map.

### STEP 3 — Implementation

`impact()` trước edit. Max 5–10 files/chat. Giữ controllers, escrow sheets, navigation. Verify 360px.

### STEP 4 — Verification

Gate: [AI_PROMPT_SHELL.md](../01_AI_RULES/AI_PROMPT_SHELL.md) § Verification (`dart format`, `flutter analyze`, focused tests). Cover: tab Mua/Bán, asset/fiat, empty ads, KYC banner (mock), nav shortcuts. **Giữ** `sc282_*` keys.

### STEP 5 — Self-check

`vittrade-minimal-review` · clutter after ≤4/10.

---

## Acceptance criteria (Phase 1 gate)

- [ ] Audit + spec + before/after + persona 3/3
- [ ] Clutter after ≤4/10
- [ ] Hub ≤3 sections above fold; ad card ≤3 rows
- [ ] KYC/escrow/dispute UI không bị xóa
- [ ] Empty state + Guide link
- [ ] `Vit*` + tokens; `flutter analyze` clean; hub test pass
- [ ] No P2P navigation regression

**Completion line:** `P2P HUB UI REDESIGN DONE — RD-P01`

---

## Batch discipline

Max 5–10 files/chat · hub trước · Codex · visual QA riêng theo checklist Flutter.

**Bắt đầu ngay:** STEP 0 → 1 → 2 → 3 đến pass gate hoặc `RESUME FROM: Phase 1 — STEP <n> — RD-P01`.

---

## Phase 2 handoff prompt

```markdown
RESUME FROM: Phase 2 — P2P sub-pages (RD-P02+)

Shell: docs/01_AI_RULES/AI_PROMPT_SHELL.md
Parent: docs/02_FLUTTER_MIGRATION/prompt-redesign/p2p-hub.md (v1)

Apply: North Star, anti-patterns, Home map, Financial safety from parent.
Scope: express, dispute detail, payment method flows, merchant/compliance pages.

Completion: P2P SUB-PAGES UI REDESIGN DONE — <batch_id>
```
