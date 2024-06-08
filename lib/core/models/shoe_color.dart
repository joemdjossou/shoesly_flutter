class ShoeColor {
  final String hexCode;
  final String name;

  ShoeColor({
    required this.hexCode,
    required this.name,
  });

  factory ShoeColor.fromMap(Map<String, dynamic> map) {
    return ShoeColor(
      hexCode: map['hexCode'],
      name: map['name'],
    );
  }
}
