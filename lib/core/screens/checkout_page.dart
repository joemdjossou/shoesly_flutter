import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shoesly_flutter/core/providers/cart_provider.dart';
import 'package:shoesly_flutter/core/screens/discover_page.dart';
import 'package:shoesly_flutter/utils/values.dart';
import 'package:shoesly_flutter/utils/values/app_sizes.dart';
import 'package:shoesly_flutter/widgets/black_button_widget.dart';

class CheckoutPage extends StatelessWidget {
  final List<Map<String, dynamic>>? orderDetails;

  const CheckoutPage({super.key, this.orderDetails});

  static const String id = '/checkout_page';

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final grandTotal = cartProvider.calculateTotalPrice();

    Future<void> placeOrder(BuildContext context) async {
      final firestore = FirebaseFirestore.instance;

      final orderData = {
        'paymentMethod': 'Credit Card',
        'location': 'Semarang, Indonesia',
        'orderDetail': orderDetails,
        'subTotal': grandTotal,
        'shippingCost': 20.0,
        'totalOrder': grandTotal + 20.0,
      };

      try {
        await firestore.collection('orders').add(orderData);
        cartProvider.clearCart();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Payment details added successfully',
              style: Constants.subHeadingStyle.copyWith(
                color: AppColors.primaryBackgroundColor,
                fontWeight: FontWeight.w300,
                fontSize: Sizes.fontSize20,
              ),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacementNamed(context, DiscoverPage.id);
      } catch (error) {
        Exception('Error placing order: $error');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Order Summary",
          style: TextStyle(
            color: Colors.black,
            fontSize: Sizes.fontSize20,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: Sizes.xl,
                ),
                const Text(
                  "Information",
                  style: TextStyle(
                    fontSize: Sizes.fontSize20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: Sizes.md,
                ),
                const Text(
                  "Payment Method",
                  style: TextStyle(
                    fontSize: Sizes.fontSize14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: Sizes.xs,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Credit Cart",
                      style: TextStyle(
                        fontSize: Sizes.fontSize14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                    )
                  ],
                ),
                const SizedBox(
                  height: Sizes.md,
                ),
                const Divider(
                  height: 4,
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: Sizes.md,
                ),
                const Text(
                  "Location",
                  style: TextStyle(
                    fontSize: Sizes.fontSize14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: Sizes.xs,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Semarang, Indonesia",
                      style: TextStyle(
                        fontSize: Sizes.fontSize14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                    )
                  ],
                ),
                const SizedBox(
                  height: Sizes.xl,
                ),
                const Text(
                  "Order Detail",
                  style: TextStyle(
                    fontSize: Sizes.fontSize20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: Sizes.xl,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: orderDetails!.length,
                  itemBuilder: (context, index) {
                    final detail = orderDetails![index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              detail['name'],
                              style: const TextStyle(
                                fontSize: Sizes.fontSize16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: Sizes.md,
                            ),
                            Text(
                              "${detail['brand']} . ${detail['color']} . ${detail['size']} . Qty ${detail['quantity']}",
                              style: Constants.textStyle,
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "\$${detail['price']}",
                              style: const TextStyle(
                                fontSize: Sizes.fontSize14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                ),
                const SizedBox(
                  height: Sizes.xl,
                ),
                const Text(
                  "Payment Detail",
                  style: TextStyle(
                    fontSize: Sizes.fontSize20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: Sizes.xl,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Sub Total",
                      style: TextStyle(
                        fontSize: Sizes.fontSize14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "\$$grandTotal",
                      style: const TextStyle(
                        fontSize: Sizes.fontSize16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: Sizes.md,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Shipping",
                      style: TextStyle(
                        fontSize: Sizes.fontSize14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "\$20.0",
                      style: TextStyle(
                        fontSize: Sizes.fontSize16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: Sizes.md,
                ),
                const Divider(
                  height: 4,
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: Sizes.md,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Order",
                      style: TextStyle(
                        fontSize: Sizes.fontSize14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "\$${grandTotal + 20}",
                      style: const TextStyle(
                        fontSize: Sizes.fontSize16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
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
                        placeOrder(context);
                      },
                      child: blackButton("PAYMENT"),
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
