import 'package:uniestagios/domain/form_validation/usecases/validator.usecase.dart';

import 'usecases/email_validator.usecase.dart';
import 'usecases/password_validator.usecase.dart';
import 'usecases/simple_field_validator.usecase.dart';

enum ValidationMethod {
  SIMPLE_FIELD,
  EMAIL,
  PASSWORD,
}

class InputValidator {
  Map<ValidationMethod, ValidatorUsecase> map = {
    ValidationMethod.SIMPLE_FIELD: SimpleFieldValidatorUsecase(),
    ValidationMethod.EMAIL: EmailValidatorUsecase(),
    ValidationMethod.PASSWORD: PasswordValidatorUsecase(),
  };

  String? validate(String? value, ValidationMethod method) {
    return map[method]?.validate(value);
  }
}
