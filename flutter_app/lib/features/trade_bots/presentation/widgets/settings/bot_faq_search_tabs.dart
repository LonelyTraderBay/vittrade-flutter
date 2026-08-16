part of '../../phone/pages/settings/bot_faq_page.dart';

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitSearchBar(
      controller: controller,
      fieldKey: BotFaqPage.searchKey,
      placeholder: 'Tìm câu hỏi...',
      variant: VitSearchBarVariant.compact,
      onChanged: onChanged,
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs({
    required this.categories,
    required this.activeId,
    required this.onChanged,
  });

  final List<TradeBotFaqCategory> categories;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      tabs: [
        for (final category in categories)
          VitTabItem(
            key: category.id,
            label: category.label,
            widgetKey: BotFaqPage.tabKey(category.id),
          ),
      ],
      activeKey: activeId,
      onChanged: onChanged,
      variant: VitTabBarVariant.pill,
    );
  }
}
