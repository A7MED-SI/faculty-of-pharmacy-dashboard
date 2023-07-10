class Ad {
  final int id;
  final String title;

  Ad(this.id, this.title);

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(1, 'title');
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}
