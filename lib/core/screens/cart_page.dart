import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shoesly_flutter/core/providers/cart_provider.dart';
import 'package:shoesly_flutter/core/screens/checkout_page.dart';
import 'package:shoesly_flutter/utils/values.dart';
import 'package:shoesly_flutter/utils/values/app_sizes.dart';
import 'package:shoesly_flutter/widgets/black_button_widget.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});
  static const String id = '/cart_page';

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items;
    final grandTotal = cartProvider.calculateTotalPrice();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cart",
          style: TextStyle(
            color: Colors.black,
            fontSize: Sizes.fontSize16,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset("assets/icons/arrow-left.svg"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.xl),
        child: Stack(
          children: [
            ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Dismissible(
                  key: Key(item.name),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    cartProvider.deleteItem(item);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.md),
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Image.network(
                                item.imageUrl,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: Sizes.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontSize: Sizes.fontSize16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: Sizes.xs),
                              Row(
                                children: [
                                  Text(
                                    item.brand,
                                    style: const TextStyle(
                                      fontSize: Sizes.fontSize14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(width: Sizes.sm),
                                  Text(
                                    "${item.color} .",
                                    style: const TextStyle(
                                      fontSize: Sizes.fontSize14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(width: Sizes.sm),
                                  Text(
                                    item.shoeSize.toString(),
                                    style: const TextStyle(
                                      fontSize: Sizes.fontSize14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: Sizes.sm),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$${item.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: Sizes.fontSize16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border:
                                              Border.all(color: Colors.grey),
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            cartProvider.updateQuantity(
                                                item, item.quantity - 1);
                                          },
                                          icon: const Icon(Icons.remove),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: Sizes.sm,
                                      ),
                                      Text(
                                        item.quantity.toString(),
                                        style: const TextStyle(
                                          fontSize: Sizes.fontSize16,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: Sizes.sm,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border:
                                              Border.all(color: Colors.black),
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            cartProvider.updateQuantity(
                                                item, item.quantity + 1);
                                          },
                                          icon: const Icon(Icons.add),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(Sizes.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Grand Total",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.shadeGreyAccentColor300,
                          ),
                        ),
                        const SizedBox(
                          height: Sizes.xs,
                        ),
                        Text(
                          '\$$grandTotal',
                          style: const TextStyle(
                            fontSize: Sizes.fontSize16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        List<Map<String, dynamic>> orderDetails = [];
                        for (var item in cartItems) {
                          orderDetails.add({
                            'name': item.name,
                            'brand': item.brand,
                            'color': item.color,
                            'size': item.shoeSize,
                            'quantity': item.quantity,
                            'price': item.price,
                          });
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CheckoutPage(orderDetails: orderDetails),
                          ),
                        );
                      },
                      child: blackButton("CHECKOUT"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
