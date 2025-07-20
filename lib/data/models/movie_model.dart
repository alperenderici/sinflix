import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/movie.dart';

part 'movie_model.g.dart';

@JsonSerializable()
class MovieModel extends Movie {
  const MovieModel({
    required super.id,
    required super.title,
    required super.description,
    required super.posterUrl,
    super.isFavorite = false,
    super.overview,
    super.posterPath,
    super.backdropPath,
    super.voteAverage,
    super.voteCount,
    super.releaseDate,
    super.genres = const [],
    super.runtime,
    super.originalLanguage,
    super.adult,
    super.popularity,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    // API response field mapping
    return MovieModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      title: json['Title'] as String? ?? json['title'] as String? ?? '',
      description:
          json['Plot'] as String? ?? json['description'] as String? ?? '',
      posterUrl:
          json['Poster'] as String? ?? json['posterUrl'] as String? ?? '',
      isFavorite: json['isFavorite'] as bool? ?? false,
      overview: json['Plot'] as String?,
      posterPath: json['Poster'] as String?,
      backdropPath: json['backdropPath'] as String?,
      voteAverage: (json['imdbRating'] as String?)?.isNotEmpty == true
          ? double.tryParse(json['imdbRating'] as String)
          : json['voteAverage'] as double?,
      voteCount: json['imdbVotes'] != null
          ? int.tryParse((json['imdbVotes'] as String).replaceAll(',', ''))
          : json['voteCount'] as int?,
      releaseDate: json['Released'] != null
          ? DateTime.tryParse(json['Released'] as String)
          : json['releaseDate'] != null
          ? DateTime.tryParse(json['releaseDate'] as String)
          : null,
      genres: json['Genre'] != null
          ? (json['Genre'] as String).split(', ').map((e) => e.trim()).toList()
          : json['genres'] != null
          ? List<String>.from(json['genres'] as List)
          : [],
      runtime: json['Runtime'] != null
          ? int.tryParse((json['Runtime'] as String).replaceAll(' min', ''))
          : json['runtime'] as int?,
      originalLanguage:
          json['Language'] as String? ?? json['originalLanguage'] as String?,
      adult:
          json['Rated'] == 'R' ||
          json['Rated'] == 'NC-17' ||
          (json['adult'] as bool? ?? false),
      popularity: json['popularity'] as double?,
    );
  }

  Map<String, dynamic> toJson() => _$MovieModelToJson(this);

  factory MovieModel.fromEntity(Movie movie) {
    return MovieModel(
      id: movie.id,
      title: movie.title,
      description: movie.description,
      posterUrl: movie.posterUrl,
      isFavorite: movie.isFavorite,
      overview: movie.overview,
      posterPath: movie.posterPath,
      backdropPath: movie.backdropPath,
      voteAverage: movie.voteAverage,
      voteCount: movie.voteCount,
      releaseDate: movie.releaseDate,
      genres: movie.genres,
      runtime: movie.runtime,
      originalLanguage: movie.originalLanguage,
      adult: movie.adult,
      popularity: movie.popularity,
    );
  }

  Movie toEntity() {
    return Movie(
      id: id,
      title: title,
      description: description,
      posterUrl: posterUrl,
      isFavorite: isFavorite,
      overview: overview,
      posterPath: posterPath,
      backdropPath: backdropPath,
      voteAverage: voteAverage,
      voteCount: voteCount,
      releaseDate: releaseDate,
      genres: genres,
      runtime: runtime,
      originalLanguage: originalLanguage,
      adult: adult,
      popularity: popularity,
    );
  }
}
