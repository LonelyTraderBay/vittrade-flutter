# Bottom-Sheet Standard (Mandatory)

**Authority:** Derived from the existing `showVitBottomSheet` wrapper (`flutter_app/lib/shared/widgets/vit_bottom_sheet.dart`) and its guardrail test — not new policy. The tablet-surface section (2026-09-13) is new policy, approved via before/after mockup (user chọn cap 480dp kiểu pop-over).  
**Scope:** every screen on both surfaces (phone + tablet) — See [UI-Rule-Layer-Map.md](./UI-Rule-Layer-Map.md).  
**Enforcement:** `test/quality/bottom_sheet_guardrail_test.dart` (chặn API thô) + `dart run tool/tablet_sheet_audit.dart --check` (chrome tablet: ratchet baseline `test/quality/tablet_sheet_chrome_baseline.txt`, hiện 0 nợ) + behavior unit-test `test/shared/widgets/vit_bottom_sheet_test.dart` (pop-over cap + footer + grid)  
**Reference screen:** `flutter_app/lib/features/home/presentation/pages/home_page_part_01.dart` (`_showMoreProducts`) — phone; tablet: `flutter_app/lib/features/markets/presentation/widgets/tablet/market_list_tools.dart` (`_openOverflowSheet`)

## Rule

**Always call `showVitBottomSheet<T>(...)`, never Flutter's raw `showModalBottomSheet(...)` directly**, anywhere under `lib/app`, `lib/features`, or `lib/shared` — except inside `vit_bottom_sheet.dart` itself, which is the one file allowed to call the raw Flutter API because it *is* the wrapper.

`showVitBottomSheet` forwards straight to `showModalBottomSheet` but locks in three pieces of shared chrome so every sheet in the app looks and behaves the same:

- **Shape** — defaults `shape` to `RoundedRectangleBorder(borderRadius: AppRadii.sheetTopLargeRadius)` (large top-corner radius), so callers don't hand-roll their own `BorderRadius`.
- **Scrim** — defaults `barrierColor` to `AppColors.modalScrim` (60%-alpha black) and `backgroundColor` to `AppColors.surface`, keeping the dim/backdrop tone consistent across modules.
- **Navigator attachment** — defaults `useRootNavigator: true`. This is the guardrail's stated reason for the rule: sheets opened with the raw API can attach to the wrong (nested) navigator, while `showVitBottomSheet` always attaches to the root navigator.
- **Drag behavior** — `enableDrag: true` and `isDismissible: true` by default, so drag-to-dismiss and tap-outside-to-dismiss stay uniform. Note: this only enables the drag *gesture*; the wrapper does not render a visual drag-handle bar (`showDragHandle` is not passed), so no handle affordance is drawn today.

All other `showModalBottomSheet` parameters (`isScrollControlled`, `constraints`, `useSafeArea`, `backgroundColor`, `barrierColor`, `shape`) still pass through as optional overrides — the wrapper only supplies defaults, it does not remove caller control. Một ngoại lệ có chủ đích từ 2026-09-13: khi `TabletSpacingTokens.tabletSurfaceActive` bật và caller KHÔNG truyền `constraints`, wrapper tự áp `BoxConstraints(maxWidth: TabletSpacingTokens.sheetMaxWidth)` (480dp) — xem mục Tablet surface bên dưới.

## Tablet surface (2026-09-13 — pop-over cap 480dp)

Trên tablet, sheet **không tràn theo viewport**: wrapper tự kẹp bề rộng **480dp, căn giữa** (kiểu iPad pop-over) theo surface đã resolve ở bootstrap (`tabletSurfaceActive`), không theo width runtime — phone composition trong cửa sổ rộng vẫn full-width như cũ. Lưu ý: Flutter 3.x vốn mặc định cap sheet ở 640dp — 480dp là lựa chọn có chủ đích của chuẩn này, thay thế giá trị mặc định tình cờ của framework.

```
┌──────────────────────── 1280dp viewport ────────────────────────┐
│                    ░░░░░ scrim modalScrim ░░░░░                 │
│             ┌──────────────── 480dp ────────────────┐            │
│             │              ▬▬   (handle)            │          │
│             │  Tiêu đề (VitSheetPanel, đậm)          │          │
│             │  ┌───────────┐   ┌───────────┐         │          │
│             │  │ ô grid 1  │   │ ô grid 2  │         │          │
│             │  └───────────┘   └───────────┘         │          │
│             │  (nội dung cuộn khi vượt tier)         │          │
│             │  ────────────── hairline ─────────────  │          │
│             │  [ Hủy ]                  [ Xác nhận ]  │ ← footer │
│             └─────────────────────────────────────────┘ ghim     │
└──────────────────────────────────────────────────────────────────┘
```

