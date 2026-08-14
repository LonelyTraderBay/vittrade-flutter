# Kế hoạch Ponytail Audit — Toàn module VitTrade (Sequential Runbook)

**Phiên bản:** 2.1 (2026-07-02)
**Mục đích:** Cho Codex quét over-engineering **từng bước một**, không bỏ sót, không gộp việc.
**Chế độ audit:** Chỉ ghi ledger — **KHÔNG sửa code** trong bước audit.
**Skill:** `.codex/skills/ponytail-audit/SKILL.md`
**Shell chung:** `docs/01_AI_RULES/AI_PROMPT_SHELL.md`

> **Ghi đè quy tắc:** File này **ghi đè** mục "Non-stop execution" trong `AI_PROMPT_SHELL.md`
> cho riêng workflow ponytail audit. Mỗi chat = **đúng 1 STEP**, sau đó **DỪNG** và chờ user xác nhận.

---

## Muc luc

1. [Luat thuc thi bat buoc (AI doc truoc)](#1-luat-thuc-thi-bat-buoc-ai-doc-truoc)
2. [Cach nguoi van hanh dieu khien](#2-cach-nguoi-van-hanh-dieu-khien)
3. [File tien do](#3-file-tien-do)
4. [Bang STEP tuan tu (71 buoc)](#4-bang-step-tuan-tu-71-buoc)
5. [Quy trinh 6 buoc trong moi chat audit](#5-quy-trinh-6-buoc-trong-moi-chat-audit)
6. [Acceptance gate + completion lines](#6-acceptance-gate--completion-lines)
7. [Prompt copy-paste (mau)](#7-prompt-copy-paste-mau)
8. [Chi tiet tung giai doan + sub-step module lon](#8-chi-tiet-tung-giai-doan--sub-step-module-lon)
9. [Buoc MERGE (module lon)](#9-buoc-merge-module-lon)
10. [Giai doan FIX (tach rieng, sau audit)](#10-giai-doan-fix-tach-rieng-sau-audit)
11. [Scan patterns + khong flag](#11-scan-patterns--khong-flag)
12. [Handoff khi context day](#12-handoff-khi-context-day)
13. [Bang prompt STEP tiep theo (lookup)](#13-bang-prompt-step-tiep-theo-lookup)

---

## 1. Luat thuc thi bat buoc (AI doc truoc)

### 1.1 Mot chat = mot STEP

| Rule | Mo ta |
| --- | --- |
| **R1** | Mỗi phiên Codex chỉ được làm **đúng 1 STEP** trong bảng Section 4. |
| **R2** | Xong STEP → ghi ledger (hoac partial ledger) → cap nhat file tien do → **DUNG**. |
| **R3** | **Cam** tu dong chay STEP tiep theo trong cung chat. |
| **R4** | **Cam** gop audit + fix trong cung chat. |
| **R5** | **Cam** gop 2 STEP (vd. trade + wallet) trong 1 chat. |
| **R6** | Module > 45 file `.dart` → **bat buoc** dung sub-step (P1/P2…, W1/W2…) da dinh nghia. |
| **R7** | Het sub-step cua module → chay buoc **MERGE** rieng truoc khi danh ✅ module. |

### 1.2 Khối HANDOFF bắt buộc (mọi STEP — kể cả MERGE)

> **Một format duy nhất** cho partial (P/W), module nhỏ, MERGE, debt, master, sync.
> **Không** thay bằng bảng tóm tắt, bullet findings, hay chỉ dòng `PONYTAIL AUDIT DONE`.
> Tag audit (`PONYTAIL AUDIT DONE`, `PARTIAL DONE`, …) nằm **bên trong** khối, không thay khối.

AI **phải** kết thúc message bằng **đúng khối sau** — là **dòng cuối cùng** của reply (không thêm gì sau `---`):

```text
---
✅ STEP-<NNN> HOÀN THÀNH: <mô tả ngắn STEP>

Ledger: flutter_app/run-artifacts/<artifact>
Findings: delete=X | yagni=X | shrink=X | reuse-vit=X | token-drift=X
Audit tag: <PONYTAIL AUDIT PARTIAL DONE: STEP-NNN — … | PONYTAIL AUDIT DONE: AUDIT-XX — … | (bỏ dòng nếu không áp dụng)>

⏭ STEP TIẾP THEO: STEP-<NNN+1> — <mô tả ngắn>

📋 COPY prompt này vào CHAT MỚI (New Chat → paste → Enter):

Chạy STEP-<NNN+1> theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md

⚠️ DỪNG ĐÂY — KHÔNG chạy STEP-<NNN+1> trong chat này.
---
```

**Ví dụ STEP-013 (MERGE trade) — bắt buộc copy prompt STEP-014:**

```text
---
✅ STEP-013 HOÀN THÀNH: MERGE module trade

Ledger: flutter_app/run-artifacts/ponytail-audit-trade-YYYY-MM-DD.md
Findings: delete=4 | yagni=42 | shrink=59 | reuse-vit=25 | token-drift=1
Audit tag: PONYTAIL AUDIT DONE: AUDIT-01 — trade

⏭ STEP TIẾP THEO: STEP-014 — wallet pages (P1)

📋 COPY prompt này vào CHAT MỚI (New Chat → paste → Enter):

Chạy STEP-014 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md

⚠️ DỪNG ĐÂY — KHÔNG chạy STEP-014 trong chat này.
---
```

**STEP-071 (bước cuối audit)** — thay `STEP TIẾP THEO` bằng:

```text
⏭ GIAI ĐOẠN TIẾP THEO: FIX (sau master) — xem Section 10

📋 COPY prompt FIX batch 1 vào CHAT MỚI (khi sẵn sàng sửa code):

Đọc flutter_app/run-artifacts/ponytail-audit-master-summary-*.md
Fix batch 1 theo master summary (tối đa 8 file). vittrade-minimal-review + flutter analyze + test.

⚠️ DỪNG ĐÂY — audit 71/71 xong; FIX = chat khác.
---
```

### 1.3 Thứ tự nội dung trong reply (tránh lỗi STEP-013)

| Thứ tự | Nội dung | Giới hạn |
| ---: | --- | --- |
| 1 | Tóm tắt ngắn (1–3 câu) + link artifact | Tùy chọn |
| 2 | Top 3 findings (bullet) | Tùy chọn, **tối đa 3** |
| 3 | **Khối HANDOFF Section 1.2** | **Bắt buộc, cuối message** |

**Invalid stop (cấm):**
- Kết thúc chỉ bằng `PONYTAIL AUDIT DONE: …` **không** có khối 1.2
- `Next step: STEP-014` một dòng **không** kèm block copy prompt đầy đủ
- Bảng top 5/top 30 **thay** cho khối handoff
- "Bạn muốn tiếp tục không?" / "Shall I run STEP-014?"
- Tự chạy STEP tiếp theo trong cùng chat
- Fix code trong audit turn
- Bất kỳ text nào **sau** dòng `---` đóng của khối handoff

### 1.4 Thứ tự ưu tiên STEP

Chạy **đúng thứ tự STEP-001 → STEP-071**. Không nhảy cóc trừ khi user yêu cầu rõ.
Prompt STEP tiếp theo: tra **Section 13** hoặc dùng công thức cố định ở khối 1.2.

---

## 2. Cach nguoi van hanh dieu khien

### Khoi dong lan dau

```text
Chay STEP-001 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md
```

### Moi lan tiep theo (chat moi)

```text
Chay STEP-<NNN> theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md
```

Hoac doc file tien do va chon STEP co trang thai ⬜.

### Checklist nguoi van hanh

- [ ] Mở **phiên Codex mới** cho mỗi STEP
- [ ] Chi paste **1** prompt STEP
- [ ] Xác nhận AI trả về **khối HANDOFF Section 1.2** (có dòng `Chạy STEP-NNN+1 theo docs/...`)
- [ ] **Không** chấp nhận reply chỉ có `PONYTAIL AUDIT DONE` hoặc `Next step:` một dòng
- [ ] Kiem tra artifact ton tai trong `flutter_app/run-artifacts/`
- [ ] Kiem tra `ponytail-audit-progress.md` da cap nhat
- [ ] Moi chat tiep theo

---

## 3. File tien do

**Duong dan:** `flutter_app/run-artifacts/ponytail-audit-progress.md`

AI **tao file lan dau** (STEP-001) va **cap nhat sau moi STEP**.

### Mau file tien do

```markdown
# Ponytail Audit Progress

Last updated: YYYY-MM-DD
Current step: STEP-NNN
Next step: STEP-NNN+1

| STEP | ID | Scope | Artifact | Status | Date |
| --- | --- | --- | --- | --- | --- |
| 001 | AUDIT-00A | shared/widgets | ponytail-audit-shared-widgets-....md | done | 2026-07-02 |
| 002 | AUDIT-00B | shared/layout | ... | pending | |
...

## Stats
- Steps done: X / 71
- Modules fully audited: X / 23
- Merge steps done: X / 9
```

**Status values:** `pending` | `in_progress` | `done` | `blocked`

---

## 4. Bang STEP tuan tu (71 buoc)

> **Quy tac dat ten artifact:** `ponytail-audit-<scope>-YYYY-MM-DD.md`
> Sub-step: them hau to `-p1`, `-w2`, v.v.

### Giai doan 0 — Nen dung chung (STEP 001–003)

| STEP | ID | Scope | ~Files | Artifact |
| ---: | --- | --- | ---: | --- |
| 001 | AUDIT-00A | `shared/widgets/` | 45 | `ponytail-audit-shared-widgets-YYYY-MM-DD.md` |
| 002 | AUDIT-00B | `shared/layout/` | 11 | `ponytail-audit-shared-layout-YYYY-MM-DD.md` |
| 003 | AUDIT-00C | `app/theme/` | 11 | `ponytail-audit-app-theme-YYYY-MM-DD.md` |

### Giai doan 1A — trade (STEP 004–013)

| STEP | Sub | Scope (alphabetical) | Artifact |
| ---: | --- | --- | --- |
| 004 | P1 | `trade/presentation/pages/` active_copies → complaint_submission | `...-trade-p1-...md` |
| 005 | P2 | pages complaint_tracking → market_data_analytics_part_04 | `...-trade-p2-...md` |
| 006 | P3 | pages ombudsman_referral → transaction_reporting | `...-trade-p3-...md` |
| 007 | W1 | `trade/presentation/widgets/` advanced_chart_area → bot_performance_charts_strategy | `...-trade-w1-...md` |
| 008 | W2 | widgets bot_performance_metrics → copy_audit_log_controls | `...-trade-w2-...md` |
| 009 | W3 | widgets copy_audit_log_events → execution_quality_common | `...-trade-w3-...md` |
| 010 | W4 | widgets execution_quality_overview → performance_attribution_summary_tabs | `...-trade-w4-...md` |
| 011 | W5 | widgets performance_attribution_tabs → trade_body_review_widgets | `...-trade-w5-...md` |
| 012 | W6 | widgets trade_formatters → vit_trade_terminal_header | `...-trade-w6-...md` |
| 013 | MERGE | Gop P1–P3 + W1–W6 | `ponytail-audit-trade-YYYY-MM-DD.md` |

### Giai doan 1B — wallet (STEP 014–017)

| STEP | Sub | Scope | Artifact |
| ---: | --- | --- | --- |
| 014 | P1 | `wallet/presentation/pages/` (22 files) | `...-wallet-p1-...md` |
| 015 | W1 | widgets asset_detail → wallet_manager_common | `...-wallet-w1-...md` |
| 016 | W2 | widgets wallet_manager_distribution → withdraw_preview_sheet | `...-wallet-w2-...md` |
| 017 | MERGE | Gop wallet partials | `ponytail-audit-wallet-YYYY-MM-DD.md` |

### Giai doan 1C — p2p (STEP 018–024)

| STEP | Sub | Scope | Artifact |
| ---: | --- | --- | --- |
| 018 | P1 | pages p2p_2fa → p2p_fraud_prevention | `...-p2p-p1-...md` |
| 019 | P2 | pages p2p_fund_lock → p2p_payment_method_ownership | `...-p2p-p2-...md` |
| 020 | P3 | pages p2p_payment_verification → p2p_wallet_transfer | `...-p2p-p3-...md` |
| 021 | W1 | widgets p2p_2fa_common → p2p_guide_safety | `...-p2p-w1-...md` |
| 022 | W2 | widgets p2p_guide_tabs → p2p_settings_hours_common | `...-p2p-w2-...md` |
| 023 | W3 | widgets p2p_settings_trade → p2p_wallet_transfer_form | `...-p2p-w3-...md` |
| 024 | MERGE | Gop p2p partials | `ponytail-audit-p2p-YYYY-MM-DD.md` |

### Giai doan 2A — earn (STEP 025–032)

| STEP | Sub | Scope | Artifact |
| ---: | --- | --- | --- |
| 025 | P1 | pages auto_compound → savings_product_detail | `...-earn-p1-...md` |
| 026 | P2 | pages savings_receipt → staking_insurance | `...-earn-p2-...md` |
| 027 | P3 | pages staking_insurance_p1 → staking_withdrawal_p3 | `...-earn-p3-...md` |
| 028 | W1 | widgets savings_analytics → savings_what_if_asset | `...-earn-w1-...md` |
| 029 | W2 | widgets savings_what_if_common → staking_guide_sections | `...-earn-w2-...md` |
| 030 | W3 | widgets staking_history → staking_social_feed_common | `...-earn-w3-...md` |
| 031 | W4 | widgets staking_social_sections → staking_validator_summary | `...-earn-w4-...md` |
| 032 | MERGE | Gop earn partials | `ponytail-audit-earn-YYYY-MM-DD.md` |

### Giai doan 2B — launchpad (STEP 033–036)

| STEP | Sub | Scope | Artifact |
| ---: | --- | --- | --- |
| 033 | P1 | pages launchpad_abi_diff → launchpad_webhooks_p4 | `...-launchpad-p1-...md` |
| 034 | W1 | widgets launchpad_abi_entries → launchpad_notif_categories | `...-launchpad-w1-...md` |
| 035 | W2 | widgets launchpad_notif_controls → launchpad_webhooks_state | `...-launchpad-w2-...md` |
| 036 | MERGE | Gop launchpad partials | `ponytail-audit-launchpad-YYYY-MM-DD.md` |

### Giai doan 2C — arena (STEP 037–040)

| STEP | Sub | Scope | Artifact |
| ---: | --- | --- | --- |
| 037 | P1 | pages arena_blocked → arena_safety_center | `...-arena-p1-...md` |
| 038 | P2 | pages arena_smart_rule → verified_challenges | `...-arena-p2-...md` |
| 039 | W1 | widgets (45 files) | `...-arena-w1-...md` |
| 040 | MERGE | Gop arena partials | `ponytail-audit-arena-YYYY-MM-DD.md` |

> **Ranh gioi:** Arena = points-only. Khong flag copy bat buoc theo AGENTS.md.

### Giai doan 2D — markets (STEP 041–044)

| STEP | Sub | Scope | Artifact |
| ---: | --- | --- | --- |
| 041 | P1 | pages (37 files) | `...-markets-p1-...md` |
| 042 | W1 | widgets comparison → market_screener_filters | `...-markets-w1-...md` |
| 043 | W2 | widgets market_screener_results → watchlist_toolbar | `...-markets-w2-...md` |
| 044 | MERGE | Gop markets partials | `ponytail-audit-markets-YYYY-MM-DD.md` |

### Giai doan 2E — predictions (STEP 045–048)

| STEP | Sub | Scope | Artifact |
| ---: | --- | --- | --- |
| 045 | P1 | pages (25 files) | `...-predictions-p1-...md` |
| 046 | W1 | widgets prediction_data → prediction_tournaments_empty | `...-predictions-w1-...md` |
| 047 | W2 | widgets prediction_tournaments_list → predictions_search_sections | `...-predictions-w2-...md` |
| 048 | MERGE | Gop predictions partials | `ponytail-audit-predictions-YYYY-MM-DD.md` |

### Giai doan 2F — dca (STEP 049–051)

| STEP | Sub | Scope | Artifact |
| ---: | --- | --- | --- |
| 049 | P1 | pages (30 files) | `...-dca-p1-...md` |
| 050 | W1 | widgets (30 files) | `...-dca-w1-...md` |
| 051 | MERGE | Gop dca partials | `ponytail-audit-dca-YYYY-MM-DD.md` |

### Giai doan 3 — Tai khoan (STEP 052–055) — 1 STEP / module

| STEP | ID | Module | ~Files | Artifact |
| ---: | --- | --- | ---: | --- |
| 052 | AUDIT-10 | auth/presentation/ | 15 | `ponytail-audit-auth-...md` |
| 053 | AUDIT-11 | profile/presentation/ | 40 | `ponytail-audit-profile-...md` |
| 054 | AUDIT-12 | onboarding/presentation/ | 4 | `ponytail-audit-onboarding-...md` |
| 055 | AUDIT-13 | notifications/presentation/ | 3 | `ponytail-audit-notifications-...md` |

### Giai doan 4 — Kham pha (STEP 056–060)

| STEP | ID | Module | ~Files | Artifact |
| ---: | --- | --- | ---: | --- |
| 056 | AUDIT-14 | home/presentation/ | 4 | `ponytail-audit-home-...md` |
| 057 | AUDIT-15 | discovery/presentation/ | 11 | `ponytail-audit-discovery-...md` |
| 058 | AUDIT-16 | news/presentation/ | 3 | `ponytail-audit-news-...md` |
| 059 | AUDIT-17 | referral/presentation/ | 16 | `ponytail-audit-referral-...md` |
| 060 | AUDIT-18 | rewards/presentation/ | 1 | `ponytail-audit-rewards-...md` |

### Giai doan 5 — Van hanh (STEP 061–064)

| STEP | ID | Module | ~Files | Artifact |
| ---: | --- | --- | ---: | --- |
| 061 | AUDIT-19 | support/presentation/ | 11 | `ponytail-audit-support-...md` |
| 062 | AUDIT-20 | admin/presentation/ | 15 | `ponytail-audit-admin-...md` |
| 063 | AUDIT-21 | cross_module/presentation/ | 21 | `ponytail-audit-cross-module-...md` |
| 064 | AUDIT-22 | enterprise_states/presentation/ | 4 | `ponytail-audit-enterprise-states-...md` |

### Giai doan 6 — Dev (STEP 065)

| STEP | ID | Module | Artifact |
| ---: | --- | --- | --- |
| 065 | AUDIT-23 | dev/presentation/ | `ponytail-audit-dev-...md` |

### Giai doan 7 — Data/domain (STEP 066–068)

| STEP | Sub | Scope | Artifact |
| ---: | --- | --- | --- |
| 066 | DD-A | `features/trade,earn,p2p/wallet/markets/launchpad/*/data+domain` | `...-data-domain-a-...md` |
| 067 | DD-B | `features/arena,predictions,dca,profile,auth/*/data+domain` | `...-data-domain-b-...md` |
| 068 | MERGE | Gop DD-A + DD-B + modules nho con lai | `ponytail-audit-data-domain-...md` |

**DD-A path cu the:**
- `flutter_app/lib/features/trade/data/`, `trade/domain/`
- `flutter_app/lib/features/earn_core/data/`, `earn/domain/`
- `flutter_app/lib/features/p2p_core/data/`, `p2p_core/domain/` (+ siblings presentation)
- `flutter_app/lib/features/wallet/data/`, `wallet/domain/`
- `flutter_app/lib/features/markets/data/`, `markets/domain/`
- `flutter_app/lib/features/launchpad/data/`, `launchpad/domain/`

**DD-B path cu the:** tat ca module con lai co `data/` hoac `domain/`.

### Giai doan 8 — Debt (STEP 069)

| STEP | ID | Scope | Artifact |
| ---: | --- | --- | --- |
| 069 | AUDIT-25 | Toan repo comment `// ponytail:` | `ponytail-debt-...md` |

Skill: `~/.codex/skills/ponytail-debt/SKILL.md`

### Giai doan 9 — Master summary (STEP 070)

| STEP | ID | Input | Artifact |
| ---: | --- | --- | --- |
| 070 | AUDIT-26 | Tat ca ledger + debt | `ponytail-audit-master-summary-...md` |

**Dieu kien:** STEP 001–069 deu `done` trong progress file.

### Giai doan 10 — Dong bo tracker (STEP 071)

| STEP | ID | Viec | Artifact |
| ---: | --- | --- | --- |
| 071 | SYNC | Kiem tra 23/23 module + MISSING report | Cap nhat `ponytail-audit-progress.md` final |

**Completion toan ke hoach:**
`PONYTAIL AUDIT MASTER DONE — 71/71 STEPS — 23/23 MODULES`

---

## 5. Quy trinh 6 buoc trong moi chat audit

AI thuc hien **dung thu tu** trong 1 chat (1 STEP):

| # | Buoc | Mo ta |
| ---: | --- | --- |
| 1 | **PRE-FLIGHT** | Doc shell + skill + STEP nay. Xac nhan scope va file list. |
| 2 | **INVENTORY** | Dem file `.dart` trong scope; ghi vao ledger header. Neu lech voi bang STEP → bao `BLOCKED`. |
| 3 | **SCAN** | Quet tung file: reuse-vit, yagni, delete, shrink, token-drift. GitNexus `query()` truoc reuse-vit. |
| 4 | **WRITE** | Ghi artifact (partial hoac full). Toi thieu 5 findings co impact cao, hoac ghi "Lean slice". |
| 5 | **PROGRESS** | Cap nhat `ponytail-audit-progress.md` (STEP = done). |
| 6 | **STOP** | In **khối HANDOFF Section 1.2** (bắt buộc cuối message). **Không làm gì thêm.** |

---

## 6. Acceptance gate + completion lines

> **Ledger file** (artifact) và **handoff chat** (Section 1.2) là hai thứ khác nhau.
> Tag `PONYTAIL AUDIT DONE` / `PARTIAL DONE` ghi **trong ledger** và **trong dòng Audit tag** của khối 1.2 — **không** thay khối handoff.

### 6.1 Partial ledger (sub-step P/W)

```markdown
# Ponytail audit (partial) — <scope-sub> — <date>

## Scope
- STEP: STEP-NNN
- Paths: ...
- Files inventoried: N
- File range: <first.dart> → <last.dart>

## Findings
1. <file>:L<line>: <tag> ...

## Summary
- delete: N | yagni: N | shrink: N | reuse-vit: N | token-drift: N
```

**Audit tag (trong khối 1.2):** `PONYTAIL AUDIT PARTIAL DONE: STEP-NNN — <scope-sub>`

### 6.2 Merged ledger (sau MERGE step)

```markdown
# Ponytail audit — <module> — <date>

## Scope
- Module: ...
- Sub-steps merged: P1..Pn, W1..Wn
- Total files: N

## Top findings (ranked)
1. ...

## Summary
- delete: N | yagni: N | shrink: N | reuse-vit: N | token-drift: N
- net: ~-<lines> lines possible

## Do-not-cut acknowledged
- ...
```

**Audit tag (trong khối 1.2):** `PONYTAIL AUDIT DONE: AUDIT-XX — <module>`

**Handoff bắt buộc:** Khối Section 1.2 với prompt `Chạy STEP-<NNN+1> theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` (vd. STEP-013 → STEP-014).

### 6.3 Master (STEP-070)

- Top 50 findings xep hang impact
- Tong theo tag
- 10 batch fix de xuat (5–8 file/batch)
- Danh sach MISSING (module chua co merged ledger)

**Audit tag (trong khối 1.2):** `PONYTAIL AUDIT MASTER DONE — 71/71 STEPS — 23/23 MODULES` (chỉ STEP-071 hoặc sau SYNC)

**Handoff STEP-070 → 071:** prompt `Chạy STEP-071 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md`

---

## 7. Prompt copy-paste (mau)

### 7.1 Prompt khoi dong (STEP bat ky)

```text
Doc va tuan thu:
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (tru Non-stop — uu tien file ke hoach nay)
- .codex/skills/ponytail-audit/SKILL.md
- docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md

NHIEM VU: PONYTAIL AUDIT — chi 1 STEP, chi ledger, KHONG sua code.

STEP: STEP-<NNN>
ID: <AUDIT-ID hoac sub>
Scope: <duong dan day du>
Artifact: flutter_app/run-artifacts/<ten-file>.md

Thuc hien quy trinh 6 buoc (Section 5).
Cap nhat flutter_app/run-artifacts/ponytail-audit-progress.md.
Ket thuc bang KHOI HANDOFF Section 1.2 (copy day du prompt STEP tiep theo) — DUNG, khong chay STEP tiep theo.
Khong ket thuc chi bang PONYTAIL AUDIT DONE hoac bang tom tat dai.
```

### 7.2 Prompt MERGE (vi du trade STEP-013)

```text
Doc ke hoach ponytail audit Section 1.2, 9, 13.

STEP: STEP-013 | MERGE trade
Doc partial ledgers:
- ponytail-audit-trade-p1-*.md .. ponytail-audit-trade-w6-*.md

Gop thanh ponytail-audit-trade-YYYY-MM-DD.md
- Xep hang lai top findings toan module (bo trung lap)
- Tinh summary + net lines
- KHONG sua code
Cap nhat progress.
Ket thuc bang KHOI HANDOFF Section 1.2 — bat buoc co prompt copy:
  Chạy STEP-014 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md
DUNG — khong chay STEP-014 trong chat nay.
```

### 7.3 Prompt STEP dau tien (copy ngay)

```text
Chay STEP-001 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md
```

---

## 8. Chi tiet tung giai doan + sub-step module lon

### 8.0 Giai doan 0 — Nen (STEP 001–003)

| STEP | Prompt scope |
| ---: | --- |
| 001 | `flutter_app/lib/shared/widgets/` |
| 002 | `flutter_app/lib/shared/layout/` |
| 003 | `flutter_app/lib/app/theme/` |

**Muc tieu:** Tim Vit* trung lap, token sai, wrapper thua **truoc** khi audit feature.

---

### 8.1 trade (STEP 004–013)

**Duong dan goc:** `flutter_app/lib/features/trade/presentation/`

| STEP | Thu muc | File dau → cuoi (alphabetical) |
| ---: | --- | --- |
| 004-P1 | pages/ | `active_copies_page.dart` → `complaint_submission_page.dart` |
| 005-P2 | pages/ | `complaint_tracking_page.dart` → `market_data_analytics_page_part_04.dart` |
| 006-P3 | pages/ | `ombudsman_referral_page.dart` → `transaction_reporting_page.dart` |
| 007-W1 | widgets/ | `advanced_chart_area_actions.dart` → `bot_performance_charts_strategy.dart` |
| 008-W2 | widgets/ | `bot_performance_metrics_summary.dart` → `copy_audit_log_controls.dart` |
| 009-W3 | widgets/ | `copy_audit_log_events.dart` → `execution_quality_common.dart` |
| 010-W4 | widgets/ | `execution_quality_overview.dart` → `performance_attribution_summary_tabs.dart` |
| 011-W5 | widgets/ | `performance_attribution_tabs.dart` → `trade_body_review_widgets.dart` |
| 012-W6 | widgets/ | `trade_formatters.dart` → `vit_trade_terminal_header.dart` |
| 013 | MERGE | Xem Section 9 |

**Do-not-cut module:** preview/confirm order, copy trading safety, bot emergency stop, compliance disclosures.

---

### 8.2 wallet (STEP 014–017)

| STEP | Scope |
| ---: | --- |
| 014 | pages/ (toan bo 22 file) |
| 015 | widgets/ asset_detail → wallet_manager_common |
| 016 | widgets/ wallet_manager_distribution → withdraw_preview_sheet |
| 017 | MERGE |

**Do-not-cut:** withdraw preview/confirm, address mask, limit warnings.

---

### 8.3 p2p (STEP 018–024)

| STEP | Scope |
| ---: | --- |
| 018–020 | pages/ 3 batch (xem bang STEP) |
| 021–023 | widgets/ 3 batch |
| 024 | MERGE |

**Do-not-cut:** dispute flow, payment method verification, fund lock confirm.

---

### 8.4 earn (STEP 025–032)

| STEP | Scope |
| ---: | --- |
| 025–027 | pages/ 3 batch |
| 028–031 | widgets/ 4 batch |
| 032 | MERGE |

---

### 8.5 launchpad, arena, markets, predictions, dca (STEP 033–051)

Xem bang STEP Section 4. Moi module lon deu co MERGE rieng.

---

### 8.6 Module nho (STEP 052–065) — 1 chat / module

Moi STEP quet **toan bo** `flutter_app/lib/features/<module>/presentation/`.

Khong can sub-step vi < 45 file (tru profile = 40, van 1 STEP).

---

### 8.7 Data/domain (STEP 066–068)

**Tag bo sung:** `yagni` (interface 1 impl), `shrink` (fixture `_part_XX`), `delete` (entity/method khong caller).

**Khong de xuat xoa:** mock/fixture dang duoc test hoac router dung.

---

### 8.8 Debt + Master (STEP 069–071)

| STEP | Viec |
| ---: | --- |
| 069 | Grep `// ponytail:` va `# ponytail:` — tag `no-trigger` neu thieu upgrade path |
| 070 | Merge 23 module ledgers + debt → master summary |
| 071 | Kiem tra MISSING; xac nhan 23/23 module co merged ledger |

---

## 9. Buoc MERGE (module lon)

AI chi lam **merge + rank**, khong quet lai toan bo code.

**Input:** Tat ca partial `...-<module>-p1...md` … `...-wN...md`

**Output:** 1 file `ponytail-audit-<module>-YYYY-MM-DD.md`

**Quy tac gop:**
1. Bo finding trung (cung file + cung line)
2. Giu finding impact cao nhat
3. Top findings: toi da 30 dong / module
4. Summary tong hop tu partials

**Sau MERGE:** Luon dung **khoi HANDOFF Section 1.2** — khong dung rieng dong `Completion MERGE: PONYTAIL AUDIT DONE` lam ket thuc message.

**Audit tag (trong khoi 1.2):** `PONYTAIL AUDIT DONE: AUDIT-XX — <module>`

---

## 10. Giai doan FIX (tach rieng, sau audit)

> **Chi bat dau khi STEP 070 (master) xong.** Fix = chat moi, khong dung STEP audit.

### FIX-001, FIX-002, … (rieng biet voi STEP audit)

```text
Doc docs/01_AI_RULES/AI_PROMPT_SHELL.md
Doc .codex/skills/vittrade-minimal-review/SKILL.md
Doc flutter_app/run-artifacts/ponytail-audit-master-summary-*.md

FIX BATCH: <module> batch <n>
Items: #1-#8 tu merged ledger
Toi da 8 file.

Sau fix:
- vittrade-minimal-review
- flutter analyze
- flutter test test/features/<module>/ --reporter=compact

Completion: PONYTAIL FIX BATCH DONE — <module> batch <n>
DUNG — cho user xac nhan batch tiep theo.
```

**Quy tac fix:** Giong audit — **1 batch / chat**, dung sau completion line.

---

## 11. Scan patterns + khong flag

### Scan (bat buoc moi file)

1. **reuse-vit** — VitCard, VitHeader, VitTabBar, VitSegmentedChoice, VitPresetChipRow, VitPageLayout
2. **yagni** — `_Foo` / helper 1 caller
3. **delete** — unused_element, wrapper delegate-only
4. **shrink** — section label, formatter, row builder trung
5. **token-drift** — `BorderRadius.circular(` ngoai `app_radii.dart`; hex ngoai `AppColors`

### Khong flag

- Preview/confirm tai chinh, escrow, bao mat, P2P payment
- Masked PII
- Loading / empty / error / offline / submitting / success (plan yeu cau)
- Migration bat buoc local → Vit*
- Test guardrail `flutter_app/test/quality/`
- Arena points-only; Prediction Markets boundaries

---

## 12. Handoff khi context day

Neu 1 sub-step qua lon (hiem):

```text
RESUME FROM: ponytail-audit — STEP-NNN — <scope-sub> — file <ten.dart>
```

Sau handoff: chat moi chi lam **phan con lai cua cung STEP**, khong nhay STEP.

---

## 13. Bang prompt STEP tiep theo (lookup)

**Cong thuc prompt (moi STEP audit):**

```text
Chạy STEP-<NNN> theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md
```

AI **phai** paste **nguyen van** dong prompt STEP tiep theo vao khoi HANDOFF Section 1.2 — khong viet "xem Section 8".

| Xong STEP | STEP tiep theo | Mo ta ngan | Prompt copy (chat moi) |
| ---: | ---: | --- | --- |
| 001 | 002 | shared/layout | `Chạy STEP-002 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 002 | 003 | app/theme | `Chạy STEP-003 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 003 | 004 | trade pages P1 | `Chạy STEP-004 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 004 | 005 | trade pages P2 | `Chạy STEP-005 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 005 | 006 | trade pages P3 | `Chạy STEP-006 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 006 | 007 | trade widgets W1 | `Chạy STEP-007 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 007 | 008 | trade widgets W2 | `Chạy STEP-008 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 008 | 009 | trade widgets W3 | `Chạy STEP-009 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 009 | 010 | trade widgets W4 | `Chạy STEP-010 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 010 | 011 | trade widgets W5 | `Chạy STEP-011 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 011 | 012 | trade widgets W6 | `Chạy STEP-012 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 012 | 013 | **MERGE trade** | `Chạy STEP-013 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| **013** | **014** | **wallet pages P1** | **`Chạy STEP-014 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md`** |
| 014 | 015 | wallet widgets W1 | `Chạy STEP-015 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 015 | 016 | wallet widgets W2 | `Chạy STEP-016 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 016 | 017 | MERGE wallet | `Chạy STEP-017 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 017 | 018 | p2p pages P1 | `Chạy STEP-018 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 018 | 019 | p2p pages P2 | `Chạy STEP-019 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 019 | 020 | p2p pages P3 | `Chạy STEP-020 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 020 | 021 | p2p widgets W1 | `Chạy STEP-021 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 021 | 022 | p2p widgets W2 | `Chạy STEP-022 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 022 | 023 | p2p widgets W3 | `Chạy STEP-023 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 023 | 024 | MERGE p2p | `Chạy STEP-024 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 024 | 025 | earn pages P1 | `Chạy STEP-025 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 025 | 026 | earn pages P2 | `Chạy STEP-026 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 026 | 027 | earn pages P3 | `Chạy STEP-027 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 027 | 028 | earn widgets W1 | `Chạy STEP-028 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 028 | 029 | earn widgets W2 | `Chạy STEP-029 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 029 | 030 | earn widgets W3 | `Chạy STEP-030 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 030 | 031 | earn widgets W4 | `Chạy STEP-031 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 031 | 032 | MERGE earn | `Chạy STEP-032 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 032 | 033 | launchpad P1 | `Chạy STEP-033 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 033 | 034 | launchpad W1 | `Chạy STEP-034 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 034 | 035 | launchpad W2 | `Chạy STEP-035 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 035 | 036 | MERGE launchpad | `Chạy STEP-036 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 036 | 037 | arena pages P1 | `Chạy STEP-037 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 037 | 038 | arena pages P2 | `Chạy STEP-038 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 038 | 039 | arena widgets W1 | `Chạy STEP-039 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 039 | 040 | MERGE arena | `Chạy STEP-040 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 040 | 041 | markets pages P1 | `Chạy STEP-041 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 041 | 042 | markets widgets W1 | `Chạy STEP-042 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 042 | 043 | markets widgets W2 | `Chạy STEP-043 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 043 | 044 | MERGE markets | `Chạy STEP-044 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 044 | 045 | predictions pages P1 | `Chạy STEP-045 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 045 | 046 | predictions widgets W1 | `Chạy STEP-046 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 046 | 047 | predictions widgets W2 | `Chạy STEP-047 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 047 | 048 | MERGE predictions | `Chạy STEP-048 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 048 | 049 | dca pages P1 | `Chạy STEP-049 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 049 | 050 | dca widgets W1 | `Chạy STEP-050 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 050 | 051 | MERGE dca | `Chạy STEP-051 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 051 | 052 | auth | `Chạy STEP-052 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 052 | 053 | profile | `Chạy STEP-053 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 053 | 054 | onboarding | `Chạy STEP-054 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 054 | 055 | notifications | `Chạy STEP-055 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 055 | 056 | home | `Chạy STEP-056 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 056 | 057 | discovery | `Chạy STEP-057 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 057 | 058 | news | `Chạy STEP-058 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 058 | 059 | referral | `Chạy STEP-059 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 059 | 060 | rewards | `Chạy STEP-060 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 060 | 061 | support | `Chạy STEP-061 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 061 | 062 | admin | `Chạy STEP-062 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 062 | 063 | cross_module | `Chạy STEP-063 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 063 | 064 | enterprise_states | `Chạy STEP-064 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 064 | 065 | dev | `Chạy STEP-065 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 065 | 066 | data/domain DD-A | `Chạy STEP-066 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 066 | 067 | data/domain DD-B | `Chạy STEP-067 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 067 | 068 | MERGE data/domain | `Chạy STEP-068 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 068 | 069 | ponytail debt | `Chạy STEP-069 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 069 | 070 | master summary | `Chạy STEP-070 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 070 | 071 | sync 23/23 | `Chạy STEP-071 theo docs/02_FLUTTER_MIGRATION/checklists/ke-hoach-ponytail-audit-toan-module.md` |
| 071 | — | **Audit xong → FIX** | Xem Section 1.2 (STEP-071) va Section 10 |

---

## Phu luc A — Checklist 23 feature modules

Danh ✅ khi co **merged ledger** (khong tinh partial):

- [ ] trade (STEP 013)
- [ ] wallet (017)
- [ ] p2p (024)
- [ ] earn (032)
- [ ] launchpad (036)
- [ ] arena (040)
- [ ] markets (044)
- [ ] predictions (048)
- [ ] dca (051)
- [ ] auth (052)
- [ ] profile (053)
- [ ] onboarding (054)
- [ ] notifications (055)
- [ ] home (056)
- [ ] discovery (057)
- [ ] news (058)
- [ ] referral (059)
- [ ] rewards (060)
- [ ] support (061)
- [ ] admin (062)
- [ ] cross_module (063)
- [ ] enterprise_states (064)
- [ ] dev (065)

**Data/domain:** STEP 068 | **Debt:** 069 | **Master:** 070 | **Sync:** 071

---

## Phu luc B — Timeline goi y (1 STEP / ngay)

| Tuan | STEP | Ghi chu |
| --- | --- | --- |
| 1 | 001–007 | Nen + trade P1–P3 + W1 |
| 2 | 008–013 | trade W2–W6 + MERGE trade |
| 3 | 014–024 | wallet + p2p |
| 4 | 025–032 | earn |
| 5 | 033–044 | launchpad + arena + markets |
| 6 | 045–055 | predictions + dca + tai khoan |
| 7 | 056–065 | kham pha + van hanh + dev |
| 8 | 066–071 | data + debt + master + sync |
| 9+ | FIX batches | Theo master summary |

*71 STEP ≈ 71 chat audit (co the 1 STEP/ngay ≈ 10 tuan).*

---

## Phu luc C — Tracker tong (cap nhat thu cong hoac qua progress file)

| ID | Module | MERGE STEP | Merged ledger | Status |
| --- | --- | ---: | --- | --- |
| AUDIT-00A | shared/widgets | 001 | | ⬜ |
| AUDIT-00B | shared/layout | 002 | | ⬜ |
| AUDIT-00C | app/theme | 003 | | ⬜ |
| AUDIT-01 | trade | 013 | | ⬜ |
| AUDIT-02 | wallet | 017 | | ⬜ |
| AUDIT-03 | p2p | 024 | | ⬜ |
| AUDIT-04 | earn | 032 | | ⬜ |
| AUDIT-05 | launchpad | 036 | | ⬜ |
| AUDIT-06 | arena | 040 | | ⬜ |
| AUDIT-07 | markets | 044 | | ⬜ |
| AUDIT-08 | predictions | 048 | | ⬜ |
| AUDIT-09 | dca | 051 | | ⬜ |
| AUDIT-10..23 | (module nho) | 052–065 | | ⬜ |
| AUDIT-24 | data/domain | 068 | | ⬜ |
| AUDIT-25 | debt | 069 | | ⬜ |
| AUDIT-26 | master | 070 | | ⬜ |
| SYNC | dong bo | 071 | | ⬜ |
