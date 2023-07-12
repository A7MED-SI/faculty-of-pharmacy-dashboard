part of 'question_bank_bloc.dart';

enum SubjectFetchingStatus { initial, loading, success, failed }

enum QuestionBankAddingStatus { initial, success, failed }

enum QuestionBankUpdatingStatus { initial, success, failed }

enum QuestionBankDeletingStatus { initial, success, failed }

@immutable
class QuestionBankState {
  final SubjectFetchingStatus subjectFetchingStatus;
  final QuestionBankAddingStatus questionBankAddingStatus;
  final QuestionBankUpdatingStatus questionBankUpdatingStatus;
  final QuestionBankDeletingStatus questionBankDeletingStatus;
  final Subject? subject;

  const QuestionBankState({
    this.subjectFetchingStatus = SubjectFetchingStatus.initial,
    this.questionBankAddingStatus = QuestionBankAddingStatus.initial,
    this.questionBankUpdatingStatus = QuestionBankUpdatingStatus.initial,
    this.questionBankDeletingStatus = QuestionBankDeletingStatus.initial,
    this.subject,
  });

  QuestionBankState copyWith({
    SubjectFetchingStatus? subjectFetchingStatus,
    QuestionBankAddingStatus? questionBankAddingStatus,
    QuestionBankUpdatingStatus? questionBankUpdatingStatus,
    QuestionBankDeletingStatus? questionBankDeletingStatus,
    Subject? subject,
  }) {
    return QuestionBankState(
      subject: subject ?? this.subject,
      subjectFetchingStatus:
          subjectFetchingStatus ?? this.subjectFetchingStatus,
      questionBankAddingStatus:
          questionBankAddingStatus ?? this.questionBankAddingStatus,
      questionBankUpdatingStatus:
          questionBankUpdatingStatus ?? this.questionBankUpdatingStatus,
      questionBankDeletingStatus:
          questionBankDeletingStatus ?? this.questionBankDeletingStatus,
    );
  }
}
