import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'models.dart';
import 'theme.dart';

// Central application state (catalog, cart, orders, filters, session).

class AppState extends ChangeNotifier {
  // Order ids are display-only; demo orders start at this number.
  static const int _orderIdBase = 1042;

  bool isAuthenticated = true;
  int bottomNavIndex = 0; // 0: Home, 1: Favorites, 2: Notifications, 3: Cart
  bool isDrawerOpen = false;

  // User Profile Data (Matching Emre Huzeyfe Bastas screen)
  String fullName = 'Emre Huzeyfe Baştaş';
  String phoneNumber = '+90 410 245 22 15';
  String email = 'huzeyfebastas@gmail.com';
  String paymentSummary = 'Credit Card, Apple Pay';
  String deliveryAddress = '3720 Filbert Dr, Danielsville, PA';

  // Filter & Search State
  static const double priceFilterMin = 8.0;
  static const double priceFilterMax = 50.0;

  String selectedCategory = 'Sushi';
  String searchQuery = '';
  double maxPriceFilter = priceFilterMax;
  bool sortByRating = false;

  // Payment State
  String selectedPaymentMethod = 'Credit Card';
  String couponCode = demoCouponCode;
  double taxation = 15.00;
  bool couponApplied = true;

  // The only coupon accepted at checkout: $2.00 off any order.
  static const String demoCouponCode = 'FastDelicious/3572';
  static const double demoCouponValue = 2.0;

  // Favorites Set
  final Set<String> favoriteIds = {'sushi_1'};

  // Catalog Data
  final List<String> categories = const [
    'Pizza',
    'Burger',
    'Sushi',
    'Kebab',
    'Soup',
  ];

  final List<FoodItem> catalog = const [
    FoodItem(
      id: 'sushi_1',
      name: 'Sake Roll',
      subtitle: 'Kinoa, kani, avocado',
      category: 'Sushi',
      price: 14.50,
      calories: 130,
      prepTime: '15-20 min',
      rating: 4.9,
      weightGrams: 350,
      description:
          'Sake is produced by a leavening process and converting starch into sugar. It may sound simple, but the entire process can take a few months.',
      visualType: FoodVisualType.sakeRoll,
    ),
    FoodItem(
      id: 'sushi_2',
      name: 'Maguro',
      subtitle: 'Finest fatty tuna, tobiko',
      category: 'Sushi',
      price: 12.75,
      calories: 145,
      prepTime: '15-20 min',
      rating: 4.8,
      weightGrams: 320,
      description:
          'Hand-pressed sushi rice topped with velvety cuts of bluefin maguro tuna and delicate red tobiko roe.',
      visualType: FoodVisualType.maguro,
    ),
    FoodItem(
      id: 'sushi_3',
      name: 'Dragon Maki',
      subtitle: 'Unagi, cucumber, avocado',
      category: 'Sushi',
      price: 16.20,
      calories: 210,
      prepTime: '20-25 min',
      rating: 4.9,
      weightGrams: 380,
      description:
          'Roasted freshwater eel glazed in sweet tare sauce wrapped with crisp cucumber and creamy avocado slices.',
      visualType: FoodVisualType.dragonRoll,
    ),
    FoodItem(
      id: 'soup_1',
      name: 'Plain Soup',
      subtitle: 'Wood-fired soup',
      category: 'Soup',
      price: 8.25,
      calories: 95,
      prepTime: '10-15 min',
      rating: 4.7,
      weightGrams: 280,
      description:
          'Slow-simmered dashi and miso broth infused with wood-fired aromatics, wakame seaweed, and scallions.',
      visualType: FoodVisualType.plainSoup,
    ),
    FoodItem(
      id: 'pizza_1',
      name: 'Truffle Pepperoni',
      subtitle: 'Mozzarella, black truffle',
      category: 'Pizza',
      price: 18.50,
      calories: 340,
      prepTime: '20-25 min',
      rating: 4.9,
      weightGrams: 450,
      description:
          'Artisan wood-fired sourdough crust layered with San Marzano tomatoes, aged mozzarella, and crispy pepperoni.',
      visualType: FoodVisualType.pizza,
    ),
    FoodItem(
      id: 'burger_1',
      name: 'Wagyu Smash',
      subtitle: 'Aged cheddar, brioche',
      category: 'Burger',
      price: 15.90,
      calories: 420,
      prepTime: '15-20 min',
      rating: 4.8,
      weightGrams: 390,
      description:
          'Double smashed Wagyu beef patties seared with caramelized onions, melted sharp cheddar, and house truffle aioli.',
      visualType: FoodVisualType.burger,
    ),
    FoodItem(
      id: 'kebab_1',
      name: 'Adana Skewers',
      subtitle: 'Charcoal lamb, sumac',
      category: 'Kebab',
      price: 17.00,
      calories: 310,
      prepTime: '20-25 min',
      rating: 4.9,
      weightGrams: 410,
      description:
          'Hand-minced lamb seasoned with red pepper flakes grilled over glowing oak charcoal, served with warm flatbread.',
      visualType: FoodVisualType.kebab,
    ),
  ];

