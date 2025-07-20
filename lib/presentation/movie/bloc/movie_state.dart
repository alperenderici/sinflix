import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart';

abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object> get props => [];
}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<Movie> movies;
  final bool hasReachedMax;
  final int currentPage;
  final bool isLoadingMore;

  const MovieLoaded({
    required this.movies,
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.isLoadingMore = false,
  });

  MovieLoaded copyWith({
    List<Movie>? movies,
    bool? hasReachedMax,
    int? currentPage,
    bool? isLoadingMore,
  }) {
    return MovieLoaded(
      movies: movies ?? this.movies,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object> get props => [movies, hasReachedMax, currentPage, isLoadingMore];
}

class MovieError extends MovieState {
  final String message;

  const MovieError(this.message);

  @override
  List<Object> get props => [message];
}

class FavoriteMoviesLoaded extends MovieState {
  final List<Movie> favoriteMovies;

  const FavoriteMoviesLoaded(this.favoriteMovies);

  @override
  List<Object> get props => [favoriteMovies];
}

class FavoriteToggleSuccess extends MovieState {
  final String movieId;

  const FavoriteToggleSuccess(this.movieId);

  @override
  List<Object> get props => [movieId];
}
