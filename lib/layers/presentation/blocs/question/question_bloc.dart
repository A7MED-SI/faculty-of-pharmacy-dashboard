import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pharmacy_dashboard/layers/data/models/question_bank/question_bank.dart';
import 'package:pharmacy_dashboard/layers/data/repositories/question_bank_repository.dart';
import 'package:pharmacy_dashboard/layers/data/repositories/question_repository.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/question/add_question.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/question/add_question_from_exel.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/question/delete_question.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/question/delete_question_list.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/question/update_question.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/question_bank/show_question_bank.dart';

part 'question_event.dart';
part 'question_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  QuestionBloc() : super(const QuestionState()) {
    on<QuestionBankFetched>(_mapQuestionBankFetched);
    on<QuestionAdded>(_mapQuestionAdded);
    on<QuestionUpdated>(_mapQuestionUpdated);
    on<QuestionDeleted>(_mapQuestionDeleted);
    on<QuestionsFromExcelAdded>(_mapQuestionsFromExcelAdded);
    on<QuestionToggled>(_mapQuestionToggled);
    on<AllQuestionSelectedPressed>(_mapAllQuestionSelectedPressed);
    on<SelectedQuestionsDeleted>(_mapSelectedQuestionsDeleted);
  }

  final _showQuestionBankUseCase = ShowQuestionBankUseCase(
      questionBanksRepository: QuestionBankRepositoryImplementation());
  final _addQuestionUseCase = AddQuestionUseCase(
      questionRepository: QuestionRepositoryImplementation());
  final _updateQuestionUseCase = UpdateQuestionUseCase(
      questionRepository: QuestionRepositoryImplementation());
  final _deleteQuestionUseCase = DeleteQuestionUseCase(
      questionRepository: QuestionRepositoryImplementation());
  final _addQuestionsFromExcelUseCase = AddQuestionFromExelUseCase(
      questionRepository: QuestionRepositoryImplementation());
  final _deleteQuestionListUseCase = DeleteQuestionListUseCase(
      questionRepository: QuestionRepositoryImplementation());

  FutureOr<void> _mapQuestionBankFetched(
      QuestionBankFetched event, Emitter<QuestionState> emit) async {
    emit(state.copyWith(
        questionBankFetchingStatus: QuestionBankFetchingStatus.loading));
    final result = await _showQuestionBankUseCase(event.showQuestionBankParams);

    await result.fold(
      (l) async {
        emit(state.copyWith(
            questionBankFetchingStatus: QuestionBankFetchingStatus.failed));
      },
      (questionBank) async {
        emit(state.copyWith(
          questionBankFetchingStatus: QuestionBankFetchingStatus.success,
          questionBank: questionBank,
        ));
      },
    );
  }

  FutureOr<void> _mapQuestionAdded(
      QuestionAdded event, Emitter<QuestionState> emit) async {
    emit(state.copyWith(
        questionBankFetchingStatus: QuestionBankFetchingStatus.loading));
    final result = await _addQuestionUseCase(event.addQuestionParams);

    await result.fold(
      (l) async {
        emit(state.copyWith(
          addingQuestionStatus: AddingQuestionStatus.failed,
          errorMessage: l.message,
        ));
      },
      (r) async {
        emit(
            state.copyWith(addingQuestionStatus: AddingQuestionStatus.success));
      },
    );
    emit(const QuestionState());

    add(QuestionBankFetched(
        showQuestionBankParams: ShowQuestionBankParams(
      questionBankId: event.addQuestionParams.questionBankId,
    )));
  }

  FutureOr<void> _mapQuestionUpdated(
      QuestionUpdated event, Emitter<QuestionState> emit) async {
    emit(state.copyWith(
        questionBankFetchingStatus: QuestionBankFetchingStatus.loading));
    final result = await _updateQuestionUseCase(event.updateQuestionParams);

    await result.fold(
      (l) async {
        emit(state.copyWith(
          updatingQuestionStatus: UpdatingQuestionStatus.failed,
          errorMessage: l.message,
        ));
      },
      (r) async {
        emit(state.copyWith(
            updatingQuestionStatus: UpdatingQuestionStatus.success));
      },
    );
    emit(const QuestionState());

    add(QuestionBankFetched(
        showQuestionBankParams: ShowQuestionBankParams(
      questionBankId: event.updateQuestionParams.questionBankId,
    )));
  }

  FutureOr<void> _mapQuestionDeleted(
      QuestionDeleted event, Emitter<QuestionState> emit) async {
    emit(state.copyWith(
        questionBankFetchingStatus: QuestionBankFetchingStatus.loading));
    final result = await _deleteQuestionUseCase(event.questionId);

    await result.fold(
      (l) async {
        emit(state.copyWith(
          deletingQuestionStatus: DeletingQuestionStatus.failed,
          errorMessage: l.message,
        ));
      },
      (r) async {
        emit(state.copyWith(
            deletingQuestionStatus: DeletingQuestionStatus.success));
      },
    );
    emit(const QuestionState());

    add(QuestionBankFetched(
        showQuestionBankParams: ShowQuestionBankParams(
      questionBankId: event.questionBankId,
    )));
  }

  FutureOr<void> _mapQuestionsFromExcelAdded(
      QuestionsFromExcelAdded event, Emitter<QuestionState> emit) async {
    emit(state.copyWith(
        questionBankFetchingStatus: QuestionBankFetchingStatus.loading));
    final result =
        await _addQuestionsFromExcelUseCase(event.addQuestionFromExelParams);

    await result.fold(
      (l) async {
        emit(state.copyWith(
          addingQuestionsFromExcelStatus: AddingQuestionsFromExcelStatus.failed,
          errorMessage: l.message,
        ));
      },
      (r) async {
        emit(state.copyWith(
            addingQuestionsFromExcelStatus:
                AddingQuestionsFromExcelStatus.success));
      },
    );
    emit(const QuestionState());

    add(QuestionBankFetched(
        showQuestionBankParams: ShowQuestionBankParams(
      questionBankId: event.addQuestionFromExelParams.questionBankId,
    )));
  }

  FutureOr<void> _mapQuestionToggled(
      QuestionToggled event, Emitter<QuestionState> emit) {
    final Map<int, bool> isQuestionSelected =
        Map.from(state.isQuestionSelected);
    final List<int> selectedQuestion = List.from(state.selectedQuestions);
    if (state.isQuestionSelected.containsKey(event.id) &&
        state.isQuestionSelected[event.id]!) {
      selectedQuestion.removeWhere((element) => element == event.id);
      isQuestionSelected[event.id] = false;
    } else {
      selectedQuestion.add(event.id);
      isQuestionSelected[event.id] = true;
    }
    emit(state.copyWith(
      isQuestionSelected: isQuestionSelected,
      selectedQuestions: selectedQuestion,
    ));
  }

  FutureOr<void> _mapAllQuestionSelectedPressed(
      AllQuestionSelectedPressed event, Emitter<QuestionState> emit) {
    Map<int, bool> isQuestionSelected = {};
    List<int> selectedQuestion = [];
    if (event.selectionValue) {
      for (var q in state.questionBank!.questions!) {
        selectedQuestion.add(q.id);
        isQuestionSelected[q.id] = true;
      }
    }
    emit(state.copyWith(
      isQuestionSelected: isQuestionSelected,
      selectedQuestions: selectedQuestion,
      allQuestionsSelected: event.selectionValue,
    ));
  }

  FutureOr<void> _mapSelectedQuestionsDeleted(
      SelectedQuestionsDeleted event, Emitter<QuestionState> emit) async {
    log(state.selectedQuestions.toString());
    emit(state.copyWith(
        questionBankFetchingStatus: QuestionBankFetchingStatus.loading));
    final result = await _deleteQuestionListUseCase(state.selectedQuestions);

    await result.fold(
      (l) async {
        emit(state.copyWith(
          deletingQuestionStatus: DeletingQuestionStatus.failed,
          errorMessage: l.message,
        ));
      },
      (r) async {
        emit(state.copyWith(
            deletingQuestionStatus: DeletingQuestionStatus.success));
      },
    );
    final qBankId = state.questionBank!.id;
    emit(const QuestionState());

    add(QuestionBankFetched(
        showQuestionBankParams: ShowQuestionBankParams(
      questionBankId: qBankId,
    )));
  }
}
