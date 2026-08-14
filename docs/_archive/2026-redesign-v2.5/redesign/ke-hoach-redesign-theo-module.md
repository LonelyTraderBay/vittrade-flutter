# Kế hoạch Redesign UI theo Module — VitTrade (token-lite)

**Version:** 2.5 | **Updated:** 2026-07-05

> **Entry point:** [prompt-redesign/EXECUTION-PLAYBOOK.md](prompt-redesign/EXECUTION-PLAYBOOK.md) — **66 bước** copy-paste.
> **Contract:** [REDESIGN-CONTRACT.md](prompt-redesign/REDESIGN-CONTRACT.md) · Hub → [README.md](prompt-redesign/README.md).
> **Tiến độ:** cột `status` trong CSV — regenerate **giữ** status.

| Artifact | Khi nào load |
| --- | --- |
| **File này** (§1–4) | Mỗi chat redesign — **1 lần** |
| [ke-hoach-redesign-batches.csv](ke-hoach-redesign-batches.csv) | **1 row** / batch |
| [prompt-redesign/EXECUTION-PLAYBOOK.md](prompt-redesign/EXECUTION-PLAYBOOK.md) | **66 bước** — chạy tuần tự |
| [prompt-redesign/REDESIGN-CONTRACT.md](prompt-redesign/REDESIGN-CONTRACT.md) | Chuẩn chung mọi batch |
| [prompt-redesign/README.md](prompt-redesign/README.md) | 11 hub Tier A |
| `special_prompt` (hub batch) | **Full** hub file (~150–220 dòng) |
| `module_prompt` (batch con) | Partial: North Star · Copy · Financial only |
| [prompt-redesign/_template-tier-b-batch.md](prompt-redesign/_template-tier-b-batch.md) | Batch con / module nhỏ |

**Không load:** checklist `.md` · batches CSV toàn bộ · §4.2 (đã bỏ — dùng CSV) · full `home_page.dart`.

---

## 1. Quy tắc token (Codex)

1. User chỉ định **`batch_id`** (vd. `RD-M02-B01`, `RD-T02`).
2. Load **§1–4** + **1 row** `ke-hoach-redesign-batches.csv`.
3. Lọc checklist CSV theo `sc_ids` (split `;`) — ~6–18 dòng/batch.
4. **Tier A hub** (`special_prompt` set): load **full** hub prompt.
5. **Tier B batch con** (`module_prompt` set, `special_prompt` empty): plan + [_template-tier-b-batch.md](prompt-redesign/_template-tier-b-batch.md) + parent sections only.
6. Mirror **SC-007 Home** — **không sửa** `home_page.dart`.
7. **Chat mới**/batch · max **5–10** file code.
8. **Tiến độ:** chỉ đổi `status` trong batches CSV — không sửa bảng §4 tay.
9. Verify STEP 4: `AI_PROMPT_SHELL.md` + focused Flutter checks.
10. **STEP 0:** GitNexus `impact()` + `context()` trên symbol/page trước mọi edit.

### STEP 4 — Codex verification (analyze + focused tests)

Áp dụng **sau implementation**, khi chạy `flutter test`, `flutter analyze`, hoặc `dart run tool/*_audit.dart`:

| Khi | Làm |
| --- | --- |
| Kiểm tra focused | Chạy đúng test/audit của batch; đọc và sửa lỗi trực tiếp |
| Kiểm tra tổng | Chạy `flutter analyze` và `flutter test --reporter=compact` |
| Output dài | Giữ lệnh ở `--reporter=compact` và chia nhỏ phạm vi kiểm tra |

**Nguồn chuẩn:** các lệnh verify trong `AI_PROMPT_SHELL.md` và skill Codex áp dụng cho batch.

**Không bỏ qua:** `impact()` / `context()` trước edit và `detect_changes()` trước commit.

**Không thay GitNexus:** GitNexus vẫn là gate bắt buộc cho blast radius và thay đổi execution flow.

**Thứ tự redesign:** `RD-M02` → `RD-M23`. **`RD-M01` = reference only.**

**Lấy row batch (PowerShell):**

```powershell
Import-Csv docs/02_FLUTTER_MIGRATION/redesign/ke-hoach-redesign-batches.csv |
  Where-Object batch_id -eq 'RD-M02-B01'
```

---

## 2. Home reference — RD-M01 (skip redesign)

| sc | route | page | doc |
| --- | --- | --- | --- |
| `sc007Home` | `/home` | `lib/features/home/presentation/pages/home_page.dart` | [Home standard](../04_SCREEN_REFERENCES/home/HomePage-Flutter-Native-Standard.md) |

Mirror: hero → CTA → sections; `AppSpacing`/`AppRadii`/`AppTextStyles`; empty + CTA.

---

## 3. Charter (tóm tắt — chi tiết ở AGENTS/DESIGN/shell)

**North Star:** Tin cậy trước · đơn giản trước · chuyên nghiệp luôn.

**Vit* bắt buộc:** `VitPageLayout`, `VitPageContent`, `VitCard`, `VitHeader`, `VitTabBar`, `VitSegmentedChoice`, `VitCtaButton`, `VitInput`, `VitPresetChipRow`, `VitStatusPill`.

