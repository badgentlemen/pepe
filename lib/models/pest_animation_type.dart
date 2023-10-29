enum PestAnimationType {
  idle,
}

extension PestAnimationTypeExt on PestAnimationType {
  int get amount {
    switch (this) {
      case PestAnimationType.idle:
        return 8;
      default:
        return 1;
    }
  }
}