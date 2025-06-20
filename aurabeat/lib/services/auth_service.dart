import 'package:dio/dio.dart';
import '../core/utils/dio_client.dart';
import '../core/constants/api_constants.dart';
import '../models/user_model.dart';

class AuthService {
  final DioClient _dioClient = DioClient.instance;

  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.login,
        data: request.toJson(),
        options: Options(
          headers: {
            'Content-Type': ApiConstants.contentTypeJson,
          },
        ),
      );

      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.register,
        data: request.toJson(),
        options: Options(
          headers: {
            'Content-Type': ApiConstants.contentTypeJson,
          },
        ),
      );

      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response != null) {
      final data = e.response!.data;
      if (data is Map<String, dynamic> && data.containsKey('message')) {
        return data['message'];
      }
      return 'Server error: ${e.response!.statusCode}';
    }
    return 'Network error: ${e.message}';
  }
}