import 'package:avecpaulette/features/home/presentation/widgets/map_widget.dart';
import 'package:avecpaulette/features/home/presentation/widgets/tile/info_tile_swiper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/cottage.dart';
import 'tile/cottage_info_tile.dart';

class MainMap extends StatefulWidget {
  final Set<Cottage> cottages;
  final LatLng target;

  MainMap({
    Key? key,
    required this.cottages,
    required this.target,
  }) : super(key: key);

  @override
  State<MainMap> createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {
  TileSwiperController tileSwiperController = TileSwiperController();
  final SimpleMapController simpleMapController = SimpleMapController();
  var _isTileSwiperVisible = false;

  List<CottageInfoTile> _getMapTiles() {
    return widget.cottages.map((cottage) => CottageInfoTile(cottage)).toList();
  }

  int? _getIndexOfCottage(Cottage cottage) {
    for (int i = 0; i < widget.cottages.length; i++) {
      if (cottage.title == widget.cottages.toList()[i].title) {
        return i;
      }
    }
    return null;
  }

  void _onCottageTapped(Cottage cottage) {
    int? cottageIndex = _getIndexOfCottage(cottage);
    if (!_isTileSwiperVisible) {
      tileSwiperController =
          TileSwiperController(initialPage: _getIndexOfCottage(cottage) ?? 0);
    } else {
      if (cottageIndex != null) {
        tileSwiperController.jumpToPage(cottageIndex);
      }
    }
    _isTileSwiperVisible = true;
    setState(() {});
  }

  void _onTileSelected(int index) {
    simpleMapController.selectMarker(widget.cottages.toList()[index].title);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        setState(() {
          simpleMapController.selectMarker("");
          _isTileSwiperVisible = false;
        });
        return Future.value(false);
      },
      child: Stack(children: [
        Center(
          child: MapWidget(
              simpleMapController: simpleMapController,
              cottages: widget.cottages,
              target: widget.target,
              onCottageSelected: _onCottageTapped),
        ),
        Visibility(
          visible: _isTileSwiperVisible,
          child: TileSwiper(
            onTileSelected: _onTileSelected,
            tileSwiperController: tileSwiperController,
            mapTiles: _getMapTiles(),
          ),
        ),
      ]),
    );
  }
}
