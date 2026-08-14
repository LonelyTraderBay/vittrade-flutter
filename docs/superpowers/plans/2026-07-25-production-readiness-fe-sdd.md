# Plan — Production readiness FE (Subagent-Driven)

**Date:** 2026-07-25  
**Branch:** `feat/p0-network-session-refresh`  
**Base:** `ff4903ac` (main)  
**Authority:** `AGENTS.md`, ADR-010, `ke-hoach-san-sang-production.md`  
**Ledger:** `.superpowers/sdd/progress-prod-fe.md`

## Goal

Hoàn thiện FE path tới production readiness **không bịa OpenAPI**.  
UI/UX đã đóng. Wave còn lại: network/auth session → remote repos (khi contract ký) → release/smoke.

## Global constraints

1. Dùng một phiên Codex nhất quán — không đổi model giữa batch.
2. **Không commit** trừ khi user yêu cầu rõ.
3. `core/` không import `app/`; session refresh nối qua provider overrides.
4. ADR-010: **không** tạo remote repository / DTO shape đoán cho tới khi BE ký JSON schema.
5. Auth skeleton: fail-closed khi `enableMockData == false` và chưa có remote thật.
6. Copy user-facing: tiếng Việt đủ dấu; không lộ token/PII ra log/UI.
7. Mỗi task ≤ ~10 file; verify: `flutter analyze` + focused tests; minimal-diff self-check.
8. Prediction Markets / Open Arena boundaries không liên quan wave này (network/core).

## Out of scope (blocked / external)

- Signed OpenAPI, staging API URL, GitHub signing secrets, manual device smoke.
- Inventing `remote_*_repository` implementations before contract sign-off.

---

## Task 1 — Retro-review B1+B2 (working tree)

**Status target:** review-only (implementation already in WIP)

**Spec (already implemented — reviewer verifies):**

### B1 Error mapper
- Pure mapper layer: status 400/401/403/404/409/422/429/5xx → vi-VN `ApiFailure.userMessage`
- Business codes: `INSUFFICIENT_BALANCE` (+ details), `LIMIT_EXCEEDED`; `NETWORK_UNAVAILABLE` → `OfflineFailure`
- Never use English BE `message` as UI copy
- Interceptor delegates to mapper; focused tests pass

### B2 Session refresh + SecureStore
- `SecureStoreKeys.authRefreshToken`
- `sessionRefreshInterceptor`: 401 → refresh once → retry; fail → logout/clear
- `AuthRepository.refreshSession` + mock/fail-closed
- `AuthSessionController`: persist access+refresh; `tryRefreshAccessToken`; clear all three keys on logout/corrupt restore
- Wire via `authSessionNetworkOverrides()` in `VitTradeApp`
- Auth fail-closed / operation error copy tiếng Việt
- Skeleton notes `POST /auth/refresh` as to-confirm (no invented response shape)
- Focused tests pass

**Files (expected):**
- `flutter_app/lib/core/network/api_error_mapper.dart` (new)
- `flutter_app/lib/core/network/session_refresh.dart` (new)
- `flutter_app/lib/core/network/api_client.dart`
- `flutter_app/lib/core/storage/secure_store.dart`
- `flutter_app/lib/app/providers/auth_controller_providers.dart`
- `flutter_app/lib/app/vit_trade_app.dart`
- `flutter_app/lib/features/auth/**` (domain/data/presentation touched)
- matching tests + i18n baseline line removal
- `docs/02_FLUTTER_MIGRATION/Auth-Backend-Contract-Skeleton.md` (refresh row)

**Verify evidence already claimed:**
```text
flutter test test/core/network/api_client_test.dart
flutter test test/features/auth/auth_session_controller_test.dart
flutter test test/features/auth/mock_auth_repository_test.dart
flutter test test/features/auth/data/fail_closed_auth_repository_test.dart
flutter test test/features/auth/login_page_test.dart
flutter test test/quality/i18n_vi_only_guardrail_test.dart
```

**Gate T1:** Reviewer Spec ✅ + Quality Approved (or fix loop). No new scope.

---

## Task 2 — Fix Critical/Important from Task 1 review (conditional)

Only if Task 1 finds Critical/Important. Scope = reviewer findings only.  
Re-verify focused tests listed in findings. No commit.

---

## Task 3 — P0 provider fail-closed ratchet (FE-only, unblocked)

**Goal:** Guardrail/test chứng minh Auth + Wallet + Trade + P2P + Markets + Profile  
providers fail-closed (không silent mock) khi `enableMockData == false` và không có `remote:`.

**Constraints:** Không thêm remote repo; chỉ test/guardrail (+ minimal provider fix nếu thiếu failClosed).

**Verify:**
```text
flutter test test/quality/<new_or_existing_fail_closed_guardrail>.dart --reporter=compact
flutter analyze
```

**Gate T3:** tests green; no remote invented; ≤10 files.

---

## Task 4+ — BLOCKED until BE signs contracts

| Task | Module | Unblock when |
| --- | --- | --- |
| 4 | Auth remote + DTO theo schema ký | Auth OpenAPI signed incl. `/auth/refresh` |
| 5 | Wallet remote high-risk | Wallet contract signed |
| 6 | Profile/Security remote | Profile contract signed |
| 7 | Markets + Trade remote | Markets/Trade contracts signed |
| 8 | P2P remote | P2P contract signed |
| 9 | Release secrets + smoke | Ops secrets + device QA |

Do **not** dispatch implementers for Task 4+ while blocked.

---

## SDD execution rules (VitTrade)

- One implementer subagent per task; then one reviewer; fix loop if needed.
- Controller writes brief/report/diff paths under `flutter_app/run-artifacts/sdd/`.
- Implementers: **do not git commit** unless plan task says user approved commits.
- Model: inherit session Auto — do not request Sonnet/Opus.
- After each approved task: append ledger line in `.superpowers/sdd/progress-prod-fe.md`.
