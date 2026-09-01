# Tablet Spacing & Gutter Standard (Mandatory)

**Authority:** [DESIGN.md](../../../DESIGN.md) Layout · [AGENTS.md](../../../AGENTS.md) UI rules · [Page-Rhythm-Standard.md](./Page-Rhythm-Standard.md) (vertical page rhythm) · [Tablet-Card-Border-Standard.md](./Tablet-Card-Border-Standard.md)
**Enforcement:** `dart run tool/tablet_spacing_audit.dart --check` · `test/quality/tablet_spacing_guardrail_test.dart` (**absolute lock — zero baseline**) · `test/quality/tablet_base8_role_scale_guardrail_test.dart` (**closed role/value contract**) · `test/quality/tablet_module_role_scale_guardrail_test.dart` (**module/shared token mapping and no Phone-role leakage**) · `test/quality/tablet_gap_12_guardrail_test.dart` (**Rule 6 — major block gaps 12dp dọc+ngang, zero-tolerance, no baseline**) · `test/quality/tablet_icon_size_guardrail_test.dart` (S5 — icon-size literal ratchet) · `test/quality/tablet_fullbleed_guardrail_test.dart` (S6 — gutter-flush ratchet) · `test/quality/tablet_pane_child_vertical_inset_guardrail_test.dart` (S7 — pane-child vertical-inset lock) · `test/quality/tablet_token_override_guardrail_test.dart` (Rule 5 — co-location · no-leakage · exact-set ratchet)
**Scope:** every Dart file under `lib/` on the **tablet surface** (path contains `/tablet/`, or the file name mentions `tablet`).
**Born:** 2026-08-22 — companion to the Tablet Card & Border Standard; locks the "which gap, which token" decision so tablet screens stop drifting optically page-to-page.

## Why this standard exists

The tablet call-site layer is tokenized — a 2026-08-22 sweep found **zero** numeric literals in `SizedBox` gaps, `EdgeInsets` insets, or stroke thicknesses (the only three stragglers, `Divider(height: 1)`, were migrated on the spot). The module/shared layer still needs separate surface-aware mapping, so `tablet_module_role_scale_guardrail_test.dart` locks those explicit bridges and rejects Phone-role leakage. What was *not* written down is **which token each spacing role must use**: pages picked `x4` vs `x5` vs `columnGutter` by feel, so identical roles rendered at different gaps on different panes (the master-detail gutter-stacking bug of commit `4a171046` was exactly this class of drift). This standard fixes the role→token map and locks the zero-literal state so drift cannot creep back.

## Rule 1 — The spacing scale is role-based

Tablet uses a **closed Base-8-derived role scale** on a 4dp alignment
substrate: `x1=4 · x2=4 · x3=8 · x4=12 · x5=24 · x6=32 · x7=56` (plus
`contentPad=20`, `pageEndBreathing=32`, `rowGap=8`, `cardGap=12`,
`dividerHairline=1`). The 4dp substrate does **not** authorize arbitrary
values such as 28, 36, 40 or 48 at call sites. Phone keeps the independent
Fibonacci scale in `AppSpacing`.

| Role on the tablet surface | Token | Value |
| --- | --- | --- |
| Micro gap (pill↔pill in a Wrap, icon↔label) | `TabletSpacingTokens.x1`–`x2` | 4 |
| Item gap (rows/chips/cards inside a section) | `TabletSpacingTokens.rowGap` | 8 |
| Section inner gap (header→body, compact tier) | `TabletSpacingTokens.pageRhythmCompactInnerGap` | 4 |
| Section inner gap (standard/form tier) | `TabletSpacingTokens.pageRhythmStandardInnerGap` | 12 |
| Form field / inline item stack | `TabletSpacingTokens.pageRhythmFormInnerGap` or `rowGap` | 8 |
| Section gap (between blocks in a scroll) | `TabletSpacingTokens.pageContentGapTight` via `VitPageContent(rhythm: compact)` or `pageRhythmStandardSectionGap` via `standard/form/relaxed` | 8 compact / 12 standard-form-relaxed |
| Icon→text inside a tile/card row | `TabletSpacingTokens.x3` | 8 |
| Between sibling cards in a column | `TabletSpacingTokens.cardGap` | 12 |
| Inside-card padding | `VitCard` variant/density defaults (`density.cardPadding`) | 12 / 16 / 24 by density |
| Tile strip padding (Tier A) | module token sourced from `TabletSpacingTokens` | role-specific |

### Closed role/value contract

The public Tablet scale is role-based, not a free-form 4dp grid:

