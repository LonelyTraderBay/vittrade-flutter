"""Generate copy-paste prompts for pending redesign batches + final gate."""
from __future__ import annotations

import csv
import math
import subprocess
from datetime import date
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
CSV_PATH = REPO / "docs/_archive/2026-redesign-v2.5/redesign/ke-hoach-redesign-batches.csv"
OUT_FINAL = REPO / "docs/_archive/2026-redesign-v2.5/prompt-redesign/EXECUTION-PENDING-FINAL.md"
OUT_LAST = REPO / "docs/_archive/2026-redesign-v2.5/prompt-redesign/EXECUTION-PENDING-4-LAST.md"
OUT_LEGACY = REPO / "docs/_archive/2026-redesign-v2.5/prompt-redesign/EXECUTION-PENDING-26.md"
BASE = "dad444ab0"
MAX_PAGES_PER_CHAT = 8
DOC_NAME = "EXECUTION-PENDING-4-LAST.md"

# Known trap: agent edits *_part_*.dart but CSV tracks the root page file.
BATCH_NOTES: dict[str, str] = {
    "RD-C01": (
        "TRAP: dca_page_part_01..04 đã có diff — batch cần `dca_page.dart` (shell/router). "
        "Sửa file GỐC hoặc re-export/part wiring trong dca_page.dart."
    ),
    "RD-A01": (
        "TRAP: arena_guide_page_part_01 đã diff — batch cần `arena_guide_page.dart`. "
        "Migrate shell/layout sang file gốc, không chỉ part."
    ),
    "RD-L02": (
        "TRAP: launchpad_staking_page_part_* có thể đã diff — CSV cần "
        "launchpad_staking_page.dart, launchpad_receipt_page.dart, "
        "launchpad_claim_receipt_page.dart, launchpad_bridge_order_page.dart."
    ),
    "RD-M23-B01": (
        "Dev/showcase pages — redesign 5 file còn lại; giữ route_checker behavior."
    ),
}


def batch_tier(special_prompt: str, module_prompt: str) -> str:
    if special_prompt:
        return "A_hub"
    if module_prompt:
        return "B_child"
    return "B_simple"


def completion_line(batch_id: str, module_id: str) -> str:
    if batch_id == "RD-T02":
        return "TRADING BOTS HUB UI REDESIGN DONE — SC-059 v2"
    return f"MODULE UI REDESIGN DONE — {module_id} — {batch_id}"


def load_lines(batch_id: str, special_prompt: str, module_prompt: str) -> list[str]:
    lines = [
        "- docs/_archive/2026-redesign-v2.5/redesign/ke-hoach-redesign-theo-module.md §1-4",
        "- docs/_archive/2026-redesign-v2.5/prompt-redesign/REDESIGN-CONTRACT.md",
        f"- ke-hoach-redesign-batches.csv row {batch_id}",
        "- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)",
    ]
    if special_prompt:
        lines.append(f"- docs/02_FLUTTER_MIGRATION/{special_prompt} (FULL hub prompt)")
    elif module_prompt:
        lines.append(
            f"- docs/02_FLUTTER_MIGRATION/{module_prompt} "
            "(North Star · Copy · Financial ONLY)"
        )
        lines.append("- docs/_archive/2026-redesign-v2.5/prompt-redesign/_template-tier-b-batch.md")
    else:
        lines.append("- docs/_archive/2026-redesign-v2.5/prompt-redesign/_template-tier-b-batch.md")
    lines.append("- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)")
    return lines


def page_path(p: str) -> str:
    p = p.replace("\\", "/").lstrip("/")
    return p if p.startswith("flutter_app/") else f"flutter_app/{p}"


def page_short(p: str) -> str:
    return p.split("/")[-1]


def changed_files() -> set[str]:
    out = subprocess.check_output(
        ["git", "diff", "--name-only", BASE],
        cwd=REPO,
        text=True,
        errors="replace",
        stderr=subprocess.DEVNULL,
    )
    return set(out.strip().splitlines()) if out.strip() else set()


def missing_pages(row: dict, changed: set[str]) -> tuple[list[str], list[str]]:
    pages = [p for p in row["page_files"].split(";") if p and p != "-"]
    done, missing = [], []
    for p in pages:
        hit = any(c.endswith(page_path(p)) or page_path(p) == c for c in changed)
        (done if hit else missing).append(p)
    return done, missing


def chunk_pages(pages: list[str], size: int) -> list[list[str]]:
    if not pages:
        return [[]]
    return [pages[i : i + size] for i in range(0, len(pages), size)]


