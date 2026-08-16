part of '../../phone/pages/settings/bot_api_documentation_page.dart';

class _WebSocketView extends StatelessWidget {
  const _WebSocketView({required this.url, required this.events});

  final String url;
  final List<TradeBotWebSocketEvent> events;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.tool,
      children: [
        VitPageSection(
          label: 'Kết nối WebSocket',
          density: VitDensity.tool,
          children: [
            _InfoCard(
              child: VitPageContent(
                rhythm: VitPageRhythm.standard,
                padding: VitContentPadding.none,
                fullBleed: true,
                density: VitDensity.tool,
                children: [
                  Text(
                    'Kết nối để nhận sự kiện bot theo thời gian thực:',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                  _CodeBlock(text: url, compact: true),
                ],
              ),
            ),
          ],
        ),
        VitPageSection(
          label: 'Loại sự kiện',
          density: VitDensity.tool,
          children: [
            VitPageContent(
              padding: VitContentPadding.none,
              fullBleed: true,
              density: VitDensity.tool,
              children: [
                for (final event in events)
                  _InfoCard(
                    child: VitPageContent(
                      padding: VitContentPadding.none,
                      fullBleed: true,
                      density: VitDensity.tool,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.bolt_rounded,
                              color: _apiPrimary,
                              size: AppSpacing.iconSm,
                            ),
                            const SizedBox(width: AppSpacing.x2),
                            Text(
                              event.event,
                              style: AppTextStyles.caption.copyWith(
                                color: _apiPrimary,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          event.description,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                        _CodeBlock(text: event.payload),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _ExamplesView extends StatelessWidget {
  const _ExamplesView({
    required this.examples,
    required this.language,
    required this.copied,
    required this.onLanguageChanged,
    required this.onCopy,
  });

  final List<TradeBotCodeExample> examples;
  final String language;
  final bool copied;
  final ValueChanged<String> onLanguageChanged;
  final ValueChanged<String> onCopy;

  @override
  Widget build(BuildContext context) {
    final selected = examples.firstWhere(
      (item) => item.language == language,
      orElse: () => examples.first,
    );
    return VitPageContent(
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.tool,
      children: [
        Row(
          children: [
            for (final example in examples) ...[
              VitCtaButton(
                key: BotApiDocumentationPage.languageKey(example.language),
                onPressed: () => onLanguageChanged(example.language),
                fullWidth: false,
                density: VitDensity.tool,
                variant: selected.language == example.language
                    ? VitCtaButtonVariant.secondary
                    : VitCtaButtonVariant.ghost,
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: AppSpacing.x3,
                ),
                child: Text(
                  example.label,
                  style: AppTextStyles.caption.copyWith(
                    color: selected.language == example.language
                        ? _apiPrimary
                        : AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              if (example != examples.last)
                const SizedBox(width: AppSpacing.x2),
            ],
          ],
        ),
        VitPageSection(
          label: 'Bắt đầu nhanh',
          density: VitDensity.tool,
          children: [
            _InfoCard(
              child: VitPageContent(
                padding: VitContentPadding.none,
                fullBleed: true,
                density: VitDensity.tool,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.menu_book_outlined,
                        color: _apiPrimary,
                        size: AppSpacing.iconSm,
                      ),
                      const SizedBox(width: AppSpacing.x2),
                      Expanded(
                        child: Text(
                          selected.title,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      VitIconButton(
                        icon: copied
                            ? Icons.check_circle_outline_rounded
                            : Icons.content_copy_rounded,
                        tooltip: copied
                            ? 'Đã sao chép mã nguồn'
                            : 'Sao chép mã nguồn',
                        label: copied ? 'Đã sao chép!' : 'Sao chép',
                        size: VitIconButtonSize.sm,
                        variant: copied
                            ? VitIconButtonVariant.success
                            : VitIconButtonVariant.ghost,
                        onPressed: () => onCopy(selected.source),
                      ),
                    ],
                  ),
                  _CodeBlock(text: selected.source, example: true),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
