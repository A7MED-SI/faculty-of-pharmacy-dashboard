part of 'question_bloc.dart';

@immutable
abstract class QuestionEvent {}

class QuestionBankFetched extends QuestionEvent {
  final ShowQuestionBankParams showQuestionBankParams;

  QuestionBankFetched({required this.showQuestionBankParams});
}

class QuestionAdded extends QuestionEvent {
  final AddQuestionParams addQuestionParams;

  QuestionAdded({required this.addQuestionParams});
}

class QuestionUpdated extends QuestionEvent {
  final UpdateQuestionParams updateQuestionParams;

  QuestionUpdated({required this.updateQuestionParams});
}

class QuestionDeleted extends QuestionEvent {
  final int questionId;
  final int questionBankId;

  QuestionDeleted({
    required this.questionId,
    required this.questionBankId,
  });
}
