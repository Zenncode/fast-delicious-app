import 'package:flutter/material.dart';

import '../app_state.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';
import 'delivery_tracking_screen.dart';

// Payment screen: method selection, coupon, taxation, checkout.

class PaymentScreen extends StatefulWidget {
  final AppState appState;

  const PaymentScreen({super.key, required this.appState});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late final TextEditingController _couponController;

  @override
  void initState() {
    super.initState();
    _couponController =
        TextEditingController(text: widget.appState.couponCode);
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.appState;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Row(
                children: [
                  CircleIconButton(
                    icon: Icons.chevron_left_rounded,
                    onTap: () => Navigator.of(context).pop(),
                    semanticLabel: 'Go back',
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Payment',
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
              const SizedBox(height: 26),

              // Payment Options (Credit Card, Paypal, Google Play)
              _PaymentOptionCard(
                label: 'Credit Card',
                isSelected: state.selectedPaymentMethod == 'Credit Card',
                leadingLogo: const MastercardLogo(),
                onTap: () => setState(() {
                  state.setPaymentMethod('Credit Card');
                }),
              ),
              const SizedBox(height: 14),
              _PaymentOptionCard(
                label: 'Paypal',
                isSelected: state.selectedPaymentMethod == 'Paypal',
                leadingLogo: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Color(0xFF0079C1),
                  size: 24,
                ),
                onTap: () => setState(() {
                  state.setPaymentMethod('Paypal');
                }),
              ),
              const SizedBox(height: 14),
              _PaymentOptionCard(
                label: 'Google Play',
                isSelected: state.selectedPaymentMethod == 'Google Play',
                leadingLogo: const GoogleGLogo(),
                onTap: () => setState(() {
                  state.setPaymentMethod('Google Play');
                }),
              ),
              const SizedBox(height: 28),

              // Add Coupon Section
              const Text(
                'Add Coupon',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _couponController.text.trim().isEmpty
                        ? Colors.transparent
                        : (state.couponApplied
                            ? AppColors.greenCall.withValues(alpha: 0.55)
                            : AppColors.primary.withValues(alpha: 0.55)),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Coupon Code',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 2),
                          TextField(
                            controller: _couponController,
                            onChanged: (val) {
                              setState(() => state.applyCoupon(val));
                            },
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Semantics(
                      button: true,
                      label: 'Apply coupon',
                      child: GestureDetector(
                        onTap: () {
                          final isValid =
                              state.applyCoupon(_couponController.text);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: AppColors.surfaceLight,
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                              content: Text(
                                isValid
                                    ? 'Coupon ${AppState.demoCouponCode} '
                                        'applied: ${formatPrice(AppState.demoCouponValue)} off!'
                                    : 'Invalid coupon code. '
                                        'Try ${AppState.demoCouponCode}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.redeem_rounded,
                            color: AppColors.textSecondary,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),

              // Subtotal Row (goods total after discount, before taxation)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Subtotal',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    formatPrice(state.cartTotal),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Taxation Row ($15.00)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Taxation',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    formatPrice(state.taxation),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const Spacer(),

              // Bottom Total Price (incl. taxation) & Order Now Button
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
                        formatPrice(state.grandTotal),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 165,
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
                      onPressed: state.cartItems.isEmpty
                          ? null
                          : () {
                              state.placeOrder();
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      DeliveryTrackingScreen(appState: state),
                                ),
                              );
                            },
                      child: const Text(
                        'Order Now',
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

class _PaymentOptionCard extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Widget leadingLogo;
  final VoidCallback onTap;

  const _PaymentOptionCard({
    required this.label,
    required this.isSelected,
    required this.leadingLogo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 62,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : AppColors.surface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            SizedBox(width: 32, child: Center(child: leadingLogo)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColors.background : Colors.white,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.35)
                      : AppColors.textSecondary.withValues(alpha: 0.4),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
