import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import '../user_model.dart';

part 'register_response.freezed.dart';
part 'register_response.g.dart';

/// API'den dönen register response modeli - Freezed ile
/// Register API'si token ve user bilgilerini döndürüyor
@freezed
class RegisterResponse with _$RegisterResponse {
  const factory RegisterResponse({
    required String token,
    required UserModel user,
  }) = _RegisterResponse;

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);
}
