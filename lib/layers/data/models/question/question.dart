class Question {
  final String text;
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question('');
  }

  Map<String, dynamic> toJson() {
    return {};
  }

  Question(this.text);
}
