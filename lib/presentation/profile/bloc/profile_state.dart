import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/entities/user.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final User user;
  final List<Movie> favoriteMovies;
  final bool hasReachedMaxFavorites;
  final int currentFavoritesPage;
  final bool isLoadingMoreFavorites;
  final bool isUpdatingProfile;
  final bool isUploadingPicture;

  const ProfileLoaded({
    required this.user,
    this.favoriteMovies = const [],
    this.hasReachedMaxFavorites = false,
    this.currentFavoritesPage = 1,
    this.isLoadingMoreFavorites = false,
    this.isUpdatingProfile = false,
    this.isUploadingPicture = false,
  });

  ProfileLoaded copyWith({
    User? user,
    List<Movie>? favoriteMovies,
    bool? hasReachedMaxFavorites,
    int? currentFavoritesPage,
    bool? isLoadingMoreFavorites,
    bool? isUpdatingProfile,
    bool? isUploadingPicture,
  }) {
    return ProfileLoaded(
      user: user ?? this.user,
      favoriteMovies: favoriteMovies ?? this.favoriteMovies,
      hasReachedMaxFavorites: hasReachedMaxFavorites ?? this.hasReachedMaxFavorites,
      currentFavoritesPage: currentFavoritesPage ?? this.currentFavoritesPage,
      isLoadingMoreFavorites: isLoadingMoreFavorites ?? this.isLoadingMoreFavorites,
      isUpdatingProfile: isUpdatingProfile ?? this.isUpdatingProfile,
      isUploadingPicture: isUploadingPicture ?? this.isUploadingPicture,
    );
  }

  @override
  List<Object> get props => [
        user,
        favoriteMovies,
        hasReachedMaxFavorites,
        currentFavoritesPage,
        isLoadingMoreFavorites,
        isUpdatingProfile,
        isUploadingPicture,
      ];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object> get props => [message];
}

class ProfileUpdateSuccess extends ProfileState {
  final User user;

  const ProfileUpdateSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

class ProfilePictureUploadSuccess extends ProfileState {
  final String imageUrl;

  const ProfilePictureUploadSuccess({required this.imageUrl});

  @override
  List<Object> get props => [imageUrl];
}

class FavoriteMovieAdded extends ProfileState {
  final String movieId;

  const FavoriteMovieAdded({required this.movieId});

  @override
  List<Object> get props => [movieId];
}

class FavoriteMovieRemoved extends ProfileState {
  final String movieId;

  const FavoriteMovieRemoved({required this.movieId});

  @override
  List<Object> get props => [movieId];
}

class FavoritesCleared extends ProfileState {
  const FavoritesCleared();
}
