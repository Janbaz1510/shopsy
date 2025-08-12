import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                return ListTile(
                  contentPadding: EdgeInsets.all(8),
                  leading: CommonImageWidget(imageURL: cartItem.product.image),
                  title: CommonTextWidget(title: cartItem.product.title, fontSize: 14, fontWeight: FontWeight.w500),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: CommonTextWidget(title: "Price: \u20B9${cartItem.product.price.toStringAsFixed(2)}", fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          cartProvider.decreaseQuantity(cartItem.product.id);
                        },
                      ),
                      CommonTextWidget(title: "${cartItem.quantity}"),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          cartProvider.addProduct(cartItem.product);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24),
            child: CommonTextWidget(title: "Total: \u20B9${cartProvider.totalPrice.toStringAsFixed(2)}", fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
