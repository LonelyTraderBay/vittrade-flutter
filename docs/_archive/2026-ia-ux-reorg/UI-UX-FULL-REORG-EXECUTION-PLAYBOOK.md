# UI/UX Full Reorg — Execution Playbook (AI Step Tracker)

Generated: 2026-07-21  
**Last reconciled:** 2026-07-22 (P0–P6 done — **PROGRAM COMPLETE**)  
Authority: `AGENTS.md` · `Two-Phase-Codex-Workflow.md` · this file
Entry index: [`00-INDEX.md`](./00-INDEX.md)

**Mục tiêu:** Sắp xếp lại navigation + hub composition để user **không bị rỗi / lạc**, tìm được sản phẩm trong ≤3 tap từ entry điểm, mỗi hub có nội dung actionable (không blank/sparse).

**Phạm vi:** Toàn app VitTrade Flutter (`flutter_app/`).  
**Không thuộc phạm vi:** Backend thật, đổi package structure, thêm bottom-nav tab thứ 6 (trừ khi product đổi quyết định).

---

## 0. Cách AI dùng file này (BẮT BUỘC)

### 0.1 Chính sách chat (đã chọn): **cùng một chat, làm tuần tự theo STEP**

User muốn AI **làm theo thứ tự trong cùng một chat**, không bắt buộc 1 chat = 1 STEP.

| Chế độ | Khi nào dùng |
|--------|----------------|
| **A — Same-chat continuum (mặc định)** | Làm `STEP` kế tiếp trong **cùng chat** sau khi STEP trước `done` + tick dashboard + log |
| **B — New chat** | Chỉ khi chạm **hard stop** §0.3 (context bẩn / fail chồng / đổi phase lớn / user yêu cầu) |

**Không** được nhảy STEP (ví dụ P0.1 → P0.5).  
**Không** được mở song song 2 STEP code cùng lúc trên cùng worktree.

### 0.2 Phân tích: cùng chat được không?

| Khía cạnh | Cùng 1 chat (A) | 1 chat / 1 STEP (B) |
|-----------|-----------------|---------------------|
| Tiến độ liên tục | Tốt — AI nhớ quyết định D1–D6, style docs vừa viết | Phải `@` playbook + re-orient mỗi lần |
| Bỏ sót STEP | Thấp nếu **bắt buộc tick checklist** sau mỗi STEP | Thấp nếu user nhớ mở đúng STEP |
| Context Codex (~40% soft ceiling) | **Rủi ro chính** — chat dài → AI quên rule / hallucinate file | An toàn hơn, tốn công mở chat |
| Docs-only (P0) | **Nên cùng chat** — ít token, cùng family wireframe | Không cần thiết |
| Code batch (P1+) | Cùng chat **được** nếu mỗi STEP vẫn ≤5–10 file + verify xong mới sang STEP sau | Bắt buộc new chat nếu analyze/test fail chồng hoặc đụng >10 file |

**Kết luận phân tích:** Làm tuần tự trong **một chat là được và phù hợp P0 + chuỗi STEP nhỏ**. Vẫn phải giữ **ranh giới STEP** (xong → tick → verify → mới STEP kế). Không biến cả 51 STEP thành một “big bang” không checkpoint.

### 0.3 Quy trình trong cùng chat (mỗi STEP)

1. Đọc đúng `STEP-x.y` đang `pending` / được chỉ định.  
2. Đọc file nguồn STEP liệt kê.  
3. Nếu sửa Dart: GitNexus `impact` trước khi sửa symbol.  
4. Làm **hết** must-do của STEP; không kéo việc của STEP sau vào.  
5. Chạy **verify của STEP**; ghi evidence ngắn.  
6. Tick `[x]` ở checkbox STEP **và** cập nhật §1 Dashboard + §1.1 Log.  
7. **Tự chuyển** sang STEP kế trong playbook (báo user: `Done STEP-… → next STEP-…`) — **không hỏi** “có làm tiếp không?” trừ khi `blocked`.  
8. Runtime: Codex theo workflow đã chốt; không đổi model giữa batch.

### 0.4 Soft ceiling (cùng chat vẫn tiếp tục được, nhưng AI phải cảnh báo)

Sau mỗi STEP, nếu **một** điều sau đúng → ghi log `soft_warn` và **đề xuất** new chat (user có thể bảo “cứ tiếp tục”):

- Context / chat đã rất dài (statusline > ~40% nếu có)  
- Vừa xong **cả một phase** (P0.12, P1.6, P2.9, …)  
- Vừa sửa **>8 file Dart** trong STEP  
- Verify có warning lặp lại 2 lần

### 0.5 Hard stop — **phải** dừng chat hiện tại / new chat (không thương lượng)

Dừng continuum, mở chat mới (vẫn bám STEP kế, không nhảy):

1. STEP `blocked` (thiếu quyết định product / conflict)  
2. `flutter analyze` hoặc test **FAIL** và đã thử fix **1 lần** trong chat mà vẫn fail  
3. User bảo rewind / đổi hướng  
4. Bắt đầu **P1 lần đầu** sau P0 (ranh giới docs→code): **khuyến nghị mạnh** new chat; nếu user nói “cùng chat” thì được, nhưng AI nhắc soft_warn  
5. Hai phase code khác nhau trên file chồng chéo (ví dụ P2 Trade + P3 Earn) trong cùng lúc

### 0.6 Giới hạn gộp STEP (tránh bỏ sót)

