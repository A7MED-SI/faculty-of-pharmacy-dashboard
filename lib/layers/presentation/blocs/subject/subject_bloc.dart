import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pharmacy_dashboard/layers/data/models/subject/subject.dart';
import 'package:pharmacy_dashboard/layers/data/repositories/subject_repository.dart';
import 'package:pharmacy_dashboard/layers/data/repositories/year_semester_repositroy.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/subject/add_subject.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/subject/delete_subject.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/subject/get_subjects.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/subject/toggle_subject_active.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/subject/update_subject.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/year_semester/get_year_semesters.dart';

part 'subject_event.dart';
part 'subject_state.dart';

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  SubjectBloc() : super(const SubjectState()) {
    on<SubjectsFetched>(_mapSubjectsFetched);
    on<SemestersFetched>(_mapSemestersFetched);
    on<SemesterValueChanged>(_mapSemesterValueChanged);
    on<SubjectAdded>(_mapSubjectAdded);
    on<SubjectUpdated>(_mapSubjectUpdated);
    on<SubjectDeleted>(_mapSubjectDeleted);
    on<SubjectActiveStatusToggled>(_mapSubjectActiveStatusToggled);
  }
  final _getSubjectsUseCase =
      GetSubjectsUseCase(subjectsRepository: SubjectRepositoryImplementation());
  final _getYearSemestersUseCase = GetYearSemestersUseCase(
      yearSemesterRepository: YearSemesterRepositoryImplementation());
  final _addSubjectUseCase =
      AddSubjectUseCase(subjectsRepository: SubjectRepositoryImplementation());
  final _updateSubjectUseCase = UpdateSubjectUseCase(
      subjectsRepository: SubjectRepositoryImplementation());
  final _deleteSubjectUseCase = DeleteSubjectUseCase(
      subjectRepository: SubjectRepositoryImplementation());
  final _toggleSubjectActiveStatus = ToggleSubjectActiveUseCase(
      subjectRepository: SubjectRepositoryImplementation());

  FutureOr<void> _mapSubjectsFetched(
      SubjectsFetched event, Emitter<SubjectState> emit) async {
    final result = await _getSubjectsUseCase(event.getSubjectsParams);
    await result.fold(
      (l) async {
        emit(state.copyWith(
            subjectsFetchingStatus: SubjectsFetchingStatus.failed));
      },
      (subjects) async {
        emit(state.copyWith(
          subjectsFetchingStatus: SubjectsFetchingStatus.success,
          subjects: subjects,
        ));
      },
    );
  }

  FutureOr<void> _mapSemestersFetched(
      SemestersFetched event, Emitter<SubjectState> emit) async {
    emit(state.copyWith(
        semestersFetchingStatus: SemestersFetchingStatus.initial));
    final result =
        await _getYearSemestersUseCase(GetYearSemestersParams(include: ''));

    await result.fold(
      (l) async {
        emit(state.copyWith(
            semestersFetchingStatus: SemestersFetchingStatus.failed));
      },
      (yearSemesters) async {
        List<({String text, int value})> semesters = [];
        for (var ys in yearSemesters) {
          for (var sem in ys.semesters) {
            final String text = '${ys.arabicName} - ${sem.arabicName}';
            final int value = sem.id;
            semesters.add((text: text, value: value));
          }
        }
        emit(state.copyWith(
          semestersFetchingStatus: SemestersFetchingStatus.success,
          semesters: semesters,
        ));
      },
    );
  }

  FutureOr<void> _mapSemesterValueChanged(
      SemesterValueChanged event, Emitter<SubjectState> emit) {
    emit(state.copyWith(currenSemesterId: event.newVlaue));
  }

  FutureOr<void> _mapSubjectAdded(
      SubjectAdded event, Emitter<SubjectState> emit) async {
    emit(
        state.copyWith(subjectsFetchingStatus: SubjectsFetchingStatus.loading));
    final result = await _addSubjectUseCase(event.addSubjectParams);

    await result.fold(
      (l) async {
        emit(state.copyWith(
            subjectsFetchingStatus: SubjectsFetchingStatus.success,
            subjectAddingStatus: SubjectAddingStatus.failed));
        emit(state.copyWith(subjectAddingStatus: SubjectAddingStatus.initial));
      },
      (subject) async {
        final subjects = List.of(state.subjects)..insert(0, subject);
        emit(state.copyWith(
            subjectsFetchingStatus: SubjectsFetchingStatus.success,
            subjectAddingStatus: SubjectAddingStatus.success,
            subjects: subjects));
        emit(state.copyWith(subjectAddingStatus: SubjectAddingStatus.initial));
      },
    );
  }

  FutureOr<void> _mapSubjectUpdated(
      SubjectUpdated event, Emitter<SubjectState> emit) async {
    emit(
        state.copyWith(subjectsFetchingStatus: SubjectsFetchingStatus.loading));
    final result = await _updateSubjectUseCase(event.updateSubjectParams);

    await result.fold(
      (l) async {
        emit(state.copyWith(
            subjectsFetchingStatus: SubjectsFetchingStatus.success,
            subjectUpdatingStatus: SubjectUpdatingStatus.failed));
        emit(state.copyWith(
            subjectUpdatingStatus: SubjectUpdatingStatus.initial));
      },
      (subject) async {
        final subjectIndex = state.subjects.indexWhere(
          (subject) {
            return subject.id == event.updateSubjectParams.subjectId;
          },
        );
        final subjects = List.of(state.subjects);
        subjects[subjectIndex] = subject;
        emit(state.copyWith(
            subjectsFetchingStatus: SubjectsFetchingStatus.success,
            subjectUpdatingStatus: SubjectUpdatingStatus.success,
            subjects: subjects));
        emit(state.copyWith(
            subjectUpdatingStatus: SubjectUpdatingStatus.initial));
      },
    );
  }

  FutureOr<void> _mapSubjectDeleted(
      SubjectDeleted event, Emitter<SubjectState> emit) async {
    emit(
        state.copyWith(subjectsFetchingStatus: SubjectsFetchingStatus.loading));
    final result = await _deleteSubjectUseCase(event.subjectId);

    await result.fold(
      (l) async {
        emit(state.copyWith(
            subjectsFetchingStatus: SubjectsFetchingStatus.success,
            subjectDeletingStatus: SubjectDeletingStatus.failed));
        emit(state.copyWith(
            subjectDeletingStatus: SubjectDeletingStatus.initial));
      },
      (r) async {
        final subjects = List.of(state.subjects);
        subjects.removeWhere((subject) => subject.id == event.subjectId);
        emit(state.copyWith(
          subjectsFetchingStatus: SubjectsFetchingStatus.success,
          subjectDeletingStatus: SubjectDeletingStatus.success,
          subjects: subjects,
        ));
        emit(state.copyWith(
            subjectDeletingStatus: SubjectDeletingStatus.initial));
      },
    );
  }

  FutureOr<void> _mapSubjectActiveStatusToggled(
      SubjectActiveStatusToggled event, Emitter<SubjectState> emit) async {
    var subjectIndex =
        state.subjects.indexWhere((subject) => subject.id == event.subjectId);
    var oldSubject = state.subjects[subjectIndex];
    var newSubject = Subject(
      id: oldSubject.id,
      title: oldSubject.title,
      semester: oldSubject.semester,
      isActive: (oldSubject.isActive! + 1) % 2,
    );
    final subjects = List.of(state.subjects);
    subjects[subjectIndex] = newSubject;
    emit(state.copyWith(subjects: subjects));
    final result = await _toggleSubjectActiveStatus(event.subjectId);

    await result.fold(
      (l) async {
        subjects[subjectIndex] = oldSubject;
        emit(state.copyWith(
            subjects: subjects,
            subjectTogglingActiveStatus: SubjectTogglingActiveStatus.failed));
        emit(state.copyWith(
            subjectTogglingActiveStatus: SubjectTogglingActiveStatus.initial));
      },
      (r) async {},
    );
  }
}
