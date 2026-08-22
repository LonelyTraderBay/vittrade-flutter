# AGENTS.md - VitTrade Flutter Enterprise Mono-Repo

**Project:** VitTrade - Enterprise Crypto Trading App  
**Tech Stack:** Flutter, Dart, Riverpod, GoRouter  
**Package Manager:** Flutter/Dart pub  
**Test Framework:** flutter_test  
**Last Updated:** 2026-08-21 (thêm mục Working Style — quy định phân tích → phương án → triển khai → test cho mọi tác vụ code)

Read `docs/00_START_HERE.md` before using long-form design, architecture, or QA
guidance.

## Source Of Truth

- App package: `flutter_app/`
- App source: `flutter_app/lib/`
- Public router import: `flutter_app/lib/app/router/app_router.dart`
- Tests: `flutter_app/test/`
- Generated QA artifacts: `flutter_app/run-artifacts/`

Do not recreate root npm, Vite, React, Tailwind, or web screenshot capture
tooling. The former web baseline is obsolete historical context only.

## Architecture

Use the enterprise Flutter module layout:

```text
flutter_app/lib/
├── app/
├── core/
├── features/
│   └── <feature>/
│       ├── domain/
│       ├── data/
│       └── presentation/
│           ├── pages/
│           ├── widgets/
│           └── controllers/
└── shared/
```

Rules:

- Keep app bootstrap, theme, router facade, and shell composition in `app/`.
- Keep non-UI cross-cutting boundaries in `core/`.
  - **Documented exception:** `core/navigation/back_navigation.dart` imports
    `flutter/widgets.dart` + `go_router` because `goBackOrFallback` needs a
    `BuildContext` to call `context.go`/`context.pop`. This is the one
    sanctioned "UI-adjacent" file in `core/` — do not use it as precedent for
    importing Flutter/UI packages elsewhere in `core/`. The path-validation
    helpers in the same file (`resolveSafeBackPath`, `_normalizeInternalPath`)
    are pure Dart and stay non-UI.
- Keep reusable UI primitives in `shared/`.
- Keep screen widgets under `features/<feature>/presentation/pages/`.
- Put repository contracts and value objects under `domain/`.
- Put mock/remote repository implementations and their base Riverpod provider
  under `data/`; feature/screen-level controller providers that wire a
  repository provider together with `presentation/controllers/` models live
  in `app/providers/<feature>_controller_providers.dart` (composition root —
  27 provider files covering 27/28 feature modules as of 2026-07-18; naming
  variants: `dev` → `dev_tools_controller_providers.dart`, `markets` →
  `market_controller_providers.dart`. `trade_core` intentionally has none —
  it is the shared entity kernel with no screens/controllers of its own).
- Prefer `package:vit_trade_flutter/...` imports across modules.

### State management / controller pattern

Chuẩn chốt tại GĐ2 · STATE-S26 (2026-07-17), chi tiết trong
`docs/05_ARCHITECTURE/decisions/ADR-001-async-error-idiom.md`:

- Controller có **mutation / async / status transition** ⇒ `NotifierProvider`
  (đường đọc async thuần dùng `AsyncNotifierProvider`). Family arg truyền qua
  constructor (`ClassName.new` — idiom Riverpod 3). Khuôn mẫu:
  `NotificationsStateController`
  (`lib/app/providers/notifications_controller_providers.dart`) và
  `TradeOrderController` (implementation tham chiếu ADR-001).
- `Provider<Controller>` const CHỈ cho **read-model thuần** (không ghi status,
  không repo-write). Ví dụ hợp lệ: `tradeReadModelControllerProvider`,
  `TradeMarginController`.
- Cấm seed `late List` từ `ref.read` rồi mutate bằng `setState`
  (dual-source-of-truth — STATE-S23 đang gỡ). Guardrail:
  `flutter_app/test/quality/state_management_guardrail_test.dart`.
- Family key: scalar/record-of-scalar, hoặc bắt buộc `.autoDispose`
  (STATE-S24).
- Máy trạng thái high-risk dùng enum `TradeHighRiskFlowStatus` (10 giá trị),
  KHÔNG bọc `AsyncValue` — xem bảng điểm ghi trong ADR-001.

### Quy ước part-file

Chuẩn chốt tại GĐ3 · ARCH-A4 (2026-07-18):

- Tách một file lớn thành `part`/`part of` là hợp lệ, nhưng **tên part phải
  mang vai trò ổn định**: `_sections` (các section UI của trang), `_common`
  (widget/helper dùng chung trong trang), `_widgets`, `_state`, `_methods`
  (nhóm method của mock repo), `_entities`...
