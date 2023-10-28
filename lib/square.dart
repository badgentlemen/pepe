import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:pepe/constants.dart';
import 'package:pepe/plant.dart';
import 'package:uuid/uuid.dart';

class Square extends RectangleComponent with TapCallbacks {
  Square({
    required double offsetX,
    required double offsetY,
  }) : super(
          position: Vector2(
            offsetX,
            offsetY,
          ),
        );

  Plant? plant;

  @override
  void onTapUp(TapUpEvent event) {
    if (plant != null) {
      return;
    }

    plant = Plant(
      id: const Uuid().v4(),
      offsetX: 0,
      offsetY: 0,
      health: 100,
      fireFrequency: 3,
    );

    add(plant!);

    super.onTapUp(event);
  }

  @override
  FutureOr<void> onLoad() {
    priority = 1;
    size = blockSize;
    return super.onLoad();
  }
}
