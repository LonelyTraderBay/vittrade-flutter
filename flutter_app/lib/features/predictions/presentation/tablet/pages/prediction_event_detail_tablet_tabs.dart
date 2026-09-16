part of 'prediction_event_detail_tablet_page.dart';

// ---------------------------------------------------------------------------
// Tab Quy tắc / Bình luận / Nắm giữ lớn / Hoạt động.
// ---------------------------------------------------------------------------

class _Sc211DetailTabs extends StatelessWidget {
  const _Sc211DetailTabs({required this.activeTab, required this.onChanged});

  final _Sc211DetailTab activeTab;
  final ValueChanged<_Sc211DetailTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface2,
      borderRadius: AppRadii.cardRadius,
      child: Padding(
        padding: TabletSpacingTokens.cardPaddingCompact,
        child: VitTabBar(
          variant: VitTabBarVariant.segment,
          activeKey: switch (activeTab) {
            _Sc211DetailTab.rules => 'rules',
            _Sc211DetailTab.comments => 'comments',
            _Sc211DetailTab.holders => 'holders',
            _Sc211DetailTab.activity => 'activity',
          },
          onChanged: (key) => onChanged(_Sc211DetailTab.values.byName(key)),
          tabs: const [
            VitTabItem(
              key: 'rules',
              label: 'Quy tắc',
              widgetKey: PredictionEventDetailTabletPage.rulesTabKey,
            ),
            VitTabItem(
              key: 'comments',
              label: 'Bình luận',
              widgetKey: PredictionEventDetailTabletPage.commentsTabKey,
            ),
            VitTabItem(
              key: 'holders',
              label: 'Nắm giữ lớn',
              widgetKey: PredictionEventDetailTabletPage.holdersTabKey,
            ),
            VitTabItem(
              key: 'activity',
              label: 'Hoạt động',
              widgetKey: PredictionEventDetailTabletPage.activityTabKey,
            ),
          ],
        ),
      ),
    );
  }
}

class _Sc211TabCard extends StatelessWidget {
  const _Sc211TabCard({required this.snapshot, required this.activeTab});

  final PredictionEventDetailSnapshot snapshot;
  final _Sc211DetailTab activeTab;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: switch (activeTab) {
        _Sc211DetailTab.rules => _Sc211RulesContent(snapshot: snapshot),
        _Sc211DetailTab.comments => const _Sc211CommentsContent(),
        _Sc211DetailTab.holders => _Sc211HoldersContent(snapshot: snapshot),
        _Sc211DetailTab.activity => _Sc211ActivityContent(snapshot: snapshot),
      },
    );
  }
}

class _Sc211RulesContent extends StatelessWidget {
  const _Sc211RulesContent({required this.snapshot});

  final PredictionEventDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Sc211InfoBlock(
          icon: Icons.menu_book_rounded,
          title: 'Mô tả',
          text:
              'Thị trường này chốt "Yes" nếu bitcoin chạm mốc 150.000 USD '
              'trước ngày kết thúc. Ngược lại, thị trường chốt "No".',
        ),
        const SizedBox(height: TabletSpacingTokens.x4),
        const _Sc211InfoBox(
          icon: Icons.verified_user_outlined,
          title: 'Nguồn chốt kèo',
          text: 'CoinGecko & CoinMarketCap (trung bình)',
          color: AppColors.primary,
        ),
        const SizedBox(height: TabletSpacingTokens.x3),
        _Sc211InfoBox(
          icon: Icons.calendar_month_outlined,
          title: 'Ngày kết thúc',
          text: '${_sc211FormatDate(snapshot.event.endDate)} lúc 23:59 UTC',
          color: AppColors.warn,
        ),
        const SizedBox(height: TabletSpacingTokens.x4),
        Text(
          'Quy tắc thị trường',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: TabletSpacingTokens.x3),
        for (var index = 0; index < snapshot.rules.length; index += 1) ...[
          _Sc211RuleRow(index: index, text: snapshot.rules[index]),
          if (index != snapshot.rules.length - 1)
            const SizedBox(height: TabletSpacingTokens.x3),
        ],
      ],
    );
  }
}

class _Sc211RuleRow extends StatelessWidget {
  const _Sc211RuleRow({required this.index, required this.text});

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: TabletSpacingTokens.x5,
          child: Text(
            '${index + 1}.',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.micro.copyWith(color: AppColors.text2),
          ),
        ),
      ],
    );
  }
}

class _Sc211InfoBlock extends StatelessWidget {
  const _Sc211InfoBlock({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox.square(
              dimension: TabletSpacingTokens.iconSm,
              child: Icon(
                icon,
                color: AppColors.text2,
                size: TabletSpacingTokens.iconSm,
              ),
            ),
            const SizedBox(width: TabletSpacingTokens.x1),
            Text(
              title,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: TabletSpacingTokens.x3),
        Text(
          text,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
      ],
    );
  }
}

