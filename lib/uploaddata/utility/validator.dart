class Validator {
  static String? validateName({required String? name}) {
    if (name == null) {
      return null;
    }
    if (name.isEmpty) {
      return 'Name can\'t be empty';
    }

    return null;
  }
  static String? validatePrice({required String? name}) {
    if (name == null) {
      return null;
    }
    if (name.isEmpty) {
      return 'Price can\'t be empty';
    }

    return null;
  }
  static String? validateDiscountPrice({required String? name}) {
    if (name == null) {
      return null;
    }
    if (name.isEmpty) {
      return 'Discount price can\'t be empty';
    }

    return null;
  }

  static String? validateAvailableQuantity({required String? name}) {
    if (name == null) {
      return null;
    }
    if (name.isEmpty) {
      return 'Available quantity can\'t be empty';
    }

    return null;
  }

  static String? validateCategory({required String? name}) {
    if (name == null) {
      return null;
    }
    if (name.isEmpty) {
      return 'Category name can\'t be empty';
    }

    return null;
  }

  static String? validateImageUrl({required String? name}) {
    if (name == null) {
      return null;
    }
    if (name.isEmpty) {
      return 'Image Url can\'t be empty';
    }

    return null;
  }

  static String? validateEmail({required String? email}) {
    if (email == null) {
      return null;
    }
    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (email.isEmpty) {
      return 'Email can\'t be empty';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'Enter a correct email';
    }

    return null;
  }

  static String? validatePassword({required String? password}) {
    if (password == null) {
      return null;
    }
    if (password.isEmpty) {
      return 'Password can\'t be empty';
    } else if (password.length < 6) {
      return 'Enter a password with length at least 6';
    }

    return null;
  }


}