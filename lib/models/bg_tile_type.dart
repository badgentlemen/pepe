enum BackgroundTileType {
  blue,
  brown,
  gray,
  green,
  pink,
  purple,
  yellow,
}

extension BackgroundTileTypeExt on BackgroundTileType {
  String get title {
    switch (this) {
      case BackgroundTileType.blue:
        return 'Blue';
      case BackgroundTileType.brown:
        return 'Brown';
      case BackgroundTileType.gray:
        return 'Gray';
      case BackgroundTileType.green:
        return 'Green';
      case BackgroundTileType.pink:
        return 'Pink';
      case BackgroundTileType.purple:
        return 'Purple';
      case BackgroundTileType.yellow:
        return 'Yellow';
    }
  }
}