**States (khi flow cần):** loading · empty · error · offline · submitting · success.

**Financial:** preview + confirm trước withdraw · escrow · P2P payment · security changes.

**Cấm:** card-in-card · tab trong `VitCard` border · local duplicate Vit* · magic radius · hype/casino · sửa Home.

**Product:** Arena = points only · Predictions ≠ casino · financial = preview/confirm · giữ `sc*` test keys.

**Gate batch:** clutter after ≤4/10 · analyze clean · focused tests pass · ≤3 section above fold (hub).

**STEP 0→5:** explore → audit → spec → code → verify → self-check (`vittrade-minimal-review`).

---

## 4. Module index (tóm tắt — chi tiết batch → CSV)

Bảng dưới **tự sinh** từ `ke-hoach-redesign-batches.csv`. Tra batch: filter `batch_id` hoặc `module_id`.

| module_id | module | hub_sc | màn | accent | batches | progress |
| --- | --- | --- | ---: | --- | ---: | --- |
| `RD-M01` | **home** | `sc007Home` | 1 | Global foundation | 0 | 🔒 reference |
| `RD-M02` | **auth** | `sc001Login` | 6 | Trust, security, clarity | 1 | ✅ 1/1 |
| `RD-M03` | **onboarding** | `sc397Onboarding` | 1 | Guided first-run | 1 | ✅ 1/1 |
| `RD-M04` | **markets** | `sc008MarketList` | 22 | Scan, compare, data | 4 | ✅ 4/4 |
| `RD-M05` | **trade** | `sc048Trade` | 91 | Action, precision, risk | 11 | ✅ 11/11 |
| `RD-M06` | **wallet** | `sc135Wallet` | 21 | Assets, trust, security | 4 | ✅ 4/4 |
| `RD-M07` | **profile** | `sc156Profile` | 16 | Account, settings | 3 | ✅ 3/3 |
| `RD-M08` | **p2p** | `sc282P2PHome` | 77 | Escrow, compliance UX | 11 | ✅ 11/11 |
| `RD-M09` | **earn** | `sc327StakingEarn` | 70 | Yield + risk transparency | 7 | ✅ 7/7 |
| `RD-M10` | **dca** | `sc169Dca` | 13 | Disciplined investing | 3 | ✅ 3/3 |
| `RD-M11` | **predictions** | `sc027PredictionsHome` | 18 | Probability, not casino | 3 | ✅ 3/3 |
| `RD-M12` | **arena** | `sc184ArenaHome` | 26 | Points-only | 5 | ✅ 5/5 |
| `RD-M13` | **launchpad** | `sc295Launchpad` | 24 | IDO participation | 3 | ✅ 3/3 |
| `RD-M14` | **discovery** | `sc283UnifiedSearch` | 3 | Discovery | 1 | ✅ 1/1 |
| `RD-M15` | **news** | `sc047News` | 1 | Information | 1 | ✅ 1/1 |
| `RD-M16` | **notifications** | `sc291Notifications` | 1 | Actionable alerts | 1 | ✅ 1/1 |
| `RD-M17` | **referral** | `sc290ReferralHome` | 5 | No hype | 1 | ✅ 1/1 |
| `RD-M18` | **support** | `sc292HelpCenter` | 3 | Help & trust | 1 | ✅ 1/1 |
| `RD-M19` | **rewards** | `sc319RewardsHub` | 1 | Rewards hub | 1 | ✅ 1/1 |
| `RD-M20` | **cross_module** | `sc321UnifiedPortfolio` | 4 | Unified views | 1 | ✅ 1/1 |
| `RD-M21` | **enterprise_states** | `sc320EnterpriseStates` | 1 | Enterprise states | 1 | ✅ 1/1 |
| `RD-M22` | **admin** | `sc180AdminHome` | 5 | Ops dashboards | 1 | ✅ 1/1 |
| `RD-M23` | **dev** | `sc399DesignSystem` | 6 | Design system | 1 | ✅ 1/1 |

Inventory **416** · redesign **415** màn · **66** batches · done **66/66**.

---

## 5. Prompt mẫu

```text
Batch: <batch_id>  Module: <module_id>

Load (batch scope only):
- ke-hoach-redesign-theo-module.md §1-4
- ke-hoach-redesign-batches.csv row <batch_id>
- VitTrade-Screen-Redesign-Checklist.csv rows matching sc_ids
- <special_prompt full file if hub batch>
- <module_prompt partial sections if child batch>
- prompt-redesign/_template-tier-b-batch.md if Tier B
- docs/01_AI_RULES/AI_PROMPT_SHELL.md (verify gate)

GitNexus impact() trước mọi edit. Mirror SC-007 Home (read-only).
STEP 0→5. Max 5-10 files. New chat next batch.
Completion: MODULE UI REDESIGN DONE — <module_id> — <batch_id>
```

**Playbook:** [EXECUTION-PLAYBOOK.md](prompt-redesign/EXECUTION-PLAYBOOK.md) · SC-059: `RD-T02` → `TRADING BOTS HUB UI REDESIGN DONE — SC-059 v2`.
