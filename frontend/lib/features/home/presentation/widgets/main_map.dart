import 'package:avecpaulette/features/home/presentation/widgets/cottage_tile.dart';
import 'package:avecpaulette/features/home/presentation/widgets/simple_map_widget.dart';
import 'package:avecpaulette/features/home/presentation/widgets/tile_swiper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/cottage.dart';

class MainMap extends StatelessWidget {
  final Set<Cottage> cottages;
  final LatLng target;
  final TileSwiperController tileSwiperController = TileSwiperController();
  final SimpleMapController simpleMapController = SimpleMapController();

  MainMap({
    Key? key,
    required this.cottages,
    required this.target,
  }) : super(key: key);

  List<CottageTile> _getMapTiles() {
    return cottages.map((cottage) => CottageTile(cottage)).toList();
  }

  void _onCottageTapped(Cottage cottage) {
    for (int i = 0; i < cottages.length; i++) {
      if (cottage.title == cottages.toList()[i].title) {
        tileSwiperController.jumpToPage(i);
      }
    }
  }

  void _onTileSelected(int index) {
    simpleMapController.selectMarker(cottages.toList()[index].title);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Center(
        child: SimpleMap(
            simpleMapController: simpleMapController,
            cottages: cottages,
            target: target,
            onCottageSelected: _onCottageTapped),
      ),
      TileSwiper(
        onTileSelected: _onTileSelected,
        tileSwiperController: tileSwiperController,
        mapTiles: _getMapTiles(),
      ),
    ]);
  }
}
