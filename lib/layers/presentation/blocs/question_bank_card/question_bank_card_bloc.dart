import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pharmacy_dashboard/layers/data/models/question_bank/question_bank.dart';

import '../../../data/repositories/question_bank_repository.dart';
import '../../../domain/use_cases/question_bank/toggle_question_bank_active.dart';

part 'question_bank_card_event.dart';
part 'question_bank_card_state.dart';

class QuestionBankCardBloc
    extends Bloc<QuestionBankCardEvent, QuestionBankCardState> {
  QuestionBankCardBloc({required QuestionBank questionBank})
      : super(QuestionBankCardState(questionBank: questionBank)) {
    on<QuestionBankCardActiveToggled>(_mapQuestionBankCardActiveToggled);
  }

  final _toggleQuestionBankActiveUseCase = ToggleQuestionBankActiveUseCase(
      questionBankRepository: QuestionBankRepositoryImplementation());

  FutureOr<void> _mapQuestionBankCardActiveToggled(
      QuestionBankCardActiveToggled event,
      Emitter<QuestionBankCardState> emit) async {
    final originalQuestionBank = state.questionBank;
    emit(state.copyWith(
        questionBank: originalQuestionBank.copyWith(
            isActive: (originalQuestionBank.isActive! + 1) % 2)));

    final result =
        await _toggleQuestionBankActiveUseCase(originalQuestionBank.id);

    await result.fold(
      (l) async {
        emit(state.copyWith(
          questionBank: originalQuestionBank,
          togglingStatus: TogglingStatus.failed,
          errorMessage: l.message,
        ));
        emit(state.copyWith(togglingStatus: TogglingStatus.initial));
      },
      (r) async {},
    );
  }
}
