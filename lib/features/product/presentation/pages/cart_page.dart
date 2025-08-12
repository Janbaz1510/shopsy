import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopsy/core/utils/bg_colors_utils.dart';
import 'package:shopsy/features/product/presentation/widgets/common_image_widget.dart';
import 'package:shopsy/features/product/presentation/widgets/common_text_widget.dart';
import '../state/cart_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: CommonTextWidget(title: "Your Cart", color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartProvider.items.length,
              itemBuilder: (context, index) {
                final cartItem = cartProvider.items[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 100,
                        decoration: BoxDecoration(color: getBackgroundColor(cartItem.product.image), borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.all(6),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CommonImageWidget(imageURL: cartItem.product.image),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonTextWidget(title: cartItem.product.title, textAlign: TextAlign.start, maxLine: 2, fontSize: 14, fontWeight: FontWeight.w500),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: CommonTextWidget(title: "Price: \u20B9${cartItem.product.price.toStringAsFixed(2)}", fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              cartProvider.decreaseQuantity(cartItem.product.id);
                            },
                          ),
                          Container(
                            color: Colors.grey.shade300,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0, right: 5, top: 2, bottom: 2),
                              child: CommonTextWidget(title: "${cartItem.quantity}"),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              cartProvider.addProduct(cartItem.product);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.blueGrey.shade200,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 50),
              child: CommonTextWidget(title: "Total: \u20B9${cartProvider.totalPrice.toStringAsFixed(2)}", textAlign: TextAlign.center, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
