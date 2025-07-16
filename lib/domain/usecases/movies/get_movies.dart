import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/movie.dart';
import '../../repositories/movies_repository.dart';

class GetMovies implements UseCase<List<Movie>, GetMoviesParams> {
  final MoviesRepository repository;

  GetMovies(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(GetMoviesParams params) async {
    return await repository.getMovies(
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetMoviesParams extends Equatable {
  final int page;
  final int limit;

  const GetMoviesParams({
    this.page = 1,
    this.limit = 5,
  });

  @override
  List<Object> get props => [page, limit];
}
