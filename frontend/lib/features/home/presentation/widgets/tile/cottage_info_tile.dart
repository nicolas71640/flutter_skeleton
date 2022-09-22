import 'package:flutter/material.dart';

import '../../../domain/entities/cottage.dart';
import 'info_tile.dart';

class CottageInfoTile extends InfoTile {
  final Cottage cottage;

  CottageInfoTile(this.cottage, {Key? key})
      : super(key: key, id: cottage.title);

  @override
  Widget buildContent() {
    return ListTile(title: Text(cottage.title));
  }
}
