# Execution Prompt — Redesign UI Auth Hub (SC-001)

**Version:** 1.0  
**Batch:** `RD-M02-B01`  
**Accent:** Trust, security, clarity  
**Shell contract:** [AI_PROMPT_SHELL.md](../../01_AI_RULES/AI_PROMPT_SHELL.md) — không lặp boilerplate shell.

**Design authority:**

| File | Vai trò |
| --- | --- |
| [AGENTS.md](../../../AGENTS.md) | Product, UI rules, financial safety |
| [DESIGN.md](../../../DESIGN.md) | Tokens, component ladder |
| [Flutter-Native-Design-Standard.md](../standards/Flutter-Native-Design-Standard.md) | Trust-first, no dark patterns |
| [HomePage-Flutter-Native-Standard.md](../../04_SCREEN_REFERENCES/home/HomePage-Flutter-Native-Standard.md) | SC-007 visual standard |
| [trading-bots-hub.md](trading-bots-hub.md) | Tier A reference |

**Phase 2 handoff:** copy khối cuối file vào chat mới sau khi Phase 1 pass gate.

---

## Design North Star

> **“Tin cậy trước, đơn giản trước, chuyên nghiệp luôn.”**

Màn Login phải cảm giác như **cổng bảo mật fintech tier-1** (Coinbase / Kraken / Binance login — **pattern**, không copy brand):
- **Trust-first:** logo/wordmark rõ, không clutter quảng cáo; form tập trung 2 field + 1 CTA.
- **Security clarity:** lỗi field cụ thể; password toggle có semantics; demo login chỉ dev/mock — fail-closed production.
- **Clarity:** một primary action “Đăng nhập”; secondary links (quên MK, đăng ký) không cạnh tranh CTA.
- **Progressive disclosure:** không nhồi OAuth/social nếu chưa có route; không fake “verified” badges.

---

## Personas & hành trình bắt buộc

| Persona | Mục tiêu | Đường đi tối thiểu (≤3 bước tap) |
| --- | --- | --- |
| **Người mới** | Đăng nhập lần đầu | Login → nhập email/SĐT + MK → submit → home |
| **User thường** | Quay lại nhanh | Login → autofill field → submit |
| **User quên MK** | Khôi phục tài khoản | Login → “Quên mật khẩu?” → forgot flow |

**Error state bắt buộc:** validation inline + message rõ (empty identifier/password, auth fail) — không generic “Error”.

---

## Mục tiêu

1. **Audit** UI hub SC-001 theo North Star + anti-patterns bên dưới.
2. **Redesign** sang, tối giản — hierarchy rõ, density thấp, touch ≥44px.
3. **Giữ** enterprise compliance: `Vit*`, tokens, test keys `sc001_login_*`, auth repository contract.
4. **Deliver** before/after spec verify bằng test + visual check 360px.

---

## Anti-patterns — phải loại bỏ

| Anti-pattern | Vì sao xấu | Hướng sửa |
| --- | --- | --- |
| Hero marketing dài trên login | Distraction, giảm trust | 1 headline + 1 subtitle max |
| >2 CTA primary cùng hàng | Cognitive overload | 1 `VitCtaButton` primary; demo secondary/outline |
| Password field không toggle | UX fail | Giữ `passwordToggleKey` + semantics |
| Local `_auth*` colors ngoài tokens | Drift | `AppColors.primary*` only |
| Card trong card cho form | Clutter | Single surface / `VitPageContent` |
| Demo login hiện production | Security risk | Guard `enableMockData` / env test |
| Magic radius/spacing | Drift | `AppRadii` / `AppSpacing` |

---

## Phạm vi (scope)

### Trong scope — Phase 1 (batch `RD-M02-B01`)

| Mục | Path |
| --- | --- |
| Hub | `lib/features/auth/presentation/pages/login_page.dart` |
| Test | `test/features/auth/login_page_test.dart` |

### Ngoài scope Phase 1

`register_page`, `forgot_password_page`, 2FA, OAuth — audit link từ login; batch Phase 2 nếu plan có.

### Không được làm

