# Execution Prompt — Tier B batch (sub-hub / simple module)

**Version:** 1.1 · **Suite:** [REDESIGN-CONTRACT.md](REDESIGN-CONTRACT.md) · [EXECUTION-PLAYBOOK.md](EXECUTION-PLAYBOOK.md)

**Khi dùng:** Bước trong playbook có tier `B_child` hoặc `B_simple` — copy block Prompt từ playbook trước.

**Shell contract:** [AI_PROMPT_SHELL.md](../../01_AI_RULES/AI_PROMPT_SHELL.md)

---

## Load order

1. [ke-hoach-redesign-theo-module.md](../redesign/ke-hoach-redesign-theo-module.md) §1–4
2. `ke-hoach-redesign-batches.csv` row `<batch_id>`
3. Checklist CSV rows matching `sc_ids`
4. **Partial parent** (nếu `module_prompt` có giá trị): chỉ sections **Design North Star**, **Copy & tone**, **Financial / product safety** — **không** load full STEP lặp
5. File này (Tier B discipline)

---

## Inherit từ module hub

| Section parent | Áp dụng |
| --- | --- |
| North Star | Tone toàn batch |
| Copy & tone | Headlines, CTA, tránh hype |
| Financial / product safety | Preview/confirm, product boundary |
| Anti-patterns | Tham chiếu — audit lại trên page batch |
| IA hub map | Chỉ hub; batch con follow section rhythm tương tự |

---

## Tier B discipline

- Max **5–10 files** code + tests.
- Mirror SC-007 Home (read-only).
- States: loading · empty · error khi flow cần.
- Không tạo local `Vit*` duplicate.
- Completion: `MODULE UI REDESIGN DONE — <module_id> — <batch_id>`

---

## Batch-specific (user điền)

**Batch:** `<batch_id>`  
**Pages:** from CSV `page_files`  
**Accent:** from CSV `accent` column / plan §4

**Focus this batch:** {one paragraph — e.g. compliance forms, order flow, settings}

---

## Verify

Focused tests for touched pages only. STEP 4 gate per shell.
