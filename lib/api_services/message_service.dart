import 'dart:async';
import 'package:dio/dio.dart';
import '../core/api_repository/api_repository.dart';
import '../models/messages_response.dart';

class MessageService extends ApiRepository {

//************************************ get-messages *********************************//
  Future<MessageResponse?> getMessages(
      {required Map<String, String>? queryToAPI}) async {
    final Response<dynamic> res = await ApiRepository.apiClient.get(
      '/messages',
      queryParameters: queryToAPI
    );
    return MessageResponse.fromJson(res.data as Map<String, dynamic>);
  }
}
