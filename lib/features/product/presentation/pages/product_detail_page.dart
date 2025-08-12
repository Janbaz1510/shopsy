import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopsy/features/product/presentation/pages/cart_page.dart';
import 'package:shopsy/core/utils/common_text_widget.dart';
import '../../domain/entities/product.dart';
import '../state/cart_provider.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CommonTextWidget(title: product.title, color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product.image, height: 200),
            SizedBox(height: 16),
            CommonTextWidget(title: "Price: \u20B9${product.price.toStringAsFixed(2)}"),
            SizedBox(height: 16),
            CommonTextWidget(title: product.description),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final cartProvider = Provider.of<CartProvider>(context, listen: false);
                  cartProvider.addProduct(product);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => CartPage()));
                },
                child: CommonTextWidget(title: "Add to Cart"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
