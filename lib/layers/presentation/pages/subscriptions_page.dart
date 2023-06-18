import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class SubscriptionsPage extends StatelessWidget {
  const SubscriptionsPage({super.key});
  static const routeName = 'subscriptions';

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
                      'إضافة اشتراكات',
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
                      label: Text('تاريخ التوليد'),
                    ),
                    DataColumn(
                      label: Text('نوع الاشتراك'),
                    ),
                    DataColumn(
                      label: Text('المسؤول'),
                    ),
                  ],
                  rows: [
                    DataRow2(
                      onTap: () {},
                      cells: const [
                        DataCell(Text('12/3/2023')),
                        DataCell(Text('اشتراك فصل')),
                        DataCell(Text('عدنان الأحمد')),
                      ],
                    ),
                    const DataRow2(
                      cells: [
                        DataCell(Text('12/3/2023')),
                        DataCell(Text('اشتراك فصل')),
                        DataCell(Text('عدنان الأحمد')),
                      ],
                    ),
                    const DataRow2(
                      cells: [
                        DataCell(Text('12/3/2023')),
                        DataCell(Text('اشتراك فصل')),
                        DataCell(Text('عدنان الأحمد')),
                      ],
                    ),
                    const DataRow2(
                      cells: [
                        DataCell(Text('12/3/2023')),
                        DataCell(Text('اشتراك فصل')),
                        DataCell(Text('عدنان الأحمد')),
                      ],
                    )
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
