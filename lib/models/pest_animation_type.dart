enum PestAnimationType {
  idle,
  hit,
}

extension PestAnimationTypeExt on PestAnimationType {
  int get amount {
    switch (this) {
      case PestAnimationType.idle:
        return 8;
      case PestAnimationType.hit:
        return 5;
      default:
        return 1;
    }
  }
}