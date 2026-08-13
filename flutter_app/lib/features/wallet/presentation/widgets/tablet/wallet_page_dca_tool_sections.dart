part of 'wallet_page_sections.dart';

const _walletToolGridCrossAxisCount = 2;
const double _walletToolGridAspectRatio = 2.25;
const double _walletToolGridGap = AppSpacing.x2;
const double _walletDcaIcon = AppSpacing.iconLg;
const double _walletDcaStatIcon = AppSpacing.iconMd;
const double _walletDcaGap = AppSpacing.x2;

class WalletDcaCard extends StatelessWidget {
  const WalletDcaCard({super.key, required this.dca});

  final WalletDcaSnapshot dca;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.standard,
      radius: VitCardRadius.standard,
      padding: VitDensity.compact.cardPadding,
      borderColor: _walletPurple.withValues(alpha: .28),
      child: Column(
        children: [
          Row(
            children: [
              const _IconCircle(
                icon: Icons.sync_alt_rounded,
                color: _walletPurple,
                size: _walletDcaIcon,
              ),
              const SizedBox(width: _walletDcaGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            dca.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x1),
                        VitMetricDeltaPill(
                          label: dca.returnLabel,
                          tone: VitMetricDeltaTone.positive,
                          icon: Icons.trending_up_rounded,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Text(
                      dca.subtitle,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
              const _IconCircle(
                icon: Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: _walletDcaIcon,
                muted: true,
              ),
            ],
          ),
          const SizedBox(height: _walletDcaGap),
          Row(
            children: [
              Expanded(
                child: _DcaStatCard(
                  icon: Icons.sync_alt_rounded,
                  iconColor: _walletPurple,
                  label: 'Kế hoạch đang chạy',
                  value: dca.activePlans.toString(),
                ),
              ),
              const SizedBox(width: _walletDcaGap),
              Expanded(
                child: _DcaStatCard(
                  icon: Icons.trending_up_rounded,
                  iconColor: _walletPrimary,
                  label: 'Đã đầu tư',
                  value: _formatVnd(dca.invested),
                ),
              ),
            ],
          ),
          const SizedBox(height: _walletDcaGap),
          Row(
            children: [
              const _IconCircle(
                icon: Icons.schedule_rounded,
                color: _walletAmber,
                size: _walletDcaStatIcon,
              ),
              const SizedBox(width: _walletDcaGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Giao dịch tiếp theo',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      dca.nextTrade,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DcaStatCard extends StatelessWidget {
  const _DcaStatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: VitDensity.tool.cardPadding,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      borderColor: iconColor.withValues(alpha: .18),
      child: Row(
        children: [
          _IconCircle(icon: icon, color: iconColor, size: _walletDcaStatIcon),
          const SizedBox(width: _walletDcaGap),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.numericMicro.copyWith(
                    color: AppColors.text3,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.amountSm.copyWith(
                    color: AppColors.text1,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconCircle extends StatelessWidget {
  const _IconCircle({
    required this.icon,
    required this.color,
    required this.size,
    this.muted = false,
  });

  final IconData icon;
  final Color color;
  final double size;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: ColoredBox(
          color: muted
              ? AppColors.dynamicIslandBg.withValues(alpha: .16)
              : color.withValues(alpha: .12),
          child: Center(
            child: Icon(icon, color: color, size: size * .56),
          ),
        ),
      ),
    );
  }
}

class WalletToolGrid extends StatelessWidget {
  const WalletToolGrid({
    super.key,
    required this.tools,
    required this.onNavigate,
    this.onShowMore,
  });

  final List<WalletTool> tools;
  final ValueChanged<String> onNavigate;
  final VoidCallback? onShowMore;

  @override
  Widget build(BuildContext context) {
    if (tools.isEmpty && onShowMore == null) {
      return const VitEmptyState(
        title: 'Kh\u00F4ng c\u00F3 c\u00F4ng c\u1EE5 v\u00ED',
        icon: Icons.grid_view_rounded,
      );
    }

    final showMore = onShowMore != null;
    final itemCount = tools.length + (showMore ? 1 : 0);

    return VitActionTileGrid(
      density: VitDensity.compact,
      crossAxisCount: _walletToolGridCrossAxisCount,
      crossAxisSpacing: _walletToolGridGap,
      mainAxisSpacing: _walletToolGridGap,
      childAspectRatio: _walletToolGridAspectRatio,
      itemCount: itemCount,
      itemBuilder: (context, index, density) {
        if (showMore && index == tools.length) {
          return VitServiceTile(
            key: const Key('sc135_wallet_more_actions'),
            density: density,
            icon: Icons.more_horiz_rounded,
            label: 'Th\u00EAm',
            accentColor: AppColors.text3,
            onTap: () => onShowMore?.call(),
          );
        }
        final tool = tools[index];
        return VitServiceTile(
          key: Key('sc135_wallet_action_${tool.id}'),
          density: density,
          icon: _toolIcon(tool.iconKey),
          label: tool.label,
          accentColor: Color(tool.colorHex),
          onTap: () => onNavigate(tool.route),
        );
      },
    );
  }
}
