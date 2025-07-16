import 'package:equatable/equatable.dart';

abstract class MoviesEvent extends Equatable {
  const MoviesEvent();

  @override
  List<Object?> get props => [];
}

class MoviesLoadRequested extends MoviesEvent {
  final bool isRefresh;

  const MoviesLoadRequested({this.isRefresh = false});

  @override
  List<Object> get props => [isRefresh];
}

class MoviesLoadMoreRequested extends MoviesEvent {
  const MoviesLoadMoreRequested();
}

class MoviesRefreshRequested extends MoviesEvent {
  const MoviesRefreshRequested();
}

class MoviesSearchRequested extends MoviesEvent {
  final String query;

  const MoviesSearchRequested({required this.query});

  @override
  List<Object> get props => [query];
}

class MoviesSearchClearRequested extends MoviesEvent {
  const MoviesSearchClearRequested();
}

class MovieDetailsRequested extends MoviesEvent {
  final String movieId;

  const MovieDetailsRequested({required this.movieId});

  @override
  List<Object> get props => [movieId];
}

class MovieFavoriteToggleRequested extends MoviesEvent {
  final String movieId;
  final bool isFavorite;

  const MovieFavoriteToggleRequested({
    required this.movieId,
    required this.isFavorite,
  });

  @override
  List<Object> get props => [movieId, isFavorite];
}
