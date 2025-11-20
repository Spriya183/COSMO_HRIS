class Validation {
  static String? validUserName(String? name) {
    if (name == null || name.isEmpty) {
      return "Please enter your email";
    }

    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+$',
    );
    if (!emailRegex.hasMatch(name)) {
      return "Enter a valid email address";
    }

    return null;
  }

  static String? passwordValidation(String? password) {
    if (password == null || password.isEmpty) {
      return "Please enter your password";
    }
    return null;
  }

  static String? oldPasswordValidation(String? oldPassword) {
    if (oldPassword == null || oldPassword.isEmpty) {
      return "Old password is required";
    }
    return null;
  }

  static String? newPasswordValidation(String? newPassword) {
    if (newPassword == null || newPassword.isEmpty) {
      return "New password is required";
    }
    return null;
  }

  static String? confirmPasswordValidation(String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return "Please enter your password";
    }
    return null;
  }

  static String? mobileNumberValidation(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return "Please enter your mobile number";
    }
    return null;
  }

  static String? nameValidation(String? fullName) {
    if (fullName == null || fullName.isEmpty) {
      return "Please enter your name";
    }
    return null;
  }

  static String? titlePostValidation(String? title) {
    if (title == null || title.isEmpty) {
      return "Title cannot be empty";
    }
    return null;
  }

  static String? contentPostValidation(String? content) {
    if (content == null || content.isEmpty) {
      return "Content cannot be empty";
    }
    return null;
  }
}
