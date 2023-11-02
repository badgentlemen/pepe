import 'package:flame/components.dart';

class SunBattery extends SpriteComponent {
  SunBattery({required this.frequency, required this.power,});

  /// Частота срабатывания
  final int frequency;

  /// Сила
  final int power;
}