import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pharmacy_dashboard/layers/data/repositories/question_bank_repository.dart';
import 'package:pharmacy_dashboard/layers/data/repositories/subject_repository.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/question_bank/add_question_bank.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/question_bank/delete_question_bank.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/question_bank/update_question_bank.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/subject/show_subject.dart';

import '../../../data/models/subject/subject.dart';

part 'question_bank_event.dart';
part 'question_bank_state.dart';

class QuestionBankBloc extends Bloc<QuestionBankEvent, QuestionBankState> {
  QuestionBankBloc() : super(const QuestionBankState()) {
    on<SubjectFetched>(_mapSubjectFetched);
    on<QuestionBankAdded>(_mapQuestionBankAdded);
    on<QuestionBankUpdated>(_mapQuestionBankUpdated);
    on<QuestionBankDeleted>(_mapQuestionBankDeleted);
  }

  final _showSubjectUseCase =
      ShowSubjectUseCase(subjectsRepository: SubjectRepositoryImplementation());
  final _addQuestionBankUseCase = AddQuestionBankUseCase(
      questionBanksRepository: QuestionBankRepositoryImplementation());
  final _updateQuestionBankUseCase = UpdateQuestionBankUseCase(
      questionBanksRepository: QuestionBankRepositoryImplementation());
  final _deleteQuestionBankseCase = DeleteQuestionBankUseCase(
      questionBankRepository: QuestionBankRepositoryImplementation());

  FutureOr<void> _mapSubjectFetched(
      SubjectFetched event, Emitter<QuestionBankState> emit) async {
    emit(state.copyWith(subjectFetchingStatus: SubjectFetchingStatus.loading));
    final result = await _showSubjectUseCase(event.params);

    await result.fold(
      (l) async {
        emit(state.copyWith(
            subjectFetchingStatus: SubjectFetchingStatus.failed));
      },
      (subject) async {
        emit(state.copyWith(
          subjectFetchingStatus: SubjectFetchingStatus.success,
          subject: subject,
        ));
      },
    );
  }

  FutureOr<void> _mapQuestionBankAdded(
      QuestionBankAdded event, Emitter<QuestionBankState> emit) async {
    final subject = state.subject;
    emit(const QuestionBankState());
    final result = await _addQuestionBankUseCase(event.addQuestionBankParams);

    await result.fold(
      (l) async {
        emit(state.copyWith(
          questionBankAddingStatus: QuestionBankAddingStatus.failed,
          errorMessage: l.message,
        ));
      },
      (r) async {
        emit(state.copyWith(
            questionBankAddingStatus: QuestionBankAddingStatus.success));
      },
    );
    emit(state.copyWith(
        questionBankAddingStatus: QuestionBankAddingStatus.initial));
    add(SubjectFetched(ShowSubjectParams(subjectId: subject!.id)));
  }

  FutureOr<void> _mapQuestionBankUpdated(
      QuestionBankUpdated event, Emitter<QuestionBankState> emit) async {
    final subject = state.subject;
    emit(const QuestionBankState());
    final result =
        await _updateQuestionBankUseCase(event.updateQuestionBankParams);

    await result.fold(
      (l) async {
        emit(state.copyWith(
          questionBankUpdatingStatus: QuestionBankUpdatingStatus.failed,
          errorMessage: l.message,
        ));
      },
      (r) async {
        emit(state.copyWith(
            questionBankUpdatingStatus: QuestionBankUpdatingStatus.success));
      },
    );
    emit(state.copyWith(
        questionBankUpdatingStatus: QuestionBankUpdatingStatus.initial));
    add(SubjectFetched(ShowSubjectParams(subjectId: subject!.id)));
  }

  FutureOr<void> _mapQuestionBankDeleted(
      QuestionBankDeleted event, Emitter<QuestionBankState> emit) async {
    final subject = state.subject;
    emit(const QuestionBankState());
    final result = await _deleteQuestionBankseCase(event.questionBankId);

    await result.fold(
      (l) async {
        emit(state.copyWith(
          questionBankDeletingStatus: QuestionBankDeletingStatus.failed,
          errorMessage: l.message,
        ));
      },
      (r) async {
        emit(state.copyWith(
            questionBankDeletingStatus: QuestionBankDeletingStatus.success));
      },
    );
    emit(state.copyWith(
        questionBankDeletingStatus: QuestionBankDeletingStatus.initial));
    add(SubjectFetched(ShowSubjectParams(subjectId: subject!.id)));
  }
}
