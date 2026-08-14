# Plan — Hoàn thiện tiếp theo (ưu tiên sau Wave 1 + Trust Polish)

**Date:** 2026-07-25  
**Authority:** `AGENTS.md`, ADR-010, `ke-hoach-san-sang-production.md`  
**Context:** Network Wave 1 đã merge (#81). UI Trust Polish PR
[#82](https://github.com/LonelyTraderBay/vittrade-flutter/pull/82)
**MERGED** @ `8b88dd17`. W0+W1 “hoàn thiện ngay” met; W2–4 vẫn BLOCKED.

## Hiện trạng ngắn

| Hạng mục | Trạng thái |
| --- | --- |
| UI system + Trust polish | ✅ `main` — PR [#82](https://github.com/LonelyTraderBay/vittrade-flutter/pull/82) MERGED @ `8b88dd17` |
| Network foundation (mapper, refresh, retry, fail-closed) | ✅ `main` |
| Remote repositories / OpenAPI | 🔒 BLOCKED (BE) |
| Release secrets + smoke device dài | 🔒 BLOCKED (Ops) |
| Money domain `double`→string | 🔒 Backlog (ADR riêng) |

---

## Wave 0 — Mở khóa PR #82 (ưu tiên #1 — làm ngay)

**Goal:** Enterprise Flutter Gates xanh → mark ready → squash-merge.

### Task 0.1 — `dart format`

CI Static fail ở `dart format --set-exit-if-changed .`.  
**Fix:** format toàn `flutter_app/` (hoặc các file dirty), commit `style:`.

### Task 0.2 — Làm mới audit artifacts (guardrail stale)

CI Guardrails fail (Expected exit 0):

- `back_navigation_behavior_guardrail_test`
- `top_header_action_guardrail_test`
- `card_tile_guardrail_test`

**Fix:** chạy audit tools tương ứng (generate/update CSV/MD trong
`docs/02_FLUTTER_MIGRATION/audits/` theo convention repo), rồi re-run 3
guardrail tests. Không “sửa test để xanh” nếu artifact là nguồn sự thật.

### Task 0.3 — Cập nhật golden pixels

CI Golden Windows fail:

- `trade_page_golden_test` (data state)
- `wallet_page_golden_test` (data + error fail-closed)
- `p2p_page_golden_test` (data state)

**Fix:** regenerate goldens trên Windows (cùng convention CI), review diff
visual (copy/density thay đổi là expected), commit goldens.

### Task 0.4 — Verify + merge Enterprise

```text
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test test/quality/back_navigation_behavior_guardrail_test.dart
flutter test test/quality/top_header_action_guardrail_test.dart
flutter test test/quality/card_tile_guardrail_test.dart
flutter test test/features/trade/golden test/features/wallet/golden test/features/p2p_core/golden
```

Push → chờ Gates xanh → mark ready → squash-merge `main`.

**Gate W0:** PR #82 MERGED.

---

## Wave 1 — FE còn làm được (sau #82, không cần BE)

Thứ tự ưu tiên; mỗi task ≤ ~10 file; SDD 1 implementer → 1 reviewer.

### Task 1.1 — Nits Trust còn lại (nhỏ)

Từ review A2/A5:

- Đồng bộ nhãn “Danh sách trắng” / `Whitelist` còn sót (AddressSavedState).
- (Optional) Withdraw confirm density `.relaxed` nếu không overflow phone.

**Cancel-ok** nếu đã hết sau golden refresh.

### Task 1.2 — Ratchet i18n vi-VN theo file chạm

Không mở PR dịch hết ~280 dòng baseline.  
Rule: mỗi PR tiếp theo chạm file trong `i18n_vi_only_baseline.txt` → dịch
và xóa dòng baseline trong cùng PR.

**Batch riêng (tuỳ chọn):** 1 module/PR (vd. wallet validation English còn lại).

### Task 1.3 — Hub offline-with-cache (gap C1)

Inventory C1 ghi: Home/Markets/Wallet thiếu offline-when-cache pattern đồng bộ.  
**Spec:** 1–2 batch; dùng `VitOfflineBanner` / pattern shared; không bịa API.

### Task 1.4 — A11y TalkBack smoke checklist (docs + 1 test mở rộng)

Checklist manual Android + bổ sung 1–2 semantics còn thiếu trên CTA P0
(nếu D1 còn lỗ).

### Task 1.5 — Architecture debt khi chạm

Không wave “tách hết part-file”. Rule: khi sửa file lớn → ưu tiên tách
widget sang `presentation/widgets/` nếu chạm > ngưỡng guardrail.

---

## Wave 2 — Production remote (BLOCKED đến khi BE ký)

| Thứ tự | Module | Unblock |
| --- | --- | --- |
| 2.1 | Auth remote + `/auth/refresh` shape thật | OpenAPI Auth ký |
| 2.2 | Wallet high-risk remote | Wallet contract ký |
| 2.3 | Profile/Security remote | Profile ký |
| 2.4 | Markets + Trade remote | Markets/Trade ký |
| 2.5 | P2P remote | P2P ký |

Quy trình mỗi module: contract → DTO → mapper → `remote_*` →
`guardedRepository` → tests → PR. **Cấm đoán schema.**

Skeletons sẵn: `docs/02_FLUTTER_MIGRATION/*-Backend-Contract-Skeleton.md`.

---

## Wave 3 — Release & vận hành (BLOCKED Ops / song song W0 sau)

| Task | Việc |
| --- | --- |
| 3.1 | GitHub secrets `VITTRADE_KEYSTORE_*` |
| 3.2 | Staging `API_BASE_URL` thật (không `.invalid`) |
| 3.3 | Chạy `flutter-release.yml` → artifact nội bộ |
| 3.4 | Smoke device P0 routes + logcat high-risk |
| 3.5 | Observability (crash + log policy + build SHA) — P1 beta |

---

## Wave 4 — Backlog có chủ đích (sau beta P0 remote tối thiểu)

| ID | Việc |
| --- | --- |
| 4.1 | ADR + migration money `double` → string/minor-unit (Wallet trước) |
| 4.2 | Module identity Earn / Launchpad / Predictions / Arena |
| 4.3 | Perf profile device thật (Trade/Markets/Wallet/P2P) |
| 4.4 | E2E / contract tests từ OpenAPI (P2) |

---

## Checklist thực thi

```text
[x] 0.1 Format CI
[x] 0.2 Refresh audit artifacts (back / header / card-tile)
[x] 0.3 Update goldens Trade/Wallet/P2P
[x] 0.4 Gates xanh → merge PR #82 (@ 8b88dd17)
[x] 1.1 Nits Trust (nếu còn)
[x] 1.2 i18n ratchet theo chạm file (process rule)
[x] 1.3 Offline-with-cache hubs — Cancelled (evidence)
[x] 1.4 TalkBack checklist
──── GATE: BE ký Auth ────
[ ] 2.1 … 2.5 remote theo thứ tự
[ ] 3.x secrets + smoke
[ ] 4.x backlog beta+
```

## Định nghĩa “hoàn thiện 100%”

| Phạm vi | Ý nghĩa |
| --- | --- |
| **Ngay** | W0 + W1 FE unblocked Done |
| **Production-ready thật** | + W2 Auth/Wallet tối thiểu + W3 secrets/smoke |
| **Không bịa** | W2 không Done bằng remote giả |

## SDD

Dùng phiên Codex hiện tại · không commit trừ user yêu cầu · batch ≤10 file ·
`flutter analyze` + focused tests mỗi task · ADR-010 giữ nguyên.

---

## Execution result (2026-07-25)

DOCUMENTER close-out for this plan. **No Dart production changes** in the
documenter pass. Evidence:

- Cancel pack: `flutter_app/run-artifacts/sdd/task-1.3-cancelled.md`
- Blocked pack: `flutter_app/run-artifacts/sdd/wave-2-4-blocked.md`
- Ledger: `.superpowers/sdd/progress-hoan-thien-tiep.md`

### Final status table

| ID | Task | Result |
| --- | --- | --- |
| 0.1 | `dart format` | **Approved** |
| 0.2 | Refresh audit artifacts | **Approved** |
| 0.3 | Update goldens Trade/Wallet/P2P | **Approved** |
| 0.4 | Verify + merge Enterprise | **MERGED** — [PR #82](https://github.com/LonelyTraderBay/vittrade-flutter/pull/82) @ `8b88dd17` (2026-07-25) |
| 1.1 | Nits Trust (Danh sách trắng) | **Approved** |
| 1.2 | i18n vi-VN ratchet theo file chạm | **Process rule** (no batch) |
| 1.3 | Hub offline-with-cache | **Cancelled** — no live `currentState`; needs product decision (C1 + GD4 explore) |
| 1.4 | A11y TalkBack smoke checklist | **Approved** |
| 2.x | Production remote | **Blocked** — signed OpenAPI/contracts |
| 3.x | Ops / secrets / device smoke | **Blocked** — `VITTRADE_KEYSTORE_*`, staging URL, device lab |
| 4.x | Money / identity / perf / E2E | **Blocked** — ADR + beta+ backlog |

**Định nghĩa “hoàn thiện ngay” (W0 + W1 FE unblocked):** **met** — 0.4
MERGED; W1 in-scope Done (1.3 Cancelled with evidence). **Production-ready
thật** still requires W2+W3 unlocks — not claimed Done.

FE leftover after merge tracked in
[`2026-07-26-fe-leftover-sdd.md`](./2026-07-26-fe-leftover-sdd.md).
