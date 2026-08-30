# VitTrade UI Redesign — Execution Playbook

**Generated:** 2026-07-05 · **Batches:** 66 · **Screens:** 415

> **Cách dùng:** Mỗi bước = **1 chat mới**. Copy block **Prompt** bên dưới. Pass gate → `status=done` trong CSV → regenerate plan.

**Bộ đồng bộ:**

| File | Vai trò |
| --- | --- |
| [REDESIGN-CONTRACT.md](REDESIGN-CONTRACT.md) | Chuẩn chung — load 1 lần đầu session |
| [ke-hoach-redesign-theo-module.md](../redesign/ke-hoach-redesign-theo-module.md) | Routing §1–4 mỗi chat |
| [README.md](README.md) | 11 hub Tier A + SC-059 |
| Hub prompts trong folder này | Tier A full / parent Tier B |

---

## Quy trình tổng thể

1. Hub batch (**Tier A**) trước — thiết lập North Star module.
2. Batch con (**Tier B_child**) — inherit partial `module_prompt`.
3. Module nhỏ (**Tier B_simple**) — plan + template.
4. **Module gate** sau batch cuối của module (test cả module).
5. **Final gate** sau bước 66 — không cần soát từng màn lẻ.

### Module gate (sau batch cuối mỗi module)

```bash
cd flutter_app
flutter test test/features/<module>/ --reporter=compact
flutter analyze
```

Completion: `MODULE REDESIGN GATE PASS — <module_id>`

### Final gate (sau bước 66)

```bash
cd flutter_app
flutter analyze
flutter test --reporter=compact
dart run tool/design_token_consistency_audit.dart --check
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
```

Completion: `VITTRADE UI REDESIGN COMPLETE — 415 screens`

---

## Bảng thứ tự (master)

