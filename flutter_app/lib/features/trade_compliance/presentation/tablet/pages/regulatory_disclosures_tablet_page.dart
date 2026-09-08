import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/trade_compliance_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// SC-084: Tuân thủ giao dịch — hub công bố quy định (MiFID, bảo vệ tiền
/// khách hàng, hạn chế, trách nhiệm pháp lý, liên hệ, tài liệu).
class RegulatoryDisclosuresTabletPage extends ConsumerWidget {
  const RegulatoryDisclosuresTabletPage({super.key});

  static const contentKey = Key('sc084_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeRegulatoryDisclosuresProvider);
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Tuân thủ giao dịch',
      semanticIdentifier: 'SC-084',
      child: Column(
        children: [
          VitHeader(
            title: 'Tuân thủ giao dịch',
            subtitle: 'Công bố quy định · Bảo vệ nhà đầu tư',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.trade,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
          ),
          Expanded(
            child: snapshotAsync.when(
              loading: () => const Center(child: VitSkeletonList(rows: 6)),
              error: (error, stackTrace) => SingleChildScrollView(
                child: VitErrorState(
                  title: 'Không tải được công bố quy định',
                  message: 'Vui lòng kiểm tra kết nối và thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () =>
                      ref.invalidate(tradeRegulatoryDisclosuresProvider),
                ),
              ),
              data: (snapshot) => Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1080),
                  child: SingleChildScrollView(
                    key: RegulatoryDisclosuresTabletPage.contentKey,
                    padding: const EdgeInsets.fromLTRB(
                      TabletSpacingTokens.x6,
                      TabletSpacingTokens.x4,
                      TabletSpacingTokens.x6,
                      TabletSpacingTokens.x6,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _HeroCard(
                          title: snapshot.heroTitle,
                          description: snapshot.heroDescription,
                        ),
                        const SizedBox(height: TabletSpacingTokens.x3),
                        _DisclosureBlockCard(
                          title: snapshot.mifidTitle,
                          body: snapshot.mifidArticles.isEmpty
                              ? ''
                              : snapshot.mifidArticles.first.body,
                          items: [
                            for (final article in snapshot.mifidArticles)
                              ...article.items,
                          ],
                        ),
                        const SizedBox(height: TabletSpacingTokens.x3),
                        Text(
                          snapshot.commitmentText,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: TabletSpacingTokens.x3),
                        _DisclosureBlockCard(
                          title: snapshot.protection.coverage.title,
                          body: snapshot.protection.coverage.body,
                          items: snapshot.protection.coverage.items,
                        ),
                        const SizedBox(height: TabletSpacingTokens.x3),
                        _DisclosureBlockCard(
                          title: snapshot.restrictions.taxReporting.title,
                          body: snapshot.restrictions.taxReporting.body,
                          items: snapshot.restrictions.taxReporting.items,
                        ),
                        const SizedBox(height: TabletSpacingTokens.x3),
                        _DisclosureBlockCard(
                          title: snapshot.liability.limitation.title,
                          body: snapshot.liability.limitation.body,
                          items: snapshot.liability.limitation.items,
                        ),
                        const SizedBox(height: TabletSpacingTokens.x3),
                        _DisclosureBlockCard(
                          title: snapshot.whistleblower.title,
                          body: snapshot.whistleblower.body,
                          items: snapshot.whistleblower.items,
                        ),
                        const SizedBox(height: TabletSpacingTokens.x3),
                        _ContactsCard(contacts: snapshot.contacts),
                        const SizedBox(height: TabletSpacingTokens.x3),
                        _DocumentsCard(terms: snapshot.terms),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.control.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x1),
          Text(
            description,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _DisclosureBlockCard extends StatelessWidget {
  const _DisclosureBlockCard({
    required this.title,
    required this.body,
    required this.items,
  });

  final String title;
  final String body;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.control.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          if (body.isNotEmpty) ...[
            const SizedBox(height: TabletSpacingTokens.x1),
            Text(
              body,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: 1.3,
              ),
            ),
          ],
          if (items.isNotEmpty) ...[
            const SizedBox(height: TabletSpacingTokens.x2),
            for (final item in items)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: TabletSpacingTokens.x1,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item,
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
        ],
      ),
    );
  }
}

class _ContactsCard extends StatelessWidget {
  const _ContactsCard({required this.contacts});

  final List<dynamic> contacts;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Liên hệ',
            style: AppTextStyles.control.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          for (final contact in contacts)
            Padding(
              padding: TabletSpacingTokens.tableCellPaddingV,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      contact.title as String,
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: AppTextStyles.bold,
                        color: AppColors.text1,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      contact.subtitle as String,
                      textAlign: TextAlign.end,
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
    );
  }
}

class _DocumentsCard extends StatelessWidget {
  const _DocumentsCard({required this.terms});

  final List<dynamic> terms;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tài liệu',
            style: AppTextStyles.control.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          for (final doc in terms)
            Padding(
              padding: TabletSpacingTokens.tableCellPaddingV,
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.zero,
                    child: Icon(
                      Icons.description_outlined,
                      size: TabletSpacingTokens.iconSm,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: TabletSpacingTokens.x2),
                  Expanded(
                    child: Text(
                      doc.title as String,
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
    );
  }
}
