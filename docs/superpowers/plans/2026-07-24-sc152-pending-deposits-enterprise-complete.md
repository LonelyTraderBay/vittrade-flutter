# SC-152 Nạp tiền đang chờ — Hoàn thiện Enterprise UI

> **For Codex workers:** Đọc `.codex/skills/incremental-implementation/SKILL.md` và làm task-by-task. Steps dùng checkbox (`- [ ]`). Mỗi **batch = một phiên Execute Codex mới** (Two-Phase Codex Workflow).

**Goal:** Đưa `/wallet/pending-deposits` (SC-152) từ trạng thái “P0 Vit*/spacing đã merge (#61)” lên mức enterprise-complete: honesty refresh, states/CTA, mật độ card, hygiene token/test — không redesign.

**Architecture:** Giữ `FutureProvider` read-model (`walletPendingDepositsProvider`). Không poll 5s (YAGNI mock-UI). Refresh = `ref.refresh(...).future` + `RefreshIndicator` + `showVitNoticeSheet` sau khi data về. Offline = nhận diện lỗi mạng trên `AsyncValue` + `VitOfflineBanner`. Failed → `/support` qua `ProductSupportContext` (flow `withdrawal` + issueLabel nạp). Density = thu gọn `VitInfoRow` mặc định, bỏ trùng.

**Tech Stack:** Flutter, Riverpod `FutureProvider`, GoRouter, Vit* shared widgets, `showVitNoticeSheet`, `maskAddress`.

**Audit nguồn:** canvas IDE `sc152-pending-deposits-enterprise-ui-audit` (local design canvas — không commit; không dùng absolute path máy).

## Global Constraints

- Copy user-facing: **tiếng Việt có dấu**, không thêm chuỗi Anh mới (I18N-1).
- Notice success/error/must-ack: **`showVitNoticeSheet`** — không SnackBar.
- Filter: giữ **`VitFilterChip` S4**; icon: **`VitAccentIconBox`**; trust/footer: **`VitInfoCallout`**.
- Sensitive: tiếp tục **`maskAddress`** cho `fromAddress` / `txHash`.
- Không commit trực tiếp `main`; branch feature → PR squash merge khi CI xanh.
- Mỗi batch ≤ ~5–10 file; verify trước khi báo complete; minimal-diff self-check.
- **Out of scope:** poll Timer 5s, thêm `ContextualSupportFlow.deposit`, đổi router path, redesign layout toàn wallet, BE thật.

---

## File map (toàn chương trình)

| File | Vai trò |
| --- | --- |
| `flutter_app/lib/features/wallet/presentation/pages/transfer/pending_deposits_page.dart` | Shell, AsyncValue branches, `_refreshDeposits`, filter state, copy timeout |
| `.../widgets/transfer/pending_deposits_page_sections.dart` | Banner copy, filters, deposit card, progress |
| `.../widgets/transfer/pending_deposits_page_common.dart` | Details collapse, empty/failed CTA, status notices |
| `flutter_app/test/features/wallet/pending_deposits_page_test.dart` | SC-152 focused tests |
| `flutter_app/lib/app/theme/spacing/wallet_spacing_tokens.dart` | Chỉ B4: dọn token pending legacy không còn reference |
| `docs/02_FLUTTER_MIGRATION/audits/*` | Chỉ khi CI báo stale — regenerate + commit artifact |

---

## Quyết định sản phẩm đã chốt (không mở lại giữa batch)

1. **Không** implement “tự động mỗi 5 giây”. Sửa copy trung thực.
2. Copy banner phụ khi còn pending: `Nhấn làm mới để cập nhật trạng thái xác nhận`.
3. Refresh await xong rồi mới notice `Đã làm mới`.
4. Empty khi filter không khớp: CTA `Xem tất cả` → reset filter `_DepositFilter.all`. Empty toàn cục (0 deposit): CTA `Nạp tiền` → `AppRoutePaths.walletDeposit`.
5. Failed: nút/link `Liên hệ hỗ trợ` → support route với context wallet.
6. Progress: **giữ LinearProgress + bỏ hàng dots** (gọn 1 lớp).
7. Details: mặc định **thu gọn**; expand “Chi tiết giao dịch”.

---

## Batch execution order

```text
B1 Honesty refresh  →  B2 States & CTAs  →  B3 Density & copy UX  →  B4 Token/test hygiene
     (chat mới)            (chat mới)            (chat mới)               (chat mới)
```

Sau mỗi batch: `flutter analyze` (file đụng) + `flutter test test/features/wallet/pending_deposits_page_test.dart` + domain guardrail nếu đụng filter/icon. PR tùy chọn từng batch hoặc gộp cuối — ưu tiên **1 PR / batch** nếu >1 ngày làm.

---

### Task 1 (Batch B1): Honesty refresh — copy + await + RefreshIndicator

**Files:**
- Modify: `flutter_app/lib/features/wallet/presentation/widgets/transfer/pending_deposits_page_sections.dart` (`_SummaryBanner`)
- Modify: `flutter_app/lib/features/wallet/presentation/pages/transfer/pending_deposits_page.dart` (`build` scroll, `_refreshDeposits`)
- Modify: `flutter_app/test/features/wallet/pending_deposits_page_test.dart`

**Interfaces:**
- Consumes: `walletPendingDepositsProvider`, `showVitNoticeSheet`, `VitInsetScrollView`
- Produces: `Future<void> _refreshDeposits()` awaitable; banner subtitle trung thực; pull-to-refresh cùng path


```text
impact({ target: "_refreshDeposits", direction: "upstream",
  repo: "vittrade-flutter" })
```

Ghi blast radius vào commit/PR body. WARN nếu HIGH/CRITICAL trước khi sửa.

- [ ] **Step 2: Viết test failing — banner không còn claim 5 giây**

Trong `pending_deposits_page_test.dart`, thêm vào test baseline (hoặc test riêng):

```dart
testWidgets('SC-152 banner không claim cập nhật tự động 5 giây', (tester) async {
  await pumpPendingDeposits(tester);
  expect(find.textContaining('5 giây'), findsNothing);
  expect(
    find.text('Nhấn làm mới để cập nhật trạng thái xác nhận'),
    findsOneWidget,
  );
});
```

- [ ] **Step 3: Chạy test — expect FAIL**

```powershell
cd flutter_app
flutter test test/features/wallet/pending_deposits_page_test.dart --name "5 giây" --reporter=compact
```

Expected: FAIL (vẫn thấy copy cũ hoặc thiếu copy mới).

- [ ] **Step 4: Sửa `_SummaryBanner` subtitle**

Trong `pending_deposits_page_sections.dart`, đổi nhánh `hasPending`:

```dart
hasPending
    ? 'Nhấn làm mới để cập nhật trạng thái xác nhận'
    : 'Không có giao dịch nào đang chờ',
```

- [ ] **Step 5: Viết test refresh await (sheet sau data)**

Giữ assertion sheet `Đã làm mới`. Thêm comment trong test: refresh phải `pumpAndSettle` sau tap (đã có). Không cần fake delay trừ khi mock repository có `loadDelay` — nếu cần, override provider:

```dart
// Chỉ thêm nếu flaky: pump với MockWalletRepository(loadDelay: Duration(milliseconds: 50))
```

Cập nhật test hiện tại `SC-152 refresh invalidates and shows notice sheet` — vẫn PASS sau Step 6.

- [ ] **Step 6: Implement `_refreshDeposits` await**

Trong `pending_deposits_page.dart`:

```dart
Future<void> _refreshDeposits() async {
  try {
    await ref.refresh(walletPendingDepositsProvider.future);
  } catch (_) {
    // AsyncValue.error sẽ render VitErrorState; vẫn báo người dùng.
  }
  if (!mounted) return;
  await showVitNoticeSheet(
    context: context,
    title: 'Đã làm mới',
    message:
        'Trạng thái nạp tiền đang chờ đã được cập nhật. Kiểm tra lại số xác nhận và mạng trước khi thao tác ví.',
  );
}
```

Đổi `onRefresh: _refreshDeposits` (kiểu `Future<void> Function()`). `_SummaryBanner.onRefresh` đổi thành `Future<void> Function()` và `onPressed: () { unawaited(onRefresh()); }` hoặc truyền thẳng nếu `VitIconButton` nhận `VoidCallback` — giữ `unawaited(onRefresh())` nếu API nút là sync.

- [ ] **Step 7: Bọc RefreshIndicator**

Trong `build`, thay `VitInsetScrollView(...)` bằng:

```dart
RefreshIndicator(
  color: AppColors.primary,
  backgroundColor: AppColors.surface2,
  onRefresh: _refreshDeposits,
  child: VitInsetScrollView(
    key: PendingDepositsPage.contentKey,
    bottomInset: bottomInset,
    physics: const AlwaysScrollableScrollPhysics(
      parent: ClampingScrollPhysics(),
    ),
    child: VitPageContent(
      // ... giữ nguyên children
    ),
  ),
)
```

`AlwaysScrollableScrollPhysics` để pull được khi content ngắn.

- [ ] **Step 8: Verify B1**

```powershell
cd flutter_app
dart format lib/features/wallet/presentation/pages/transfer/pending_deposits_page.dart lib/features/wallet/presentation/widgets/transfer/pending_deposits_page_sections.dart test/features/wallet/pending_deposits_page_test.dart
flutter analyze lib/features/wallet/presentation/pages/transfer/pending_deposits_page.dart lib/features/wallet/presentation/widgets/transfer/pending_deposits_page_sections.dart
flutter test test/features/wallet/pending_deposits_page_test.dart --reporter=compact
```

Expected: analyze clean; all SC-152 tests PASS.

- [ ] **Step 9: Commit B1** (khi user yêu cầu commit)

```text
fix(wallet): SC-152 B1 — honesty refresh (bỏ claim 5s, await, pull-to-refresh)
```

---

### Task 2 (Batch B2): Offline + empty/failed CTAs

**Files:**
- Modify: `pending_deposits_page.dart` (error/offline branch)
- Modify: `pending_deposits_page_common.dart` (`_EmptyDeposits`, failed notice + support)
- Modify: `pending_deposits_page_sections.dart` (wire `onSupport` / empty callbacks qua `_DepositCard` nếu cần)
- Modify: `pending_deposits_page_test.dart`

**Interfaces:**
- Consumes: `VitOfflineBanner`, `VitEmptyState.actionLabel/onAction`, `AppRoutePaths.support` / `ProductSupportContext`
- Produces: `_isLikelyOffline(Object error)`, `_openSupportForDeposit(WalletPendingDeposit)`, empty CTAs

- [ ] **Step 1: Helper offline detection**

Thêm private top-level hoặc method trong state:

```dart
bool _isLikelyOffline(Object error) {
  final text = error.toString().toLowerCase();
  return error is SocketException ||
      text.contains('socket') ||
      text.contains('network') ||
      text.contains('offline') ||
      text.contains('failed host lookup');
}
```

Import `dart:io` show `SocketException` (hoặc tránh `dart:io` trên web — ưu tiên string match only nếu page chạy web/QA):

```dart
bool _isLikelyOffline(Object error) {
  final text = error.toString().toLowerCase();
  return text.contains('socket') ||
      text.contains('network') ||
      text.contains('offline') ||
      text.contains('failed host lookup') ||
      text.contains('clientexception');
}
```

- [ ] **Step 2: Nhánh error UI**

Trong `snapshotAsync.when(error: ...)`:

```dart
error: (error, stackTrace) => [
  if (_isLikelyOffline(error))
    VitOfflineBanner(
      message: 'Mất kết nối mạng',
      detail: 'Không tải được nạp tiền đang chờ. Thử lại khi có mạng.',
    )
  else
    VitErrorState(
      title: 'Không tải được nạp tiền đang chờ',
      message: 'Vui lòng kiểm tra kết nối và thử lại.',
      actionLabel: 'Thử lại',
      onAction: () => ref.invalidate(walletPendingDepositsProvider),
    ),
  // Offline cũng cần CTA thử lại:
  if (_isLikelyOffline(error))
    VitErrorState(
      title: 'Đang offline',
      message: 'Danh sách nạp đang chờ chưa khả dụng.',
      actionLabel: 'Thử lại',
      onAction: () => ref.invalidate(walletPendingDepositsProvider),
    ),
],
```

**Thu gọn hơn (khuyến nghị implement):** một widget:

```dart
error: (error, _) => [
  if (_isLikelyOffline(error))
    const VitOfflineBanner(
      message: 'Mất kết nối mạng',
      detail: 'Không tải được nạp tiền đang chờ.',
    ),
  VitErrorState(
    title: _isLikelyOffline(error)
        ? 'Đang offline'
        : 'Không tải được nạp tiền đang chờ',
    message: 'Vui lòng kiểm tra kết nối và thử lại.',
    actionLabel: 'Thử lại',
    onAction: () => ref.invalidate(walletPendingDepositsProvider),
  ),
],
```

- [ ] **Step 3: `_EmptyDeposits` nhận callback**

```dart
class _EmptyDeposits extends StatelessWidget {
  const _EmptyDeposits({
    required this.hasAnyDeposits,
    required this.onShowAll,
    required this.onDeposit,
  });

  final bool hasAnyDeposits;
  final VoidCallback onShowAll;
  final VoidCallback onDeposit;

  @override
  Widget build(BuildContext context) {
    if (hasAnyDeposits) {
      return VitEmptyState(
        title: 'Không có giao dịch nạp nào',
        message: 'Bộ lọc hiện tại không có giao dịch cần theo dõi.',
        icon: Icons.inbox_outlined,
        actionLabel: 'Xem tất cả',
        onAction: onShowAll,
      );
    }
    return VitEmptyState(
      title: 'Chưa có nạp đang chờ',
      message: 'Khi bạn gửi tiền vào ví, giao dịch sẽ xuất hiện tại đây.',
      icon: Icons.inbox_outlined,
      actionLabel: 'Nạp tiền',
      onAction: onDeposit,
    );
  }
}
```

Wire từ page:

```dart
_EmptyDeposits(
  hasAnyDeposits: snapshot.deposits.isNotEmpty,
  onShowAll: () => setState(() => _filter = _DepositFilter.all),
  onDeposit: () => context.go(AppRoutePaths.walletDeposit),
),
```

- [ ] **Step 4: Failed → hỗ trợ**

Trong `_DepositCard` failed block, thay `_StatusNotice` thuần bằng callout + action. Pattern tối thiểu: thêm trailing/`VitCtaButton` text dưới notice:

```dart
if (deposit.status == 'failed') ...[
  const SizedBox(height: _pendingGap),
  const _StatusNotice(
    color: AppColors.sell,
    icon: Icons.warning_amber_rounded,
    text: 'Giao dịch thất bại — liên hệ hỗ trợ nếu đã gửi tiền',
  ),
  const SizedBox(height: _pendingTinyGap),
  Align(
    alignment: Alignment.centerLeft,
    child: VitCtaButton(
      label: 'Liên hệ hỗ trợ',
      variant: VitCtaVariant.secondary, // dùng variant thực tế trong widgets.dart
      onPressed: () => onSupport(deposit),
    ),
  ),
],
```

Truyền `onSupport` từ page:

```dart
void _openSupportForDeposit(WalletPendingDeposit deposit) {
  final ctx = ProductSupportContext.fromContract(
    ContextualSupportContracts.contracts.firstWhere(
      (c) => c.flow == ContextualSupportFlow.withdrawal,
    ),
    referenceId: deposit.id,
    sourceRoute: AppRoutePaths.walletPendingDeposits,
    issueLabel: 'Nạp ${deposit.asset} thất bại',
  );
  context.go(ctx.toSupportRoute(supportPath: AppRoutePaths.support));
}
```

Import `contextual_support_contract.dart`. **Kiểm tra** `VitCtaButton` API thực tế trước khi code — nếu không có secondary, dùng `TextButton`/`VitSectionLink` đúng Vit* hiện có (ưu tiên Vit*).

- [ ] **Step 5: Tests B2**

```dart
testWidgets('SC-152 empty filter có CTA Xem tất cả', (tester) async {
  await pumpPendingDeposits(tester);
  await tester.tap(find.byKey(PendingDepositsPage.filterKey('pending')));
  await tester.pumpAndSettle();
  // Force empty: tap filter không khớp — dùng done rồi mock? 
  // Đơn giản hơn: tap pending (2 items), không empty.
  // Thay: filter custom bằng cách chỉ assert empty widget khi 
  // pump với override provider deposits: [] 
});
```

Override provider (pattern VitTrade):

```dart
await tester.pumpWidget(
  ProviderScope(
    overrides: [
      walletPendingDepositsProvider.overrideWith(
        (ref) async => const WalletPendingDepositsSnapshot(
          deposits: [],
          endpoint: '/api/mobile/wallet/wallet-pending-deposits',
          actionDraft: 'POST /wallet/deposit-intent',
          supportedStates: [WalletScreenState.empty],
        ),
      ),
    ],
    child: VitTradeApp(
      routerConfig: createAppRouter(
        initialLocation: AppRoutePaths.walletPendingDeposits,
      ),
    ),
  ),
);
await tester.pumpAndSettle();
expect(find.text('Nạp tiền'), findsOneWidget);
```

Thêm test offline:

```dart
walletPendingDepositsProvider.overrideWith(
  (ref) async => throw Exception('SocketException: Failed host lookup'),
);
// expect VitOfflineBanner / 'Đang offline'
```

Thêm test failed support button tồn tại trên `pd004` (mock failed deposit — xác nhận id trong fixture).

- [ ] **Step 6: Verify B2**

```powershell
cd flutter_app
flutter analyze lib/features/wallet/presentation/pages/transfer/pending_deposits_page.dart lib/features/wallet/presentation/widgets/transfer/pending_deposits_page_common.dart lib/features/wallet/presentation/widgets/transfer/pending_deposits_page_sections.dart
flutter test test/features/wallet/pending_deposits_page_test.dart --reporter=compact
dart run tool/navigation_edge_audit.dart --check
```

Nếu navigation edge stale: `dart run tool/navigation_edge_audit.dart` rồi commit CSV.

- [ ] **Step 7: Commit B2**

```text
fix(wallet): SC-152 B2 — offline banner, empty/failed CTA + support
```

---

### Task 3 (Batch B3): Density card + copy UX + progress gọn

**Files:**
- Modify: `pending_deposits_page_sections.dart` (`_DepositCard`, `_ConfirmationProgress`)
- Modify: `pending_deposits_page_common.dart` (`_DepositDetails`)
- Modify: `pending_deposits_page.dart` (`_copyHash` timeout)
- Modify: `pending_deposits_page_test.dart`

**Interfaces:**
- Consumes: local `bool _detailsExpanded` per card **hoặc** `ExpansionTile`/`Vit`-compatible expand
- Produces: details mặc định thu gọn; copy reset sau 2s; progress không dots

- [ ] **Step 1: Bỏ dots trong `_ConfirmationProgress`**

Xóa vòng `for (var i = 0; i < dotCount; i++)` và `dotCount`. Giữ Semantics + label + LinearProgress + VitStatusPill tỷ lệ.

- [ ] **Step 2: Bỏ trùng fields trong details khi expand**

Trong `_DepositDetails`, **xóa** row `Thời điểm gửi` (đã có `deposit.createdAt` trên header card). Giữ: xác nhận, dự kiến nhận, mạng, từ địa chỉ, mã giao dịch.

- [ ] **Step 3: Collapse details**

Biến `_DepositCard` thành `StatefulWidget` với `_expanded = false`:

```dart
TextButton(
  onPressed: () => setState(() => _expanded = !_expanded),
  child: Text(_expanded ? 'Ẩn chi tiết' : 'Chi tiết giao dịch'),
),
if (_expanded) _DepositDetails(...),
```

Ưu tiên widget Vit* nếu có `VitExpandableSection` / tương đương — Grep trước:

```powershell
rg "VitExpandable|VitDisclosure|ExpansionTile" flutter_app/lib/shared -g "*.dart"
```

Dùng shared nếu có; không invent abstraction mới.

- [ ] **Step 4: Copy timeout**

Trong `_PendingDepositsPageState`:

```dart
Timer? _copiedReset;

Future<void> _copyHash(WalletPendingDeposit deposit) async {
  _copiedReset?.cancel();
  setState(() => _copiedId = deposit.id);
  await Clipboard.setData(ClipboardData(text: deposit.txHash));
  _copiedReset = Timer(const Duration(seconds: 2), () {
    if (!mounted) return;
    if (_copiedId == deposit.id) setState(() => _copiedId = null);
  });
}

@override
void dispose() {
  _copiedReset?.cancel();
  super.dispose();
}
```

Giữ `VitStatusPill` làm copy control (đã có) — không đổi sang widget khác trừ khi audit B3 còn dư thời gian.

- [ ] **Step 5: Tests**

- Progress: `find` không phụ thuộc số dots (test hiện tại không assert dots — OK).
- Copy: tap copy → `Đã chép` → `tester.pump(Duration(seconds: 2))` → lại `Sao chép`.
- Details: mặc định không thấy label `Mạng` cho đến khi tap `Chi tiết giao dịch`.

- [ ] **Step 6: Verify B3**

```powershell
cd flutter_app
flutter analyze lib/features/wallet/presentation/pages/transfer/pending_deposits_page.dart lib/features/wallet/presentation/widgets/transfer/pending_deposits_page_sections.dart lib/features/wallet/presentation/widgets/transfer/pending_deposits_page_common.dart
flutter test test/features/wallet/pending_deposits_page_test.dart --reporter=compact
```

- [ ] **Step 7: Commit B3**

```text
fix(wallet): SC-152 B3 — gọn progress/details + copy timeout
```

---

### Task 4 (Batch B4): Token dead + test hygiene + PR gate

**Files:**
- Modify: `flutter_app/lib/app/theme/spacing/wallet_spacing_tokens.dart` (chỉ xóa symbol **không còn reference**)
- Modify: `pending_deposits_page_test.dart` (bổ sung nếu còn gap)
- Có thể đụng: audit CSVs nếu CI stale

- [ ] **Step 1: Inventory token pending**

```powershell
cd flutter_app
rg "walletPending(SummaryIconBox|AssetIconBox|ChipHeight|CardPadding|CopyHeight)" lib test -g "*.dart"
```

Chỉ xóa constant **0 hit** ngoài định nghĩa. **Giữ** `walletPendingProgressHeight`, bottom insets nếu page còn dùng.

- [ ] **Step 2: Xóa dead constants** (ví dụ — chỉ khi rg sạch)

Các ứng viên từ audit: `walletPendingSummaryIconBox` (44), `walletPendingAssetIconBox` (40), `walletPendingChipHeight` (30), padding chip/card legacy nếu không reference.

- [ ] **Step 3: Test file line budget**

Nếu `pending_deposits_page_test.dart` > 400 dòng: tách `pending_deposits_page_states_test.dart` (offline/empty) — bắt buộc theo guardrail.

- [ ] **Step 4: Full focused gate trước PR**

```powershell
cd flutter_app
dart format --output=none --set-exit-if-changed lib/features/wallet/presentation/pages/transfer/pending_deposits_page.dart lib/features/wallet/presentation/widgets/transfer/pending_deposits_page_sections.dart lib/features/wallet/presentation/widgets/transfer/pending_deposits_page_common.dart test/features/wallet/
flutter analyze lib/features/wallet/presentation/pages/transfer/pending_deposits_page.dart lib/features/wallet/presentation/widgets/transfer/
flutter test test/features/wallet/pending_deposits_page_test.dart --reporter=compact
flutter test test/quality/accent_icon_box_guardrail_test.dart test/quality/segment_pill_guardrail_test.dart test/quality/notice_acknowledgement_guardrail_test.dart --reporter=compact
dart run tool/navigation_edge_audit.dart --check
dart run tool/segment_pill_audit.dart --check --strict-full
```


Expected: risk low; chỉ wallet pending deposits + tokens/tests.

- [ ] **Step 6: Commit B4 + PR Enterprise**

```text
chore(wallet): SC-152 B4 — dọn token pending legacy + siết test
```

PR body checklist theo `docs/02_FLUTTER_MIGRATION/checklists/Enterprise-PR-Review-Checklist.md` (scope, verify commands, không commit run-artifacts). Merge: **squash** khi CI xanh + Enterprise Flutter Gates pass.

---

## Definition of Done (toàn chương trình)

- [ ] Không còn copy “5 giây” / auto-update giả
- [ ] Refresh (icon + pull) await data rồi mới notice
- [ ] Offline nhận diện + CTA thử lại
- [ ] Empty có CTA đúng ngữ cảnh; failed có đường `/support`
- [ ] Card gọn: 1 progress, details collapse, không trùng createdAt
- [ ] Copy “Đã chép” tự reset ~2s
- [ ] Dead pending spacing tokens đã dọn (nếu an toàn)
- [ ] SC-152 tests + analyze xanh; navigation-edge/segment-pill artifacts current
- [ ] Đã merge `main` theo chuẩn Enterprise (squash)

---

## Rủi ro & mitigation

| Rủi ro | Mitigation |
| --- | --- |
| `RefreshIndicator` không kéo được content ngắn | `AlwaysScrollableScrollPhysics` |
| `dart:io` SocketException vỡ web | Chỉ string-match error |
| Support contract Anh trong ProductSupportContext | Chỉ dùng issueLabel vi-VN; không đổi contract core trong batch này |
| Test file >400 dòng | Tách file states |
| CI artifact stale | Regen tool tương ứng trước push |
| VitCtaButton API lệch | Grep `class VitCtaButton` trước implement B2 |

---

## Self-review (spec coverage)

| Finding audit | Task |
| --- | --- |
| H1 claim 5s | Task 1 |
| H2 refresh notice sớm | Task 1 |
| H3 offline | Task 2 |
| H4 empty/failed CTA | Task 2 |
| H5 pull-to-refresh | Task 1 |
| H6 density / trùng | Task 3 |
| H7 copy sticky | Task 3 |
| H8 progress đôi + token | Task 3 + 4 |
| H9 test gaps | Task 2–4 |

Không còn placeholder TBD trong các step trên.