| Step | batch_id | module | tier | sc# | prompt | status |
| ---: | --- | --- | --- | ---: | --- | --- |
| 1 | `RD-M02-B01` | auth | A_hub | 6 | prompt-redesign/auth-hub.md | done |
| 2 | `RD-M03-B01` | onboarding | B_simple | 1 | — | done |
| 3 | `RD-K01` | markets | A_hub | 5 | prompt-redesign/markets-hub.md | done |
| 4 | `RD-K02` | markets | B_child | 6 | — | done |
| 5 | `RD-K03` | markets | B_child | 8 | — | done |
| 6 | `RD-K04` | markets | B_child | 3 | — | done |
| 7 | `RD-T01` | trade | A_hub | 9 | prompt-redesign/trade-core-hub.md | done |
| 8 | `RD-T02` | trade | A_hub | 1 | prompt-redesign/trading-bots-hub.md | done |
| 9 | `RD-T03` | trade | B_child | 14 | — | done |
| 10 | `RD-T04` | trade | B_child | 4 | — | done |
| 11 | `RD-T05` | trade | A_hub | 8 | prompt-redesign/copy-trading-hub.md | done |
| 12 | `RD-T06` | trade | B_child | 15 | — | done |
| 13 | `RD-T07` | trade | B_child | 5 | — | done |
| 14 | `RD-T08` | trade | B_child | 6 | — | done |
| 15 | `RD-T09` | trade | B_child | 12 | — | done |
| 16 | `RD-T10` | trade | B_child | 15 | — | done |
| 17 | `RD-T11` | trade | B_child | 2 | — | done |
| 18 | `RD-W01` | wallet | A_hub | 6 | prompt-redesign/wallet-hub.md | done |
| 19 | `RD-W02` | wallet | B_child | 3 | — | done |
| 20 | `RD-W03` | wallet | B_child | 5 | — | done |
| 21 | `RD-W04` | wallet | B_child | 7 | — | done |
| 22 | `RD-F01` | profile | B_simple | 8 | — | done |
| 23 | `RD-F02` | profile | B_simple | 6 | — | done |
| 24 | `RD-F03` | profile | B_simple | 2 | — | done |
| 25 | `RD-P01` | p2p | A_hub | 6 | prompt-redesign/p2p-hub.md | done |
| 26 | `RD-P02` | p2p | B_child | 8 | — | done |
| 27 | `RD-P03` | p2p | B_child | 9 | — | done |
| 28 | `RD-P04` | p2p | B_child | 6 | — | done |
| 29 | `RD-P05` | p2p | B_child | 9 | — | done |
| 30 | `RD-P06` | p2p | B_child | 9 | — | done |
| 31 | `RD-P07` | p2p | B_child | 8 | — | done |
| 32 | `RD-P08` | p2p | B_child | 6 | — | done |
| 33 | `RD-P09` | p2p | B_child | 7 | — | done |
| 34 | `RD-P10` | p2p | B_child | 5 | — | done |
| 35 | `RD-P11` | p2p | B_child | 4 | — | done |
| 36 | `RD-E01` | earn | A_hub | 6 | prompt-redesign/earn-staking-hub.md | done |
| 37 | `RD-E02` | earn | B_child | 7 | — | done |
| 38 | `RD-E03` | earn | B_child | 9 | — | done |
| 39 | `RD-E04` | earn | B_child | 10 | — | done |
| 40 | `RD-E05` | earn | B_child | 14 | — | done |
| 41 | `RD-E06` | earn | B_child | 6 | — | done |
| 42 | `RD-E07` | earn | B_child | 18 | — | done |
| 43 | `RD-C01` | dca | B_simple | 5 | — | done |
| 44 | `RD-C02` | dca | B_simple | 4 | — | done |
| 45 | `RD-C03` | dca | B_simple | 4 | — | done |
| 46 | `RD-R01` | predictions | A_hub | 5 | prompt-redesign/predictions-hub.md | done |
| 47 | `RD-R02` | predictions | B_child | 7 | — | done |
| 48 | `RD-R03` | predictions | B_child | 6 | — | done |
| 49 | `RD-A01` | arena | A_hub | 6 | prompt-redesign/arena-hub.md | done |
| 50 | `RD-A02` | arena | B_child | 7 | — | done |
| 51 | `RD-A03` | arena | B_child | 5 | — | done |
| 52 | `RD-A04` | arena | B_child | 5 | — | done |
| 53 | `RD-A05` | arena | B_child | 3 | — | done |
| 54 | `RD-L01` | launchpad | A_hub | 4 | prompt-redesign/launchpad-hub.md | done |
| 55 | `RD-L02` | launchpad | B_child | 7 | — | done |
| 56 | `RD-L03` | launchpad | B_child | 13 | — | done |
| 57 | `RD-M14-B01` | discovery | B_simple | 3 | — | done |
| 58 | `RD-M15-B01` | news | B_simple | 1 | — | done |
| 59 | `RD-M16-B01` | notifications | B_simple | 1 | — | done |
| 60 | `RD-M17-B01` | referral | B_simple | 5 | — | done |
| 61 | `RD-M18-B01` | support | B_simple | 3 | — | done |
| 62 | `RD-M19-B01` | rewards | B_simple | 1 | — | done |
| 63 | `RD-M20-B01` | cross_module | B_simple | 4 | — | done |
| 64 | `RD-M21-B01` | enterprise_states | B_simple | 1 | — | done |
| 65 | `RD-M22-B01` | admin | B_simple | 5 | — | done |
| 66 | `RD-M23-B01` | dev | B_simple | 6 | — | done |

---

## Prompt từng bước (copy-paste)

### Step 1/66 — `RD-M02-B01` (auth — all)

**Tier:** A_hub · **Module:** `RD-M02` · **Next:** `RD-M03-B01`

```text
EXECUTION 1/66 — batch RD-M02-B01 module RD-M02

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/auth-hub.md (FULL hub prompt)
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M02 — RD-M02-B01
```

Sau completion: chạy MODULE GATE test/features/auth/ → `MODULE REDESIGN GATE PASS — RD-M02`


### Step 2/66 — `RD-M03-B01` (onboarding — all)

**Tier:** B_simple · **Module:** `RD-M03` · **Next:** `RD-K01`

```text
EXECUTION 2/66 — batch RD-M03-B01 module RD-M03

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M03 — RD-M03-B01
```

Sau completion: chạy MODULE GATE test/features/onboarding/ → `MODULE REDESIGN GATE PASS — RD-M03`


### Step 3/66 — `RD-K01` (Hub & overview)

