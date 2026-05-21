import 'package:flutter/material.dart';

class HistoryFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const HistoryFilterChip({
    super.key, 
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white54),
          borderRadius: BorderRadius.circular(20),
          color: isSelected ? Colors.white : Colors.transparent, 
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF0E564D) : Colors.white, 
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}