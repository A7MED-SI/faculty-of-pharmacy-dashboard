enum AdminRole {
  superAdmin(1),
  admin(2);

  final int value;
  const AdminRole(this.value);
}

enum AdminPermission {
  canAddExcel(1),
  canAddSubs(2);

  final int value;
  const AdminPermission(this.value);
}

enum SubscriptionableType {
  all(-1),
  yearSemester(3),
  subject(4);

  final int value;
  const SubscriptionableType(this.value);
  static String typeInArabic(int value) {
    return value == 3
        ? 'فصل'
        : (value == 4)
            ? 'مادة'
            : 'الكل';
  }

  static String typeInEnglish(int value) {
    return value == 3
        ? 'Semester'
        : (value == 4)
            ? 'Subject'
            : 'Everything';
  }
}

enum QuestionBankType {
  previousExam(1),
  chapterBank(2);

  final int value;
  const QuestionBankType(this.value);
  static String typeInArabic(int value) {
    return value == 1 ? 'دورة سابقة' : 'بنك مادة';
  }
}
