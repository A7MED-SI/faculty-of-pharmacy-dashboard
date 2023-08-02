part of 'question_bank_card_bloc.dart';

enum TogglingStatus { initial, success, failed }

@immutable
class QuestionBankCardState {
  final TogglingStatus togglingStatus;
  final QuestionBank questionBank;
  final String? errorMessage;
  const QuestionBankCardState({
    this.togglingStatus = TogglingStatus.initial,
    required this.questionBank,
    this.errorMessage,
  });

  QuestionBankCardState copyWith({
    TogglingStatus? togglingStatus,
    QuestionBank? questionBank,
    String? errorMessage,
  }) {
    return QuestionBankCardState(
      togglingStatus: togglingStatus ?? this.togglingStatus,
      questionBank: questionBank ?? this.questionBank,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
