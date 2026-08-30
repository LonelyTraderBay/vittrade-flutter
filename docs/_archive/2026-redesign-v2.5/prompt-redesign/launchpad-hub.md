# Execution Prompt — Redesign UI Launchpad Hub (SC-295)

**Version:** 1.0  
**Batch:** `RD-L01`  
**Accent:** IDO participation  
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

Hub Launchpad phải cảm giác như **IDO/Launchpad tier-1** (Binance Launchpad / Coinbase Launch — **pattern**, không copy brand):
- **IDO participation:** user thấy ngay dự án active, trạng thái, bước tham gia — không wall of tools.
- **Trust-first:** risk/safety section giữ visible; không countdown giả, không “guaranteed return”.
- **Progressive disclosure:** advanced/risk tools gom section phụ — không nhồi hero.
- **One primary action** mỗi project card: “Tham gia” / “Xem chi tiết” — không 3 CTA cạnh tranh.

---

## Personas & hành trình bắt buộc

| Persona | Mục tiêu | Đường đi tối thiểu (≤3 bước tap) |
| --- | --- | --- |
| **Người mới** | Hiểu Launchpad + xem dự án đầu tiên | Hub → hero → tab All → project card → join/detail |
| **User thường** | Tham gia IDO đang active | Hub → filter active → join CTA |
| **User nâng cao** | Portfolio + performance | Hub → portfolio/performance actions → sub-route |

**Empty state bắt buộc:** tab filter không có project — headline + CTA “Xem tất cả” hoặc quay tab All (mock hỗ trợ `LaunchpadScreenState.empty`).

---

## Mục tiêu

1. **Audit** UI hub SC-295 theo North Star + anti-patterns bên dưới.
2. **Redesign** gọn, sang — hierarchy như Home, density thấp; accent module `AppModuleAccents.launchpad`.
3. **Giữ** enterprise compliance: `Vit*`, tokens, test keys `sc295_launchpad_*`, `launchpadControllerProvider`.
4. **Deliver** before/after spec verify bằng test + visual check 360px.

---

## Anti-patterns — phải loại bỏ

| Anti-pattern | Vì sao xấu | Hướng sửa |
| --- | --- | --- |
| 8+ tool tiles above projects | Mất focus IDO | Tools sau project list hoặc collapsed section |
| Project card >3 rows metrics | Khó scan | Status + name + 2 KPI + 1 CTA |
| Tab trong `VitCard` border | Drift AGENTS | `VitTabBar` / segmented ngoài card |
| Hype language (“100x”, “Last chance”) | Regulatory/trust fail | Factual status + dates |
| Local duplicate launchpad widgets | Enterprise fail | Shared `Vit*` + existing part files |
| Magic line-height/spacing constants | Drift | `AppSpacing.launchpad*` tokens |
| Ẩn safety/risk để “đẹp” | Financial safety fail | Giữ `safetyKey` section |

---

## Phạm vi (scope)

### Trong scope — Phase 1 (batch `RD-L01`)

| Mục | Path |
| --- | --- |
| Hub | `lib/features/launchpad/presentation/pages/launchpad_page.dart` |
| Parts | `launchpad_home_*.dart` (header, project, tool, shared, helpers) |
| Test | `test/features/launchpad/launchpad_page_test.dart` |

### Ngoài scope Phase 1

Performance, portfolio, staking, subscribe/claim flows — audit link từ hub; Phase 2 (`RD-L02`…).

### Không được làm

- Pub mới · đổi route/repository · xóa/đổi `Key` `sc295_launchpad_*` · dark patterns (fake scarcity, guaranteed ROI).

---

## Chuẩn thiết kế — map Home → Launchpad

| Home (SC-007) | Launchpad hub (SC-295) |
| --- | --- |
| Auto-hide header | `VitAutoHideHeaderScaffold` + top chrome |
| Hero summary | Hero active projects count + subtitle |
| Primary actions | Filter / Performance / Portfolio icon actions |
| Segmented discovery | Tabs All / Active / Upcoming / Ended |
| Product cards | Project cards — uniform height, join CTA |
| Trust strip | Safety + risk tools sections |
| Section rhythm | ≤3 sections above fold: Hero → Tabs → Projects |

### Component ladder

`VitCard`, `VitCtaButton`, `VitTabBar`, `VitStatusPill`, `VitHeaderActionButton`, `VitAutoHideHeaderScaffold` — trước local widgets.

## IA & content hierarchy (360px)

```text
1. Header: "Launchpad" + subtitle (Dự án mới · Token Launch)
2. Hero (active count + short value prop)
3. Header actions: filter | performance | portfolio
4. Segmented tabs
5. Project list (cards)
6. Staking promo (if data)
7. Advanced tools (collapsed/grouped)
8. Risk tools + safety disclaimer
```

**Project card target:** logo + name + status pill | allocation/progress | 1 join CTA (`joinKey`).

---

## Copy & tone

- Headline: participation (“Khám phá dự án token mới”), không “IDO Module”.
- Status factual: “Đang diễn ra”, “Sắp mở”, “Đã kết thúc”.
- CTA: “Tham gia”, “Xem chi tiết”, “Ví Launchpad”.
- Tránh: guaranteed profit, lottery hype, emoji.

---

## Financial / product safety

- Participation flows cần preview/confirm ở sub-routes — hub chỉ entry, không skip risk.
- Points/wallet boundaries: launchpad dùng wallet context — không lẫn Arena points copy.
- Giữ contract notes / supported states visible trong dev QA; không xóa error/offline handling.
- Join CTA không auto-submit — navigate hoặc sheet confirm tùy flow hiện có.

---

## Quy trình thực thi

### STEP 0 — Khám phá


```bash
cd flutter_app
flutter test test/features/launchpad/launchpad_page_test.dart --reporter=compact
```

### STEP 1–2 — Audit + spec

Bảng P0–P2 + clutter before; wireframe, before/after, persona 3/3, component map. **Không dừng hỏi user.**

### STEP 3 — Implementation

`impact()` trước edit. Giữ tab filter, header routes, nav clearance. Verify 360px scroll.

### STEP 4 — Verification

```bash
dart format --output=none --set-exit-if-changed lib/features/launchpad/presentation/pages/launchpad_page.dart lib/features/launchpad/presentation/widgets/launchpad_home*.dart test/features/launchpad/launchpad_page_test.dart
flutter analyze
flutter test test/features/launchpad/launchpad_page_test.dart --reporter=compact
```

Test cover (giữ `sc295_launchpad_*`): mock snapshot, tab switch, project visibility, header actions, safety section.

### STEP 5 — Batch self-check

`vittrade-minimal-review` · clutter after ≤4/10.

---

## Acceptance criteria (Phase 1 gate)

- [ ] Audit + spec + persona 3/3 trong chat.
- [ ] Clutter after ≤4/10; projects above tools in visual priority.
- [ ] Project card ≤3 rows + 1 primary CTA.
- [ ] Safety/risk sections retained.
- [ ] 100% `Vit*` + tokens; `flutter analyze` clean; tests pass.
- [ ] No launchpad navigation regression.

**Completion line:** `LAUNCHPAD HUB UI REDESIGN DONE — RD-L01`

---

## Batch discipline

Max **5–10 files**/chat · Phase 1 = hub only · Codex · STEP 0→5 liên tục.

---

## Phase 2 handoff

```markdown
RESUME FROM: Phase 2 — Launchpad sub-pages
Parent: docs/02_FLUTTER_MIGRATION/prompt-redesign/launchpad-hub.md
Completion: LAUNCHPAD SUB-PAGES UI REDESIGN DONE — <batch_id>
```