| Role | Allowed value | Rule |
| --- | ---: | --- |
| Micro | 4dp | `x1`/`x2`; only inside a compact control or inline cluster |
| Item / compact section | 8dp | `x3`/`rowGap`/`pageContentGapTight` |
| Block / panel / card sibling / gutter | 12dp | `x4`/`cardGap`/`pageRhythmStandardSectionGap` |
| Standard card padding | 16dp | card/density padding only |
| Relaxed / hero padding | 24dp | card/hero padding only, never a block gap |
| Content edge inset | 20dp | `contentPad` only |
| Page-end breathing | 32dp | `pageEndBreathing` only, never between blocks |
| Extended component metric | 56dp | `x7`; fixed visual extent only, never a gap |

`x1` and `x2` intentionally converge at 4dp because they name two distinct
micro roles, not two additional values. `16dp` is a named standard-card
padding role and is not exposed as another `xN` alias.

Control sizes, icon sizes, data-row extents and border metrics are separate
metrics. They do not expand the spacing whitelist.

**Never** re-derive a gap from another scale step "because it looks close" — pick by role, not by eye. When two roles genuinely need a new number, add a named token to `TabletSpacingTokens`/module spacing (with a role comment), never a literal at the call site.

## Rule 2 — Horizontal gutters of the tablet frame

All tablet frame geometry comes from `TabletDashboardWidths` (`lib/app/theme/tablet_dashboard_widths.dart`) — do **not** re-declare these numbers anywhere else:

| Geometry | Token | Value |
| --- | --- | --- |
| Nav rail width | `VitNavigationRail.width` | 96 |
| Screen edge → dashboard block (each side) | `outerHorizontalMargin` | 12 |
| Gutter between the two dashboard columns | `columnGutter` | 12 |
| Two-column threshold (below → single column) | `twoColumnMinWidth` | 900 |
| Primary/secondary column caps | `primaryColumnMaxWidth` / `secondaryColumnMaxWidth` | 800 / 400 |
| Vertical breathing above/below the block | `blockVerticalGap` | 12 |

Consequences (learned the hard way — commit `4a171046`):

- Pane content inside a master-detail/two-column layout is **gutter-flush**: `VitPageContent(fullBleed: true)` + `VitHeader(horizontalPadding: TabletSpacingTokens.zero)`. Stacking the default `contentPad` on top of `columnGutter` yields a 44px gap — double the rail→menu margin — and reads as broken alignment.
- A page needing different frame numbers keeps a **page-local override** in its own widget call — never edits the shared tokens (R8 safety margin, see the doc comment in `tablet_dashboard_widths.dart`).

## Rule 3 — Lines: hairline only, token-locked

- Every divider/separator stroke is a **1px hairline**: `Divider(height: TabletSpacingTokens.dividerHairline)` (plus its color token). `thickness:` literals are forbidden; card border strokes stay at VitCard's default 1px side (see the Card & Border standard).
- Accent bars that accompany section labels use a named module/Tablet token — never a hand-rolled `width: 3/4`.

## Rule 4 — Absolute lock: no numeric spacing literals

In tablet files, every dimension must be a token reference:

