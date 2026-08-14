# A+ Roadmap — Execution Playbook (file thực thi cho AI)

> **Bộ ba file của roadmap này:**
> 1. [A-Plus-Task-Manifest.csv](A-Plus-Task-Manifest.csv) — nguồn sự thật máy đọc: 69 task, mỗi dòng có `depends_on`, `verify`, `status`. **Cập nhật `status` ở đây, không ở chỗ khác.**
> 2. [A-Plus-DECISIONS.md](A-Plus-DECISIONS.md) — 5 quyết định chỉ người chốt; task bị gate không được chạy khi quyết định còn `pending`.
> 3. File này — thứ tự batch + prompt block copy-paste cho từng phiên AI.
>
> **Bối cảnh "why" đầy đủ** nằm ở [VitTrade-Enterprise-Grade-Assessment-A-Plus-Roadmap.md](../VitTrade-Enterprise-Grade-Assessment-A-Plus-Roadmap.md) — mỗi task có cột `md_anchor` (vd `§3 › 3.5`) trỏ đúng section. **Không nạp cả file báo cáo vào một phiên AI** — chỉ mở đúng section của task đang làm.

---

## §0. Luật vận hành (áp cho MỌI batch)

Kế thừa toàn bộ [AI_PROMPT_SHELL.md](../../01_AI_RULES/AI_PROMPT_SHELL.md) và [Two-Phase-Codex-Workflow.md](../../01_AI_RULES/Two-Phase-Codex-Workflow.md). Bổ sung riêng cho roadmap này:

1. **State machine**: `status` trong manifest ∈ `pending | blocked | in_progress | done | dup`. Chỉ được chuyển `pending → in_progress → done`. `done` chỉ hợp lệ khi **toàn bộ lệnh trong cột `verify` pass** và evidence (lệnh + kết quả) được báo lại. Task `dup` không thực thi — làm tại task trong cột `same_as`.
2. **Kiểm tra tiền đề trước khi làm**: mọi `task_id` trong `depends_on` phải `done`; `decision_gate` (nếu có, không ghi "soft") phải `decided` trong DECISIONS.
3. **Verify pattern còn tồn tại trước khi sửa** (§16 của báo cáo): số dòng trong báo cáo là bằng chứng tại thời điểm audit 2026-07-15. Trước khi edit, grep xác nhận symbol/pattern còn đúng; nếu code đã đổi, ghi chú vào cột `notes`-của-batch trong báo cáo phiên và điều chỉnh, không làm mù theo line number.
4. **Nguyên tắc "guardrail trước, sửa sau"**: không bao giờ làm task "Viết lại/Tối ưu" trước khi task guardrail tương ứng trong `depends_on` xanh (A2→A1, S24→HN1/S23, 83→82, HN2→HN3/4/5).
5. **Batch 5–10 file, phiên Codex mới mỗi batch, minimal-diff self-check** trước khi verify (theo `.codex/skills/vittrade-minimal-review/SKILL.md`). Batch quá 10 file → half-batch.
6. **Bí khi thực thi**: half-batch ≤5 file → re-plan slice → dòng `RESUME FROM: <batch-id> - <task_id>` rồi dừng, không viết gì sau đó.
7. **Ranh giới sản phẩm bất di bất dịch**: Open Arena = points-only; Prediction Markets = positions/P&L; mọi flow tài chính phải preview→confirm. Không guardrail nào được nới để "cho tiện".
8. **Cấm hand-edit artifact CSV do tool sinh** (`docs/02_FLUTTER_MIGRATION/audits/*`): chạy lại `tool/*_audit.dart` ở WRITE mode. (Manifest của roadmap này KHÔNG do tool sinh — được phép sửa `status` bằng tay.)

### Gate verify chuẩn (chạy từ `flutter_app/`, = skill `/vt-verify`)

```bash
flutter pub get
dart format --output=none --set-exit-if-changed .
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
flutter analyze
flutter test --reporter=compact
```