**Tier:** A_hub · **Module:** `RD-M04` · **Next:** `RD-K02`

```text
EXECUTION 3/66 — batch RD-K01 module RD-M04

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/markets-hub.md (FULL hub prompt)
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M04 — RD-K01
```


### Step 4/66 — `RD-K02` (Discovery tools)

**Tier:** B_child · **Module:** `RD-M04` · **Next:** `RD-K03`

```text
EXECUTION 4/66 — batch RD-K02 module RD-M04

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/markets-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M04 — RD-K02
```


### Step 5/66 — `RD-K03` (Depth & sentiment)

**Tier:** B_child · **Module:** `RD-M04` · **Next:** `RD-K04`

```text
EXECUTION 5/66 — batch RD-K03 module RD-M04

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/markets-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M04 — RD-K03
```


### Step 6/66 — `RD-K04` (Pair detail)

**Tier:** B_child · **Module:** `RD-M04` · **Next:** `RD-T01`

```text
EXECUTION 6/66 — batch RD-K04 module RD-M04

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/markets-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M04 — RD-K04
```

Sau completion: chạy MODULE GATE test/features/markets/ → `MODULE REDESIGN GATE PASS — RD-M04`


### Step 7/66 — `RD-T01` (Hub giao dịch cốt lõi)

**Tier:** A_hub · **Module:** `RD-M05` · **Next:** `RD-T02`

```text
EXECUTION 7/66 — batch RD-T01 module RD-M05

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/trade-core-hub.md (FULL hub prompt)
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M05 — RD-T01
```


### Step 8/66 — `RD-T02` (Hub Trading Bots SC-059)

**Tier:** A_hub · **Module:** `RD-M05` · **Next:** `RD-T03`

```text
EXECUTION 8/66 — batch RD-T02 module RD-M05

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/trading-bots-hub.md (FULL hub prompt)
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: TRADING BOTS HUB UI REDESIGN DONE — SC-059 v2
```


### Step 9/66 — `RD-T03` (Bot vận hành & analytics)

**Tier:** B_child · **Module:** `RD-M05` · **Next:** `RD-T04`

```text
EXECUTION 9/66 — batch RD-T03 module RD-M05

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/trading-bots-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M05 — RD-T03
```


### Step 10/66 — `RD-T04` (Bot guide & tax)

**Tier:** B_child · **Module:** `RD-M05` · **Next:** `RD-T05`

```text
EXECUTION 10/66 — batch RD-T04 module RD-M05

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/trading-bots-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M05 — RD-T04
```


### Step 11/66 — `RD-T05` (Copy trading hub)

**Tier:** A_hub · **Module:** `RD-M05` · **Next:** `RD-T06`

```text
EXECUTION 11/66 — batch RD-T05 module RD-M05

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/copy-trading-hub.md (FULL hub prompt)
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M05 — RD-T05
```


### Step 12/66 — `RD-T06` (Copy provider & performance)

**Tier:** B_child · **Module:** `RD-M05` · **Next:** `RD-T07`

```text
EXECUTION 12/66 — batch RD-T06 module RD-M05

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/copy-trading-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M05 — RD-T06
```


### Step 13/66 — `RD-T07` (Margin & trader)

**Tier:** B_child · **Module:** `RD-M05` · **Next:** `RD-T08`

```text
EXECUTION 13/66 — batch RD-T07 module RD-M05

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/trade-core-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M05 — RD-T07
```


### Step 14/66 — `RD-T08` (Tools & analytics)

**Tier:** B_child · **Module:** `RD-M05` · **Next:** `RD-T09`

```text
EXECUTION 14/66 — batch RD-T08 module RD-M05

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/trade-core-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M05 — RD-T08
```


### Step 15/66 — `RD-T09` (Compliance 1)

**Tier:** B_child · **Module:** `RD-M05` · **Next:** `RD-T10`

```text
EXECUTION 15/66 — batch RD-T09 module RD-M05

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/trade-core-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M05 — RD-T09
```


### Step 16/66 — `RD-T10` (Compliance 2 & complaints)

**Tier:** B_child · **Module:** `RD-M05` · **Next:** `RD-T11`

```text
EXECUTION 16/66 — batch RD-T10 module RD-M05

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/trade-core-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M05 — RD-T10
```


