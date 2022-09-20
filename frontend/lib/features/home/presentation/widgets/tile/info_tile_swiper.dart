import 'package:avecpaulette/core/util/ui_utils.dart';
import 'package:flutter/material.dart';

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
  double height = 200;
  Duration duration = const Duration(milliseconds: 0);
  double lastPosition = 0;
  double startPosition = 0;
  final double smallHeight = 200;
  final double bigHeight = 600;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: context.dynamicHeight(0.01),
      right: 0,
      left: 0,
      child: AnimatedContainer(
        duration: duration,
        height: height,
        child: GestureDetector(
          onVerticalDragEnd: (DragEndDetails details) {
            setState(() {
              duration = const Duration(milliseconds: 400);

              //if dragging down :
              if (lastPosition - startPosition > 0) {
                if (MediaQuery.of(context).size.height - lastPosition >
                    bigHeight - (bigHeight - smallHeight) * 0.2) {
                  height = bigHeight;
                } else {
                  height = smallHeight;
                }
              } else {
                if (MediaQuery.of(context).size.height - lastPosition >
                    smallHeight + (bigHeight - smallHeight) * 0.2) {
                  height = bigHeight;
                } else {
                  height = smallHeight;
                }
              }
            });
          },
          onVerticalDragStart: (DragStartDetails details) =>
              startPosition = details.globalPosition.dy,
          onVerticalDragUpdate: (DragUpdateDetails details) {
            setState(() {
              lastPosition = details.globalPosition.dy;
              duration = const Duration(milliseconds: 0);

              /// Limits at 200 height minimum
              if (lastPosition > MediaQuery.of(context).size.height - 200) {
                height = smallHeight;
              } else {
                height = MediaQuery.of(context).size.height - lastPosition;
              }
            });
          },
          child: PageView(
            onPageChanged: (value) => widget.onTileSelected?.call(value),
            controller: widget.tileSwiperController.pageController,
            children: widget.mapTiles,
          ),
        ),
      ),
    );
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
