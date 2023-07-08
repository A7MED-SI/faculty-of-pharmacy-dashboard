import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_dashboard/core/layout/adaptive.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/subscriptions/add_subscription_group.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/app_elevated_button.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/loading_widget.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/subscriptions/get_subscriptions.dart';
import 'package:pharmacy_dashboard/layers/presentation/blocs/subscription/subscription_bloc.dart';
import 'package:intl/intl.dart' as intl;

import '../../../core/constants/api_enums/api_enums.dart';
import '../AppWidgetsDisplayer.dart';
import '../widgets/app_text_button.dart';

class SubscriptionsPage extends StatefulWidget {
  const SubscriptionsPage({super.key});
  static const routeName = 'subscriptions';

  @override
  State<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  late final SubscriptionBloc _subscriptionBloc;

  @override
  void initState() {
    super.initState();
    _subscriptionBloc = SubscriptionBloc();
    _subscriptionBloc
        .add(SubscriptionsFetched(params: GetSubscriptoinsParams()));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colorScheme.surfaceVariant,
        body: BlocConsumer<SubscriptionBloc, SubscriptionState>(
          listener: (context, state) {
            if (state.subsAddingStatus == SubsAddingStatus.failed) {
              AppWidgetsDisplayer.dispalyErrorSnackBar(
                context: context,
                message:
                    'فشل الإضافة يرجى التحقق من الإتصال من الإنترنت والمحاولة مرة أخرى',
              );
            }
            if (state.subsAddingStatus == SubsAddingStatus.success) {
              AppWidgetsDisplayer.dispalyErrorSnackBar(
                context: context,
                message: 'تمت إضافة الإشتراكات بنجاح',
              );
            }
          },
          bloc: _subscriptionBloc,
          builder: (context, state) {
            return state.subsFetchingStatus == SubsFetchingStatus.initial ||
                    state.subsFetchingStatus == SubsFetchingStatus.loading
                ? const LoadingWidget()
                : Container(
                    margin: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            AppTextButton(
                              text: 'إضافة اشتراكات',
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return _AddSubsDialog(
                                        subscriptionBloc: _subscriptionBloc,
                                      );
                                    });
                              },
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
                                label: Text('نوع الاشتراك'),
                              ),
                              DataColumn(
                                label: Text('المسؤول'),
                              ),
                              DataColumn(
                                label: Text('تاريخ البدء'),
                              ),
                              DataColumn(
                                label: Text('تاريخ الإنتهاء'),
                              ),
                            ],
                            rows: [
                              for (var sub in state.subscriptions)
                                DataRow2(
                                  onTap: () {},
                                  cells: [
                                    const DataCell(Text('اشتراك فصل')),
                                    const DataCell(Text('عدنان الأحمد')),
                                    DataCell(Text(intl.DateFormat.yMd().format(
                                        sub.startDate ?? DateTime.now()))),
                                    DataCell(Text(intl.DateFormat.yMd().format(
                                        sub.endDate ?? DateTime.now()))),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}

class _AddSubsDialog extends StatefulWidget {
  const _AddSubsDialog({
    required this.subscriptionBloc,
  });
  final SubscriptionBloc subscriptionBloc;
  @override
  State<_AddSubsDialog> createState() => _AddSubsDialogState();
}

class _AddSubsDialogState extends State<_AddSubsDialog> {
  final subsTypes = [
    (text: 'فصل', type: SubscriptionableType.yearSemester),
    (text: 'مادة', type: SubscriptionableType.subject)
  ];
  late final ValueNotifier<int> subTypeNotifier;
  late final TextEditingController subsNumberController;

  @override
  void initState() {
    super.initState();
    subTypeNotifier = ValueNotifier(subsTypes.first.type.value);
    subsNumberController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDesktop = isDisplayDesktop(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      insetPadding: isDesktop
          ? const EdgeInsets.symmetric(horizontal: 300)
          : const EdgeInsets.symmetric(horizontal: 60),
      backgroundColor: colorScheme.background,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'إضافة اشتراكات',
                  style: textTheme.headlineSmall?.copyWith(
                    color: colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 250,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'عدد الاشتراكات:',
                      style: textTheme.bodyLarge
                          ?.copyWith(color: colorScheme.onBackground),
                    ),
                    SizedBox(
                      width: 140,
                      child: TextField(
                        controller: subsNumberController,
                        maxLength: 2,
                        style: textTheme.bodyLarge,
                        decoration: const InputDecoration(
                          isCollapsed: true,
                          counterText: '',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 250,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'نوع الاشتراك:',
                      style: textTheme.bodyLarge
                          ?.copyWith(color: colorScheme.onBackground),
                    ),
                    SizedBox(
                      width: 140,
                      child: ValueListenableBuilder<int>(
                          valueListenable: subTypeNotifier,
                          builder: (context, value, _) {
                            return DropdownButtonFormField2<int>(
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              style: textTheme.bodyLarge,
                              value: value,
                              items: [
                                for (var subType in subsTypes)
                                  DropdownMenuItem(
                                    value: subType.type.value,
                                    child: Text(subType.text),
                                  ),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  subTypeNotifier.value = value;
                                }
                              },
                              buttonStyleData: const ButtonStyleData(
                                height: 40,
                                padding: EdgeInsets.only(left: 10, right: 10),
                                overlayColor: MaterialStatePropertyAll(
                                    Colors.transparent),
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
                            );
                          }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: Text(
                        'إلغاء',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    AppElevatedButton(
                      onPressed: () {
                        widget.subscriptionBloc.add(SubscriptionGroupAdded(
                            params: AddSubscriptoinGroupParams(
                          subCount: int.parse(subsNumberController.text),
                          subscriptionableType: subTypeNotifier.value,
                        )));
                        context.pop();
                      },
                      text: 'إضافة',
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