- Pub mới · đổi route/repository/auth logic · xóa/đổi `Key` `sc001_login_*` · dark patterns (fake urgency, hidden terms).

---

## Chuẩn thiết kế — map Home → Auth Login

| Home (SC-007) | Login hub (SC-001) |
| --- | --- |
| Clean header rhythm | Wordmark + welcome headline |
| Primary next action | Full-width “Đăng nhập” CTA |
| Trust surfaces | Subtle security copy (1 dòng) nếu cần |
| Form density | 2 inputs stacked + spacing token |
| Secondary navigation | Forgot + Register as text links |
| Dark surfaces | `surface` / `surface2` tokens only |
| Loading/submitting | Disabled CTA + progress khi `_submitting` |

### Component ladder

`VitInput`, `VitCtaButton`, `VitPageLayout`, `VitPageContent`, `VitIconButton` (password toggle) — trước local widgets. Radius: `inputRadius` for fields/buttons.

## IA & content hierarchy (360px)

```text
1. Top safe area + brand mark
2. Headline + subtitle (value: secure access)
3. Identifier field (email/SĐT)
4. Password field + toggle
5. Inline error (if any)
6. Primary CTA "Đăng nhập"
7. Demo CTA (dev/mock only — visually de-emphasized)
8. Row: Quên mật khẩu | Đăng ký
9. Optional footer legal micro-copy
```

**Form target:** không scroll on 360×800 khi keyboard đóng; keyboard open vẫn thấy active field.

---

## Copy & tone

- Headline: chào + lợi ích (“Đăng nhập an toàn”), không jargon backend.
- Error: hướng dẫn sửa (“Vui lòng nhập email hoặc số điện thoại”).
- CTA verb-first: “Đăng nhập”, “Dùng tài khoản demo”.
- Tránh: “Kiếm tiền ngay”, emoji, hype.

---

## Financial / product safety

- Không hiển thị số dư/wallet trên login.
- Demo credentials chỉ khi mock enabled; production test assert fail-closed (đã có pattern trong test).
- Mask password; không log identifier trong UI debug.
- Link register/forgot phải navigate đúng route — không dead tap.

---

## Quy trình thực thi

### STEP 0 — Khám phá

GitNexus `query` + `context` `LoginPage`. Baseline:

```bash
cd flutter_app
flutter test test/features/auth/login_page_test.dart --reporter=compact
```

### STEP 1–2 — Audit + spec

Bảng P0–P2 + clutter before; wireframe, before/after, persona 3/3, component map. **Không dừng hỏi user.**

### STEP 3 — Implementation

`impact()` trước edit. Giữ `_submit`, validation, demo guard. Verify 360px + keyboard.

### STEP 4 — Verification

```bash
dart format --output=none --set-exit-if-changed lib/features/auth/presentation/pages/login_page.dart test/features/auth/login_page_test.dart
flutter analyze
flutter test test/features/auth/login_page_test.dart --reporter=compact
```

Test cover (giữ `sc001_login_*`): field validation, submit success, forgot/register navigation, demo vs production, password toggle.

### STEP 5 — Batch self-check

`vittrade-minimal-review` · clutter after ≤4/10.

---

## Acceptance criteria (Phase 1 gate)

- [ ] Audit + spec + persona 3/3 trong chat.
- [ ] Clutter after ≤4/10.
- [ ] Single primary CTA; form ≤2 fields above fold.
- [ ] Error states clear; demo hidden/disabled in production path.
- [ ] 100% `Vit*` + tokens; `flutter analyze` clean; tests pass.
- [ ] No auth/navigation regression.

**Completion line:** `AUTH HUB UI REDESIGN DONE — RD-M02-B01`

---

## Batch discipline

Max **5–10 files**/chat · Phase 1 = login only · Codex · STEP 0→5 liên tục.

---

## Phase 2 handoff

```markdown
RESUME FROM: Phase 2 — Auth sub-pages
Parent: docs/02_FLUTTER_MIGRATION/prompt-redesign/auth-hub.md
Completion: AUTH SUB-PAGES UI REDESIGN DONE — <batch_id>
```
