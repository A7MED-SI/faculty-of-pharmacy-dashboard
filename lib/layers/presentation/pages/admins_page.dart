import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class AdminsPage extends StatelessWidget {
  const AdminsPage({super.key});
  static const routeName = 'admins';

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
                      'إضافة مسؤول',
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
                      label: Text('الاسم'),
                    ),
                    DataColumn(
                      label: Text('اسم المستخدم'),
                    ),
                    DataColumn(
                      label: Text('كلمة المرور'),
                    ),
                    DataColumn(
                      label: Text('مفعل'),
                    ),
                  ],
                  rows: [
                    DataRow2(
                      onTap: () {},
                      cells: [
                        const DataCell(Text('أحمد الشيخ ابراهيم')),
                        const DataCell(Text('A7MED_SI')),
                        const DataCell(Text('Giea823lkajf')),
                        DataCell(
                          Switch(
                            value: false,
                            onChanged: (newValue) {},
                            activeColor: colorScheme.primary,
                          ),
                        )
                      ],
                    ),
                    DataRow2(
                      cells: [
                        const DataCell(Text('أحمد الشيخ ابراهيم')),
                        const DataCell(Text('A7MED_SI')),
                        const DataCell(Text('Giea823lkajf')),
                        DataCell(
                          Switch(
                            value: true,
                            onChanged: (newValue) {},
                            activeColor: colorScheme.primary,
                          ),
                        )
                      ],
                    ),
                    DataRow2(
                      cells: [
                        const DataCell(Text('أحمد الشيخ ابراهيم')),
                        const DataCell(Text('A7MED_SI')),
                        const DataCell(Text('Giea823lkajf')),
                        DataCell(
                          Switch(
                            value: true,
                            onChanged: (newValue) {},
                            activeColor: colorScheme.primary,
                          ),
                        )
                      ],
                    ),
                    DataRow2(
                      cells: [
                        const DataCell(Text('أحمد الشيخ ابراهيم')),
                        const DataCell(Text('A7MED_SI')),
                        const DataCell(Text('Giea823lkajf')),
                        DataCell(
                          Switch(
                            value: true,
                            onChanged: (newValue) {},
                            activeColor: colorScheme.primary,
                          ),
                        )
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
