import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pharmacy_dashboard/layers/data/repositories/subject_repository.dart';
import 'package:pharmacy_dashboard/layers/data/repositories/year_semester_repositroy.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/subject/toggle_subject_active.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/year_semester/toggle_year_semester_active.dart';

import '../../../data/models/year_semester/year_semester.dart';
import '../../../domain/use_cases/year_semester/get_year_semesters.dart';

part 'year_semester_event.dart';
part 'year_semester_state.dart';

class YearSemesterBloc extends Bloc<YearSemesterEvent, YearSemesterState> {
  YearSemesterBloc() : super(const YearSemesterState()) {
    on<YearSemesterFetched>(_mapYearSemesterFetched);
    on<YearSemesterActiveToggled>(_mapYearSemesterActiveToggled);
    on<SubjectActiveToggled>(_mapSubjectActiveToggled);
  }
  final _getYearSemestersUseCase = GetYearSemestersUseCase(
      yearSemesterRepository: YearSemesterRepositoryImplementation());
  final _toggleYearSemesterActiveUseCase = ToggleYearSemesterActiveUseCase(
      yearSemesterRepository: YearSemesterRepositoryImplementation());
  final _toggleSubjectActiveUseCase = ToggleSubjectActiveUseCase(
      subjectRepository: SubjectRepositoryImplementation());
  FutureOr<void> _mapYearSemesterFetched(
      YearSemesterFetched event, Emitter<YearSemesterState> emit) async {
    final result = await _getYearSemestersUseCase(event.getYearSemestersParams);

    await result.fold(
      (l) async {
        emit(state.copyWith(
            yearSemestersFetchingStatus: YearSemestersFetchingStatus.failed));
      },
      (yearSemesters) async {
        emit(state.copyWith(
          yearSemestersFetchingStatus: YearSemestersFetchingStatus.success,
          yearSemesters: yearSemesters,
        ));
      },
    );
  }

  FutureOr<void> _mapYearSemesterActiveToggled(
      YearSemesterActiveToggled event, Emitter<YearSemesterState> emit) async {
    final originalYearSemesters = state.yearSemesters;
    var yearIndex = 0;
    var semesterIndex = 0;
    outerloop:
    for (int i = 0; i < state.yearSemesters.length; i++) {
      for (int j = 0; j < state.yearSemesters[i].semesters.length; j++) {
        if (state.yearSemesters[i].semesters[j].id == event.yearSemesterId) {
          yearIndex = i;
          semesterIndex = j;
          break outerloop;
        }
      }
    }
    final yearSemesters = List.of(state.yearSemesters);
    var yearSemester = yearSemesters[yearIndex];
    final semesters = List.of(yearSemester.semesters);
    final newSemester = semesters[semesterIndex].copyWith(
      isActive: (semesters[semesterIndex].isActive! + 1) % 2,
    );
    semesters[semesterIndex] = newSemester;
    yearSemester = yearSemester.copyWith(semesters: semesters);
    yearSemesters[yearIndex] = yearSemester;
    emit(state.copyWith(yearSemesters: yearSemesters));

    final result = await _toggleYearSemesterActiveUseCase(event.yearSemesterId);

    await result.fold(
      (l) async {
        emit(state.copyWith(
          semesterSubjectTogglingStatus: SemesterSubjectTogglingStatus.failed,
          yearSemesters: originalYearSemesters,
        ));
        emit(state.copyWith(
            semesterSubjectTogglingStatus:
                SemesterSubjectTogglingStatus.initial));
      },
      (r) async {},
    );
  }

  FutureOr<void> _mapSubjectActiveToggled(
      SubjectActiveToggled event, Emitter<YearSemesterState> emit) async {
    final originalYearSemesters = state.yearSemesters;
    var yearIndex = 0;
    var semesterIndex = 0;
    var subjectIndex = 0;
    outerloop:
    for (int i = 0; i < originalYearSemesters.length; i++) {
      for (int j = 0; j < originalYearSemesters[i].semesters.length; j++) {
        for (int k = 0;
            k < originalYearSemesters[i].semesters[j].subjects!.length;
            k++) {
          if (state.yearSemesters[i].semesters[j].subjects![k].id ==
              event.subjectId) {
            yearIndex = i;
            semesterIndex = j;
            subjectIndex = k;
            break outerloop;
          }
        }
      }
    }
    final yearSemesters = List.of(state.yearSemesters);
    var yearSemester = yearSemesters[yearIndex];
    final semesters = List.of(yearSemester.semesters);
    var newSemester = semesters[semesterIndex];
    final newSubjects = newSemester.subjects!;
    final newSubject = newSubjects[subjectIndex]
        .copyWith(isActive: (newSubjects[subjectIndex].isActive! + 1) % 2);
    newSubjects[subjectIndex] = newSubject;
    newSemester = newSemester.copyWith(subjects: newSubjects);
    semesters[semesterIndex] = newSemester;
    yearSemester = yearSemester.copyWith(semesters: semesters);
    yearSemesters[yearIndex] = yearSemester;
    emit(state.copyWith(yearSemesters: yearSemesters));

    final result = await _toggleSubjectActiveUseCase(event.subjectId);

    await result.fold(
      (l) async {
        emit(state.copyWith(
          semesterSubjectTogglingStatus: SemesterSubjectTogglingStatus.failed,
          yearSemesters: originalYearSemesters,
        ));
        emit(state.copyWith(
            semesterSubjectTogglingStatus:
                SemesterSubjectTogglingStatus.initial));
      },
      (r) async {},
    );
  }
}
