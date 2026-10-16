import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'models.dart';
import 'theme.dart';

// Custom vector artwork: food illustrations, map, and header painters.

// Custom Vector Food Illustrations (Sushi Sake Roll, Maguro, Soup, etc.)
class FoodIllustrationWidget extends StatelessWidget {
  final FoodVisualType type;
  final double size;

  const FoodIllustrationWidget({
    super.key,
    required this.type,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _FoodVectorPainter(type),
      ),
    );
  }
}

class _FoodVectorPainter extends CustomPainter {
  final FoodVisualType type;

  _FoodVectorPainter(this.type);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    switch (type) {
      case FoodVisualType.sakeRoll:
      case FoodVisualType.dragonRoll:
        // Draw two green maki rolls in back + salmon nigiri in front (Matches Sake Roll artwork)
        _drawMakiRoll(canvas, Offset(w * 0.42, h * 0.28), w * 0.20);
        _drawMakiRoll(canvas, Offset(w * 0.72, h * 0.36), w * 0.20);
        _drawSalmonNigiri(canvas, Offset(w * 0.45, h * 0.62), w * 0.56, h * 0.36);
        break;
      case FoodVisualType.maguro:
        // Draw two rich tuna nigiri pieces (Matches Maguro artwork)
        _drawTunaNigiri(canvas, Offset(w * 0.52, h * 0.36), w * 0.56, h * 0.28);
        _drawTunaNigiri(canvas, Offset(w * 0.46, h * 0.66), w * 0.58, h * 0.28);
        break;
      case FoodVisualType.plainSoup:
        // Draw warm soup bowl with spoon (Matches Plain Soup artwork)
        _drawSoupBowl(canvas, Offset(w * 0.5, h * 0.56), w * 0.68);
        break;
      case FoodVisualType.pizza:
        _drawPizzaSlice(canvas, Offset(w * 0.5, h * 0.52), w * 0.68);
        break;
      case FoodVisualType.burger:
        _drawBurger(canvas, Offset(w * 0.5, h * 0.52), w * 0.68);
        break;
      case FoodVisualType.kebab:
        _drawKebab(canvas, Offset(w * 0.5, h * 0.52), w * 0.68);
        break;
    }
  }

  void _drawMakiRoll(Canvas canvas, Offset center, double radius) {
    // Green cucumber/nori outer cylinder
    final basePaint = Paint()..color = const Color(0xFF4C8C4A);
    canvas.drawOval(
      Rect.fromCenter(
        center: center.translate(0, radius * 0.32),
        width: radius * 1.9,
        height: radius * 1.25,
      ),
      basePaint,
    );
    canvas.drawRect(
      Rect.fromCenter(
        center: center.translate(0, radius * 0.16),
        width: radius * 1.9,
        height: radius * 0.35,
      ),
      basePaint,
    );
    // White rice top oval
    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: radius * 1.85,
        height: radius * 1.15,
      ),
      Paint()..color = const Color(0xFFF8F9FA),
    );
    // Green rim stroke
    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: radius * 1.85,
        height: radius * 1.15,
      ),
      Paint()
        ..color = const Color(0xFF68B665)
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.16,
    );
    // Red salmon/kani center filling
    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: radius * 0.78,
        height: radius * 0.48,
      ),
      Paint()..color = const Color(0xFFE63946),
    );
  }

  void _drawSalmonNigiri(Canvas canvas, Offset center, double width, double height) {
    // Rice base
    final riceRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center.translate(0, height * 0.25),
        width: width * 0.88,
        height: height * 0.65,
      ),
      Radius.circular(height * 0.28),
    );
    canvas.drawRRect(riceRect, Paint()..color = const Color(0xFFF1F3F5));

    // Salmon topping slice
    final salmonRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center.translate(0, -height * 0.06),
        width: width,
        height: height * 0.68,
      ),
      Radius.circular(height * 0.3),
    );
    canvas.drawRRect(salmonRect, Paint()..color = const Color(0xFFFF7A45));

    // White fat stripes on salmon
    final stripePaint = Paint()
      ..color = const Color(0xFFFFB899)
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    for (int i = -1; i <= 1; i++) {
      final dx = i * (width * 0.2);
      canvas.drawLine(
        center.translate(dx - 6, -height * 0.25),
        center.translate(dx + 8, height * 0.12),
        stripePaint,
      );
    }
  }

  void _drawTunaNigiri(Canvas canvas, Offset center, double width, double height) {
    final riceRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center.translate(0, height * 0.25),
        width: width * 0.82,
        height: height * 0.6,
      ),
      Radius.circular(height * 0.25),
    );
    canvas.drawRRect(riceRect, Paint()..color = const Color(0xFFF1F3F5));

    final tunaRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: width,
        height: height * 0.64,
      ),
      Radius.circular(height * 0.32),
    );
    canvas.drawRRect(tunaRect, Paint()..color = const Color(0xFFE5383B));
  }

  void _drawSoupBowl(Canvas canvas, Offset center, double width) {
    // Spoon handle extending top-right
    canvas.drawLine(
      center.translate(width * 0.1, -width * 0.15),
      center.translate(width * 0.45, -width * 0.48),
      Paint()
        ..color = const Color(0xFFCED4DA)
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );
    // Dark ceramic bowl bottom
    canvas.drawArc(
      Rect.fromCenter(center: center, width: width, height: width * 0.75),
      0,
      math.pi,
      true,
      Paint()..color = const Color(0xFF3B4254),
    );
    // Golden soup broth top oval
    canvas.drawOval(
      Rect.fromCenter(
        center: center.translate(0, -width * 0.02),
        width: width * 0.96,
        height: width * 0.38,
      ),
      Paint()..color = const Color(0xFFF3C65F),
    );
  }

  void _drawPizzaSlice(Canvas canvas, Offset center, double width) {
    final path = Path()
      ..moveTo(center.dx, center.dy - width * 0.45)
      ..lineTo(center.dx - width * 0.42, center.dy + width * 0.38)
      ..quadraticBezierTo(
        center.dx,
        center.dy + width * 0.52,
        center.dx + width * 0.42,
        center.dy + width * 0.38,
      )
      ..close();
    canvas.drawPath(path, Paint()..color = const Color(0xFFF5B742));
    canvas.drawCircle(
      center.translate(-6, 4),
      width * 0.1,
      Paint()..color = const Color(0xFFD62828),
    );
    canvas.drawCircle(
      center.translate(10, 14),
      width * 0.09,
      Paint()..color = const Color(0xFFD62828),
    );
  }

  void _drawBurger(Canvas canvas, Offset center, double width) {
    // Top bun
    canvas.drawArc(
      Rect.fromCenter(
        center: center.translate(0, -width * 0.05),
        width: width * 0.85,
        height: width * 0.65,
      ),
      math.pi,
      math.pi,
      true,
      Paint()..color = const Color(0xFFE09F3E),
    );
    // Patty
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: center.translate(0, width * 0.08),
          width: width * 0.9,
          height: width * 0.18,
        ),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFF5C3A21),
    );
    // Bottom bun
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: center.translate(0, width * 0.24),
          width: width * 0.82,
          height: width * 0.14,
        ),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFFE09F3E),
    );
  }

  void _drawKebab(Canvas canvas, Offset center, double width) {
    canvas.drawLine(
      center.translate(-width * 0.4, width * 0.4),
      center.translate(width * 0.4, -width * 0.4),
      Paint()
        ..color = const Color(0xFFADB5BD)
        ..strokeWidth = 3,
    );
    for (int i = -1; i <= 1; i++) {
      canvas.drawCircle(
        center.translate(i * 14.0, -i * 14.0),
        width * 0.14,
        Paint()..color = const Color(0xFFBC4749),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FoodVectorPainter oldDelegate) =>
      oldDelegate.type != type;
}

// ============================================================================
// CUSTOM PAINTER: DARK STREET MAP + DELIVERY ROUTE
// ============================================================================
class DarkDeliveryMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Deep dark map canvas
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFF191B24),
    );

    // Secondary street grid lines
    final minorRoad = Paint()
      ..color = const Color(0xFF232734)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final majorRoad = Paint()
      ..color = const Color(0xFF2B3040)
      ..strokeWidth = 16
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw organic curved roads matching dark map aesthetic
    final p1 = Path()
      ..moveTo(-20, h * 0.18)
      ..quadraticBezierTo(w * 0.45, h * 0.22, w + 20, h * 0.35);
    final p2 = Path()
      ..moveTo(w * 0.22, -20)
      ..quadraticBezierTo(w * 0.35, h * 0.45, w * 0.08, h + 20);
    final p3 = Path()
      ..moveTo(w * 0.72, -20)
      ..quadraticBezierTo(w * 0.65, h * 0.50, w * 0.92, h + 20);
    final p4 = Path()
      ..moveTo(-20, h * 0.56)
      ..quadraticBezierTo(w * 0.5, h * 0.42, w + 20, h * 0.68);
    final p5 = Path()
      ..moveTo(-20, h * 0.38)
      ..lineTo(w + 20, h * 0.26);

    canvas.drawPath(p5, minorRoad);
    canvas.drawPath(p1, majorRoad);
    canvas.drawPath(p2, majorRoad);
    canvas.drawPath(p3, minorRoad);
    canvas.drawPath(p4, majorRoad);

    // Golden-Cream Delivery Route Line (from Sushi Origin to User Pin)
    final startPt = Offset(w * 0.78, h * 0.24);
    final endPt = Offset(w * 0.36, h * 0.39);

    final routePath = Path()
      ..moveTo(startPt.dx, startPt.dy)
      ..lineTo(w * 0.73, h * 0.27)
      ..lineTo(w * 0.62, h * 0.26)
      ..lineTo(w * 0.76, h * 0.42)
      ..lineTo(w * 0.44, h * 0.44)
      ..lineTo(w * 0.42, h * 0.39)
      ..lineTo(endPt.dx, endPt.dy);

    // Subtle glow under route
    canvas.drawPath(
      routePath,
      Paint()
        ..color = const Color(0xFFFFD166).withValues(alpha: 0.22)
        ..strokeWidth = 8
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round,
    );

    canvas.drawPath(
      routePath,
      Paint()
        ..color = const Color(0xFFF4D58D)
        ..strokeWidth = 2.6
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round,
    );

    // Draw Sushi Origin Marker at Start Point
    canvas.drawCircle(
      startPt,
      20,
      Paint()..color = AppColors.background.withValues(alpha: 0.85),
    );
    canvas.drawCircle(
      startPt,
      14,
      Paint()..color = const Color(0xFFFF7A45),
    );
    canvas.drawCircle(
      startPt.translate(5, -4),
      6,
      Paint()..color = const Color(0xFF68B665),
    );

    // Draw Destination White Pin Badge at End Point
    final pinRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: endPt, width: 32, height: 36),
      const Radius.circular(10),
    );
    canvas.drawRRect(pinRect, Paint()..color = Colors.white);
    canvas.drawCircle(
      endPt,
      8,
      Paint()..color = AppColors.primary,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================================
// CUSTOM PAINTER: CHEF HAT & FLOATING INGREDIENTS (Auth Screen)
// ============================================================================
class ChefHatSplashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final cy = size.height * 0.72;

    // White Chef Hat Puffs
    final whitePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(cx - 24, cy - 22), 20, whitePaint);
    canvas.drawCircle(Offset(cx, cy - 30), 24, whitePaint);
    canvas.drawCircle(Offset(cx + 24, cy - 22), 20, whitePaint);

    // Chef Hat Band
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy + 2), width: 64, height: 24),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFFE9ECEF),
    );

    // Floating colorful food icons in an arc above the chef hat
    // Red tomato top center
    canvas.drawCircle(
      Offset(cx - 6, cy - 105),
      9,
      Paint()..color = const Color(0xFFE63946),
    );
    // Yellow cheese wedge left
    canvas.drawCircle(
      Offset(cx - 42, cy - 68),
      9,
      Paint()..color = const Color(0xFFFFBE0B),
    );
    // Green pear center-right
    canvas.drawCircle(
      Offset(cx + 30, cy - 66),
      8,
      Paint()..color = const Color(0xFF80ED99),
    );
    // Orange chicken drumstick top-right
    canvas.drawCircle(
      Offset(cx + 62, cy - 92),
      9,
      Paint()..color = const Color(0xFFFF9F1C),
    );
    // Coral steak right
    canvas.drawCircle(
      Offset(cx + 76, cy - 42),
      10,
      Paint()..color = const Color(0xFFFF4D6D),
    );
    // Red cherries top-left
    canvas.drawCircle(
      Offset(cx - 68, cy - 86),
      7,
      Paint()..color = const Color(0xFFD90429),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================================
// CUSTOM PAINTER: BOKEH PROFILE HEADER
// ============================================================================
class BokehHeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final circles = [
      (Offset(size.width * 0.2, 60.0), 34.0, const Color(0xFFFF432A)),
      (Offset(size.width * 0.45, 40.0), 42.0, const Color(0xFFFFBE0B)),
      (Offset(size.width * 0.75, 70.0), 38.0, const Color(0xFF3898EC)),
      (Offset(size.width * 0.62, 110.0), 30.0, const Color(0xFF34C759)),
      (Offset(size.width * 0.30, 105.0), 28.0, const Color(0xFFE63946)),
    ];

    for (final c in circles) {
      canvas.drawCircle(
        c.$1,
        c.$2,
        Paint()
          ..color = c.$3.withValues(alpha: 0.28)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 24),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
