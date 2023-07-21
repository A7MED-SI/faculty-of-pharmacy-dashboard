import 'dart:ui';

import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_dashboard/core/apis/qr_pdf_api.dart';
import 'package:pharmacy_dashboard/core/layout/adaptive.dart';
import 'package:pharmacy_dashboard/layers/data/models/subscription/subscription.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/subscriptions/add_subscription_group.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/app_elevated_button.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/loading_widget.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/subscriptions/get_subscriptions.dart';
import 'package:pharmacy_dashboard/layers/presentation/blocs/subscription/subscription_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
  final subsTypes = [
    (
      text: SubscriptionableType.typeInArabic(SubscriptionableType.all.value),
      type: SubscriptionableType.all
    ),
    (
      text: SubscriptionableType.typeInArabic(
          SubscriptionableType.yearSemester.value),
      type: SubscriptionableType.yearSemester
    ),
    (
      text:
          SubscriptionableType.typeInArabic(SubscriptionableType.subject.value),
      type: SubscriptionableType.subject
    ),
  ];
  late final SubscriptionBloc _subscriptionBloc;
  late final ValueNotifier<int> subTypeNotifier;

  @override
  void initState() {
    super.initState();
    _subscriptionBloc = SubscriptionBloc();
    _subscriptionBloc
        .add(SubscriptionsFetched(params: GetSubscriptoinsParams()));
    subTypeNotifier = ValueNotifier(subsTypes.first.type.value);
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
              AppWidgetsDisplayer.dispalySuccessSnackBar(
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
                            const SizedBox(width: 40),
                            SizedBox(
                              width: 220,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'نوع الاشتراك:',
                                    style: textTheme.bodyLarge?.copyWith(
                                        color: colorScheme.onBackground),
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
                                                borderRadius:
                                                    BorderRadius.circular(12),
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
                                                _subscriptionBloc.add(
                                                    SubscriptionsFetched(
                                                        params:
                                                            GetSubscriptoinsParams(
                                                  subscriptionableType: value ==
                                                          -1
                                                      ? null
                                                      : subTypeNotifier.value
                                                          .toString(),
                                                )));
                                              }
                                            },
                                            buttonStyleData:
                                                const ButtonStyleData(
                                              height: 40,
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              overlayColor:
                                                  MaterialStatePropertyAll(
                                                      Colors.transparent),
                                            ),
                                            iconStyleData: const IconStyleData(
                                              icon: Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors.black45,
                                              ),
                                              iconSize: 30,
                                            ),
                                            dropdownStyleData:
                                                DropdownStyleData(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            if (state.selection
                                .reduce((value, element) => value | element))
                              AppTextButton(
                                onPressed: () async {
                                  await downloadQrPdf(
                                    subscriptions: state.subscriptions,
                                    selection: state.selection,
                                  );
                                },
                                text: 'توليد ملف رموز',
                              ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: PaginatedDataTable2(
                            renderEmptyRowsInTheEnd: false,
                            columns: [
                              DataColumn(
                                label: Text(
                                  'نوع الاشتراك',
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onBackground,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'الكود',
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onBackground,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                            onSelectAll: (value) {
                              if (value != null) {
                                _subscriptionBloc
                                    .add(AllSelectedChanged(value));
                              }
                            },
                            source: SubscriptionsTableDataSource(
                              subscriptions: state.subscriptions,
                              subscriptionBloc: _subscriptionBloc,
                              selection: state.selection,
                              colorScheme: colorScheme,
                              textTheme: textTheme,
                            ),
                            rowsPerPage: 10,
                            empty: Center(
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                color: Colors.grey[200],
                                child: const Text('No data'),
                              ),
                            ),
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

Future<void> downloadQrPdf({
  required List<Subscription> subscriptions,
  required List<bool> selection,
}) async {
  final List<String> selectedSubCodes = [];
  final List<String> selectedSubTypes = [];
  for (int i = 0; i < subscriptions.length; i++) {
    if (selection[i]) {
      selectedSubCodes.add(subscriptions[i].subCode);
      selectedSubTypes.add(SubscriptionableType.typeInEnglish(
          subscriptions[i].subscriptionableType));
    }
  }

  final List<Uint8List> qrImages = [];
  for (int i = 0; i < selectedSubCodes.length; i++) {
    final qrPainter = QrPainter(
        data: selectedSubCodes[i],
        version: QrVersions.auto,
        gapless: false,
        dataModuleStyle: const QrDataModuleStyle(
          color: Colors.black,
        ));
    final image = await qrPainter.toImage(150);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    final buffer = byteData!.buffer;
    qrImages.add(buffer.asUint8List());
  }
  await QrPdfApi.generateThenDownload(
    qrImages: qrImages,
    subTypes: selectedSubTypes,
  );
}

class SubscriptionsTableDataSource extends DataTableSource {
  SubscriptionsTableDataSource({
    required this.subscriptions,
    required this.subscriptionBloc,
    required this.colorScheme,
    required this.textTheme,
    required this.selection,
  });

  final List<Subscription> subscriptions;
  final SubscriptionBloc subscriptionBloc;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final List<bool> selection;

  @override
  int get selectedRowCount => 0;
  @override
  DataRow? getRow(int index) {
    return DataRow.byIndex(
      index: index,
      selected: selection[index],
      onSelectChanged: (value) {
        if (value != null) {
          subscriptionBloc.add(RowSelectionToggled(index));
        }
      },
      cells: [
        DataCell(Text(
          SubscriptionableType.typeInArabic(
              subscriptions[index].subscriptionableType),
          style: textTheme.bodyMedium!.copyWith(
            color: colorScheme.onBackground,
          ),
        )),
        DataCell(SelectableText(
          subscriptions[index].subCode,
          style: textTheme.bodyMedium!.copyWith(
            color: colorScheme.onBackground,
          ),
        )),
      ],
    );
  }

  @override
  int get rowCount => subscriptions.length;

  @override
  bool get isRowCountApproximate => false;
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
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    subTypeNotifier = ValueNotifier(subsTypes.first.type.value);
    subsNumberController = TextEditingController(text: '1');
    subsNumberController.selection = TextSelection(
        baseOffset: 0, extentOffset: subsNumberController.text.length);
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
          child: Form(
            key: _formKey,
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
                        child: TextFormField(
                          autofocus: true,
                          controller: subsNumberController,
                          maxLength: 2,
                          style: textTheme.bodyLarge,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يجب إدخال عدد الإشتراكات';
                            }
                            return null;
                          },
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
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
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
      ),
    );
  }
}
