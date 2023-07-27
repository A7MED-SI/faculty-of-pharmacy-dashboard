import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_dashboard/core/layout/adaptive.dart';
import 'package:pharmacy_dashboard/layers/data/models/statistics/statistics.dart';
import 'package:pharmacy_dashboard/layers/presentation/blocs/dashboard/dashboard_bloc.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/loading_widget.dart';

import '../../../core/charts/pie_chart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  static const routeName = 'dashboard';

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final DashboardBloc _dashboardBloc;

  @override
  void initState() {
    super.initState();
    _dashboardBloc = DashboardBloc();
    _dashboardBloc.add(StatisticsFetched());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocProvider(
      create: (context) => _dashboardBloc,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            backgroundColor: colorScheme.surfaceVariant,
            body: BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, state) {
                return state.statisticsFetchingStatus ==
                            StatisticsFetchingStatus.initial ||
                        state.statisticsFetchingStatus ==
                            StatisticsFetchingStatus.loading
                    ? const LoadingWidget()
                    : StatisticsCardsLayout(
                        key: UniqueKey(),
                        statisticsNumbers: state.currentStatisticsNumbers!,
                        currentChosenValue: state.currentChosenValue,
                      );
              },
            )),
      ),
    );
  }
}

class StatisticsCardsLayout extends StatefulWidget {
  const StatisticsCardsLayout({
    super.key,
    required this.statisticsNumbers,
    required this.currentChosenValue,
  });
  final StatisticsNumbers statisticsNumbers;
  final int currentChosenValue;

  @override
  State<StatisticsCardsLayout> createState() => _StatisticsCardsLayoutState();
}

class _StatisticsCardsLayoutState extends State<StatisticsCardsLayout> {
  final colorsInOrder = [Colors.orange, Colors.blue, Colors.amberAccent];
  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(right: 10),
            width: 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'وقت الإحصاء:',
                  style: textTheme.bodyLarge
                      ?.copyWith(color: colorScheme.onBackground),
                ),
                SizedBox(
                  width: 200,
                  child: DropdownButtonFormField2<int>(
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    style: textTheme.bodyLarge,
                    value: widget.currentChosenValue,
                    items: const [
                      DropdownMenuItem(
                        value: 0,
                        child: Text('اخر 30 يوم'),
                      ),
                      DropdownMenuItem(
                        value: 1,
                        child: Text('اخر 6 أشهر'),
                      ),
                      DropdownMenuItem(
                        value: 2,
                        child: Text('السنة الحالية'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        context
                            .read<DashboardBloc>()
                            .add(StatisticsNumbersValueChanged(value));
                      }
                    },
                    buttonStyleData: const ButtonStyleData(
                      height: 40,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      overlayColor:
                          MaterialStatePropertyAll(Colors.transparent),
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 30,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: StatisticsCard(
                        categoriesAmounts: [
                          widget.statisticsNumbers.newSubscribeInSubject,
                          widget.statisticsNumbers.newSubscribeInSemester
                        ],
                        categoriesLabels: const ['اشتراك مادة', 'اشتراك فصل'],
                        colorsInOrder: colorsInOrder,
                        heroLabel: 'الاشتراكات',
                        totalAmount:
                            widget.statisticsNumbers.newSubscribeInSubject +
                                widget.statisticsNumbers.newSubscribeInSemester,
                      ),
                    ),
                    Expanded(
                      child: StatisticsCard(
                        categoriesAmounts: [widget.statisticsNumbers.newUser],
                        categoriesLabels: const [
                          'مستخدم جديد',
                        ],
                        colorsInOrder: colorsInOrder,
                        heroLabel: 'المستخدمون الجدد',
                        totalAmount: widget.statisticsNumbers.newUser,
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StatisticsCard(
                      categoriesAmounts: [
                        widget.statisticsNumbers.newSubscribeInSubject,
                        widget.statisticsNumbers.newSubscribeInSemester
                      ],
                      categoriesLabels: const ['اشتراك مادة', 'اشتراك فصل'],
                      colorsInOrder: colorsInOrder,
                      heroLabel: 'الاشتراكات',
                      totalAmount:
                          widget.statisticsNumbers.newSubscribeInSubject +
                              widget.statisticsNumbers.newSubscribeInSemester,
                    ),
                    StatisticsCard(
                      categoriesAmounts: [widget.statisticsNumbers.newUser],
                      categoriesLabels: const [
                        'مستخدم جديد',
                      ],
                      colorsInOrder: colorsInOrder,
                      heroLabel: 'المستخدمون الجدد',
                      totalAmount: widget.statisticsNumbers.newUser,
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

class StatisticsCard extends StatelessWidget {
  const StatisticsCard({
    super.key,
    required this.categoriesAmounts,
    required this.categoriesLabels,
    required this.heroLabel,
    required this.totalAmount,
    required this.colorsInOrder,
  });
  final String heroLabel;
  final List<String> categoriesLabels;
  final List<int> categoriesAmounts;
  final List<Color> colorsInOrder;
  final int totalAmount;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDesktop = isDisplayDesktop(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: isDesktop ? 400 : 300,
                maxWidth: isDesktop ? 300 : 250,
              ),
              child: RallyPieChart(
                heroLabel: heroLabel,
                heroAmount: totalAmount.toDouble(),
                wholeAmount: totalAmount.toDouble(),
                segments: [
                  for (int i = 0; i < categoriesAmounts.length; i++)
                    RallyPieChartSegment(
                      color: colorsInOrder[i],
                      value: categoriesAmounts[i].toDouble(),
                    ),
                ],
              ),
            ),
            for (int i = 0; i < categoriesLabels.length; i++)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    onTap: () {},
                    leading: Container(
                      width: 4,
                      height: 40,
                      color: colorsInOrder[i],
                    ),
                    title: Text(
                      categoriesLabels[i],
                      style: textTheme.bodyLarge,
                    ),
                    subtitle: Text(categoriesAmounts[i].toString()),
                  ),
                  if (i < categoriesLabels.length - 1)
                    const Divider(
                      endIndent: 6,
                      indent: 6,
                    )
                ],
              ),
          ],
        ),
      ),
    );
  }
}
