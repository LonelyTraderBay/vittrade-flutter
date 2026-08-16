part of '../../phone/pages/safety/copy_audit_log_page.dart';

class _AuditSearchField extends StatelessWidget {
  const _AuditSearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitSearchBar(
      controller: controller,
      fieldKey: CopyAuditLogPage.searchFieldKey,
      placeholder: 'Tìm kiếm event, pair, ID...',
      variant: VitSearchBarVariant.compact,
      onChanged: onChanged,
    );
  }
}
