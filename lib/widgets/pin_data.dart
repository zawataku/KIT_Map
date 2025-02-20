class PinData {
  num x, y;
  final String message;
  PinData(this.x, this.y, this.message);

  factory PinData.fromJson(Map<String, dynamic> json) {
    return PinData(json['x'], json['y'], json['name']);
  }
}
