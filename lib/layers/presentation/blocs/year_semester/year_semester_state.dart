part of 'year_semester_bloc.dart';

enum YearSemestersFetchingStatus { initial, loading, success, failed }

enum SemesterSubjectTogglingStatus { initial, success, failed }

@immutable
class YearSemesterState {
  final YearSemestersFetchingStatus yearSemestersFetchingStatus;
  final SemesterSubjectTogglingStatus semesterSubjectTogglingStatus;
  final List<YearSemester> yearSemesters;

  const YearSemesterState({
    this.yearSemestersFetchingStatus = YearSemestersFetchingStatus.initial,
    this.semesterSubjectTogglingStatus = SemesterSubjectTogglingStatus.initial,
    this.yearSemesters = const [],
  });

  YearSemesterState copyWith({
    YearSemestersFetchingStatus? yearSemestersFetchingStatus,
    SemesterSubjectTogglingStatus? semesterSubjectTogglingStatus,
    List<YearSemester>? yearSemesters,
  }) {
    return YearSemesterState(
      yearSemestersFetchingStatus:
          yearSemestersFetchingStatus ?? this.yearSemestersFetchingStatus,
      semesterSubjectTogglingStatus:
          semesterSubjectTogglingStatus ?? this.semesterSubjectTogglingStatus,
      yearSemesters: yearSemesters ?? this.yearSemesters,
    );
  }
}
