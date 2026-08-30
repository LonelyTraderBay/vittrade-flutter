# Execution Prompt — Redesign UI Open Arena Hub (SC-184)

**Version:** 1.0  
**Batch:** `RD-A01`  
**Accent:** Points-only — **CRITICAL:** no wallet / payout / profit / stake language ([AGENTS.md](../../../AGENTS.md) Open Arena boundary)  
**Shell contract:** [AI_PROMPT_SHELL.md](../../01_AI_RULES/AI_PROMPT_SHELL.md) — không lặp boilerplate shell.

**Design authority:**

| File | Vai trò |
| --- | --- |
| [AGENTS.md](../../../AGENTS.md) | Product boundaries, UI rules, points-only copy |
| [DESIGN.md](../../../DESIGN.md) | Tokens, component ladder |
| [Flutter-Native-Design-Standard.md](../standards/Flutter-Native-Design-Standard.md) | Trust-first, no dark patterns |
| [HomePage-Flutter-Native-Standard.md](../../04_SCREEN_REFERENCES/home/HomePage-Flutter-Native-Standard.md) | SC-007 visual standard |
| [trading-bots-hub.md](trading-bots-hub.md) | Tier A reference |

**Phase 2 handoff:** copy khối cuối file vào chat mới sau khi Phase 1 pass gate.

---

## Design North Star

> **“Tin cậy trước, đơn giản trước, chuyên nghiệp luôn.”**

Hub Open Arena = **nền tảng thử thách cộng đồng tier-1** (Strava Challenges pattern, không copy brand):
- Quét **≤3 giây**: điểm Arena, thử thách mở, bước tiếp theo.
- **Một CTA chính** / vùng; Studio tools ẩn sau tap — không nhồi home card.
- **Points-only:** completion, fair play, ledger — **không** ví/payout/profit/stake.
- Người mới: empty state + “Tham gia” / “Tạo phòng”; micro-copy 1 dòng mỗi thuật ngữ.

---

## Personas & hành trình bắt buộc

Thiết kế phải pass cả 3 journey — ghi trong design spec STEP 2:

| Persona | Mục tiêu | Đường đi tối thiểu (≤3 bước tap) |
| --- | --- | --- |
| **Creator** | Tạo thử thách / preset an toàn | Hub → Studio → Smart Rules hoặc Preset Library → publish gate |
| **Participant** | Tham gia phòng nhanh | Hub → chọn mode / room card → Join |
| **Casual browser** | Hiểu Arena là gì, không bị overwhelm | Hub → Guide teaser hoặc verified strip → 1 CTA “Khám phá” |

**Empty state bắt buộc:** khi không có room/mode phù hợp — icon + headline points-only + 1 CTA primary + link “Xem hướng dẫn” (`/arena/guide`).

---

## Mục tiêu

1. **Audit** UI hub SC-184 + studio cluster theo North Star + anti-patterns.
2. **Redesign** gọn, sang — hierarchy rõ như Home, density thấp.
3. **Giữ** enterprise compliance: `Vit*`, tokens, test keys, **points-only** copy.
4. **Deliver** before/after spec verify bằng test + visual check 360px.

---

## Anti-patterns — phải loại bỏ

Audit và fix nếu còn tồn tại:

| Anti-pattern | Vì sao xấu | Hướng sửa |
| --- | --- | --- |
| Wallet / payout / profit / stake copy | Vi phạm Open Arena boundary | Chỉ “điểm Arena”, “completion”, “fair play” |
| Card trong card (`VitCard` lồng stat mini) | Visual noise | Flat row + divider |
| >2 action cùng hàng trên challenge card | Cognitive overload | 1 primary + overflow menu |
| 3+ metric trên hero summary | Khó đọc 360px | Hero **2 KPI** (điểm + active challenges) |
| Tab trong `VitCard` border | Drift AGENTS | Tab ngoài card |
| Local widget trùng `Vit*` | Không enterprise | Shared primitive |
| Magic spacing/radius | Drift design system | Chỉ `AppSpacing` / `AppRadii` |
| Casino / hype UI (countdown giả, neon) | Trust fail | Factual status pills |
| Bridge copy nhầm Prediction wallet | Boundary leak | Bridge = topic/context only |

---

## Phạm vi (scope)

### Trong scope — Phase 1 (`RD-A01`)

| Screen | SC | Path |
| --- | --- | --- |
| Arena Home | `sc184ArenaHome` | `lib/features/arena/presentation/pages/arena_home_page.dart` + `part_01`…`part_03` |
| Arena Studio | `sc185ArenaStudio` | `lib/features/arena/presentation/pages/arena_studio_page.dart` |
| Smart Rules | `sc186ArenaSmartRules` | `lib/features/arena/presentation/pages/arena_smart_rule_builder_page.dart` |
| Preset Library | `sc187ArenaPresetLibrary` | `lib/features/arena/presentation/pages/arena_universal_preset_library_page.dart` |
| Governance Gate | `sc188ArenaGovernanceGate` | `lib/features/arena/presentation/pages/arena_governance_gate_page.dart` |
| Guide | `sc209ArenaGuide` | `lib/features/arena/presentation/pages/arena_guide_page.dart` |
| Test (gate) | — | `test/features/arena/arena_home_page_test.dart` |

### Ngoài scope Phase 1

Challenge flow (`RD-A02`), points/ledger (`RD-A03`), safety/trust (`RD-A04`), production bridges (`RD-A05`) — audit liệt kê link từ hub; redesign batch riêng.

### Không được làm

- Pub dependency mới.
- Đổi route, repository contract, points ledger logic.
- Xóa/đổi `Key` test `ArenaHomePage.*Key` / `sc184_*` nếu có.
- Redesign toàn module Arena trong một chat.
- Dark pattern hoặc **bất kỳ** copy wallet/payout/profit/stake.