| Loại | Trong cùng chat | Gộp nhiều STEP? |
|------|-----------------|-----------------|
| Docs-only (P0.2–P0.8) | Có | Được gộp **tối đa 2 STEP hub** liên tiếp nếu cùng template và user không cấm; vẫn tick **từng** STEP |
| Docs matrix/ledgers (P0.9–P0.12) | Có | **Không gộp** — từng STEP |
| Code (P1+) | Có (continuum) | **Không gộp** 2 STEP code; xong verify mới STEP sau |
| Checkpoint STEP (`*.6`, `*.9`, `P0.12`, `P6.5`) | Có | **Không gộp** với STEP khác |

### 0.7 Prompt Execute — continuum (cùng chat)

```text
Làm tuần tự theo playbook (cùng chat được):
@docs/02_FLUTTER_MIGRATION/audits/IA-Route-Entry-Point-Map/UI-UX-FULL-REORG-EXECUTION-PLAYBOOK.md

Bắt đầu từ STEP-<id> (hoặc STEP pending đầu tiên).
Chế độ: Same-chat continuum (§0.1 A).

Ràng buộc:
- Làm lần lượt theo thứ tự; không nhảy STEP; không gộp 2 STEP code
- Docs P0: có thể gộp tối đa 2 STEP hub (P0.2–P0.8) nếu cùng template — vẫn tick từng STEP
- Mỗi STEP xong: verify → tick checkbox + §1 Dashboard + §1.1 Log → báo next STEP → tiếp tục
- Hard stop §0.5: dừng và nói rõ lý do
- Soft ceiling §0.4: cảnh báo nhưng tiếp tục nếu user đã chọn continuum
- Dùng phiên Codex hiện tại; Dart: GitNexus impact trước khi sửa symbol
- P0: không sửa flutter_app/lib (trừ khi STEP ghi rõ)
```

### 0.8 Prompt Execute — một STEP (khi hard stop / user muốn tách)

```text
Thực hiện đúng STEP-<id> trong:
@docs/02_FLUTTER_MIGRATION/audits/IA-Route-Entry-Point-Map/UI-UX-FULL-REORG-EXECUTION-PLAYBOOK.md

Ràng buộc: chỉ STEP đó; tick + log; verify; báo next STEP id — chờ chat mới nếu đang ở chế độ tách chat.
```

---

## 1. Progress Dashboard (AI cập nhật sau mỗi STEP)

| Phase | Status | Done / Total STEPs | % |
|-------|--------|-------------------:|--:|
| P0 Spec depth | `done` | 12 / 12 | 100% |
| P1 Home+Profile | `done` | 6 / 6 | 100% |
| P2 Markets+Trade+Wallet | `done` | 9 / 9 | 100% |
| P3 Earn+P2P | `done` | 8 / 8 | 100% |
| P4 Discovery | `done` | 6 / 6 | 100% |
| P5 Density+States | `done` | 5 / 5 | 100% |
| P6 Wiring+VisualQA | `done` | 5 / 5 | 100% |
| **TỔNG** | | **51 / 51** | **100%** |

Status values: `pending` · `in_progress` · `blocked` · `done`

### 1.0 Hiện trạng thực tế (reconciled 2026-07-22 · P6 COMPLETE)

| Mục | Giá trị |
|-----|---------|
| **Next STEP** | — (program complete) |
| **Phases xong** | P0 · P1 · P2 · P3 · P4 · P5 · **P6** |
| **Phases còn** | **0** |
| **Branch** | `ia-ux-readiness-pack` |
| **Git note** | Diff lớn P1–P6 trên worktree (+ `1b1511c1` P5.4). Nên mở PR → `main`. |
| **D1–D6** | Locked |
| **RG** | RG-01…11,13 closed/accepted; **RG-12** open tension (D1) — không block program |
| **Sparse P0** | **0** |
| **Button wiring** | `broken=0` (P6.1/P6.2 ledgers) |
| **Visual QA** | **33/33 GIỮ** · 65 phone QA flows @360×800 |
| **Verify P6.5** | route+nav+analyze PASS; `flutter test` **3534** PASS |

**Prompt continue:**

```text
Program complete. Open PR for ia-ux-readiness-pack → main.
```

### 1.1 Run log (append-only)

