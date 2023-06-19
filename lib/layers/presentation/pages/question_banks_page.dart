import 'package:flutter/material.dart';
import 'package:pharmacy_dashboard/core/layout/adaptive.dart';

class QuestionBanksPage extends StatelessWidget {
  const QuestionBanksPage({super.key});
  static const routeName = 'questionBanks';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDestop = isDisplayDesktop(context);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: colorScheme.surfaceVariant,
        body: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Row(
            children: [
              const Expanded(
                child: _ScrollViewList(),
              ),
              if (isDestop)
                const Expanded(
                  child: _ScrollViewList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScrollViewList extends StatelessWidget {
  const _ScrollViewList();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                const _BankCard(),
                const _BankCard(),
                const _BankCard(),
                const _BankCard(),
                const _BankCard(),
                const _BankCard(),
                const _BankCard(),
                const _BankCard(),
                const _BankCard(),
                const _BankCard(),
                const _BankCard(),
                const _BankCard(),
                const _BankCard(),
                const _BankCard(),
                const _BankCard(),
                const _BankCard(),
                const _BankCard(),
                const _BankCard(),
                const _BankCard(),
                const _BankCard(),
                const _BankCard(),
                const _BankCard(),
                const _BankCard(),
                const _BankCard(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BankCard extends StatelessWidget {
  const _BankCard();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        color: colorScheme.background,
        elevation: 4,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
          child: Text(
            'بنك الأسئلة',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onBackground,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
