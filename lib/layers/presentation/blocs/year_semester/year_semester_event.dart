part of 'year_semester_bloc.dart';

@immutable
abstract class YearSemesterEvent {}

class YearSemesterFetched extends YearSemesterEvent {
  final GetYearSemestersParams getYearSemestersParams;

  YearSemesterFetched({required this.getYearSemestersParams});
}

class YearSemesterActiveToggled extends YearSemesterEvent {
  final int yearSemesterId;
  final int year;
  final int semester;

  YearSemesterActiveToggled({
    required this.yearSemesterId,
    required this.year,
    required this.semester,
  });
}
