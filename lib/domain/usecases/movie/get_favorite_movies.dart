import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/movie.dart';
import '../../repositories/movie_repository.dart';

class GetFavoriteMovies implements UseCase<List<Movie>, NoParams> {
  final MovieRepository repository;

  GetFavoriteMovies(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(NoParams params) async {
    return await repository.getFavoriteMovies();
  }
}
