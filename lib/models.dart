import 'package:flutter/material.dart';

// Domain models and price formatting shared across the app.

enum FoodVisualType { sakeRoll, maguro, plainSoup, dragonRoll, pizza, burger, kebab }

class FoodItem {
  final String id;
  final String name;
  final String subtitle;
  final String category;
  final double price;
  final int calories;
  final String prepTime;
  final double rating;
  final int weightGrams;
  final String description;
  final FoodVisualType visualType;

  const FoodItem({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.category,
    required this.price,
    required this.calories,
    required this.prepTime,
    required this.rating,
    required this.weightGrams,
    required this.description,
    required this.visualType,
  });
}

class CartItem {
  final FoodItem item;
  int quantity;

  CartItem({required this.item, this.quantity = 1});

  double get totalPrice => item.price * quantity;
}

class PointNotification {
  final int points;
  final String title;
  final String timeAgo;
  final Color badgeColor;

  const PointNotification({
    required this.points,
    required this.title,
    required this.timeAgo,
    required this.badgeColor,
  });
}

class OrderRecord {
  final String id;
  final List<CartItem> items;
  final double total;
  final String date;
  final String status;

  const OrderRecord({
    required this.id,
    required this.items,
    required this.total,
    required this.date,
    required this.status,
  });
}

// Formats price with comma decimal like "$14,50" in the UI design
String formatPrice(double value) {
  final parts = value.toStringAsFixed(2).split('.');
  return '\$${parts[0]},${parts[1]}';
}
