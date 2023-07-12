part of 'question_bank_card_bloc.dart';

@immutable
abstract class QuestionBankCardEvent {}

class QuestionBankCardActiveToggled extends QuestionBankCardEvent {

  QuestionBankCardActiveToggled();
}
