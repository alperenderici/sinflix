import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final String id;
  final String title;
  final String description;
  final String posterUrl;
  final bool isFavorite;

  // Legacy fields for backward compatibility
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final double? voteAverage;
  final int? voteCount;
  final DateTime? releaseDate;
  final List<String> genres;
  final int? runtime;
  final String? originalLanguage;
  final bool? adult;
  final double? popularity;

  const Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.posterUrl,
    this.isFavorite = false,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.voteAverage,
    this.voteCount,
    this.releaseDate,
    this.genres = const [],
    this.runtime,
    this.originalLanguage,
    this.adult,
    this.popularity,
  });

  Movie copyWith({
    String? id,
    String? title,
    String? description,
    String? posterUrl,
    bool? isFavorite,
    String? overview,
    String? posterPath,
    String? backdropPath,
    double? voteAverage,
    int? voteCount,
    DateTime? releaseDate,
    List<String>? genres,
    int? runtime,
    String? originalLanguage,
    bool? adult,
    double? popularity,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      posterUrl: posterUrl ?? this.posterUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      releaseDate: releaseDate ?? this.releaseDate,
      genres: genres ?? this.genres,
      runtime: runtime ?? this.runtime,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      adult: adult ?? this.adult,
      popularity: popularity ?? this.popularity,
    );
  }

  String get fullPosterUrl {
    if (posterPath == null) return '';
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }

  String get fullBackdropUrl {
    if (backdropPath == null) return '';
    return 'https://image.tmdb.org/t/p/w1280$backdropPath';
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    posterUrl,
    isFavorite,
    overview,
    posterPath,
    backdropPath,
    voteAverage,
    voteCount,
    releaseDate,
    genres,
    runtime,
    originalLanguage,
    adult,
    popularity,
  ];
}
