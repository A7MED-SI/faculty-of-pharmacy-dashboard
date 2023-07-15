import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'question_dialog_event.dart';
part 'question_dialog_state.dart';

class QuestionDialogBloc
    extends Bloc<QuestionDialogEvent, QuestionDialogState> {
  QuestionDialogBloc({
    List<TextEditingController>? controllers,
    bool? showHint,
    List<bool>? answersValidity,
  }) : super(QuestionDialogState(
          answersControllers: controllers ??
              [
                TextEditingController(),
                TextEditingController(),
              ],
          showHint: showHint ?? false,
          answersValidity: answersValidity ?? [true, false],
        )) {
    on<AnswerAdded>(_mapAnswerAdded);
    on<AnswerDeleted>(_mapAnswerDeleted);
    on<HintToggled>(_mapHintToggled);
    on<AnswerValidityToggled>(_mapAnswerValidityChanged);
    on<ImageAdded>(_mapImageAdded);
    on<ImageDeleted>(_mapImageDeleted);
  }

  FutureOr<void> _mapAnswerAdded(
      AnswerAdded event, Emitter<QuestionDialogState> emit) async {
    emit(state.copyWith(
      answersControllers: List.of(state.answersControllers)
        ..add(TextEditingController()),
      answersValidity: List.of(state.answersValidity)..add(false),
    ));
  }

  FutureOr<void> _mapAnswerDeleted(
      AnswerDeleted event, Emitter<QuestionDialogState> emit) async {
    emit(state.copyWith(
      answersControllers: List.of(state.answersControllers)
        ..removeAt(event.index),
      answersValidity: List.of(state.answersValidity)..removeAt(event.index),
    ));
  }

  FutureOr<void> _mapHintToggled(
      HintToggled event, Emitter<QuestionDialogState> emit) {
    emit(state.copyWith(showHint: !state.showHint));
  }

  FutureOr<void> _mapAnswerValidityChanged(
      AnswerValidityToggled event, Emitter<QuestionDialogState> emit) {
    final answersValidity = List.of(state.answersValidity);
    answersValidity[event.index] ^= true;
    emit(state.copyWith(answersValidity: answersValidity));
  }

  FutureOr<void> _mapImageAdded(
      ImageAdded event, Emitter<QuestionDialogState> emit) {
    emit(state.copyWith(image: event.image));
  }

  FutureOr<void> _mapImageDeleted(
      ImageDeleted event, Emitter<QuestionDialogState> emit) {
    emit(QuestionDialogState(
      answersControllers: state.answersControllers,
      answersValidity: state.answersValidity,
      showHint: state.showHint,
    ));
  }
}
