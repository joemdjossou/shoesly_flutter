class Brand {
  final int itemCount;
  final String logoGreyUrl;
  final String logoUrl;
  final String name;

  Brand({
    required this.itemCount,
    required this.logoGreyUrl,
    required this.logoUrl,
    required this.name,
  });

  //serializing the json
  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      itemCount: json['itemCount'],
      logoGreyUrl: json['logoGreyUrl'],
      logoUrl: json['logoUrl'],
      name: json['name'],
    );
  }
}
