part of 'question_dialog_bloc.dart';

@immutable
abstract class QuestionDialogEvent {}

class AnswerAdded extends QuestionDialogEvent {}

class AnswerDeleted extends QuestionDialogEvent {
  final int index;

  AnswerDeleted(this.index);
}

class HintToggled extends QuestionDialogEvent {}

class AnswerValidityToggled extends QuestionDialogEvent {
  final int index;

  AnswerValidityToggled({
    required this.index,
  });
}

class ImageAdded extends QuestionDialogEvent {
  final Uint8List image;

  ImageAdded({required this.image});
}

class ImageDeleted extends QuestionDialogEvent {}
