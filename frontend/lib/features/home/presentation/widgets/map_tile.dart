import 'package:flutter/material.dart';

abstract class MapTile extends StatelessWidget {
  final String id;
  
  const MapTile({
    Key? key, required this.id,
  }) : super(key: key);

  Widget buildContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20)),
          child: Container(
              color: Colors.amber,
              child: buildContent())),
    );
  }
}