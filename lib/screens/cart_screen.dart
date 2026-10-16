import 'package:flutter/material.dart';

import '../app_state.dart';
import '../models.dart';
import '../painters.dart';
import '../theme.dart';
import '../widgets.dart';
import 'payment_screen.dart';

// Cart screen with quantity steppers and order total.

class CartScreen extends StatelessWidget {
  final AppState appState;
  final bool isEmbeddedTab;

  const CartScreen({
    super.key,
    required this.appState,
    this.isEmbeddedTab = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          child: Column(
            children: [
              // Top Bar
              Row(
                children: [
                  CircleIconButton(
                    icon: Icons.chevron_left_rounded,
                    onTap: () {
                      if (isEmbeddedTab) {
                        appState.setBottomNav(0);
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    semanticLabel: 'Go back',
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'My Cart',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
              const SizedBox(height: 24),

              // Cart Items Container
              Expanded(
                child: appState.cartItems.isEmpty
                    ? const Center(
                        child: Text(
                          'Your cart is empty.\nAdd delicious sushi or soup from the menu!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: ListView.separated(
                          itemCount: appState.cartItems.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 18),
                          itemBuilder: (context, index) {
                            final cartItem = appState.cartItems[index];
                            return _CartItemTile(
                              cartItem: cartItem,
                              onRemove: () =>
                                  appState.removeFromCart(cartItem.item.id),
                              onIncrement: () => appState.updateCartQuantity(
                                cartItem.item.id,
                                1,
                              ),
                              onDecrement: () => appState.updateCartQuantity(
                                cartItem.item.id,
                                -1,
                              ),
                            );
                          },
                        ),
                      ),
              ),
              const SizedBox(height: 20),

              // Bottom Total Price ($33,50) & Next Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Price',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatPrice(appState.cartTotal),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 155,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 6,
                        shadowColor: AppColors.primary.withValues(alpha: 0.45),
                      ),
                      onPressed: appState.cartItems.isEmpty
                          ? null
                          : () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      PaymentScreen(appState: appState),
                                ),
                              );
                            },
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback onRemove;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _CartItemTile({
    required this.cartItem,
    required this.onRemove,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Thumbnail Box
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: FoodIllustrationWidget(
              type: cartItem.item.visualType,
              size: 46,
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Item Name, Subtitle, Price + Quantity Stepper
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cartItem.item.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          cartItem.item.subtitle,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Remove "x" circle button
                  GestureDetector(
                    onTap: onRemove,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: AppColors.surfaceLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Price + visible quantity controls (- qty +)
              Row(
                children: [
                  Text(
                    formatPrice(cartItem.totalPrice),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  _QuantityStepper(
                    quantity: cartItem.quantity,
                    onIncrement: onIncrement,
                    onDecrement: onDecrement,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _QuantityStepper({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperIconButton(
            icon: Icons.remove_rounded,
            onTap: onDecrement,
            semanticLabel: 'Decrease quantity',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '$quantity',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _StepperIconButton(
            icon: Icons.add_rounded,
            onTap: onIncrement,
            semanticLabel: 'Increase quantity',
          ),
        ],
      ),
    );
  }
}

class _StepperIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String semanticLabel;

  const _StepperIconButton({
    required this.icon,
    required this.onTap,
    required this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: AppColors.surfaceLight,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
      ),
    );
  }
}