### Step 17/66 — `RD-T11` (Orders & receipts)

**Tier:** B_child · **Module:** `RD-M05` · **Next:** `RD-W01`

```text
EXECUTION 17/66 — batch RD-T11 module RD-M05

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/trade-core-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M05 — RD-T11
```

Sau completion: chạy MODULE GATE test/features/trade/ → `MODULE REDESIGN GATE PASS — RD-M05`


### Step 18/66 — `RD-W01` (Hub & assets)

**Tier:** A_hub · **Module:** `RD-M06` · **Next:** `RD-W02`

```text
EXECUTION 18/66 — batch RD-W01 module RD-M06

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/wallet-hub.md (FULL hub prompt)
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M06 — RD-W01
```


### Step 19/66 — `RD-W02` (Deposit)

**Tier:** B_child · **Module:** `RD-M06` · **Next:** `RD-W03`

```text
EXECUTION 19/66 — batch RD-W02 module RD-M06

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/wallet-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M06 — RD-W02
```


### Step 20/66 — `RD-W03` (Withdraw)

**Tier:** B_child · **Module:** `RD-M06` · **Next:** `RD-W04`

```text
EXECUTION 20/66 — batch RD-W03 module RD-M06

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/wallet-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M06 — RD-W03
```


### Step 21/66 — `RD-W04` (Transfer & buy)

**Tier:** B_child · **Module:** `RD-M06` · **Next:** `RD-F01`

```text
EXECUTION 21/66 — batch RD-W04 module RD-M06

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/wallet-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M06 — RD-W04
```

Sau completion: chạy MODULE GATE test/features/wallet/ → `MODULE REDESIGN GATE PASS — RD-M06`


### Step 22/66 — `RD-F01` (Hub & settings)

**Tier:** B_simple · **Module:** `RD-M07` · **Next:** `RD-F02`

```text
EXECUTION 22/66 — batch RD-F01 module RD-M07

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M07 — RD-F01
```


### Step 23/66 — `RD-F02` (Security & KYC)

**Tier:** B_simple · **Module:** `RD-M07` · **Next:** `RD-F03`

```text
EXECUTION 23/66 — batch RD-F02 module RD-M07

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M07 — RD-F02
```


### Step 24/66 — `RD-F03` (API keys)

**Tier:** B_simple · **Module:** `RD-M07` · **Next:** `RD-P01`

```text
EXECUTION 24/66 — batch RD-F03 module RD-M07

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M07 — RD-F03
```

Sau completion: chạy MODULE GATE test/features/profile/ → `MODULE REDESIGN GATE PASS — RD-M07`


### Step 25/66 — `RD-P01` (Hub & navigation)

**Tier:** A_hub · **Module:** `RD-M08` · **Next:** `RD-P02`

```text
EXECUTION 25/66 — batch RD-P01 module RD-M08

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/p2p-hub.md (FULL hub prompt)
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M08 — RD-P01
```


### Step 26/66 — `RD-P02` (Express & orders)

**Tier:** B_child · **Module:** `RD-M08` · **Next:** `RD-P03`

```text
EXECUTION 26/66 — batch RD-P02 module RD-M08

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/p2p-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M08 — RD-P02
```


### Step 27/66 — `RD-P03` (Ads & merchant)

**Tier:** B_child · **Module:** `RD-M08` · **Next:** `RD-P04`

```text
EXECUTION 27/66 — batch RD-P03 module RD-M08

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/p2p-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M08 — RD-P03
```


### Step 28/66 — `RD-P04` (Payment methods)

**Tier:** B_child · **Module:** `RD-M08` · **Next:** `RD-P05`

```text
EXECUTION 28/66 — batch RD-P04 module RD-M08

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/p2p-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M08 — RD-P04
```


### Step 29/66 — `RD-P05` (Insurance & escrow)

**Tier:** B_child · **Module:** `RD-M08` · **Next:** `RD-P06`

```text
EXECUTION 29/66 — batch RD-P05 module RD-M08

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/p2p-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M08 — RD-P05
```


### Step 30/66 — `RD-P06` (KYC)

**Tier:** B_child · **Module:** `RD-M08` · **Next:** `RD-P07`

