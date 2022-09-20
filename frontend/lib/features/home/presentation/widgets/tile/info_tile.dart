import 'package:flutter/material.dart';

import 'draggable_line.dart';

abstract class InfoTile extends StatelessWidget {
  final String id;

  const InfoTile({
    Key? key,
    required this.id,
  }) : super(key: key);

  Widget buildContent();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20)),
            child: Container(
              color: Colors.grey.shade50,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomPaint(
                      size: const Size(20, 1),
                      painter: DraggableLine(),
                    ),
                  ),
                  Expanded(child: buildContent()),
                ],
              ),
            )),
      ),
    );
  }
}
