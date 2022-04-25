import 'package:firebase_auth/firebase_auth.dart';

enum AuthResultStatus {
  successful,
  emailAlreadyExists,
  wrongPassword,
  invalidEmail,
  userNotFound,
  userDisabled,
  weakPassword,
  operationNotAllowed,
  undefined,
}

class AuthExceptionHandler {
  static handleException(FirebaseAuthException e) {
    final AuthResultStatus status;
    switch (e.code) {
      case "invalid-email":
        status = AuthResultStatus.invalidEmail;
        break;
      case "wrong-password":
        status = AuthResultStatus.wrongPassword;
        break;
      case "user-not-found":
        status = AuthResultStatus.userNotFound;
        break;
      case "user-disabled":
        status = AuthResultStatus.userDisabled;
        break;
      case "email-already-in-use":
        status = AuthResultStatus.emailAlreadyExists;
        break;
      case "operation-not-allowed":
        status = AuthResultStatus.operationNotAllowed;
        break;
      case "weak-password":
        status = AuthResultStatus.weakPassword;
        break;

      default:
        status = AuthResultStatus.undefined;
    }
    return status;
  }

  static generateExceptionMessage(AuthResultStatus exceptionCode) {
    String errorMessage;
    switch (exceptionCode) {
      case AuthResultStatus.invalidEmail:
        errorMessage = "E-Mail inválido.";
        break;
      case AuthResultStatus.wrongPassword:
        errorMessage = "Senha incorreta.";
        break;
      case AuthResultStatus.userNotFound:
        errorMessage = "Não existe um usuário com este E-Mail.";
        break;
      case AuthResultStatus.userDisabled:
        errorMessage = "Usuário desabilitado.";
        break;
      case AuthResultStatus.operationNotAllowed:
        errorMessage = "Operação negada.";
        break;
      case AuthResultStatus.emailAlreadyExists:
        errorMessage =
            "E-Mail já registrado, por favor faça o login ou redefina sua senha.";
        break;

      default:
        errorMessage = "Ocorreu um erro inesperado, tente novamente.";
    }

    return errorMessage;
  }
}
