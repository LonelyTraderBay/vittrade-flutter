part of 'p2p_kyc_tablet_pages.dart';

/// SC-249 (và alias SC-402 verify): Xác minh danh tính.
class P2PIdentityVerificationTabletPage extends ConsumerWidget {
  const P2PIdentityVerificationTabletPage({super.key});

  static const contentKey = Key('sc249_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pIdentityVerificationProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-249',
        semanticLabel: 'Xác minh danh tính P2P',
        title: 'Xác minh danh tính',
        subtitle: 'Giấy tờ · Hướng dẫn',
        contentKey: P2PIdentityVerificationTabletPage.contentKey,
        children: [
          VitErrorState(
            title: 'Không tải được xác minh danh tính',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(p2pIdentityVerificationProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-249',
        semanticLabel: 'Xác minh danh tính P2P',
        title: snapshot.heroTitle,
        subtitle: 'Bước 1/3 · Giấy tờ tùy thân',
        contentKey: P2PIdentityVerificationTabletPage.contentKey,
        children: [
          Text(
            snapshot.heroBody,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.3,
            ),
          ),

          _section(
            title: 'Loại giấy tờ',
            rows: [
              for (final doc in snapshot.documentTypes)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          doc.label,
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: AppTextStyles.bold,
                            color: AppColors.text1,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          doc.description,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          _section(
            title: 'Hướng dẫn chụp',
            rows: [
              ..._noteList(
                snapshot.guidelines,
                Icons.check_circle_outline_rounded,
                AppColors.buy,
              ),
            ],
          ),

          _section(
            title: 'Bảo mật dữ liệu',
            rows: [
              ..._noteList(
                snapshot.securityNotes,
                Icons.lock_outline_rounded,
                AppColors.primary,
              ),
            ],
          ),

          const SizedBox(height: TabletSpacingTokens.x4),

          VitCtaButton(
            onPressed: () => context.push(snapshot.nextRoute),
            child: const Text('Tiếp tục'),
          ),
        ],
      ),
    );
  }
}

/// SC-250: Xác minh địa chỉ.
class P2PAddressProofTabletPage extends ConsumerWidget {
  const P2PAddressProofTabletPage({super.key});

  static const contentKey = Key('sc250_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pAddressProofProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-250',
        semanticLabel: 'Xác minh địa chỉ P2P',
        title: 'Xác minh địa chỉ',
        subtitle: 'Hóa đơn · Sao kê',
        contentKey: P2PAddressProofTabletPage.contentKey,
        children: [
          VitErrorState(
            title: 'Không tải được xác minh địa chỉ',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(p2pAddressProofProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-250',
        semanticLabel: 'Xác minh địa chỉ P2P',
        title: snapshot.heroTitle,
        subtitle: 'Bước 2/3 · Bằng chứng địa chỉ',
        contentKey: P2PAddressProofTabletPage.contentKey,
        children: [
          Text(
            snapshot.heroBody,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.3,
            ),
          ),

          _section(
            title: 'Loại giấy tờ chấp nhận',
            rows: [
              for (final doc in snapshot.documentTypes)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Text(
                    doc.label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
            ],
          ),

          _section(
            title: 'Yêu cầu',
            rows: [
              ..._noteList(
                snapshot.requirements,
                Icons.check_circle_outline_rounded,
                AppColors.buy,
              ),
            ],
          ),

          _section(
            title: 'Dữ liệu nhận diện (mẫu)',
            rows: [
              for (final (label, value) in [
                ('Họ tên', snapshot.extractedName),
                ('Địa chỉ', snapshot.extractedAddress),
                ('Ngày phát hành', snapshot.extractedDate),
              ])
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          label,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ),
                      Text(
                        value,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          _section(
            title: 'Bảo mật dữ liệu',
            rows: [
              ..._noteList(
                snapshot.securityNotes,
                Icons.lock_outline_rounded,
                AppColors.primary,
              ),
            ],
          ),

          const SizedBox(height: TabletSpacingTokens.x4),

          VitCtaButton(
            onPressed: () => context.push(snapshot.submitRoute),
            child: const Text('Gửi bằng chứng địa chỉ'),
          ),
        ],
      ),
    );
  }
}

/// SC-251 (và alias SC-403 face-match): Xác minh khuôn mặt.
class P2PSelfieVerificationTabletPage extends ConsumerWidget {
  const P2PSelfieVerificationTabletPage({super.key});

  static const contentKey = Key('sc251_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pSelfieVerificationProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-251',
        semanticLabel: 'Xác minh khuôn mặt P2P',
        title: 'Xác minh khuôn mặt',
        subtitle: 'Bước 3/3 · Selfie',
        contentKey: P2PSelfieVerificationTabletPage.contentKey,
        children: [
          VitErrorState(
            title: 'Không tải được xác minh khuôn mặt',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(p2pSelfieVerificationProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-251',
        semanticLabel: 'Xác minh khuôn mặt P2P',
        title: snapshot.heroTitle,
        subtitle: 'Bước 3/3 · Selfie & Liveness',
        contentKey: P2PSelfieVerificationTabletPage.contentKey,
        children: [
          Text(
            snapshot.heroBody,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.3,
            ),
          ),

          _section(
            title: snapshot.sampleTitle,
            rows: [
              Text(
                snapshot.sampleBody,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: TabletSpacingTokens.x2),
              for (final action in snapshot.livenessActions)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Text(
                    action.label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                    ),
                  ),
                ),
            ],
          ),

          _section(
            title: 'Kết quả đối chiếu (mẫu)',
            rows: [
              for (final (label, value) in [
                ('Độ khớp khuôn mặt', snapshot.matchScore),
                ('Điểm liveness', snapshot.livenessScore),
              ])
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          label,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ),
                      Text(
                        value,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.buy,
                          fontWeight: AppTextStyles.bold,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          _section(
            title: 'Mẹo chụp đẹp',
            rows: [
              ..._noteList(
                snapshot.tips,
                Icons.lightbulb_outline_rounded,
                AppColors.caution,
              ),
            ],
          ),

          const SizedBox(height: TabletSpacingTokens.x4),

          VitCtaButton(
            onPressed: () => context.push(snapshot.statusRoute),
            child: const Text('Hoàn tất & xem trạng thái'),
          ),
        ],
      ),
    );
  }
}

/// SC-252: Xác minh video.
class P2PVideoVerificationTabletPage extends ConsumerWidget {
  const P2PVideoVerificationTabletPage({super.key});

  static const contentKey = Key('sc252_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pVideoVerificationProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-252',
        semanticLabel: 'Xác minh video P2P',
        title: 'Xác minh video',
        subtitle: 'Đặt lịch · Chuẩn bị',
        contentKey: P2PVideoVerificationTabletPage.contentKey,
        children: [
          VitErrorState(
            title: 'Không tải được xác minh video',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(p2pVideoVerificationProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-252',
        semanticLabel: 'Xác minh video P2P',
        title: snapshot.heroTitle,
        subtitle: 'Gặp nhân viên xác minh qua video',
        contentKey: P2PVideoVerificationTabletPage.contentKey,
        children: [
          Text(
            snapshot.heroBody,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.3,
            ),
          ),

          _section(
            title: 'Chuẩn bị trước buổi gọi',
            rows: [
              ..._noteList(
                snapshot.preparationItems,
                Icons.check_circle_outline_rounded,
                AppColors.buy,
              ),
            ],
          ),

          _section(
            title: 'Khung giờ khả dụng',
            rows: [
              for (final slot in snapshot.timeSlots.take(8))
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${slot.date} · ${slot.time}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                      ),
                      VitStatusPill(
                        label: slot.available ? 'Còn chỗ' : 'Đã kín',
                        status: slot.available
                            ? VitStatusPillStatus.success
                            : VitStatusPillStatus.neutral,
                        size: VitStatusPillSize.sm,
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: TabletSpacingTokens.x4),

          VitCtaButton(
            onPressed: () => context.push(snapshot.statusRoute),
            child: const Text('Đặt lịch xác minh'),
          ),
        ],
      ),
    );
  }
}
