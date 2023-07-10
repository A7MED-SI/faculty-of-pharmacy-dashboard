import 'package:json_annotation/json_annotation.dart';
import 'package:pharmacy_dashboard/layers/data/models/question_bank/question_bank.dart';
part 'subject.g.dart';

@JsonSerializable()
class Subject {
  final int id;
  final String title;
  @JsonKey(name: 'is_active')
  final int? isActive;
  @JsonKey(name: 'year_semester_id')
  final int yearSemesterId;
  @JsonKey(name: 'question_exams')
  final List<QuestionBank>? previousExams;
  @JsonKey(name: 'subject_chapters')
  final List<QuestionBank>? chapterBanks;

  Subject({
    required this.id,
    required this.title,
    this.isActive = 1,
    required this.yearSemesterId,
    this.chapterBanks,
    this.previousExams,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return _$SubjectFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SubjectToJson(this);
  }
}
