import 'package:flutter/services.dart';

enum AuthProblems {
  UserNotFound, PasswordNotValid, NetworkError, Unknow }

AuthProblems plaformExceptionHandle(PlatformException e) {
  AuthProblems errorType = AuthProblems.Unknow;
  switch (e.message) {
    case 'Error 17011':
    case 'There is no user record corresponding to this identifier. The user may have been deleted.':
      errorType = AuthProblems.UserNotFound;
      break;
    case 'Error 17009':
    case 'The password is invalid or the user does not have a password.':
      errorType = AuthProblems.PasswordNotValid;
      break;
    case 'Error 17020':
    case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
      errorType = AuthProblems.NetworkError;
      break;
    default:
      print('Case ${e.message} is not jet implemented');
  }
  print('The error is $errorType');
  return errorType;
}

String authProblemToString(AuthProblems errType) {
  switch (errType) {
    case AuthProblems.NetworkError:
      return 'Problemas com sua conexão';
    case AuthProblems.PasswordNotValid:
      return 'Senha inválida';
    case AuthProblems.UserNotFound:
      return 'Email inválido';
    default: // AuthProblems.Unknow
      return 'Falha desconhecida';
  }
}