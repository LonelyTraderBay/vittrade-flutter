part of 'arena_tablet_pages.dart';

// Trung tâm an toàn (dời từ _governance sang part riêng theo vai trò khi
// tách file vượt trần 1200 dòng): SC-198 Safety center.

// ---------------------------------------------------------------------------
// SC-198: Trung tâm an toàn (dời từ cụm points theo vai trò governance).

class ArenaSafetyCenterTabletPage extends ConsumerWidget {
  const ArenaSafetyCenterTabletPage({super.key});

  static const contentKey = Key('sc198_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(arenaSafetyCenterSnapshotProvider);
    final showBack = context.canPop();

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-198',
        semanticLabel: 'Trung tâm an toàn Open Arena',
        title: 'Trung tâm an toàn',
        subtitle: 'Cộng đồng · Báo cáo · Phân xử',
        contentKey: ArenaSafetyCenterTabletPage.contentKey,
        children: [
          _ardError(
            'Không tải được trung tâm an toàn',
            () => ref.invalidate(arenaSafetyCenterSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitPageLayout(
        variant: VitPageVariant.flush,
        semanticIdentifier: 'SC-198',
        semanticLabel: 'Trung tâm an toàn Open Arena',
        child: Column(
          children: [
            VitHeader(
              title: 'Trung tâm an toàn',
              subtitle: snapshot.bannerTitle,
              showBack: showBack,
              onBack: showBack
                  ? () => goBackOrFallback(
                      context,
                      fallbackPath: AppRoutePaths.arena,
                      mode: BackNavigationMode.historyThenFallback,
                    )
                  : null,
            ),
            Expanded(
              child: VitTabletPaneWorkspace(
                contentKey: ArenaSafetyCenterTabletPage.contentKey,
                primaryChildren: [
                  VitModuleHeroCard(
                    accentColor: AppModuleAccents.arena,
                    density: VitDensity.compact,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          snapshot.bannerTitle,
                          style: AppTextStyles.sectionTitle.copyWith(
                            fontWeight: AppTextStyles.heavy,
                            color: AppColors.text1,
                          ),
                        ),
                        const SizedBox(height: TabletSpacingTokens.x2),
                        Text(
                          snapshot.bannerDescription,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (snapshot.communityRules.isNotEmpty)
                    _PlayListSection(
                      title: 'Quy tắc cộng đồng',
                      itemCount: snapshot.communityRules.length,
                      itemBuilder: (context, i) {
                        final rule = snapshot.communityRules[i];
                        return ListTile(
                          dense: true,
                          leading: Icon(
                            _govSafetyKindIcon(rule.kind),
                            color: AppModuleAccents.arena,
                          ),
                          title: Text(
                            rule.title,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          subtitle: Text(
                            rule.description,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        );
                      },
                    ),
                  if (snapshot.bannedContent.isNotEmpty)
                    _PlayInfoCard(
                      title: 'Nội dung bị cấm',
                      icon: Icons.block_outlined,
                      rows: [
                        for (final item in snapshot.bannedContent)
                          VitBulletRow(text: item),
                      ],
                    ),
                  if (snapshot.violationProcess.isNotEmpty)
                    _PlayListSection(
                      title: 'Quy trình xử lý vi phạm',
                      itemCount: snapshot.violationProcess.length,
                      itemBuilder: (context, i) {
                        final step = snapshot.violationProcess[i];
                        return ListTile(
                          dense: true,
                          leading: Text(
                            '${step.step}',
                            style: AppTextStyles.caption.copyWith(
                              color: AppModuleAccents.arena,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          title: Text(
                            step.title,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          subtitle: Text(
                            step.description,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        );
                      },
                    ),
                  if (snapshot.reportActions.isNotEmpty)
                    _PlayListSection(
                      title: 'Hành động báo cáo',
                      itemCount: snapshot.reportActions.length,
                      itemBuilder: (context, i) {
                        final action = snapshot.reportActions[i];
                        return ListTile(
                          dense: true,
                          leading: Icon(
                            _govSafetyKindIcon(action.kind),
                            color: AppColors.warn,
                          ),
                          title: Text(
                            action.title,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          subtitle: Text(
                            action.description,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        );
                      },
                    ),
                ],
                secondaryChildren: [
                  _PlayInfoCard(
                    title: snapshot.resolution.title,
                    icon: _govSafetyKindIcon(snapshot.resolution.kind),
                    rows: [
                      _ardBody(snapshot.resolution.description),
                      for (final item in snapshot.resolution.items)
                        VitBulletRow(
                          text: '${item.allowed ? '✓' : '✗'} ${item.text}',
                        ),
                    ],
                  ),
                  _PlayInfoCard(
                    title: snapshot.offPlatform.title,
                    icon: _govSafetyKindIcon(snapshot.offPlatform.kind),
                    rows: [_ardBody(snapshot.offPlatform.description)],
                  ),
                  _PlayInfoCard(
                    title: snapshot.pointsDisclaimer.title,
                    icon: _govSafetyKindIcon(snapshot.pointsDisclaimer.kind),
                    rows: [_ardBody(snapshot.pointsDisclaimer.description)],
                  ),
                  if (snapshot.quickLinks.isNotEmpty)
                    _ardQuickLinks(context, [
                      for (final link in snapshot.quickLinks)
                        (link.title, link.route),
                    ]),
                  if (snapshot.footerLabel.isNotEmpty)
                    Text(
                      snapshot.footerLabel,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                ],
                narrowChildren: [
                  VitModuleHeroCard(
                    accentColor: AppModuleAccents.arena,
                    density: VitDensity.compact,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          snapshot.bannerTitle,
                          style: AppTextStyles.sectionTitle.copyWith(
                            fontWeight: AppTextStyles.heavy,
                            color: AppColors.text1,
                          ),
                        ),
                        const SizedBox(height: TabletSpacingTokens.x2),
                        Text(
                          snapshot.bannerDescription,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (snapshot.communityRules.isNotEmpty)
                    _PlayInfoCard(
                      title: 'Quy tắc cộng đồng',
                      rows: [
                        for (final rule in snapshot.communityRules)
                          _PlayInfoRow(
                            label: rule.title,
                            value: rule.description,
                          ),
                      ],
                    ),
                  if (snapshot.quickLinks.isNotEmpty)
                    _ardQuickLinks(context, [
                      for (final link in snapshot.quickLinks)
                        (link.title, link.route),
                    ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
