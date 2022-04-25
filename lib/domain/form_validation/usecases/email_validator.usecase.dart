import 'package:uniestagios/domain/form_validation/usecases/validator.usecase.dart';

class EmailValidatorUsecase implements ValidatorUsecase {
  @override
  String? validate(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    String? newValue = value?.trim();
    if (newValue?.length == 0 || newValue == null) {
      return 'Campo não pode ser vazio';
    } else if (!regExp.hasMatch(newValue)) {
      return 'E-Mail inválido';
    } else {
      return null;
    }
  }
}
