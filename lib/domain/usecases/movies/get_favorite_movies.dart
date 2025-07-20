import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/movie.dart';
import '../../repositories/movies_repository.dart';

class GetFavoriteMovies implements UseCase<List<Movie>, NoParams> {
  final MoviesRepository repository;

  GetFavoriteMovies(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(NoParams params) async {
    return await repository.getFavoriteMovies();
  }
}
