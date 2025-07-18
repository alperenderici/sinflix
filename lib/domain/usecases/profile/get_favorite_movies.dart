import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/movie.dart';
import '../../repositories/profile_repository.dart';

class GetFavoriteMovies
    implements UseCase<List<Movie>, GetFavoriteMoviesParams> {
  final ProfileRepository repository;

  GetFavoriteMovies(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(
    GetFavoriteMoviesParams params,
  ) async {
    return await repository.getFavoriteMovies(
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetFavoriteMoviesParams extends Equatable {
  final int page;
  final int limit;

  const GetFavoriteMoviesParams({this.page = 1, this.limit = 10});

  @override
  List<Object> get props => [page, limit];
}
