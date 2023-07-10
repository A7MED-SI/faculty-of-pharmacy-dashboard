enum AdminRole {
  superAdmin(1),
  admin(2);

  final int value;
  const AdminRole(this.value);
}

enum SubscriptionableType {
  yearSemester(3),
  subject(4);

  final int value;
  const SubscriptionableType(this.value);
  static String typeInArabic(int value) {
    return value == 3 ? 'فصل' : 'مادة';
  }
}
