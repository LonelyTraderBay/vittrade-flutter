# Kế hoạch redesign UI tablet Open Arena (đầy đủ + đúng đặc điểm tablet)

> Trạng thái: **ĐỀ XUẤT — chờ user duyệt mockup từng đợt** (mockup gate per
> cluster, theo quy tắc `user-redesign-mockup-gate`).
> Ngày lập: 2026-09-19. Phạm vi: CHỈ UI tablet của `features/arena`
> (theo chính sách `tablet-only-scope-policy`); không sửa phone/web.
> Mô hình quy trình: redesign Predictions 18/18 màn (2026-09-19 đóng sạc,
> 8 vòng user-review) — đo trang chuẩn → mockup → re-compose → router-pump
> Rect → chỉ sửa khi sai token.

## 1. Hiện trạng census (số liệu 2026-09-19)

### 1.1 Quy mô

| Tầng | File | Dòng | Ghi chú |
| --- | --- | --- | --- |
| Tablet pages | 7 file part (1 library `arena_tablet_pages.dart`) | **3.679** | 26 page class |
| Phone pages | 63 file (6 nhóm con) | 18.475 | 25 trang thư viện |
| Widgets dùng chung feature | 42 file | 10.015 | phần lớn chỉ phone dùng |

Route: **25 route thật + 1 redirect** (`/arena/points` → `/rewards?tab=arena`,
redirect áp ở CẢ phone lẫn tablet manifest — `tablet_route_manifest.dart:98`).

### 1.2 Phân tầng chất lượng 26 trang tablet

**Tier A — flagship 2 cột đã duyệt (6/26)** — redesign 2026-09-09, user đã
nghiệm thu trên emulator (`arena-tablet-redesign-flagship`):

| # | SC | Trang | Scaffold | Vấn đề còn |
| --- | --- | --- | --- | --- |
| 1 | SC-184 | `ArenaHomeTabletPage` (1.177 dòng) | `VitPageLayout` + `VitHeader` + `VitTwoColumnTabletDashboard` | `VitHeader` (home.dart:55) lệch chuẩn root hub `VitTopChrome rootModule` (predictions đã chuyển — commit 8a0d65e1); nợ R6-bare-block-list 1 (baseline `tablet_gap_role_baseline.txt`) |
| 2 | SC-209 | `ArenaGuideTabletPage` | `_ArenaHubScaffold` (VitHeader) + 2 cột | VitHeader như trên; CTA "Điểm Arena" trỏ `AppRoutePaths.arenaPoints` — path redirect ra ngoài module sang Rewards |
| 3 | SC-185 | `ArenaStudioTabletPage` | 2 cột | — |
| 4 | SC-205 | `MyArenaTabletPage` | 2 cột | — |
| 5 | SC-194 | `ArenaLeaderboardTabletPage` | 2 cột | không filter/kỳ (snapshot tĩnh) |
| 6 | (SC-200) | `ArenaPointsTabletPage` (hubs.dart:385) | 2 cột hoàn chỉnh | **DEAD CODE tầng route**: branch build ở `tablet_route_tree.dart:1175` không bao giờ tới vì redirect manifest thắng |

**Tier C — placeholder mỏng (20/26)** — mỗi trang ~55–120 dòng: khung
`VitTabletSectionFrame` + 1–2 card `_ardSection` chứa `Text` thuần,
cắt `.take(6/8/10)`, hầu như không có CTA/hành động:

