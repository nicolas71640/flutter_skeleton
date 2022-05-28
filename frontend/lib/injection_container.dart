import 'package:departments/core/network/network_info.dart';
import 'package:departments/features/departmentsViewer/data/datasources/number_trivia_local_data_source.dart';
import 'package:departments/features/departmentsViewer/data/datasources/number_trivia_remote_data_source.dart';
import 'package:departments/features/departmentsViewer/data/repositories/number_trivia_repository_impl.dart';
import 'package:departments/features/departmentsViewer/domain/repositories/number_trivia_repository.dart';
import 'package:departments/features/departmentsViewer/domain/usecases/get_concrete_number_trivia_usecase.dart';
import 'package:departments/features/departmentsViewer/domain/usecases/get_random_number_trivia_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/util/input_converter.dart';
import 'features/departmentsViewer/presentation/bloc/number_trivia_bloc.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;
void init() {
  //! External
  initExternal();

  //! Features - Number Trivia
  initFeatures();

  //! Core
  initCore();
}

void initFeatures() {
  //Bloc, a block should never be injected as singleton
  sl.registerFactory(() => NumberTriviaBloc(
      getConcreteNumberTriviaUseCase: sl(),
      getRandomNumberTriviaUseCase: sl(),
      inputConverter: sl()));

  //UseCases, Lazy = only created when called, Regular = created when the app starts
  sl.registerLazySingleton(() => GetConcreteNumberTriviaUseCase(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTriviaUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<NumberTriviaRepository>(
      () => NumberTriviaRepositoryImpl(
            remoteDataSource: sl(),
            localDataSource: sl(),
            networkInfo: sl(),
          ));

  //Data Sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(sl()));

  sl.registerSingletonWithDependencies<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sl()),
      dependsOn: [SharedPreferences]);
}

void initCore() {
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
}

void initExternal() {
  sl.registerSingletonAsync(() async => await SharedPreferences.getInstance());
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton<http.Client>(() => http.Client());
}
