import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/usecases/usecase.dart';
import '../../../core/utils/app_logger.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/movie/get_favorite_movies.dart';
import '../../../domain/usecases/movie/get_movies.dart';
import '../../../domain/usecases/movie/toggle_favorite.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetMovies _getMovies;
  final GetFavoriteMovies _getFavoriteMovies;
  final ToggleFavorite _toggleFavorite;

  MovieBloc({
    required GetMovies getMovies,
    required GetFavoriteMovies getFavoriteMovies,
    required ToggleFavorite toggleFavorite,
  })  : _getMovies = getMovies,
        _getFavoriteMovies = getFavoriteMovies,
        _toggleFavorite = toggleFavorite,
        super(MovieInitial()) {
    on<LoadMovies>(_onLoadMovies);
    on<LoadMoreMovies>(_onLoadMoreMovies);
    on<ToggleMovieFavorite>(_onToggleMovieFavorite);
    on<LoadFavoriteMovies>(_onLoadFavoriteMovies);
  }

  Future<void> _onLoadMovies(LoadMovies event, Emitter<MovieState> emit) async {
    try {
      if (event.isRefresh || state is! MovieLoaded) {
        emit(MovieLoading());
      }

      AppLogger.debug('Loading movies for page: ${event.page}');

      final result = await _getMovies(GetMoviesParams(page: event.page));

      result.fold(
        (failure) {
          AppLogger.error('Failed to load movies: ${failure.message}');
          emit(MovieError(failure.message));
        },
        (movies) {
          AppLogger.debug('Loaded ${movies.length} movies');
          emit(MovieLoaded(
            movies: movies,
            currentPage: event.page,
            hasReachedMax: movies.isEmpty,
          ));
        },
      );
    } catch (e) {
      AppLogger.error('Error loading movies: $e');
      emit(MovieError('Failed to load movies'));
    }
  }

  Future<void> _onLoadMoreMovies(
      LoadMoreMovies event, Emitter<MovieState> emit) async {
    try {
      final currentState = state;
      if (currentState is! MovieLoaded || currentState.hasReachedMax) {
        return;
      }

      emit(currentState.copyWith(isLoadingMore: true));

      final nextPage = currentState.currentPage + 1;
      AppLogger.debug('Loading more movies for page: $nextPage');

      final result = await _getMovies(GetMoviesParams(page: nextPage));

      result.fold(
        (failure) {
          AppLogger.error('Failed to load more movies: ${failure.message}');
          emit(currentState.copyWith(isLoadingMore: false));
        },
        (newMovies) {
          AppLogger.debug('Loaded ${newMovies.length} more movies');
          final allMovies = List<Movie>.from(currentState.movies)
            ..addAll(newMovies);

          emit(MovieLoaded(
            movies: allMovies,
            currentPage: nextPage,
            hasReachedMax: newMovies.isEmpty,
            isLoadingMore: false,
          ));
        },
      );
    } catch (e) {
      AppLogger.error('Error loading more movies: $e');
      final currentState = state;
      if (currentState is MovieLoaded) {
        emit(currentState.copyWith(isLoadingMore: false));
      }
    }
  }

  Future<void> _onToggleMovieFavorite(
      ToggleMovieFavorite event, Emitter<MovieState> emit) async {
    try {
      AppLogger.debug('Toggling favorite for movie: ${event.movieId}');

      final result = await _toggleFavorite(
        ToggleFavoriteParams(movieId: event.movieId),
      );

      result.fold(
        (failure) {
          AppLogger.error('Failed to toggle favorite: ${failure.message}');
          emit(MovieError(failure.message));
        },
        (success) {
          AppLogger.debug('Successfully toggled favorite: $success');
          
          // Update the movie list if we're in MovieLoaded state
          final currentState = state;
          if (currentState is MovieLoaded) {
            final updatedMovies = currentState.movies.map((movie) {
              if (movie.id == event.movieId) {
                return movie.copyWith(isFavorite: !movie.isFavorite);
              }
              return movie;
            }).toList();

            emit(currentState.copyWith(movies: updatedMovies));
          }
          
          emit(FavoriteToggleSuccess(event.movieId));
        },
      );
    } catch (e) {
      AppLogger.error('Error toggling favorite: $e');
      emit(MovieError('Failed to toggle favorite'));
    }
  }

  Future<void> _onLoadFavoriteMovies(
      LoadFavoriteMovies event, Emitter<MovieState> emit) async {
    try {
      AppLogger.debug('Loading favorite movies');

      final result = await _getFavoriteMovies(NoParams());

      result.fold(
        (failure) {
          AppLogger.error('Failed to load favorite movies: ${failure.message}');
          emit(MovieError(failure.message));
        },
        (favoriteMovies) {
          AppLogger.debug('Loaded ${favoriteMovies.length} favorite movies');
          emit(FavoriteMoviesLoaded(favoriteMovies));
        },
      );
    } catch (e) {
      AppLogger.error('Error loading favorite movies: $e');
      emit(MovieError('Failed to load favorite movies'));
    }
  }
}