- **Gate per-batch** = cột `verify` của các task trong batch (focused).
- **Gate cuối mỗi giai đoạn** = trọn khối trên (full). Guardrail MỚI nào được tạo ra trong giai đoạn phải được thêm vào `.github/workflows/flutter-ci.yml` trước khi đóng giai đoạn — "mặc định bị gác".

### Completion strings

- Batch xong: `A-PLUS BATCH PASS — <batch-id>`
- Giai đoạn xong: `A-PLUS GATE PASS — GD<n>` (chỉ in sau khi gate full xanh + mọi task giai đoạn `done`/`dup`)

---

## §1. GIAI ĐOẠN 0 — Quick wins (làm ngay, không chờ quyết định nào trừ B4)

Đóng P0 rẻ nhất + bật chốt chặn gần-miễn-phí. Task: TEST-HR1, CI-D1, ARCH-A6, ARCH-A5, DOC-D2, DOC-D1, DOC-D3, CI-D5.

### AP-GD0-B1 — TEST-HR1: đóng lỗ hổng guardrail high-risk (P0)

```text
Thực hiện task TEST-HR1 trong docs/02_FLUTTER_MIGRATION/a-plus-roadmap/A-Plus-Task-Manifest.csv.
Đọc thêm: §10 › HR-1 của VitTrade-Enterprise-Grade-Assessment-A-Plus-Roadmap.md + docs/01_AI_RULES/AI_PROMPT_SHELL.md.

Việc: 3/9 high-risk contract (trade_margin_futures, trade_bots, trade_copy) không được guardrail nào gác.
(1) Chọn 1 trang đại diện mỗi flow trong trade_terminal / trade_bots / trade_copy; wire
    snapshot.highRiskContractId vào VitHighRiskStatePanel theo đúng khuôn
    lib/features/earn/presentation/pages/staking/staking_earn_page.dart:103-109.
    contractId ad-hoc ('copy-performance-...') KHÔNG được tính — phải lấy từ snapshot.
(2) Thêm 3 trang đó vào const targets của test/quality/high_risk_state_primitives_guardrail_test.dart.

Ràng buộc: chỉ ~4-7 file; verify pattern còn tồn tại trước khi sửa; minimal-diff.
Gate: cd flutter_app && flutter test test/quality/high_risk_state_primitives_guardrail_test.dart
      (chứng minh fail TRƯỚC khi wire, pass SAU) + flutter analyze.
Xong: cập nhật status=done trong manifest + evidence.
Completion: A-PLUS BATCH PASS — AP-GD0-B1
```

### AP-GD0-B2 — CI-D1 + ARCH-A5: analyzer nghiêm + dọn ranh giới core

```text
Thực hiện task CI-D1 và ARCH-A5 trong A-Plus-Task-Manifest.csv (md_anchor: §7 › D1, §1 › A5).

CI-D1: analysis_options.yaml — thêm analyzer.language strict-casts/strict-inference/strict-raw-types
       (nâng lên error) + lint unawaited_futures, discarded_futures, cancel_subscriptions, close_sinks,
       prefer_final_locals, always_use_package_imports. Có vi phạm mới → fix code, KHÔNG hạ severity.
ARCH-A5: core/navigation/back_navigation.dart chạm flutter/widgets — chọn phương án (a) whitelist + doc
       comment, hoặc (b) tách phần thuần chuỗi ở lại core; ghi quyết định vào AGENTS.md; không đổi API.

Gate: cd flutter_app && flutter analyze (0 issue) && dart format --output=none --set-exit-if-changed .
      && flutter test test/quality/back_navigation_behavior_guardrail_test.dart
Completion: A-PLUS BATCH PASS — AP-GD0-B2
```

### AP-GD0-B3 — DOC-D2 + DOC-D1 + DOC-D3: khôi phục sự thật tài liệu

