import 'package:uniestagios/domain/form_validation/input_validator.dart';

String? validateForm(String? value, ValidationMethod method) {
  InputValidator _validator = InputValidator();

  return _validator.validate(value, method);
}
