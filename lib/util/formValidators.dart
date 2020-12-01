extension Validations on String {
  bool isValidName() {
    return RegExp(r'^[a-zA-Z\s.]*$').hasMatch(this);
  }

  bool isValidEmail() {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$")
        .hasMatch(this);
  }

  bool get isRegexWithAlphanumericSpaceDotChars =>
      RegExp(r'^[a-zA-Z0-9\s.,\-’]*$').hasMatch(this);
}

final Function(String) nameValidator = (value) {
  if (value.isEmpty) {
    return 'Required';
  } else if (!value.isValidName()) {
    return 'Please use alphabets, space and dot characters only';
  }
  return null;
};

final Function(String) emailValidator = (value) {
  if (value.isEmpty) {
    return 'Required';
  } else if (!value.isValidEmail()) {
    return 'Please enter email in correct format';
  }
  return null;
};

final Function(String) regexAlphanumericSpaceDotCharsValidator = (value) {
  if (value.isEmpty) {
    return 'Required';
  } else if (!value.isRegexWithAlphanumericSpaceDotChars) {
    return 'Use alphanumeric, space, dot, colon, comma & ’ chars only';
  }
  return null;
};
