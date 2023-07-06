// ignore_for_file: unused_element

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/use_cases/admin/add_admin.dart';
import '../../domain/use_cases/admin/update_admin.dart';
import '../AppWidgetsDisplayer.dart';
import '../widgets/app_text_button.dart';
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
  late final AdminBloc _adminBloc;
  @override
  void initState() {
    super.initState();
    _adminBloc = AdminBloc();
    _adminBloc.add(AdminsFetched(getAdminsParams: GetAdminsParams()));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
            if (state.updatingStatus == UpdatingStatus.failed) {
              AppWidgetsDisplayer.dispalyErrorSnackBar(
                context: context,
                message:
                    'فشل التعديل يرجى التحقق من الإتصال من الإنترنت والمحاولة مرة أخرى',
              );
            }
            if (state.addingStatus == AddingStatus.success) {
              AppWidgetsDisplayer.dispalySuccessSnackBar(
                context: context,
                message: 'تمت إضافة المسؤول بنجاح',
              );
            }
            if (state.updatingStatus == UpdatingStatus.success) {
              AppWidgetsDisplayer.dispalySuccessSnackBar(
                context: context,
                message: 'تم حفظ التعديل بنجاح',
              );
            }
          },
          bloc: _adminBloc,
          builder: (context, state) {
            return state.adminsFetchingStatus == AdminsFetchingStatus.initial ||
                    state.adminsFetchingStatus == AdminsFetchingStatus.loading
                ? const LoadingWidget()
                : Container(
                    margin: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
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
                                label: Text('التفعيل'),
                              ),
                            ],
                            rows: [
                              for (var admin in state.admins)
                                DataRow2(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return _AddUpdateAdminDialog(
                                            isUpdate: true,
                                            adminBloc: _adminBloc,
                                            adminId: admin.id,
                                            name: admin.name,
                                            username: admin.username,
                                          );
                                        });
                                  },
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
                                    )
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

class _AddUpdateAdminDialog extends StatefulWidget {
  const _AddUpdateAdminDialog({
    required this.adminBloc,
    this.isUpdate = false,
    this.name,
    this.username,
    this.adminId,
    this.password,
  });
  final AdminBloc adminBloc;
  final bool isUpdate;
  final String? name;
  final String? username;
  final String? password;
  final int? adminId;

  @override
  State<_AddUpdateAdminDialog> createState() => _AddUpdateAdminDialogState();
}

class _AddUpdateAdminDialogState extends State<_AddUpdateAdminDialog> {
  late final TextEditingController nameController;
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;
  late final TextEditingController passwordConfirmationController;
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    usernameController = TextEditingController(text: widget.username);
    passwordController = TextEditingController(text: widget.password);
    passwordConfirmationController =
        TextEditingController(text: widget.password);
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
                  widget.isUpdate ? 'تعديل مسؤول' : 'إضافة مسؤول',
                  style: textTheme.headlineSmall?.copyWith(
                    color: colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 320,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الاسم:',
                      style: textTheme.bodyLarge
                          ?.copyWith(color: colorScheme.onBackground),
                    ),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: nameController,
                        style: textTheme.bodyLarge,
                        decoration: const InputDecoration(
                          isCollapsed: true,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 320,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'اسم المستخدم:',
                      style: textTheme.bodyLarge
                          ?.copyWith(color: colorScheme.onBackground),
                    ),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: usernameController,
                        style: textTheme.bodyLarge,
                        decoration: const InputDecoration(
                          isCollapsed: true,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 320,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'كلمة المرور:',
                      style: textTheme.bodyLarge
                          ?.copyWith(color: colorScheme.onBackground),
                    ),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: passwordController,
                        style: textTheme.bodyLarge,
                        obscureText: true,
                        decoration: const InputDecoration(
                          isCollapsed: true,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 320,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'تأكيد كلمة المرور:',
                      style: textTheme.bodyLarge
                          ?.copyWith(color: colorScheme.onBackground),
                    ),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: passwordConfirmationController,
                        style: textTheme.bodyLarge,
                        obscureText: true,
                        decoration: const InputDecoration(
                          isCollapsed: true,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 16),
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
                        widget.isUpdate
                            ? widget.adminBloc.add(AdminUpdated(
                                updateAdminsParams: UpdateAdminParams(
                                name: nameController.text,
                                username: usernameController.text,
                                password: passwordController.text,
                                adminId: widget.adminId!,
                              )))
                            : widget.adminBloc.add(AdminAdded(
                                addAdminsParams: AddAdminParams(
                                name: nameController.text,
                                username: usernameController.text,
                                password: passwordController.text,
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
    );
  }
}
