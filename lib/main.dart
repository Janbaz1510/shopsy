import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopsy/features/product/data/datasources/product_local_data_source.dart';
import 'package:shopsy/features/product/data/repositories/product_repository_impl.dart';
import 'package:shopsy/features/product/domain/usecases/get_products.dart';
import 'package:shopsy/features/product/presentation/pages/product_list_page.dart';
import 'package:shopsy/features/product/presentation/state/cart_provider.dart';
import 'package:shopsy/features/product/presentation/state/product_provider.dart';


void main() {
  final localDataSource = ProductLocalDataSourceImpl();
  final repository = ProductRepositoryImpl(localDataSource);
  final getProducts = GetProducts(repository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider(getProducts)),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ProductListPage(),
      ),
    ),
  );
}
