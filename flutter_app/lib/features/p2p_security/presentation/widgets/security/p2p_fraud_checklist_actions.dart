part of '../../phone/pages/security/p2p_fraud_prevention_page.dart';

class _ChecklistCard extends StatelessWidget {
  const _ChecklistCard({
    required this.checklist,
    required this.activeCategory,
    required this.onCategoryChanged,
    required this.onToggle,
  });

  final List<P2PSafetyChecklistItemDraft> checklist;
  final String activeCategory;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final categories = ['before', 'during', 'after'];
    final activeItems = checklist
        .where((item) => item.category == activeCategory)
        .toList(growable: false);

    return VitCard(
      key: P2PFraudPreventionPage.checklistKey,
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pFraudCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.menu_book_outlined,
                color: AppModuleAccents.p2p,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Checklist an toàn',
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: _p2pFraudMajorGap),
          Row(
            children: [
              for (var index = 0; index < categories.length; index++) ...[
                Expanded(
                  child: _CategoryTab(
                    category: categories[index],
                    selected: activeCategory == categories[index],
                    items: checklist
                        .where((item) => item.category == categories[index])
                        .toList(growable: false),
                    onTap: () => onCategoryChanged(categories[index]),
                  ),
                ),
                if (index != categories.length - 1)
                  const SizedBox(width: _p2pFraudSectionGap),
              ],
            ],
          ),
          const SizedBox(height: _p2pFraudMajorGap),
          for (var index = 0; index < activeItems.length; index++) ...[
            _ChecklistItem(item: activeItems[index], onTap: onToggle),
            if (index != activeItems.length - 1)
              const Divider(
                color: AppColors.divider,
                height: _p2pFraudMajorGap,
              ),
          ],
        ],
      ),
    );
  }
}

class _CategoryTab extends StatelessWidget {
  const _CategoryTab({
    required this.category,
    required this.selected,
    required this.items,
    required this.onTap,
  });

  final String category;
  final bool selected;
  final List<P2PSafetyChecklistItemDraft> items;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final checked = items.where((item) => item.checked).length;

    return VitCard(
      key: P2PFraudPreventionPage.tabKey(category),
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      borderColor: selected ? AppModuleAccents.p2p : AppColors.cardBorder,
      background: ColoredBox(
        color: selected ? AppModuleAccents.p2p : AppColors.surface2,
      ),
      padding: P2PSpacingTokens.p2pFraudCategoryTabPadding,
      onTap: onTap,
      clip: true,
      child: Column(
        children: [
          Text(
            _categoryLabel(category),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: selected ? AppColors.onAccent : AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            '$checked/${items.length}',
            style: AppTextStyles.micro.copyWith(
              color: selected
                  ? AppColors.onAccent.withValues(alpha: .72)
                  : AppColors.text3,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  const _ChecklistItem({required this.item, required this.onTap});

  final P2PSafetyChecklistItemDraft item;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PFraudPreventionPage.checklistItemKey(item.id),
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      padding: P2PSpacingTokens.p2pFraudChecklistItemPadding,
      onTap: () => onTap(item.id),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox.square(
            dimension: P2PSpacingTokens.p2pFraudChecklistBox,
            child: Material(
              color: item.checked ? AppColors.buy : AppColors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadii.smRadius,
                side: BorderSide(
                  color: item.checked ? AppColors.buy : AppColors.borderSolid,
                ),
              ),
              child: item.checked
                  ? const Icon(
                      Icons.check_rounded,
                      color: AppColors.onAccent,
                      size: P2PSpacingTokens.p2pFraudChecklistCheckIcon,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: _p2pFraudMajorGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: AppTextStyles.caption.copyWith(
                    color: item.checked ? AppColors.buy : AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    decoration: item.checked
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    decorationColor: AppColors.buy,
                  ),
                ),
                Text(
                  item.description,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmergencyActions extends StatelessWidget {
  const _EmergencyActions({required this.snapshot});

  final P2PFraudPreventionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PFraudPreventionPage.emergencyKey,
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pFraudCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: AppColors.sell,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Bạn đang bị lừa đảo?',
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: _p2pFraudMajorGap),
          for (
            var index = 0;
            index < snapshot.emergencyActions.length;
            index++
          ) ...[
            _EmergencyButton(action: snapshot.emergencyActions[index]),
            if (index != snapshot.emergencyActions.length - 1)
              const SizedBox(height: _p2pFraudSectionGap),
          ],
        ],
      ),
    );
  }
}

class _EmergencyButton extends StatelessWidget {
  const _EmergencyButton({required this.action});

  final P2PFraudEmergencyActionDraft action;

  @override
  Widget build(BuildContext context) {
    final color = _actionColor(action.toneKey);

    return VitCard(
      key: P2PFraudPreventionPage.actionKey(action.id),
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.large,
      borderColor: color.withValues(alpha: .22),
      background: ColoredBox(color: color.withValues(alpha: .08)),
      padding: P2PSpacingTokens.p2pFraudInnerPadding,
      onTap: () {
        unawaited(HapticFeedback.selectionClick());
        context.go(action.route);
      },
      clip: true,
      child: Row(
        children: [
          Icon(
            _actionIcon(action.iconKey),
            color: color,
            size: P2PSpacingTokens.p2pFraudActionIcon,
          ),
          const SizedBox(width: _p2pFraudMajorGap),
          Expanded(
            child: Text(
              action.label,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: color,
            size: P2PSpacingTokens.p2pFraudActionIcon,
          ),
        ],
      ),
    );
  }
}
