import 'package:flutter/material.dart';

import '../app_state.dart';
import '../sheets.dart';
import '../theme.dart';
import '../widgets.dart';
import 'cart_screen.dart';
import 'delivery_tracking_screen.dart';
import 'favorites_tab.dart';
import 'home_tab.dart';
import 'notifications_tab.dart';
import 'payment_screen.dart';

// App shell: 3D zoom drawer, side menu, and bottom navigation.

class MainZoomDrawerShell extends StatelessWidget {
  // Drawer-open animation values (translate + scale for the 3D zoom effect).
  static const double _drawerOffsetX = 230.0;
  static const double _drawerOffsetY = 90.0;
  static const double _drawerScale = 0.72;

  final AppState appState;

  const MainZoomDrawerShell({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Side Drawer (Matches bottom-center mockup in image_4c8260.jpg)
          SideDrawerMenu(appState: appState),

          // Foreground Main App Container with 3D Scale & Slide Animation
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            transform: Matrix4.identity()
              ..translateByDouble(
                appState.isDrawerOpen ? _drawerOffsetX : 0.0,
                appState.isDrawerOpen ? _drawerOffsetY : 0.0,
                0.0,
                1.0,
              )
              ..scaleByDouble(
                appState.isDrawerOpen ? _drawerScale : 1.0,
                appState.isDrawerOpen ? _drawerScale : 1.0,
                appState.isDrawerOpen ? _drawerScale : 1.0,
                1.0,
              ),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(appState.isDrawerOpen ? 32 : 0),
              boxShadow: appState.isDrawerOpen
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.55),
                        blurRadius: 35,
                        spreadRadius: 4,
                        offset: const Offset(-12, 16),
                      ),
                    ]
                  : [],
              border: appState.isDrawerOpen
                  ? Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1.5)
                  : null,
            ),
            clipBehavior: appState.isDrawerOpen ? Clip.antiAlias : Clip.none,
            child: GestureDetector(
              onTap: appState.isDrawerOpen ? appState.closeDrawer : null,
              child: AbsorbPointer(
                absorbing: appState.isDrawerOpen,
                child: Scaffold(
                  backgroundColor: AppColors.background,
                  body: SafeArea(
                    child: IndexedStack(
                      index: appState.bottomNavIndex,
                      children: [
                        // HeroMode disables Hero animations for tabs that are
                        // not currently visible. IndexedStack keeps every tab
                        // mounted, so without this the same dish can exist in
                        // both the Home list and the Favorites grid at once,
                        // creating duplicate Hero tags that break navigation.
                        HeroMode(
                          enabled: appState.bottomNavIndex == 0,
                          child: HomeTabView(appState: appState),
                        ),
                        HeroMode(
                          enabled: appState.bottomNavIndex == 1,
                          child: FavoritesTabView(appState: appState),
                        ),
                        HeroMode(
                          enabled: appState.bottomNavIndex == 2,
                          child: NotificationsTabView(appState: appState),
                        ),
                        HeroMode(
                          enabled: appState.bottomNavIndex == 3,
                          child: CartScreen(
                            appState: appState,
                            isEmbeddedTab: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottomNavigationBar: _BottomNavBar(appState: appState),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SideDrawerMenu extends StatelessWidget {
  final AppState appState;

  const SideDrawerMenu({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top right close button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: CircleIconButton(
                  icon: Icons.close,
                  onTap: appState.closeDrawer,
                  semanticLabel: 'Close menu',
                ),
              ),
            ),
            const SizedBox(height: 36),
            _DrawerMenuItem(
              icon: Icons.favorite_border,
              label: 'Favorites',
              onTap: () => appState.setBottomNav(1),
            ),
            _DrawerMenuItem(
              icon: Icons.credit_card_outlined,
              label: 'Payment Methods',
              onTap: () {
                appState.closeDrawer();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PaymentScreen(appState: appState),
                  ),
                );
              },
            ),
            _DrawerMenuItem(
              icon: Icons.shopping_bag_outlined,
              label: 'My Order',
              onTap: () {
                appState.closeDrawer();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => DeliveryTrackingScreen(appState: appState),
                  ),
                );
              },
            ),
            _DrawerMenuItem(
              icon: Icons.history,
              label: 'History',
              onTap: () {
                appState.closeDrawer();
                showOrderHistorySheet(context, appState);
              },
            ),
            _DrawerMenuItem(
              icon: Icons.chat_bubble_outline,
              label: 'Complaint',
              onTap: () {
                appState.closeDrawer();
                showComplaintDialog(context);
              },
            ),
            _DrawerMenuItem(
              icon: Icons.shield_outlined,
              label: 'Privacy Policy',
              onTap: () {
                appState.closeDrawer();
                showPrivacyPolicySheet(context);
              },
            ),
            const Spacer(),
            _DrawerMenuItem(
              icon: Icons.logout,
              label: 'Log-out',
              onTap: appState.logout,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 20),
            const SizedBox(width: 14),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final AppState appState;

  const _BottomNavBar({required this.appState});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: AppColors.background,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavIconItem(
            icon: Icons.home_outlined,
            label: 'Home',
            isSelected: appState.bottomNavIndex == 0,
            onTap: () => appState.setBottomNav(0),
          ),
          _NavIconItem(
            icon: Icons.favorite_border_rounded,
            label: 'Favorites',
            isSelected: appState.bottomNavIndex == 1,
            onTap: () => appState.setBottomNav(1),
          ),
          _NavIconItem(
            icon: Icons.notifications_none_rounded,
            label: 'Notifications',
            isSelected: appState.bottomNavIndex == 2,
            onTap: () => appState.setBottomNav(2),
          ),
          _NavIconItem(
            icon: Icons.shopping_bag_outlined,
            label: 'Cart',
            isSelected: appState.bottomNavIndex == 3,
            badgeCount: appState.totalCartCount,
            onTap: () => appState.setBottomNav(3),
          ),
        ],
      ),
    );
  }
}

class _NavIconItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final int badgeCount;
  final VoidCallback onTap;

  const _NavIconItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    this.badgeCount = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 56,
          height: 56,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                size: 24,
              ),
              if (badgeCount > 0)
                Positioned(
                  top: 10,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$badgeCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
