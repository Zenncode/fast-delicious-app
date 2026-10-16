import 'package:flutter/material.dart';

import '../app_state.dart';
import '../painters.dart';
import '../theme.dart';
import '../widgets.dart';

// Live courier tracking screen with the custom-painted dark map.

class DeliveryTrackingScreen extends StatefulWidget {
  final AppState appState;

  const DeliveryTrackingScreen({super.key, required this.appState});

  @override
  State<DeliveryTrackingScreen> createState() => _DeliveryTrackingScreenState();
}

class _DeliveryTrackingScreenState extends State<DeliveryTrackingScreen> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    // Single courier for the whole delivery; only the card layout toggles.
    const courierName = 'Robert Odell';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Custom Dark Vector Map with Route Line & Markers
          Positioned.fill(
            child: CustomPaint(
              painter: DarkDeliveryMapPainter(),
            ),
          ),

          // Top Floating Map Controls (< Back and GPS Target)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleIconButton(
                    icon: Icons.chevron_left_rounded,
                    onTap: () => Navigator.of(context).pop(),
                    semanticLabel: 'Go back',
                  ),
                  CircleIconButton(
                    icon: Icons.gps_fixed_rounded,
                    onTap: () {
                      setState(() => isExpanded = !isExpanded);
                    },
                    semanticLabel: 'Toggle delivery details',
                  ),
                ],
              ),
            ),
          ),

          // Bottom Delivery & Courier Card (Tap handle to toggle Expanded/Collapsed view)
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: GestureDetector(
                  onTap: () => setState(() => isExpanded = !isExpanded),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOutCubic,
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha: 0.96),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        // Drag Handle
                        Container(
                          width: 38,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.textSecondary.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        if (isExpanded) ...[
                          // Expanded Delivery Time & Address Timeline
                          Padding(
                            padding: const EdgeInsets.fromLTRB(22, 18, 22, 20),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.schedule_rounded,
                                      color: AppColors.textSecondary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 14),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          'Delivery Time',
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 11.5,
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          '26 minutes',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                // Vertical Dotted Connector
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 9,
                                      top: 4,
                                      bottom: 4,
                                    ),
                                    child: Column(
                                      children: List.generate(
                                        5,
                                        (i) => Container(
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 2,
                                          ),
                                          width: 3,
                                          height: 3,
                                          decoration: const BoxDecoration(
                                            color: AppColors.textSecondary,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.location_on_rounded,
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Your Address',
                                            style: TextStyle(
                                              color: AppColors.textSecondary,
                                              fontSize: 11.5,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            widget.appState.deliveryAddress,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          // Collapsed Horizontal Dotted Timeline (Bottom-Left of image_4c8260.jpg)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.schedule_rounded,
                                  color: AppColors.textSecondary,
                                  size: 18,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: List.generate(
                                      14,
                                      (index) => Container(
                                        width: 3,
                                        height: 3,
                                        decoration: BoxDecoration(
                                          color: index < 8
                                              ? AppColors.primary
                                              : AppColors.textSecondary,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.location_on_rounded,
                                  color: AppColors.primary,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ],

                        // White Courier Card (Robert Odell)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            children: [
                              // Courier Avatar
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFD9E2EC),
                                  border: Border.all(
                                    color: Colors.black12,
                                    width: 1,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Color(0xFF334E68),
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      courierName,
                                      style: const TextStyle(
                                        color: AppColors.background,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const Text(
                                      'Food Courier',
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 11.5,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: List.generate(
                                        5,
                                        (_) => const Padding(
                                          padding: EdgeInsets.only(right: 2),
                                          child: Icon(
                                            Icons.star_rounded,
                                            color: AppColors.primary,
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Green Phone Call Button
                              GestureDetector(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: AppColors.surfaceLight,
                                      behavior: SnackBarBehavior.floating,
                                      content: Text(
                                        'Calling $courierName (Food Courier)...',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: AppColors.greenCall,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            AppColors.greenCall.withValues(alpha: 0.4),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.phone_in_talk_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
