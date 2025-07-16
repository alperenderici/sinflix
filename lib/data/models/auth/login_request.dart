import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

/// API'ye gönderilecek login request modeli
/// Email ve password bilgilerini içerir
@JsonSerializable()
class LoginRequest {
  @JsonKey(name: 'email')
  final String email;
  
  @JsonKey(name: 'password')
  final String password;

  const LoginRequest({
    required this.email,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);

  @override
  String toString() => 'LoginRequest(email: $email)';
}