class _Sc211InfoBox extends StatelessWidget {
  const _Sc211InfoBox({
    required this.icon,
    required this.title,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox.square(
            dimension: TabletSpacingTokens.iconMd,
            child: Icon(icon, color: color, size: TabletSpacingTokens.iconSm),
          ),
          const SizedBox(width: TabletSpacingTokens.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: TabletSpacingTokens.x1),
                Text(text, style: AppTextStyles.caption.copyWith(color: color)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Sc211CommentsContent extends StatelessWidget {
  const _Sc211CommentsContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VitCard(
          borderColor: AppColors.warningBorder,
          background: const ColoredBox(color: AppColors.warn08),
          padding: TabletSpacingTokens.cardPaddingCompact,
          child: Row(
            children: [
              const SizedBox.square(
                dimension: TabletSpacingTokens.iconSm,
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.warn,
                  size: TabletSpacingTokens.iconSm,
                ),
              ),
              const SizedBox(width: TabletSpacingTokens.x3),
              Expanded(
                child: Text(
                  'Cẩn thận với liên kết ngoài. Không chia sẻ thông tin cá '
                  'nhân hay tài chính.',
                  style: AppTextStyles.micro.copyWith(color: AppColors.warn),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: TabletSpacingTokens.x3),
        const _Sc211CommentRow(
          author: 'MacroAlpha',
          side: 'Yes',
          text: 'Dòng vốn ETF và thanh khoản đang hỗ trợ thị trường này.',
          likes: 18,
        ),
        const _Sc211CommentRow(
          author: 'RiskDesk',
          side: 'No',
          text:
              'Nên theo dõi lãi suất vĩ mô và thanh khoản sàn trước khi vào tiền.',
          likes: 9,
        ),
        const SizedBox(height: TabletSpacingTokens.x3),
        SizedBox(
          height: TabletSpacingTokens.buttonCompact,
          child: VitCard(
            variant: VitCardVariant.inner,
            padding: TabletSpacingTokens.zeroInsets,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: TabletSpacingTokens.x3,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Thêm bình luận…',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ),
                  Text(
                    'Đăng',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Sc211CommentRow extends StatelessWidget {
  const _Sc211CommentRow({
    required this.author,
    required this.side,
    required this.text,
    required this.likes,
  });

  final String author;
  final String side;
  final String text;
  final int likes;

  @override
  Widget build(BuildContext context) {
    final color = side == 'Yes' ? AppColors.buy : AppColors.sell;
    return Padding(
      padding: TabletSpacingTokens.tableCellPaddingV,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: TabletSpacingTokens.iconMd,
            backgroundColor: AppColors.surface2,
            child: Text(
              author[0],
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const SizedBox(width: TabletSpacingTokens.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: TabletSpacingTokens.x2,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      author,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    _Sc211TinyBadge(
                      label: side,
                      color: color,
                      background: color.withValues(alpha: .12),
                    ),
                    Text(
                      '4 phút trước',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TabletSpacingTokens.x1),
                Text(
                  text,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: TabletSpacingTokens.x1),
                Row(
                  children: [
                    const SizedBox.square(
                      dimension: TabletSpacingTokens.iconSm,
                      child: Icon(
                        Icons.thumb_up_alt_outlined,
                        color: AppColors.text3,
                        size: TabletSpacingTokens.iconSm,
                      ),
                    ),
                    const SizedBox(width: TabletSpacingTokens.x1),
                    Text(
                      VitFormat.count(likes),
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    const SizedBox(width: TabletSpacingTokens.x3),
                    Text(
                      'Báo cáo',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Sc211HoldersContent extends StatelessWidget {
  const _Sc211HoldersContent({required this.snapshot});

  final PredictionEventDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(flex: 1, child: _Sc211OrderBookLabel('#')),
            Expanded(flex: 4, child: _Sc211OrderBookLabel('NHÀ GIAO DỊCH')),
            Expanded(
              flex: 2,
              child: _Sc211OrderBookLabel('BÊN', alignEnd: true),
            ),
            Expanded(
              flex: 2,
              child: _Sc211OrderBookLabel('CỔ PHẦN', alignEnd: true),
            ),
          ],
        ),
        const SizedBox(height: TabletSpacingTokens.x3),
        for (var index = 0; index < snapshot.topHolders.length; index += 1)
          _Sc211HolderRow(rank: index + 1, holder: snapshot.topHolders[index]),
      ],
    );
  }
}

class _Sc211HolderRow extends StatelessWidget {
  const _Sc211HolderRow({required this.rank, required this.holder});

  final int rank;
  final PredictionHolderDraft holder;

  @override
  Widget build(BuildContext context) {
    final color = holder.outcome == 'Yes' ? AppColors.buy : AppColors.sell;
    return Padding(
      padding: TabletSpacingTokens.tableCellPaddingV,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: SizedBox.square(
              dimension: TabletSpacingTokens.iconMd,
              child: Icon(
                rank == 1 ? Icons.workspace_premium_rounded : Icons.circle,
                color: rank == 1 ? AppColors.warn : AppColors.text3,
                size: rank == 1
                    ? TabletSpacingTokens.iconMd
                    : TabletSpacingTokens.iconSm,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              holder.name,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: _Sc211TinyBadge(
                label: holder.outcome,
                color: color,
                background: color.withValues(alpha: .12),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              VitFormat.count(holder.shares),
              textAlign: TextAlign.end,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Sc211ActivityContent extends StatelessWidget {
  const _Sc211ActivityContent({required this.snapshot});

  final PredictionEventDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in snapshot.activity)
          Padding(
            padding: TabletSpacingTokens.tableCellPaddingV,
            child: Row(
              children: [
                const SizedBox.square(
                  dimension: TabletSpacingTokens.iconMd,
                  child: Material(
                    color: AppColors.surface2,
                    borderRadius: AppRadii.smRadius,
                    child: Icon(
                      Icons.flash_on_rounded,
                      color: AppColors.primary,
                      size: TabletSpacingTokens.iconSm,
                    ),
                  ),
                ),
                const SizedBox(width: TabletSpacingTokens.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${item.actor} ${item.action}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: TabletSpacingTokens.x1),
                      Text(
                        item.amount,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  item.time,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
