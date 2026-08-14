# Execution Prompt — Redesign UI Markets Hub (SC-008)

**Version:** 1.0  
**Batch:** `RD-K01`  
**Accent:** Scan, compare, data  
**Shell contract:** [AI_PROMPT_SHELL.md](../../01_AI_RULES/AI_PROMPT_SHELL.md) — không lặp boilerplate shell.

**Design authority:**

| File | Vai trò |
| --- | --- |
| [AGENTS.md](../../../AGENTS.md) | Product, UI rules, financial safety |
| [DESIGN.md](../../../DESIGN.md) | Tokens, component ladder |
| [Flutter-Native-Design-Standard.md](../standards/Flutter-Native-Design-Standard.md) | Trust-first, no dark patterns |
| [HomePage-Flutter-Native-Standard.md](../../04_SCREEN_REFERENCES/home/HomePage-Flutter-Native-Standard.md) | SC-007 visual standard |
| [trading-bots-hub.md](trading-bots-hub.md) | Tier A reference |

**Phase 2 handoff:** copy khối cuối file vào chat mới sau khi Phase 1 pass gate.

---

## Design North Star

> **“Tin cậy trước, đơn giản trước, chuyên nghiệp luôn.”**

Hub Markets phải cảm giác như **bảng giá fintech tier-1** (Binance Markets / Coinbase Markets / Kraken — **pattern**, không copy brand):
- **Quét ≤3 giây:** symbol, giá, %24h, volume — cột thẳng hàng, tabular figures.
- **So sánh nhanh:** sort/filter/category không che list; movers/tools là strip phụ, không chiếm fold.
- **Data-first:** last-updated rõ; empty/search fail có CTA reset — không màn hình im lặng.
- **Trust-first:** không hype coin, không FOMO badge; màu semantic `buy`/`sell` cho delta.

---

## Personas & hành trình bắt buộc

| Persona | Mục tiêu | Đường đi tối thiểu (≤3 bước tap) |
| --- | --- | --- |
| **Người mới** | Tìm BTC/ETH và xem giá | Hub → search hoặc scroll list → tap pair → detail |
| **User thường** | Theo dõi watchlist | Hub → star favorite → filter category → mở pair |
| **User nâng cao** | Scan movers + sort volume | Hub → movers strip → sort volume → pair detail |

**Empty state bắt buộc:** search/filter không match — `VitEmptyState` + CTA “Xóa bộ lọc” (đã có logic; polish copy/layout).

---

## Mục tiêu

1. **Audit** UI hub SC-008 theo North Star + anti-patterns bên dưới.
2. **Redesign** gọn, scan được — hierarchy rõ như Home, density thấp hơn hiện tại.
3. **Giữ** enterprise compliance: `Vit*`, tokens, test keys `sc008_*`, navigation tới pair detail.
4. **Deliver** before/after spec verify bằng test + visual check 360px.

---

## Anti-patterns — phải loại bỏ

| Anti-pattern | Vì sao xấu | Hướng sửa |
| --- | --- | --- |
| Card trong card trên pair row | Noise, khó scan | Flat row + divider; sparkline inline |
| >3 metric trên 1 pair row | 360px overflow | Symbol + price + %24h primary; volume secondary |
| Tab/category bọc `VitCard` border | Drift AGENTS | Chip row / `VitTabBar` ngoài card |
| Sort sheet che toàn màn hình không cần | Friction | Inline sheet hoặc bottom sheet gọn |
| Local duplicate `Vit*` | Enterprise fail | Shared primitive |
| Magic spacing/radius | Drift | `AppSpacing` / `AppRadii` |
| Movers/tools chiếm >50% fold | Mất scan list | Tối đa 1 strip above column header |

---

## Phạm vi (scope)

### Trong scope — Phase 1 (batch `RD-K01`)

| Mục | Path |
| --- | --- |
| Hub | `lib/features/markets/presentation/pages/market_list_page.dart` |
| Widgets hub | `market_list_*.dart`, `market_body_review_widgets.dart` |
| Test | `test/features/markets/market_list_page_test.dart` |

### Ngoài scope Phase 1

`pair_detail`, `market_movers`, `market_sectors`, alerts — audit link từ hub; redesign batch Phase 2 (`RD-K02`…).

