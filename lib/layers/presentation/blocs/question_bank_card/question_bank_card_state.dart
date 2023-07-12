part of 'question_bank_card_bloc.dart';

enum TogglingStatus { initial, success, failed }

@immutable
class QuestionBankCardState {
  final TogglingStatus togglingStatus;
  final QuestionBank questionBank;
  const QuestionBankCardState({
    this.togglingStatus = TogglingStatus.initial,
    required this.questionBank,
  });

  QuestionBankCardState copyWith({
    TogglingStatus? togglingStatus,
    QuestionBank? questionBank,
  }) {
    return QuestionBankCardState(
      togglingStatus: togglingStatus ?? this.togglingStatus,
      questionBank: questionBank ?? this.questionBank,
    );
  }
}
