import 'package:flutter/material.dart';

class ExpandableWidget extends StatefulWidget {
  final Widget child;
  final double minHeight;
  final double maxHeight;

  const ExpandableWidget(
      {Key? key,
      required this.child,
      required this.minHeight,
      required this.maxHeight})
      : super(key: key);

  @override
  State<ExpandableWidget> createState() => _ExpandableWidgetState();
}

class _ExpandableWidgetState extends State<ExpandableWidget> {
  late double currentHeight = widget.minHeight;
  Duration duration = const Duration(milliseconds: 0);
  double lastPosition = 0;
  double startPosition = 0;
  bool draggingInProgress = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      height: currentHeight,
      child: GestureDetector(
          onVerticalDragEnd: (DragEndDetails details) {
            setState(() {
              if (draggingInProgress) {
                draggingInProgress = false;
                duration = const Duration(milliseconds: 400);

                //if dragging down :
                if (lastPosition - startPosition > 0) {
                  //If dragged it enough down, take the minimum height
                  if (MediaQuery.of(context).size.height - lastPosition >
                      widget.maxHeight -
                          (widget.maxHeight - widget.minHeight) * 0.2) {
                    currentHeight = widget.maxHeight;
                  }
                  //Else go back to the maximum height
                  else {
                    currentHeight = widget.minHeight;
                  }
                }
                //If dragging up
                else {
                  //If dragged it enough up, take the maximum height
                  if (MediaQuery.of(context).size.height - lastPosition >
                      widget.minHeight +
                          (widget.maxHeight - widget.minHeight) * 0.2) {
                    currentHeight = widget.maxHeight;
                  }
                  //Else go back to the minimum height
                  else {
                    currentHeight = widget.minHeight;
                  }
                }
              }
            });
          },
          onVerticalDragStart: (DragStartDetails details) {
            //Enable dragging on if the user draggit for the upper border or if it's very small
            if (details.localPosition.dy < currentHeight * 0.2 ||
                currentHeight < 70) {
              draggingInProgress = true;
            }
            startPosition = details.globalPosition.dy;
          },
          onVerticalDragUpdate: (DragUpdateDetails details) {
            setState(() {
              if (draggingInProgress) {
                lastPosition = details.globalPosition.dy;
                duration = const Duration(milliseconds: 0);

                //Don't drag it under the min height
                if (lastPosition >
                    MediaQuery.of(context).size.height - widget.minHeight) {
                  currentHeight = widget.minHeight;
                }
                //Update current height on drag
                else {
                  currentHeight =
                      MediaQuery.of(context).size.height - lastPosition;
                }
              }
            });
          },
          child: widget.child),
    );
  }
}