| Cụm | SC | Trang | Nội dung tablet hiện tại | Thiếu so với phone |
| --- | --- | --- | --- | --- |
| Play | SC-189 | Mode detail | 1 card "Tóm tắt quy tắc" take(8) | lịch trình, phòng đấu, CTA tham gia |
| Play | SC-190 | Challenge detail | rules + bậc thưởng take(6) + 1 chip | 4 tab (Luật chơi/Bằng chứng/Thành viên/Hoạt động), clarity card, creator card, safety link — phone ~1.700 dòng/4 part |
| Play | SC-191 | **Join** | 2 card text (quy tắc + hoàn phí) | **toàn bộ chuỗi financial-safety**: 2 checkbox xác nhận, kiểm tra số dư `hasEnough`, gate `canJoin`, ActionStack confirm/decline (phone `arena_join_page.dart:120-195`) — KHÔNG có preview/confirm trên tablet |
| Play | SC-193 | Creator | trust metrics + live rooms dạng text | hồ sơ, stats, CTA follow/đấu |
| Gov | SC-192 | Resolution center | 1 card trạng thái | hàng đợi khiếu nại, CTA vào hồ sơ |
| Gov | SC-199 | Trust breakdown | metrics take(8) text | biểu diễn điểm uy tín theo trục, lịch sử |
| Gov | SC-203 | Blocked users | user id take(10) text | **nút mở chặn** — `ArenaBlockedUsersStateController.unblockUser` có sẵn nhưng KHÔNG trang tablet nào nối |
| Gov | SC-204 | My reports | report id take(10) text | trạng thái, filter, appeal |
| Gov | SC-202 | Report case | related reports take(6) text | timeline hồ sơ, trạng thái 5 mức, CTA appeal (`ArenaReportCaseController.reviewState` có sẵn) |
| Points | SC-201 | Points ledger | list mỏng | filter theo loại điểm, nhóm theo ngày, CTA entry detail |
| Points | SC-200 | Ledger entry detail | 1 card | chi tiết đầy đủ biến động điểm |
| Utility | SC-197 | Flow map | card text | sơ đồ luồng dạng panel trực quan |
| Utility | SC-198 | Safety center | card text | trung tâm an toàn đa mục + CTA vào các trang con |
| Utility | SC-206 | Production ready | card text | dashboard trạng thái hệ sinh thái |
| Utility | SC-207 | Prediction bridge | card text | nguyên tắc + ví dụ + chủ đề bridge (phone 4 part) |
| Utility | SC-208 | Ecosystem | card text | canonical states + flows registry (phone 4 part) |
| Studio | SC-186 | Smart rules | card text | **form builder 3 bước** của phone (583+ dòng) — `ArenaSmartRuleBuilderController` + `arenaCreationProvider` (Notifier mutation, phase submit) hoàn toàn không được tablet dùng |
| Studio | SC-187 | Preset library | card text | thư viện preset + filter domain + demo |
| Studio | SC-188 | Governance gate | card text | hành động quản trị (`ArenaGovernanceController.actionState` có sẵn) |
| Studio | SC-195 | Verified challenges | list mỏng | danh sách thử thách đã xác minh + CTA vào thử thách |

## 2. Luồng dữ liệu hiện trạng

```
UI tablet (26 trang)
 └── watch TRỰC TIẾP 25 FutureProvider snapshot
      (arena_controller_providers.dart — composition root)
      └── arenaReadModelControllerProvider  (read-model thuần)
          └── arenaRepositoryProvider (data/providers/arena_repository_provider.dart)
              ├── MockArenaRepository   — 27 method Future<T> (GD4 async playbook)
              └── FailClosedArenaRepository (fail-closed default)

BỎ NGỎ — KHÔNG trang tablet nào dùng:
 • arenaJoinControllerProvider              (view-state canJoin — STATE-S25)
 • arenaChallengeDetailControllerProvider   (pointsReview)
 • arenaGovernanceControllerProvider        (actionState)
 • arenaReportCaseControllerProvider        (reviewState/appeal)
 • arenaBlockedUsersStateControllerProvider (Notifier mutation unblockUser)
 • arenaCreationProvider                    (Notifier mutation tạo thử thách,
                                            ArenaCreationCommandPhase)
```

Phone ngược lại: đi qua controller/view-state đầy đủ. Tức là **layer dữ liệu đã
đủ cho mọi màn** — gap của tablet thuần túy ở presentation (không nối).
Chưa có remote repository (đúng chính sách chờ backend; theo
`remote-repository-playbook.md`).

