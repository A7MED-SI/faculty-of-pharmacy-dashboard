part of 'subject_bloc.dart';

@immutable
abstract class SubjectEvent {}

class SubjectsFetched extends SubjectEvent {
  final GetSubjectsParams getSubjectsParams;

  SubjectsFetched({required this.getSubjectsParams});
}

class SubjectAdded extends SubjectEvent {
  final AddSubjectParams addSubjectParams;

  SubjectAdded({required this.addSubjectParams});
}

class SubjectUpdated extends SubjectEvent {
  final UpdateSubjectParams updateSubjectParams;

  SubjectUpdated({required this.updateSubjectParams});
}

class SubjectActiveStatusToggled extends SubjectEvent {
  final int subjectId;

  SubjectActiveStatusToggled({required this.subjectId});
}

class SubjectDeleted extends SubjectEvent {
  final int subjectId;

  SubjectDeleted({required this.subjectId});
}

class SubjectFetched extends SubjectEvent {
  final int subjectId;

  SubjectFetched(this.subjectId);
}

class SemestersFetched extends SubjectEvent {}

class MainSemesterValueChanged extends SubjectEvent {
  final int? newVlaue;

  MainSemesterValueChanged(this.newVlaue);
}

class DialogSemesterValueChanged extends SubjectEvent {
  final int? newVlaue;

  DialogSemesterValueChanged(this.newVlaue);
}