```text
Thực hiện task DOC-D2, DOC-D1, DOC-D3 trong A-Plus-Task-Manifest.csv (md_anchor: §9 › D2, D1, D3).

Thứ tự: D2 (git add doc required-reading — trình user duyệt commit) → D1 (INDEX 'Removed docs' khớp đĩa
+ guardrail trong ops_metadata_guardrails_test.dart) → D3 (chốt path canonical standards/·checklists/·
audits/·redesign/·prompt-redesign/; merge bản mới hơn về canonical rồi git rm bản top-level trùng).
LƯU Ý: trước mỗi git rm phải grep zero-reference toàn repo; bản top-level mới hơn thì merge trước.

Gate: cd flutter_app && flutter test test/quality/ops_metadata_guardrails_test.dart
      && dart run tool/card_tile_audit.dart --check && dart run tool/design_token_consistency_audit.dart --check;
      git ls-files --error-unmatch docs/01_AI_RULES/Two-Phase-Codex-Workflow.md
Completion: A-PLUS BATCH PASS — AP-GD0-B3
```

### AP-GD0-B4 — ARCH-A6 (chờ commit Phase 5) + CI-D5 (chờ DEC-codeowners) — human-gated

```text
ARCH-A6 chỉ chạy SAU khi user duyệt commit đợt tách Phase 5 (working tree 104 file):
bỏ 'trade' khỏi presentationOnlyModules, cập nhật comment, re-baseline 39/218/239.
Gate: flutter test test/quality/architecture_baseline_guardrails_test.dart.

CI-D5 là việc của NGƯỜI (GitHub settings): điền owner thật theo DEC-codeowners + bật branch protection.
AI chỉ hỗ trợ sửa nội dung file .github/CODEOWNERS khi đã có tên thật.
Completion: A-PLUS BATCH PASS — AP-GD0-B4
```

**Gate đóng GĐ0**: chạy trọn khối verify chuẩn §0 → `A-PLUS GATE PASS — GD0`.

---

## §2. GIAI ĐOẠN 1 — An toàn & enforcement (làm TRƯỚC khi tích hợp backend)

Task: ERR-31/32/33/34, STATE-S24, PERF-HN1(+S21), TEST-HR2, ARCH-A2, DEBT-83/81/84, SEC-S43/44, A11Y-1/2/3/4, DEBT-82.

| Batch | Task | File ước tính | Phụ thuộc |
|---|---|---|---|
| AP-GD1-B1 | ERR-31 + ERR-32 | 3–4 | — |
| AP-GD1-B2 | ERR-33 lô 1 (markets, launchpad, home, rewards, referral) | ~10 | — |
| AP-GD1-B3 | ERR-33 lô 2 (news, discovery, onboarding, support, cross_module×4) + ERR-34 | ~10 | B2 |
| AP-GD1-B4 | STATE-S24 (guardrail autoDispose + dual-source) | 2 | — |
| AP-GD1-B5 | PERF-HN1 (vá leak màn đặt lệnh; = STATE-S21) | 4–6 | B4 |
| AP-GD1-B6 | TEST-HR2 (earn data/domain tests — P0) | 2–4 | — |
| AP-GD1-B7 | ARCH-A2 (guardrail import-cycle, allowlist 2 cycle) | 1 | — |
| AP-GD1-B8 | DEBT-83 + DEBT-81 (guardrail `_format*` + vá drift tiền) | 3 | — |
| AP-GD1-B9 | DEBT-84 (VitFormat 12/12 test + money-copy tool/guardrail) | 3 | B8 |
| AP-GD1-B10a/b | SEC-S43 + SEC-S44 (maskAddress + ~13 site + test; tách đôi nếu >10 file) | 8+7 | — |
| AP-GD1-B11 | A11Y-2 + A11Y-3 (tap target + text-scaling; 4 file shared + 2 guardrail) | 6 | — |
| AP-GD1-B12a | A11Y-1 bước 1 (VitPageLayout: param `semanticIdentifier` + đổi finder test) | 2–3 | — |
| AP-GD1-B12b… | A11Y-1 bước 2 (382 call site, lô 8–10 file/module — cân nhắc script + review) | nhiều lô | B12a |
| AP-GD1-B13 | A11Y-4 (semantic label tiếng Việt + guardrail Latin-only) | 5–8 | B12a |
| AP-GD1-B14…18 | DEBT-82 theo module: earn → wallet → p2p → trade family → predictions | 5–10/lô | B8, B9 |

