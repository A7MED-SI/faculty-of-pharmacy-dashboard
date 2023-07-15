// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      id: json['id'] as int,
      questionText: json['question_text'] as String,
      questionBankId: json['question_bank_id'] as int,
      answers: (json['answers'] as List<dynamic>)
          .map((e) => Answer.fromJson(e as Map<String, dynamic>))
          .toList(),
      hint: json['hint'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'id': instance.id,
      'question_text': instance.questionText,
      'hint': instance.hint,
      'image': instance.image,
      'question_bank_id': instance.questionBankId,
      'answers': instance.answers.map((e) => e.toJson()).toList(),
    };

Answer _$AnswerFromJson(Map<String, dynamic> json) => Answer(
      id: json['id'] as int,
      answerText: json['answer_text'] as String,
      isTrue: json['is_true'] as int,
    );

Map<String, dynamic> _$AnswerToJson(Answer instance) => <String, dynamic>{
      'id': instance.id,
      'answer_text': instance.answerText,
      'is_true': instance.isTrue,
    };
