import 'package:doctor_appointment/core/services/api_service.dart';
import 'package:doctor_appointment/features/chatbot/data/models/ai_chat_models.dart';
import 'package:dio/dio.dart';

abstract class AIChatRemoteDataSource {
  Future<NewChatResponseModel> startNewChat();
  Future<List<String>> getUserChats();
  Future<AIChatResponseModel> sendMessage(AIChatRequestModel request);
  Future<List<AIChatHistoryModel>> getHistory(String sessionId);
}

class AIChatRemoteDataSourceImpl implements AIChatRemoteDataSource {
  final ApiService _apiService;

  AIChatRemoteDataSourceImpl(this._apiService);

  @override
  Future<NewChatResponseModel> startNewChat() async {
    final response = await _apiService.post('/api/AIChat/new-chat');
    return NewChatResponseModel.fromJson(response['data']);
  }

  @override
  Future<List<String>> getUserChats() async {
    final response = await _apiService.get('/api/AIChat/user-chats');
    return (response['data'] as List<dynamic>)
        .map((e) => e.toString())
        .toList();
  }

  @override
  Future<AIChatResponseModel> sendMessage(AIChatRequestModel request) async {
    try {
      final response = await _apiService.post(
        '/api/AIChat/send',
        data: request.toJson(),
      );
      return AIChatResponseModel.fromJson(response['data']);
    } on DioException catch (e) {
      final serverMessage = e.response?.data is Map
          ? (e.response?.data['message'] as String?)
          : null;
      if (e.response?.statusCode == 429) {
        throw Exception(serverMessage ?? 'Rate limit exceeded');
      }
      throw Exception(serverMessage ?? 'Failed to send message');
    }
  }

  @override
  Future<List<AIChatHistoryModel>> getHistory(String sessionId) async {
    final response = await _apiService.get('/api/AIChat/history/$sessionId');
    return (response['data'] as List<dynamic>)
        .map((e) => AIChatHistoryModel.fromJson(e))
        .toList();
  }
}
