import 'package:json_annotation/json_annotation.dart';
part 'subject_image.g.dart';

@JsonSerializable()
class SubjectImage {
  final int id;
  final String image;
  final String title;

  SubjectImage({
    required this.id,
    required this.image,
    required this.title,
  });

  factory SubjectImage.fromJson(Map<String, dynamic> json) {
    return _$SubjectImageFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SubjectImageToJson(this);
  }
}
