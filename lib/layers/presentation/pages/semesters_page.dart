import 'package:flutter/material.dart';

class SemestersPage extends StatefulWidget {
  const SemestersPage({super.key});
  static const routeName = 'semesters';

  @override
  State<SemestersPage> createState() => _SemestersPageState();
}

class _SemestersPageState extends State<SemestersPage> {
  bool isExpanded = false;
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              // ExpansionPanelList(
              //   children: [
              //     ExpansionPanel(
              //       backgroundColor: colorScheme.background,
              //       headerBuilder: (context, isExpanded) {
              //         return Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Padding(
              //               padding: const EdgeInsets.all(8.0),
              //               child: Text(
              //                 'السنة الأولى',
              //                 style: textTheme.headlineSmall?.copyWith(
              //                   color: colorScheme.onBackground,
              //                   fontWeight: FontWeight.bold,
              //                 ),
              //               ),
              //             ),
              //             Switch(
              //               value: true,
              //               onChanged: (value) {},
              //               activeColor: colorScheme.primary,
              //             )
              //           ],
              //         );
              //       },
              //       body: Row(
              //         children: [
              //           Expanded(
              //             child: Column(
              //               mainAxisSize: MainAxisSize.min,
              //               children: [
              //                 Text(
              //                   '',
              //                   style: textTheme.headlineSmall,
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ],
              //       ),
              //     )
              //   ],
              // ),
              ExpansionTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'السنة الأولى',
                      style: textTheme.headlineSmall?.copyWith(
                        color: colorScheme.onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Switch(
                      onChanged: (value) {},
                      value: true,
                      activeColor: colorScheme.primary,
                    ),
                  ],
                ),
                backgroundColor: colorScheme.background,
                collapsedBackgroundColor: colorScheme.background,
                collapsedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                collapsedIconColor: colorScheme.onBackground,
                tilePadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                              padding: const EdgeInsets.only(right: 12),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Center(
                                    child: Text(
                                      'الفصل الأول',
                                      style: textTheme.bodyLarge?.copyWith(
                                        color: colorScheme.secondary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'المادة 1',
                                        style: textTheme.bodyLarge?.copyWith(
                                          color: colorScheme.onBackground,
                                        ),
                                      ),
                                      const SizedBox(width: 40),
                                      Switch(
                                        onChanged: (value) {},
                                        value: true,
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
                                  child: Text(
                                    'الفصل الثاني',
                                    style: textTheme.bodyLarge?.copyWith(
                                      color: colorScheme.secondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'المادة 1',
                                      style: textTheme.bodyLarge?.copyWith(
                                        color: colorScheme.onBackground,
                                      ),
                                    ),
                                    const SizedBox(width: 40),
                                    Switch(
                                      onChanged: (value) {},
                                      value: true,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