- **KHÔNG dùng suffix số thứ tự `_part_NN`** — đó là tách cơ học tạm thời, là
  "nợ có theo dõi". Toàn lib/ hiện đã về 0 và bị khóa ở 0 bởi guardrail
  `test/quality/architecture_size_style_debt_guardrails_test.dart`.
- UI tái dùng nên chuyển vào `presentation/widgets/` thay vì phình part-file
  của trang.

## Product Boundaries

Prediction Markets and Open Arena must stay separate.

| Boundary | Prediction Markets | Open Arena |
| --- | --- | --- |
| Currency | Wallet balance | Arena Points |
| Performance | PnL / positions | Points pool / completion |
| History | Orders / receipts | Ledger entries |
| Leaderboard | Trading context | Fair play / completion |

Allowed bridges: topic/category, event context, creator discovery,
search/discovery, and profile surfaces with clearly separated sections.

## Chính sách ngôn ngữ (vi-VN-only)

Chuẩn chốt tại GĐ2 · I18N-1 (DEC-i18n Nhánh A, 2026-07-16):

- Copy sản phẩm user-facing là **tiếng Việt có dấu đầy đủ, viết inline** —
  hợp lệ, KHÔNG cần bọc qua ARB/gen-l10n ở giai đoạn mock-UI này. Lý do:
  sản phẩm một ngôn ngữ, backend chưa chốt; bọc l10n sớm chỉ thêm một tầng
  gián tiếp mà không có người dùng thứ hai ngôn ngữ nào hưởng lợi.
- Đường nâng cấp đã định: khi có backend/đa ngôn ngữ thật, migrate sang
  `flutter gen-l10n` (ARB) theo từng module — locale runtime đã sẵn
  (`flutter_localizations` + `locale: vi` trong `vit_trade_app.dart`,
  I18N-2).
- **Cấm thêm chuỗi tiếng Anh user-facing MỚI** trong presentation layer.
  Ratchet: `flutter_app/test/quality/i18n_vi_only_guardrail_test.dart` +
  baseline `i18n_vi_only_baseline.txt` (nợ tiếng Anh baseline — xem số dòng
  file làm nguồn sự thật, đang giảm dần —
  trả dần khi chạm file; SỬA một chuỗi baseline nghĩa là dịch nó luôn).
  Lưu ý heuristic: tiếng Việt KHÔNG DẤU ("mua nhanh") từng false-positive
  là tiếng Anh — guardrail chỉ bắt chuỗi có ≥2 từ marker tiếng Anh, không
  language-detect; copy mới cứ viết đủ dấu là an toàn.
- Nhãn kỹ thuật không phải copy (semanticIdentifier, route path, Key, tên
  package/API) không thuộc phạm vi chính sách này.

## UI Rules

- Visual contract for agents: [`DESIGN.md`](DESIGN.md) at repo root (tokens +
  component ladder); `AGENTS.md` wins on product/financial rules.
- Full map of every design-consistency audit domain (~24), what enforces it,
  and the exact command to check it locally — see
  `docs/02_FLUTTER_MIGRATION/Flutter-Design-System-Reference.md` before
  creating a new page.
- Phone-first at 360px is the baseline. The surface (Phone/Tablet/Web) is
  resolved **once at bootstrap** by `AppSurfaceResolver`
  (`lib/app/bootstrap/app_surface.dart`): web when `kIsWeb`, else tablet at
  `AppBreakpoints.tablet` (600px), else phone. Each surface owns its router
  (`lib/app/router/{phone,tablet,web}/`) and shell
  (`lib/app/shell/{phone,tablet,web}/`); pages and shells never dispatch on
  width at runtime. `createAppRouter()` without `surface:` renders the Phone
  composition at every width — it is the compat API for tests, not a
  responsive mode.
- Per-feature tablet composition rolls out module by module (done: auth,
  home, markets hub, trade, wallet, profile, và các trang tablet dùng chung
  của P2P trong `p2p_core`). A module without its own tablet composition
  routes to the `VitTabletUtilityPage` placeholder (`P2PTabletUtilityPage`
  cho P2P) — tablet surface **không** render lại phone page. Real web pages
  exist only for auth and home; mọi web route khác là placeholder
  `VitWebUtilityPage`.
- Detailed per-component standards (page rhythm, content width, card tiles,
  segment pills, scroll auto-hide, notice acknowledgements, service tile
  badges, task cards, accent icon boxes, radius tokens) live in
  `.codex/skills/vittrade-ui-checklists/references/ui-visual-standards.md` and
  the matching files under `docs/02_FLUTTER_MIGRATION/standards/` — read the
  applicable standard before touching presentation code; do not duplicate its
  content here.