```text
EXECUTION 30/66 — batch RD-P06 module RD-M08

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/p2p-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M08 — RD-P06
```


### Step 31/66 — `RD-P07` (Security)

**Tier:** B_child · **Module:** `RD-M08` · **Next:** `RD-P08`

```text
EXECUTION 31/66 — batch RD-P07 module RD-M08

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/p2p-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M08 — RD-P07
```


### Step 32/66 — `RD-P08` (Wallet & limits)

**Tier:** B_child · **Module:** `RD-M08` · **Next:** `RD-P09`

```text
EXECUTION 32/66 — batch RD-P08 module RD-M08

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/p2p-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M08 — RD-P08
```


### Step 33/66 — `RD-P09` (Compliance & tax)

**Tier:** B_child · **Module:** `RD-M08` · **Next:** `RD-P10`

```text
EXECUTION 33/66 — batch RD-P09 module RD-M08

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/p2p-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M08 — RD-P09
```


### Step 34/66 — `RD-P10` (Disputes)

**Tier:** B_child · **Module:** `RD-M08` · **Next:** `RD-P11`

```text
EXECUTION 34/66 — batch RD-P10 module RD-M08

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/p2p-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M08 — RD-P10
```


### Step 35/66 — `RD-P11` (Social & settings)

**Tier:** B_child · **Module:** `RD-M08` · **Next:** `RD-E01`

```text
EXECUTION 35/66 — batch RD-P11 module RD-M08

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/p2p-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M08 — RD-P11
```

Sau completion: chạy MODULE GATE test/features/p2p/ → `MODULE REDESIGN GATE PASS — RD-M08`


### Step 36/66 — `RD-E01` (Staking entry)

**Tier:** A_hub · **Module:** `RD-M09` · **Next:** `RD-E02`

```text
EXECUTION 36/66 — batch RD-E01 module RD-M09

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/earn-staking-hub.md (FULL hub prompt)
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M09 — RD-E01
```


### Step 37/66 — `RD-E02` (Staking ops)

**Tier:** B_child · **Module:** `RD-M09` · **Next:** `RD-E03`

```text
EXECUTION 37/66 — batch RD-E02 module RD-M09

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/earn-staking-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M09 — RD-E02
```


### Step 38/66 — `RD-E03` (Staking legal/risk)

**Tier:** B_child · **Module:** `RD-M09` · **Next:** `RD-E04`

```text
EXECUTION 38/66 — batch RD-E03 module RD-M09

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/earn-staking-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M09 — RD-E03
```


### Step 39/66 — `RD-E04` (Staking compliance)

**Tier:** B_child · **Module:** `RD-M09` · **Next:** `RD-E05`

```text
EXECUTION 39/66 — batch RD-E04 module RD-M09

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/earn-staking-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M09 — RD-E04
```


### Step 40/66 — `RD-E05` (Staking community)

**Tier:** B_child · **Module:** `RD-M09` · **Next:** `RD-E06`

```text
EXECUTION 40/66 — batch RD-E05 module RD-M09

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/earn-staking-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M09 — RD-E05
```


### Step 41/66 — `RD-E06` (Savings entry)

**Tier:** B_child · **Module:** `RD-M09` · **Next:** `RD-E07`

```text
EXECUTION 41/66 — batch RD-E06 module RD-M09

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/earn-staking-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M09 — RD-E06
```


### Step 42/66 — `RD-E07` (Savings tools)

**Tier:** B_child · **Module:** `RD-M09` · **Next:** `RD-C01`

```text
EXECUTION 42/66 — batch RD-E07 module RD-M09

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/earn-staking-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M09 — RD-E07
```

Sau completion: chạy MODULE GATE test/features/earn/ → `MODULE REDESIGN GATE PASS — RD-M09`


### Step 43/66 — `RD-C01` (Hub & schedule)

**Tier:** B_simple · **Module:** `RD-M10` · **Next:** `RD-C02`

```text
EXECUTION 43/66 — batch RD-C01 module RD-M10

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M10 — RD-C01
```


### Step 44/66 — `RD-C02` (Rebalance)

**Tier:** B_simple · **Module:** `RD-M10` · **Next:** `RD-C03`

