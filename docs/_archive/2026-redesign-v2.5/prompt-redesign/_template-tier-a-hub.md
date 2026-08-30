# Execution Prompt — Redesign UI {ModuleName} Hub ({HubSc})

**Version:** 1.0  
**Batch:** `{BatchId}`  
**Accent:** {Accent}  
**Shell contract:** [AI_PROMPT_SHELL.md](../../01_AI_RULES/AI_PROMPT_SHELL.md) — không lặp boilerplate shell.

**Design authority:**

| File | Vai trò |
| --- | --- |
| [AGENTS.md](../../../AGENTS.md) | Product, UI rules, financial safety |
| [DESIGN.md](../../../DESIGN.md) | Tokens, component ladder |
| [Flutter-Native-Design-Standard.md](../standards/Flutter-Native-Design-Standard.md) | Trust-first, no dark patterns |
| [HomePage-Flutter-Native-Standard.md](../../04_SCREEN_REFERENCES/home/HomePage-Flutter-Native-Standard.md) | SC-007 visual standard |
| [prompt-redesign-trading-bots-hub-sc059.md](../prompt-redesign-trading-bots-hub-sc059.md) | Tier A reference |

---

## Design North Star

> **“Tin cậy trước, đơn giản trước, chuyên nghiệp luôn.”**

{NorthStarParagraph}

---

## Personas & hành trình

| Persona | Mục tiêu | ≤3 bước tap |
| --- | --- | --- |
| **Người mới** | {BeginnerGoal} | {BeginnerPath} |
| **User thường** | {RegularGoal} | {RegularPath} |
| **User nâng cao** | {PowerGoal} | {PowerPath} |

**Empty state:** {EmptyStateRule}

---

## Mục tiêu

1. Audit hub theo North Star + anti-patterns.
2. Redesign — hierarchy như Home, density thấp.
3. Giữ `Vit*`, tokens, test keys, product safety.
4. Before/after spec + verify 360px.

---

## Anti-patterns (audit STEP 1 — cập nhật từ code)

| Anti-pattern | Vì sao xấu | Hướng sửa |
| --- | --- | --- |
| Card trong card | Visual noise | Flat rows / divider |
| >2 primary actions / card | Overload | 1 CTA + overflow menu |
| Tab trong `VitCard` border | Drift AGENTS | Tab ngoài card |
| Local duplicate `Vit*` | Enterprise fail | Shared primitive |
| Magic radius/spacing | Drift | `AppRadii` / `AppSpacing` |
| {ModuleSpecific1} | TBD audit | TBD fix |

---

## Phạm vi

### Trong scope — Phase 1 (batch `{BatchId}`)

| Hub | Path |
| --- | --- |
| Primary | `{HubPagePath}` |
| Tests | `{HubTestPath}` |

### Ngoài scope Phase 1

Batch con cùng module — liệt kê link từ hub; redesign batch riêng.

### Không được làm

- Pub mới · đổi route/repository · xóa `sc*` keys · dark patterns.

---

## Home → {ModuleName} map

| Home (SC-007) | Hub |
| --- | --- |
| Hero summary | {HubHero} |
| Primary CTA | {HubCta} |
| Section rhythm | ≤3 section above fold |
| Empty + CTA | {EmptyPattern} |
| `VitTabBar` / segmented | {TabPattern} |

---

## IA scroll order (360px)

```text
1. Header + subtitle
2. Hero (2 KPI max)
3. Primary CTA
4. Tab / filter (if any)
5. Content list
6. Footer disclaimer (if financial)
```

---

## Copy & tone

- Headline: lợi ích, không tên module kỹ thuật.
- CTA verb-first · label ≤3 từ.
- Tránh hype / FOMO / casino language.

---

## Financial / product safety

{ProductSafetyRules}

---

## Quy trình

### STEP 0


### STEP 1–2

Audit table + wireframe + persona 3/3 + component map.

### STEP 3–4

`impact()` trước edit. Verify: `flutter analyze` + focused test. Gate: [AI_PROMPT_SHELL.md](../../01_AI_RULES/AI_PROMPT_SHELL.md).

### STEP 5

`vittrade-minimal-review` · clutter after ≤4/10.

**Completion:** `{CompletionLine}`

---

## Phase 2 handoff

```text
RESUME FROM: Phase 2 — {ModuleName} sub-batch
Parent: prompt-redesign/{parent-file}.md
Apply: North Star, Copy, Financial sections only.
Completion: {MODULE} SUB-PAGES UI REDESIGN DONE — <batch_id>
```
