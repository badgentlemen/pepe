enum PestAnimationType {
  idle,
  hit,
  run,
}

extension PestAnimationTypeExt on PestAnimationType {
  int get amount {
    switch (this) {
      case PestAnimationType.idle:
        return 8;
      case PestAnimationType.hit:
        return 5;
      case PestAnimationType.run:
        return 12;
      default:
        return 1;
    }
  }
}