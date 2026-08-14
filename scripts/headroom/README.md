# Headroom — VitTrade (Cursor-only)

Headroom nén output tool dài **trước khi** Cursor Agent đọc, qua MCP `headroom` trong Cursor.

Headroom là tooling tùy chọn cho Cursor; Codex không phụ thuộc vào proxy này.

## Hàng ngày

```powershell
.\scripts\Start-CursorSession.ps1
```

Hoặc chỉ proxy: `.\scripts\headroom\Start-VitTradeHeadroom.ps1`

Mở Cursor → Settings → MCP → `headroom` phải **connected** (restart IDE sau lần setup đầu).

## Scripts

| Script | Mục đích |
|--------|----------|
| `Start-VitTradeHeadroom.ps1` | **Bắt buộc** — proxy `:8787` cho MCP Cursor |
| `Stop-VitTradeHeadroom.ps1` | Dừng proxy |
| `vittrade.headroom.env` | Preset env (copy override → `vittrade.headroom.local.env`) |

## Cursor $200 — tối ưu quota

- Model: **Cursor Auto** — không chọn Sonnet/Opus/thinking thủ công.
- Batch **5–10 file**/turn; chat mới sau mỗi batch.
- GitNexus `impact()` / `query()` trước khi sửa (xem [AGENTS.md](../../AGENTS.md)).
- Agent gọi `headroom_compress` khi log test/analyze >500 dòng (rule: `.cursor/rules/vittrade-headroom.mdc`).
- Diff ngắn hơn qua `.cursor/rules/vittrade-minimal-diff.mdc` (bổ sung Headroom, không thay thế).

## Giới hạn

Proxy **không** nén traffic Cursor subscription (Agent chạy backend Cursor). Tiết kiệm đến từ MCP + quy trình batch.

## Theo dõi

```powershell
headroom perf
headroom dashboard
```
