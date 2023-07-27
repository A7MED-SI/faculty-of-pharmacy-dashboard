// ignore_for_file: unused_element

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_dashboard/core/validations/validations.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/app_error_widget.dart';
import '../../data/models/login_response/login_response.dart';
import '../../domain/use_cases/admin/add_admin.dart';
import '../../domain/use_cases/admin/update_admin.dart';
import '../AppWidgetsDisplayer.dart';
import '../widgets/app_text_button.dart';
import '../widgets/delete_confirmation_dialog.dart';
import '../widgets/loading_widget.dart';
import '../../domain/use_cases/admin/get_admins.dart';
import '../blocs/admin/admin_bloc.dart';

import '../../../core/layout/adaptive.dart';
import '../widgets/app_elevated_button.dart';

class AdminsPage extends StatefulWidget {
  const AdminsPage({super.key});
  static const routeName = 'admins';

  @override
  State<AdminsPage> createState() => _AdminsPageState();
}

class _AdminsPageState extends State<AdminsPage> {
  late final TextEditingController userNameController;
  late final AdminBloc _adminBloc;
  @override
  void initState() {
    super.initState();
    _adminBloc = AdminBloc();
    _adminBloc.add(AdminsFetched(getAdminsParams: GetAdminsParams()));
    userNameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDesktop = isDisplayDesktop(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colorScheme.surfaceVariant,
        body: BlocConsumer<AdminBloc, AdminState>(
          listener: (context, state) {
            if (state.togglingStatus == TogglingStatus.failed) {
              AppWidgetsDisplayer.dispalyErrorSnackBar(
                context: context,
                message:
                    'فشل التغيير يرجى التحقق من الإتصال من الإنترنت والمحاولة مرة أخرى',
              );
            }
            if (state.addingStatus == AddingStatus.failed) {
              AppWidgetsDisplayer.dispalyErrorSnackBar(
                context: context,
                message:
                    'فشل الإضافة يرجى التحقق من الإتصال من الإنترنت والمحاولة مرة أخرى',
              );
            }
            if (state.addingStatus == AddingStatus.success) {
              AppWidgetsDisplayer.dispalySuccessSnackBar(
                context: context,
                message: 'تمت إضافة المسؤول بنجاح',
              );
            }
            if (state.updatingStatus == UpdatingStatus.failed) {
              AppWidgetsDisplayer.dispalyErrorSnackBar(
                context: context,
                message:
                    'فشل التعديل يرجى التحقق من الإتصال من الإنترنت والمحاولة مرة أخرى',
              );
            }
            if (state.updatingStatus == UpdatingStatus.success) {
              AppWidgetsDisplayer.dispalySuccessSnackBar(
                context: context,
                message: 'تم تعديل المسؤول بنجاح',
              );
            }
            if (state.deletingStatus == DeletingStatus.failed) {
              AppWidgetsDisplayer.dispalyErrorSnackBar(
                context: context,
                message:
                    'فشل الحذف يرجى التحقق من الإتصال من الإنترنت والمحاولة مرة أخرى',
              );
            }
            if (state.deletingStatus == DeletingStatus.success) {
              AppWidgetsDisplayer.dispalySuccessSnackBar(
                context: context,
                message: 'تم حذف المسؤول بنجاح',
              );
            }
          },
          bloc: _adminBloc,
          builder: (context, state) {
            return Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 200,
                        child: TextField(
                          autofocus: true,
                          controller: userNameController,
                          style: textTheme.bodyLarge,
                          onChanged: (text) {
                            _adminBloc.add(AdminsFetched(
                                getAdminsParams: GetAdminsParams(
                              username: text == '' ? null : text,
                            )));
                          },
                          decoration: InputDecoration(
                            hintText: 'اسم المستخدم',
                            hintStyle: textTheme.bodyMedium,
                            suffixIcon: const Icon(Icons.search),
                            isCollapsed: true,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12),
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (isDesktop)
                        AppTextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return _AddUpdateAdminDialog(
                                    adminBloc: _adminBloc,
                                  );
                                });
                          },
                          text: 'إضافة مسؤول',
                        ),
                    ],
                  ),
                  if (!isDesktop) const SizedBox(height: 8),
                  if (!isDesktop)
                    AppTextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return _AddUpdateAdminDialog(
                                adminBloc: _adminBloc,
                              );
                            });
                      },
                      text: 'إضافة مسؤول',
                    ),
                  const SizedBox(height: 20),
                  state.adminsFetchingStatus == AdminsFetchingStatus.initial ||
                          state.adminsFetchingStatus ==
                              AdminsFetchingStatus.loading
                      ? const LoadingWidget()
                      : state.adminsFetchingStatus ==
                              AdminsFetchingStatus.failed
                          ? AppErrorWidget(
                              onRefreshPressed: () {
                                _adminBloc.add(AdminsFetched(
                                    getAdminsParams: GetAdminsParams(
                                  username: userNameController.text.isNotEmpty
                                      ? userNameController.text
                                      : null,
                                )));
                              },
                            )
                          : Expanded(
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
                                    label: Text('التفعيل'),
                                  ),
                                  DataColumn(
                                    label: Text(''),
                                  ),
                                ],
                                rows: [
                                  for (var admin in state.admins)
                                    DataRow2(
                                      onTap: () {},
                                      cells: [
                                        DataCell(Text(admin.name)),
                                        DataCell(Text(admin.username)),
                                        DataCell(
                                          Switch(
                                            value: admin.isActive == 1,
                                            onChanged: (newValue) {
                                              _adminBloc.add(AdminActiveToggled(
                                                  adminId: admin.id));
                                            },
                                            activeColor: colorScheme.primary,
                                          ),
                                        ),
                                        DataCell(
                                          PopupMenuButton<String>(
                                            padding: EdgeInsets.zero,
                                            tooltip: 'خيارات',
                                            onSelected: (value) async {
                                              if (value == 'edit') {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return _AddUpdateAdminDialog(
                                                        isUpdate: true,
                                                        adminBloc: _adminBloc,
                                                        admin: admin,
                                                      );
                                                    });
                                              } else {
                                                final result =
                                                    await showDialog<bool?>(
                                                  context: context,
                                                  builder: (context) {
                                                    return const DeleteConfirmationDialog(
                                                      text:
                                                          'هل أنت متأكد أنك تريد حذف هذا الإعلان؟',
                                                    );
                                                  },
                                                );
                                                if (result != null && result) {
                                                  _adminBloc.add(AdminDeleted(
                                                      adminId: admin.id));
                                                }
                                              }
                                            },
                                            splashRadius: 30,
                                            itemBuilder: (context) =>
                                                <PopupMenuItem<String>>[
                                              const PopupMenuItem<String>(
                                                value: 'edit',
                                                child: Text(
                                                  'تعديل',
                                                ),
                                              ),
                                              const PopupMenuItem<String>(
                                                value: 'delete',
                                                child: Text(
                                                  'حذف',
                                                ),
                                              ),
                                            ],
                                            child: const Icon(
                                                Icons.more_vert_outlined),
                                          ),
                                        )
                                      ],
                                    ),
                                ],
                                empty: Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    color: Colors.grey[200],
                                    child:
                                        const Text('لا يوجد أي مسؤولين حاليا'),
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

