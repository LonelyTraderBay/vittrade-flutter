part of 'p2p_security_tablet_pages.dart';

class P2PDeviceManagementTabletPage extends ConsumerWidget {
  const P2PDeviceManagementTabletPage({super.key});

  static const contentKey = Key('sc255_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pDeviceManagementProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _secPageFrame(
        context: context,
        semanticIdentifier: 'SC-255',
        semanticLabel: 'Quản lý thiết bị P2P',
        title: 'Thiết bị tin tưởng',
        subtitle: 'Thiết bị · Phiên đăng nhập',
        contentKey: P2PDeviceManagementTabletPage.contentKey,
        child: _secError(
          'Không tải được thiết bị',
          () => ref.invalidate(p2pDeviceManagementProvider),
        ),
      ),
      data: (snapshot) => _secPageFrame(
        context: context,
        semanticIdentifier: 'SC-255',
        semanticLabel: 'Quản lý thiết bị P2P',
        title: 'Thiết bị tin tưởng',
        subtitle: '${snapshot.devices.length} thiết bị',
        contentKey: P2PDeviceManagementTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final device in snapshot.devices)
              Padding(
                padding: const EdgeInsets.only(bottom: TabletSpacingTokens.x3),
                child: VitCard(
                  radius: VitCardRadius.tight,
                  padding: TabletSpacingTokens.cardPaddingCompact,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${device.name} (${device.type})',
                              style: AppTextStyles.control.copyWith(
                                fontWeight: AppTextStyles.bold,
                                color: AppColors.text1,
                              ),
                            ),
                          ),
                          if (device.isCurrent)
                            const VitStatusPill(
                              label: 'Thiết bị này',
                              status: VitStatusPillStatus.info,
                              size: VitStatusPillSize.sm,
                            ),
                        ],
                      ),
                      const SizedBox(height: TabletSpacingTokens.x2),
                      ..._insRowsList([
                        ('Hệ điều hành', device.os),
                        ('Trình duyệt', device.browser),
                        ('Vị trí', device.location),
                        ('IP', device.ip),
                        ('Hoạt động cuối', device.lastActive),
                      ]),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: TabletSpacingTokens.x1),
            _secSection(
              title: snapshot.infoTitle,
              rows: [
                Text(
                  snapshot.infoBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: TabletSpacingTokens.x2),
                ..._secTips(snapshot.securityTips),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

List<Widget> _insRowsList(List<(String, String)> pairs) {
  return [
    for (final (label, value) in pairs)
      Padding(
        padding: TabletSpacingTokens.tableCellPaddingV,
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
          ],
        ),
      ),
  ];
}

/// SC-256: Mã chống lừa đảo.
class P2PAntiPhishingCodeTabletPage extends ConsumerWidget {
  const P2PAntiPhishingCodeTabletPage({super.key});

