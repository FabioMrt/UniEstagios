import 'package:uniestagios/domain/form_validation/usecases/validator.usecase.dart';

class SimpleFieldValidatorUsecase implements ValidatorUsecase {
  @override
  String? validate(String? value) {
    if (value?.length == 0 || value == null) {
      return 'Campo não pode ser vazio';
    } else
      return null;
  }
}
