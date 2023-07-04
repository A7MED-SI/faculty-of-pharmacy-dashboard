class Validations {
  Validations._();

  static const String _emailPattern = r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b';
  static bool emailValidation({required String email}) {
    RegExp regex = RegExp(_emailPattern);
    return regex.hasMatch(email);
  }

  static bool passwordValidation({required String password}) {
    return password.trim().length >= 6;
  }

  static bool phoneValidation({required String phone}) {
    if (phone.isEmpty) return false;
    var res = true;
    res &= phone.length >= 10 && phone.length <= 13;
    if (!(phone[0].codeUnitAt(0) >= '0'.codeUnitAt(0) &&
        phone[0].codeUnitAt(0) <= '9'.codeUnitAt(0))) {
      res &= phone[0] == '+';
    }
    for (int i = 1; i < phone.length; i++) {
      res &= (phone[i].codeUnitAt(0) >= '0'.codeUnitAt(0) &&
          phone[i].codeUnitAt(0) <= '9'.codeUnitAt(0));
    }
    return res;
  }

  static const String _websitePattern =
      r'^(www.)[a-z0-9]+\.[a-z]+(\/[a-zA-Z0-9#]+\/?)*$';
  static bool websiteValidation({required String website}) {
    RegExp regex = RegExp(_websitePattern);
    return regex.hasMatch(website);
  }
}
