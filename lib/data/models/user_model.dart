import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User data model - API response'a uygun Freezed ile
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    required String email,
    @JsonKey(name: 'photoUrl') String? photoUrl,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

/// UserModel extension - Entity dönüşümü için
extension UserModelX on UserModel {
  /// Model'i domain entity'sine çevir
  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      photoUrl: photoUrl,
    );
  }

  /// Entity'den model oluştur
  static UserModel fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      photoUrl: user.photoUrl,
    );
  }
}
