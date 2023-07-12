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
import 'package:pharmacy_dashboard/layers/presentation/widgets/app_text_button.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/loading_widget.dart';

import '../../../core/layout/adaptive.dart';
import '../AppWidgetsDisplayer.dart';
import '../widgets/app_elevated_button.dart';

class SubjectsPage extends StatefulWidget {
  const SubjectsPage({super.key});
  static const routeName = 'subjects';

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  late final SubjectBloc _subjectBloc;

  @override
  void initState() {
    super.initState();
    _subjectBloc = SubjectBloc();
    _subjectBloc.add(SubjectsFetched(getSubjectsParams: GetSubjectsParams()));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colorScheme.surfaceVariant,
        body: BlocConsumer<SubjectBloc, SubjectState>(
          listener: (context, state) {
            if (state.subjectAddingStatus == SubjectAddingStatus.failed) {
              AppWidgetsDisplayer.dispalyErrorSnackBar(
                context: context,
                message:
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
                message:
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
                message:
                    'فشل الحذف يرجى التحقق من الإتصال من الإنترنت والمحاولة مرة أخرى',
              );
            }
            if (state.subjectTogglingActiveStatus ==
                SubjectTogglingActiveStatus.failed) {
              AppWidgetsDisplayer.dispalySuccessSnackBar(
                context: context,
                message:
                    'يرجى التحقق من الإتصال من الإنترنت والمحاولة مرة أخرى',
              );
            }
          },
          bloc: _subjectBloc,
          builder: (context, state) {
            return state.subjectsFetchingStatus ==
                        SubjectsFetchingStatus.initial ||
                    state.subjectsFetchingStatus ==
                        SubjectsFetchingStatus.loading
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
                                      return _AddUpdateSubjectDialog(
                                          subjectBloc: _subjectBloc);
                                    });
                              },
                              text: 'إضافة مادة',
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
                                        '/${SubjectsPage.routeName}/${QuestionBanksPage.routeName}?subjectId=${subject.id}');
                                  },
                                  cells: [
                                    DataCell(Text(subject.title)),
                                    const DataCell(Text('الثالثة')),
                                    const DataCell(
                                      Text('الأول'),
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
                                        onSelected: (value) {
                                          if (value == 'edit') {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return _AddUpdateSubjectDialog(
                                                  subjectBloc: _subjectBloc,
                                                  isUpdate: true,
                                                  semesterId:
                                                      subject.yearSemesterId,
                                                  title: subject.title,
                                                  subjectId: subject.id,
                                                );
                                              },
                                            );
                                          } else {
                                            _subjectBloc.add(SubjectDeleted(
                                                subjectId: subject.id));
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

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    widget.subjectBloc.add(SemesterValueChanged(widget.semesterId));
    widget.subjectBloc.add(SemestersFetched());
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
        child: BlocBuilder<SubjectBloc, SubjectState>(
          bloc: widget.subjectBloc,
          builder: (context, state) {
            return state.semestersFetchingStatus ==
                    SemestersFetchingStatus.initial
                ? const LoadingWidget()
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 10),
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
                        SizedBox(
                          width: 340,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'اسم المادة:',
                                style: textTheme.bodyLarge
                                    ?.copyWith(color: colorScheme.onBackground),
                              ),
                              SizedBox(
                                width: 250,
                                child: TextField(
                                  controller: titleController,
                                  style: textTheme.bodyLarge,
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
                                'الفصل:',
                                style: textTheme.bodyLarge
                                    ?.copyWith(color: colorScheme.onBackground),
                              ),
                              SizedBox(
                                width: 250,
                                child: DropdownButtonFormField2<int>(
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  hint: Text(
                                    'اختر الفصل و السنة',
                                    style: textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: textTheme.bodyLarge,
                                  value: state.currenSemesterId,
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
                                          .add(SemesterValueChanged(value));
                                    }
                                  },
                                  buttonStyleData: const ButtonStyleData(
                                    height: 40,
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
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
                                      ? widget.subjectBloc.add(SubjectUpdated(
                                          updateSubjectParams:
                                              UpdateSubjectParams(
                                          yearSemesterId:
                                              state.currenSemesterId!,
                                          title: widget.title!,
                                          subjectId: widget.subjectId!,
                                        )))
                                      : widget.subjectBloc.add(SubjectAdded(
                                          addSubjectParams: AddSubjectParams(
                                          yearSemesterId:
                                              state.currenSemesterId!,
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
                  );
          },
        ),
      ),
    );
  }
}