  // Initial Cart matching My Cart screenshot ($14.50 + $8.25 + $12.75 = $35.50 / $33.50 with promo)
  late final List<CartItem> cartItems = [
    CartItem(item: catalog[0], quantity: 1), // Sake Roll $14.50
    CartItem(item: catalog[3], quantity: 1), // Plain Soup $8.25
    CartItem(item: catalog[1], quantity: 1), // Maguro $12.75
  ];

  // Initial Notifications matching Notifications screenshot (also the reset seed)
  static const List<PointNotification> _initialNotifications = [
    PointNotification(
      points: 30,
      title: 'You earned 30 points!',
      timeAgo: '2 days ago',
      badgeColor: AppColors.badgeBlue,
    ),
    PointNotification(
      points: 50,
      title: 'You earned 50 points!',
      timeAgo: '4 days ago',
      badgeColor: AppColors.badgeGreen,
    ),
    PointNotification(
      points: 20,
      title: 'You earned 20 points!',
      timeAgo: '1 week ago',
      badgeColor: AppColors.badgeAmber,
    ),
    PointNotification(
      points: 70,
      title: 'You earned 70 points!',
      timeAgo: '1 week ago',
      badgeColor: AppColors.badgeRed,
    ),
    PointNotification(
      points: 30,
      title: 'You earned 30 points!',
      timeAgo: '2 weeks ago',
      badgeColor: AppColors.badgeBlue,
    ),
    PointNotification(
      points: 20,
      title: 'You earned 20 points!',
      timeAgo: '2 weeks ago',
      badgeColor: AppColors.badgeAmber,
    ),
  ];

  final List<PointNotification> notifications =
      List<PointNotification>.from(_initialNotifications);

  final List<OrderRecord> orderHistory = [];

  List<FoodItem> get filteredCatalog {
    final list = catalog.where((food) {
      final matchesCategory = food.category == selectedCategory;
      final matchesSearch = searchQuery.isEmpty ||
          food.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          food.subtitle.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesPrice = food.price <= maxPriceFilter;
      return matchesCategory && matchesSearch && matchesPrice;
    }).toList();

    if (sortByRating) {
      list.sort((a, b) => b.rating.compareTo(a.rating));
    }
    return list;
  }

  List<FoodItem> get favoriteItems =>
      catalog.where((item) => favoriteIds.contains(item.id)).toList();

  double get rawCartSubtotal =>
      cartItems.fold(0.0, (sum, entry) => sum + entry.totalPrice);

  // Goods total after the coupon discount, before taxation.
  // Matches the exact $33,50 display when the default 3 items + coupon are active.
  double get cartTotal {
    if (cartItems.isEmpty) return 0.0;
    return math.max(0.0, rawCartSubtotal - couponDiscount);
  }

  // Discount granted by the demo coupon (0 unless the exact code is applied).
  double get couponDiscount => couponApplied ? demoCouponValue : 0.0;

  // Amount actually charged at checkout: goods total + taxation.
  double get grandTotal => cartItems.isEmpty ? 0.0 : cartTotal + taxation;

  int get totalCartCount =>
      cartItems.fold(0, (sum, entry) => sum + entry.quantity);

  void setBottomNav(int index) {
    bottomNavIndex = index;
    isDrawerOpen = false;
    notifyListeners();
  }

  void toggleDrawer() {
    isDrawerOpen = !isDrawerOpen;
    notifyListeners();
  }