- `SizedBox(height: 12)` → `SizedBox(height: TabletSpacingTokens.x4)` (S1)
- `EdgeInsets.all(16)` / `EdgeInsets.only(top: 24)` → token-based insets (S2)
- `thickness: 2`, `Divider(height: 1)` → `TabletSpacingTokens.dividerHairline` (S3)
- **No element-level separator SizedBox in a rhythm-owning scaffold's children (S4, token-blind):** `ProfilePaneScaffold(children:)` and `VitTwoColumnTabletDashboard(primaryChildren:/secondaryChildren:)` wrap their children in `VitPageContent(rhythm:)`, which already inserts the section gap between every pair — a `SizedBox` standing as a direct child of those lists stacks onto it (12+12). Children stay flat; a heading/content pair with a tighter inner gap is ONE child widget (the loaded sidebar's `VitTradeSection` pattern), never two children with a SizedBox between them. The scanner checks every children argument of every scaffold occurrence and is token-blind — even a tokenized separator is a violation.
- **Icon size must be a token (S5):** `Icon(size: 14)`-style literals were a scanner blind spot (S1–S3 cover only SizedBox/EdgeInsets/thickness) — found live in Markets token-info (14/14/15 while the scale is iconSm 13 / iconMd 21). Enforced by `test/quality/tablet_icon_size_guardrail_test.dart`: any `size:` numeric literal in a tablet file fails CI, except 4 legacy hero-status icons (auth 56/72, wallet 144) pinned in the test's exact-set baseline — migrate on touch, never add.
- **Detail content of a master-detail shell is gutter-flush (S6):** a page/pane/skeleton rendering inside the shell's detail column must declare `VitPageContent(fullBleed: true)` (+ `density: compact`, header `horizontalPadding: TabletSpacingTokens.zero`) — the shell already owns `outerHorizontalMargin` and `blockVerticalGap`; skipping `fullBleed` double-stacks both (the 2026-08-28 Markets overview bug: 68dp stacked top breathing + 40px horizontal offset vs the master frame — same class as the 4a171046 gutter-stacking bug). Hub routes and utility surfaces that bypass `*PaneScaffold` are the risky ones. Enforced by `test/quality/tablet_fullbleed_guardrail_test.dart`: every `VitPageContent(` in a tablet file must declare top-level `fullBleed:`; 5 wrappers that legitimately own their own gutter (Profile master menu + its skeleton/error, both `VitTwoColumnTabletDashboard` wrappers) are pinned in the exact-set baseline.
- **Pane/dashboard children carry no vertical inset (S7, token-blind):** `MarketsPaneScaffold(children:)`, `ProfilePaneScaffold(children:)` and `VitTwoColumnTabletDashboard(primaryChildren:/secondaryChildren:)` own the vertical rhythm — `VitPageContent(rhythm:)` already inserts the section gap (12dp standard tier) between every pair of children. A `Padding` wrapper standing as a direct child whose padding has a positive vertical component (a Phone-page margin token like `pairRiskMargin` 10/13, `pairTradeCtaPadding` …/16, or any `EdgeInsets.all`/`only(top:)`/`fromLTRB(…, >0, …, >0)`) stacks onto that gap and breaks the page rhythm — the 2026-08-29 pair-detail pane bug: gaps rendered at 23–29dp instead of 12dp, with the two link cards squeezed at 8dp in between. Direct-child wrappers must be horizontal-only: `EdgeInsets.symmetric(horizontal: TabletSpacingTokens.contentPad)`, `EdgeInsetsDirectional.only(start:…, end:…)`, `fromLTRB(x, 0, x, 0)`, `.zero`, or a token in the guardrail's exact-set allowlist (`MarketsSpacingTokens.pairPaneChildFlushPadding` — value-locked to `symmetric(horizontal: contentPad)` by its own test; adding a token requires bumping the allowlist + value lock in the same commit). End-of-scroll breathing lives INSIDE the last widget (the `_Disclaimer` / `_PairTradeCtas` pattern), never in the children list. **Porting Phone content into a tablet pane is a re-compose, not a copy**: every vertical margin the Phone page owned must be dropped at the port boundary — the tablet scaffold is the single source of vertical truth. Enforced by `test/quality/tablet_pane_child_vertical_inset_guardrail_test.dart` (scans every children/primaryChildren/secondaryChildren list of the three scaffolds, unwraps `if (cond)` elements, and is token-blind — even a tokenized Phone margin fails).

The guardrail is **zero-tolerance with no baseline** — the surface is clean today and any new literal fails CI outright. (Token references like `TabletSpacingTokens.x5` never trip the scanner: the digit is glued to a word character.)

## Rule 5 — Per-surface token overrides are exceptional (the 5 conditions)

The token system does not fork an entire module into two duplicated sets.
Phone and Tablet intentionally have separate geometric namespaces where their
surface contracts differ: Phone keeps `AppSpacing`, while Tablet uses
`TabletSpacingTokens`. Module-semantic roles remain shared where the value is
truly common. Per-surface differences ride on four sanctioned layers, tried
in this order:

1. **Context tiers** — `VitDensity` / `VitPageRhythm` picked per page
   (compact / standard / form / relaxed / flush); the same enums serve both
   surfaces, so density changes stay page-context decisions.
2. **Surface geometry namespace** — `TabletSpacingTokens` owns the Tablet
   spacing scale and shared Tablet layout metrics; it must never be imported
   by Phone presentation code.
3. **Frame tokens** — `TabletDashboardWidths` owns tablet-only geometry
   (thresholds, master width, gutters). It is a tablet namespace, not a set
   of overrides of phone values.
4. **Local tablet-override token** — the exception. A module spacing token
   whose name contains `Tablet` is legitimate only when ALL five conditions
   hold:

| # | Condition |
| --- | --- |
| 1 | Same role on both surfaces — it overrides an existing token's value; it never introduces a new role |
| 2 | The difference is permanent and form-factor-intrinsic, not a tuning pass |
| 3 | Not expressible via a tier or a frame token — those levers were tried first |
| 4 | Co-located + co-named: declared in the same module token file right next to its phone counterpart, with `Tablet` inserted into the counterpart's name (`profileMenuIconBox` → `profileMenuTabletIconBox`) |
| 5 | A dated doc comment states the rationale and both surface values, and the guardrail baseline is bumped in the same commit |

