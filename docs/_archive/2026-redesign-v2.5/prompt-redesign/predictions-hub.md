# Execution Prompt — Redesign UI Predictions Hub (SC-027)

**Version:** 1.0  
**Batch:** `RD-R01`  
**Accent:** Probability, not casino — positions, receipts, risk transparency ([AGENTS.md](../../../AGENTS.md) Prediction Markets boundary)  
**Shell contract:** [AI_PROMPT_SHELL.md](../../01_AI_RULES/AI_PROMPT_SHELL.md) — không lặp boilerplate shell.

**Design authority:**

| File | Vai trò |
| --- | --- |
| [AGENTS.md](../../../AGENTS.md) | Product boundaries, financial safety, UI rules |
| [DESIGN.md](../../../DESIGN.md) | Tokens, component ladder |
| [Flutter-Native-Design-Standard.md](../standards/Flutter-Native-Design-Standard.md) | Trust-first, no dark patterns |
| [HomePage-Flutter-Native-Standard.md](../../04_SCREEN_REFERENCES/home/HomePage-Flutter-Native-Standard.md) | SC-007 visual standard |
| [trading-bots-hub.md](trading-bots-hub.md) | Tier A reference |

**Phase 2 handoff:** copy khối cuối file vào chat mới sau khi Phase 1 pass gate.

---

## Design North Star

> **“Tin cậy trước, đơn giản trước, chuyên nghiệp luôn.”**

Hub Prediction Markets = **probability tier-1** (Polymarket / Kalshi pattern, không copy brand):
- Quét **≤3 giây**: sự kiện nổi bật, implied prob, bước tiếp theo.
- **Một CTA chính** / vùng; order/receipt ẩn sau event detail.
- **Probability-first** — **không** casino UI, hype, FOMO countdown.
- Người mới: category filter + event card rõ prob; micro-copy position/resolution.

---

## Personas & hành trình bắt buộc

Thiết kế phải pass cả 3 journey — ghi trong design spec STEP 2:

| Persona | Mục tiêu | Đường đi tối thiểu (≤3 bước tap) |
| --- | --- | --- |
| **Casual browser** | Khám phá sự kiện hot, hiểu probability | Hub → category chip → event card → detail |
| **Active participant** | Vào position nhanh | Hub → search hoặc breaking → event detail → preview order |
| **Research-focused user** | Lọc theo lịch / chủ đề | Hub → calendar hoặc search filter → event detail |

**Empty state bắt buộc:** filter không match — icon + headline + “Xóa bộ lọc” primary + link Breaking.

---

## Mục tiêu

1. **Audit** UI hub SC-027 + discovery cluster theo North Star + anti-patterns.
2. **Redesign** gọn, sang — hierarchy rõ như Home, density thấp.
3. **Giữ** enterprise compliance: `Vit*`, tokens, test keys, probability copy.
4. **Deliver** before/after spec verify bằng test + visual check 360px.

---

## Anti-patterns — phải loại bỏ

Audit và fix nếu còn tồn tại:

| Anti-pattern | Vì sao xấu | Hướng sửa |
| --- | --- | --- |
| Casino / hype copy (“All in”, “Jackpot”, emoji 🎰) | Trust fail, vi phạm accent | “Position”, “Xác suất”, “Biên độ” |
| Card trong card trên event row | Visual noise | Flat row + prob bar inline |
| >2 CTA trên event card (Yes/No + Share + Alert) | Overload | 1 tap → detail; actions trong detail |
| 3+ stat trên home hero | Khó đọc 360px | Hero **2 KPI** (open events + portfolio snapshot link) |
| Tab trong `VitCard` border | Drift AGENTS | Tab/filter ngoài card |
| Fake urgency (countdown giả, “limited slots”) | Dark pattern | Factual close time only |
| Local widget trùng `Vit*` | Không enterprise | Shared primitive |
| Magic spacing/radius | Drift | `AppSpacing` / `AppRadii` only |
| Arena bridge nhầm points wallet | Boundary leak | Bridge = discovery/context only |

---

## Phạm vi (scope)

### Trong scope — Phase 1 (`RD-R01`)

| Screen | SC | Path |
| --- | --- | --- |
| Predictions Home | `sc027PredictionsHome` | `lib/features/predictions/presentation/pages/predictions_home_page.dart` |
| Search | `sc028PredictionsSearch` | `lib/features/predictions/presentation/pages/predictions_search_page.dart` |
| Breaking | `sc029PredictionsBreaking` | `lib/features/predictions/presentation/pages/predictions_breaking_page.dart` |
| Event Detail | `sc030PredictionEventDetail` | `lib/features/predictions/presentation/pages/prediction_event_detail_page.dart` + parts |
| Event Calendar | `sc039PredictionEventCalendar` | `lib/features/predictions/presentation/pages/prediction_event_calendar_page.dart` |
| Test (gate) | — | `test/features/predictions/predictions_home_page_test.dart` |

### Ngoài scope Phase 1

Portfolio & social (`RD-R02`), tools/receipt/chart (`RD-R03`) — audit liệt kê link từ hub; redesign batch riêng.

### Không được làm

- Pub dependency mới.
- Đổi route, repository contract, order execution logic.
- Xóa/đổi `Key` test `PredictionsHomePage.*Key` / `sc027_*` nếu có.
- Redesign toàn module predictions trong một chat.
- Dark pattern: fake odds movement, neon hype, casino metaphors.

---

## Chuẩn thiết kế — map Home → Predictions

Mirror **cấu trúc** Home, **accent** probability (semantic buy/sell cho Yes/No — không casino chrome):

