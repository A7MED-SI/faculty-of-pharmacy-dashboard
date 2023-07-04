import 'package:flutter/material.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({super.key});
  static const routeName = 'questions';

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // ignore: unused_local_variable
    final textTheme = Theme.of(context).textTheme;
    // ignore: unused_local_variable
    final size = MediaQuery.of(context).size;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colorScheme.surfaceVariant,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const QuestionCard(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return ExpansionTile(
      title: Text(
        'من كم حمض أميني يتكون هرمون ال PTH',
        style: textTheme.headlineSmall?.copyWith(
          color: colorScheme.onBackground,
          fontWeight: FontWeight.bold,
        ),
      ),
      // leading: MaterialButton(
      //   shape: const CircleBorder(),
      //   onPressed: () {},
      //   child: const Icon(Icons.more_vert_outlined),
      // ),
      leading: PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        onSelected: (value) {},
        splashRadius: 30,
        itemBuilder: (context) => <PopupMenuItem<String>>[
          const PopupMenuItem<String>(
            value: 'one',
            child: Text(
              'تعديل',
            ),
          ),
          const PopupMenuItem<String>(
            value: 'two',
            child: Text(
              'حذف',
            ),
          ),
        ],
        child: const Icon(Icons.more_vert_outlined),
      ),
      backgroundColor: colorScheme.background,
      collapsedBackgroundColor: colorScheme.background,
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      collapsedIconColor: colorScheme.onBackground,
      tilePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      iconColor: colorScheme.onBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      childrenPadding: const EdgeInsets.only(right: 12),
      children: const [
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 200,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnswerRow(
                  answer: 'أربع و ستون',
                  isCorrect: true,
                ),
                AnswerRow(
                  answer: 'خمس و ستون',
                ),
                AnswerRow(
                  answer: 'ثمان و سبعون',
                ),
                AnswerRow(
                  answer: 'ستون',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AnswerRow extends StatelessWidget {
  const AnswerRow({
    super.key,
    required this.answer,
    this.isCorrect = false,
  });

  final String answer;
  final bool isCorrect;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          answer,
          style: textTheme.bodyLarge,
        ),
        isCorrect
            ? const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 20,
              )
            : const Icon(
                Icons.cancel_rounded,
                color: Colors.red,
                size: 20,
              ),
      ],
    );
  }
}
