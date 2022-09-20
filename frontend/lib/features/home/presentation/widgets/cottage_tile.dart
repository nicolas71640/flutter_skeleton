import 'package:flutter/material.dart';

import '../../domain/entities/cottage.dart';
import 'map_tile.dart';

class CottageTile extends MapTile {
  final Cottage cottage;

  CottageTile(this.cottage, {Key? key}) : super(key: key, id: cottage.title);

  @override
  Widget buildContent() {
    return ListTile(title: Text(cottage.title));
  }
}