```text
EXECUTION 44/66 — batch RD-C02 module RD-M10

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M10 — RD-C02
```


### Step 45/66 — `RD-C03` (Optimizer)

**Tier:** B_simple · **Module:** `RD-M10` · **Next:** `RD-R01`

```text
EXECUTION 45/66 — batch RD-C03 module RD-M10

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M10 — RD-C03
```

Sau completion: chạy MODULE GATE test/features/dca/ → `MODULE REDESIGN GATE PASS — RD-M10`


### Step 46/66 — `RD-R01` (Hub & discovery)

**Tier:** A_hub · **Module:** `RD-M11` · **Next:** `RD-R02`

```text
EXECUTION 46/66 — batch RD-R01 module RD-M11

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/predictions-hub.md (FULL hub prompt)
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M11 — RD-R01
```


### Step 47/66 — `RD-R02` (Portfolio & social)

**Tier:** B_child · **Module:** `RD-M11` · **Next:** `RD-R03`

```text
EXECUTION 47/66 — batch RD-R02 module RD-M11

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/predictions-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M11 — RD-R02
```


### Step 48/66 — `RD-R03` (Tools)

**Tier:** B_child · **Module:** `RD-M11` · **Next:** `RD-A01`

```text
EXECUTION 48/66 — batch RD-R03 module RD-M11

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/predictions-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M11 — RD-R03
```

Sau completion: chạy MODULE GATE test/features/predictions/ → `MODULE REDESIGN GATE PASS — RD-M11`


### Step 49/66 — `RD-A01` (Hub & studio)

**Tier:** A_hub · **Module:** `RD-M12` · **Next:** `RD-A02`

```text
EXECUTION 49/66 — batch RD-A01 module RD-M12

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/arena-hub.md (FULL hub prompt)
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M12 — RD-A01
```


### Step 50/66 — `RD-A02` (Challenge flow)

**Tier:** B_child · **Module:** `RD-M12` · **Next:** `RD-A03`

```text
EXECUTION 50/66 — batch RD-A02 module RD-M12

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/arena-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M12 — RD-A02
```


### Step 51/66 — `RD-A03` (Points & ledger)

**Tier:** B_child · **Module:** `RD-M12` · **Next:** `RD-A04`

```text
EXECUTION 51/66 — batch RD-A03 module RD-M12

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/arena-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M12 — RD-A03
```


### Step 52/66 — `RD-A04` (Safety & trust)

**Tier:** B_child · **Module:** `RD-M12` · **Next:** `RD-A05`

```text
EXECUTION 52/66 — batch RD-A04 module RD-M12

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/arena-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M12 — RD-A04
```


### Step 53/66 — `RD-A05` (Production bridges)

**Tier:** B_child · **Module:** `RD-M12` · **Next:** `RD-L01`

```text
EXECUTION 53/66 — batch RD-A05 module RD-M12

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/arena-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M12 — RD-A05
```

Sau completion: chạy MODULE GATE test/features/arena/ → `MODULE REDESIGN GATE PASS — RD-M12`


### Step 54/66 — `RD-L01` (Hub & portfolio)

**Tier:** A_hub · **Module:** `RD-M13` · **Next:** `RD-L02`

```text
EXECUTION 54/66 — batch RD-L01 module RD-M13

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/launchpad-hub.md (FULL hub prompt)
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M13 — RD-L01
```


### Step 55/66 — `RD-L02` (Participation)

**Tier:** B_child · **Module:** `RD-M13` · **Next:** `RD-L03`

```text
EXECUTION 55/66 — batch RD-L02 module RD-M13

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/launchpad-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M13 — RD-L02
```


### Step 56/66 — `RD-L03` (Advanced tools)

**Tier:** B_child · **Module:** `RD-M13` · **Next:** `RD-M14-B01`

```text
EXECUTION 56/66 — batch RD-L03 module RD-M13

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/launchpad-hub.md (North Star · Copy · Financial ONLY)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M13 — RD-L03
```

Sau completion: chạy MODULE GATE test/features/launchpad/ → `MODULE REDESIGN GATE PASS — RD-M13`


### Step 57/66 — `RD-M14-B01` (discovery — all)

**Tier:** B_simple · **Module:** `RD-M14` · **Next:** `RD-M15-B01`

