part of '../../phone/pages/settings/bot_api_documentation_page.dart';

class _EndpointsView extends StatelessWidget {
  const _EndpointsView({required this.endpoints});

  final List<TradeBotApiEndpoint> endpoints;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Các điểm cuối REST API',
      density: VitDensity.tool,
      children: [
        VitPageContent(
          rhythm: VitPageRhythm.standard,
          padding: VitContentPadding.none,
          fullBleed: true,
          density: VitDensity.tool,
          children: [
            for (final endpoint in endpoints) _EndpointCard(endpoint: endpoint),
          ],
        ),
      ],
    );
  }
}

class _EndpointCard extends StatelessWidget {
  const _EndpointCard({required this.endpoint});

  final TradeBotApiEndpoint endpoint;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: BotApiDocumentationPage.endpointKey(endpoint.method, endpoint.path),
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      child: VitPageContent(
        rhythm: VitPageRhythm.standard,
        padding: VitContentPadding.none,
        fullBleed: true,
        density: VitDensity.tool,
        children: [
          Row(
            children: [
              _MethodBadge(method: endpoint.method),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  endpoint.path,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.monoCode.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          Text(
            endpoint.description,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          if (endpoint.params.isNotEmpty) _Parameters(params: endpoint.params),
          _ResponseBlock(response: endpoint.response),
        ],
      ),
    );
  }
}

class _Parameters extends StatelessWidget {
  const _Parameters({required this.params});

  final List<TradeBotApiParameter> params;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'THAM SỐ:',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        for (final param in params) ...[
          _ParameterRow(param: param),
          if (param != params.last)
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        ],
      ],
    );
  }
}

class _ParameterRow extends StatelessWidget {
  const _ParameterRow({required this.param});

  final TradeBotApiParameter param;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          param.name,
          style: AppTextStyles.micro.copyWith(
            color: _apiPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Text(
          '(${param.type})',
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        if (param.required)
          Text(
            ' *',
            style: AppTextStyles.micro.copyWith(
              color: _apiRed,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            '- ${param.description}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ),
      ],
    );
  }
}

class _ResponseBlock extends StatelessWidget {
  const _ResponseBlock({required this.response});

  final String response;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'PHẢN HỒI:',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            const Expanded(child: SizedBox.shrink()),
            VitIconButton(
              key: BotApiDocumentationPage.copyKey,
              icon: Icons.content_copy_rounded,
              tooltip: 'Sao chép phản hồi',
              size: VitIconButtonSize.sm,
              variant: VitIconButtonVariant.transparent,
              onPressed: () => Clipboard.setData(ClipboardData(text: response)),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        _CodeBlock(text: response),
      ],
    );
  }
}
