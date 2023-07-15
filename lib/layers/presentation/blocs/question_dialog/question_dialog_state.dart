part of 'question_dialog_bloc.dart';

@immutable
class QuestionDialogState {
  final List<TextEditingController> answersControllers;
  final List<bool> answersValidity;
  final bool showHint;
  final Uint8List? image;

  const QuestionDialogState({
    required this.answersControllers,
    required this.answersValidity,
    required this.showHint,
    this.image,
  });

  QuestionDialogState copyWith({
    List<TextEditingController>? answersControllers,
    List<bool>? answersValidity,
    bool? showHint,
    Uint8List? image,
  }) {
    return QuestionDialogState(
      answersControllers: answersControllers ?? this.answersControllers,
      showHint: showHint ?? this.showHint,
      answersValidity: answersValidity ?? this.answersValidity,
      image: image ?? this.image,
    );
  }
}