- Never wrap `VitTabBar` / `VitSegmentedTabBar` in `VitCard` or `DecoratedBox`
  with a border — segment tabs render their own pill outline. Never use
  `BorderRadius.circular()` outside `app_radii.dart`.

## Financial Safety

- Preview and confirm withdrawals, escrow release, security changes, address
  additions, and P2P payment-method changes.
- Show fees, risk, limits, and next steps before high-risk confirmation.
- Mask sensitive account, wallet, email, phone, and address data.
- Arena copy must stay points-only. Do not use payout, wallet, profit, or
  stake-return language for Arena.
- Prediction Markets may use positions, probability, receipt, rewards, and P/L;
  avoid hype or casino language.

## Working Style — Phân tích, phương án, triển khai

Chuẩn chốt 2026-08-21; áp dụng bắt buộc cho mọi tác vụ tạo/sửa code, user
không cần nhắc lại trong prompt:

- **Phân tích trước, sửa sau:** luôn đi theo trình tự hiện trạng →
  vấn đề (là gì, chi tiết, vì sao xảy ra) → phương án → triển khai.
  Không sửa code khi chưa nêu rõ vấn đề.
- **Phương án tối ưu cân bằng + best-effort:** chọn phương án đơn giản
  nhất vẫn giải quyết triệt để yêu cầu — không over-engineer (bám quy
  tắc Minimal diff / Ponytail-lite: không trừu tượng hoá cho một
  caller, không thêm dependency mới), không hack tạm bợ. Có nhiều
  phương án thì nêu ngắn trade-off của từng cái và **chỉ định một
  phương án đề xuất**.
- **Trình bày dễ hiểu, logic rõ:** mô tả vấn đề và chỗ cần sửa bằng
  tiếng Việt có dấu, đơn giản, có logic rõ ràng; nêu rõ file/vị trí
  cần sửa và lý do từng chỗ.
- **Triển khai bám phương án đã trình bày:** chỉ implement đúng scope
  của phương án; phần phát sinh thêm phải được đánh dấu "ngoài phương
  án" và giải trình trước khi làm.
- **Test đầy đủ:** sau khi sửa luôn chạy kiểm chứng theo quy tắc mục
  Commands (focused test cho module chạm, full test cho
  router/shared/repository/structural change); báo kết quả thật, kể cả
  khi fail.

## Commands

Run from `flutter_app/`:

```bash
dart run tool/preflight_check.dart
flutter pub get
dart format --output=none --set-exit-if-changed .
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
flutter analyze
flutter test --reporter=compact
flutter run
```

