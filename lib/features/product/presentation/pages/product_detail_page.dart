import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopsy/core/utils/bg_colors_utils.dart';
import 'package:shopsy/features/product/presentation/pages/cart_page.dart';
import 'package:shopsy/features/product/presentation/widgets/common_text_widget.dart';
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 400,
            width: double.infinity,
            decoration: BoxDecoration(color: getBackgroundColor(product.image)),
            child: Image.network(product.image),
          ),
          SizedBox(height: 16),
          CommonTextWidget(title: product.title, fontWeight: FontWeight.bold, fontSize: 22, padding: 16),
          CommonTextWidget(title: "\u20B9${product.price.toStringAsFixed(2)}", padding: 16, fontWeight: FontWeight.w500, fontSize: 16),
          SizedBox(height: 16),
          CommonTextWidget(title: product.description, maxLines: 10, fontSize: 16, padding: 16, fontWeight: FontWeight.w400),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey.shade200,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  final cartProvider = Provider.of<CartProvider>(context, listen: false);
                  cartProvider.addProduct(product);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => CartPage()));
                },
                child: CommonTextWidget(title: "Add to Cart", fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
