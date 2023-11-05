import 'package:pepe/components/pest.dart';

class ScriptedPest {
  ScriptedPest({
    required this.pest,
    required this.delayDuration,
    required this.row,
  });

  /// delay после которого вредитель вступает в игру
  final Duration delayDuration;

  /// Строка поля по которому пойдет вредитель
  final int row;

  /// Вредитель
  final Pest pest;

  int get delayDurationSec => delayDuration.inSeconds;
}