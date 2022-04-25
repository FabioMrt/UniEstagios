import 'package:uniestagios/domain/form_validation/usecases/validator.usecase.dart';

class PasswordValidatorUsecase implements ValidatorUsecase {
  @override
  String? validate(String? value) {
    if (value?.length == 0 || value == null) {
      return 'Campo não pode ser vazio';
    } else if (value.length < 8) {
      return 'Sua senha precisa ter mais de 8 caracteres';
    }
    return null;
  }
}