  static const contentKey = Key('sc256_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pAntiPhishingCodeProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _secPageFrame(
        context: context,
        semanticIdentifier: 'SC-256',
        semanticLabel: 'Mã chống lừa đảo P2P',
        title: 'Mã chống lừa đảo',
        subtitle: 'Nhận diện email thật',
        contentKey: P2PAntiPhishingCodeTabletPage.contentKey,
        child: _secError(
          'Không tải được mã chống lừa',
          () => ref.invalidate(p2pAntiPhishingCodeProvider),
        ),
      ),
      data: (snapshot) => _secPageFrame(
        context: context,
        semanticIdentifier: 'SC-256',
        semanticLabel: 'Mã chống lừa đảo P2P',
        title: 'Mã chống lừa đảo',
        subtitle: 'Nhận diện email chính thức',
        contentKey: P2PAntiPhishingCodeTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VitCard(
              radius: VitCardRadius.tight,
              padding: TabletSpacingTokens.cardPaddingCompact,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.statusTitle,
                    style: AppTextStyles.control.copyWith(
                      fontWeight: AppTextStyles.bold,
                      color: AppColors.text1,
                    ),
                  ),
                  const SizedBox(height: TabletSpacingTokens.x1),
                  Text(
                    snapshot.statusBody,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.3,
                    ),
                  ),
                  if (snapshot.hasCode) ...[
                    const SizedBox(height: TabletSpacingTokens.x2),
                    VitStatusPill(
                      label: 'Mã hiện tại: ${snapshot.currentCode}',
                      status: VitStatusPillStatus.success,
                      size: VitStatusPillSize.sm,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _secSection(
              title: snapshot.explainerTitle,
              rows: [
                Text(
                  snapshot.explainerBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: TabletSpacingTokens.x2),
                ..._secTips(snapshot.benefits),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _secSection(
              title: 'Ví dụ nhận diện',
              rows: [
                for (final example in snapshot.examples)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.zero,
                          child: Icon(
                            example.isLegit
                                ? Icons.mark_email_read_outlined
                                : Icons.mark_email_unread_outlined,
                            size: TabletSpacingTokens.iconSm,
                            color: example.isLegit
                                ? AppColors.buy
                                : AppColors.sell,
                          ),
                        ),
                        const SizedBox(width: TabletSpacingTokens.x2),
                        Expanded(
                          child: Text(
                            '${example.subject} — ${example.preview}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _secSection(
              title: snapshot.warningTitle,
              rows: _secTips(snapshot.warnings),
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-257: Lịch sử đăng nhập.
class P2PLoginHistoryTabletPage extends ConsumerWidget {
  const P2PLoginHistoryTabletPage({super.key});

  static const contentKey = Key('sc257_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pLoginHistoryProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _secPageFrame(
        context: context,
        semanticIdentifier: 'SC-257',
        semanticLabel: 'Lịch sử đăng nhập P2P',
        title: 'Lịch sử đăng nhập',
        subtitle: 'Thiết bị · Vị trí',
        contentKey: P2PLoginHistoryTabletPage.contentKey,
        child: _secError(
          'Không tải được lịch sử đăng nhập',
          () => ref.invalidate(p2pLoginHistoryProvider),
        ),
      ),
      data: (snapshot) => _secPageFrame(
        context: context,
        semanticIdentifier: 'SC-257',
        semanticLabel: 'Lịch sử đăng nhập P2P',
        title: 'Lịch sử đăng nhập',
        subtitle: '${snapshot.events.length} lần đăng nhập',
        contentKey: P2PLoginHistoryTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VitCard(
              radius: VitCardRadius.tight,
              padding: TabletSpacingTokens.zeroInsets,
              clip: true,
              child: Column(
                children: [
                  for (var i = 0; i < snapshot.events.length; i++) ...[
                    Padding(
                      padding: TabletSpacingTokens.tableCellPadding,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              '${snapshot.events[i].deviceName} · ${snapshot.events[i].browser}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text1,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              '${snapshot.events[i].city}, ${snapshot.events[i].country}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: VitStatusPill(
                              label: snapshot.events[i].statusLabel,
                              status: snapshot.events[i].status == 'success'
                                  ? VitStatusPillStatus.success
                                  : VitStatusPillStatus.error,
                              size: VitStatusPillSize.sm,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              snapshot.events[i].timestamp,
                              textAlign: TextAlign.end,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                                fontFeatures: AppTextStyles.tabularFigures,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (i < snapshot.events.length - 1)
                      const Divider(
                        height: TabletSpacingTokens.dividerHairline,
                        thickness: TabletSpacingTokens.dividerHairline,
                        color: AppColors.divider,
                      ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _secSection(
              title: 'Cảnh báo',
              rows: [
                Text(
                  snapshot.warningBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _secSection(
              title: snapshot.infoTitle,
              rows: _secTips(snapshot.securityTips),
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-258: Hoạt động đáng ngờ.
class P2PSuspiciousActivityTabletPage extends ConsumerWidget {
  const P2PSuspiciousActivityTabletPage({super.key});

  static const contentKey = Key('sc258_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pSuspiciousActivityProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _secPageFrame(
        context: context,
        semanticIdentifier: 'SC-258',
        semanticLabel: 'Hoạt động đáng ngờ P2P',
        title: 'Hoạt động đáng ngờ',
        subtitle: 'Cảnh báo · Kiểm tra',
        contentKey: P2PSuspiciousActivityTabletPage.contentKey,
        child: _secError(
          'Không tải được hoạt động đáng ngờ',
          () => ref.invalidate(p2pSuspiciousActivityProvider),
        ),
      ),
      data: (snapshot) => _secPageFrame(
        context: context,
        semanticIdentifier: 'SC-258',
        semanticLabel: 'Hoạt động đáng ngờ P2P',
        title: 'Hoạt động đáng ngờ',
        subtitle: snapshot.summarySubtitle,
        contentKey: P2PSuspiciousActivityTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (snapshot.alerts.isEmpty)
              const VitEmptyState(
                icon: Icons.verified_user_outlined,
                title: 'Không có cảnh báo',
                message: 'Tài khoản của bạn đang an toàn.',
              )
            else
              for (final alert in snapshot.alerts)
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: TabletSpacingTokens.x3,
                  ),
                  child: VitCard(
                    radius: VitCardRadius.tight,
                    padding: TabletSpacingTokens.cardPaddingCompact,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                alert.type,
                                style: AppTextStyles.control.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                  color: AppColors.text1,
                                ),
                              ),
                            ),
                            Text(
                              alert.timestamp,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                                fontFeatures: AppTextStyles.tabularFigures,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: TabletSpacingTokens.x1),
                        Text(
                          alert.message,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

/// SC-404: Chế độ whitelist rút tiền.
class P2PWhitelistModeTabletPage extends ConsumerStatefulWidget {
  const P2PWhitelistModeTabletPage({super.key});

  static const contentKey = Key('sc404_tablet_content');

  @override
  ConsumerState<P2PWhitelistModeTabletPage> createState() =>
      _P2PWhitelistModeTabletPageState();
}

class _P2PWhitelistModeTabletPageState
    extends ConsumerState<P2PWhitelistModeTabletPage> {
  bool _whitelistEnabled = false;

  @override
  Widget build(BuildContext context) {
    return _secPageFrame(
      context: context,
      semanticIdentifier: 'SC-404',
      semanticLabel: 'Chế độ whitelist P2P',
      title: 'Chế độ whitelist',
      subtitle: 'Rút tiền · Địa chỉ tin tưởng',
      contentKey: P2PWhitelistModeTabletPage.contentKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VitHighRiskStatePanel(
            state: VitHighRiskUiState.riskReview,
            title: 'Xem lại chế độ whitelist',
            message:
                'Khi bật, rút tiền chỉ thực hiện được tới các địa chỉ đã thêm vào danh sách tin tưởng. Thay đổi chế độ cần xác minh 2FA.',
            contractId: 'p2p-whitelist-tablet',
          ),
          const SizedBox(height: TabletSpacingTokens.x3),
          _secSection(
            title: 'Hành động',
            rows: [
              Wrap(
                spacing: TabletSpacingTokens.x3,
                runSpacing: TabletSpacingTokens.x2,
                children: [
                  VitCtaButton(
                    fullWidth: false,
                    variant: VitCtaButtonVariant.secondary,
                    onPressed: () =>
                        setState(() => _whitelistEnabled = !_whitelistEnabled),
                    child: Text(
                      _whitelistEnabled ? 'Tắt whitelist' : 'Bật whitelist',
                    ),
                  ),
                  VitCtaButton(
                    fullWidth: false,
                    variant: VitCtaButtonVariant.ghost,
                    onPressed: () =>
                        context.go(AppRoutePaths.p2pSecurityCenter),
                    child: const Text('Về trung tâm bảo mật'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
