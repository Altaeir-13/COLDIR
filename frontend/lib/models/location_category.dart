import 'package:flutter/material.dart';

// Modelo que representa uma categoria de locais
// (ex: Hospedagem, Alimentação, Transporte).

class LocationCategory {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  LocationCategory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}
