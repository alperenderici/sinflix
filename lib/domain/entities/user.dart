import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

/// User domain entity - API response'a uygun Freezed ile immutable
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
    String? photoUrl,
  }) = _User;
}
