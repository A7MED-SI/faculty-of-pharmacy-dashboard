import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

@JsonSerializable(explicitToJson: true)
class Question {
  final int id;
  @JsonKey(name: 'question_text')
  final String questionText;
  final String? hint;
  final String? image;
  @JsonKey(name: 'question_bank_id')
  final int questionBankId;
  final List<Answer> answers;
  Question({
    required this.id,
    required this.questionText,
    required this.questionBankId,
    required this.answers,
    this.hint,
    this.image,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return _$QuestionFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$QuestionToJson(this);
  }
}

@JsonSerializable()
class Answer {
  final int id;
  @JsonKey(name: 'answer_text')
  final String answerText;
  @JsonKey(name: 'is_true')
  final int isTrue;

  Answer({
    required this.id,
    required this.answerText,
    required this.isTrue,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return _$AnswerFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AnswerToJson(this);
  }

  Map<String, dynamic> toRawJson() {
    return {
      'answer_text': answerText,
      'is_true': isTrue,
    };
  }
}
