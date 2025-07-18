import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/movie.dart';
import '../../repositories/movie_repository.dart';

class GetMovies implements UseCase<List<Movie>, GetMoviesParams> {
  final MovieRepository repository;

  GetMovies(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(GetMoviesParams params) async {
    return await repository.getMovies(page: params.page);
  }
}

class GetMoviesParams {
  final int page;

  GetMoviesParams({required this.page});
}
