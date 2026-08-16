part of '../../phone/pages/hub/watchlist_page.dart';

class _WatchlistToolbar extends StatelessWidget {
  const _WatchlistToolbar({
    required this.controller,
    required this.count,
    required this.onChanged,
    required this.onClear,
    required this.onAddPair,
  });

  final TextEditingController controller;
  final int count;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final VoidCallback onAddPair;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: Column(
        children: [
          Padding(
            padding: VitDensity.compact.cardPadding,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _ToolbarSearchField(
                        key: WatchlistPage.searchKey,
                        controller: controller,
                        placeholder: 'Tìm kiếm cặp giao dịch...',
                        onChanged: onChanged,
                        onClear: onClear,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    VitIconButton(
                      key: WatchlistPage.addPairKey,
                      icon: Icons.add_rounded,
                      tooltip: 'Thêm cặp theo dõi',
                      onPressed: onAddPair,
                      variant: VitIconButtonVariant.primary,
                      size: VitIconButtonSize.md,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: AppColors.warn,
                      size: AppSpacing.iconSm,
                    ),
                    const SizedBox(width: AppSpacing.x1),
                    Text(
                      '$count cặp đang theo dõi',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            height: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
        ],
      ),
    );
  }
}

class _ToolbarSearchField extends StatelessWidget {
  const _ToolbarSearchField({
    super.key,
    required this.controller,
    required this.placeholder,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final String placeholder;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return VitSearchBar(
      controller: controller,
      placeholder: placeholder,
      variant: VitSearchBarVariant.compact,
      onChanged: onChanged,
      onClear: onClear,
    );
  }
}
