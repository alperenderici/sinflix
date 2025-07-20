import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

// Core
import '../network/dio_client.dart';
import '../services/analytics_service.dart';
import '../services/crashlytics_service.dart';
import '../utils/app_logger.dart';

// Data Sources
import '../../data/datasources/auth/auth_remote_data_source.dart';
import '../../data/datasources/movie/movie_remote_data_source.dart';
import '../../data/datasources/movies/movies_remote_datasource.dart';
import '../../data/datasources/profile/profile_remote_datasource.dart';

// Repositories
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../data/repositories/movies_repository_impl.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../domain/repositories/movies_repository.dart';
import '../../domain/repositories/profile_repository.dart';

// Use Cases
import '../../domain/usecases/auth/login_user.dart';
import '../../domain/usecases/auth/register_user.dart';
import '../../domain/usecases/auth/logout_user.dart';
import '../../domain/usecases/auth/get_current_user.dart';
import '../../domain/usecases/movie/get_movies.dart';
import '../../domain/usecases/movie/get_favorite_movies.dart';
import '../../domain/usecases/movie/toggle_favorite.dart';
import '../../domain/usecases/movies/get_movies.dart' as legacy_movies;
import '../../domain/usecases/movies/get_movie_details.dart';
import '../../domain/usecases/movies/search_movies.dart';
import '../../domain/usecases/movies/toggle_favorite_movie.dart';
import '../../domain/usecases/movies/get_favorite_movies.dart' as movies;
import '../../domain/usecases/profile/get_user_profile.dart';
import '../../domain/usecases/profile/update_user_profile.dart';
import '../../domain/usecases/profile/upload_profile_picture.dart';
import '../../domain/usecases/profile/get_favorite_movies.dart'
    as legacy_favorites;
import '../../domain/usecases/profile/add_to_favorites.dart';
import '../../domain/usecases/profile/remove_from_favorites.dart';

// BLoCs
import '../../presentation/auth/bloc/auth_bloc.dart';
import '../../presentation/movie/bloc/movie_bloc.dart';
import '../../presentation/home/bloc/movies_bloc.dart';
import '../../presentation/profile/bloc/profile_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  AppLogger.info('Initializing dependency injection...');

  // Core
  _initCore();

  // Services
  _initServices();

  // Data sources
  _initDataSources();

  // Repositories
  _initRepositories();

  // Use cases
  _initUseCases();

  // BLoCs
  _initBlocs();

  AppLogger.info('Dependency injection initialized successfully');
}

void _initCore() {
  // Dio
  sl.registerLazySingleton<Dio>(() => Dio());

  // Dio Client
  sl.registerLazySingleton<DioClient>(() => DioClient(sl()));
}

void _initServices() {
  // Firebase services are singletons and don't need registration
  // They are accessed statically through AnalyticsService and CrashlyticsService
}

void _initDataSources() {
  // Auth
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  // Movie
  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(sl()),
  );

  // Movies (Legacy)
  sl.registerLazySingleton<MoviesRemoteDataSource>(
    () => MoviesRemoteDataSourceImpl(dioClient: sl()),
  );

  // Profile
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(dioClient: sl()),
  );
}

void _initRepositories() {
  // Auth
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Movie
  sl.registerLazySingleton<MovieRepository>(() => MovieRepositoryImpl(sl()));

  // Movies (Legacy)
  sl.registerLazySingleton<MoviesRepository>(
    () => MoviesRepositoryImpl(remoteDataSource: sl()),
  );

  // Profile
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl()),
  );
}

void _initUseCases() {
  // Auth Use Cases
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => LogoutUser(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));

  // Movie Use Cases
  sl.registerLazySingleton(() => GetMovies(sl()));
  sl.registerLazySingleton(() => GetFavoriteMovies(sl()));
  sl.registerLazySingleton(() => ToggleFavorite(sl()));

  // Movies Use Cases (Legacy)
  sl.registerLazySingleton(() => legacy_movies.GetMovies(sl()));
  sl.registerLazySingleton(() => GetMovieDetails(sl()));
  sl.registerLazySingleton(() => SearchMovies(sl()));
  sl.registerLazySingleton(() => ToggleFavoriteMovie(sl()));
  sl.registerLazySingleton(() => movies.GetFavoriteMovies(sl()));

  // Profile Use Cases
  sl.registerLazySingleton(() => GetUserProfile(sl()));
  sl.registerLazySingleton(() => UpdateUserProfile(sl()));
  sl.registerLazySingleton(() => UploadProfilePicture(sl()));
  sl.registerLazySingleton(() => legacy_favorites.GetFavoriteMovies(sl()));
  sl.registerLazySingleton(() => AddToFavorites(sl()));
  sl.registerLazySingleton(() => RemoveFromFavorites(sl()));
}

void _initBlocs() {
  // Auth BLoC
  sl.registerFactory(
    () => AuthBloc(
      loginUser: sl(),
      registerUser: sl(),
      logoutUser: sl(),
      getCurrentUser: sl(),
    ),
  );

  // Movie BLoC
  sl.registerFactory(
    () => MovieBloc(
      getMovies: sl(),
      getFavoriteMovies: sl(),
      toggleFavorite: sl(),
    ),
  );

  // Movies BLoC (Legacy) - Using correct Movie repository
  sl.registerFactory(
    () => MoviesBloc(
      getMovies: sl<legacy_movies.GetMovies>(),
      getMovieDetails: sl(),
      searchMovies: sl(),
      toggleFavoriteMovie: sl(),
    ),
  );

  // Profile BLoC
  sl.registerFactory(
    () => ProfileBloc(
      getUserProfile: sl(),
      updateUserProfile: sl(),
      uploadProfilePicture: sl(),
      getFavoriteMovies: sl<movies.GetFavoriteMovies>(),
      addToFavorites: sl(),
      removeFromFavorites: sl(),
    ),
  );
}
