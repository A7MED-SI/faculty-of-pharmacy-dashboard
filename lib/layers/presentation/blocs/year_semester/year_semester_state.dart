part of 'year_semester_bloc.dart';

enum YearSemestersFetchingStatus { initial, loading, success, failed }

@immutable
class YearSemesterState {
  final YearSemestersFetchingStatus yearSemestersFetchingStatus;
  final List<YearSemester> yearSemesters;

  const YearSemesterState({
    this.yearSemestersFetchingStatus = YearSemestersFetchingStatus.initial,
    this.yearSemesters = const [],
  });

  YearSemesterState copyWith({
    YearSemestersFetchingStatus? yearSemestersFetchingStatus,
    List<YearSemester>? yearSemesters,
  }) {
    return YearSemesterState(
      yearSemestersFetchingStatus:
          yearSemestersFetchingStatus ?? this.yearSemestersFetchingStatus,
      yearSemesters: yearSemesters ?? this.yearSemesters,
    );
  }
}
