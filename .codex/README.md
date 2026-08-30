# Codex Workspace Guide

Đây là entrypoint ngắn cho Codex khi làm việc trong repo VitTrade. Nguồn luật
cao nhất vẫn là `AGENTS.md`; file này giúp chọn đúng tài liệu và skill mà
không phải nạp toàn bộ repo vào context.

## Bắt đầu một phiên

1. Đọc `AGENTS.md` và `docs/00_START_HERE.md`.
2. Chọn đúng một slice công việc từ `docs/INDEX.md`.
3. Với task nhiều file hoặc chưa rõ phạm vi, đọc
   `.codex/skills/planning-and-task-breakdown/SKILL.md` trước khi sửa.
4. Với thay đổi nhiều file, thực hiện từng batch nhỏ và verify sau mỗi batch;
   dùng `.codex/skills/incremental-implementation/SKILL.md`.
5. Trước commit, đọc `.codex/skills/code-review-and-quality/SKILL.md`.

## Skill router

| Tình huống | Skill cần đọc |
| --- | --- |
| UI/UX, tablet, spacing, density | `ui-ux-pro-max`, `frontend-ui-engineering`, `vittrade-ui-checklists` |
| Chọn domain UI và lệnh audit | `vittrade-design-domain` |
| Financial/P2P/high-risk flow | `vittrade-product-verify`, `security-and-hardening` |
| Bug, test fail, build fail | `debugging-and-error-recovery` |
| Behavior/state/test mới | `test-driven-development` |
| Trim diff trước khi hoàn tất batch | `vittrade-minimal-review`, `vittrade-batch-gate` |
| Review trước merge | `code-review-and-quality` |

Các đường dẫn đầy đủ nằm dưới `.codex/skills/<skill>/SKILL.md`.

## Verification chuẩn

Chạy từ `flutter_app/`:

```bash
dart format --output=none --set-exit-if-changed .
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
flutter analyze
flutter test --reporter=compact
```

Thêm audit/test theo module khi task chạm UI, router, financial flow hoặc
shared component. Không commit `build/`, `.dart_tool/`, `run-artifacts/`, log,
secret hoặc file cấu hình máy cá nhân.

## Runtime boundary

Codex là agent runtime duy nhất được hỗ trợ cho repo này. Không tạo lại
`.cursor/`, `.claude/`, Headroom, GStack hoặc MCP config trỏ sang project khác.
`.superpowers/` và `docs/superpowers/` chỉ là hồ sơ SDD lịch sử; không nạp vào
context trừ khi task chỉ rõ tài liệu đó.
