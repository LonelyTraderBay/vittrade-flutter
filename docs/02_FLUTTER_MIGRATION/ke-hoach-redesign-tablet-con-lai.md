# Kế hoạch redesign tablet các cụm còn lại — theo chuẩn v2 (post Arena + Predictions)

Updated: 2026-09-19 (census toàn bộ UI tablet sau khi Arena v2 25/25 và
Predictions v2 18/18 đóng sạch)

## 1. Vì sao phải lập kế hoạch này

Kế hoạch cha
[ke-hoach-nang-cap-ui-tablet-enterprise.md](./ke-hoach-nang-cap-ui-tablet-enterprise.md)
chốt "hoàn tất Đợt 0–9" ngày 2026-09-14, trong đó nhiều cụm được phán quyết
**"giữ nguyên"** dựa trên audit delta *theo tầng scaffold*. Sau đó chính
cụm bị phán verdict đó (Đợt 7 — Predictions + Arena) vẫn phải redesign toàn
bộ theo chuẩn cao hơn:

- Arena v2: 25/25 trang (089b8a51 → 14d0454, 5 đợt + sweep).
- Predictions v2: 18/18 màn, 8 vòng user-review đóng sạch.

Bài học: `tablet_composition_tier_audit` chỉ trả lời "*trang có scaffold
chuẩn không*", không trả lời "*composition có chất tablet không*" (2 cột
theo nghề màn, mật độ dùng hết bề ngang, KPI banner, chrome rootModule).
Vì vậy mọi phán verdict "giữ nguyên" của các đợt 4–8 cần rà lại bằng
census mới.

## 2. Census 2026-09-19 — số liệu

Nguồn: script dùng một lần `flutter_app/tmp/tmp_tablet_phoneport_census.dart`
+ `flutter_app/tmp/tmp_tablet_phoneport_classify.dart`, dữ liệu
`flutter_app/tmp/tablet_phoneport_census.tsv` (tmp đã ignore, giữ để tái chạy
đo tiến độ; không commit).

### 2.1 Phân bố scaffold 166 file tablet page library

| Tầng composition | SL file |
| --- | --- |
| 2 cột / workspace / master-detail (chuẩn v2) | 50 (25 DASH2COL + 22 WORKSPACE + 2 MASTER + 1 PANE) |
| Detail surface (wallet/trade/auth) | 27 (16 + 5 + 6) |
| **MỘT CỘT** | **73** (56 SECFRAME + 16 PAGELAYOUT + 1 PAGECONTENT) |
| Part file của cụm đã redesign | 16 |

73 file một cột đang render **262 class `*TabletPage`**.

### 2.2 Phân loại 262 trang một cột theo nghề màn

| Nghề màn | SL | Hướng xử lý |
| --- | --- | --- |
| Dashboard / monitor / hub | 43 | re-compose dashboard 2 cột |
| Bảng dữ liệu / danh sách↔chi tiết | 37 | master-detail hoặc bảng đầy chiều rộng |
| Cài đặt / cấu hình | 14 | settings master-detail |
| Form / wizard | 20 | sticky footer CTA |
| Tài liệu / giải thích / chính sách | 25 | **giữ 1 cột** (linear đúng chuẩn) |
| Receipt / detail / confirm / chat | 18 | **giữ 1 cột** |
| OTHER (triage ở mockup gate) | 105 | dự kiến ~40 re-compose, còn lại giữ |

### 2.3 Bằng chứng phone-port điển hình (đọc code trực tiếp)

- `NewsTabletPage` (SC-047): doc comment tự nhận *"resolve snapshot theo
  filter **như trang phone**"* — một cột duy nhất, tương tác
  expand-in-place của phone thay vì master-detail danh sách↔bài. Archetype
  map của kế hoạch cha đặt news hub vào **Monitor dashboard**.
- `RewardsTabletPage` (SC-319): thẻ tổng quan + check-in + lọc + danh sách
  xếp chồng một cột — cùng họ phone-port, cũng được map vào Monitor
  dashboard.
- Staking (9 file, 44 trang): hub/dashboard/analytics/history là chồng
  `_stkSection` card label-value một cột — kế hoạch cha map vào **Analysis
  master-detail** nhưng audit delta 2026-09-14 chốt "giữ nguyên".

## 3. Phạm vi LOẠI KHỎI redesign — một cột là ĐÚNG chuẩn

Theo quyết định đã chốt 2026-09-13 (màn linear giữ một cột) + flagship:

- 5 root tab flagship (home / wallet / markets / trade / profile).
- `advanced_chart` terminal full-height (OHLCV + CTA ghim — đúng nghề).
- `live_market_data_analytics` (chốt giữ ở Đợt 3 kế hoạch cha).
- Auth ×6 (`AuthTabletSurface`), `WalletTabletDetailSurface` ×16,
  `TradeTabletDetailSurface` ×5.
