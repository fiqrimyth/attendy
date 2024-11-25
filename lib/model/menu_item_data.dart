import 'dart:ui';

class MenuItemData {
  final String icon;
  final String label;
  final VoidCallback onTap;
  final int? badge;

  MenuItemData({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badge,
  });
}
