

class RegexValidator {

  static RegExp email = RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\.[a-zA-z]{2,3}$"); 
  static RegExp password = RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$");

  static bool isEmail(String input) => email.hasMatch(input);
  static bool isPassword(String input) => password.hasMatch(input);


}