### Không được làm

- Pub mới · đổi route/repository · xóa/đổi `Key` `sc008_*` · dark patterns (pump banners, fake urgency).

---

## Chuẩn thiết kế — map Home → Markets

| Home (SC-007) | Markets hub (SC-008) |
| --- | --- |
| Header + subtitle | `MarketListHeader` — title + quick nav |
| Search / discovery | `VitSearchBar` compact + inline sort |
| Product strip | Top movers + tools row (conditional) |
| List rhythm | Column header + pair rows đồng nhất |
| Empty + CTA | Search/filter empty + reset |
| Section gap | ≤3 blocks above pair list khi summary hiện |
| Tabular numbers | `AppTextStyles.numericCode` / semantic delta |

### Component ladder

`VitSearchBar`, `VitCard`, `VitEmptyState`, `VitTabBar` / category chips, `VitIconButton`, `VitStatusPill` — trước local widgets. Radius: `inputRadius`, `cardRadius`, `pillRadius` only.

## IA & content hierarchy (360px)

```text
1. Header: "Thị trường" + subtitle data freshness
2. Search + sort toggle (inline)
3. Category chips
4. (Optional) Movers strip + tools — khi không search
5. Column header (symbol | price | 24h)
6. Pair list (max visible slice + "Xem tất cả" nếu route có)
7. Footer link sectors/movers nếu còn chỗ
```

**Pair row target:** icon/symbol | price right | % pill | star favorite — **≤2 visual rows**.

---

## Copy & tone

- Headline: lợi ích (“Theo dõi thị trường”), không “MarketList Module”.
- Label ≤3 từ: “Tăng mạnh”, “Giảm”, “Volume”.
- Tránh: “Coin hot”, “Pump”, emoji trang trí.

---

## Financial / product safety

- Giá/% chỉ mang tính tham khảo; last-updated hiển thị khi mock/realtime có.
- Không gợi ý mua/bán trên list row — CTA trade ở pair detail.
- Favorite local state ok; không ẩn disclaimer data delay nếu có.

---

## Quy trình thực thi

### STEP 0 — Khám phá

GitNexus `query` + `context` `MarketListPage`. Baseline:

```bash
cd flutter_app
flutter test test/features/markets/market_list_page_test.dart --reporter=compact
```

### STEP 1–2 — Audit + spec

Bảng P0–P2 + clutter before; wireframe, before/after (3 bullet), persona 3/3, component map. **Không dừng hỏi user — chuyển STEP 3.**

### STEP 3 — Implementation

`impact()` trước edit. Giữ controller, `_go`, favorite toggle. Verify 360px.

### STEP 4 — Verification

```bash
dart format --output=none --set-exit-if-changed lib/features/markets/presentation/pages/market_list_page.dart lib/features/markets/presentation/widgets/market_list*.dart test/features/markets/market_list_page_test.dart
flutter analyze
flutter test test/features/markets/market_list_page_test.dart --reporter=compact
```

Test cover (giữ `sc008_*`): search, category filter, sort, pair tap navigation, empty state.

### STEP 5 — Batch self-check

`vittrade-minimal-review` · clutter after ≤4/10.

---

## Acceptance criteria (Phase 1 gate)

- [ ] Audit + spec + persona 3/3 trong chat.
- [ ] Clutter after ≤4/10 (giảm ≥3 vs before hoặc before ≤4).
- [ ] Above fold ưu tiên list scan; pair row ≤2 rows.
- [ ] Empty/search state có CTA reset.
- [ ] 100% `Vit*` + tokens; `flutter analyze` clean; tests pass.
- [ ] Không regression navigation markets module.

**Completion line:** `MARKETS HUB UI REDESIGN DONE — RD-K01`

---

## Batch discipline

Max **5–10 files**/chat · Phase 1 = hub only · Codex · STEP 0→5 liên tục.

---

## Phase 2 handoff

```markdown
RESUME FROM: Phase 2 — Markets sub-pages
Parent: docs/02_FLUTTER_MIGRATION/prompt-redesign/markets-hub.md
Completion: MARKETS SUB-PAGES UI REDESIGN DONE — <batch_id>
```
