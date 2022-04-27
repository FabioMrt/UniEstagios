import 'package:get/get.dart';
import 'package:uniestagios/domain/form_validation/usecases/validator.usecase.dart';

class CNPJValidatorUsecase implements ValidatorUsecase {
  @override
  String? validate(String? value) {
    String? newValue = value?.trim();
    if (newValue?.length == 0 || newValue == null) {
      return 'Campo não pode ser vazio';
    } else {
      return null;
    }
  }
}
