# VitTrade UI Redesign — Shared Contract (mọi batch)

**Version:** 1.0 · Áp dụng **66 batch** · Mirror **SC-007 Home** (read-only).

Mọi hub prompt và batch Tier B **phải** tuân contract này. Chi tiết: [AGENTS.md](../../../AGENTS.md), [DESIGN.md](../../../DESIGN.md), [AI_PROMPT_SHELL.md](../../01_AI_RULES/AI_PROMPT_SHELL.md).

---

## North Star (global)

> Tin cậy trước · đơn giản trước · chuyên nghiệp luôn.

- Phone **360px+** · dark baseline · **≤3 section** above fold (hub).
- **Clutter score after ≤4/10** (hub); giảm ≥3 so với before nếu before >4.
- **Không sửa** `home_page.dart`.

---

## UI bắt buộc

`VitPageLayout`, `VitPageContent`, `VitCard`, `VitHeader`, `VitTabBar`, `VitSegmentedChoice`, `VitCtaButton`, `VitInput`, `VitPresetChipRow`, `VitStatusPill`.

**Cấm:** card-in-card · tab trong `VitCard` border · local duplicate `Vit*` · magic `BorderRadius` · hype/casino copy.

**States (khi flow cần):** loading · empty · error · offline · submitting · success.

---

## Product boundaries

| Module | Rule |
| --- | --- |
| Open Arena | **Points only** — không wallet/payout/stake/profit language |
| Predictions | Probability · positions · receipt — **không** casino/hype |
| Trade / Wallet / P2P / Earn | Preview + confirm trước hành động rủi ro; mask sensitive data |

---

## Workflow (mọi batch)

| STEP | Việc |
| --- | --- |
| 1 | Audit UI + clutter before |
| 2 | Spec wireframe + before/after + persona check |
| 3 | Code — max **5–10 files**/chat |
| 4 | `flutter analyze` + focused tests (shell gate) |
| 5 | `vittrade-minimal-review` · clutter after |

**Sau batch pass:** `status=done` trong CSV → `py -3 flutter_app/tool/gen_redesign_plan.py`.

---

## Completion lines

| Tier | Format |
| --- | --- |
| Hub (generic) | `MODULE UI REDESIGN DONE — <module_id> — <batch_id>` |
| RD-T02 bots | `TRADING BOTS HUB UI REDESIGN DONE — SC-059 v2` |
| Module gate | `MODULE REDESIGN GATE PASS — <module_id>` |
| Final | `VITTRADE UI REDESIGN COMPLETE — 415 screens` |

---

## Thứ tự thực thi

Chỉ dùng [EXECUTION-PLAYBOOK.md](EXECUTION-PLAYBOOK.md) — **66 bước**, hub trước batch con trong mỗi module, `RD-M02` → `RD-M23`.

Không skip batch · không gom nhiều batch một chat.
