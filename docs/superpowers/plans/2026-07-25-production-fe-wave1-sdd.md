# Plan — Production FE Wave 1 SDD (hoàn thiện phần unblocked)

**Date:** 2026-07-25  
**Base:** `main` @ `fadd9c0f` (PR #80 merged)  
**Authority:** `AGENTS.md`, ADR-010, `ke-hoach-san-sang-production.md`  
**Ledger:** `.superpowers/sdd/progress-prod-fe-wave1.md`

## Goal

Đưa **mọi việc FE không bị chặn contract/Ops** về Done bằng Subagent-Driven
(1 implementer → 1 reviewer mỗi task). Wave 2 remote + Wave 3 release ký thật
được ghi **BLOCKED 100% đúng phạm vi** (không bịa OpenAPI / không commit secrets).

## Already done (PR #80)

- [x] B1 Error mapper HTTP/business → vi-VN
- [x] B2 Session refresh + SecureStore + overrides
- [x] P0 provider fail-closed static ratchet

## Global constraints

1. Dùng một phiên Codex nhất quán.
2. Không commit trừ khi user yêu cầu rõ (SDD mặc định: no commit).
3. ADR-010: **cấm** `remote_*_repository` / DTO đoán.
4. `core/` không import `app/`.
5. Batch ≤ ~10 file; verify analyze + focused tests; minimal-diff.
6. Copy user-facing tiếng Việt đủ dấu.

## Definition of “100%” cho lần chạy này

| Phạm vi | Tiêu chí Done |
| --- | --- |
| Wave 1 (FE unblocked) | Mọi task 1.1–1.6 Approved hoặc Cancelled có lý do |
| Wave 2 remote | Ledger ghi BLOCKED + unblock condition (không implement) |
| Wave 3 release ký/smoke device | Ledger ghi BLOCKED trên secrets/device QA |
| Wave 4 P1 | Chỉ làm nếu còn quota sau W1; else backlog có thứ tự |

---

## Task 1.1 — Trim ponytail PR #80

**Spec:** Áp dụng findings ponytail-review:
- Xóa case `NETWORK_UNAVAILABLE` chết trong `apiUserMessageForBusinessCode`
- Xóa parse body JSON-string + test tương ứng (`ResponseType.json`)
- Bỏ barrel re-export mapper/session_refresh khỏi `api_client.dart`; cập nhật import test
- Gộp expect status thành loop trong test

**Files (≤10):** `api_error_mapper.dart`, `api_client.dart`, `api_client_test.dart` (+ import callers nếu cần)

**Verify:**
```text
cd flutter_app
flutter test test/core/network/api_client_test.dart --reporter=compact
flutter analyze
```

**Gate:** Reviewer Spec + Quality; net lines giảm.

---

## Task 1.2 — Fail-closed runtime ratchet

**Spec:** Thêm test chứng minh runtime (không chỉ static string): với
`enableMockData=false` và không override `remote:`, đọc/gọi ít nhất Auth +
Wallet repository provider → fail-closed exception (không trả mock data).

**Files:** `test/quality/repository_guard_coverage_guardrail_test.dart` và/hoặc
test mới nhỏ; chỉ sửa provider nếu thiếu `failClosed` thật.

**Verify:** focused guardrail/runtime test + analyze.

---

## Task 1.3 — Mock API-safe P0 (tối đa 2 batch)

**Spec:** Audit nhanh mock Auth + Wallet withdraw/overview: tiền không dùng
`double` lộ API; status/timestamp API-safe nơi chạm high-risk. Không rewrite
toàn bộ 400 màn. Batch A Auth; Batch B Wallet high-risk nếu còn nợ rõ.

**Cancel-ok:** Nếu audit không tìm thấy vi phạm P0 rõ → ledger “no-op Approved”.

---

## Task 1.4 — Contract skeletons đàm phán (docs only)

**Spec:** Thêm/ cập nhật skeleton **to-confirm** cho Wallet, Profile, Markets/Trade,
P2P (pattern Auth-Backend-Contract-Skeleton). Không wire remote, không DTO.

**Verify:** docs only; reviewer kiểm tra không có path `remote_*` mới trong lib/.

---

## Task 1.5 — Release CI skeleton

**Spec:** Job release riêng (tag hoặc workflow_dispatch), build release với
dart-defines; secrets optional / skip có message rõ nếu thiếu — không phá debug gate.

**Files:** `.github/workflows/flutter-ci.yml` hoặc workflow mới ≤1 file chính.

**Verify:** YAML hợp lệ; debug job không đổi hành vi fail.

---

## Task 1.6 — Retry policy request an toàn

**Spec:** Retry giới hạn cho GET idempotent; **không** retry POST high-risk
(withdraw confirm, escrow release, …). Test unit chứng minh.

**Cancel-ok** nếu overlap lớn với Dio mặc định và reviewer coi là yagni — ghi ledger.

---

## Task W2/W3 — BLOCKED evidence pack

**Spec:** Một subagent chỉ đọc + viết ledger/section trong plan: liệt kê
unblock conditions (OpenAPI Auth ký, staging URL, signing secrets, device smoke).
**Không** tạo remote repo.

---

## SDD rules

- 1 implementer subagent / task → 1 reviewer subagent (spec + quality).
- Fix loop nếu Critical/Important; nits optional cùng PR sau.
- Artifacts: `flutter_app/run-artifacts/sdd/` (gitignored ok).
- Không escalate model.

---

## Execution result

**Closed:** 2026-07-25 · Ledger: `.superpowers/sdd/progress-prod-fe-wave1.md`  
**Blocked pack:** `flutter_app/run-artifacts/sdd/task-w2-w3-blocked.md`

| ID | Result | Summary |
| --- | --- | --- |
| 1.1 | **Approved** | Ponytail trim on mapper/client/tests |
| 1.2 | **Approved** | Runtime fail-closed ratchet (Auth+Wallet) |
| 1.3 | **No-op Approved** | No clear P0 mock API-safe violations in scoped audit |
| 1.4 | **Approved** | Contract skeletons for negotiation (docs only) |
| 1.5 | **Approved** | Release CI skeleton; secrets optional |
| 1.6 | **Approved** | Safe GET retry; no POST high-risk retry |
| W2 | **Blocked** | Remote repos await signed Auth/Wallet/Profile/Markets+Trade/P2P contracts |
| W3 | **Blocked** | Real `VITTRADE_KEYSTORE_*`, device smoke, staging `API_BASE_URL` ≠ `.invalid` |

Wave 1 FE-unblocked scope is **Done**. Wave 2/3 remain intentionally out of
implementation until BE/Ops unlocks — no remote repos and no invented OpenAPI.
