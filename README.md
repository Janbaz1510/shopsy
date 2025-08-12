# 🛍️ Shopsy - Product Listing & Cart App

A simple yet scalable Flutter-based mobile store prototype implementing **Clean Architecture** principles.  
Browse products, view details, add them to your cart, update quantities, and remove items — all from local mock data.

---

## 📱 Download APK
*(Upload your APK and replace link below)*  
<a href="https://drive.google.com/file/d/your-apk-link/view?usp=sharing" target="_blank"><strong>Download Shopsy APK</strong></a>

---

## 🌟 Features

### 🛒 Core Functionality
- 📦 **Product List**: Load products from local JSON
- 🔍 **Product Details**: View price, image, and description
- ➕ **Add to Cart**: Add products with quantity update
- 🗑️ **Remove from Cart**: Delete single or multiple items
- 💰 **Cart Total**: Auto-calculated total price
- 💾 **Optional Local Storage**: Save cart between sessions

### 🎯 User Experience
- ⚡ **Fast Navigation**: No API calls — local mock data
- 🎨 **Responsive UI**: Looks great on all devices
- 🖼️ **Placeholder Images**: From `picsum.photos`
- 📂 **Clean Architecture**: Easy to maintain and extend

---

## 🏗️ Architecture

The project follows **Clean Architecture** principles:

lib/
├── core/ # Constants, helpers, widgets
├── data/ # Data layer
│ ├── datasources/ # Local JSON reading
│ ├── models/ # Product & Cart models
│ └── repositories/ # Data implementations
├── domain/ # Business logic
│ ├── entities/ # Core entities
│ ├── repositories/ # Abstract contracts
│ └── usecases/ # Add/remove/get cart, fetch products
└── presentation/ # UI Layer
├── providers/ # State management with Provider
├── screens/ # Product list, details, cart
└── widgets/ # Shared UI components



git clone https://github.com/username/shopsy.git
cd shopsy
flutter pub get
flutter run


---

## 📸 Screenshots

| Product List Screen | Product Details Screen | Cart Screen |
|---------------------|------------------------|-------------|
| ![Product List](screenshots/product_list_screen.jpg) | ![Product Details](screenshots/product_details_screen.jpg) | ![Cart](screenshots/cart_screen.jpg) |


---
