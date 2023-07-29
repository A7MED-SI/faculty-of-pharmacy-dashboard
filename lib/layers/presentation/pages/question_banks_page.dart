import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_dashboard/core/layout/adaptive.dart';
import 'package:pharmacy_dashboard/layers/data/models/question_bank/question_bank.dart';
import 'package:pharmacy_dashboard/layers/data/models/subject/subject.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/question_bank/add_question_bank.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/question_bank/update_question_bank.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/subject/show_subject.dart';
import 'package:pharmacy_dashboard/layers/presentation/AppWidgetsDisplayer.dart';
import 'package:pharmacy_dashboard/layers/presentation/blocs/question_bank/question_bank_bloc.dart';
import 'package:pharmacy_dashboard/layers/presentation/blocs/question_bank_card/question_bank_card_bloc.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/questions_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/pages/subjects_page.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/app_error_widget.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/app_text_button.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/loading_widget.dart';

import '../../../core/constants/api_enums/api_enums.dart';
import '../widgets/app_elevated_button.dart';
import '../widgets/delete_confirmation_dialog.dart';

class QuestionBanksPage extends StatefulWidget {
  const QuestionBanksPage({
    super.key,
    required this.subjectId,
  });
  static const routeName = 'questionBanks';

  final int subjectId;

  @override
  State<QuestionBanksPage> createState() => _QuestionBanksPageState();
}

class _QuestionBanksPageState extends State<QuestionBanksPage> {
  late final QuestionBankBloc _questionBankBloc;

  @override
  void initState() {
    super.initState();
    _questionBankBloc = QuestionBankBloc();
    _questionBankBloc
        .add(SubjectFetched(ShowSubjectParams(subjectId: widget.subjectId)));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDesktop = isDisplayDesktop(context);

    return BlocProvider(
      create: (context) => _questionBankBloc,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: colorScheme.background,
          body: BlocConsumer<QuestionBankBloc, QuestionBankState>(
            listener: (context, state) {
              if (state.questionBankAddingStatus ==
                  QuestionBankAddingStatus.failed) {
                AppWidgetsDisplayer.dispalyErrorSnackBar(
                  context: context,
                  message:
                      'فشل الإضافة يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى',
                );
              }
              if (state.questionBankAddingStatus ==
                  QuestionBankAddingStatus.success) {
                AppWidgetsDisplayer.dispalySuccessSnackBar(
                  context: context,
                  message: 'تم إضافة الإمتحان بنجاح',
                );
              }
              if (state.questionBankUpdatingStatus ==
                  QuestionBankUpdatingStatus.failed) {
                AppWidgetsDisplayer.dispalyErrorSnackBar(
                  context: context,
                  message:
                      'فشل التعديل يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى',
                );
              }
              if (state.questionBankUpdatingStatus ==
                  QuestionBankUpdatingStatus.success) {
                AppWidgetsDisplayer.dispalySuccessSnackBar(
                  context: context,
                  message: 'تم تعديل الإمتحان بنجاح',
                );
              }
              if (state.questionBankDeletingStatus ==
                  QuestionBankDeletingStatus.failed) {
                AppWidgetsDisplayer.dispalyErrorSnackBar(
                  context: context,
                  message: state.errorMessage ??
                      'فشل الحذف يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى',
                );
              }
              if (state.questionBankDeletingStatus ==
                  QuestionBankDeletingStatus.success) {
                AppWidgetsDisplayer.dispalySuccessSnackBar(
                  context: context,
                  message: 'تم حذف الإمتحان بنجاح',
                );
              }
            },
            builder: (context, state) {
              return state.subjectFetchingStatus ==
                          SubjectFetchingStatus.initial ||
                      state.subjectFetchingStatus ==
                          SubjectFetchingStatus.loading
                  ? const LoadingWidget()
                  : state.subjectFetchingStatus == SubjectFetchingStatus.failed
                      ? AppErrorWidget(
                          onRefreshPressed: () {
                            _questionBankBloc.add(SubjectFetched(
                                ShowSubjectParams(
                                    subjectId: widget.subjectId)));
                          },
                        )
                      : Column(
                          children: [
                            const SizedBox(height: 12),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    state.subject!.title,
                                    style: textTheme.bodyLarge?.copyWith(
                                      color: colorScheme.onBackground,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  AppTextButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return _AddUpdateQuestionBankDialog(
                                            questionBankBloc: _questionBankBloc,
                                            subjectId: state.subject!.id,
                                          );
                                        },
                                      );
                                    },
                                    text: 'إضافة امتحان',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _FirstScrollViewList(
                                      subject: state.subject!,
                                      addSecondList: !isDesktop,
                                    ),
                                  ),
                                  if (isDesktop)
                                    Expanded(
                                      child: _SecondScrollViewList(
                                        subject: state.subject!,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        );
            },
          ),
        ),
      ),
    );
  }
}

