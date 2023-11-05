import 'package:pepe/components/pest.dart';

class ScriptedPest {
  ScriptedPest({
    required this.pest,
    required this.delayDuration,
  });

  /// delay после которого вредитель вступает в игру
  final Duration delayDuration;

  /// Вредитель
  final Pest pest;
}