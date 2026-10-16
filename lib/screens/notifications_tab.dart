import 'package:flutter/material.dart';

import '../app_state.dart';
import '../theme.dart';
import '../widgets.dart';
import 'profile_screen.dart';

// Loyalty point notifications feed.

class NotificationsTabView extends StatelessWidget {
  final AppState appState;

  const NotificationsTabView({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      child: Column(
        children: [
          // Top Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleIconButton(
                icon: Icons.notes_rounded,
                onTap: appState.toggleDrawer,
                semanticLabel: 'Open menu',
              ),
              const Text(
                'Notifications',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Semantics(
                button: true,
                label: 'Open profile',
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ProfileScreen(appState: appState),
                      ),
                    );
                  },
                  child: const UserAvatarWidget(size: 40),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Points Notification List
          Expanded(
            child: ListView.separated(
              itemCount: appState.notifications.length,
              separatorBuilder: (_, __) => Divider(
                color: Colors.white.withValues(alpha: 0.05),
                height: 22,
              ),
              itemBuilder: (context, index) {
                final item = appState.notifications[index];
                return Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: item.badgeColor.withValues(alpha: 0.18),
                        border: Border.all(
                          color: item.badgeColor.withValues(alpha: 0.65),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '+${item.points}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.timeAgo,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
