import 'dart:async';

import 'package:flame/components.dart';

class Label extends RectangleComponent {
  Label({
    required super.position,
    required super.size,
    required this.value,
  });

  final int value;

  @override
  FutureOr<void> onLoad() {
    add(
      TextBoxComponent(
        text: value.toString(),
        align: Anchor.center,
        size: size,
        position: Vector2(0, 0),
      ),
    );

    return super.onLoad();
  }
}
