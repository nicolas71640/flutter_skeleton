import 'package:avecpaulette/core/util/ui_utils.dart';
import 'package:flutter/material.dart';

import 'expandable_widget.dart';
import 'info_tile.dart';

typedef OnTileSelected = void Function(int index);

class TileSwiper extends StatefulWidget {
  const TileSwiper({
    Key? key,
    required this.mapTiles,
    required this.tileSwiperController,
    this.onTileSelected,
  }) : super(key: key);

  final List<InfoTile> mapTiles;
  final TileSwiperController tileSwiperController;
  final OnTileSelected? onTileSelected;

  @override
  State<TileSwiper> createState() => _TileSwiperState();
}

class _TileSwiperState extends State<TileSwiper> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: context.dynamicHeight(0.01),
        right: 0,
        left: 0,
        child: ExpandableWidget(
          minHeight: 200,
          maxHeight: 600,
          child: PageView(
            onPageChanged: (value) => widget.onTileSelected?.call(value),
            controller: widget.tileSwiperController.pageController,
            children: widget.mapTiles,
          ),
        ));
  }
}

class TileSwiperController {
  final int initialPage;
  late PageController pageController;

  TileSwiperController({this.initialPage = 0}) {
    pageController =
        PageController(viewportFraction: 0.9, initialPage: initialPage);
  }

  void jumpToPage(int page) {
    pageController.animateToPage(page,
        duration: const Duration(milliseconds: 400), curve: Curves.decelerate);
  }
}
