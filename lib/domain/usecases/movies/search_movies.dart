import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/movie.dart';
import '../../repositories/movies_repository.dart';

class SearchMovies implements UseCase<List<Movie>, SearchMoviesParams> {
  final MoviesRepository repository;

  SearchMovies(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(SearchMoviesParams params) async {
    return await repository.searchMovies(
      query: params.query,
      page: params.page,
      limit: params.limit,
    );
  }
}

class SearchMoviesParams extends Equatable {
  final String query;
  final int page;
  final int limit;

  const SearchMoviesParams({
    required this.query,
    this.page = 1,
    this.limit = 5,
  });

  @override
  List<Object> get props => [query, page, limit];
}