| When | STEP | Agent/chat | Result | Evidence (1 dòng) |
|------|------|------------|--------|-------------------|
| 2026-07-21 | P0.1 | continuum | done | INDEX badge DEPTH PARTIAL; Trade terminal wording; pack links; EP-26/27 D5 |
| 2026-07-21 | P0.2 | continuum | done | `18` path→tab full + D1 + reselect/back |
| 2026-07-21 | P0.3 | continuum | done | `19` Markets deep; heatmap/watchlist inbound=no |
| 2026-07-21 | P0.4 | continuum | done | `20` Trade terminal-first + D5 header; no Orders hub-tab |
| 2026-07-21 | P0.5 | continuum | done | `21` Wallet D6 promote history/address-book/health-score |
| 2026-07-21 | P0.6 | continuum | done | `22` Earn 31 GOM in 5 clusters + dual hub |
| 2026-07-21 | P0.7 | continuum | done | `23` P2P ≤3-tap Express/Create/Orders |
| 2026-07-21 | P0.8 | continuum | done | `24` boundary Pred/Arena + `25` auth no-shell |
| 2026-07-21 | P0.9 | continuum | done | `26` 33/33 GIỮ edges + HUB family rules |
| 2026-07-21 | P0.10 | continuum | done | Ledgers RG-01–13, 33 Visual QA, hub contracts |
| 2026-07-21 | P0.11 | continuum | done | Gate D1–D6 locked; DEPTH READY |
| 2026-07-21 | P0.12 | continuum | done | INDEX `SPEC DEPTH READY FOR P1`; P0=done |
| 2026-07-21 | — | continuum | soft_warn | Phase P0 complete → prefer new chat before STEP-P1.1 code |
| 2026-07-21 | P1.1 | continuum | done | Home 4 quick + 4 groups; Support/Referral off; analyze+75 tests PASS |
| 2026-07-21 | P1.2 | continuum | done | News header EP-30; D3 recent under Discovery; D4 ticker kept; 78 tests |
| 2026-07-21 | — | continuum | soft_warn | P1.1+P1.2 code done → prefer new chat before STEP-P1.3 Profile |
| 2026-07-22 | P2.5 | continuum | done | vi-VN switcher labels + Rủi ro cao on Margin/Bot; analyze+17 tests PASS |
| 2026-07-22 | — | continuum | soft_warn | User nhảy tới P2.5; P1.3–P2.4 vẫn pending — resume P1.3 hoặc P2.1 theo thứ tự |
| 2026-07-22 | P1.3 | continuum | done | Profile sections + KYC banner D2 + legal scaffold; profile tests PASS |
| 2026-07-22 | P2.1 | continuum | done | Heatmap+Watchlist chips; RG-01/02 closed; markets nav test PASS |
| 2026-07-22 | P2.2 | continuum | done | HUB strip only; ẨN→Thêm sheet; Ngành off header |
| 2026-07-22 | P2.3 | continuum | done | route+nav+analyze PASS; markets suite 182 PASS |
| 2026-07-22 | P2.4 | continuum | done | Spot header Lệnh/Vị thế D5; RG-03/04 closed; trade tests PASS |
| 2026-07-22 | — | continuum | soft_warn | P1.3+P2.1–P2.4 cùng chat; prefer new chat → P1.4 hoặc P2.6 |
| 2026-07-22 | P1.4 | continuum | done | Pháp lý accordion 39 GOM / 5 nhóm; RG-08 closed; catalog+page tests PASS |
| 2026-07-22 | P1.5 | continuum | done | Empty stubs home+profile=0; Home-Profile-IA-Delta-Checklist 100% |
| 2026-07-22 | P1.6 | continuum | done | route+nav+analyze PASS; home+profile 161 tests; fixture sections=6 |
| 2026-07-22 | — | continuum | soft_warn | Phase P1 complete → prefer new chat before STEP-P2.6 |
| 2026-07-22 | P2.6 | continuum | done | Trade golden updated; analyze+trade suite 100 PASS; RG-03/04 already closed |
| 2026-07-22 | P2.7 | continuum | done | D6 tools visible + overflow Thêm; RG-05/06/07 closed; wallet_page 7 PASS |
| 2026-07-22 | P2.8 | continuum | done | deposit/withdraw/address-add preview suites PASS; notice intact |
| 2026-07-22 | P2.9 | continuum | done | route+nav+analyze PASS; markets+trade+wallet **410** PASS |
| 2026-07-22 | — | continuum | soft_warn | Phase P2 complete → prefer new chat before STEP-P3.1 |
| 2026-07-22 | P3.1 | continuum | done | Earn tools grid 8 HUB + Bảng điều khiển/Tiết kiệm CTA; vi-VN accents |
| 2026-07-22 | P3.2 | continuum | done | EarnLegalCatalog 31 GOM / 5 cụm sheet; RG-09 closed |
| 2026-07-22 | P3.3 | continuum | done | Savings tile grid + Thêm overflow; stacked cards removed |
| 2026-07-22 | P3.4 | continuum | done | earn golden refresh; analyze+earn suite **484** PASS |
| 2026-07-22 | P3.5 | continuum | done | Express nhanh + Tạo tin + Đơn rõ ≤3-tap |
| 2026-07-22 | P3.6 | continuum | done | Công cụ sheet 11 HUB; marketplace body giữ |
| 2026-07-22 | P3.7 | continuum | done | Escrow vi-VN; payment-method preview PASS |
| 2026-07-22 | P3.8 | continuum | done | route+nav+analyze PASS; earn 484 + p2p 437 PASS |
| 2026-07-22 | — | continuum | soft_warn | Phase P3 complete → prefer new chat before STEP-P4.1 |
| 2026-07-22 | — | continuum | reconciled | §1.0 snapshot: P0–P3 done / next P4.1; worktree có diff P1–P3 chưa commit hết |
| 2026-07-22 | P4.1 | continuum | done | Predictions Danh mục+tools → portfolio canonical; empty/error giữ |
| 2026-07-22 | P4.2 | continuum | done | Arena Của tôi→/arena/my; Công cụ sheet; Chỉ điểm Arena; product_copy PASS |
| 2026-07-22 | P4.3 | continuum | done | Home Discovery canonical; Markets footer «Lối tắt từ Markets» |
| 2026-07-22 | P4.4 | continuum | done | Khám phá labels Token mới/Phần thưởng/Chủ đề |
| 2026-07-22 | P4.5 | continuum | done | Profile redirects→portfolio+/arena/my; matrix `26` updated |
| 2026-07-22 | P4.6 | continuum | done | route+nav+analyze PASS; Discovery focused+home 75 + product_copy PASS |
| 2026-07-22 | — | continuum | soft_warn | Phase P4 complete → prefer new chat before STEP-P5.1 |
| 2026-07-22 | P5.1 | continuum | done | Regen density+body; expected screens 415; Sparse watchlist refreshed (13 P0) |
| 2026-07-22 | P5.2 | continuum | done | EARN-LEGAL 5 pages: scrollEndPadding + gap alias→xN; Spacers removed |
| 2026-07-22 | P5.3 | continuum | done | SAVINGS/ARENA/PRED/DCA (+TradingBots emergent); product P0→0 |
| 2026-07-22 | P5.4 | continuum | done | Earn/Savings/Arena VitEmptyState gaps; State-Coverage note; commit 1b1511c1 |
| 2026-07-22 | P5.5 | continuum | done | P0=1 DEV-EXC only; density/body/route/nav+analyze PASS; P5=`done` |
| 2026-07-22 | — | continuum | soft_warn | Phase P5 complete → prefer new chat before STEP-P6.1 |
| 2026-07-22 | P6.1 | continuum | done | trade+markets+wallet wiring: broken=0 (2 legitimate) |
| 2026-07-22 | P6.2 | continuum | done | earn+p2p+discovery wiring: broken=0 (1 legitimate) |
| 2026-07-22 | P6.3 | continuum | done | 5 bottom-nav GIỮ phone QA expectBottomNav @360×800 |
| 2026-07-22 | P6.4 | continuum | done | 33/33 GIỮ evidence; flows 43–65; positions overflow fix |
| 2026-07-22 | P6.5 | continuum | done | DoD; INDEX PROGRAM COMPLETE; flutter test **3534** PASS |
| 2026-07-22 | P6.5 | continuum | reverify | phone Visual QA **65/65** PASS; wiring artifacts `broken=0`; playbook P5.5 Next cleared |

