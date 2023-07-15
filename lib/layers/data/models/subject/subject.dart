import 'package:json_annotation/json_annotation.dart';
import 'package:pharmacy_dashboard/layers/data/models/question_bank/question_bank.dart';
import 'package:pharmacy_dashboard/layers/data/models/year_semester/year_semester.dart';
part 'subject.g.dart';

@JsonSerializable(explicitToJson: true)
class Subject {
  final int id;
  final String title;
  @JsonKey(name: 'is_active')
  final int? isActive;
  @JsonKey(name: 'year_semester')
  final Semester semester;
  @JsonKey(name: 'question_exams')
  final List<QuestionBank>? previousExams;
  @JsonKey(name: 'subject_chapters')
  final List<QuestionBank>? chapterBanks;

  Subject({
    required this.id,
    required this.title,
    this.isActive = 1,
    required this.semester,
    this.chapterBanks,
    this.previousExams,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return _$SubjectFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SubjectToJson(this);
  }

  Subject copyWith({
    int? id,
    String? title,
    int? isActive,
    Semester? semester,
    List<QuestionBank>? previousExams,
    List<QuestionBank>? chapterBanks,
  }) {
    return Subject(
      id: id ?? this.id,
      title: title ?? this.title,
      semester: semester ?? this.semester,
      chapterBanks: chapterBanks ?? this.chapterBanks,
      isActive: isActive ?? this.isActive,
      previousExams: previousExams ?? this.previousExams,
    );
  }
}
