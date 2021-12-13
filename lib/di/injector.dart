import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tddflutter/core/network/network_info.dart';
import 'package:tddflutter/core/util/input_converter.dart';
import 'package:tddflutter/data/datasources/number_trivia_local_datasource.dart';
import 'package:tddflutter/data/datasources/number_trivia_remote_datasource.dart';
import 'package:tddflutter/data/repositories/number_trivia_repository_impl.dart';
import 'package:tddflutter/domain/repositories/number_trivia_repository.dart';
import 'package:tddflutter/domain/usecases/number_trivia/get_concrete_number_trivia.dart';
import 'package:tddflutter/domain/usecases/number_trivia/get_random_number_trivia.dart';
import 'package:tddflutter/presentation/number_trivia/controller/bloc/number_trivia_controller_bloc.dart';

final getIt = GetIt.instance;

class Injector {
  static Future<void> init() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    getIt.registerFactory<SharedPreferences>(() => sharedPreferences);
    getIt.registerFactory<http.Client>(() => http.Client());
    getIt.registerFactory<InternetConnectionChecker>(() => InternetConnectionChecker());
    getIt.registerFactory<NetworkInfo>(() => NetworkInfoImpl(connectionChecker: getIt()));
    getIt.registerFactory<NumberTriviaRemoteDatasource>(() => NumberTriviaRemoteDatasourceImpl(client: getIt()));
    getIt.registerFactory<NumberTriviaLocalDatasource>(() => NumberTriviaLocalDatasourceImpl(storage: getIt()));
    getIt.registerFactory<NumberTriviaRepository>(
      () => NumberTriviaRepositoryImpl(
        localDatasource: getIt(),
        networkInfo: getIt(),
        remoteDatasource: getIt(),
      ),
    );
    getIt.registerFactory<GetConcreteNumberTrivia>(() => GetConcreteNumberTrivia(repository: getIt()));
    getIt.registerFactory<GetRandomNumberTrivia>(() => GetRandomNumberTrivia(repository: getIt()));
    getIt.registerFactory<InputConverter>(() => InputConverter());
    getIt.registerFactory<NumberTriviaControllerBloc>(
      () => NumberTriviaControllerBloc(
        getConcreteNumberTrivia: getIt(),
        getRandomNumberTrivia: getIt(),
        inputConverter: getIt(),
      ),
    );
  }
}
