part of 'question_bank_bloc.dart';

@immutable
abstract class QuestionBankEvent {}

class SubjectFetched extends QuestionBankEvent {
  final ShowSubjectParams params;

  SubjectFetched(this.params);
}

class QuestionBankAdded extends QuestionBankEvent {
  final AddQuestionBankParams addQuestionBankParams;

  QuestionBankAdded({required this.addQuestionBankParams});
}

class QuestionBankUpdated extends QuestionBankEvent {
  final UpdateQuestionBankParams updateQuestionBankParams;

  QuestionBankUpdated({required this.updateQuestionBankParams});
}

class QuestionBankDeleted extends QuestionBankEvent {
  final int questionBankId;

  QuestionBankDeleted({required this.questionBankId});
}
