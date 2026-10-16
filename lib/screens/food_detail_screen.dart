import 'package:flutter/material.dart';

import '../app_state.dart';
import '../models.dart';
import '../painters.dart';
import '../theme.dart';
import '../widgets.dart';
import 'cart_screen.dart';

// Dish detail screen with quantity selector and nutrition specs.

class FoodDetailScreen extends StatefulWidget {
  final AppState appState;
  final FoodItem food;

  const FoodDetailScreen({
    super.key,
    required this.appState,
    required this.food,
  });

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final isFav = widget.appState.isFavorite(widget.food.id);
    final totalPrice = widget.food.price * quantity;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Navigation Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleIconButton(
                    icon: Icons.chevron_left_rounded,
                    onTap: () => Navigator.of(context).pop(),
                    semanticLabel: 'Go back',
                  ),
                  CircleIconButton(
                    icon: isFav ? Icons.favorite : Icons.favorite_border,
                    iconColor: isFav ? AppColors.primary : Colors.white,
                    onTap: () {
                      setState(() {
                        widget.appState.toggleFavorite(widget.food.id);
                      });
                    },
                    semanticLabel:
                        isFav ? 'Remove from favorites' : 'Add to favorites',
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Centered Food Title
              Center(
                child: Text(
                  widget.food.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Large Center Food Illustration
              Expanded(
                child: Center(
                  child: Hero(
                    tag: 'food_${widget.food.id}',
                    child: FoodIllustrationWidget(
                      type: widget.food.visualType,
                      size: 190,
                    ),
                  ),
                ),
              ),

              // Quantity Pill (- 1 +)
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (quantity > 1) {
                            setState(() => quantity--);
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '—',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          '$quantity',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => quantity++),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '+',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 26),

              // 4 Nutrition & Prep Badges (130 cal, 15-20 min, 4.9 vote, 350g)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _SpecMetricBadge(
                          icon: Icons.local_fire_department_rounded,
                          label: '${widget.food.calories} cal',
                        ),
                        _SpecMetricBadge(
                          icon: Icons.schedule_rounded,
                          label: widget.food.prepTime,
                        ),
                        _SpecMetricBadge(
                          icon: Icons.star_rounded,
                          label: '${widget.food.rating} vote',
                        ),
                        _SpecMetricBadge(
                          icon: Icons.scale_rounded,
                          label: '${widget.food.weightGrams}g',
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'Description',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.food.description,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Bottom Price & Add to Cart Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatPrice(totalPrice),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    width: 175,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 6,
                        shadowColor: AppColors.primary.withValues(alpha: 0.5),
                      ),
                      onPressed: () {
                        widget.appState.addToCart(
                          widget.food,
                          quantity: quantity,
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CartScreen(
                              appState: widget.appState,
                              isEmbeddedTab: false,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpecMetricBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SpecMetricBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
