import 'package:flutter/material.dart';

import '../app_state.dart';
import '../theme.dart';
import '../widgets.dart';
import 'food_detail_screen.dart';

// Favorites tab: grid of saved dishes.

class FavoritesTabView extends StatelessWidget {
  final AppState appState;

  const FavoritesTabView({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final favs = appState.favoriteItems;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleIconButton(
                icon: Icons.notes_rounded,
                onTap: appState.toggleDrawer,
                semanticLabel: 'Open menu',
              ),
              const Text(
                'Favorites',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const UserAvatarWidget(size: 40),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: favs.isEmpty
                ? const Center(
                    child: Text(
                      'No favorite dishes yet.\nTap the heart icon on any dish to save it!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: favs.length,
                    itemBuilder: (context, index) {
                      final food = favs[index];
                      return FoodCatalogCard(
                        food: food,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => FoodDetailScreen(
                                appState: appState,
                                food: food,
                              ),
                            ),
                          );
                        },
                        onAddToCart: () => appState.addToCart(food),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
