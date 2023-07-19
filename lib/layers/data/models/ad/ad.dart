import 'package:json_annotation/json_annotation.dart';
part 'ad.g.dart';

@JsonSerializable()
class Ad {
  final int id;
  final String title;
  final String image;
  @JsonKey(name: 'is_active')
  final int? isActive;

  Ad({
    required this.id,
    required this.title,
    required this.image,
    this.isActive = 1,
  });

  factory Ad.fromJson(Map<String, dynamic> json) {
    return _$AdFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AdToJson(this);
  }
}