Trước khi commit + push, chạy `dart run tool/preflight_check.dart` — một
lệnh duy nhất mô phỏng trọn chuỗi kiểm tra tĩnh của CI: dart format,
flutter analyze, mọi lệnh audit `--check` đọc trực tiếp từ
`.github/workflows/flutter-ci.yml` (chạy trên bản checkout sạch tái tạo
từ index sắp commit — bắt đúng lớp lỗi "artifact audit commit từ cây có
code chưa đồng bộ" mà chạy audit trên working tree không lộ), và full
test suite (flag `--fast` để bỏ test khi chỉ cần kiểm nhanh giữa chừng).

Use focused tests for touched modules and full tests for router, shared layout,
repository, or broad structural changes.

## Codex Workflow

Codex is the default repository agent surface. Keep the working context small
and load only the relevant local skill from `.codex/skills/` for each task:

- Session entrypoint: `.codex/README.md` → `docs/INDEX.md` → task-specific skill.

- Multi-file or ambiguous work: use `planning-and-task-breakdown` first.
- Implementation: use `incremental-implementation` and verify every slice.
- Symbol changes: run GitNexus `impact` before editing and
  `detect_changes` before committing.
- UI work: use `vittrade-ui-checklists` plus the matching design-domain
  standard.
- High-risk financial flows: use `vittrade-product-verify`.
- Batch size: 5–10 files; load one execution prompt and one plan slice from
  `docs/INDEX.md` at a time.

### Minimal diff (Ponytail-lite)

- Rule `.codex/skills/vittrade-minimal-review/SKILL.md` governs diff trimming
  when editing `flutter_app/**`.
- Reuse `Vit*` shared widgets and theme tokens; shortest diff that passes the plan gate.
- No one-caller abstractions, no new pub deps unless explicitly requested.
- Batch completion gate: self-check diff and trim bloat before marking batch done (see workflow rule).
- AGENTS.md and the active execution prompt override YAGNI — do not skip required migration scope.

## Repo Hygiene

- Do not commit `.idea/`, `*.iml`, logs, `build/`, `.dart_tool/`,
  `flutter_app/tmp/`, `flutter_app/run-artifacts/`, or root `output/`.
- Keep Android, iOS, web, Dart source, tests, and package metadata under
  `flutter_app/`.
- Treat `docs/02_FLUTTER_MIGRATION/` as the retained path for Flutter coverage
  and QA docs, not as a dependency on old React code.

## Agent Skills

Local agent workflow skills live in `.codex/skills/`. Use them selectively for
spec, planning, implementation, testing, debugging, review, security, and UI
work. This AGENTS.md remains the higher-priority project contract; GitNexus,
Flutter commands, financial safety, and Prediction Markets/Open Arena
boundaries always take precedence over generic skill guidance.

| Task | Skill |
| --- | --- |
| UI review / screen polish | `.codex/skills/vittrade-ui-checklists/SKILL.md` |
| Batch completion gate | `.codex/skills/vittrade-batch-gate/SKILL.md` |
| Design-domain audit lookup | `.codex/skills/vittrade-design-domain/SKILL.md` |
| High-risk product verification | `.codex/skills/vittrade-product-verify/SKILL.md` |
| Button wiring audit | `.codex/skills/vittrade-button-wiring-audit/SKILL.md` |
| Plan multi-file work | `.codex/skills/planning-and-task-breakdown/SKILL.md` |
| Incremental implementation | `.codex/skills/incremental-implementation/SKILL.md` |
| Pre-merge review | `.codex/skills/code-review-and-quality/SKILL.md` |
| GitNexus impact / refactor | `.codex/skills/gitnexus-impact-analysis/SKILL.md` |
| Over-engineering / diff trim | `.codex/skills/vittrade-minimal-review/SKILL.md` |
| Debug / test failure / blocked batch | `.codex/skills/debugging-and-error-recovery/SKILL.md` |
| Performance / jank / profiling | `.codex/skills/performance-optimization/SKILL.md` |
| Trade module debt scan (sprint) | `.codex/skills/ponytail-audit/SKILL.md` |
| UI/UX design intelligence (reference) | `.codex/skills/ui-ux-pro-max/SKILL.md` — tra cứu style/UX guidance; LUÔN thua DESIGN.md + tokens + Vit* ladder khi xung đột (xem install note trong SKILL.md) |

<!-- gitnexus:start -->
# GitNexus — Code Intelligence

This project is indexed by GitNexus as **vittrade-flutter**. Counts and
execution-flow totals are runtime data; verify freshness with
`node .gitnexus/run.cjs status` instead of relying on hard-coded numbers. Use
the GitNexus MCP tools to understand code, assess impact, and navigate safely.

> Index stale? Run `.\scripts\gitnexus\Refresh-Index.ps1` or `node .gitnexus/run.cjs analyze --skip-agents-md --skip-skills`. Local index lives in `.gitnexus/` (gitignored, ~730MB — refresh after clone).

## Always Do

- **MUST run impact analysis before editing any symbol.** Before modifying a function, class, or method, run `impact({target: "symbolName", direction: "upstream"})` and report the blast radius (direct callers, affected processes, risk level) to the user.
- **MUST run `detect_changes()` before committing** to verify your changes only affect expected symbols and execution flows. For regression review, compare against the default branch: `detect_changes({scope: "compare", base_ref: "main"})`.
- **MUST warn the user** if impact analysis returns HIGH or CRITICAL risk before proceeding with edits.
- When exploring unfamiliar code, use `query({query: "concept"})` to find execution flows instead of grepping. It returns process-grouped results ranked by relevance.
- When you need full context on a specific symbol — callers, callees, which execution flows it participates in — use `context({name: "symbolName"})`.

## Never Do

- NEVER edit a function, class, or method without first running `impact` on it.
- NEVER ignore HIGH or CRITICAL risk warnings from impact analysis.
- NEVER rename symbols with find-and-replace — use `rename` which understands the call graph.
- NEVER commit changes without running `detect_changes()` to check affected scope.

## Resources

| Resource | Use for |
|----------|---------|
| `gitnexus://repo/vittrade-flutter/context` | Codebase overview, check index freshness |
| `gitnexus://repo/vittrade-flutter/clusters` | All functional areas |
| `gitnexus://repo/vittrade-flutter/processes` | All execution flows |
| `gitnexus://repo/vittrade-flutter/process/{name}` | Step-by-step execution trace |

More GitNexus skills: `.codex/skills/gitnexus-exploring/`, `gitnexus-debugging/`,
`gitnexus-refactoring/`, `gitnexus-guide/`, `gitnexus-cli/`.

<!-- gitnexus:end -->
