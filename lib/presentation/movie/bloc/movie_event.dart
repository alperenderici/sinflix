import 'package:equatable/equatable.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object> get props => [];
}

class LoadMovies extends MovieEvent {
  final int page;
  final bool isRefresh;

  const LoadMovies({
    this.page = 1,
    this.isRefresh = false,
  });

  @override
  List<Object> get props => [page, isRefresh];
}

class LoadMoreMovies extends MovieEvent {}

class ToggleMovieFavorite extends MovieEvent {
  final String movieId;

  const ToggleMovieFavorite(this.movieId);

  @override
  List<Object> get props => [movieId];
}

class LoadFavoriteMovies extends MovieEvent {}
