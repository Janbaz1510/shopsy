import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopsy/core/utils/bg_colors_utils.dart';
import 'package:shopsy/features/product/presentation/widgets/common_image_widget.dart';
import 'package:shopsy/features/product/presentation/widgets/common_text_widget.dart';
import '../state/product_provider.dart';
import 'product_detail_page.dart';
import 'cart_page.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<ProductProvider>(context, listen: false).fetchProducts();
      });
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: CommonTextWidget(title: "Shopsy", color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => CartPage()));
            },
          ),
        ],
      ),
      body: productProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: productProvider.products.length,
              itemBuilder: (context, index) {
                final product = productProvider.products[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailPage(product: product)));
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80,
                          height: 100,
                          decoration: BoxDecoration(color: getBackgroundColor(product.image), borderRadius: BorderRadius.circular(12)),
                          padding: EdgeInsets.all(6),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CommonImageWidget(imageURL: product.image),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              CommonTextWidget(title: product.title, fontSize: 14, fontWeight: FontWeight.w500),
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: CommonTextWidget(title: "\u20B9 ${product.price}", fontSize: 14, fontWeight: FontWeight.bold),
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
    );
  }
}
