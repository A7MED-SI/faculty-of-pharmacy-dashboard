class Notification {
  final int id;
  final String title;

  Notification(this.id, this.title);

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(1, 'title');
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}
