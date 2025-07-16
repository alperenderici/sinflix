import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/app_logger.dart';
import '../../../domain/usecases/profile/add_to_favorites.dart';
import '../../../domain/usecases/profile/get_favorite_movies.dart';
import '../../../domain/usecases/profile/get_user_profile.dart';
import '../../../domain/usecases/profile/remove_from_favorites.dart';
import '../../../domain/usecases/profile/update_user_profile.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfile getUserProfile;
  final UpdateUserProfile updateUserProfile;
  final GetFavoriteMovies getFavoriteMovies;
  final AddToFavorites addToFavorites;
  final RemoveFromFavorites removeFromFavorites;

  ProfileBloc({
    required this.getUserProfile,
    required this.updateUserProfile,
    required this.getFavoriteMovies,
    required this.addToFavorites,
    required this.removeFromFavorites,
  }) : super(const ProfileInitial()) {
    on<ProfileLoadRequested>(_onProfileLoadRequested);
    on<ProfileUpdateRequested>(_onProfileUpdateRequested);
    on<FavoriteMoviesLoadRequested>(_onFavoriteMoviesLoadRequested);
    on<FavoriteMoviesLoadMoreRequested>(_onFavoriteMoviesLoadMoreRequested);
    on<FavoriteMovieAddRequested>(_onFavoriteMovieAddRequested);
    on<FavoriteMovieRemoveRequested>(_onFavoriteMovieRemoveRequested);
  }

  Future<void> _onProfileLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());

    AppLogger.debug('Loading user profile...');

    final result = await getUserProfile();

    result.fold(
      (failure) {
        AppLogger.error('Failed to load user profile: ${failure.message}');
        emit(
          ProfileError(message: failure.message ?? 'Failed to load profile'),
        );
      },
      (user) {
        AppLogger.info('Loaded user profile: ${user.email}');
        emit(ProfileLoaded(user: user));

        // Also load favorite movies
        add(const FavoriteMoviesLoadRequested());
      },
    );
  }

  Future<void> _onProfileUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    emit(currentState.copyWith(isUpdatingProfile: true));

    AppLogger.debug('Updating user profile...');

    final result = await updateUserProfile(
      UpdateUserProfileParams(
        name: event.name,
        profilePictureUrl: event.profilePictureUrl,
      ),
    );

    result.fold(
      (failure) {
        AppLogger.error('Failed to update user profile: ${failure.message}');
        emit(currentState.copyWith(isUpdatingProfile: false));
        emit(
          ProfileError(message: failure.message ?? 'Failed to update profile'),
        );
      },
      (user) {
        AppLogger.info('Updated user profile: ${user.email}');
        emit(currentState.copyWith(user: user, isUpdatingProfile: false));
        emit(ProfileUpdateSuccess(user: user));
      },
    );
  }

  Future<void> _onFavoriteMoviesLoadRequested(
    FavoriteMoviesLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded && !event.isRefresh) return;

    AppLogger.debug('Loading favorite movies...');

    final result = await getFavoriteMovies(
      const GetFavoriteMoviesParams(page: 1),
    );

    result.fold(
      (failure) {
        AppLogger.error('Failed to load favorite movies: ${failure.message}');
        if (currentState is ProfileLoaded) {
          emit(currentState.copyWith(favoriteMovies: []));
        }
      },
      (movies) {
        AppLogger.info('Loaded ${movies.length} favorite movies');
        if (currentState is ProfileLoaded) {
          emit(
            currentState.copyWith(
              favoriteMovies: movies,
              hasReachedMaxFavorites: movies.length < 10,
              currentFavoritesPage: 1,
            ),
          );
        }
      },
    );
  }

  Future<void> _onFavoriteMoviesLoadMoreRequested(
    FavoriteMoviesLoadMoreRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded ||
        currentState.hasReachedMaxFavorites ||
        currentState.isLoadingMoreFavorites) {
      return;
    }

    emit(currentState.copyWith(isLoadingMoreFavorites: true));

    final nextPage = currentState.currentFavoritesPage + 1;
    AppLogger.debug('Loading more favorite movies (page $nextPage)...');

    final result = await getFavoriteMovies(
      GetFavoriteMoviesParams(page: nextPage),
    );

    result.fold(
      (failure) {
        AppLogger.error(
          'Failed to load more favorite movies: ${failure.message}',
        );
        emit(currentState.copyWith(isLoadingMoreFavorites: false));
      },
      (newMovies) {
        AppLogger.info('Loaded ${newMovies.length} more favorite movies');
        final allMovies = List.of(currentState.favoriteMovies)
          ..addAll(newMovies);
        emit(
          currentState.copyWith(
            favoriteMovies: allMovies,
            hasReachedMaxFavorites: newMovies.length < 10,
            currentFavoritesPage: nextPage,
            isLoadingMoreFavorites: false,
          ),
        );
      },
    );
  }

  Future<void> _onFavoriteMovieAddRequested(
    FavoriteMovieAddRequested event,
    Emitter<ProfileState> emit,
  ) async {
    AppLogger.debug('Adding movie to favorites: ${event.movieId}');

    final result = await addToFavorites(
      AddToFavoritesParams(movieId: event.movieId),
    );

    result.fold(
      (failure) {
        AppLogger.error('Failed to add movie to favorites: ${failure.message}');
        emit(
          ProfileError(
            message: failure.message ?? 'Failed to add to favorites',
          ),
        );
      },
      (_) {
        AppLogger.info('Added movie to favorites: ${event.movieId}');
        emit(FavoriteMovieAdded(movieId: event.movieId));

        // Refresh favorites list
        add(const FavoriteMoviesLoadRequested(isRefresh: true));
      },
    );
  }

  Future<void> _onFavoriteMovieRemoveRequested(
    FavoriteMovieRemoveRequested event,
    Emitter<ProfileState> emit,
  ) async {
    AppLogger.debug('Removing movie from favorites: ${event.movieId}');

    final result = await removeFromFavorites(
      RemoveFromFavoritesParams(movieId: event.movieId),
    );

    result.fold(
      (failure) {
        AppLogger.error(
          'Failed to remove movie from favorites: ${failure.message}',
        );
        emit(
          ProfileError(
            message: failure.message ?? 'Failed to remove from favorites',
          ),
        );
      },
      (_) {
        AppLogger.info('Removed movie from favorites: ${event.movieId}');
        emit(FavoriteMovieRemoved(movieId: event.movieId));

        // Refresh favorites list
        add(const FavoriteMoviesLoadRequested(isRefresh: true));
      },
    );
  }
}
