# Two-Phase Cursor Workflow

Standard VitTrade pattern: **analyze once, execute in small chats**. Saves
context and retry cost without manual model switching.

Authority: `AGENTS.md` and `.cursor/rules/vittrade-cursor-workflow.mdc` win on
product, financial, architecture, and **Auto-only** model policy. This doc is
the operator runbook.

## Why two phases

| Phase | Mode | Chat | Job |
| --- | --- | --- | --- |
| 1 — Plan | Plan (read-only) | Chat A | Scope, risks, batch list, verify commands |
| 2 — Execute | Agent | Chat B, C, … | One batch per chat; verify; stop |

Do **not** rely on rules to force a “strong model then cheap model.” Cursor
**Auto** already balances cost/intelligence per request. Quality comes from
**Plan → approve → batch execute**, not from escalating Sonnet/Opus.

## When to use

Use two-phase when any of these is true:

- Task spans **more than ~10 files**
- Multi-screen migration / design-standard rollout
- Unclear architecture or cross-feature boundaries
- High-risk financial / security flows need preview-confirm contracts first

Skip Plan (single Agent chat) for small, obvious edits (1–3 files, clear fix).

## Phase 1 — Plan (Chat A)

1. Keep **Auto** selected. Switch to **Plan mode** (mode picker / Shift+Tab).
2. Daily session already running (`.\scripts\Start-CursorSession.ps1`) —
   GitNexus + Headroom connected.
3. Paste the **Plan prompt** below (fill `<task>`).
4. Agent explores only: GitNexus `impact` / `query`, targeted reads — no edits.
5. **You approve** the batch plan before any Build / Execute chat.

### Plan prompt (copy)

```text
Phân tích <task>. Chỉ đọc / khám phá — không sửa code.

Output bắt buộc:
1. Mục tiêu + out-of-scope (1 đoạn ngắn)
2. Rủi ro / boundary (Prediction Markets vs Open Arena, financial preview-confirm nếu có)
3. Danh sách batch theo thứ tự — mỗi batch 5–10 file, ưu tiên domain → data → presentation, một feature/module
4. Mỗi batch: paths tường minh + domain Standard (nếu UI) + lệnh verify cụ thể từ Flutter-Design-System-Reference / prompt hiện hành
5. Lệnh verify tổng (analyze + focused tests) sau batch cuối

Tham chiếu Codex: `.codex/skills/planning-and-task-breakdown/SKILL.md`
Không mở rộng scope ngoài <task>.
```

Codex là nguồn skill chuẩn; không cần runtime-specific agent runbook.

## Phase 2 — Execute (Chat B, C, …)

1. **New chat** per batch. Keep **Auto**. Use **Agent mode**.
2. Attach only: approved batch slice (or `@` the plan section) + needed files.
3. Paste the **Execute prompt** below.
4. After the batch: minimal-diff self-check → verification gate → cite evidence.
5. Start a **new chat** for the next batch (do not pile batches into one context).

### Execute prompt (copy)

```text
Thực hiện đúng Batch <N> trong plan đã duyệt (dán / @ đoạn Batch N).

Ràng buộc:
- Chỉ các file trong batch — không mở rộng scope
- Auto only — không đề xuất đổi model
- GitNexus impact trước khi sửa symbol
- Xong: tự check minimal-diff (.codex/skills/vittrade-minimal-review/SKILL.md),
  rồi chạy verification gate (AI_PROMPT_SHELL § Verification) — analyze + focused tests
- Báo evidence (lệnh + kết quả). Không hỏi “làm batch tiếp?” nếu plan đã định nghĩa batch kế

Tham chiếu Codex: `.codex/skills/incremental-implementation/SKILL.md`
```

## Cost and quality rules

| Do | Don’t |
| --- | --- |
| Auto always | Escalate model when stuck |
| Plan → approve → Build/Execute | Implement while still unclear |
| 5–10 files / chat; new chat after batch | One giant migration chat |
| Load one prompt + one plan slice (`docs/INDEX.md`) | Paste full audit CSV / backlog + plan |
| QA (`/browse`, `/review`) in a **separate** chat | Mix visual QA into migration batch |
| Hard task → smaller batch / Plan / GitNexus | Assume a higher model tier |

## Stuck recovery

1. Shrink to the next **half-batch** (≤5 files).
2. Re-enter Plan for the blocked slice only.
3. Handoff line if context full: `RESUME FROM: <phase> - <batch>` (see
   `AI_PROMPT_SHELL.md`).
4. Still blocked → escalate to human with evidence; do not switch models.

## Related

| Doc / tool | Role |
| --- | --- |
| `.cursor/rules/vittrade-cursor-workflow.mdc` | Always-on Cursor session rules |
| `docs/01_AI_RULES/AI_PROMPT_SHELL.md` | Verification + batch discipline |
| `docs/01_AI_RULES/AI_EXECUTION_CONTRACT.md` | Execution gate |
| `docs/INDEX.md` | On-demand doc picker |
| `.codex/skills/planning-and-task-breakdown/SKILL.md` | Batch plan procedure |
| `.codex/skills/incremental-implementation/SKILL.md` | Single-batch implement procedure |
| `.codex/skills/vittrade-minimal-review/SKILL.md` | Diff trim before batch done |