Audit snapshot (2026-09-01): **3 local override tokens** —
`profileMenuTabletIconBox=32` / `profileMenuTabletIcon=18` against phone
`36/20`, plus `profileApiCreateTabletExpiryExtent=67` against phone `62`.
These are referenced exclusively from tablet files and their phone
counterparts stay live in the mirrored phone files. Enforced by
`test/quality/tablet_token_override_guardrail_test.dart`: co-location (T1),
no phone-side leakage (T2), exact-set ratchet on the baseline (T3).

Page-local frame constants (Rule 2) are **not** overrides and stay sanctioned;
promote a value into `TabletDashboardWidths` before a fourth module copies it
(the `_compactBreakpoint = 760` trio in home/markets/profile sat at the limit
as of 2026-08-27).


## Rule 6 — Base-8-derived: gap khối DỌC VÀ NGANG = 12

> **Migration 2026-09-01 (hướng A user duyệt):** Tablet chuyển sang hệ
> Base-8-derived — thang 4·8·12·16·24·32·56 sống trong
> `TabletSpacingTokens`; con số luật đổi 13 → 12 (không thể nhận ra bằng
> mắt), mọi nhịp giờ khớp widget Material (4/8/16/24). Phone giữ thang
> Fibonacci cũ qua `AppSpacing` — hai surface hai namespace, độc lập.

**Born:** 2026-08-31 — product-owner decision sau lỗi nhịp lệch của Trade
terminal SC-048 (label→nội dung chạy từ 8 → 44dp giữa các panel do padding
chồng 2 lớp cùng token + header cột + không có hợp đồng mép→nội dung). Luật
thắng Rule 1 cho **khoảng trắng dọc dạng gap** trong code tablet; các role
vi mô của Rule 1 (leading hàng, icon↔chữ trong cùng một hàng) không thuộc
phạm vi vì đó không phải khoảng trắng giữa các khối.

| Phát biểu | Chi tiết |
| --- | --- |
| **Áp cho** | Gap khối DỌC VÀ NGANG giữa panel, section, card sibling, frame, gutter, mép panel→nội dung đầu và nhãn→nội dung trong file tablet |
| **Giá trị duy nhất** | `12` — qua `TabletSpacingTokens.x4` / `.cardGap` / `.pageRhythmStandardSectionGap` (namespace tablet) hoặc token module terminal cùng nguồn |
| **Ngoài phạm vi** | Micro gap 4dp, item/row/compact section gap 8dp, compact inner gap 4dp, extent/leading của hàng dữ liệu (24–26dp), kích thước control/icon, border/hairline, chart height, touch-target và card/panel inset padding |
| **Một khoảng = một lớp** | Cấm chồng: label padding bottom 12 **HOẶC** child padding top 12 — không bao giờ cả hai. Body của panel phẳng chỉ inset ngang; khoảng dọc do đúng một lớp đảm nhiệm |
| **Đo theo flow** | Khoảng đo từ mép khối đến mép khối kế theo trục flow (RenderBox). Phần tử thấp hơn bị `crossAxisAlignment.center` làm lệch tâm trong một hàng không tính là gap |

Enforcement hai lớp:

1. **Nguồn (zero-tolerance, KHÔNG baseline):**
   `test/quality/tablet_gap_12_guardrail_test.dart` — mọi SizedBox
   KHÔNG child (khe) với `height:`/`width:` trong thư mục tablet phải dùng
   token Role Scale. Gap khối phải là 12; micro/item gap được phép là 4/8
   qua `x1`/`x2`/`x3` tương ứng. Literal ngoài scale fail CI ngay lập tức.
2. **Đo thật (layout-lock):** mỗi module đã chuyển sang luật 12 phải có
   test RenderBox đo mọi cặp kề == 12.0 — bản mẫu:
   `test/features/trade/trade_terminal_gap_12_lock_test.dart`
   (gutter + mép→nội dung + nhãn→nội dung + khối↔khối, ±0.1dp).

Trạng thái: **TOÀN BỘ surface tablet đã sweep xong (2026-09-01)** —
mọi gap khối SizedBox dọc+ngang = 12, micro/item gap dùng đúng role 4/8, khung dashboard
(columnGutter 24→12, blockVerticalGap 16→12, outerHorizontalMargin
20→12). Widget dùng CHUNG phone+tablet (vd `VitTradeSimpleOrderForm`,
tier `VitPageContent(rhythm:)` compact 8dp) nằm ngoài phạm vi cho tới khi
có quyết định riêng cho phone surface — đây là RANH GIỚI đã biết duy
nhất của luật.