## 3. Vấn đề (tổng hợp, có bằng chứng)

1. **P0 — Vi phạm Financial Safety tại SC-191 Join tablet**: tiêu điểm Arena
   (points-spend) không có preview số dư, không ack, không confirm
   (AGENTS.md: "Preview and confirm…" áp cho luồng chi; phone đã làm đúng).
2. **P0 — IA mâu thuẫn `/arena/points`**: redirect sang Rewards trên cả 2
   surface nhưng tablet vẫn giữ 1 hub 2 cột hoàn chỉnh không tới được
   (dead code ~170 dòng) + CTA Guide trỏ path redirect ra khỏi module.
3. **P1 — 20/26 trang placeholder-tier**: cắt `.take(N)`, Text thuần, không
   CTA, không tab, không filter → không "đầy đủ" và không dùng ưu thế màn
   rộng (không 2 cột, không master-detail, không hover states).
4. **P1 — Tablet bypass toàn bộ controller/mutation**: mở chặn, appeal,
   governance action, tạo thử thách đều không chạy được trên tablet.
5. **P1 — Chrome root hub lệch chuẩn**: Home + 5 hub dùng `VitHeader`;
   chuẩn mới (predictions 8a0d65e1) là `VitTopChrome rootModule` + top
   relaxed 16dp.
6. **P2 — Nợ R6-bare-block-list 1 site** ở home.dart (baseline
   `tablet_gap_role_baseline.txt`).
7. **P2 — Detail pages chưa dùng idiom workspace**: chuẩn có sẵn
   `VitTabletPaneWorkspace` (2026-09-17) chưa được arena dùng.

## 4. Quyết định sản phẩm cần chốt trước Đợt 1

| # | Quyết định | Đề xuất |
| --- | --- | --- |
| D1 | `/arena/points` | **Giữ redirect** sang `/rewards?tab=arena` (nhất quán 2 surface, Rewards là chủ điểm thưởng), **xoá class dead** `ArenaPointsTabletPage`, đổi CTA "Điểm Arena" của Guide sang target trực tiếp `/rewards?tab=arena` |
| D2 | Chính sách cắt nội dung | Bỏ toàn bộ `.take(N)` trong trang tablet; render đủ dữ liệu snapshot (fixtures hiện có số lượng nhỏ, không cần phân trang giai đoạn mock) |
| D3 | Leaderboard/Verified/Ledger có filter kỳ/k loại không | Mockup kèm mục filter; default là có (search + filter chip theo kỳ/loại) vì đây là "đặc điểm tablet" (đậm dữ liệu) |

## 5. Kế hoạch 5 đợt (mỗi đợt 1 scope, mockup gate trước khi code)

> Nguyên tắc áp mọi đợt (rút từ predictions + chuẩn hiện hành):
> - **Re-compose, không copy phone**: scaffold sở hữu khoảng dọc, pane
>   children không mang margin dọc của phone (rule S7), tablet tokens
>   (`TabletSpacingTokens`), gap theo role scale (section 12 / trong-section
>   tight 8 — bài học R6).
> - Mockup ASCII phải vẽ cả **hành vi cuộn** (bài học banner KPI predictions
>   2c5d5ada: hero/ngang không được fixed nếu không hợp đồng dashboard).
> - Nghiệm thu "lệch chuẩn": đo trang chuẩn cùng emulator → router-pump
>   widget-test Rect → chỉ sửa khi sai token; cảm giác chật = quyết định
>   thiết kế mới, qua mockup gate.
> - Part-file: tên theo vai trò (`_sections`, `_common`, `_widgets`) — cấm
>   `_NN`; file part cùng thư mục library cha.
> - Copy: tiếng Việt đủ dấu, points-only cho Arena (cấm payout/wallet/
>   profit/stake-return), không thêm chuỗi tiếng Anh user-facing.
> - Regan: đổi path/thêm file ⇒ regen artifact + baseline đúng thứ tự
>   (`presentation-artifact-regen-workflow`).
> - Gate mỗi đợt: focused test module + các guardrail chạm
>   (gap-role R1–R6, spacing, sheet, composition tier T1/T2, i18n) →
>   `preflight --fast`; cuối đợt commit riêng.

