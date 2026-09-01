import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_copy_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/entities/trade_copy_entities.dart';

part '../../../widgets/safety/dispute_resolution_form.dart';
part '../../../widgets/safety/dispute_resolution_cases.dart';
part '../../../widgets/safety/dispute_resolution_common.dart';

const _disputePrimary = AppColors.primary;
const _disputeField = AppColors.surface2;
const _disputeFieldBorder = AppColors.borderSolid;

class DisputeResolutionPage extends ConsumerStatefulWidget {
  const DisputeResolutionPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc082_dispute_resolution_content');
  static const submitKey = Key('sc082_submit_complaint');
  static const providerKey = Key('sc082_provider_dropdown');
  static const subjectKey = Key('sc082_subject');
  static const descriptionKey = Key('sc082_description');
  static const uploadKey = Key('sc082_upload_evidence');
  static const complaintTypeSectionKey = Key('sc082_complaint_type_section');

  static Key complaintTypeKey(String id) => Key('sc082_complaint_type_$id');
  static Key tabKey(String id) => Key('sc082_tab_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DisputeResolutionPage> createState() =>
      _DisputeResolutionPageState();
}

class _DisputeResolutionPageState extends ConsumerState<DisputeResolutionPage> {
  late final TextEditingController _subjectController;
  late final TextEditingController _descriptionController;
  String _activeTabId = 'file';
  String? _selectedType;
  String? _selectedProviderId;
  bool _evidenceAttached = false;
  TradeDisputeSubmissionResult? _lastResult;

  @override
  void initState() {
    super.initState();
    _subjectController = TextEditingController()
      ..addListener(() => setState(() {}));
    _descriptionController = TextEditingController()
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool get _canSubmit {
    return _selectedType != null &&
        _selectedProviderId != null &&
        _subjectController.text.trim().isNotEmpty &&
        _descriptionController.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(tradeDisputeResolutionProvider);
    return VitTradeHubScaffold(
      title: 'Giải quyết khiếu nại',
      semanticLabel: 'Giải quyết khiếu nại',
      semanticIdentifier: 'SC-082',
      contentKey: DisputeResolutionPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeCopyTrading,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: [
        ...snapshotAsync.when(
          loading: () => const [VitSkeletonList()],
          error: (error, stackTrace) => [
            VitErrorState(
              title: 'Không tải được dữ liệu khiếu nại',
              message: 'Vui lòng kiểm tra kết nối và thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(tradeDisputeResolutionProvider),
            ),
          ],
          data: (snapshot) => [
            if (_activeTabId == 'file')
              _FileComplaintTab(
                snapshot: snapshot,
                selectedType: _selectedType,
                selectedProviderId: _selectedProviderId,
                subjectController: _subjectController,
                descriptionController: _descriptionController,
                evidenceAttached: _evidenceAttached,
                canSubmit: _canSubmit,
                onTypeChanged: (value) => setState(() => _selectedType = value),
                onProviderChanged: (value) =>
                    setState(() => _selectedProviderId = value),
                onUpload: () => setState(() => _evidenceAttached = true),
                onSubmit: _handleSubmit,
              )
            else
              VitTradeSection(
                title: 'Cases',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _DisputeTabs(
                      tabs: snapshot.tabs,
                      activeId: _activeTabId,
                      onChanged: (id) => setState(() => _activeTabId = id),
                    ),
                    _CasesTab(
                      activeTabId: _activeTabId,
                      snapshot: snapshot,
                      lastResult: _lastResult,
                    ),
                  ],
                ),
              ),
            if (_activeTabId != 'file')
              VitTradeComplianceSection(
                title: 'Dispute process',
                density: VitDensity.tool,
                statusPill: const VitStatusPill(
                  label: 'Regulated intake',
                  status: VitStatusPillStatus.info,
                  size: VitStatusPillSize.sm,
                ),
                items: [
                  VitTradeComplianceItem(
                    label: 'Providers',
                    value: '${snapshot.providers.length} available',
                  ),
                  const VitTradeComplianceItem(
                    label: 'Framework',
                    value: 'Copy-trading dispute intake',
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    if (!_canSubmit) return;

    final result = await ref
        .read(tradeCopyTradingRepositoryProvider)
        .submitDisputeComplaint(
          TradeDisputeComplaintDraft(
            complaintType: _selectedType!,
            providerId: _selectedProviderId!,
            subject: _subjectController.text.trim(),
            description: _descriptionController.text.trim(),
            evidenceNames: _evidenceAttached
                ? const ['slippage-proof.png']
                : const [],
          ),
        );
    if (!mounted) return;

    setState(() {
      _lastResult = result;
      _selectedType = null;
      _selectedProviderId = null;
      _subjectController.clear();
      _descriptionController.clear();
      _evidenceAttached = false;
      _activeTabId = 'active';
    });
  }
}
