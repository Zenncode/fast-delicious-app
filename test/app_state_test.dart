import 'package:flutter_test/flutter_test.dart';

import 'package:fast_delicious_food_app/app_state.dart';

void main() {
  group('AppState cart math', () {
    test('starts with the demo cart matching the reference design', () {
      final state = AppState();
      expect(state.cartItems.length, 3);
      expect(state.rawCartSubtotal, closeTo(35.50, 0.001));
      expect(state.cartTotal, closeTo(33.50, 0.001)); // $2.00 coupon applied
      expect(state.grandTotal, closeTo(48.50, 0.001)); // + $15.00 taxation
    });

    test('coupon only applies with the exact demo code (case-insensitive)', () {
      final state = AppState();
      state.applyCoupon('WRONG-CODE');
      expect(state.couponDiscount, 0.0);
      expect(state.cartTotal, closeTo(35.50, 0.001));

      state.applyCoupon(AppState.demoCouponCode.toLowerCase());
      expect(state.couponDiscount, 2.0);
      expect(state.cartTotal, closeTo(33.50, 0.001));
    });

    test('addToCart merges quantities for the same dish', () {
      final state = AppState();
      final item = state.catalog.first; // sushi_1 is already in the demo cart
      state.addToCart(item, quantity: 2);
      final entry = state.cartItems.firstWhere((c) => c.item.id == item.id);
      expect(entry.quantity, 3);
    });

    test('updateCartQuantity removes the item when it reaches zero', () {
      final state = AppState();
      final id = state.cartItems.first.item.id;
      state.updateCartQuantity(id, -1);
      expect(state.cartItems.any((c) => c.item.id == id), isFalse);
    });
  });

  group('AppState checkout', () {
    test('placeOrder records the order and empties the cart', () {
      final state = AppState();
      state.placeOrder();
      expect(state.cartItems, isEmpty);
      expect(state.orderHistory, hasLength(1));
      expect(state.orderHistory.first.total, closeTo(48.50, 0.001));
      expect(state.notifications.first.timeAgo, 'Just now');
    });

    test('placeOrder does nothing when the cart is empty', () {
      final state = AppState();
      state.placeOrder();
      state.placeOrder();
      expect(state.orderHistory, hasLength(1));
    });
  });

  group('AppState filters and favorites', () {
    test('search narrows within the selected category', () {
      final state = AppState();
      state.setSearchQuery('wagyu');
      expect(state.filteredCatalog, isEmpty); // Wagyu is a Burger, Sushi selected
      state.selectCategory('Burger');
      expect(state.filteredCatalog, hasLength(1));
    });

    test('toggleFavorite adds and removes', () {
      final state = AppState();
      expect(state.isFavorite('sushi_2'), isFalse);
      state.toggleFavorite('sushi_2');
      expect(state.isFavorite('sushi_2'), isTrue);
      state.toggleFavorite('sushi_2');
      expect(state.isFavorite('sushi_2'), isFalse);
    });
  });

  group('AppState session reset', () {
    test('logout restores the first-run demo state', () {
      final state = AppState();
      state.addToCart(state.catalog[4]); // Truffle Pepperoni
      state.toggleFavorite('pizza_1');
      state.placeOrder();
      state.logout();

      expect(state.isAuthenticated, isFalse);
      expect(state.cartItems.length, 3);
      expect(state.rawCartSubtotal, closeTo(35.50, 0.001));
      expect(state.orderHistory, isEmpty);
      expect(state.favoriteIds, hasLength(1));
      expect(state.favoriteIds.contains('sushi_1'), isTrue);
      expect(state.bottomNavIndex, 0);
    });
  });
}
