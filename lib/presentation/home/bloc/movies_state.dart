import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart';

abstract class MoviesState extends Equatable {
  const MoviesState();

  @override
  List<Object?> get props => [];
}

class MoviesInitial extends MoviesState {
  const MoviesInitial();
}

class MoviesLoading extends MoviesState {
  const MoviesLoading();
}

class MoviesLoaded extends MoviesState {
  final List<Movie> movies;
  final bool hasReachedMax;
  final int currentPage;
  final bool isLoadingMore;

  const MoviesLoaded({
    required this.movies,
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.isLoadingMore = false,
  });

  MoviesLoaded copyWith({
    List<Movie>? movies,
    bool? hasReachedMax,
    int? currentPage,
    bool? isLoadingMore,
  }) {
    return MoviesLoaded(
      movies: movies ?? this.movies,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object> get props => [movies, hasReachedMax, currentPage, isLoadingMore];
}

class MoviesError extends MoviesState {
  final String message;

  const MoviesError({required this.message});

  @override
  List<Object> get props => [message];
}

class MoviesSearchLoading extends MoviesState {
  const MoviesSearchLoading();
}

class MoviesSearchLoaded extends MoviesState {
  final List<Movie> movies;
  final String query;
  final bool hasReachedMax;
  final int currentPage;

  const MoviesSearchLoaded({
    required this.movies,
    required this.query,
    this.hasReachedMax = false,
    this.currentPage = 1,
  });

  MoviesSearchLoaded copyWith({
    List<Movie>? movies,
    String? query,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return MoviesSearchLoaded(
      movies: movies ?? this.movies,
      query: query ?? this.query,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object> get props => [movies, query, hasReachedMax, currentPage];
}

class MoviesSearchError extends MoviesState {
  final String message;
  final String query;

  const MoviesSearchError({
    required this.message,
    required this.query,
  });

  @override
  List<Object> get props => [message, query];
}

class MovieDetailsLoading extends MoviesState {
  const MovieDetailsLoading();
}

class MovieDetailsLoaded extends MoviesState {
  final Movie movie;

  const MovieDetailsLoaded({required this.movie});

  @override
  List<Object> get props => [movie];
}

class MovieDetailsError extends MoviesState {
  final String message;

  const MovieDetailsError({required this.message});

  @override
  List<Object> get props => [message];
}
