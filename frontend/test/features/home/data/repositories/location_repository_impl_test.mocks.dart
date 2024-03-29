// Mocks generated by Mockito 5.4.2 from annotations
// in avecpaulette/test/features/home/data/repositories/location_repository_impl_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:avecpaulette/features/home/data/datasources/location_service.dart'
    as _i3;
import 'package:avecpaulette/features/home/domain/entities/location_entity.dart'
    as _i5;
import 'package:location/location.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeLocation_0 extends _i1.SmartFake implements _i2.Location {
  _FakeLocation_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [LocationService].
///
/// See the documentation for Mockito's code generation for more information.
class MockLocationService extends _i1.Mock implements _i3.LocationService {
  MockLocationService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Location get location => (super.noSuchMethod(
        Invocation.getter(#location),
        returnValue: _FakeLocation_0(
          this,
          Invocation.getter(#location),
        ),
      ) as _i2.Location);
  @override
  _i4.Stream<_i5.LocationEntity> getCurrentLocation() => (super.noSuchMethod(
        Invocation.method(
          #getCurrentLocation,
          [],
        ),
        returnValue: _i4.Stream<_i5.LocationEntity>.empty(),
      ) as _i4.Stream<_i5.LocationEntity>);
}
