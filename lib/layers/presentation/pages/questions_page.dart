import 'dart:typed_data';
import 'dart:js' as js;

import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_dashboard/core/constants/api_enums/api_enums.dart';
import 'package:pharmacy_dashboard/layers/data/models/question/question.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/question/add_question.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/question/add_question_from_exel.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/question/update_question.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/question_bank/show_question_bank.dart';
import 'package:pharmacy_dashboard/layers/presentation/AppWidgetsDisplayer.dart';
import 'package:pharmacy_dashboard/layers/presentation/blocs/question/question_bloc.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/app_text_button.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/loading_widget.dart';
import 'package:pharmacy_dashboard/layers/presentation/blocs/question_dialog/question_dialog_bloc.dart';
import 'package:pharmacy_dashboard/layers/presentation/widgets/svg_image.dart';

import '../../../core/constants/images/svg_images.dart';
import '../../../core/layout/adaptive.dart';
import '../widgets/app_elevated_button.dart';
import '../widgets/delete_confirmation_dialog.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({
    super.key,
    required this.questionBankId,
  });
  static const routeName = 'questions';
  final int questionBankId;

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  late final QuestionBloc _questionBloc;

  @override
  void initState() {
    super.initState();
    _questionBloc = QuestionBloc();
    _questionBloc.add(QuestionBankFetched(
        showQuestionBankParams: ShowQuestionBankParams(
      questionBankId: widget.questionBankId,
    )));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDesktop = isDisplayDesktop(context);
    return BlocProvider(
      create: (context) => _questionBloc,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: colorScheme.surfaceVariant,
          body: BlocConsumer<QuestionBloc, QuestionState>(
            listener: (context, state) {
              if (state.addingQuestionStatus == AddingQuestionStatus.failed) {
                AppWidgetsDisplayer.dispalyErrorSnackBar(
                  context: context,
                  message:
                      'فشل الإضافة يرجى التحقق من اتصالك بالإنترنت والمحاولة لاحقا',
                );
              }
              if (state.addingQuestionStatus == AddingQuestionStatus.success) {
                AppWidgetsDisplayer.dispalySuccessSnackBar(
                  context: context,
                  message: 'تم إضافة السؤال بنجاح',
                );
              }
              if (state.updatingQuestionStatus ==
                  UpdatingQuestionStatus.failed) {
                AppWidgetsDisplayer.dispalyErrorSnackBar(
                  context: context,
                  message:
                      'فشل التعديل يرجى التحقق من اتصالك بالإنترنت والمحاولة لاحقا',
                );
              }
              if (state.updatingQuestionStatus ==
                  UpdatingQuestionStatus.success) {
                AppWidgetsDisplayer.dispalySuccessSnackBar(
                  context: context,
                  message: 'تم تعديل السؤال بنجاح',
                );
              }
              if (state.deletingQuestionStatus ==
                  DeletingQuestionStatus.failed) {
                AppWidgetsDisplayer.dispalyErrorSnackBar(
                  context: context,
                  message:
                      'فشل الحذف يرجى التحقق من اتصالك بالإنترنت والمحاولة لاحقا',
                );
              }
              if (state.deletingQuestionStatus ==
                  DeletingQuestionStatus.success) {
                AppWidgetsDisplayer.dispalySuccessSnackBar(
                  context: context,
                  message: 'تم حذف السؤال بنجاح',
                );
              }
              if (state.addingQuestionsFromExcelStatus ==
                  AddingQuestionsFromExcelStatus.failed) {
                AppWidgetsDisplayer.dispalyErrorSnackBar(
                  context: context,
                  message:
                      'فشل رفع الملف يرجى التحقق من اتصالك بالإنترنت والمحاولة لاحقا',
                );
              }
              if (state.addingQuestionsFromExcelStatus ==
                  AddingQuestionsFromExcelStatus.success) {
                AppWidgetsDisplayer.dispalySuccessSnackBar(
                  context: context,
                  message: 'تم رفع ملف الأسئلة بنجاح',
                );
              }
            },
            builder: (context, state) {
              return state.questionBankFetchingStatus ==
                          QuestionBankFetchingStatus.initial ||
                      state.questionBankFetchingStatus ==
                          QuestionBankFetchingStatus.loading
                  ? const LoadingWidget()
                  : CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      state.questionBank!.bankType ==
                                              QuestionBankType
                                                  .previousExam.value
                                          ? '${state.questionBank!.subject!.title} - ${state.questionBank!.title} - دورة ${state.questionBank!.yearOfExam} - فصل ${state.questionBank!.semesterOfExam}'
                                          : '${state.questionBank!.title} - الفصل رقم ${state.questionBank!.chapterOrder}',
                                      style: textTheme.bodyLarge?.copyWith(
                                        color: colorScheme.onBackground,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (isDesktop)
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AppTextButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (newContext) {
                                                  return _AddUpdateQuestionDialog(
                                                    questionBloc: _questionBloc,
                                                    questionBankId:
                                                        widget.questionBankId,
                                                  );
                                                },
                                              );
                                            },
                                            text: 'إضافة سؤال',
                                          ),
                                          const SizedBox(width: 10),
                                          AppTextButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return _AddExcelFileDialog(
                                                    questionBloc: _questionBloc,
                                                    questionBankId:
                                                        widget.questionBankId,
                                                  );
                                                },
                                              );
                                            },
                                            text: 'إضافة ملف اكسل',
                                          ),
                                        ],
                                      )
                                  ],
                                ),
                                if(!isDesktop)
                                const SizedBox(height:8),
                                if (!isDesktop)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      AppTextButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (newContext) {
                                              return _AddUpdateQuestionDialog(
                                                questionBloc: _questionBloc,
                                                questionBankId:
                                                    widget.questionBankId,
                                              );
                                            },
                                          );
                                        },
                                        text: 'إضافة سؤال',
                                      ),
                                      const SizedBox(width: 10),
                                      AppTextButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return _AddExcelFileDialog(
                                                questionBloc: _questionBloc,
                                                questionBankId:
                                                    widget.questionBankId,
                                              );
                                            },
                                          );
                                        },
                                        text: 'إضافة ملف اكسل',
                                      ),
                                    ],
                                  ),
                                const SizedBox(height: 10),
                                for (int i = 0;
                                    i < state.questionBank!.questions!.length;
                                    i++)
                                  QuestionCard(
                                    question: state.questionBank!.questions![i],
                                    questionNumber: i + 1,
                                  ),
                              ],
                            ),
                          ),
                        )
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    super.key,
    required this.question,
    required this.questionNumber,
  });
  final Question question;
  final int questionNumber;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ExpansionTile(
        title: Text(
          '$questionNumber. ${question.questionText}',
          style: textTheme.headlineSmall?.copyWith(
            color: colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: PopupMenuButton<String>(
          tooltip: 'خيارات',
          padding: EdgeInsets.zero,
          onSelected: (value) async {
            final questionBloc = context.read<QuestionBloc>();
            if (value == 'edit') {
              showDialog(
                context: context,
                builder: (newContext) {
                  return _AddUpdateQuestionDialog(
                    questionBloc: questionBloc,
                    isUpdate: true,
                    question: question,
                    questionBankId: question.questionBankId,
                  );
                },
              );
            } else {
              final result = await showDialog<bool?>(
                context: context,
                builder: (context) {
                  return const DeleteConfirmationDialog(
                    text: 'هل أنت متأكد أنك تريد حذف هذا السؤال؟',
                  );
                },
              );
              if (result != null && result) {
                questionBloc.add(
                  QuestionDeleted(
                      questionId: question.id,
                      questionBankId: question.questionBankId),
                );
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
        backgroundColor: colorScheme.background,
        collapsedBackgroundColor: colorScheme.background,
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        collapsedIconColor: colorScheme.onBackground,
        tilePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        iconColor: colorScheme.onBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (question.hint != null || question.image != null)
                  Row(
                    children: [
                      if (question.hint != null)
                        Expanded(
                          flex: 4,
                          child: Text(
                            'تلميح: ${question.hint}',
                            style: textTheme.bodyLarge?.copyWith(
                              color: colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const Spacer(),
                      if (question.image != null)
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () {
                              js.context.callMethod('open', [question.image]);
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(colorScheme.primary),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                            ),
                            child: Text(
                              'فتح الصورة',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                Text(
                  '${question.answers.length} أجوبة:',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                for (var answer in question.answers)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnswerRow(
                        answer: answer.answerText,
                        isCorrect: answer.isTrue == 1,
                      ),
                      if (answer.id != question.answers.last.id)
                        const Divider(indent: 20, endIndent: 20),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnswerRow extends StatelessWidget {
  const AnswerRow({
    super.key,
    required this.answer,
    this.isCorrect = false,
  });

  final String answer;
  final bool isCorrect;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Text(
              answer,
              style: textTheme.bodyLarge,
              overflow: TextOverflow.visible,
            ),
          ),
          isCorrect
              ? const Expanded(
                  child: SvgImage(SvgImages.check),
                )
              : const Expanded(
                  child: SvgImage(
                    SvgImages.cancel,
                    color: Colors.red,
                  ),
                ),
        ],
      ),
    );
  }
}

class _AddUpdateQuestionDialog extends StatefulWidget {
  const _AddUpdateQuestionDialog({
    required this.questionBloc,
    this.isUpdate = false,
    this.question,
    required this.questionBankId,
  });
  final QuestionBloc questionBloc;
  final bool isUpdate;
  final Question? question;
  final int questionBankId;
  @override
  State<_AddUpdateQuestionDialog> createState() =>
      _AddUpdateQuestionDialogState();
}

class _AddUpdateQuestionDialogState extends State<_AddUpdateQuestionDialog> {
  late final TextEditingController questionTextController;
  late final TextEditingController hintController;
  late final QuestionDialogBloc _questionDialogBloc;
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    final answersValidity =
        widget.question?.answers.map<bool>((e) => e.isTrue == 1).toList();
    final answersControllers = widget.question?.answers
        .map<TextEditingController>(
            (e) => TextEditingController(text: e.answerText))
        .toList();
    _questionDialogBloc = QuestionDialogBloc(
      answersValidity: answersValidity,
      controllers: answersControllers,
      showHint: widget.question?.hint != null,
    );
    questionTextController =
        TextEditingController(text: widget.question?.questionText);
    hintController = TextEditingController(text: widget.question?.hint);
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
          ? const EdgeInsets.symmetric(horizontal: 100)
          : const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: colorScheme.background,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          child: BlocBuilder<QuestionDialogBloc, QuestionDialogState>(
            bloc: _questionDialogBloc,
            builder: (context, state) {
              return SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          widget.isUpdate ? 'تعديل سؤال' : 'إضافة سؤال',
                          style: textTheme.headlineSmall?.copyWith(
                            color: colorScheme.onBackground,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'السؤال:',
                              style: textTheme.bodyLarge
                                  ?.copyWith(color: colorScheme.onBackground),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              controller: questionTextController,
                              style: textTheme.bodyLarge,
                              maxLines: null,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'يجب ادخال نص السؤال';
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
                          if (isDesktop) const Spacer(),
                        ],
                      ),
                      if (!state.showHint)
                        TextButton(
                          onPressed: () {
                            _questionDialogBloc.add(HintToggled());
                          },
                          child: Text(
                            'إضافة تلميح',
                            style: textTheme.bodyLarge?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (state.showHint) const SizedBox(height: 12),
                      if (state.showHint)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'التلميح:',
                                style: textTheme.bodyLarge
                                    ?.copyWith(color: colorScheme.onBackground),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  TextField(
                                    controller: hintController,
                                    style: textTheme.bodyLarge,
                                    decoration: const InputDecoration(
                                      isCollapsed: true,
                                      contentPadding: EdgeInsets.only(
                                        right: 10,
                                        top: 11,
                                        bottom: 11,
                                        left: 30,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 8,
                                    child: Tooltip(
                                      message: 'حذف التلميح',
                                      child: InkWell(
                                        onTap: () {
                                          _questionDialogBloc
                                              .add(HintToggled());
                                        },
                                        child: Icon(
                                          Icons.cancel,
                                          color: colorScheme.secondary,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            if (isDesktop) const Spacer(),
                          ],
                        ),
                      for (int i = 0; i < state.answersControllers.length; i++)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'الإجابة ${i + 1}:',
                                    style: textTheme.bodyLarge?.copyWith(
                                        color: colorScheme.onBackground),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      TextFormField(
                                        key: ValueKey(i),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        controller: state.answersControllers[i],
                                        style: textTheme.bodyLarge,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'يجب ادخال نص الجواب';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          isCollapsed: true,
                                          contentPadding: EdgeInsets.only(
                                            right: 10,
                                            top: 11,
                                            bottom: 11,
                                            left: state.answersControllers
                                                        .length >
                                                    2
                                                ? 30
                                                : 10,
                                          ),
                                        ),
                                      ),
                                      if (state.answersControllers.length > 2)
                                        Positioned(
                                          left: 8,
                                          child: Tooltip(
                                            message: 'حذف الإجابة',
                                            child: InkWell(
                                              onTap: () {
                                                _questionDialogBloc
                                                    .add(AnswerDeleted(i));
                                              },
                                              child: Icon(
                                                Icons.cancel,
                                                color: colorScheme.secondary,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                                if (isDesktop)
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'صحيح',
                                          style: textTheme.bodyLarge,
                                        ),
                                        const SizedBox(width: 2),
                                        InkWell(
                                          onTap: () {
                                            if (state.answersValidity[i]) {
                                              return;
                                            }
                                            _questionDialogBloc.add(
                                                AnswerValidityToggled(
                                                    index: i));
                                          },
                                          child: SvgImage(
                                            state.answersValidity[i]
                                                ? SvgImages.check
                                                : SvgImages.emptyCircle,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'خاطىء',
                                          style: textTheme.bodyLarge,
                                        ),
                                        const SizedBox(width: 2),
                                        InkWell(
                                          onTap: () {
                                            if (!state.answersValidity[i]) {
                                              return;
                                            }
                                            _questionDialogBloc.add(
                                                AnswerValidityToggled(
                                                    index: i));
                                          },
                                          child: SvgImage(
                                            !state.answersValidity[i]
                                                ? SvgImages.cancel
                                                : SvgImages.emptyCircle,
                                            color: !state.answersValidity[i]
                                                ? Colors.red
                                                : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            if (!isDesktop) const SizedBox(height: 4),
                            if (!isDesktop)
                              Row(
                                children: [
                                  const Spacer(),
                                  const SizedBox(width: 30),
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      children: [
                                        Text(
                                          'صحيح',
                                          style: textTheme.bodyLarge,
                                        ),
                                        const SizedBox(width: 2),
                                        InkWell(
                                          onTap: () {
                                            if (state.answersValidity[i]) {
                                              return;
                                            }
                                            _questionDialogBloc.add(
                                                AnswerValidityToggled(
                                                    index: i));
                                          },
                                          child: SvgImage(
                                            state.answersValidity[i]
                                                ? SvgImages.check
                                                : SvgImages.emptyCircle,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'خاطىء',
                                          style: textTheme.bodyLarge,
                                        ),
                                        const SizedBox(width: 2),
                                        InkWell(
                                          onTap: () {
                                            if (!state.answersValidity[i]) {
                                              return;
                                            }
                                            _questionDialogBloc.add(
                                                AnswerValidityToggled(
                                                    index: i));
                                          },
                                          child: SvgImage(
                                            !state.answersValidity[i]
                                                ? SvgImages.cancel
                                                : SvgImages.emptyCircle,
                                            color: !state.answersValidity[i]
                                                ? Colors.red
                                                : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                          ],
                        ),
                      if (state.answersControllers.length < 6)
                        TextButton(
                          onPressed: () {
                            _questionDialogBloc.add(AnswerAdded());
                          },
                          child: Text(
                            'إضافة إجابة',
                            style: textTheme.bodyLarge?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),
                      if (state.image == null)
                        TextButton(
                          onPressed: () async {
                            final FilePickerResult? result =
                                await FilePickerWeb.platform.pickFiles(
                              type: FileType.image,
                            );
                            if (result != null) {
                              _questionDialogBloc.add(
                                  ImageAdded(image: result.files.first.bytes!));
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
                                widget.isUpdate
                                    ? 'اختيار صورة جديدة'
                                    : 'اختيار صورة',
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
                      if (state.image != null)
                        Center(
                          child: Stack(
                            children: [
                              Image.memory(
                                state.image!,
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
                                      _questionDialogBloc.add(ImageDeleted());
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
                                final List<Answer> answers = [];
                                for (int i = 0;
                                    i < state.answersControllers.length;
                                    i++) {
                                  answers.add(Answer(
                                      id: 1,
                                      answerText:
                                          state.answersControllers[i].text,
                                      isTrue:
                                          state.answersValidity[i] ? 1 : 0));
                                }
                                widget.isUpdate
                                    ? widget.questionBloc.add(QuestionUpdated(
                                        updateQuestionParams:
                                            UpdateQuestionParams(
                                        questionBankId: widget.questionBankId,
                                        questionText:
                                            questionTextController.text,
                                        answers: answers,
                                        questionId: widget.question!.id,
                                        hint: state.showHint &&
                                                hintController.text != ''
                                            ? hintController.text
                                            : null,
                                      )))
                                    : widget.questionBloc.add(QuestionAdded(
                                        addQuestionParams: AddQuestionParams(
                                        questionBankId: widget.questionBankId,
                                        questionText:
                                            questionTextController.text,
                                        answers: answers,
                                        hint: state.showHint &&
                                                hintController.text != ''
                                            ? hintController.text
                                            : null,
                                      )));
                                context.pop();
                              },
                              text: widget.isUpdate ? 'حفظ' : 'إضافة',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AddExcelFileDialog extends StatefulWidget {
  const _AddExcelFileDialog({
    required this.questionBloc,
    required this.questionBankId,
  });
  final QuestionBloc questionBloc;
  final int questionBankId;
  @override
  State<_AddExcelFileDialog> createState() => _AddExcelFileDialogState();
}

class _AddExcelFileDialogState extends State<_AddExcelFileDialog> {
  late final TextEditingController titleController;
  Uint8List? excelFile;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: 'اختر الملف');
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
                  'إضافة ملف اكسل',
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
                      'اسم الملف:',
                      style: textTheme.bodyLarge
                          ?.copyWith(color: colorScheme.onBackground),
                    ),
                    SizedBox(
                      width: 250,
                      child: TextField(
                        onTap: () async {
                          final FilePickerResult? result =
                              await FilePickerWeb.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['xlsx'],
                          );
                          if (result != null) {
                            titleController.text = result.files.first.name;
                            excelFile = result.files.first.bytes!;
                          }
                        },
                        controller: titleController,
                        style: textTheme.bodyLarge,
                        readOnly: true,
                        showCursor: false,
                        mouseCursor: SystemMouseCursors.click,
                        canRequestFocus: false,
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
                        if (excelFile == null) {
                          return;
                        }
                        widget.questionBloc.add(QuestionsFromExcelAdded(
                            addQuestionFromExelParams:
                                AddQuestionFromExelParams(
                                    questionBankId: widget.questionBankId,
                                    exelFile: excelFile!)));
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
