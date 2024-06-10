class CartItem {
  final String name;
  final double price;
  final String color;
  final double shoeSize;
  int quantity;
  final String imageUrl;
  final String brand;

  CartItem({
    required this.name,
    required this.price,
    required this.color,
    required this.shoeSize,
    required this.quantity,
    required this.imageUrl,
    required this.brand,
  });
}
