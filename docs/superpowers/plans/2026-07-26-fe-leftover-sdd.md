# Plan — FE leftover sau PR #82 (SDD)

**Date:** 2026-07-26  
**Base:** `main` @ `8b88dd17` (#82 merged)  
**Authority:** `AGENTS.md`, ADR-010, plan hoàn thiện trước  
**Ledger:** `.superpowers/sdd/progress-fe-leftover.md`

## Goal

Đóng **nợ FE còn mở được** sau Trust polish + CI merge. Không bịa remote.
Wave remote/Ops vẫn BLOCKED — ghi evidence, không implement.

## Already done (không làm lại)

- Network Wave 1 (#81), Trust polish + CI (#82 MERGED)
- Offline-with-cache hubs: Cancelled (thiếu currentState)
- Contract skeletons, release CI skeleton, fail-closed, retry

## Unblocked tasks

### T1 — Address book “Whitelist” → tiếng Việt

**Spec:** User-facing copy còn `Whitelist` / `Chế độ Whitelist` trong
`wallet_address_book_*` (+ tests). Đổi sang «Danh sách trắng» nhất quán A2/A1.
Keys/semantic identifiers giữ nguyên nếu là Key kỹ thuật.

**Verify:** focused address book tests + analyze. ≤8 files.

### T2 — i18n ratchet wallet address / health copy chạm được

**Spec:** Dịch chuỗi English user-facing trên address-book + (nếu cùng batch)
`wallet_health_score_cards` seed-phrase/whitelist tip nếu là UI. Xóa dòng
baseline tương ứng. Không mở PR dịch 280 dòng toàn app.

**Cancel-ok** nếu T1 đã hết baseline hits cho các file đó.

### T3 — Close-out docs

Cập nhật `2026-07-25-hoan-thien-uu-tien-tiep.md` Execution: 0.4 **MERGED**.
Ghi W2–4 vẫn BLOCKED. Không Dart.

## Blocked (không dispatch implement)

| ID | Unblock |
| --- | --- |
| W2 Auth→P2P remote | OpenAPI ký |
| W3 secrets + smoke | Ops + device |
| W4 money string / identity / perf / E2E | ADR + lab |

## SDD

1 implementer → 1 reviewer / task · dùng phiên Codex hiện tại · no commit trừ user yêu cầu
(sau wave: user thường muốn PR — chờ lệnh commit).

---

## Execution result (2026-07-26)

DOCUMENTER T3 close-out. **No Dart production changes** in this pass.
Evidence:

- Blocked pack: `flutter_app/run-artifacts/sdd/wave-remote-ops-still-blocked.md`
- Ledger: `.superpowers/sdd/progress-fe-leftover.md`
- Prior plan 0.4 MERGED: [`2026-07-25-hoan-thien-uu-tien-tiep.md`](./2026-07-25-hoan-thien-uu-tien-tiep.md) (#82 / `8b88dd17`)

### Final status table

| ID | Task | Result |
| --- | --- | --- |
| T1 | Address book Whitelist → «Danh sách trắng» | **Approved** |
| T2 | i18n ratchet address-book / health copy + baseline | **Approved** |
| T3 | Close-out docs (this plan + prior Execution + blocked pack) | **Docs done** |
| W2 | Auth→P2P production remote | **Blocked** — signed OpenAPI/contracts |
| W3 | Secrets + staging URL + device smoke | **Blocked** — Ops / device lab |
| W4 | Money string ADR / identity / perf / E2E | **Blocked** — ADR + beta+ backlog |

**FE leftover wave:** T1–T3 closed. **W2–4:** still blocked — not claimed Done.
Next FE remote action: when BE signs Auth OpenAPI → start 2.1 Auth remote.