### 1.2 Product decisions lockboard (phải chốt trước STEP-P1.1)

| ID | Decision | Default nếu user im lặng | Locked? |
|----|----------|--------------------------|---------|
| D1 | Active-tab secondary products | **A** = highlight Trade (giữ code) | [x] locked 2026-07-21 continuum |
| D2 | KYC trên Profile | **Banner** + row phụ | [x] locked 2026-07-21 continuum |
| D3 | Home “Gần đây” strip | **Giữ** dưới Discovery | [x] locked 2026-07-21 continuum |
| D4 | Home market ticker | **Giữ** (compact) | [x] locked 2026-07-21 continuum |
| D5 | Trade Orders/Positions | **Header actions** (không đổi `/trade` thành hub tab) | [x] locked 2026-07-21 continuum |
| D6 | Wallet tools bị chôn | **Promote 3**: history, address-book, health-score; còn lại overflow | [x] locked 2026-07-21 continuum |

> D1–D6 **đã khóa** (defaults + user khởi động continuum 2026-07-21). STEP-P1.1 được phép sau P0.12.

---

## 2. Definition of Done toàn chương trình

Chương trình **DONE** chỉ khi:

- [x] Mọi STEP P0–P6 = `done`
- [x] 196 GIỮ/HUB/GOM có menu home duy nhất + inbound verified hoặc exception có lý do
- [x] Home không còn 17 quick-action phẳng; có nhóm sản phẩm + Discovery tách
- [x] Profile có Pháp lý accordion; Support/Referral không còn trên Home quick actions
- [x] Trade = terminal-first + Orders/Positions header (theo D5)
- [x] Sparse P0 có fix hoặc exception documented
- [x] Home+Profile button empty-stubs = 0; hub modules đã sweep
- [x] 33 GIỮ có Visual QA tier và P0 bottom-nav đã có evidence @360×800
- [x] `route_coverage` + `navigation_edge` + `flutter analyze` PASS trên branch cuối

---

## 3. PHASE P0 — Làm dày bằng chứng (CHƯA sửa Flutter UI)

**Mục tiêu:** Đưa file `18`–`26` + ledgers lên chuẩn độ sâu gần [`17-HOME-PROFILE-MENU-WIREFRAME.md`](./17-HOME-PROFILE-MENU-WIREFRAME.md).  
**Cấm:** Sửa `flutter_app/lib/**` trong P0 (trừ regenerate audit artifacts nếu tool yêu cầu ghi `docs/…/audits/*.md|csv`).

### Chuẩn template mỗi hub wireframe (áp dụng STEP-P0.2 → P0.8)

Mỗi file hub phải có đủ section:

1. Generated date + sources (IA module + production paths)
2. ASCII wireframe @360×800 (hiện tại **và** đề xuất nếu khác)
3. Section order (top→bottom)
4. Menu tree: mọi route **GIỮ + HUB + GOM** thuộc shell (path + page class + phân loại)
5. Current vs proposed table
6. Empty / loading / error rules
7. File mapping (widget file → section)
8. Open decisions (nếu còn)
9. Gaps / reachability notes

---

### STEP-P0.1 — Sửa INDEX + đồng bộ Trade wording

- [x] **Status:** done  

- **Làm gì:**
  1. Cập nhật [`00-INDEX.md`](./00-INDEX.md): thêm section link đủ `18`–`26` + toàn bộ ledger/gate/playbook.
  2. Đổi badge “Evidence pack COMPLETE” → **`FRAME COMPLETE / DEPTH PARTIAL`** cho đến hết P0.
  3. Sửa legend “Trade hub → Lệnh” → **“Trade terminal (Spot) + Orders/Positions secondary”** (khớp `20` + D5).
  4. Link playbook này ở đầu INDEX.
