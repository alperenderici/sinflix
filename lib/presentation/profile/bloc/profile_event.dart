import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileLoadRequested extends ProfileEvent {
  const ProfileLoadRequested();
}

class ProfileUpdateRequested extends ProfileEvent {
  final String? name;
  final String? profilePictureUrl;

  const ProfileUpdateRequested({
    this.name,
    this.profilePictureUrl,
  });

  @override
  List<Object?> get props => [name, profilePictureUrl];
}

class ProfilePictureUploadRequested extends ProfileEvent {
  final String filePath;

  const ProfilePictureUploadRequested({required this.filePath});

  @override
  List<Object> get props => [filePath];
}

class FavoriteMoviesLoadRequested extends ProfileEvent {
  final bool isRefresh;

  const FavoriteMoviesLoadRequested({this.isRefresh = false});

  @override
  List<Object> get props => [isRefresh];
}

class FavoriteMoviesLoadMoreRequested extends ProfileEvent {
  const FavoriteMoviesLoadMoreRequested();
}

class FavoriteMovieAddRequested extends ProfileEvent {
  final String movieId;

  const FavoriteMovieAddRequested({required this.movieId});

  @override
  List<Object> get props => [movieId];
}

class FavoriteMovieRemoveRequested extends ProfileEvent {
  final String movieId;

  const FavoriteMovieRemoveRequested({required this.movieId});

  @override
  List<Object> get props => [movieId];
}

class FavoritesClearRequested extends ProfileEvent {
  const FavoritesClearRequested();
}
