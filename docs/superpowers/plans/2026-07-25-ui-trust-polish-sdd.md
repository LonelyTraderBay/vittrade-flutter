# Plan — UI Trust Polish & hoàn thiện cảm quan (SDD)

**Date:** 2026-07-25  
**Base:** `main` (sau PR #81 Wave 1 network khi đã merge)  
**Authority:** `AGENTS.md`, `DESIGN.md`, standards trong
`docs/02_FLUTTER_MIGRATION/standards/`, ADR-010  
**Ledger:** `.superpowers/sdd/progress-ui-trust-polish.md`

## Goal

Đưa lớp **craft & trust** lên mức beta-ready **không redesign** hệ dark
enterprise, **không bịa remote API**. Mỗi task ≤ ~10 file; 1 implementer →
1 reviewer; chat mới mỗi batch.

## Non-goals

- Đổi palette / brand / Home thành landing marketing.
- Invent `remote_*_repository` / DTO (Wave production vẫn chờ BE).
- Quét toàn bộ 400+ màn trong một wave.
- Thêm motion trang trí, dependency UI mới trừ khi plan task yêu cầu.

## Definition of Done (wave này)

| Tiêu chí | Done khi |
| --- | --- |
| Trust P0 flows | 8 luồng high-risk có checklist craft PASS + focused tests |
| Density | 5–8 màn P0 gắn `VitDensity` đúng tier; audit density có gate tối thiểu |
| States | Empty/offline/error pattern đồng bộ trên P0 (Vit* shared) |
| A11y | TalkBack smoke + semantics CTA tiền trên P0 |
| i18n chạm file | Không thêm English baseline; dịch khi sửa file |
| Motion | ≤3 chỗ intentional, không Lottie lung tung |

**Ngoài wave (vẫn BLOCKED / backlog riêng):** remote BE, money `double`→string
domain, signing secrets, device release smoke dài.

---

## Wave A — Trust hierarchy (ưu tiên #1)

### Task A1 — Chuẩn craft high-risk (docs + checklist, không UI lớn)

**Spec:** Thêm checklist ngắn vào
`docs/02_FLUTTER_MIGRATION/standards/High-Risk-State-Standard.md` (hoặc
addendum):

1. Preview và Confirm dùng cùng scale số (`amount*` / `heroNumber` nhất quán).
2. Trước CTA cuối: fee + network + địa chỉ (mask) + “không hoàn tác” / next step.
3. CTA cuối disabled đến khi đủ điều kiện; enabled có feedback rõ.
4. Copy tiếng Việt đủ dấu; không English mới.
5. `VitHighRiskStatePanel` + `highRiskContractId` bắt buộc (đã có guardrail).

**Verify:** docs only; reviewer đọc checklist.  
**Files:** ≤2.

### Task A2 — Wallet withdraw + address-add polish

**Scope pages:** `withdraw_page` (+ parts/widgets liên quan), address-add
agreement/flow.  
**Spec:** Áp checklist A1; đồng bộ typography số; mask địa chỉ; khoảng thở
density `.relaxed` hoặc tương đương trên bước confirm.  
**Verify:** focused wallet tests + analyze; high_risk guardrail.  
**Files:** ≤10.

### Task A3 — Transfer + token-approval polish

**Scope:** transfer confirm/preview, token approval revoke preview/confirm.  
**Spec:** như A1.  
**Verify:** focused wallet tests + analyze.

### Task A4 — P2P payment-method + escrow/order risk surfaces

**Scope:** payment method add/ownership/cooling + P2P home/order risk panel
đã trong guardrail table.  
**Spec:** A1 + Arena copy không lẫn tiền.  
**Verify:** p2p focused tests + product_copy nếu chạm copy.

### Task A5 — Profile security + Trade riskReview craft

**Scope:** `security_page`, trade riskReview panel (không redesign chart).  
**Spec:** A1; Trade giữ density compact cho form, panel risk rõ.  
**Verify:** focused tests + high_risk guardrail.

**Gate Wave A:** 5 task Approved; không tăng i18n English baseline.

---

## Wave B — Density & nhận thức (ưu tiên #2)

### Task B1 — Gắn density audit vào quy trình

**Spec:** Thêm bước CI hoặc guardrail test tối thiểu gọi
`ui_fullscreen_density_audit.dart --check` và/hoặc
`visual_density_risk_audit.dart --check` trên **allowlist P0** (không fail
toàn repo ngày 1 nếu baseline bẩn — ratchet: fail khi regress allowlist).  
**Files:** workflow hoặc `test/quality/*density*`, có thể cập nhật baseline
artifact.  
**Verify:** audit --check trên allowlist PASS.

### Task B2 — Chốt tier 5–8 màn P0

| Màn | Tier đề xuất |
| --- | --- |
| Trade root / form | `.compact` / `.tool` |
| Markets list | `.compact` |
| Wallet overview | `.standard` |
| Withdraw / Transfer confirm | `.relaxed` |
| P2P escrow/confirm | `.relaxed` |
| Security change | `.relaxed` |
| Home root | giữ reference (không đổi lớn) |

**Spec:** Chỉ chỉnh spacing/padding qua `VitDensity` / page rhythm — không
đổi business logic.  
**Batches:** B2a Trade+Markets; B2b Wallet+P2P+Security.  
**Verify:** page_rhythm + density allowlist + focused widget tests.

---

## Wave C — Empty / offline / error đồng bộ (ưu tiên #3)

### Task C1 — Inventory P0

**Spec:** Bảng route P0 → primitive đang dùng (`VitEmptyState` /
`VitErrorState` / `VitOfflineBanner` / local). Artifact
`flutter_app/run-artifacts/sdd/empty-offline-error-p0.md`.  
**Cancel-ok partial:** chỉ list, không sửa hết một lần.

### Task C2 — Thay local state lệch chuẩn (1–2 batch)

**Spec:** Mỗi batch ≤5 màn; map sang Vit*; copy vi-VN; CTA primary rõ.  
**Verify:** focused page tests + notice/offline guardrails nếu có.

---

## Wave D — A11y & motion (ưu tiên #4)

### Task D1 — Semantics CTA tiền P0

**Spec:** Semantics label tiếng Việt cho Mua/Bán, Xác nhận rút, số tiền
chính trên 5–8 màn Wave A.  
**Verify:** existing a11y tests mở rộng hoặc test mới nhỏ; TalkBack manual
checklist trong Notes PR.

### Task D2 — Motion tối thiểu (shared only)

**Spec:** Thống nhất duration/curve cho (1) notice sheet, (2) CTA enable
high-risk nếu thiếu, (3) không thêm animation Home.  
Ưu tiên chỉnh shared widget — tránh per-page tweens.  
**Verify:** analyze + smoke widget test nếu chạm shared.

---

## Wave E — Copy & số liệu cảm quan (ưu tiên #5, song song khi chạm file)

### Task E1 — Ratchet i18n khi chạm

**Rule:** Mọi PR Wave A–D nếu đụng file trong
`i18n_vi_only_baseline.txt` → dịch dòng đó trong cùng PR (không phình
baseline).  
Không mở PR “dịch hết 280 dòng” trừ khi user yêu cầu riêng.

### Task E2 — Numeric alignment (Trade/Markets/Wallet strips)

**Spec:** Tabular/amount tokens; căn cột giá/% trên 1–2 list P0.  
**Verify:** design_token audit nếu chạm typography; focused tests.

---

## Wave F — Backlog tách (không block “hoàn thiện cảm quan”)

| ID | Việc | Unblock |
| --- | --- | --- |
| F1 | Auth/Wallet/… remote | OpenAPI ký |
| F2 | Money domain `double`→string | ADR + migration riêng |
| F3 | Release secrets + device smoke dài | Ops |
| F4 | Module identity Earn/Launchpad/Predictions/Arena | Sau beta P0 |
| F5 | Perf profile device thật | Device lab |

---

## Thứ tự thực thi (checklist)

```text
[ ] A1 Checklist craft high-risk (docs)
[ ] A2 Withdraw + address-add
[ ] A3 Transfer + token approval
[ ] A4 P2P payment + escrow surfaces
[ ] A5 Security + Trade riskReview
[ ] B1 Density ratchet CI/allowlist
[ ] B2a Trade+Markets density
[ ] B2b Wallet+P2P+Security density
[ ] C1 Inventory empty/offline/error
[ ] C2 Fix batches (1–2)
[ ] D1 Semantics CTA tiền
[ ] D2 Motion shared tối thiểu
[ ] E1/E2 khi chạm file (không wave riêng bắt buộc)
──── Gate cảm quan beta ────
[ ] F* khi BE/Ops sẵn (plan production riêng)
```

## SDD rules

1. Dùng phiên Codex hiện tại; không đổi model giữa batch.
2. Không commit trừ user yêu cầu.  
3. GitNexus `impact` trước khi sửa symbol (nếu index sẵn).  
4. Batch gate: minimal-diff + `flutter analyze` + focused tests.  
5. High-risk: luôn preview → confirm; mask PII.  
6. Prediction Markets / Open Arena boundaries không đụng nhầm.

## Verify block (mỗi task code)

```powershell
cd flutter_app
flutter analyze
flutter test test/quality/high_risk_state_primitives_guardrail_test.dart --reporter=compact
# + focused tests của module trong task
```

Sau Wave B thêm:

```powershell
dart run tool/ui_fullscreen_density_audit.dart --check
# hoặc guardrail allowlist tương đương
```

---

## Execution result

**Closed:** 2026-07-25 · Ledger: `.superpowers/sdd/progress-ui-trust-polish.md`  
**Blocked pack:** `flutter_app/run-artifacts/sdd/task-f-backlog-blocked.md`  
**Artifacts:** `flutter_app/run-artifacts/sdd/task-a*-*.md`, `task-b*-*.md`,
`task-c1c2-*.md`, `task-d1d2-implementer.md`, `empty-offline-error-p0.md`

| ID | Result | Summary |
| --- | --- | --- |
| A1 | **Approved** | High-risk craft checklist + vi-VN wire example (docs only) |
| A2 | **Approved** | Withdraw + address-add craft (approve with nits) |
| A3 | **Approved** | Transfer confirm + token revoke craft |
| A4 | **Approved** | P2P payment-method + hub escrow risk surfaces |
| A5 | **Approved** | Security + Trade riskReview craft; no chart redesign |
| B1 | **Approved** | P0 density allowlist ratchet + guardrail test |
| B2 | **Approved** | VitDensity tiers on P0 (approve with nits; some surfaces no-op) |
| C1 | **Approved** | P0 empty/offline/error inventory artifact |
| C2 | **No-op Approved** | `needs_fix` = 0 — no Dart replace batch |
| D1 | **Approved** | Semantics CTA tiền on Wave A gaps; partial surface no-ops |
| D2 | **Cancelled** | YAGNI — shared notice/CTA motion already consistent |
| F1 | **Blocked** | Remote Auth/Wallet/… await signed OpenAPI |
| F2 | **Blocked** | Money `double`→string needs ADR + migration |
| F3 | **Blocked** | Release secrets + long device smoke need Ops |
| F4 | **Blocked** | Module identity Earn/Launchpad/Predictions/Arena after beta P0 |
| F5 | **Blocked** | Perf profile on real device needs device lab |

Waves **A–D** craft scope is **Done**. Wave **F** remains intentionally out of
implementation until BE/Ops/device unlocks — no remote repos, no money-type
migration, no secrets, no device lab work in this wave.
