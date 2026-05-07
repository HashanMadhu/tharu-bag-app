class FormValidators {
  // නම පරීක්ෂා කිරීමේ logic එක
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter customer name';
    }
    return null;
  }

  // දුරකථන අංකය පරීක්ෂා කිරීමේ logic එක
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter phone number';
    }
    if (value.length < 10) {
      return 'Enter a valid 10-digit phone number';
    }
    return null;
  }
}