- **Files:** `00-INDEX.md`, (optional) `UI-UX-REORG-MASTER-PLAN.md` trỏ sang playbook này  
- **Verify:** Mọi file trong folder readiness đều có link từ INDEX; không còn mâu thuẫn Trade hub-tab.  
- **Next:** STEP-P0.2

---

### STEP-P0.2 — Làm dày `18-APP-SHELL-BOTTOM-NAV-SPEC.md`

- [x] **Status:** done  

- **Làm gì:** Bổ sung: reselect/back matrix; bảng path→active_tab đầy đủ theo `_activeDestinationForPath`; full-bleed exceptions; header Search/Notifications/News; D1 documented.  
- **Đọc:** `root_routes.dart`, `vit_app_shell.dart`, `vit_bottom_nav.dart`, `visual_qa_route_metadata.dart`  
- **Verify:** Spec có thể trả lời “path X highlight tab nào?” không cần mở code.  
- **Next:** STEP-P0.3

---

### STEP-P0.3 — Làm dày `19-MARKETS-HUB-WIREFRAME.md`

- [x] **Status:** done  

- **Làm gì:** Template §3 đủ; liệt kê 10 HUB Markets; ghi rõ gap heatmap/watchlist; Discover footer = shortcut only.  
- **Đọc:** `market_list_page.dart`, `market_list_tools.dart`, `03-markets.md`  
- **Verify:** Mỗi HUB Markets có dòng “inbound UI: yes/no + widget”.  
- **Next:** STEP-P0.4

---

### STEP-P0.4 — Làm dày `20-TRADE-HUB-WIREFRAME.md`

- [x] **Status:** done  

- **Làm gì:** Khóa terminal-first; map product switcher; EP-26/27 header actions (D5); GOM compliance → Profile; file mapping `trade_page` / `trade_product_navigation`.  
- **Verify:** Không còn đề xuất “Trade = Orders tab hub”.  
- **Next:** STEP-P0.5

---

### STEP-P0.5 — Làm dày `21-WALLET-HUB-WIREFRAME.md`

- [x] **Status:** done  

- **Làm gì:** Section order thật; EP-08/09 dual entry; promote list theo D6; financial preview notes.  
- **Verify:** History không chỉ “buried” — có proposed entry.  
- **Next:** STEP-P0.6

---

### STEP-P0.6 — Làm dày `22-EARN-SAVINGS-HUB-WIREFRAME.md`

- [x] **Status:** done  

- **Làm gì:** Dual entry EP-15/16/28/29; list **31 GOM** nhóm 5 cluster; hub tile model vs stacked cards; Hub-Content-Contract.  
- **Đọc:** `06-earn.md`, staking/savings pages  
- **Verify:** 31 GOM đều xuất hiện trong tree sheet.  
- **Next:** STEP-P0.7

---

### STEP-P0.7 — Làm dày `23-P2P-HUB-WIREFRAME.md`

- [x] **Status:** done  

- **Làm gì:** Marketplace vs Công cụ drawer; map ~11 HUB; ghi ẨN flows contextual; insurance → Pháp lý.  
- **Verify:** User path Express / Create offer / My orders rõ ≤3 tap.  
- **Next:** STEP-P0.8

---

### STEP-P0.8 — Làm dày `24` + `25`

- [x] **Status:** done  

- **Làm gì:**  
  - `24`: bảng boundary Predictions vs Arena; Discovery dedup Home/Markets/Profile; canonical portfolio routes.  
  - `25`: auth ngoài shell; flow graph; post-auth `/home`; mock no-guard note.  
- **Verify:** Không mixed wallet/points copy trong Arena wireframe.  
- **Next:** STEP-P0.9

---

### STEP-P0.9 — Làm dày `26-CROSS-SHELL-NAV-EDGE-MATRIX.md`

- [x] **Status:** done  

- **Làm gì:** Bảng đầy đủ mọi **GIỮ** (source, target, nav_kind, back_fallback, active_tab, EP). Rule block cho mọi **HUB** family. GOM canonical homes không trùng.  
- **Verify:** Đếm GIỮ rows = 33 (hoặc giải thích thiếu EP-10/25).  
- **Next:** STEP-P0.10

---

### STEP-P0.10 — Làm dày ledgers usability

- [x] **Status:** done  

- **Làm gì:** Mở rộng từng file tới mức actionable:
  - `Reachability-Gap-Report.md` — bảng gap + exception + owner STEP
  - `Sparse-Screen-Watchlist.md` — đủ 13 P0 + batch id
  - `Hub-Content-Contract.md` — đủ hub Tier-A
  - `State-Coverage-by-Archetype.md` — giữ + ví dụ route
  - `Visual-QA-Route-Manifest.md` — list 33 GIỮ
  - `Button-Wiring-Baseline-Ledger.md` — scope matrix modules
  - `Home-Profile-IA-Delta-Checklist.md` — giữ nguyên + link D2–D4
- **Verify:** Mỗi ledger ≥1 bảng cụ thể, không chỉ 5 dòng trống.  
- **Next:** STEP-P0.11

---

### STEP-P0.11 — Chốt D1–D6 + cập nhật Gate

- [x] **Status:** done  

