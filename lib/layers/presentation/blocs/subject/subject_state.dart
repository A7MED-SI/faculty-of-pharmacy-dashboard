part of 'subject_bloc.dart';

enum SubjectsFetchingStatus { initial, loading, success, failed }

enum SemestersFetchingStatus { initial, loading, success, failed }

enum SubjectAddingStatus { initial, success, failed }

enum SubjectUpdatingStatus { initial, success, failed }

enum SubjectDeletingStatus { initial, success, failed }

enum SubjectTogglingActiveStatus { initial, success, failed }

@immutable
class SubjectState {
  final SubjectsFetchingStatus subjectsFetchingStatus;
  final SemestersFetchingStatus semestersFetchingStatus;
  final SubjectAddingStatus subjectAddingStatus;
  final SubjectUpdatingStatus subjectUpdatingStatus;
  final SubjectDeletingStatus subjectDeletingStatus;
  final SubjectTogglingActiveStatus subjectTogglingActiveStatus;
  final List<Subject> subjects;
  final List<({String text, int value})> semesters;
  final int? mainSemesterId;
  final int? dialogSemesterId;

  const SubjectState({
    this.subjectsFetchingStatus = SubjectsFetchingStatus.initial,
    this.semestersFetchingStatus = SemestersFetchingStatus.initial,
    this.subjectAddingStatus = SubjectAddingStatus.initial,
    this.subjectUpdatingStatus = SubjectUpdatingStatus.initial,
    this.subjectDeletingStatus = SubjectDeletingStatus.initial,
    this.subjectTogglingActiveStatus = SubjectTogglingActiveStatus.initial,
    this.subjects = const [],
    this.semesters = const [],
    this.mainSemesterId,
    this.dialogSemesterId,
  });

  SubjectState copyWith({
    SubjectsFetchingStatus? subjectsFetchingStatus,
    SemestersFetchingStatus? semestersFetchingStatus,
    SubjectAddingStatus? subjectAddingStatus,
    SubjectUpdatingStatus? subjectUpdatingStatus,
    SubjectDeletingStatus? subjectDeletingStatus,
    SubjectTogglingActiveStatus? subjectTogglingActiveStatus,
    List<Subject>? subjects,
    List<({String text, int value})>? semesters,
    int? mainSemesterId,
    int? dialogSemesterId,
  }) {
    return SubjectState(
      subjects: subjects ?? this.subjects,
      subjectsFetchingStatus:
          subjectsFetchingStatus ?? this.subjectsFetchingStatus,
      semestersFetchingStatus:
          semestersFetchingStatus ?? this.semestersFetchingStatus,
      semesters: semesters ?? this.semesters,
      mainSemesterId: mainSemesterId ?? this.mainSemesterId,
      subjectAddingStatus: subjectAddingStatus ?? this.subjectAddingStatus,
      subjectUpdatingStatus:
          subjectUpdatingStatus ?? this.subjectUpdatingStatus,
      subjectDeletingStatus:
          subjectDeletingStatus ?? this.subjectDeletingStatus,
      subjectTogglingActiveStatus:
          subjectTogglingActiveStatus ?? this.subjectTogglingActiveStatus,
      dialogSemesterId: dialogSemesterId ?? this.dialogSemesterId,
    );
  }
}