### Quy tắc cứng

| Quy tắc | Giá trị chuẩn | Cơ chế |
| --- | --- | --- |
| Bề rộng tablet/web | cap **480dp** (`TabletSpacingTokens.sheetMaxWidth`), căn giữa, tự động | nằm trong `showVitBottomSheet` — caller không truyền `constraints` |
| Bề rộng phone | full-width theo viewport — không đổi | wrapper bỏ qua khi surface phone |
| Tier chiều cao | compact **0.40** · standard **0.60** (mặc định tablet) · tall **0.85** | `VitSheetPanel.maxHeightFactor` nhận `TabletSpacingTokens.sheetHeightFactor*`; form nhiều bước khai báo tall |
| Khung (handle + tiêu đề) | bắt buộc `VitSheetPanel`, hoặc API chuyên dụng `showVitNoticeSheet` / `showVitPreviewConfirmSheet` / `showVitTradeConfirmSheet` | `tool/tablet_sheet_audit.dart --check` |
| Footer CTA | slot `footer` của `VitSheetPanel`: Divider hairline phía trên, KHÔNG cuộn theo nội dung — dùng cho confirm tài chính | cùng idiom `MarketsPaneScaffold.footer` |
| Grid 2 cột | `VitSheetTwoColGrid` — bề rộng ô tính từ bề rộng THẬT của sheet (LayoutBuilder), **cấm** `MediaQuery.sizeOf` trong builder sheet ( viewport ≠ sheet sau khi cap) | widget shared |
| Khoảng cách | title→nội dung x4 · grid gap x3 · nội dung→footer x4 — toàn bộ `TabletSpacingTokens` | panel tự áp |

**Bẫy chiều cao Flutter:** `showModalBottomSheet` không có `isScrollControlled: true` tự kẹp sheet ở **9/16 chiều cao màn hình**, vô hiệu hóa mọi tier của panel — sheet dùng tier standard/tall hoặc có footer phải luôn truyền `isScrollControlled: true`.

### Dialog vs Sheet (tablet — 2026-09-13, user chốt "popup thành bottom sheet hết")

Trên tablet surface, **mọi popup đều là bottom sheet** — không có dialog căn giữa:

| Loại popup | API bắt buộc |
| --- | --- |
| Danh mục/công cụ tràn ("Xem thêm", "Thêm công cụ") | `showVitBottomSheet` + `VitSheetPanel` (+ `VitSheetTwoColGrid` nếu grid) |
| Confirm bảo mật/tài chính (xóa key, đăng xuất thiết bị, xóa địa chỉ…) | `showVitConfirmSheet` — song sinh bottom-sheet của `showVitConfirmDialog`, cùng tham số, CTA ghim footer |
| Confirm tài chính có bảng xem trước | `showVitPreviewConfirmSheet` |
| Thông báo cần bấm "Đã hiểu" | `showVitNoticeSheet` |

`showVitConfirmDialog` / `AlertDialog` / `showDialog` là modality của **phone** — dùng trong code tablet bị rule **S-dialog** của `tablet_sheet_audit` chặn (đã quét sạch 7 vị trí dialog cũ: home catalog, ghi chú watchlist, 4 confirm profile/address book). Phone giữ nguyên hành vi hiện tại.

### Vì sao 480 chứ không phải 560/640

640dp là mặc định vô tình của framework (không ai quyết định); 480dp kiểu iPad pop-over giữ sheet gọn trong tầm mắt, ô grid 2 cột ≈ 214dp đủ đọc thoải mái, và sheet không chiếm ngang toàn màn hình tablet landscape. User duyệt 480 trong phiên chốt chuẩn 2026-09-13.

## Parameters (from the wrapper signature)

| Parameter | Wrapper default | Caller override |
| --- | --- | --- |
| `isScrollControlled` | `false` | Pass `true` for tall/scrollable sheet content (forms, long lists) |
| `useRootNavigator` | `true` | Rarely overridden — flipping it re-introduces the nested-navigator risk the rule exists to avoid |
| `backgroundColor` | `null` → resolves to `AppColors.surface` | Any `Color` |
| `barrierColor` | `null` → resolves to `AppColors.modalScrim` | Any `Color` |
| `shape` | `null` → resolves to `RoundedRectangleBorder(borderRadius: AppRadii.sheetTopLargeRadius)` | Any `ShapeBorder` |
| `constraints` | `null` (no wrapper default) | `BoxConstraints`, e.g. a max-height cap |
| `enableDrag` | `true` | `bool` |
| `isDismissible` | `true` | `bool` |
| `useSafeArea` | `false` | `bool` |