---

## Chuẩn thiết kế — map Home → Open Arena

Mirror **cấu trúc** Home, **accent** module Arena (points, completion — không financial orange hype):

| Home (SC-007) | Open Arena hub (SC-184) |
| --- | --- |
| Auto-hide header + scroll | `VitTopChrome` / shared auto-hide — không local scaffold |
| Hero / balance summary | Hero: **Arena Points balance** + active challenges (2 số) |
| Primary next action | “Tham gia” / “Tạo thử thách” / “Mở Studio” — 1 CTA above fold |
| Product grid / recent strip | Mode cards + live rooms — height đồng nhất |
| Announcement / hint | 1 dòng fair-play hoặc link Guide |
| Section rhythm `sectionGap` | Tối đa **3 section** above fold: Hero → Filter/Tab → Content |
| `VitSegmentedTabBar` / tab | Tab mode/category — **không** bọc trong `VitCard` border |
| Empty states có CTA | Empty rooms + empty creator state |
| `AppTextStyles.heroNumber` | Points dùng `heroNumber`; title `sectionTitle` |
| Dark surfaces tokens | Không custom background ngoài tokens |

## IA & content hierarchy (360px)

```text
1. Header: "Open Arena" + subtitle (completion / fair play — 1 dòng)
2. Hero metrics (2 KPI): điểm Arena + thử thách đang mở
3. Primary CTA (full-width)
4. Segmented filter / category chips (if any)
5. Mode cards → room list / verified teaser
6. Footer: fair-play micro-copy + link Guide (points-only)
```

**Studio (SC-185→188):** tool list → builder detail; governance gate = confirm trước publish.

## Copy & tone (tiếng Việt)

- **Headline:** lợi ích completion (“Thử thách cộng đồng”, không “Arena Module”).
- **Label:** ≤3 từ (“Điểm Arena”, “Đang mở”, “Hoàn thành”).
- **CTA:** verb-first (“Tham gia”, “Tạo phòng”, “Mở Studio”).
- **Bắt buộc tránh:** ví, rút tiền, lợi nhuận, stake, payout, ROI, “kiếm tiền”.
- **Được dùng:** điểm, completion, fair play, leaderboard (Arena context), preset, rule.

---

## Financial / product safety (Open Arena)

- **Currency = Arena Points only** — không hiển thị USDT/BTC balance trên hub.
- Performance = **points pool / completion** — không PnL trading language trên Arena surfaces.
- History = **ledger entries** — không order/receipt wallet copy.
- Bridge sang Predictions: topic/category/context only — không gộp wallet UI.
- Governance gate: preview rules + confirm trước publish — không skip để “làm gọn”.
- Report / safety links giữ nguyên nếu route có — không xóa để beautify.

---

## Quy trình thực thi

### STEP 0 — Khám phá (read-only)

2. Đọc hub parts + Home sections tương ứng (không paste full file).
3. Baseline: `flutter test test/features/arena/arena_home_page_test.dart --reporter=compact`

### STEP 1–2 — Audit + design spec

Bảng audit + clutter before (1–10) + wireframe + before/after (3 bullet) + persona 3/3 + component map. Audit thêm **points-only copy**. Không dừng hỏi user.

### STEP 3 — Implementation

- `impact()` trước mỗi symbol.
- Minimal diff; max **5–10 files**/chat — ưu tiên `arena_home_page*` trước, studio cluster nếu còn slot.
- Verify **360px** — không overflow CTA/label chính.

### STEP 4 — Verification

```bash
dart format --output=none --set-exit-if-changed lib/features/arena/presentation/pages/arena_home_page*.dart test/features/arena/arena_home_page_test.dart
flutter analyze
flutter test test/features/arena/arena_home_page_test.dart --reporter=compact
```

Test: template/mode tap, create challenge, leaderboard teaser (giữ `ArenaHomePage.*Key`).

### STEP 5 — Self-check

`vittrade-minimal-review` · clutter ≤4/10 · zero wallet/payout copy in diff.

---

## Acceptance criteria (Phase 1 gate)

- [ ] Audit + design spec + before/after + persona 3/3 trong chat.
- [ ] Clutter after ≤4/10 (giảm ≥3 vs before, hoặc before ≤4 thì giữ/improve).
- [ ] Above fold ≤3 section; challenge card ≤3 visual rows.
- [ ] Empty state beginner-friendly + primary CTA + Guide link.
- [ ] **100% points-only copy** on touched surfaces — no wallet/payout/profit/stake.
- [ ] Visual language align Home + `Flutter-Native-Design-Standard`.
- [ ] 100% `Vit*` + theme tokens; no magic radius/spacing.
- [ ] `flutter analyze` clean; `arena_home_page_test.dart` pass.
- [ ] No navigation regression từ Arena module.
- [ ] Fair-play / governance disclaimers không bị xóa.

**Completion line:** `ARENA HUB UI REDESIGN DONE — RD-A01`

---

## Phase 2 handoff prompt

```markdown
RESUME FROM: Phase 2 — Redesign Arena challenge flow & points batches

Shell: docs/01_AI_RULES/AI_PROMPT_SHELL.md
Parent: docs/02_FLUTTER_MIGRATION/prompt-redesign/arena-hub.md (v1)

North Star + anti-patterns + Home map + **points-only** rules trong parent vẫn áp dụng.
Scope batch: RD-A02 (challenge flow) hoặc RD-A03 (points/ledger) — 2–6 file + tests.
Persona: giữ creator + participant journey; casual browser empty states on join/detail.

Completion: ARENA SUB-PAGES UI REDESIGN DONE — <batch_id>
```
