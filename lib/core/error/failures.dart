abstract class Failure {
  Failure([List properties = const <dynamic>[]]);
}

class ServerFailure implements Failure {}

class CacheFailure implements Failure {}
