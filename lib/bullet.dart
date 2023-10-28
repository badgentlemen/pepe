import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Bullet extends RectangleComponent with CollisionCallbacks {
  Bullet({
    required double offsetX,
    required double offsetY,
    required double width,
    required double height,
    required this.damage,
  }) : super(
          position: Vector2(offsetX, offsetY),
          size: Vector2(
            width,
            height,
          ),
        );

  ///
  final int damage;
}