### Đợt 0 — Chuẩn hoá nền + dọn dead code (không cần mockup)

1. `VitHeader` → `VitTopChrome rootModule` (+ top relaxed 16dp) cho
   `ArenaHomeTabletPage` và `_ArenaHubScaffold` — đối chiếu pixel với hub
   Predictions/Ví trên cùng emulator (quy trình 8a0d65e1).
2. Trả nợ R6-bare-block-list 1 site ở `arena_tablet_pages_home.dart`
   (xóa khỏi baseline `tablet_gap_role_baseline.txt` khi hết).
3. D1: xoá `ArenaPointsTabletPage` + branch chết
   `tablet_route_tree.dart:1175` + đổi CTA Guide → `/rewards?tab=arena`;
   cascade regen artifact.
4. Nghiệm thu: đo Rect chrome hub Arena = hub Predictions; preflight.

*Kết quả: 5 hub flagship "đúng chuẩn tuyệt đối", cây route sạch, sẵn sàng làm
gốc chuẩn cho các đợm sau.*

### Đợt 1 — Cụm Play: detail + join (4 màn, P0 trước)

Phạm vi: SC-189 Mode detail, SC-190 Challenge detail, SC-191 Join,
SC-193 Creator. Ưu tiên SC-191 vì P0 financial-safety.

- **SC-190 Challenge detail** → archetype *detail workspace*:
  `VitTabletPaneWorkspace` — cột chính = overview (clarity card, creator
  card, 4 panel tab Luật chơi/Bằng chứng/Thành viên/Hoạt động re-compose
  từ phone part), panel phụ 400dp = bậc thưởng + CTA "Tham gia" ghim +
  safety link. Nối `arenaChallengeDetailControllerProvider` (pointsReview).
- **SC-191 Join** → workspace 2 cột: cột chính = tóm tắt thử thách + quy
  tắc + hoàn phí; panel phụ = số dư hiện tại/điểm vào/còn lại, 2 ack
  checkbox, nút confirm ghim `footer`. Confirm qua **`showVitConfirmSheet`**
  (điểm vào, số dư sau, hoàn phí, bước tiếp theo — đúng Financial Safety);
  route đi tiếp như phone. Nối `arenaJoinControllerProvider` (canJoin).
- **SC-189 Mode detail** → workspace: cột chính = quy tắc đầy đủ (bỏ
  take(8)) + lịch trình/phòng đấu; panel phụ = CTA "Vào thử thách" + liên
  kết hub.
- **SC-193 Creator** → workspace: cột chính = hồ sơ + chỉ số uy tín; panel
  phụ = phòng live (tile bấm được) + CTA "Xem độ tin cậy".
- Test: router-pump Rect các mép; test tương tác ack→canJoin→sheet confirm;
  guardrail sheet + gap role.

### Đợt 2 — Cụm Studio (4 màn, gắn mutation)

Phạm vi: SC-186 Smart rules, SC-187 Preset library, SC-188 Governance
gate, SC-195 Verified challenges.

- **SC-186 Smart rules** → archetype *form builder 2 cột*: cột chính = 3
  bước form (domain → loại thử thách → tham số) re-compose từ phone, nút
  "Xem lại & gửi" mở bottom sheet review (`VitSheetPanel`, footer CTA);
  panel phụ = bản tóm tắt live của draft. Nối `arenaCreationProvider`
  (phase submitting/success hiển thị đúng máy trạng thái, KHÔNG bọc
  AsyncValue).
