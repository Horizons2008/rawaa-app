import 'package:dio/dio.dart';

class DioExceptions implements Exception {
  DioExceptions.fromDioError(DioException dioError) {
    print("zzzzzzzzzzzzzzzzzzz ${dioError.message}");
    switch (dioError.type) {
      case DioExceptionType.cancel:
        message = "Demande requete annuler";
        break;
      case DioExceptionType.connectionTimeout:
        message = "Temp attente depasé ";
        break;
      case DioExceptionType.unknown:
        message = "Probleme de connexion Internet";
        break;
      case DioExceptionType.receiveTimeout:
        message = "Temp de reponse Depassé";
        break;
      case DioExceptionType.badResponse:
        int tt = dioError.response?.statusCode ?? 0;
        if (tt == 302) {}
        message = _handleError(tt, dioError.response!.data);
        break;
      case DioExceptionType.sendTimeout:
        message = "Temp Envoie requete dépassé";
        break;
      default:
        message = "Something went wrong";
        break;
    }
  }

  String message = "";

  String _handleError(int statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 404:
        return 'Lien introuvable';
      case 302:
        return 'session expiré vous devez reconnecter';

      case 500:
        return 'Internal server error';
      default:
        return 'Oops something went wrong';
    }
  }

  @override
  String toString() => message;
}
