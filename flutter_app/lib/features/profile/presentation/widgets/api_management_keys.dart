part of '../phone/pages/api_management_page.dart';

class _ApiKeyCard extends StatelessWidget {
  const _ApiKeyCard({
    required this.apiKey,
    required this.showSecret,
    required this.copiedId,
    required this.onToggle,
    required this.onReveal,
    required this.onCopy,
    required this.onDelete,
  });

  final ProfileApiKey apiKey;
  final bool showSecret;
  final String? copiedId;
  final VoidCallback onToggle;
  final VoidCallback onReveal;
  final void Function(String id, String value) onCopy;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final active = apiKey.isActive;
    return Opacity(
      opacity: active ? 1 : .65,
      child: VitCard(
        key: ApiManagementPage.cardKey(apiKey.id),
        density: VitDensity.compact,
        borderColor: active ? _apiBorder : _apiRed.withValues(alpha: .15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ApiKeyHeader(apiKey: apiKey, onToggle: onToggle),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            _SecretRow(
              label: 'API KEY',
              value: _maskedKey(apiKey.key),
              labelColor: _apiMuted,
              trailing: _IconTap(
                icon: copiedId == '${apiKey.id}_key'
                    ? Icons.check_circle_outline_rounded
                    : Icons.copy_rounded,
                onTap: () => onCopy('${apiKey.id}_key', apiKey.key),
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            _SecretRow(
              label: 'SECRET',
              value: showSecret
                  ? apiKey.secret
                  : '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022',
              labelColor: _apiRed,
              redBorder: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _IconTap(
                    buttonKey: ApiManagementPage.revealKey(apiKey.id),
                    icon: showSecret
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    tooltip: showSecret ? '\u1EA8n secret' : 'Hi\u1EC7n secret',
                    onTap: onReveal,
                  ),
                  if (showSecret) ...[
                    const SizedBox(width: AppSpacing.x1),
                    _IconTap(
                      icon: copiedId == '${apiKey.id}_secret'
                          ? Icons.check_circle_outline_rounded
                          : Icons.copy_rounded,
                      onTap: () => onCopy('${apiKey.id}_secret', apiKey.secret),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            _PermissionBadges(apiKey: apiKey),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            _UsageRow(apiKey: apiKey),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            Row(
              children: [
                Expanded(
                  child: _RegenerateButton(
                    onTap: () {
                      unawaited(HapticFeedback.selectionClick());
                      unawaited(
                        showVitNoticeSheet(
                          context: context,
                          title: 'Sắp ra mắt',
                          message: 'Tạo lại Secret sẽ sớm ra mắt',
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                _DeleteButton(onTap: onDelete, id: apiKey.id),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ApiKeyHeader extends StatelessWidget {
  const _ApiKeyHeader({required this.apiKey, required this.onToggle});

  final ProfileApiKey apiKey;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final active = apiKey.isActive;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: ProfileSpacingTokens.profileApiIconBox,
          height: ProfileSpacingTokens.profileApiIconBox,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: active
                  ? _apiPrimary.withValues(alpha: .15)
                  : _apiRed.withValues(alpha: .1),
              shape: RoundedRectangleBorder(
                borderRadius: AppRadii.cardRadius,
                side: BorderSide(
                  color: active
                      ? _apiPrimary.withValues(alpha: .22)
                      : _apiRed.withValues(alpha: .22),
                ),
              ),
            ),
            child: Icon(
              Icons.key_rounded,
              color: active ? _apiPrimary : _apiRed,
              size: ProfileSpacingTokens.profileApiIcon,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      apiKey.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.extraBold,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  VitAccentPill(
                    label: active ? '• Active' : '• Disabled',
                    accentColor: active ? _apiGreen : _apiRed,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                'T\u1EA1o: ${apiKey.createdAt} \u2022 ${apiKey.expiresAt == null ? 'Kh\u00F4ng h\u1EBFt h\u1EA1n' : 'H\u1EBFt h\u1EA1n: ${apiKey.expiresAt}'}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: _apiMuted),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        _ToggleSwitch(
          key: ApiManagementPage.toggleKey(apiKey.id),
          active: active,
          onTap: onToggle,
        ),
      ],
    );
  }
}
