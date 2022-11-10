import 'dart:convert';

import 'package:avecpaulette/core/util/asset_utils.dart';
import 'package:avecpaulette/features/home/presentation/widgets/tile/info_tile_swiper.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utils/test_utils.dart';
import 'robot.dart';

class HomeRobot extends Robot {
  HomeRobot(super.tester);

  Future<List<Marker>> getMarkersFromFile(String filePath) async {
    final cottages = await rootBundle
        .loadString(filePath)
        .then((jsonStr) => jsonDecode(jsonStr));
    final markers = cottages
        .map<Marker>((cottageJson) => Marker(
            markerId: MarkerId(cottageJson["title"]),
            position:
                LatLng(cottageJson["latitude"], cottageJson["longitude"])))
        .toList();
    markers
        .sort((a, b) => a.markerId.toString().compareTo(b.markerId.toString()));

    return markers;
  }

  Future<List<Marker>?> markers() async {
    final markers = await TestUtils.pumpUntilMatch<List<Marker>>(
        tester,
        () => Future.value((tester.widget(find.byType(GoogleMap)) as GoogleMap)
            .markers
            .toList()),
        (markers) => markers.isNotEmpty);

    markers?.sort(
        (a, b) => a.markerId.toString().compareTo(b.markerId.toString()));

    return Future.value(markers);
  }

  Future compareMarkers(
      List<Marker> actualMarkers, List<Marker> expectedMarkers,
      {String? markerIcon}) async {
    BitmapDescriptor? markerBitmap;
    if (markerIcon != null) {
      markerBitmap =
          await AssetUtils.getBitmapDescriptorFromAssetBytes(markerIcon, 50);
    }

    for (int i = 0; i < expectedMarkers.length; i++) {
      expect(actualMarkers[i].markerId, equals(expectedMarkers[i].markerId));
      expect(actualMarkers[i].position.latitude,
          equals(expectedMarkers[i].position.latitude));
      expect(actualMarkers[i].position.longitude,
          equals(expectedMarkers[i].position.longitude));
      if (markerBitmap != null) {
        expect(
            actualMarkers[i].icon.toString(), equals(markerBitmap.toString()));
      }
    }
  }

  void tapOnMarker(String markerId) {
    (tester.widget(find.byType(GoogleMap)) as GoogleMap)
        .markers
        .firstWhere((marker) => marker.markerId.value == markerId)
        .onTap
        ?.call();
  }

  Future checkMarkerIsSelected(String markerId) async {
    BitmapDescriptor bigMarker =
        await AssetUtils.getBitmapDescriptorFromAssetBytes(
            "assets/big_cottage_marker.png", 50);
    BitmapDescriptor smallMarker =
        await AssetUtils.getBitmapDescriptorFromAssetBytes(
            "assets/small_cottage_marker.png", 50);

    await TestUtils.pumpUntilMatch<Set<Marker>>(
        tester,
        () => Future.value(
            (tester.widget(find.byType(GoogleMap)) as GoogleMap).markers),
        (markers) =>
            markers
                .firstWhere((marker) => marker.markerId.value == markerId)
                .icon
                .toString() ==
            bigMarker.toString());

    final markers =
        (tester.widget(find.byType(GoogleMap)) as GoogleMap).markers;
    expect(
        markers
            .where((marker) => marker.markerId.value != markerId)
            .map((marker) => marker.icon.toString()),
        List.filled(markers.length - 1, smallMarker.toString()));
  }

  Future checkTileSwiperIsDisplayed() async {
    await TestUtils.pumpUntilFound(tester, find.byType(TileSwiper));
  }

  Future dragTileSwiperTo(String markerId) async {
    await tester.dragUntilVisible(
      find.text(markerId),
      find.byType(PageView),
      const Offset(-250, 0),
    );
  }
}
