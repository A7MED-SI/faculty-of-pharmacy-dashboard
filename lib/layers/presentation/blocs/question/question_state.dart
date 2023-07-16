part of 'question_bloc.dart';

enum QuestionBankFetchingStatus { initial, loading, success, failed }

enum AddingQuestionStatus { initial, success, failed }

enum UpdatingQuestionStatus { initial, success, failed }

enum DeletingQuestionStatus { initial, success, failed }

enum AddingQuestionsFromExcelStatus { initial, success, failed }

@immutable
class QuestionState {
  final QuestionBankFetchingStatus questionBankFetchingStatus;
  final AddingQuestionStatus addingQuestionStatus;
  final UpdatingQuestionStatus updatingQuestionStatus;
  final DeletingQuestionStatus deletingQuestionStatus;
  final AddingQuestionsFromExcelStatus addingQuestionsFromExcelStatus;
  final QuestionBank? questionBank;

  const QuestionState({
    this.questionBankFetchingStatus = QuestionBankFetchingStatus.initial,
    this.addingQuestionStatus = AddingQuestionStatus.initial,
    this.updatingQuestionStatus = UpdatingQuestionStatus.initial,
    this.deletingQuestionStatus = DeletingQuestionStatus.initial,
    this.addingQuestionsFromExcelStatus =
        AddingQuestionsFromExcelStatus.initial,
    this.questionBank,
  });

  QuestionState copyWith({
    QuestionBankFetchingStatus? questionBankFetchingStatus,
    QuestionBank? questionBank,
    AddingQuestionStatus? addingQuestionStatus,
    UpdatingQuestionStatus? updatingQuestionStatus,
    DeletingQuestionStatus? deletingQuestionStatus,
    AddingQuestionsFromExcelStatus? addingQuestionsFromExcelStatus,
  }) {
    return QuestionState(
      questionBank: questionBank ?? this.questionBank,
      questionBankFetchingStatus:
          questionBankFetchingStatus ?? this.questionBankFetchingStatus,
      addingQuestionStatus: addingQuestionStatus ?? this.addingQuestionStatus,
      updatingQuestionStatus:
          updatingQuestionStatus ?? this.updatingQuestionStatus,
      deletingQuestionStatus:
          deletingQuestionStatus ?? this.deletingQuestionStatus,
      addingQuestionsFromExcelStatus:
          addingQuestionsFromExcelStatus ?? this.addingQuestionsFromExcelStatus,
    );
  }
}