class _FirstScrollViewList extends StatelessWidget {
  const _FirstScrollViewList({
    required this.subject,
    required this.addSecondList,
  });
  final Subject subject;
  final bool addSecondList;
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsetsDirectional.only(end: 10, start: 5),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                _ComponentGroupDecoration(
                  label: 'أسئلة الدورات',
                  children: [
                    for (var qBank in subject.previousExams!)
                      _QuestionBankCard(
                        questionBank: qBank,
                        subjectId: subject.id,
                      ),
                  ],
                ),
                if (addSecondList)
                  _ComponentGroupDecoration(
                    label: 'بنوك الفصول',
                    children: [
                      for (var qBank in subject.chapterBanks!)
                        _QuestionBankCard(
                          questionBank: qBank,
                          subjectId: subject.id,
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SecondScrollViewList extends StatelessWidget {
  const _SecondScrollViewList({
    required this.subject,
  });
  final Subject subject;
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsetsDirectional.only(end: 10),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                _ComponentGroupDecoration(
                  label: 'بنوك الفصول',
                  children: [
                    for (var qBank in subject.chapterBanks!)
                      _QuestionBankCard(
                        questionBank: qBank,
                        subjectId: subject.id,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _QuestionBankCard extends StatefulWidget {
  const _QuestionBankCard({
    required this.questionBank,
    required this.subjectId,
  });
  final QuestionBank questionBank;
  final int subjectId;

  @override
  State<_QuestionBankCard> createState() => _QuestionBankCardState();
}

class _QuestionBankCardState extends State<_QuestionBankCard> {
  late final QuestionBankCardBloc _questionBankCardBloc;

  @override
  void initState() {
    super.initState();
    _questionBankCardBloc =
        QuestionBankCardBloc(questionBank: widget.questionBank);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return BlocConsumer<QuestionBankCardBloc, QuestionBankCardState>(
      listener: (context, state) {
        if (state.togglingStatus == TogglingStatus.failed) {
          AppWidgetsDisplayer.dispalyErrorSnackBar(
            context: context,
            message: 'يرجى التحقق من الاتصال بالإنترنت والمحاولة مرة أخرى',
          );
        }
      },
      bloc: _questionBankCardBloc,
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            onTap: () {
              context.go(
                  '/${SubjectsPage.routeName}/${widget.subjectId}/${QuestionBanksPage.routeName}/${widget.questionBank.id}/${QuestionsPage.routeName}');
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            tileColor: colorScheme.background,
            title: Text(
              widget.questionBank.title,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onBackground,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              widget.questionBank.bankType == 1
                  ? 'دورة ${widget.questionBank.yearOfExam} فصل ${widget.questionBank.semesterOfExam}'
                  : 'فصل رقم ${widget.questionBank.chapterOrder}',
              style: textTheme.bodyLarge
                  ?.copyWith(color: colorScheme.onBackground),
            ),
            trailing: Switch(
              onChanged: (value) {
                _questionBankCardBloc.add(QuestionBankCardActiveToggled());
              },
              value: state.questionBank.isActive == 1,
              activeColor: colorScheme.primary,
            ),
            leading: PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              tooltip: 'خيارات',
              onSelected: (value) async {
                final questionBankBloc = context.read<QuestionBankBloc>();
                if (value == 'edit') {
                  showDialog(
                    context: context,
                    builder: (newContext) {
                      return _AddUpdateQuestionBankDialog(
                        questionBankBloc: questionBankBloc,
                        isUpdate: true,
                        bankType: widget.questionBank.bankType,
                        chapterOrder: widget.questionBank.chapterOrder,
                        semester: widget.questionBank.semesterOfExam,
                        title: widget.questionBank.title,
                        yearOfExam: widget.questionBank.yearOfExam,
                        subjectId: widget.subjectId,
                        questionBankId: widget.questionBank.id,
                      );
                    },
                  );
                } else {
                  final result = await showDialog<bool?>(
                    context: context,
                    builder: (context) {
                      return const DeleteConfirmationDialog(
                        text: 'هل أنت متأكد أنك تريد حذف هذا الإمتحان؟',
                      );
                    },
                  );
                  if (result != null && result) {
                    questionBankBloc.add(QuestionBankDeleted(
                        questionBankId: widget.questionBank.id));
                  }
                }
              },
              splashRadius: 30,
              itemBuilder: (context) => <PopupMenuItem<String>>[
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
              child: const Icon(Icons.more_vert_outlined),
            ),
          ),
        );
      },
    );
  }
}

class _ComponentGroupDecoration extends StatelessWidget {
  const _ComponentGroupDecoration(
      {required this.label, required this.children});

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // ignore: unused_local_variable
    final textTheme = Theme.of(context).textTheme;
    return FocusTraversalGroup(
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 0,
        color: colorScheme.surfaceVariant,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12),
          child: Center(
            child: Column(
              children: [
                Text(label, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                ...children
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AddUpdateQuestionBankDialog extends StatefulWidget {
  const _AddUpdateQuestionBankDialog({
    required this.questionBankBloc,
    required this.subjectId,
    this.isUpdate = false,
    this.bankType,
    this.chapterOrder,
    this.semester,
    this.title,
    this.yearOfExam,
    this.questionBankId,
  });
  final QuestionBankBloc questionBankBloc;
  final int? questionBankId;
  final bool isUpdate;
  final String? title;
  final String? yearOfExam;
  final int? bankType;
  final int? semester;
  final int? chapterOrder;
  final int subjectId;
  @override
  State<_AddUpdateQuestionBankDialog> createState() =>
      _AddUpdateQuestionBankDialogState();
}

class _AddUpdateQuestionBankDialogState
    extends State<_AddUpdateQuestionBankDialog> {
  final bankTypes = [
    (
      text: QuestionBankType.typeInArabic(QuestionBankType.previousExam.value),
      value: QuestionBankType.previousExam.value
    ),
    (
      text: QuestionBankType.typeInArabic(QuestionBankType.chapterBank.value),
      value: QuestionBankType.chapterBank.value
    ),
  ];

  final semesters = [
    (text: 'الأول', value: 1),
    (text: 'الثاني', value: 2),
    (text: 'التكميلي', value: 3),
  ];

  late final TextEditingController titleController;
  late final TextEditingController chapterOrderController;
  late final TextEditingController yearOfExamController;

  late final ValueNotifier<int?> bankTypeNotifier;
  late final ValueNotifier<int?> semesterNotifier;

  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    chapterOrderController =
        TextEditingController(text: widget.chapterOrder?.toString());
    yearOfExamController = TextEditingController(
        text: widget.yearOfExam ?? DateTime.now().year.toString());

    bankTypeNotifier = ValueNotifier(widget.bankType);
    semesterNotifier = ValueNotifier(widget.semester);
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          child: ValueListenableBuilder<int?>(
              valueListenable: bankTypeNotifier,
              builder: (context, currentBankType, _) {
                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          widget.isUpdate ? 'تعديل امتحان' : 'إضافة امتحان',
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
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              style: textTheme.bodyLarge,
                              validator: (value) {
                                if (value == null || value.length < 3) {
                                  return 'يجب أن يتكون العنوان من 3 أحرف على الأقل';
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
                              'نوع الامتحان:',
                              style: textTheme.bodyLarge
                                  ?.copyWith(color: colorScheme.onBackground),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: DropdownButtonFormField2<int>(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return 'يجب اختيار نوع الامتحان';
                                }
                                return null;
                              },
                              hint: Text(
                                'اختر نوع الامتحان',
                                style: textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: textTheme.bodyLarge,
                              value: currentBankType,
                              items: [
                                for (var bt in bankTypes)
                                  DropdownMenuItem(
                                    value: bt.value,
                                    child: Text(bt.text),
                                  ),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  bankTypeNotifier.value = value;
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
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (currentBankType == QuestionBankType.chapterBank.value)
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'ترتيب الفصل في المادة:',
                                style: textTheme.bodyLarge
                                    ?.copyWith(color: colorScheme.onBackground),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                controller: chapterOrderController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                maxLength: 2,
                                style: textTheme.bodyLarge,
                                validator: (value) {
                                  if (currentBankType ==
                                          QuestionBankType.chapterBank.value &&
                                      (value == null || value.isEmpty)) {
                                    return 'يجب إدخال رقم الفصل في المادة';
                                  }
                                  return null;
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: const InputDecoration(
                                  isCollapsed: true,
                                  counterText: '',
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 11),
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (currentBankType ==
                          QuestionBankType.previousExam.value)
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'سنة الدورة:',
                                style: textTheme.bodyLarge
                                    ?.copyWith(color: colorScheme.onBackground),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: TextField(
                                controller: yearOfExamController,
                                readOnly: true,
                                showCursor: false,
                                mouseCursor: SystemMouseCursors.click,
                                canRequestFocus: false,
                                onTap: () async {
                                  final dateTime = await showDialog<DateTime?>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return YearPickingDialog(
                                        selectedYear: DateTime(
                                            int.parse(
                                                yearOfExamController.text),
                                            1),
                                      );
                                    },
                                  );
                                  if (dateTime != null) {
                                    yearOfExamController.text =
                                        dateTime.year.toString();
                                  }
                                },
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
                      if (currentBankType ==
                          QuestionBankType.previousExam.value)
                        const SizedBox(height: 12),
                      if (currentBankType ==
                          QuestionBankType.previousExam.value)
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'الفصل الدراسي:',
                                style: textTheme.bodyLarge
                                    ?.copyWith(color: colorScheme.onBackground),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: ValueListenableBuilder<int?>(
                                  valueListenable: semesterNotifier,
                                  builder: (context, currentSemester, _) {
                                    return DropdownButtonFormField2<int>(
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (currentBankType ==
                                                QuestionBankType
                                                    .previousExam.value &&
                                            value == null) {
                                          return 'يجب اختيار الفصل';
                                        }
                                        return null;
                                      },
                                      hint: Text(
                                        'اختر الفصل',
                                        style: textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      style: textTheme.bodyLarge,
                                      value: currentSemester,
                                      items: [
                                        for (var sem in semesters)
                                          DropdownMenuItem(
                                            value: sem.value,
                                            child: Text(sem.text),
                                          ),
                                      ],
                                      onChanged: (value) {
                                        if (value != null) {
                                          semesterNotifier.value = value;
                                        }
                                      },
                                      buttonStyleData: const ButtonStyleData(
                                        height: 40,
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
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
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    );
                                  }),
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
                                    ? widget.questionBankBloc.add(
                                        QuestionBankUpdated(
                                            updateQuestionBankParams:
                                                UpdateQuestionBankParams(
                                        questionBankId: widget.questionBankId!,
                                        bankType: bankTypeNotifier.value!,
                                        title: titleController.text,
                                        subjectId: widget.subjectId,
                                        chapterOrder: int.tryParse(
                                            chapterOrderController.text),
                                        semesterOfExam: semesterNotifier.value,
                                        yearOfExam: yearOfExamController.text,
                                      )))
                                    : widget.questionBankBloc.add(
                                        QuestionBankAdded(
                                            addQuestionBankParams:
                                                AddQuestionBankParams(
                                        bankType: bankTypeNotifier.value!,
                                        title: titleController.text,
                                        subjectId: widget.subjectId,
                                        chapterOrder: int.tryParse(
                                            chapterOrderController.text),
                                        semesterOfExam: semesterNotifier.value,
                                        yearOfExam: yearOfExamController.text,
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
              }),
        ),
      ),
    );
  }
}

class YearPickingDialog extends StatelessWidget {
  const YearPickingDialog({
    super.key,
    this.selectedYear,
  });
  final DateTime? selectedYear;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: const Text("اختر السنة"),
      content: SizedBox(
        width: 300,
        height: 300,
        child: YearPicker(
          firstDate: DateTime(DateTime.now().year - 30, 1),
          lastDate: DateTime(DateTime.now().year, 1),
          initialDate: DateTime.now(),
          selectedDate: selectedYear ?? DateTime.now(),
          onChanged: (DateTime dateTime) {
            context.pop(dateTime);
          },
          currentDate: selectedYear ?? DateTime.now(),
        ),
      ),
      actions: [
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
      ],
    );
  }
}
