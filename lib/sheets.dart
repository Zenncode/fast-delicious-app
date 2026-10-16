import 'package:flutter/material.dart';

import 'app_state.dart';
import 'models.dart';
import 'theme.dart';
import 'widgets.dart';

// Modal sheets & dialogs (change/forgot password, filter, history, complaint, privacy).

void showChangePasswordSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.background,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) => const _ChangePasswordSheet(),
  );
}

class _ChangePasswordSheet extends StatefulWidget {
  const _ChangePasswordSheet();

  @override
  State<_ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<_ChangePasswordSheet> {
  final TextEditingController _oldCtrl = TextEditingController();
  final TextEditingController _newCtrl = TextEditingController();

  @override
  void dispose() {
    _oldCtrl.dispose();
    _newCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 22,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Change Password',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              CircleIconButton(
                icon: Icons.close,
                onTap: () => Navigator.of(context).pop(),
                semanticLabel: 'Close',
              ),
            ],
          ),
          const SizedBox(height: 20),
          AuthInputField(
            label: 'Old Password',
            controller: _oldCtrl,
            obscure: true,
          ),
          const SizedBox(height: 16),
          AuthInputField(
            label: 'New Password',
            controller: _newCtrl,
            obscure: true,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: () {
                final messenger = ScaffoldMessenger.of(context);
                Navigator.of(context).pop();
                messenger.showSnackBar(
                  const SnackBar(
                    backgroundColor: AppColors.surfaceLight,
                    content: Text(
                      'Password updated.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
              child: const Text(
                'Save',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showForgotPasswordSheet(BuildContext context, String initialEmail) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.background,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) => _ForgotPasswordSheet(initialEmail: initialEmail),
  );
}

class _ForgotPasswordSheet extends StatefulWidget {
  final String initialEmail;

  const _ForgotPasswordSheet({required this.initialEmail});

  @override
  State<_ForgotPasswordSheet> createState() => _ForgotPasswordSheetState();
}

class _ForgotPasswordSheetState extends State<_ForgotPasswordSheet> {
  late final TextEditingController _emailCtrl;

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 22,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Forgot Password',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              CircleIconButton(
                icon: Icons.close,
                onTap: () => Navigator.of(context).pop(),
                semanticLabel: 'Close',
              ),
            ],
          ),
          const SizedBox(height: 20),
          AuthInputField(
            label: 'Email Address',
            controller: _emailCtrl,
            obscure: false,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: () {
                final messenger = ScaffoldMessenger.of(context);
                final email = _emailCtrl.text.trim();
                Navigator.of(context).pop();
                messenger.showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.surfaceLight,
                    content: Text(
                      email.isEmpty
                          ? 'Enter an email address to receive the reset link.'
                          : 'Password reset link sent to $email',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
              child: const Text(
                'Send Reset Link',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showFilterBottomSheet(BuildContext context, AppState appState) {
  double currentMax = appState.maxPriceFilter;
  bool sortRating = appState.sortByRating;

  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter Dishes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Max Price: ${formatPrice(currentMax)}',
                  style: const TextStyle(color: Colors.white),
                ),
                Slider(
                  value: currentMax,
                  min: AppState.priceFilterMin,
                  max: AppState.priceFilterMax,
                  activeColor: AppColors.primary,
                  onChanged: (val) => setModalState(() => currentMax = val),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Sort by Highest Rating (4.9★)',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  activeColor: AppColors.primary,
                  value: sortRating,
                  onChanged: (val) => setModalState(() => sortRating = val),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      appState.updateFilters(
                        maxPrice: currentMax,
                        sortRating: sortRating,
                      );
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Apply Filter',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

void showOrderHistorySheet(BuildContext context, AppState appState) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order History',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            if (appState.orderHistory.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'No orders yet. Place an order and it will show up here with its live status.',
                  style: TextStyle(color: AppColors.textSecondary, height: 1.5),
                ),
              )
            else
              ...appState.orderHistory.map(
                (o) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    '${o.id} • ${formatPrice(o.total)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    o.status,
                    style: const TextStyle(color: AppColors.primary),
                  ),
                  trailing: Text(
                    o.date,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ),
          ],
        ),
      );
    },
  );
}

void showComplaintDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const _ComplaintDialog(),
  );
}

class _ComplaintDialog extends StatefulWidget {
  const _ComplaintDialog();

  @override
  State<_ComplaintDialog> createState() => _ComplaintDialogState();
}

class _ComplaintDialogState extends State<_ComplaintDialog> {
  final TextEditingController _messageCtrl = TextEditingController();

  @override
  void dispose() {
    _messageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Text(
        'Submit a Complaint',
        style: TextStyle(color: Colors.white, fontSize: 17),
      ),
      content: TextField(
        controller: _messageCtrl,
        maxLines: 3,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: 'Tell us how we can improve your order experience...',
          hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            final messenger = ScaffoldMessenger.of(context);
            Navigator.of(context).pop();
            messenger.showSnackBar(
              const SnackBar(
                backgroundColor: AppColors.surfaceLight,
                content: Text(
                  'Thank you! Our support team will respond shortly.',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          },
          child: const Text('Send'),
        ),
      ],
    );
  }
}

void showPrivacyPolicySheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) => const Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Privacy Policy',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Fast and Delicious Food uses your delivery address and contact number strictly to coordinate live courier routing and reward points notifications.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13.5,
              height: 1.5,
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    ),
  );
}
