import 'package:avecpaulette/features/home/data/datasources/cottage_api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'cottage_repository_impl_test.mocks.dart';

//TODO
@GenerateMocks([
  CottageApiService,
])
void main() {
  late MockCottageApiService mockCottageApiService;

  setUp(() {
    mockCottageApiService = MockCottageApiService();
  });

  group("getItinerary", () {
    test("should ?????? ", () async {});
  });
}