- **Làm gì:** Hỏi user hoặc áp default §1.2; tick Locked; cập nhật `UI-UX-Pre-Implementation-Gate.md` (DEPTH sau P0.1–P0.10).  
- **Verify:** D1–D6 đều `[x]` Locked.  
- **Next:** STEP-P0.12

---

### STEP-P0.12 — Gate P0 exit + cập nhật Dashboard

- [x] **Status:** done  

- **Làm gì:**  
  1. Đổi INDEX badge → **`SPEC DEPTH READY FOR P1`** (chỉ khi P0.1–P0.11 done).  
  2. Cập nhật §1 Dashboard P0 = `done`.  
  3. Regenerate note: `route_coverage` + `navigation_edge` vẫn PASS.  
- **Cấm vào P1 nếu:** bất kỳ STEP P0 unchecked.  
- **Next:** STEP-P1.1

---

## 4. PHASE P1 — Home + Profile (code)

**Spec chính:** [`17-HOME-PROFILE-MENU-WIREFRAME.md`](./17-HOME-PROFILE-MENU-WIREFRAME.md) + delta checklist + D1–D6.

### STEP-P1.1 — Home product data / nhóm sản phẩm

- [x] **Status:** done  
- **Files (≤8):** `home_mock_data.dart`, widgets products/quick-actions liên quan, tests home nếu có. Tránh rewrite cả `home_page.dart` trừ khi bắt buộc.  
- **Must-do:**
  1. 4 compact quick actions + sheet “Xem thêm”
  2. Groups: Giao dịch / Pro / Sinh lời / Khám phá
  3. Discovery tách Predictions + Arena
  4. Gỡ Support + Referral khỏi Home quick actions
  5. i18n vi-VN đủ dấu
- **Verify:**
  ```bash
  cd flutter_app
  flutter analyze
  flutter test test/features/home --reporter=compact
  ```
- **Acceptance:** Delta checklist Home items (trừ News/header) = `[x]`  
- **Next:** STEP-P1.2

---

### STEP-P1.2 — Home header News + D3/D4 layout

- [x] **Status:** done  
- **Files:** `home_header.dart`, sections ticker/recent nếu đụng D3/D4, tests.  
- **Must-do:** News EP-30; áp D3/D4 (giữ/bỏ theo lock).  
- **Verify:** analyze + focused home tests; visual spot @360 nếu có test sẵn.  
- **Next:** STEP-P1.3

---

### STEP-P1.3 — Profile section model

- [x] **Status:** done  
- **Files:** `profile_home_menu_actions.dart`, `mock_profile_repository_core_fixtures.dart`, `profile_page_test.dart`, identity fixture test.  
- **Must-do:** Sections: Tài khoản · Bảo mật · Portfolio nâng cao · Giới thiệu · Hỗ trợ · Pháp lý (scaffold); KYC theo D2; Referral + Support vào Profile.  
- **Done:** 6 sections + KYC banner + legal scaffold; Support/Referral off product hub → menu sections; analyze PASS; profile_page + identity tests PASS.  
- **Next:** STEP-P1.4 (accordion GOM) — continuum đang làm P2.1–P2.4 theo yêu cầu user

---

### STEP-P1.4 — Profile Pháp lý accordion (39 GOM)

- [x] **Status:** done  
- **Files:** `profile_legal_catalog.dart`, `profile_home_legal_accordion.dart`, entities, tests.  
- **Done:** Search + 5 nhóm (Copy 29 / Bot 6 / P2P 2 / Arena 1 / Launchpad 1); `context.push` routes; RG-08 closed.  
- **Verify:** catalog + profile_page accordion tests PASS.  
- **Next:** STEP-P1.5

---

### STEP-P1.5 — Home/Profile wiring + IA delta sign-off

- [x] **Status:** done  
- **Done:** Grep empty stubs home+profile = 0; `Home-Profile-IA-Delta-Checklist.md` 100% `[x]`.  
- **Next:** STEP-P1.6

---

### STEP-P1.6 — Checkpoint P1

- [x] **Status:** done  
- **Verify block:**
  ```bash
  cd flutter_app
  dart format --output=none --set-exit-if-changed .
  dart run tool/route_coverage_audit.dart --check
  dart run tool/navigation_edge_audit.dart --check
  flutter analyze
  flutter test test/features/home test/features/profile --reporter=compact
  ```
- **Done:** route_coverage + navigation_edge + analyze PASS; `test/features/home` + `test/features/profile` **161** PASS; fixed `mock_profile_repository_test` sections `3→6`. (`dart format .` hit Windows `build/` PathNotFound noise — formatted touched test OK.)  
- **Dashboard:** P1 = `done` (6/6)  
- **Next:** STEP-P2.6 (P2.1–P2.5 already done)

---

## 5. PHASE P2 — Markets + Trade + Wallet

### STEP-P2.1 — Markets: inbound heatmap + watchlist

- [x] **Status:** done — chips «Bản đồ nhiệt» + «Theo dõi»; RG-01/02 closed.

### STEP-P2.2 — Markets: tool strip vs HUB reconcile

- [x] **Status:** done — HUB strip + overflow «Thêm» (ẨN); header bỏ «Ngành»; Discover footer giữ shortcut.

### STEP-P2.3 — Checkpoint Markets

- [x] **Status:** done — route_coverage + nav_edge + analyze PASS; `test/features/markets` 182 PASS.

### STEP-P2.4 — Trade: header Orders + Positions (D5)

