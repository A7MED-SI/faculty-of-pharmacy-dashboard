import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/subject/add_subject.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/subject/get_subjects.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/subject/update_subject.dart';
import 'package:pharmacy_dashboard/layers/presentation/blocs/subject/subject_bloc.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/question_banks_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/app_error_widget.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/app_text_button.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/loading_widget.dart';

import '../../../core/layout/adaptive.dart';
import '../AppWidgetsDisplayer.dart';
import '../widgets/app_elevated_button.dart';
import '../widgets/delete_confirmation_dialog.dart';

class SubjectsPage extends StatefulWidget {
  const SubjectsPage({super.key, this.semesterId});
  static const routeName = 'subjects';
  final int? semesterId;

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  late final SubjectBloc _subjectBloc;

  @override
  void initState() {
    super.initState();
    _subjectBloc = SubjectBloc();
    _subjectBloc.add(SubjectsFetched(
        getSubjectsParams:
            GetSubjectsParams(yearSemesterId: widget.semesterId)));
    _subjectBloc.add(MainSemesterValueChanged(widget.semesterId ?? -1));
    _subjectBloc.add(SemestersFetched());
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
        body: BlocConsumer<SubjectBloc, SubjectState>(
          listener: (context, state) {
            if (state.subjectAddingStatus == SubjectAddingStatus.failed) {
              AppWidgetsDisplayer.dispalyErrorSnackBar(
                context: context,
                message: state.errorMessage ??
                    'فشل الإضافة يرجى التحقق من الإتصال من الإنترنت والمحاولة مرة أخرى',
              );
            }
            if (state.subjectAddingStatus == SubjectAddingStatus.success) {
              AppWidgetsDisplayer.dispalySuccessSnackBar(
                context: context,
                message: 'تمت إضافة المادة بنجاح',
              );
            }
            if (state.subjectUpdatingStatus == SubjectUpdatingStatus.failed) {
              AppWidgetsDisplayer.dispalyErrorSnackBar(
                context: context,
                message: state.errorMessage ??
                    'فشل التعديل يرجى التحقق من الإتصال من الإنترنت والمحاولة مرة أخرى',
              );
            }
            if (state.subjectUpdatingStatus == SubjectUpdatingStatus.success) {
              AppWidgetsDisplayer.dispalySuccessSnackBar(
                context: context,
                message: 'تم حفظ التعديل بنجاح',
              );
            }
            if (state.subjectDeletingStatus == SubjectDeletingStatus.success) {
              AppWidgetsDisplayer.dispalySuccessSnackBar(
                context: context,
                message: 'تم حذف المادة بنجاح',
              );
            }
            if (state.subjectDeletingStatus == SubjectDeletingStatus.failed) {
              AppWidgetsDisplayer.dispalySuccessSnackBar(
                context: context,
                message: state.errorMessage ??
                    'فشل الحذف يرجى التحقق من الإتصال من الإنترنت والمحاولة مرة أخرى',
              );
            }
            if (state.subjectTogglingActiveStatus ==
                SubjectTogglingActiveStatus.failed) {
              AppWidgetsDisplayer.dispalySuccessSnackBar(
                context: context,
                message: state.errorMessage ??
                    'يرجى التحقق من الإتصال من الإنترنت والمحاولة مرة أخرى',
              );
            }
          },
          bloc: _subjectBloc,
          builder: (context, state) {
            return state.subjectsFetchingStatus ==
                        SubjectsFetchingStatus.initial ||
                    state.subjectsFetchingStatus ==
                        SubjectsFetchingStatus.loading ||
                    state.semestersFetchingStatus ==
                        SemestersFetchingStatus.initial
                ? const LoadingWidget()
                : state.subjectsFetchingStatus ==
                            SubjectsFetchingStatus.failed ||
                        state.semestersFetchingStatus ==
                            SemestersFetchingStatus.failed
                    ? AppErrorWidget(
                        onRefreshPressed: () {
                          _subjectBloc.add(SubjectsFetched(
                              getSubjectsParams: GetSubjectsParams(
                            yearSemesterId: state.mainSemesterId != -1
                                ? state.mainSemesterId
                                : null,
                          )));
                        },
                      )
                    : Container(
                        margin: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 320,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'الفصل:',
                                        style: textTheme.bodyLarge?.copyWith(
                                            color: colorScheme.onBackground),
                                      ),
                                      SizedBox(
                                        width: 260,
                                        child: DropdownButtonFormField2<int>(
                                          decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding: EdgeInsets.zero,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          style: textTheme.bodyLarge,
                                          value: state.mainSemesterId,
                                          items: [
                                            for (var sem in List.of(
                                                state.semesters)
                                              ..insert(
                                                  0, (text: 'الكل', value: -1)))
                                              DropdownMenuItem(
                                                value: sem.value,
                                                child: Text(sem.text),
                                              ),
                                          ],
                                          onChanged: (value) {
                                            if (value != null) {
                                              _subjectBloc.add(
                                                  MainSemesterValueChanged(
                                                      value));
                                              _subjectBloc.add(SubjectsFetched(
                                                  getSubjectsParams:
                                                      GetSubjectsParams(
                                                yearSemesterId:
                                                    value != -1 ? value : null,
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
                                          dropdownStyleData: DropdownStyleData(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                if (isDesktop)
                                  AppTextButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return _AddUpdateSubjectDialog(
                                              subjectBloc: _subjectBloc,
                                              semesterId:
                                                  state.mainSemesterId == -1
                                                      ? null
                                                      : state.mainSemesterId,
                                            );
                                          });
                                    },
                                    text: 'إضافة مادة',
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
                                        return _AddUpdateSubjectDialog(
                                          subjectBloc: _subjectBloc,
                                          semesterId: state.mainSemesterId == -1
                                              ? null
                                              : state.mainSemesterId,
                                        );
                                      });
                                },
                                text: 'إضافة مادة',
                              ),
                            const SizedBox(height: 20),
                            Expanded(
                              child: DataTable2(
                                empty: Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    color: Colors.grey[200],
                                    child: const Text('لا يوجد مواد مضافة بعد'),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.background,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                headingTextStyle: isDesktop
                                    ? textTheme.bodyLarge?.copyWith(
                                        color: colorScheme.onBackground,
                                        fontWeight: FontWeight.bold,
                                      )
                                    : textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.onBackground,
                                        fontWeight: FontWeight.bold,
                                      ),
                                dataTextStyle: isDesktop
                                    ? textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.onBackground,
                                      )
                                    : textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onBackground,
                                      ),
                                isHorizontalScrollBarVisible: true,
                                columns: const [
                                  DataColumn(
                                    label: Text('اسم المادة'),
                                  ),
                                  DataColumn(
                                    label: Text('السنة'),
                                  ),
                                  DataColumn(
                                    label: Text('الفصل'),
                                  ),
                                  DataColumn(
                                    label: Text('التفعيل'),
                                  ),
                                  DataColumn(label: Text('')),
                                ],
                                rows: [
                                  for (var subject in state.subjects)
                                    DataRow2(
                                      onTap: () {
                                        context.go(
                                            '/${SubjectsPage.routeName}/${subject.id}/${QuestionBanksPage.routeName}');
                                      },
                                      cells: [
                                        DataCell(Text(subject.title)),
                                        DataCell(Text(
                                            subject.semester.yearArabicName)),
                                        DataCell(
                                          Text(subject
                                              .semester.semesterArabicName),
                                        ),
                                        DataCell(
                                          Switch(
                                            value: subject.isActive == 1,
                                            onChanged: (newValue) {
                                              _subjectBloc.add(
                                                  SubjectActiveStatusToggled(
                                                      subjectId: subject.id));
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
                                                    return _AddUpdateSubjectDialog(
                                                      subjectBloc: _subjectBloc,
                                                      isUpdate: true,
                                                      semesterId:
                                                          subject.semester.id,
                                                      title: subject.title,
                                                      subjectId: subject.id,
                                                    );
                                                  },
                                                );
                                              } else {
                                                final result =
                                                    await showDialog<bool?>(
                                                  context: context,
                                                  builder: (context) {
                                                    return const DeleteConfirmationDialog(
                                                      text:
                                                          'هل أنت متأكد أنك تريد حذف هذه المادة؟',
                                                    );
                                                  },
                                                );
                                                if (result != null && result) {
                                                  _subjectBloc.add(
                                                      SubjectDeleted(
                                                          subjectId:
                                                              subject.id));
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

class _AddUpdateSubjectDialog extends StatefulWidget {
  const _AddUpdateSubjectDialog({
    required this.subjectBloc,
    this.isUpdate = false,
    this.semesterId,
    this.title,
    this.subjectId,
  });
  final SubjectBloc subjectBloc;
  final bool isUpdate;
  final int? semesterId;
  final String? title;
  final int? subjectId;
  @override
  State<_AddUpdateSubjectDialog> createState() =>
      _AddUpdateSubjectDialogState();
}

class _AddUpdateSubjectDialogState extends State<_AddUpdateSubjectDialog> {
  late final TextEditingController titleController;
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);

    widget.subjectBloc.add(DialogSemesterValueChanged(widget.semesterId ?? -1));
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
          ? const EdgeInsets.symmetric(horizontal: 330)
          : const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: colorScheme.background,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocBuilder<SubjectBloc, SubjectState>(
          bloc: widget.subjectBloc,
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        widget.isUpdate ? 'تعديل مادة' : 'إضافة مادة',
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
                            'اسم المادة:',
                            style: textTheme.bodyLarge
                                ?.copyWith(color: colorScheme.onBackground),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: titleController,
                            style: textTheme.bodyLarge,
                            validator: (value) {
                              if (value == null || value.length < 3) {
                                return 'الاسم يجب أن يتكون من 3 حروف على الأقل';
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'الفصل:',
                            style: textTheme.bodyLarge
                                ?.copyWith(color: colorScheme.onBackground),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: DropdownButtonFormField2<int>(
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'يجب اختيار الفصل';
                              }
                              return null;
                            },
                            hint: Text(
                              'اختر الفصل و السنة',
                              style: textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: textTheme.bodyLarge,
                            value: state.dialogSemesterId == -1
                                ? null
                                : state.dialogSemesterId,
                            items: [
                              for (var sem in state.semesters)
                                DropdownMenuItem(
                                  value: sem.value,
                                  child: Text(sem.text),
                                ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                widget.subjectBloc
                                    .add(DialogSemesterValueChanged(value));
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
                                  ? widget.subjectBloc.add(SubjectUpdated(
                                      updateSubjectParams: UpdateSubjectParams(
                                      yearSemesterId: state.dialogSemesterId,
                                      title: titleController.text,
                                      subjectId: widget.subjectId!,
                                    )))
                                  : widget.subjectBloc.add(SubjectAdded(
                                      addSubjectParams: AddSubjectParams(
                                      yearSemesterId: state.dialogSemesterId,
                                      title: titleController.text,
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
            );
          },
        ),
      ),
    );
  }
}
