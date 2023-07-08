import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/year_semester/get_year_semesters.dart';
import 'package:pharmacy_dashboard/layers/presentation/blocs/year_semester/year_semester_bloc.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/loading_widget.dart';

class SemestersPage extends StatefulWidget {
  const SemestersPage({super.key});
  static const routeName = 'semesters';

  @override
  State<SemestersPage> createState() => _SemestersPageState();
}

class _SemestersPageState extends State<SemestersPage> {
  late final YearSemesterBloc _yearSemesterBloc;

  @override
  void initState() {
    super.initState();
    _yearSemesterBloc = YearSemesterBloc();
    _yearSemesterBloc.add(
        YearSemesterFetched(getYearSemestersParams: GetYearSemestersParams()));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    // ignore: unused_local_variable
    final size = MediaQuery.of(context).size;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colorScheme.surfaceVariant,
        body: BlocBuilder<YearSemesterBloc, YearSemesterState>(
          bloc: _yearSemesterBloc,
          builder: (context, state) {
            return state.yearSemestersFetchingStatus ==
                    YearSemestersFetchingStatus.initial
                ? const LoadingWidget()
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (var yearSemester in state.yearSemesters)
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 20),
                              child: ExpansionTile(
                                title: Text(
                                  yearSemester.arabicName,
                                  style: textTheme.headlineSmall?.copyWith(
                                    color: colorScheme.onBackground,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                backgroundColor: colorScheme.background,
                                collapsedBackgroundColor:
                                    colorScheme.background,
                                collapsedShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                collapsedIconColor: colorScheme.onBackground,
                                tilePadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                iconColor: colorScheme.onBackground,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                children: [
                                  IntrinsicHeight(
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 12),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Center(
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          yearSemester
                                                              .semesters[0]
                                                              .arabicName,
                                                          style: textTheme
                                                              .headlineSmall
                                                              ?.copyWith(
                                                            color: colorScheme
                                                                .onBackground,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        Switch(
                                                          onChanged: (value) {},
                                                          value: true,
                                                          activeColor:
                                                              colorScheme
                                                                  .primary,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Divider(
                                                      indent: 40,
                                                      endIndent: 40),
                                                  const SizedBox(height: 8),
                                                  for (var subject
                                                      in yearSemester
                                                          .semesters[0]
                                                          .subjects)
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          subject.title,
                                                          style: textTheme
                                                              .bodyLarge
                                                              ?.copyWith(
                                                            color: colorScheme
                                                                .onBackground,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 20),
                                                        Switch(
                                                          onChanged: (value) {},
                                                          value: subject
                                                                  .isActive ==
                                                              1,
                                                        ),
                                                      ],
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          VerticalDivider(
                                            color: colorScheme.onBackground,
                                            width: 0.5,
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Center(
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        yearSemester
                                                            .semesters[1]
                                                            .arabicName,
                                                        style: textTheme
                                                            .headlineSmall
                                                            ?.copyWith(
                                                          color: colorScheme
                                                              .onBackground,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Switch(
                                                        onChanged: (value) {},
                                                        value: true,
                                                        activeColor:
                                                            colorScheme.primary,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Divider(
                                                    indent: 40, endIndent: 40),
                                                const SizedBox(height: 8),
                                                for (var subject in yearSemester
                                                    .semesters[1].subjects)
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        subject.title,
                                                        style: textTheme
                                                            .bodyLarge
                                                            ?.copyWith(
                                                          color: colorScheme
                                                              .onBackground,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 20),
                                                      Switch(
                                                        onChanged: (value) {},
                                                        value:
                                                            subject.isActive ==
                                                                1,
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                        ],
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
