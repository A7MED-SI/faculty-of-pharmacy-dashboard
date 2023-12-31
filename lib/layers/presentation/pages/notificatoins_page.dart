// ignore_for_file: unnecessary_overrides
import 'dart:js' as js;
import 'dart:typed_data';
import 'package:data_table_2/data_table_2.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/notification/get_notifications.dart';
import 'package:pharmacy_dashboard/layers/presentation/AppWidgetsDisplayer.dart';
import 'package:pharmacy_dashboard/layers/presentation/blocs/notification/notification_bloc.dart';
import 'package:pharmacy_dashboard/layers/data/models/notification/notification.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/app_error_widget.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/loading_widget.dart';

import '../../../core/global_functions/global_purpose_functions.dart';
import '../../../core/layout/adaptive.dart';
import '../../domain/use_cases/notification/add_notification.dart';
import '../widgets/app_elevated_button.dart';
import '../widgets/app_text_button.dart';
import '../widgets/delete_confirmation_dialog.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});
  static const routeName = 'notifications';

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late final NotificationBloc _notificationBloc;
  late final PaginatorController _paginatorController;
  final perPageNumbers = [10, 30, 50];
  late final ValueNotifier<int> currentPerPageNotifier;
  var currentPage = 1;
  @override
  void initState() {
    super.initState();
    _notificationBloc = NotificationBloc();
    _paginatorController = PaginatorController();
    currentPerPageNotifier = ValueNotifier(perPageNumbers[0]);
    _notificationBloc.add(NotificationsFetched(
        getNotificationsParams: GetNotificationsParams(
      page: 1,
      perPage: currentPerPageNotifier.value,
    )));
  }

  @override
  void dispose() {
    _paginatorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // ignore: unused_local_variable
    final textTheme = Theme.of(context).textTheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colorScheme.surfaceVariant,
        body: BlocConsumer<NotificationBloc, NotificationState>(
          listener: (context, state) {
            if (state.addingNotificationStatus ==
                AddingNotificationStatus.failed) {
              AppWidgetsDisplayer.displayErrorSnackBar(
                context: context,
                message: state.errorMessage ??
                    'فشل الإرسال يرجى التحقق من الإنترنت والمحاولة مرة أخرى',
              );
            }
            if (state.addingNotificationStatus ==
                AddingNotificationStatus.success) {
              AppWidgetsDisplayer.displaySuccessSnackBar(
                context: context,
                message: 'تم إرسال الإشعار بنجاح',
              );
            }
            if (state.deletingNotificationStatus ==
                DeletingNotificationStatus.failed) {
              AppWidgetsDisplayer.displayErrorSnackBar(
                context: context,
                message: state.errorMessage ??
                    'فشل الحذف يرجى التحقق من الإنترنت والمحاولة مرة أخرى',
              );
            }
            if (state.deletingNotificationStatus ==
                DeletingNotificationStatus.success) {
              AppWidgetsDisplayer.displaySuccessSnackBar(
                context: context,
                message: 'تم حذف الإشعار بنجاح',
              );
            }
          },
          bloc: _notificationBloc,
          builder: (context, state) {
            return state.notificationsFetchingStatus ==
                        NotificationsFetchingStatus.initial ||
                    state.notificationsFetchingStatus ==
                        NotificationsFetchingStatus.loading
                ? const LoadingWidget()
                : state.notificationsFetchingStatus ==
                        NotificationsFetchingStatus.failed
                    ? AppErrorWidget(
                        onRefreshPressed: () {
                          _notificationBloc.add(NotificationsFetched(
                              getNotificationsParams: GetNotificationsParams(
                            page: currentPage,
                            perPage: currentPerPageNotifier.value,
                          )));
                        },
                      )
                    : Container(
                        margin: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Spacer(),
                                AppTextButton(
                                  text: 'إرسال إشعار',
                                  onPressed: () {
                                    final currentAdmin =
                                        GlobalPurposeFunctions.getAdminModel()!;
                                    if (!currentAdmin.isSuperAdmin &&
                                        !currentAdmin.canAddQuestionFromExcel) {
                                      showToast(
                                        'ليس لديك الصلاحية لإرسال إشعار',
                                        position: const ToastPosition(
                                            align: Alignment.bottomCenter),
                                      );
                                      return;
                                    }
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return _SendNotificationDialog(
                                          notificationBloc: _notificationBloc,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Expanded(
                              child: ValueListenableBuilder<int>(
                                  valueListenable: currentPerPageNotifier,
                                  builder: (context, currentValue, _) {
                                    return PaginatedDataTable2(
                                      minWidth: 650,
                                      columns: [
                                        DataColumn(
                                          label: Text(
                                            'العنوان',
                                            style:
                                                textTheme.bodyLarge?.copyWith(
                                              color: colorScheme.onBackground,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'النص',
                                            style:
                                                textTheme.bodyLarge?.copyWith(
                                              color: colorScheme.onBackground,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const DataColumn(label: Text('')),
                                        const DataColumn(label: Text('')),
                                      ],
                                      source: NotificationTableDataSource(
                                        notifications: state.notifications,
                                        notificationBloc: _notificationBloc,
                                        colorScheme: colorScheme,
                                        textTheme: textTheme,
                                        context: context,
                                        totalRowCount:
                                            state.totalNotificationsNumber,
                                        perPageNumber: currentValue,
                                      ),
                                      rowsPerPage: currentValue,
                                      onPageChanged: (value) {
                                        currentPage = value ~/ currentValue + 1;
                                        _notificationBloc.add(
                                            NotificationsFetched(
                                                getNotificationsParams:
                                                    GetNotificationsParams(
                                          page: currentPage,
                                          perPage: currentValue,
                                        )));
                                      },
                                      onRowsPerPageChanged: (value) async {
                                        if (value != null) {
                                          _notificationBloc.add(
                                              NotificationsFetched(
                                                  getNotificationsParams:
                                                      GetNotificationsParams(
                                            page: currentPage,
                                            perPage: value,
                                          )));
                                          await Future.delayed(
                                              const Duration(seconds: 2));
                                          currentPerPageNotifier.value = value;
                                        }
                                      },
                                      availableRowsPerPage: perPageNumbers,
                                      empty: Center(
                                        child: Container(
                                          padding: const EdgeInsets.all(20),
                                          color: Colors.grey[200],
                                          child: const Text(
                                              'لا يوجد أي إشعارات مرسلة'),
                                        ),
                                      ),
                                    );
                                  }),
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

class NotificationTableDataSource extends DataTableSource {
  NotificationTableDataSource({
    required this.notifications,
    required this.notificationBloc,
    required this.colorScheme,
    required this.textTheme,
    required this.context,
    required this.totalRowCount,
    required this.perPageNumber,
  });

  final List<NotificationModel> notifications;
  final NotificationBloc notificationBloc;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final BuildContext context;
  final int totalRowCount;
  final int perPageNumber;

  @override
  int get selectedRowCount => 0;
  @override
  DataRow? getRow(int index) {
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(
          notifications[index % perPageNumber].title,
          style: textTheme.bodyMedium!.copyWith(
            color: colorScheme.onBackground,
          ),
        )),
        DataCell(Text(
          notifications[index % perPageNumber].body,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodyMedium!.copyWith(
            color: colorScheme.onBackground,
          ),
        )),
        DataCell(
          notifications[index % perPageNumber].image != null
              ? ElevatedButton(
                  onPressed: () {
                    js.context.callMethod(
                        'open', [notifications[index % perPageNumber].image]);
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(colorScheme.primary),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)))),
                  child: Text(
                    'فتح الصورة',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimary,
                    ),
                  ),
                )
              : Container(),
        ),
        DataCell(
          PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            tooltip: 'خيارات',
            onSelected: (value) async {
              if (value == 'resend') {
                showDialog(
                  context: context,
                  builder: (context) {
                    return _SendNotificationDialog(
                      notificationBloc: notificationBloc,
                      notification: notifications[index % perPageNumber],
                    );
                  },
                );
              } else {
                final result = await showDialog<bool?>(
                  context: context,
                  builder: (context) {
                    return const DeleteConfirmationDialog(
                      text: 'هل أنت متأكد أنك تريد حذف هذا الإشعار؟',
                    );
                  },
                );
                if (result != null && result) {
                  notificationBloc.add(NotificationDeleted(
                      notificationId: notifications[index % perPageNumber].id));
                }
              }
            },
            splashRadius: 30,
            itemBuilder: (context) => <PopupMenuItem<String>>[
              const PopupMenuItem<String>(
                value: 'resend',
                child: Text(
                  'إعادة إرسال',
                ),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text(
                  'حذف',
                ),
              ),
            ],
            child: const Icon(Icons.more_vert_outlined),
          ),
        ),
      ],
    );
  }

  @override
  int get rowCount => totalRowCount;

  @override
  bool get isRowCountApproximate => false;
}

class _SendNotificationDialog extends StatefulWidget {
  const _SendNotificationDialog({
    required this.notificationBloc,
    this.notification,
  });
  final NotificationBloc notificationBloc;
  final NotificationModel? notification;
  @override
  State<_SendNotificationDialog> createState() =>
      _SendNotificationDialogState();
}

class _SendNotificationDialogState extends State<_SendNotificationDialog> {
  late final TextEditingController titleController;
  late final TextEditingController bodyController;
  late final ValueNotifier<Uint8List?> imageNotifier;
  String? imageExtension;
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.notification?.title);
    bodyController = TextEditingController(text: widget.notification?.body);
    imageNotifier = ValueNotifier(null);
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
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
          : const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: colorScheme.background,
      child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            child: ValueListenableBuilder(
                valueListenable: imageNotifier,
                builder: (context, image, _) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'إرسال إشعار',
                            style: textTheme.headlineSmall?.copyWith(
                              color: colorScheme.onBackground,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'العنوان:',
                                style: textTheme.bodyLarge
                                    ?.copyWith(color: colorScheme.onBackground),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                controller: titleController,
                                style: textTheme.bodyLarge,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'يجب ادخال العنوان';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  isCollapsed: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 11),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'النص:',
                                style: textTheme.bodyLarge
                                    ?.copyWith(color: colorScheme.onBackground),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                controller: bodyController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                maxLines: null,
                                style: textTheme.bodyLarge,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'يجب ادخال نص الإشعار';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  isCollapsed: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 11),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (image == null)
                          Center(
                            child: TextButton(
                              onPressed: () async {
                                final FilePickerResult? result =
                                    await FilePickerWeb.platform.pickFiles(
                                  type: FileType.image,
                                );
                                if (result != null) {
                                  imageNotifier.value =
                                      result.files.first.bytes!;
                                  imageExtension = result.files.first.extension;
                                }
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: colorScheme.primaryContainer,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'اختيار صورة',
                                    style: textTheme.bodyLarge?.copyWith(
                                      color: colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.image,
                                    color: colorScheme.onPrimaryContainer,
                                  )
                                ],
                              ),
                            ),
                          ),
                        if (image != null)
                          Center(
                            child: Stack(
                              children: [
                                Image.memory(
                                  image,
                                  width: 200,
                                  height: 150,
                                  fit: BoxFit.fill,
                                ),
                                Positioned(
                                  left: 4,
                                  top: 4,
                                  child: Tooltip(
                                    message: 'حذف الصورة',
                                    child: InkWell(
                                      onTap: () {
                                        imageNotifier.value = null;
                                        imageExtension = null;
                                      },
                                      child: Icon(
                                        Icons.cancel,
                                        color: colorScheme.secondary,
                                        size: 20,
                                      ),
                                    ),
                                  ),
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
                                  widget.notificationBloc.add(NotificationAdded(
                                      addNotificationParams:
                                          AddNotificationParams(
                                    title: titleController.text,
                                    body: bodyController.text,
                                    image: imageNotifier.value,
                                    imageName: 'image.$imageExtension',
                                  )));
                                  context.pop();
                                },
                                text: 'إرسال',
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }),
          )),
    );
  }
}