### Prompt mẫu cho mọi batch GĐ1 (thay `<...>`)

```text
Thực hiện batch <batch-id> = task <task_id list> trong
docs/02_FLUTTER_MIGRATION/a-plus-roadmap/A-Plus-Task-Manifest.csv.
Đọc: cột action + files của từng task; section <md_anchor> trong
VitTrade-Enterprise-Grade-Assessment-A-Plus-Roadmap.md; AI_PROMPT_SHELL.md (verify gate).

Ràng buộc:
- Kiểm tra depends_on đã done + decision_gate đã decided trước khi bắt đầu.
- Chỉ file trong cột files của các task này — không mở rộng scope.
- Verify pattern còn tồn tại (grep) trước khi sửa — báo cáo audit ngày 2026-07-15, code có thể đã trôi.
- Reuse Vit* primitives + theme token; minimal-diff self-check trước khi verify.
- Flow tài chính: giữ nguyên preview→confirm; không nới guardrail.

Gate: chạy đúng cột verify của TỪNG task trong batch, rồi flutter analyze.
Xong: cập nhật status=done cho từng task trong manifest + evidence (lệnh + kết quả).
Nếu bí: RESUME FROM: <batch-id> - <task_id>
Completion: A-PLUS BATCH PASS — <batch-id>
```

**Gate đóng GĐ1**: trọn khối verify chuẩn §0 + xác nhận các guardrail mới (repository_guard_coverage, state_management, module_dependency_cycle, money_copy, tap_target, text-scaling) đã vào `flutter-ci.yml` → `A-PLUS GATE PASS — GD1`.

---

## §3. GIAI ĐOẠN 2 — Chuẩn hoá & chuẩn bị backend (Viết lại nặng)

> **Pre-gate bắt buộc trước khi mở GĐ2:**
> 1. `A-PLUS GATE PASS — GD1` đã in.
> 2. DECISIONS: **DEC-i18n phải `decided`**; DEC-coverage/DEC-ios chốt trước các batch CI tương ứng; DEC-backend cho biết deadline của cả giai đoạn.
> 3. **Re-plan**: vì GĐ2 toàn task Effort L "Viết lại", chạy một phiên Plan (Two-Phase / agent `flutter-batch-planner`) lấy manifest làm input để chia lô chi tiết theo trạng thái code THỰC TẾ lúc đó, thay vì tin vào file list tĩnh dưới đây.

Thứ tự khuyến nghị (từ cột `order` của manifest):