| Home (SC-007) | Predictions hub (SC-027) |
| --- | --- |
| Auto-hide header + scroll | Shared auto-hide scaffold — không local scaffold |
| Hero / balance summary | Hero: open events count + “Vị thế của tôi” link (2 KPI) |
| Primary next action | “Tìm sự kiện” / “Breaking” — 1 CTA above fold |
| Product grid / recent strip | Event cards — prob bar + title, scan được |
| Announcement / hint | 1 dòng risk/resolution disclaimer |
| Section rhythm `sectionGap` | Tối đa **3 section** above fold: Hero → Filter → List |
| Category chips / tab | `VitPresetChipRow` — **không** bọc trong `VitCard` border |
| Empty states có CTA | Empty filter + empty search results |
| `AppTextStyles.heroNumber` | Probability % dùng `numericCode`; title `sectionTitle` |
| Dark surfaces tokens | Không custom background ngoài tokens |

## IA & content hierarchy (360px)

```text
1. Header: "Prediction Markets" + subtitle (probability / events — 1 dòng)
2. Hero metrics (2 KPI) + search action
3. Category / filter chips
4. Breaking movers strip (optional, 1 row)
5. Event card list (prob bar + close time)
6. Footer: risk micro-disclaimer (positions ≠ guaranteed outcome)
```

**Event detail (SC-030):** title → prob → outcomes → preview order. **Calendar (SC-039):** date → dots → detail.

## Copy & tone (tiếng Việt)

- **Headline:** factual (“Thị trường dự đoán”, không “Casino Events”).
- **Label:** ≤3 từ (“Xác suất”, “Vị thế”, “Đóng lúc”).
- **CTA:** verb-first (“Xem sự kiện”, “Mở vị thế”, “Tìm kiếm”).
- **Được dùng:** probability, position, receipt, rewards, P/L (Prediction context), resolution.
- **Bắt buộc tránh:** cược, jackpot, all-in hype, “chắc thắng”, emoji casino, FOMO countdown giả.

---

## Financial / product safety (Prediction Markets)

- Preview và confirm trước mở/đóng position — không 1-tap trade từ home card.
- Hiển thị fees, limits, resolution rules trên event detail — không ẩn để “sạch UI”.
- Receipt flow (`RD-R03`) linked từ detail — không duplicate wallet withdraw copy.
- P/L và position size: màu semantic `buy`/`sell`; tabular figures.
- Wallet balance references chỉ khi flow cần funding — không hero wallet trên discovery hub.
- Arena bridge: topic/discovery only — không points/wallet merge.

---

## Quy trình thực thi

### STEP 0 — Khám phá (read-only)

2. Đọc hub + Home sections tương ứng (không paste full file).
3. Baseline: `flutter test test/features/predictions/predictions_home_page_test.dart --reporter=compact`

### STEP 1–2 — Audit + design spec

Bảng audit + clutter before (1–10) + wireframe + before/after (3 bullet) + persona 3/3 + component map. Audit thêm **probability-not-casino copy**. Không dừng hỏi user.

### STEP 3 — Implementation

- `impact()` trước mỗi symbol.
- Minimal diff; max **5–10 files**/chat — ưu tiên `predictions_home_page.dart` trước.
- Verify **360px** — prob bar + CTA không overflow.

### STEP 4 — Verification

```bash
dart format --output=none --set-exit-if-changed lib/features/predictions/presentation/pages/predictions_home_page.dart test/features/predictions/predictions_home_page_test.dart
flutter analyze
flutter test test/features/predictions/predictions_home_page_test.dart --reporter=compact
```

Test: category filter, event card tap, search/breaking nav (giữ `PredictionsHomePage.*Key`).

### STEP 5 — Self-check

`vittrade-minimal-review` · clutter ≤4/10 · zero casino/hype copy in diff.

---

## Acceptance criteria (Phase 1 gate)

- [ ] Audit + design spec + before/after + persona 3/3 trong chat.
- [ ] Clutter after ≤4/10 (giảm ≥3 vs before, hoặc before ≤4 thì giữ/improve).
- [ ] Above fold ≤3 section; event card ≤3 visual rows; prob readable at 360px.
- [ ] Empty filter state + primary CTA “Xóa bộ lọc” / Breaking link.
- [ ] **Zero casino/hype language** on touched surfaces.
- [ ] Visual language align Home + `Flutter-Native-Design-Standard`.
- [ ] 100% `Vit*` + theme tokens; no magic radius/spacing.
- [ ] `flutter analyze` clean; `predictions_home_page_test.dart` pass.
- [ ] No navigation regression từ Markets/Predictions module.
- [ ] Risk/resolution disclaimers không bị xóa để beautify.

**Completion line:** `PREDICTIONS HUB UI REDESIGN DONE — RD-R01`

---

## Phase 2 handoff prompt

```markdown
RESUME FROM: Phase 2 — Redesign Predictions portfolio & tools batches

Shell: docs/01_AI_RULES/AI_PROMPT_SHELL.md
Parent: docs/02_FLUTTER_MIGRATION/prompt-redesign/predictions-hub.md (v1)

North Star + anti-patterns + Home map + **probability-not-casino** rules trong parent vẫn áp dụng.
Scope batch: RD-R02 (portfolio/social) hoặc RD-R03 (receipt/tools) — 2–6 file + tests.
Persona: giữ casual browser empty states; active participant preview/confirm on trade flows.

Completion: PREDICTIONS SUB-PAGES UI REDESIGN DONE — <batch_id>
```