- **SC-187 Preset library** → 2 cột: cột chính = thư viện preset (grid
  tile, filter domain/loại); panel phụ = preset đang chọn + demo + CTA
  "Dùng preset này" (sang Smart rules).
- **SC-188 Governance gate** → 2 cột: cột chính = điều kiện mở khoá + trạng
  thái từng cổng; panel phụ = hành động (`actionState` từ
  `arenaGovernanceControllerProvider`) qua confirm sheet.
- **SC-195 Verified** → 2 cột danh sách: cột chính = list thử thách xác minh
  (tile đầy đủ, CTA vào challenge detail); panel phụ = tiêu chí xác minh.

### Đợt 3 — Cụm Governance & An toàn (6 màn, master-detail list→detail)

Phạm vi: SC-192 Resolution, SC-198 Safety, SC-203 Blocked, SC-204 My
reports, SC-202 Report case, SC-199 Trust.

- **SC-204 My reports + SC-202 Report case + SC-192 Resolution** → gom
  thành trải nghiệm master–detail: list hồ sơ/báo cáo bên trái (search +
  filter trạng thái), chọn → detail pane bên phải dùng
  `VitTabletPaneWorkspace` (timeline 5 trạng thái, CTA appeal qua confirm
  sheet — `reviewState`).
- **SC-203 Blocked users** → 2 cột: list người bị chặn (tile + nút "Mở
  chặn" mỗi tile, confirm sheet) — nối `unblockUser`.
- **SC-198 Safety center** → 2 cột: trung tâm an toàn đa mục, mỗi mục CTA
  vào trang con tương ứng.
- **SC-199 Trust breakdown** → workspace: cột chính = biểu diễn điểm uy tín
  theo trục + lịch sử; panel phụ = tóm tắt + CTA report.

### Đợt 4 — Cụm Points/Ledger + nội dung hệ sinh thái (6 màn)

Phạm vi: SC-201 Ledger, SC-200 Ledger entry, SC-197 Flow map, SC-206
Production ready, SC-207 Bridge, SC-208 Ecosystem.

- **SC-201 Ledger** → 2 cột: cột chính = sổ điểm nhóm theo ngày, filter
  chip theo loại biến động, tile bấm vào entry; panel phụ = tổng quan
  điểm (điểm vào/ra kỳ này).
- **SC-200 Entry detail** → workspace: chi tiết biến động + ngữ cảnh thử
  thách liên quan.
- **SC-197/206/207/208** (trang nội dung/hướng dẫn hệ sinh thái) → chuẩn
  *section 2 cột*: cột chính = nội dung chính theo panel; panel phụ = mục
  lục/neo điều hướng + lối tắt. Đây là trang "tài liệu" — ưu tiên cấu trúc
  đề mục + neo thay vì dày đặc dữ liệu.

### Đợt 5 — Sweep nghiệm thu toàn module

1. Chạy đủ guardrail: gap-role R1–R6, spacing, gutter-flush, composition
   tier, sheet audit, i18n, tablet route surface.
2. Router-pump toàn 25 route arena tablet: không crash, có contentKey,
   back đúng tầng (BXBX/chi tiết → hub → home).
3. Emulator Pixel_Tablet: walkthrough 5 cụm + luồng join + tạo thử thách
   chạy thật; đo mật độ so hub chuẩn.
4. Full preflight → commit chốt.

## 6. Ước lượng

| Đợt | Trang | Khối lượng ước tính |
| --- | --- | --- |
| 0 | 6 hub + route | ~150 dòng sửa/600 xoá |
| 1 | 4 (play) | +1.200–1.600 dòng |
| 2 | 4 (studio) | +1.000–1.400 dòng |
| 3 | 6 (governance) | +1.200–1.600 dòng |
| 4 | 6 (points/utility) | +800–1.200 dòng |
| 5 | sweep | test/baseline |

Thứ tự lý do: P0 trước (join), mutation sớm (studio) để lộ gap controller
sớm nhất, nội dung tĩnh sau cùng.
