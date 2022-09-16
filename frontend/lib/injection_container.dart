import 'package:avecpaulette/core/network/api.dart';
import 'package:avecpaulette/core/network/network_info.dart';
import 'package:avecpaulette/features/credentials/data/datasources/credentials_api_service.dart';
import 'package:avecpaulette/features/credentials/data/repositories/credentials_repository_impl.dart';
import 'package:avecpaulette/features/credentials/domain/repositories/credentials_repository.dart';
import 'package:avecpaulette/features/credentials/domain/usecases/authentication_usecase.dart';
import 'package:avecpaulette/features/credentials/domain/usecases/forgotten_password_usecase.dart';
import 'package:avecpaulette/features/credentials/domain/usecases/login_usecase.dart';
import 'package:avecpaulette/features/credentials/domain/usecases/signup_usecase.dart';
import 'package:avecpaulette/features/credentials/presentation/bloc/authentication_bloc.dart';
import 'package:avecpaulette/features/credentials/presentation/bloc/forgotten_password_bloc.dart';
import 'package:avecpaulette/features/credentials/presentation/bloc/login_bloc.dart';
import 'package:avecpaulette/features/credentials/presentation/bloc/signup_bloc.dart';
import 'package:avecpaulette/features/departmentsViewer/data/datasources/number_trivia_local_data_source.dart';
import 'package:avecpaulette/features/departmentsViewer/data/datasources/number_trivia_remote_data_source.dart';
import 'package:avecpaulette/features/departmentsViewer/data/repositories/number_trivia_repository_impl.dart';
import 'package:avecpaulette/features/departmentsViewer/domain/repositories/number_trivia_repository.dart';
import 'package:avecpaulette/features/departmentsViewer/domain/usecases/get_concrete_number_trivia_usecase.dart';
import 'package:avecpaulette/features/departmentsViewer/domain/usecases/get_random_number_trivia_usecase.dart';
import 'package:avecpaulette/features/home/data/datasources/cottage_api_service.dart';
import 'package:avecpaulette/features/home/data/datasources/location_service.dart';
import 'package:avecpaulette/features/home/data/repositories/cottage_repository_impl.dart';
import 'package:avecpaulette/features/home/data/repositories/location_repository_impl.dart';
import 'package:avecpaulette/features/home/domain/repositories/cottage_repository.dart';
import 'package:avecpaulette/features/home/domain/repositories/location_repository.dart';
import 'package:avecpaulette/features/home/domain/usecases/cottage_usecase.dart';
import 'package:avecpaulette/features/home/domain/usecases/location_usecase.dart';
import 'package:avecpaulette/features/home/presentation/bloc/home_bloc.dart';
import 'package:avecpaulette/features/stuff/data/datasources/stuff_api_service.dart';
import 'package:avecpaulette/features/stuff/domain/repositories/stuff_repository.dart';
import 'package:avecpaulette/features/stuff/domain/usecases/get_stuff_usecase.dart';
import 'package:avecpaulette/features/stuff/presentation/bloc/bloc/stuff_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/local_data_source/credentials_local_data_source.dart';
import 'core/util/input_converter.dart';
import 'features/departmentsViewer/presentation/bloc/number_trivia_bloc.dart';
import 'package:http/http.dart' as http;

import 'features/stuff/data/repositories/stuff_repository_impl.dart';

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
  sl.registerFactory(() => AuthenticationBloc(sl()));
  sl.registerFactory(() => LoginBloc(sl()));
  sl.registerFactory(() => ForgottenPasswordBloc(sl()));
  sl.registerFactory(() => SignupBloc(sl()));
  sl.registerFactory(() => StuffBloc(sl()));
  sl.registerFactory(() => HomeBloc(sl(), sl()));

  //UseCases, Lazy = only created when called, Regular = created when the app starts
  sl.registerLazySingleton(() => GetConcreteNumberTriviaUseCase(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTriviaUseCase(sl()));
  sl.registerLazySingleton(() => AuthenticationUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));
  sl.registerLazySingleton(() => GetStuffUseCase(sl()));
  sl.registerLazySingleton(() => ForgottenPasswordUseCase(sl()));
  sl.registerLazySingleton(() => CottageUseCase(sl()));
  sl.registerLazySingleton(() => LocationUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<NumberTriviaRepository>(
      () => NumberTriviaRepositoryImpl(
            remoteDataSource: sl(),
            localDataSource: sl(),
            networkInfo: sl(),
          ));
  sl.registerLazySingleton<CredentialsRepository>(
      () => CredentialsRepositoryImpl(sl(), sl(), sl()));
  sl.registerLazySingleton<StuffRepository>(
      () => StuffRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<CottageRepository>(
      () => CottageRepositoryImpl(sl()));
  sl.registerLazySingleton<LocationRepository>(
      () => LocationRepositoryImpl(sl()));

  //Data Sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(sl()));

  sl.registerSingletonWithDependencies<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sl()),
      dependsOn: [SharedPreferences]);

  sl.registerLazySingleton<Dio>(
      instanceName: "Dio", () => Api.createDio(sl(), sl()));
  sl.registerLazySingleton<Dio>(
      instanceName: "CredentialsDio", () => Api.createCredentialsDio());

  sl.registerLazySingleton<CredentialsLocalDataSource>(
      () => CredentialsLocalDataSourceImpl(sl()));
  sl.registerLazySingleton<CredentialsApiService>(
      () => CredentialsApiService(sl(instanceName: "CredentialsDio")));
  sl.registerLazySingleton<StuffApiService>(
      () => StuffApiService(sl(instanceName: "Dio")));
  sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn(
        scopes: ['email'],
      ));
  sl.registerLazySingleton<CottageApiService>(
      () => CottageApiService(sl(instanceName: "Dio")));
  sl.registerLazySingleton<LocationService>(() => LocationService(sl()));
  sl.registerLazySingleton<Location>(() => Location());
}

void initCore() {
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
}

void initExternal() {
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerSingletonAsync(() async => await SharedPreferences.getInstance());
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton<http.Client>(() => http.Client());
}
