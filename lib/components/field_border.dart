import 'dart:async';

import 'package:flame/collisions.dart';

class FieldBorder extends RectangleHitbox {
  FieldBorder({
    super.position,
    super.size,
  });


  @override
  FutureOr<void> onLoad() {
    debugMode = true;
    // TODO: implement onLoad
    return super.onLoad();
  }
}
