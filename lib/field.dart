import 'dart:async';

import 'package:flame/components.dart';
import 'package:pepe/constants.dart';
import 'package:pepe/pest.dart';
import 'package:pepe/square.dart';
import 'package:uuid/uuid.dart';

class Field extends RectangleComponent {
  Field()
      : super(
          position: Vector2(40, 40),
          size: Vector2(700, 350),
        );

  Timer? timer;

  int get numLinesY => (size.y / blockSize.y).floor();

  int get numLinesX => (size.x / blockSize.x).floor();

  @override
  FutureOr<void> onLoad() {
    final pest = Pest(
      id: const Uuid().v4(),
      health: 120,
      offsetX: size.x + blockSize.x,
      offsetY: 0,
    );

    add(pest);

    timer = Timer(
      1,
      onTick: () {
      },
      repeat: true,
    );

    _buildNet();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    timer?.update(dt);
    super.update(dt);
  }

  void _buildNet() {
    for (var y = 0; y < numLinesY; y++) {
      for (var x = 0; x < numLinesX; x++) {
        final offsetY = y * blockSize.y;
        final offsetX = x * blockSize.x;

        final field = Square(
          offsetX: offsetX,
          offsetY: offsetY,
        );

        add(field);
      }
    }
  }
}
