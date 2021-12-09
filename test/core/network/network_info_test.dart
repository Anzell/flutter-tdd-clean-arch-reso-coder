import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:tddflutter/core/network/network_info.dart';
import 'package:mockito/mockito.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([InternetConnectionChecker])
void main() {
  late NetworkInfoImpl networkInfo;
  late MockInternetConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockInternetConnectionChecker();
    networkInfo = NetworkInfoImpl(connectionChecker: mockDataConnectionChecker);
  });

  group("is connected", () {
    test("should forward the call to DataConnectionChecker.hasConnection", () async {
      final hasConnectionFuture = Future.value(true);
      when(mockDataConnectionChecker.hasConnection).thenAnswer((_) => hasConnectionFuture);
      final result = networkInfo.isConnected;
      verify(mockDataConnectionChecker.hasConnection);
      expect(result, hasConnectionFuture);
    });
  });
}
