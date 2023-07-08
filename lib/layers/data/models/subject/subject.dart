import 'package:json_annotation/json_annotation.dart';
part 'subject.g.dart';

@JsonSerializable()
class Subject {
  final int id;
  final String title;
  @JsonKey(name: 'is_active')
  final int isActive;
  @JsonKey(name: 'year_semester_id')
  final int yearSemesterId;

  Subject({
    required this.id,
    required this.title,
    required this.isActive,
    required this.yearSemesterId,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return _$SubjectFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SubjectToJson(this);
  }
}