import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_logger.dart';
import '../../../domain/usecases/movies/get_movie_details.dart';
import '../../../domain/usecases/movies/get_movies.dart';
import '../../../domain/usecases/movies/search_movies.dart';
import 'movies_event.dart';
import 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final GetMovies getMovies;
  final GetMovieDetails getMovieDetails;
  final SearchMovies searchMovies;

  MoviesBloc({
    required this.getMovies,
    required this.getMovieDetails,
    required this.searchMovies,
  }) : super(const MoviesInitial()) {
    on<MoviesLoadRequested>(_onMoviesLoadRequested);
    on<MoviesLoadMoreRequested>(_onMoviesLoadMoreRequested);
    on<MoviesRefreshRequested>(_onMoviesRefreshRequested);
    on<MoviesSearchRequested>(_onMoviesSearchRequested);
    on<MoviesSearchClearRequested>(_onMoviesSearchClearRequested);
    on<MovieDetailsRequested>(_onMovieDetailsRequested);
    on<MovieFavoriteToggleRequested>(_onMovieFavoriteToggleRequested);
  }

  Future<void> _onMoviesLoadRequested(
    MoviesLoadRequested event,
    Emitter<MoviesState> emit,
  ) async {
    if (event.isRefresh && state is MoviesLoaded) {
      // Don't show loading for refresh
    } else {
      emit(const MoviesLoading());
    }

    AppLogger.debug('Loading movies...');

    final result = await getMovies(const GetMoviesParams(page: 1));

    result.fold(
      (failure) {
        AppLogger.error('Failed to load movies: ${failure.message}');
        emit(MoviesError(message: failure.message ?? 'Failed to load movies'));
      },
      (movies) {
        AppLogger.info('Loaded ${movies.length} movies');
        emit(MoviesLoaded(
          movies: movies,
          hasReachedMax: movies.length < AppConstants.defaultPageSize,
          currentPage: 1,
        ));
      },
    );
  }

  Future<void> _onMoviesLoadMoreRequested(
    MoviesLoadMoreRequested event,
    Emitter<MoviesState> emit,
  ) async {
    final currentState = state;
    if (currentState is! MoviesLoaded || currentState.hasReachedMax || currentState.isLoadingMore) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));

    final nextPage = currentState.currentPage + 1;
    AppLogger.debug('Loading more movies (page $nextPage)...');

    final result = await getMovies(GetMoviesParams(page: nextPage));

    result.fold(
      (failure) {
        AppLogger.error('Failed to load more movies: ${failure.message}');
        emit(currentState.copyWith(isLoadingMore: false));
        // Could emit an error state or show a snackbar
      },
      (newMovies) {
        AppLogger.info('Loaded ${newMovies.length} more movies');
        final allMovies = List.of(currentState.movies)..addAll(newMovies);
        emit(MoviesLoaded(
          movies: allMovies,
          hasReachedMax: newMovies.length < AppConstants.defaultPageSize,
          currentPage: nextPage,
          isLoadingMore: false,
        ));
      },
    );
  }

  Future<void> _onMoviesRefreshRequested(
    MoviesRefreshRequested event,
    Emitter<MoviesState> emit,
  ) async {
    add(const MoviesLoadRequested(isRefresh: true));
  }

  Future<void> _onMoviesSearchRequested(
    MoviesSearchRequested event,
    Emitter<MoviesState> emit,
  ) async {
    if (event.query.trim().isEmpty) {
      add(const MoviesSearchClearRequested());
      return;
    }

    emit(const MoviesSearchLoading());

    AppLogger.debug('Searching movies with query: ${event.query}');

    final result = await searchMovies(SearchMoviesParams(query: event.query));

    result.fold(
      (failure) {
        AppLogger.error('Failed to search movies: ${failure.message}');
        emit(MoviesSearchError(
          message: failure.message ?? 'Failed to search movies',
          query: event.query,
        ));
      },
      (movies) {
        AppLogger.info('Found ${movies.length} movies for query: ${event.query}');
        emit(MoviesSearchLoaded(
          movies: movies,
          query: event.query,
          hasReachedMax: movies.length < AppConstants.defaultPageSize,
        ));
      },
    );
  }

  Future<void> _onMoviesSearchClearRequested(
    MoviesSearchClearRequested event,
    Emitter<MoviesState> emit,
  ) async {
    AppLogger.debug('Clearing search results');
    add(const MoviesLoadRequested());
  }

  Future<void> _onMovieDetailsRequested(
    MovieDetailsRequested event,
    Emitter<MoviesState> emit,
  ) async {
    emit(const MovieDetailsLoading());

    AppLogger.debug('Loading movie details for ID: ${event.movieId}');

    final result = await getMovieDetails(GetMovieDetailsParams(movieId: event.movieId));

    result.fold(
      (failure) {
        AppLogger.error('Failed to load movie details: ${failure.message}');
        emit(MovieDetailsError(message: failure.message ?? 'Failed to load movie details'));
      },
      (movie) {
        AppLogger.info('Loaded movie details: ${movie.title}');
        emit(MovieDetailsLoaded(movie: movie));
      },
    );
  }

  Future<void> _onMovieFavoriteToggleRequested(
    MovieFavoriteToggleRequested event,
    Emitter<MoviesState> emit,
  ) async {
    AppLogger.debug('Toggling favorite for movie: ${event.movieId}');
    
    // TODO: Implement favorite toggle logic
    // This would typically involve calling a use case to add/remove from favorites
    // and then updating the UI state accordingly
    
    AppLogger.info('Movie ${event.movieId} ${event.isFavorite ? 'added to' : 'removed from'} favorites');
  }
}