def render(changed: set[str], today: str, *, title: str, intro: str, doc_name: str) -> str:
    rows = list(csv.DictReader(CSV_PATH.open(encoding="utf-8-sig")))
    step_by_id = {r["batch_id"]: int(r["order"]) for r in rows}
    done_count = sum(1 for r in rows if r["status"].strip().lower() == "done")

    pending = [r for r in rows if r["status"].strip().lower() != "done"]
    pending.sort(key=lambda r: step_by_id[r["batch_id"]])

    batch_plans: list[dict] = []
    total_missing = 0

    for row in pending:
        done_list, missing = missing_pages(row, changed)
        total_missing += len(missing)
        chats = max(1, math.ceil(len(missing) / MAX_PAGES_PER_CHAT)) if missing else 1
        chunks = chunk_pages(missing, MAX_PAGES_PER_CHAT) if missing else [[]]
        batch_plans.append(
            {
                "row": row,
                "step": step_by_id[row["batch_id"]],
                "done": done_list,
                "missing": missing,
                "chats": chats,
                "chunks": chunks,
            }
        )

    batch_chats = sum(p["chats"] for p in batch_plans)
    total_chats = batch_chats + (1 if pending else 0)  # + final gate chat

    lines: list[str] = [
        title,
        "",
        f"**Generated:** {today} · **Baseline git:** `{BASE}` · **Tiến độ:** {done_count}/66 done",
        "",
        intro,
        "",
        "Liên quan: [EXECUTION-PLAYBOOK.md](EXECUTION-PLAYBOOK.md) · "
        "[REDESIGN-CONTRACT.md](REDESIGN-CONTRACT.md)",
        "",
        "---",
        "",
        "## Tổng quan",
        "",
        "| Metric | Value |",
        "| --- | --- |",
        f"| Batch còn pending | **{len(pending)}** |",
        f"| Màn còn thiếu (chưa diff) | **{total_missing}** |",
        f"| Chat batch (redesign code) | **{batch_chats}** |",
        f"| Chat final gate | **1** |",
        f"| **Tổng chat** | **{total_chats}** |",
        "",
        "**Quy tắc:** Mỗi TARGET PAGE = file liệt kê trong CSV `page_files`. "
        "Sửa `_part_*` hoặc widget con **không** tính xong batch.",
        "",
        "## Bảng thứ tự",
        "",
        "| Chat | Playbook | Batch | Module | Lần/batch | Màn còn | Màn chat |",
        "| ---: | ---: | --- | --- | ---: | ---: | ---: |",
    ]

    global_chat = 0
    for plan in batch_plans:
        row = plan["row"]
        for chat_idx, chunk in enumerate(plan["chunks"], start=1):
            global_chat += 1
            lines.append(
                f"| **{global_chat}** | {plan['step']} | `{row['batch_id']}` | "
                f"{row['module']} | {chat_idx}/{plan['chats']} | "
                f"{len(plan['missing'])} | {len(chunk)} |"
            )
    if pending:
        global_chat += 1
        lines.append(f"| **{global_chat}** | 67 | FINAL | all | 1/1 | 0 | gate |")

    lines.extend(["", "---", "", "## Prompt copy-paste", ""])

    global_chat = 0
    for batch_ordinal, plan in enumerate(batch_plans, start=1):
        row = plan["row"]
        batch_id = row["batch_id"]
        module_id = row.get("module_id") or row["module"]
        tier = batch_tier(row.get("special_prompt", ""), row.get("module_prompt", ""))
        special = row.get("special_prompt", "")
        module_prompt = row.get("module_prompt", "")

        lines.extend(
            [
                f"## {batch_ordinal}. Playbook step {plan['step']} — `{batch_id}` ({row['module']})",
                "",
                f"- **Tier:** {tier} · **Chat cần chạy:** **{plan['chats']}** · **Màn còn:** **{len(plan['missing'])}**",
                "",
            ]
        )

        if plan["done"]:
            lines.append("Đã có diff (chỉ regression mới sửa lại):")
            for p in plan["done"]:
                lines.append(f"- `{page_short(p)}`")
            lines.append("")

        note = BATCH_NOTES.get(batch_id)
        if note:
            lines.append(f"**Lưu ý batch:** {note}")
            lines.append("")

        for chat_idx, chunk in enumerate(plan["chunks"], start=1):
            global_chat += 1
            is_last = chat_idx == plan["chats"]
            lines.append(
                f"### Chat {global_chat}/{total_chats} — `{batch_id}` ({chat_idx}/{plan['chats']})"
            )
            lines.append("")

            touched_so_far = sum(len(c) for c in plan["chunks"][:chat_idx])
            remaining_after = len(plan["missing"]) - touched_so_far

            prompt_lines = [
                f"FINISH REDesign — chat {global_chat}/{total_chats}",
                f"Playbook step {plan['step']}/66 — batch {batch_id} — run {chat_idx}/{plan['chats']} — module {module_id}",
                "",
                *load_lines(batch_id, special, module_prompt),
                "",
                "GitNexus impact() trước mọi edit. Mirror SC-007 Home (read-only).",
                "STEP 0→5. Max 5-10 files code + tests this chat.",
                "",
                "BẮT BUỘC: redesign TOÀN BỘ TARGET PAGES bên dưới — Vit* · AppRadii · states.",
                "Không bỏ sót file. Không chỉ sửa widget/part file thay thế page gốc.",
                "Acceptance: `git diff dad444ab0 -- <target>` phải có thay đổi cho MỖI file TARGET.",
                "Không sửa home_page.dart. Không audit lại module đã done.",
                "",
                "TARGET PAGES:",
            ]
            for p in chunk:
                prompt_lines.append(f"- {page_path(p)}")

            if not is_last:
                prompt_lines.extend(
                    [
                        "",
                        f"BATCH INCOMPLETE — còn {remaining_after} màn sau chat này.",
                        "DO NOT set CSV status=done. DO NOT regenerate plan.",
                        f"RESUME: {doc_name} — Chat {global_chat + 1}/{total_chats}",
                    ]
                )
            else:
                prompt_lines.extend(
                    [
                        "",
                        "LAST CHAT FOR BATCH — sau pass gate:",
                        f"1. ke-hoach-redesign-batches.csv → {batch_id} status=done",
                        "2. py -3 flutter_app/tool/gen_redesign_plan.py",
                        f"3. Say: {completion_line(batch_id, module_id)}",
                    ]
                )

            lines.append("```text")
            lines.extend(prompt_lines)
            lines.append("```")
            lines.append("")

        lines.append("---")
        lines.append("")

    if pending:
        final_chat = total_chats
        lines.extend(
            [
                f"## Final gate — Chat {final_chat}/{total_chats}",
                "",
                f"Chạy **sau khi** cả {len(pending)} batch pending đều `status=done` (66/66).",
                "",
                "```text",
                f"FINAL REDesign GATE — chat {final_chat}/{final_chat}",
                "",
                "All 66 batches status=done. Không sửa UI thêm trừ fix gate fail.",
                "",
                "Run from flutter_app/:",
                "1. flutter analyze (0 errors)",
                "2. flutter test --reporter=compact",
                "3. dart run tool/design_token_consistency_audit.dart --check",
                "4. dart run tool/route_coverage_audit.dart --check",
                "5. dart run tool/navigation_edge_audit.dart --check",
                "",
                "Fix any failure. Keep verification output focused; use the documented Codex gate.",
                "Completion: VITTRADE UI REDESIGN COMPLETE — 415 screens",
                "```",
                "",
            ]
        )

    return "\n".join(lines)


