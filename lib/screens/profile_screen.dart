import 'package:flutter/material.dart';

import '../app_state.dart';
import '../painters.dart';
import '../sheets.dart';
import '../theme.dart';
import '../widgets.dart';

// User profile screen with editable fields and change-password sheet.

class ProfileScreen extends StatefulWidget {
  final AppState appState;

  const ProfileScreen({super.key, required this.appState});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _paymentCtrl;
  late final TextEditingController _addressCtrl;

  @override
  void initState() {
    super.initState();
    _phoneCtrl = TextEditingController(text: widget.appState.phoneNumber);
    _emailCtrl = TextEditingController(text: widget.appState.email);
    _paymentCtrl = TextEditingController(text: widget.appState.paymentSummary);
    _addressCtrl = TextEditingController(text: widget.appState.deliveryAddress);
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _paymentCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Top Blurred Bokeh Header Effect
          Positioned(
            top: -20,
            left: 0,
            right: 0,
            height: 220,
            child: CustomPaint(
              painter: BokehHeaderPainter(),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top Bar (My Profile + X button)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                  child: Row(
                    children: [
                      const SizedBox(width: 38),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'My Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      CircleIconButton(
                        icon: Icons.close,
                        onTap: () => Navigator.of(context).pop(),
                        semanticLabel: 'Close profile',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Main Card with Overlapping Avatar
                Expanded(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 38),
                        padding: const EdgeInsets.fromLTRB(22, 58, 22, 20),
                        decoration: const BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(34),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              widget.appState.fullName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Expanded(
                              child: ListView(
                                children: [
                                  _ProfileEditableField(
                                    icon: Icons.phone_outlined,
                                    label: 'Phone Number',
                                    controller: _phoneCtrl,
                                    keyboardType: TextInputType.phone,
                                  ),
                                  const SizedBox(height: 14),
                                  _ProfileEditableField(
                                    icon: Icons.email_outlined,
                                    label: 'Email',
                                    controller: _emailCtrl,
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  const SizedBox(height: 14),
                                  _ProfileEditableField(
                                    icon: Icons.credit_card_outlined,
                                    label: 'Payment Methods',
                                    controller: _paymentCtrl,
                                  ),
                                  const SizedBox(height: 14),
                                  _ProfileEditableField(
                                    icon: Icons.local_shipping_outlined,
                                    label: 'Address',
                                    controller: _addressCtrl,
                                  ),
                                  const SizedBox(height: 16),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton.icon(
                                      onPressed: () =>
                                          showChangePasswordSheet(context),
                                      icon: const Icon(
                                        Icons.lock_reset_rounded,
                                        color: AppColors.primary,
                                        size: 18,
                                      ),
                                      label: const Text(
                                        'Change Password',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                                  widget.appState.saveProfile(
                                    name: widget.appState.fullName,
                                    phone: _phoneCtrl.text,
                                    mail: _emailCtrl.text,
                                    pay: _paymentCtrl.text,
                                    addr: _addressCtrl.text,
                                  );
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'Save',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Overlapping User Avatar with "+" badge
                      Stack(
                        children: [
                          const UserAvatarWidget(size: 76),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.background,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 14,
                                color: AppColors.background,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileEditableField extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const _ProfileEditableField({
    required this.icon,
    required this.label,
    required this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 3),
                TextField(
                  controller: controller,
                  keyboardType: keyboardType,
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
          const Icon(
            Icons.edit_outlined,
            color: AppColors.textSecondary,
            size: 17,
          ),
        ],
      ),
    );
  }
}
