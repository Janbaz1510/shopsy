import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopsy/features/product/data/datasources/product_local_data_source.dart';
import 'package:shopsy/features/product/data/repositories/product_repository_impl.dart';
import 'package:shopsy/features/product/domain/usecases/get_products.dart';
import 'package:shopsy/features/product/presentation/pages/product_list_page.dart';
import 'package:shopsy/features/product/presentation/state/cart_provider.dart';
import 'package:shopsy/features/product/presentation/state/product_provider.dart';

/// Main entry point for the Shopsy Flutter e-commerce application
void main() {
  // Initialize data layer - loads products from local JSON file
  final localDataSource = ProductLocalDataSourceImpl();
  
  // Initialize repository layer - abstracts data access for the domain layer
  final repository = ProductRepositoryImpl(localDataSource);
  
  // Initialize domain layer - encapsulates business logic for fetching products
  final getProducts = GetProducts(repository);

  // Start the Flutter application with dependency injection and state management
  runApp(
    MultiProvider(
      providers: [
        // Product state management - provides product list to the widget tree
        ChangeNotifierProvider(create: (_) => ProductProvider(getProducts)),
        // Cart state management - provides cart functionality to the widget tree
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Remove debug banner for cleaner UI
        home: ProductListPage(), // Set the initial screen to product listing
      ),
    ),
  );
}