- [x] **Status:** done — Spot `headerActions` Lệnh→EP-26 / Vị thế→EP-27; RG-03/04 closed; terminal không đổi tab hub.

### STEP-P2.5 — Trade: product switcher clarity + risk badges

- [x] **Status:** done  
- **Files:** `trade_product_navigation.dart`, `vit_trade_product_tabs.dart`, `trade_product_navigation_test.dart`, `trade_page_test.dart`, wireframe `20` §3.  
- **Must-do:** Spot/Futures/Margin/Convert/Bot labels vi-VN; badge rủi ro Margin/Bot.  
- **Done:** Labels `Giao ngay` / `Phái sinh` / `Ký quỹ` / `Chuyển đổi` / `Bot`; `VitStatusPill` **Rủi ro cao** trên Margin+Bot; wireframe §3 synced.  
- **Verify:** `flutter analyze` (touched) PASS; `flutter test` trade_product_navigation + trade_page + trade_module_layout → 17 PASS.

### STEP-P2.6 — Checkpoint Trade

- [x] **Status:** done — `trade_page` golden refreshed (P2.4/P2.5 chrome); analyze PASS; `test/features/trade` **100** PASS; RG-03/04 closed.  
- **Next:** STEP-P2.7

### STEP-P2.7 — Wallet: promote tools (D6) + history

- [x] **Status:** done — `_walletTools` = Lịch sử / Sổ địa chỉ / Sức khỏe ví; overflow «Thêm» = buy/transfer + ops ẨN; hero ⋯ removed; RG-05/06/07 closed.  
- **Files:** fixtures, `wallet_page.dart`, `WalletToolGrid`, balance/allocation sections, `wallet_page_test.dart`, golden.  
- **Next:** STEP-P2.8

### STEP-P2.8 — Wallet: deposit/withdraw preview still intact

- [x] **Status:** done — deposit/withdraw/address-add suites PASS (preview sheet + notice intact); no empty stubs found in wallet presentation.  
- **Next:** STEP-P2.9

### STEP-P2.9 — Checkpoint P2

- [x] **Status:** done  
- **Done:** route_coverage + navigation_edge + analyze PASS; `test/features/markets` + `trade` + `wallet` **410** PASS.  
- **Dashboard:** P2 = `done` (9/9)  
- **Next:** STEP-P3.1

---

## 6. PHASE P3 — Earn / Savings + P2P

### STEP-P3.1 — Earn hub tile model (không stack rỗng)

- [x] **Status:** done — Công cụ staking 8 HUB tiles; CTA Bảng điều khiển + Tiết kiệm; vi-VN accents.

### STEP-P3.2 — Earn legal sheet (31 GOM)

- [x] **Status:** done — `EarnLegalCatalog` 5 cụm; sheet «Tài liệu & rủi ro»; RG-09 closed.

### STEP-P3.3 — Savings tools density

- [x] **Status:** done — VitActionTileGrid visible + overflow «Thêm»; bỏ stacked insight cards.

### STEP-P3.4 — Checkpoint Earn

- [x] **Status:** done — analyze PASS; `test/features/earn` **484** PASS (golden refreshed).

### STEP-P3.5 — P2P marketplace clarity

- [x] **Status:** done — Express nhanh + Tạo tin + Đơn của tôi.

### STEP-P3.6 — P2P hub drawer (11 HUB tools)

- [x] **Status:** done — Header «Công cụ» → VitSheetPanel 11 HUB.

### STEP-P3.7 — P2P copy/safety

- [x] **Status:** done — Escrow/footer vi-VN; payment-method preview suites PASS.

### STEP-P3.8 — Checkpoint P3

- [x] **Status:** done — route_coverage + nav_edge + analyze PASS; earn **484** + p2p **437** PASS.  
- **Dashboard:** P3 = `done` (8/8)  
- **Next:** STEP-P4.1

---

## 7. PHASE P4 — Discovery family

### STEP-P4.1 — Predictions home boundary + empty states

- [x] **Status:** done — Header «Danh mục» + Công cụ dự đoán → portfolio canonical; loading/empty/error giữ.

### STEP-P4.2 — Arena points-only audit + UI

- [x] **Status:** done — «Của tôi»→`/arena/my`; Công cụ Arena sheet; copy «Chỉ điểm Arena»; product_copy PASS.

### STEP-P4.3 — Discovery dedup Home/Markets/Profile

- [x] **Status:** done — Home canonical; Markets footer shortcut label; Profile không browse Discovery.

### STEP-P4.4 — Launchpad + Topics + Rewards entry polish

- [x] **Status:** done — Home Khám phá vi-VN (`Token mới` / `Phần thưởng` / `Chủ đề`); risk badge Launchpad giữ.

### STEP-P4.5 — Canonical portfolio / MyArena routes

- [x] **Status:** done — `/profile/predictions`→`/markets/predictions/portfolio`; `/profile/arena`→`/arena/my`; `26` synced.

### STEP-P4.6 — Checkpoint P4

- [x] **Status:** done — route_coverage + nav_edge + analyze PASS; predictions/arena/discovery/rewards/launchpad focused + product_copy + home **75** PASS.  
- **Dashboard:** P4 = `done` (6/6)  
- **Next:** STEP-P5.1

---

## 8. PHASE P5 — Sparse density + states

### STEP-P5.1 — Regenerate density/body audits