| Batch | Task | Ghi chú |
|---|---|---|
| AP-GD2-B1 | ERR-35 | Chốt idiom async bằng ADR + trade order submit làm tham chiếu. **Mở khoá S22/S26/ERR-36/HR-3.** |
| AP-GD2-B2 | STATE-S26 | Chốt 1 pattern controller chính thức (ghi AGENTS.md) — làm TRƯỚC S22/S23, vì hai task đó là "lô thực thi" của nó |
| AP-GD2-B3 | STATE-S22 | Nhân idiom sang futures/leverage; nối panel high-risk vào status thật |
| AP-GD2-B4 | ERR-36 | Prediction submit thật (nút Buy/Sell hết no-op) |
| AP-GD2-B5…B9 | STATE-S23 | 5 lô module: markets → wallet → p2p → launchpad → earn/dca/arena |
| AP-GD2-B9b | STATE-S25 | Dọn `requireValue` — .md xếp cuối chiều 2, sau S2.3 |
| AP-GD2-B10 | ARCH-A1 | Gỡ 2 cycle (cycle 1 rồi cycle 2); ratchet ARCH-A2 về 0. Cần ARCH-A6 xong |
| AP-GD2-B11 | PERF-HN2 | Rebuild harness + scroll benchmark + guardrail static |
| AP-GD2-B12 | PERF-HN4 | Markets search → Notifier + select (dùng harness B11 chứng minh) |
| AP-GD2-B13 | CI-D2 | CI song song + cache (đổi .github/workflows — diff lớn, review kỹ) |
| AP-GD2-B14 | CI-D3 (=TEST-HR5) | Coverage + floor theo DEC-coverage + ratchet |
| AP-GD2-B15 | CI-D4 + SEC-S41 | Dependabot + SHA-pin + gitleaks + trung hoà secret fixtures |
| AP-GD2-B16 | CI-D6 | Flavors + release workflow (+ iOS nếu DEC-ios = có) |
| AP-GD2-B17 | I18N-1 | Theo nhánh DEC-i18n đã chốt |
| AP-GD2-B18 | I18N-2 + FMT-1 | Delegates/locale + VitFormat policy (FMT-1 cần DEBT-84 done) |
| AP-GD2-B19…B21 | TEST-HR3 | Pump lifecycle 9 contract (ưu tiên 6 họ chưa pump; 2-3 họ/lô) |
| AP-GD2-B22…B28 | TEST-HR4 | Repo/entity test cho 21 feature (2-3 feature/lô, ưu tiên high-risk) |

**Gate đóng GĐ2**: trọn khối verify chuẩn + coverage floor pass + `flutter build apk --flavor dev --debug` ra suffix `.dev` → `A-PLUS GATE PASS — GD2`. **Deadline: trước DEC-backend.**

---

## §4. GIAI ĐOẠN 3 — Hoàn thiện & bền vững (P2/P3)

Không có thứ tự cứng giữa các cụm — chọn theo dung lượng team; trong cụm thì theo `order`/`depends_on` của manifest.

| Cụm | Batch → Task |
|---|---|
| Testing | AP-GD3-T1: TEST-HR7 (có thể kéo lên trước ARCH-A1) · T2…T5: TEST-HR6 golden 4 feature · T6: TEST-HR8 |
| Hiệu năng | AP-GD3-P1: PERF-HN3 · P2: PERF-HN5 · P3: PERF-HN6 + PERF-HN7 |
| Kiến trúc | AP-GD3-A1…A3: ARCH-A3 (shard route constants, từng nhóm) · A4: ARCH-A4 |
| Nợ code | AP-GD3-D1: DEBT-85 · D2: DEBT-86 · D3: DEBT-87 + DEBT-88 · D4: DEBT-89 |
| Bảo mật | AP-GD3-S1: SEC-S42 · S2: SEC-S45 (ưu tiên p2p_routes) · S3: SEC-S46 |
| a11y/Docs | AP-GD3-X1: A11Y-5 · X2: DOC-D5 + DOC-D6 · X3: DOC-D4 (ADR backfill) · X4: DOC-D7 (dartdoc, làm cuối) |

Dùng prompt mẫu §2 cho mọi batch. **Gate đóng GĐ3** = trọn khối verify chuẩn + mọi task manifest `done`/`dup` → `A-PLUS GATE PASS — GD3` = **đạt A+ theo định nghĩa từng chiều trong báo cáo gốc**.

---

## §5. Theo dõi tiến độ

- Nguồn sự thật duy nhất: cột `status` trong `A-Plus-Task-Manifest.csv`.
- Đếm nhanh: `pending`/`blocked`/`in_progress`/`done` — 69 task tổng, trong đó 2 `dup` (STATE-S21 → PERF-HN1, TEST-HR5 → CI-D3), nên đích thực tế là **67 task done + 2 dup**.
- Khi báo cáo gốc và manifest mâu thuẫn (code đã trôi): sửa manifest, ghi chú lý do trong PR — báo cáo gốc là snapshot 2026-07-15, KHÔNG sửa ngược nó.
