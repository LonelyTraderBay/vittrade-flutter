/// Loại khai báo của một route trong route manifest.
enum RouteContractKind { page, redirectAlias }

/// Hợp đồng route ổn định giữa Phone, Tablet và Web.
///
/// Contract không chứa GoRouter, widget hoặc controller. Route implementation
/// của từng surface chỉ được dùng contract này để giữ path/name/screen ID
/// đồng nhất trong khi composition UI có thể khác nhau.
final class RouteContract {
  const RouteContract({
    required this.path,
    required this.feature,
    required this.kind,
    this.name,
    this.screenId,
    this.redirectTarget,
  });

  final String path;
  final String? name;
  final String? screenId;
  final String feature;
  final RouteContractKind kind;
  final String? redirectTarget;

  bool get isRedirectAlias => kind == RouteContractKind.redirectAlias;
}