  void closeDrawer() {
    if (isDrawerOpen) {
      isDrawerOpen = false;
      notifyListeners();
    }
  }

  void selectCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }

  void updateFilters({required double maxPrice, required bool sortRating}) {
    maxPriceFilter = maxPrice;
    sortByRating = sortRating;
    notifyListeners();
  }

  bool isFavorite(String id) => favoriteIds.contains(id);

  void toggleFavorite(String id) {
    if (favoriteIds.contains(id)) {
      favoriteIds.remove(id);
    } else {
      favoriteIds.add(id);
    }
    notifyListeners();
  }

  void addToCart(FoodItem item, {int quantity = 1}) {
    final existingIndex = cartItems.indexWhere((c) => c.item.id == item.id);
    if (existingIndex >= 0) {
      cartItems[existingIndex].quantity += quantity;
    } else {
      cartItems.add(CartItem(item: item, quantity: quantity));
    }
    notifyListeners();
  }

  void updateCartQuantity(String itemId, int delta) {
    final idx = cartItems.indexWhere((c) => c.item.id == itemId);
    if (idx >= 0) {
      cartItems[idx].quantity += delta;
      if (cartItems[idx].quantity <= 0) {
        cartItems.removeAt(idx);
      }
      notifyListeners();
    }
  }

  void removeFromCart(String itemId) {
    cartItems.removeWhere((c) => c.item.id == itemId);
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    selectedPaymentMethod = method;
    notifyListeners();
  }

  /// Applies [code] and returns true when it matches the demo coupon.
  bool applyCoupon(String code) {
    couponCode = code.trim();
    couponApplied = couponCode.toLowerCase() == demoCouponCode.toLowerCase();
    notifyListeners();
    return couponApplied;
  }

  void placeOrder() {
    if (cartItems.isEmpty) return;
    orderHistory.insert(
      0,
      OrderRecord(
        id: '#FD-${_orderIdBase + orderHistory.length}',
        items: List<CartItem>.from(
          cartItems.map((e) => CartItem(item: e.item, quantity: e.quantity)),
        ),
        total: grandTotal,
        date: 'Just now',
        status: 'On the way (26 min)',
      ),
    );
    notifications.insert(
      0,
      const PointNotification(
        points: 50,
        title: 'You earned 50 points!',
        timeAgo: 'Just now',
        badgeColor: AppColors.badgeGreen,
      ),
    );
    // The order has been placed, so the cart must be emptied to avoid a
    // stale cart badge and accidental duplicate checkouts.
    cartItems.clear();
    notifyListeners();
  }

  void saveProfile({
    required String name,
    required String phone,
    required String mail,
    required String pay,
    required String addr,
  }) {
    fullName = name;
    phoneNumber = phone;
    email = mail;
    paymentSummary = pay;
    deliveryAddress = addr;
    notifyListeners();
  }

  void logout() {
    isDrawerOpen = false;
    isAuthenticated = false;
    _resetSession();
    notifyListeners();
  }

  // Restores the first-run demo state so the next user starts clean.
  void _resetSession() {
    cartItems
      ..clear()
      ..addAll([
        CartItem(item: catalog[0], quantity: 1), // Sake Roll $14.50
        CartItem(item: catalog[3], quantity: 1), // Plain Soup $8.25
        CartItem(item: catalog[1], quantity: 1), // Maguro $12.75
      ]);
    favoriteIds
      ..clear()
      ..add('sushi_1');
    orderHistory.clear();
    notifications
      ..clear()
      ..addAll(_initialNotifications);
    fullName = 'Emre Huzeyfe Baştaş';
    phoneNumber = '+90 410 245 22 15';
    email = 'huzeyfebastas@gmail.com';
    paymentSummary = 'Credit Card, Apple Pay';
    deliveryAddress = '3720 Filbert Dr, Danielsville, PA';
    selectedPaymentMethod = 'Credit Card';
    couponCode = demoCouponCode;
    couponApplied = true;
    selectedCategory = 'Sushi';
    searchQuery = '';
    maxPriceFilter = priceFilterMax;
    sortByRating = false;
    bottomNavIndex = 0;
  }

  void login(String userEmail) {
    if (userEmail.trim().isNotEmpty) {
      email = userEmail.trim();
    }
    isAuthenticated = true;
    bottomNavIndex = 0;
    notifyListeners();
  }
}