```text
EXECUTION 57/66 — batch RD-M14-B01 module RD-M14

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M14 — RD-M14-B01
```

Sau completion: chạy MODULE GATE test/features/discovery/ → `MODULE REDESIGN GATE PASS — RD-M14`


### Step 58/66 — `RD-M15-B01` (news — all)

**Tier:** B_simple · **Module:** `RD-M15` · **Next:** `RD-M16-B01`

```text
EXECUTION 58/66 — batch RD-M15-B01 module RD-M15

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M15 — RD-M15-B01
```

Sau completion: chạy MODULE GATE test/features/news/ → `MODULE REDESIGN GATE PASS — RD-M15`


### Step 59/66 — `RD-M16-B01` (notifications — all)

**Tier:** B_simple · **Module:** `RD-M16` · **Next:** `RD-M17-B01`

```text
EXECUTION 59/66 — batch RD-M16-B01 module RD-M16

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M16 — RD-M16-B01
```

Sau completion: chạy MODULE GATE test/features/notifications/ → `MODULE REDESIGN GATE PASS — RD-M16`


### Step 60/66 — `RD-M17-B01` (referral — all)

**Tier:** B_simple · **Module:** `RD-M17` · **Next:** `RD-M18-B01`

```text
EXECUTION 60/66 — batch RD-M17-B01 module RD-M17

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M17 — RD-M17-B01
```

Sau completion: chạy MODULE GATE test/features/referral/ → `MODULE REDESIGN GATE PASS — RD-M17`


### Step 61/66 — `RD-M18-B01` (support — all)

**Tier:** B_simple · **Module:** `RD-M18` · **Next:** `RD-M19-B01`

```text
EXECUTION 61/66 — batch RD-M18-B01 module RD-M18

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M18 — RD-M18-B01
```

Sau completion: chạy MODULE GATE test/features/support/ → `MODULE REDESIGN GATE PASS — RD-M18`


### Step 62/66 — `RD-M19-B01` (rewards — all)

**Tier:** B_simple · **Module:** `RD-M19` · **Next:** `RD-M20-B01`

```text
EXECUTION 62/66 — batch RD-M19-B01 module RD-M19

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M19 — RD-M19-B01
```

Sau completion: chạy MODULE GATE test/features/rewards/ → `MODULE REDESIGN GATE PASS — RD-M19`


### Step 63/66 — `RD-M20-B01` (cross_module — all)

**Tier:** B_simple · **Module:** `RD-M20` · **Next:** `RD-M21-B01`

```text
EXECUTION 63/66 — batch RD-M20-B01 module RD-M20

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M20 — RD-M20-B01
```

Sau completion: chạy MODULE GATE test/features/cross_module/ → `MODULE REDESIGN GATE PASS — RD-M20`


### Step 64/66 — `RD-M21-B01` (enterprise_states — all)

**Tier:** B_simple · **Module:** `RD-M21` · **Next:** `RD-M22-B01`

```text
EXECUTION 64/66 — batch RD-M21-B01 module RD-M21

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M21 — RD-M21-B01
```

Sau completion: chạy MODULE GATE test/features/enterprise_states/ → `MODULE REDESIGN GATE PASS — RD-M21`


### Step 65/66 — `RD-M22-B01` (admin — all)

**Tier:** B_simple · **Module:** `RD-M22` · **Next:** `RD-M23-B01`

```text
EXECUTION 65/66 — batch RD-M22-B01 module RD-M22

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M22 — RD-M22-B01
```

Sau completion: chạy MODULE GATE test/features/admin/ → `MODULE REDESIGN GATE PASS — RD-M22`


### Step 66/66 — `RD-M23-B01` (dev — all)

**Tier:** B_simple · **Module:** `RD-M23` · **Next:** `FINAL GATE`

```text
EXECUTION 66/66 — batch RD-M23-B01 module RD-M23

- docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-theo-module.md §1-4
- docs/02_FLUTTER_MIGRATION/prompt-redesign/REDESIGN-CONTRACT.md
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows (sc_ids only)
- docs/02_FLUTTER_MIGRATION/prompt-redesign/_template-tier-b-batch.md
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — RD-M23 — RD-M23-B01
```