- [x] **Status:** done — Regen density+body; tool expected count **415**; Sparse watchlist updated.  
  ```bash
  dart run tool/visual_density_risk_audit.dart --check
  dart run tool/body_component_consistency_audit.dart --check
  ```

### STEP-P5.2 — Fix EARN-LEGAL-DENSITY P0 batch

- [x] **Status:** done — Withdrawal/Tax/PoR/Insurance/API: `scrollEndPadding` + SharedSpacingTokens; gap aliases→`AppSpacing.xN`; Spacers removed. Safety/legal copy kept.

### STEP-P5.3 — Fix SAVINGS / ARENA / DCA / PRED P0

- [x] **Status:** done — WhatIf/Recommendations/Guide + Arena presets/smart-rules + Pred detail + DCA backtester; also closed emergent `TradingBotsPage` P0.

### STEP-P5.4 — State widgets trên list hubs thiếu empty/error

- [x] **Status:** done — Earn products / Savings products+positions / Arena templates+modes → `VitEmptyState`; see `State-Coverage-by-Archetype.md` § P5.4.

### STEP-P5.5 — Checkpoint P5

- [x] **Status:** done — Product P0 = **0**; signed DEV exception `EnterpriseStatesPage` only; density/body/route/nav + analyze PASS.  
- **Dashboard:** P5 = `done` (5/5)  
- **Next:** — (P6 complete; program closed)

---

## 9. PHASE P6 — Wiring + Visual QA

### STEP-P6.1 — Button wiring sweep trade+markets+wallet

- [x] **Status:** done — `broken=0`; 2 legitimate (pair share disabled; copy-card demo). Artifact: `run-artifacts/button-wiring-audit-trade-markets-wallet-2026-07-22.md`.

### STEP-P6.2 — Button wiring earn+p2p+discovery

- [x] **Status:** done — `broken=0`; 1 legitimate (launchpad ended-pool). Artifact: `run-artifacts/button-wiring-audit-earn-p2p-discovery-2026-07-22.md`.

### STEP-P6.3 — Expand Visual QA manifest — 5 bottom-nav GIỮ

- [x] **Status:** done — Home/Markets/Trade/Wallet/Profile `expectBottomNav: true` @360×800 (flows 1/43/44/33/41).

### STEP-P6.4 — Expand Visual QA — remaining GIỮ

- [x] **Status:** done — 33/33 GIỮ evidence in `Visual-QA-Route-Manifest.md`; flows 43–65; positions tile overflow fixed.

### STEP-P6.5 — Final program gate

- [x] **Status:** done — §2 DoD; INDEX → **`UI/UX REORG PROGRAM COMPLETE`**; Dashboard **51/51**; `flutter test` **3534** PASS.

```bash
cd flutter_app
dart format --output=none --set-exit-if-changed .
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
flutter analyze
flutter test --reporter=compact
```

---

## 10. Dependency graph (không phá thứ tự)

```text
P0.1 INDEX
  └─ P0.2 Shell 18
       ├─ P0.3 Markets 19
       ├─ P0.4 Trade 20
       ├─ P0.5 Wallet 21
       ├─ P0.6 Earn 22
       ├─ P0.7 P2P 23
       ├─ P0.8 Discovery+Auth 24/25
       └─ P0.9 Nav matrix 26  ◄── needs 19–25
            └─ P0.10 Ledgers
                 └─ P0.11 Lock D1–D6
                      └─ P0.12 Exit
                           └─ P1.1 … P1.6
                                └─ P2 … P6
```

P0.3–P0.8 có thể song song **chỉ docs**, mỗi worktree/chat một file — nhưng **P0.9 phải sau** khi 19–25 đủ sâu.

---

## 11. Risks & stop conditions

| Risk | Stop / mitigation |
|------|-------------------|
| AI sửa Flutter trong P0 | Stop; revert; chỉ docs |
| Batch >10 files | Split STEP |
| Đụng `home_page.dart` không cần thiết | Prefer data/sections; ghi lý do nếu đụng |
| Arena wallet language | Fail product-copy; fix trước merge |
| Bỏ preview withdraw | Fail financial safety; không merge |
| INDEX vẫn nói COMPLETE trong khi P0 chưa xong | P0.1 phải sửa badge |

---

## 12. Related files

| File | Role |
|------|------|
| [`17-HOME-PROFILE-MENU-WIREFRAME.md`](./17-HOME-PROFILE-MENU-WIREFRAME.md) | Spec P1 |
| [`99-ALL-ROUTES.md`](./99-ALL-ROUTES.md) | Route truth |
| [`UX-Evidence-Matrix.csv`](./UX-Evidence-Matrix.csv) | Per-route UX columns |
| [`UI-UX-Pre-Implementation-Gate.md`](./UI-UX-Pre-Implementation-Gate.md) | Gate summary |
| [`UI-UX-REORG-MASTER-PLAN.md`](./UI-UX-REORG-MASTER-PLAN.md) | Short outline (playbook này = chi tiết) |
| `docs/01_AI_RULES/Two-Phase-Codex-Workflow.md` | Plan→Execute |

---

## 13. First action for human

1. **Hiện tại (2026-07-22):** P0–P6 = `done` → **`UI/UX REORG PROGRAM COMPLETE`**.  
2. Mở PR `ia-ux-readiness-pack` → `main` (worktree còn diff lớn chưa commit hết).
3. D1–D6 đã khóa; RG-12 vẫn là tension đã ghi nhận (không block).  
4. Không mở lại Sparse/Visual QA trừ regression sau merge.
