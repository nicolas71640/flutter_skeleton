import 'package:avecpaulette/core/util/ui_utils.dart';
import 'package:flutter/material.dart';

import 'map_tile.dart';

typedef OnTileSelected = void Function(int index);

class TileSwiper extends StatefulWidget {
  const TileSwiper({
    Key? key,
    required this.mapTiles,
    required this.tileSwiperController,
    this.onTileSelected,
  }) : super(key: key);

  final List<MapTile> mapTiles;
  final TileSwiperController tileSwiperController;
  final OnTileSelected? onTileSelected;

  @override
  State<TileSwiper> createState() => _TileSwiperState();
}

class _TileSwiperState extends State<TileSwiper> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      height: context.dynamicHeight(0.20),
      bottom: context.dynamicHeight(0.01),
      right: 0,
      left: 0,
      child: PageView(
        onPageChanged: (value) => widget.onTileSelected?.call(value),
        controller: widget.tileSwiperController.pageController,
        children: widget.mapTiles,
      ),
    );
  }
}

class TileSwiperController {
  final PageController pageController = PageController(viewportFraction: 0.9);

  void jumpToPage(int page) {
    pageController.animateToPage(page,
        duration: const Duration(milliseconds: 400), curve: Curves.decelerate);
  }
}