class _AddUpdateAdminDialog extends StatefulWidget {
  const _AddUpdateAdminDialog({
    required this.adminBloc,
    this.isUpdate = false,
    this.admin,
  });
  final AdminBloc adminBloc;
  final bool isUpdate;
  final Admin? admin;

  @override
  State<_AddUpdateAdminDialog> createState() => _AddUpdateAdminDialogState();
}

class _AddUpdateAdminDialogState extends State<_AddUpdateAdminDialog> {
  late final TextEditingController nameController;
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;
  late final TextEditingController passwordConfirmationController;
  late final ValueNotifier<bool> canAddExcelNotifier;
  late final ValueNotifier<bool> canAddSubsNotifier;
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.admin?.name);
    usernameController = TextEditingController(text: widget.admin?.username);
    passwordController = TextEditingController();
    passwordConfirmationController = TextEditingController();
    canAddExcelNotifier =
        ValueNotifier(widget.admin?.canAddQuestionFromExcel ?? false);
    canAddSubsNotifier =
        ValueNotifier(widget.admin?.canAddSubscriptions ?? false);
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
                    widget.isUpdate ? 'تعديل مسؤول' : 'إضافة مسؤول',
                    style: textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onBackground,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 340,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'الاسم:',
                        style: textTheme.bodyLarge
                            ?.copyWith(color: colorScheme.onBackground),
                      ),
                      SizedBox(
                        width: 230,
                        child: TextFormField(
                          autofocus: true,
                          controller: nameController,
                          style: textTheme.bodyLarge,
                          validator: (value) {
                            if (value == null || value.length < 5) {
                              return 'الاسم يجب أن يتكون من 5 أحرف على الأقل';
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
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 340,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'اسم المستخدم:',
                        style: textTheme.bodyLarge
                            ?.copyWith(color: colorScheme.onBackground),
                      ),
                      SizedBox(
                        width: 230,
                        child: TextFormField(
                          controller: usernameController,
                          style: textTheme.bodyLarge,
                          validator: (value) {
                            if (value == null || value.length < 5) {
                              return 'اسم المستخدم يجب أن يتكون من 3 أحرف على الأقل';
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
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 340,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'كلمة المرور:',
                        style: textTheme.bodyLarge
                            ?.copyWith(color: colorScheme.onBackground),
                      ),
                      SizedBox(
                        width: 230,
                        child: TextFormField(
                          controller: passwordController,
                          style: textTheme.bodyLarge,
                          obscureText: true,
                          validator: (value) {
                            if (value == null ||
                                !Validations.passwordValidation(
                                    password: value)) {
                              return 'كلمة المرور يجب أن تتكون من 6 محارف على الأقل';
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
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 340,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'تأكيد كلمة المرور:',
                        style: textTheme.bodyLarge
                            ?.copyWith(color: colorScheme.onBackground),
                      ),
                      SizedBox(
                        width: 230,
                        child: TextFormField(
                          controller: passwordConfirmationController,
                          style: textTheme.bodyLarge,
                          obscureText: true,
                          validator: (value) {
                            if (value == null ||
                                value != passwordController.text) {
                              return 'كلمتي المرور غير متطابقتين';
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
                ),
                const SizedBox(height: 12),
                ValueListenableBuilder(
                  valueListenable: canAddExcelNotifier,
                  builder: (context, canAdd, _) {
                    return SizedBox(
                      width: 250,
                      child: Row(
                        children: [
                          Text(
                            'يمكنه رفع ملف اكسل:',
                            style: textTheme.bodyLarge
                                ?.copyWith(color: colorScheme.onBackground),
                          ),
                          const Spacer(),
                          Switch(
                            value: canAdd,
                            onChanged: (value) {
                              canAddExcelNotifier.value = value;
                            },
                            activeColor: colorScheme.primary,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                ValueListenableBuilder(
                    valueListenable: canAddSubsNotifier,
                    builder: (context, canAdd, _) {
                      return SizedBox(
                        width: 250,
                        child: Row(
                          children: [
                            Text(
                              'يمكنه إضافة اشتراكات:',
                              style: textTheme.bodyLarge
                                  ?.copyWith(color: colorScheme.onBackground),
                            ),
                            const Spacer(),
                            Switch(
                              value: canAdd,
                              onChanged: (value) {
                                canAddSubsNotifier.value = value;
                              },
                              activeColor: colorScheme.primary,
                            ),
                          ],
                        ),
                      );
                    }),
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
                          widget.isUpdate
                              ? widget.adminBloc.add(AdminUpdated(
                                  updateAdminsParams: UpdateAdminParams(
                                  name: nameController.text,
                                  username: usernameController.text,
                                  password: passwordController.text,
                                  adminId: widget.admin!.id,
                                  canAddQuestionFromExcel:
                                      canAddExcelNotifier.value ? 1 : 0,
                                  canAddSubscription:
                                      canAddSubsNotifier.value ? 1 : 0,
                                )))
                              : widget.adminBloc.add(AdminAdded(
                                  addAdminsParams: AddAdminParams(
                                  name: nameController.text,
                                  username: usernameController.text,
                                  password: passwordController.text,
                                  canAddQuestionFromExcel:
                                      canAddExcelNotifier.value ? 1 : 0,
                                  canAddSubscription:
                                      canAddSubsNotifier.value ? 1 : 0,
                                )));
                          context.pop();
                        },
                        text: widget.isUpdate ? 'حفظ' : 'إضافة',
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
