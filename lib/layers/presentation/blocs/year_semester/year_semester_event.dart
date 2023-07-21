part of 'year_semester_bloc.dart';

@immutable
abstract class YearSemesterEvent {}

class YearSemesterFetched extends YearSemesterEvent {
  final GetYearSemestersParams getYearSemestersParams;

  YearSemesterFetched({required this.getYearSemestersParams});
}

class YearSemesterActiveToggled extends YearSemesterEvent {
  final int yearSemesterId;

  YearSemesterActiveToggled({required this.yearSemesterId});
}

class SubjectActiveToggled extends YearSemesterEvent {
  final int subjectId;

  SubjectActiveToggled({required this.subjectId});
}