`context` and `builder` are required and have no default; `T` is the sheet's return type, same as raw `showModalBottomSheet<T>`.

## Wire pattern

```dart
showVitBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  backgroundColor: AppColors.bg,
  barrierColor: AppColors.modalScrim,
  builder: (sheetContext) {
    return HomeMoreProductsSheet(
      actions: actions,
      onNavigate: (path) {
        Navigator.of(sheetContext).pop();
        rootContext.push(path);
      },
      density: density,
    );
  },
)
```

Minimal usage — no overrides, inherits every default (shape, scrim, root navigator, drag/dismiss):

```dart
showVitBottomSheet<void>(
  context: context,
  builder: (sheetContext) => const SomeSheetContent(),
)
```

`await`ing the call returns whatever the sheet passes to `Navigator.of(sheetContext).pop(value)` — the same await/return contract as raw `showModalBottomSheet<T>`, since the wrapper forwards its generic `T` straight through.

## Anti-pattern

| Anti-pattern | Why |
| --- | --- |
| `showModalBottomSheet(context: context, builder: ...)` in a feature/page file | Bypasses root-navigator attachment, shape, and scrim defaults; fails the guardrail |
| Re-declaring `RoundedRectangleBorder(borderRadius: ...)` / custom scrim color per call site | Duplicates what `showVitBottomSheet` already defaults; drifts from `sheetTopLargeRadius` / `modalScrim` |

## Exception

The guardrail scans `lib/app`, `lib/features`, `lib/shared` recursively for the literal string `showModalBottomSheet` and fails on any match, with exactly one path allowlisted: `lib/shared/widgets/vit_bottom_sheet.dart` (the wrapper's own implementation). There is no code-comment opt-out (no `// bottom-sheet: allow-*` marker) — the only way to keep a raw call is to be inside that one file.

The check is a per-line substring match (`lines[index].contains('showModalBottomSheet')`) after normalizing path separators to `/` for the allowlist comparison — it is not an AST or import-resolution check. In practice that means: it would also flag the identifier inside a comment or string literal, and it only recognizes the exact text `showModalBottomSheet` — other modal-style APIs (`showGeneralDialog`, `showCupertinoModalPopup`, etc.) are not covered by this guardrail today.

## Where it's used

`showVitBottomSheet` call sites currently span eight feature modules — `arena`, `earn`, `home`, `news`, `predictions`, `referral`, `trade`, `wallet` — plus the shared layer, so this is an app-wide primitive rather than a single-module convention. At the time of writing, the guardrail's `showModalBottomSheet` scan finds the identifier in exactly one file across `lib/app`, `lib/features`, `lib/shared`: the wrapper itself.

## Verify

```bash
cd flutter_app
flutter test test/quality/bottom_sheet_guardrail_test.dart --reporter=compact
dart run tool/tablet_sheet_audit.dart --check
flutter test test/shared/widgets/vit_bottom_sheet_test.dart --reporter=compact
```

## Migration pointers

Audit tool của domain này là `tool/tablet_sheet_audit.dart` (thêm 2026-09-13): scan library tablet (main + part files, path chứa `/tablet/` hoặc tên `vit_tablet*`), bắt 2 loại vi phạm — `S-no-panel` (library mở `showVitBottomSheet` mà không có `VitSheetPanel` trực tiếp / qua part / qua widget sheet panel-backed) và `S-chrome-leak` (dùng trực tiếp `VitSheetHandle`/`VitSheetSurface` ngoài `shared/widgets`). Baseline ratchet tại `test/quality/tablet_sheet_chrome_baseline.txt` — hiện **0 nợ** (4 sheet tự chế đã convert trong cùng commit; vai trò của baseline là chặn nợ MỚI).

## Related

- [Flutter-Design-System-Reference.md](../Flutter-Design-System-Reference.md)
- [Flutter-Module-Identity-Standard.md](./Flutter-Module-Identity-Standard.md)
- [Card-Tile-Standard.md](./Card-Tile-Standard.md)
- [Segment-Pill-Standard.md](./Segment-Pill-Standard.md)
