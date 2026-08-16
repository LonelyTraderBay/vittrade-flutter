import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_bots_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_bots/domain/entities/trade_bots_entities.dart';

part '../../../widgets/settings/bot_faq_search_tabs.dart';
part '../../../widgets/settings/bot_faq_cards_help.dart';

const _faqPrimary = AppColors.primary;

class BotFaqPage extends ConsumerStatefulWidget {
  const BotFaqPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc132_bot_faq_content');
  static const searchKey = Key('sc132_bot_faq_search');
  static Key tabKey(String id) => Key('sc132_bot_faq_tab_$id');
  static Key questionKey(String id, int index) =>
      Key('sc132_bot_faq_question_${id}_$index');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotFaqPage> createState() => _BotFaqPageState();
}

class _BotFaqPageState extends ConsumerState<BotFaqPage> {
  late final TextEditingController _searchController;
  String _categoryId = 'general';
  int? _expandedIndex;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(tradeBotFaqProvider);
    return VitTradeHubScaffold(
      title: 'Hỏi đáp Bot giao dịch',
      subtitle: 'Câu hỏi thường gặp về bot giao dịch',
      semanticLabel: 'Giải đáp câu hỏi thường gặp về bot giao dịch',
      semanticIdentifier: 'SC-132',
      contentKey: BotFaqPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      activeProductId: 'bots',
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeBots,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: snapshotAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được câu hỏi thường gặp',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradeBotFaqProvider),
          ),
        ],
        data: (snapshot) {
          final category = snapshot.categories.firstWhere(
            (item) => item.id == _categoryId,
            orElse: () => snapshot.categories.first,
          );
          final query = _query.trim().toLowerCase();
          final items = query.isEmpty
              ? category.items
              : category.items
                    .where(
                      (item) =>
                          item.question.toLowerCase().contains(query) ||
                          item.answer.toLowerCase().contains(query),
                    )
                    .toList();
          return [
            VitBotSubpageHero(
              primaryLabel: 'Câu hỏi',
              primaryValue: '${snapshot.totalFaqs}',
              secondaryLabel: 'Danh mục',
              secondaryValue: '${snapshot.categories.length}',
            ),
            VitTradeSection(
              title: 'Tìm kiếm',
              child: _SearchField(
                controller: _searchController,
                onChanged: (value) => setState(() {
                  _query = value;
                  _expandedIndex = null;
                }),
              ),
            ),
            VitTradeSection(
              title: 'Danh mục',
              child: _CategoryTabs(
                categories: snapshot.categories,
                activeId: _categoryId,
                onChanged: (id) => setState(() {
                  _categoryId = id;
                  _expandedIndex = null;
                }),
              ),
            ),
            VitTradeSection(
              title: '${category.label} (${items.length})',
              child: items.isEmpty
                  ? const _EmptyFaqs()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var i = 0; i < items.length; i++) ...[
                          VitFaqAccordion(
                            key: BotFaqPage.questionKey(category.id, i),
                            question: items[i].question,
                            answer: items[i].answer,
                            expanded: _expandedIndex == i,
                            onTap: () => setState(() {
                              _expandedIndex = _expandedIndex == i ? null : i;
                            }),
                            accentColor: _faqPrimary,
                            leadingIcon: Icons.help_outline_rounded,
                            answerBackground: VitFaqAnswerBackground.surface2,
                          ),
                          if (i != items.length - 1)
                            const SizedBox(
                              height: AppSpacing.pageRhythmCompactInnerGap,
                            ),
                        ],
                      ],
                    ),
            ),
            const VitTradeSection(title: 'Hỗ trợ', child: _HelpCard()),
            const VitBotRiskDisclaimer(),
          ];
        },
      ),
    );
  }
}