## Anti-patterns

| Anti-pattern | Why |
| --- | --- |
| `SizedBox(height: 10)` "just this once" | 10 is on no scale; next page picks 12 |
| `contentPad` stacked on `columnGutter` | Double gutter (44px) — the master-detail bug |
| Editing `TabletDashboardWidths` for one page | Shifts the proven R8 margin for every page |
| New gap = nearest scale step by eye | Role decides the token (Rule 1), not eyeballing |
| `Divider(height: 1)` literal | Should be `TabletSpacingTokens.dividerHairline` |
| Adding a one-caller spacing token | Tokens document a *role*; one-caller literals belong in review, not the scale |
| Forking a whole per-surface module token set | Duplicate module semantics guarantee drift; isolate only surface geometry in the dedicated Tablet namespace, then use tiers → frame → Rule-5 override |
| `…Tablet…` token referenced from a phone file | Breaks the override pairing contract (Rule 5 T2 — leakage-guarded) |
| Carrying a Phone page's vertical margin token (`pairRiskMargin`, `pairLinkMargin`, `pairTradeCtaPadding`) into a tablet pane's children list | Doubles the section gap (12 → 23–29dp); the rhythm "breathes unevenly" (8dp between two cards, 24–29dp around them) — S7 |
| Padding chồng 2 lớp cùng token (label bottom 12 + child top 12) | Gap render 24dp — nguyên nhân gốc lỗi; một khoảng đúng một lớp (Rule 6) |
| Mỗi panel tự chế khoảng label→nội dung | 8/11/24/36/44dp lộn xộn trên cùng trang — đã có hợp đồng 12dp (Rule 6) |
| A raw literal hiding inside a shared token (e.g. `pairTimeframePadding = LTRB(24, …)` where the scale says `contentPad` 20) | Widget-file scanners can't see it: the token file is where numbers are *allowed* to live, so a token carrying an off-scale value escapes every audit — check the token value against the scale when porting (fixed 2026-08-29) |

## Recipe for new tablet UI

1. Vertical page rhythm → `VitPageContent(rhythm: …)` by navigation role (see [Page-Rhythm-Standard.md](./Page-Rhythm-Standard.md)).
2. Every gap inside a section → Rule 1 table by role.
3. Frame layout (rail/margins/gutters/columns) → `VitTwoColumnTabletDashboard` / master-detail shell with `TabletDashboardWidths` untouched; pane content gutter-flush.
4. Any line/divider → hairline token (Rule 3).
5. Before commit: `dart run tool/tablet_spacing_audit.dart --check` + `flutter test test/quality/tablet_base8_role_scale_guardrail_test.dart test/quality/tablet_module_role_scale_guardrail_test.dart test/quality/tablet_spacing_guardrail_test.dart`.

## Verify

```bash
cd flutter_app
dart run tool/tablet_spacing_audit.dart            # regenerate audit CSV
dart run tool/tablet_spacing_audit.dart --check    # CI: artifact current
flutter test test/quality/tablet_spacing_guardrail_test.dart --reporter=compact
flutter test test/quality/tablet_base8_role_scale_guardrail_test.dart --reporter=compact
flutter test test/quality/tablet_module_role_scale_guardrail_test.dart --reporter=compact
flutter test test/quality/tablet_gap_12_guardrail_test.dart --reporter=compact
flutter test test/quality/tablet_rhythm_role_guardrail_test.dart --reporter=compact
flutter test test/quality/tablet_icon_size_guardrail_test.dart --reporter=compact
flutter test test/quality/tablet_fullbleed_guardrail_test.dart --reporter=compact
flutter test test/quality/tablet_pane_child_vertical_inset_guardrail_test.dart --reporter=compact
flutter test test/quality/tablet_token_override_guardrail_test.dart --reporter=compact
```

## Migration pointers

- Audit: [VitTrade-Tablet-Spacing-Audit.csv](../audits/VitTrade-Tablet-Spacing-Audit.csv) (empty — locked at zero)
- Vertical rhythm tiers: [Page-Rhythm-Standard.md](./Page-Rhythm-Standard.md)
- Frame widths & master-detail shells: [Tablet-Adaptive-Standard.md](./Tablet-Adaptive-Standard.md)
- Card frames & borders: [Tablet-Card-Border-Standard.md](./Tablet-Card-Border-Standard.md)
