# ZCode Workspace Guide

Đây là entrypoint ngắn cho ZCode khi làm việc trong repo VitTrade. Nguồn luật
cao nhất vẫn là `AGENTS.md`; file này giúp chọn đúng tài liệu và skill mà
không phải nạp toàn bộ repo vào context.

## Bắt đầu một phiên

1. Đọc `AGENTS.md` và `docs/00_START_HERE.md`.
2. Chọn đúng một slice công việc từ `docs/INDEX.md`.
3. Với task nhiều file hoặc chưa rõ phạm vi, đọc
   `.agents/skills/planning-and-task-breakdown/SKILL.md` trước khi sửa.
4. Với thay đổi nhiều file, thực hiện từng batch nhỏ và verify sau mỗi batch;
   dùng `.agents/skills/incremental-implementation/SKILL.md`.
5. Trước commit, đọc `.agents/skills/code-review-and-quality/SKILL.md`.

## Skill router

| Tình huống | Skill cần đọc |
| --- | --- |
| Task nhiều file, chưa rõ phạm vi | `planning-and-task-breakdown`, `spec-driven-development` |
| UI/UX, tablet, spacing, density | `vittrade-ui-checklists`, `ui-ux-pro-max`, `frontend-ui-engineering` |
| Chọn domain UI và lệnh audit | `vittrade-design-domain` |
| Financial/P2P/high-risk flow | `vittrade-product-verify`, `security-and-hardening` |
| Bug, test fail, build fail | `debugging-and-error-recovery` |
| Behavior/state/test mới | `test-driven-development` |
| Trace caller / blast-radius qua code graph | `memory-for-ai-usage` |
| Trim diff trước khi hoàn tất batch | `vittrade-minimal-review`, `vittrade-batch-gate` |
| Review trước merge | `code-review-and-quality` |
| Nút chết / wiring handler lạ | `vittrade-button-wiring-audit` |
| Debt scan từng module (sprint) | `ponytail-audit` |
| Perf / jank / profiling | `performance-optimization` |

Các đường dẫn đầy đủ nằm dưới `.agents/skills/<skill>/SKILL.md`.

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

ZCode là agent runtime duy nhất được hỗ trợ cho repo này. Skill canonical nằm
ở `.agents/skills/` — không tạo lại bản copy dưới thư mục agent khác
(`.cursor/`, `.claude/`, v.v.). `.superpowers/` và `docs/superpowers/` chỉ là
hồ sơ SDD lịch sử; không nạp vào context trừ khi task chỉ rõ tài liệu đó.
