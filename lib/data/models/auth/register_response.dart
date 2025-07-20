import 'package:freezed_annotation/freezed_annotation.dart';
import '../user_model.dart';

part 'register_response.freezed.dart';
part 'register_response.g.dart';

/// API'den dönen register response modeli
/// API response: { "token": "string", "user": { "id": "string", "name": "string", "email": "string" } }
@freezed
class RegisterResponse with _$RegisterResponse {
  const factory RegisterResponse({
    required String token,
    required UserModel user,
  }) = _RegisterResponse;

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    // API response yapısı: { "response": {...}, "data": { "token": "...", "user": {...} } }
    final data = json['data'] as Map<String, dynamic>;

    // User data'sını al
    final userData = Map<String, dynamic>.from(data);
    userData.remove('token'); // token'ı user data'sından çıkar

    return RegisterResponse(
      token: data['token'] as String,
      user: UserModel.fromJson(userData),
    );
  }
}
