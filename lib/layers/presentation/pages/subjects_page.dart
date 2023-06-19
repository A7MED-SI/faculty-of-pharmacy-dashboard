import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/question_banks_page.dart';

class SubjectsPage extends StatelessWidget {
  const SubjectsPage({super.key});
  static const routeName = 'subjects';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colorScheme.surfaceVariant,
        body: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: colorScheme.secondaryContainer,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      'فلترة المواد',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: DataTable2(
                  decoration: BoxDecoration(
                    color: colorScheme.background,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  headingTextStyle: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
                  dataTextStyle: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onBackground,
                  ),
                  isHorizontalScrollBarVisible: true,
                  columns: const [
                    DataColumn(
                      label: Text('اسم المادة'),
                    ),
                    DataColumn(
                      label: Text('السنة'),
                    ),
                    DataColumn(
                      label: Text('الفصل'),
                    ),
                    DataColumn(
                      label: Text('التفعيل'),
                    ),
                  ],
                  rows: [
                    DataRow2(
                      onTap: () {
                        context.goNamed(QuestionBanksPage.routeName);
                      },
                      cells: [
                        const DataCell(Text('كيمياء حيوية')),
                        const DataCell(Text('الثالثة')),
                        const DataCell(Text('الأول')),
                        DataCell(
                          Switch(
                            value: false,
                            onChanged: (newValue) {},
                            activeColor: colorScheme.primary,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