def main() -> None:
    today = date.today().isoformat()
    changed = changed_files()

    intro = (
        "> **Cách dùng:** Mỗi block ```text``` = **1 phiên Codex mới**, chạy **Chat 1 → Chat N** liên tiếp.\n"
        "> Chỉ ghi CSV `status=done` khi prompt ghi **LAST CHAT FOR BATCH**.\n"
        "> **Chat cuối** = Final gate (sau khi hết batch pending)."
    )
    content_final = render(
        changed,
        today,
        title="# VitTrade UI Redesign — Hoàn thiện (prompts theo thứ tự)",
        intro=intro,
        doc_name="EXECUTION-PENDING-FINAL.md",
    )
    OUT_FINAL.write_text(content_final, encoding="utf-8")

    intro_last = (
        "> **4 batch cuối · 11 màn · 5 chat** — file ưu tiên dùng cho sprint hoàn tất.\n"
        "> Mỗi block ```text``` = **1 chat mới**. Copy **Chat 1 → 5** theo thứ tự.\n"
        "> **Chat 5** = final gate (chạy sau khi 66/66 batch done)."
    )
    content_last = render(
        changed,
        today,
        title="# VitTrade UI Redesign — 4 batch cuối (11 màn còn lại)",
        intro=intro_last,
        doc_name=DOC_NAME,
    )
    OUT_LAST.write_text(content_last, encoding="utf-8")

    legacy = [
        "# (Legacy) EXECUTION-PENDING-26.md",
        "",
        f"**Redirect:** dùng **[EXECUTION-PENDING-4-LAST.md](EXECUTION-PENDING-4-LAST.md)** "
        f"(4 batch cuối) hoặc [EXECUTION-PENDING-FINAL.md](EXECUTION-PENDING-FINAL.md).",
        "",
        f"Regenerated {today}.",
        "",
    ]
    OUT_LEGACY.write_text("\n".join(legacy), encoding="utf-8")

    pending = sum(
        1
        for r in csv.DictReader(CSV_PATH.open(encoding="utf-8-sig"))
        if r["status"].strip().lower() != "done"
    )
    print(f"Wrote {OUT_FINAL.relative_to(REPO)}")
    print(f"Wrote {OUT_LAST.relative_to(REPO)}")
    print(f"Wrote {OUT_LEGACY.relative_to(REPO)} (redirect)")
    print(f"pending_batches={pending}")


if __name__ == "__main__":
    main()
