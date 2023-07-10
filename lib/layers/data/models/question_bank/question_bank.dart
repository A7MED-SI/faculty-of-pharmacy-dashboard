
import 'package:json_annotation/json_annotation.dart';
part 'question_bank.g.dart';

@JsonSerializable()
class QuestionBank {
  final int id;
  final String title;
  @JsonKey(name: 'bank_type')
  final int bankType;
  @JsonKey(name: 'is_active')
  final int isActive;
  @JsonKey(name: 'chapter_order')
  final int? chapterOrder;
  @JsonKey(name: 'year_of_exam')
  final String? yearOfExam;
  @JsonKey(name: 'semester_of_exam')
  final int? semesterOfExam;

  QuestionBank({
    required this.id,
    required this.title,
    required this.bankType,
    required this.isActive,
    this.chapterOrder,
    this.yearOfExam,
    this.semesterOfExam,
  });

  factory QuestionBank.fromJson(Map<String, dynamic> json) {
    return _$QuestionBankFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$QuestionBankToJson(this);
  }
}