- Receipt / OTP / guide / FAQ / terms / disclosure / policy thuần đọc.
- `p2p_chat` (cap bong bóng chat 640 hợp lệ — C1), `express_confirm`,
  order receipt.

## 4. Phạm vi đích theo cụm

Tổng re-compose dự kiến: **~140–150 trang / ~45 file** (112 trang chốt chắc
theo nghề + ~40 trang OTHER sau triage mockup gate).

| Đợt | Cụm | Trang 1 cột | Re-compose | Archetype đích |
| --- | --- | --- | --- | --- |
| R1 | **P2P phần một cột** (ngoài 9 dashboard 2 cột đã xong) | ~40 | ~28 | `my_orders`/`order_book`/`my_ads`/`ad_detail` → master-detail (idiom `WalletTabletHistoryShell` đã có từ Đ2b); settings/account/security/compliance/payment (~21) → settings master-detail; kyc ×6 + payment add/verify + merchant apply + blacklist add + dispute open (~12) → wizard sticky footer (slot `footer`) |
| R2 | Earn — staking | 44 | ~24 | hub (`StakingEarn`)/dashboard/analytics/history → dashboard 2 cột; validator/custody/governance/institutional → master-detail; policies/reports/guide/faq giữ linear. Cụm lớn nhất — 2–3 batch |
| R3 | Earn — savings | 22 | ~12 | hub/portfolio/analytics → dashboard; history/comparison/backtest → bảng; guide/faq giữ |
| R4 | Earn — dca + launchpad | 13 + 24 | ~9 + ~13 | dca overview → monitor dashboard (đúng map kế hoạch cha); launchpad home/portfolio/performance → dashboard; address_book/limit_orders/event_log/batch_claim → bảng |
| R5 | Trade copy + bots + compliance | 21 + 19 + 24 | ~35 | leaderboard/comparison/audit-log/attribution → bảng; portfolio/risk/performance dashboard → dashboard 2 cột; settings/security → master-detail; apply/assessment/calculator → wizard |
| R6 | Cross_module + news + rewards | 29 + 1 + 1 | ~17 | notifications-hub/unified-search/topic-hub/support → master-detail; admin/referral home → dashboard; **news → master-detail danh sách↔bài**; **rewards → monitor dashboard**. News có nợ i18n (`"Khong co tin phu hop"` không dấu) — trả ngay khi chạm file |

## 5. Thứ tự triển khai

Giữ nguyên thứ tự ưu tiên đã chốt với user 2026-09-13
(**Wallet → Trade → P2P → Earn → còn lại**); Wallet và Trade đã xong ⇒
**R1 = P2P** là đợt kế tiếp.

Phương án thay thế (không đề xuất): gộp news + rewards + dca (~17 trang
nhỏ) làm warm-up trước P2P để sớm chuẩn hoá idiom v2 — đổi lại lệch thứ tự
ưu tiên đã chốt; nếu user muốn thấy kết quả sớm thì chốt ở mockup gate.

Mỗi cụm mở đầu bằng **mockup ASCII trước/sau** chốt với user (gate redesign
bắt buộc); 1 cụm = 2–4 batch đủ nhỏ để tự review diff từng batch.

## 6. Quy trình mỗi batch (chuẩn Arena/Predictions v2)

1. Mockup ASCII trước/sau per cụm — user duyệt rồi mới code.
2. Re-compose theo archetype: scaffold từ registry (khóa T1), 0 pattern T2.
3. Đo mật độ bằng router-pump widget test `Rect` so trang chuẩn (Ví hub /
   Arena home) — không phán xét bằng cảm giác hay ảnh chụp.
4. Bộ khóa: 6 tablet lock audit + `page_rhythm --strict-full` + card_tile +
   content_width + `tablet_gap_role_audit` + i18n baseline (trả nợ chuỗi
   baseline ngay khi chạm file).
5. Regen artifact audit đúng thứ tự → `dart run tool/preflight_check.dart`
   PASS đủ 4 phase (không `--fast` khi chốt batch).
6. Commit tiếng Việt; user push.

## 7. Tiêu chí Done từng trang (giữ nguyên từ kế hoạch cha — còn hiệu lực)

- [ ] Archetype đúng nghề màn, scaffold từ registry (T1), 0 pattern T2.
- [ ] Threshold hai cột đo thực; QA matrix 768/800/834×1024/1112 + rotation xanh.
- [ ] Skeleton mirror dashboard, pull-to-refresh mọi cột, `VitEmptyState`/`VitErrorState`.
- [ ] Mask dữ liệu nhạy cảm; copy vi-VN có dấu; financial safety cho dòng tiền.
- [ ] Test riêng page + coverage không tụt dưới 92% (ratchet chỉ-tăng).
- [ ] Emulator smoke theo vision-verification workflow.
