import 'package:flutter/material.dart';
import '../models/location_category.dart';

// Provider responsável por gerenciar as categorias de locais exibidas na tela inicial

class LocationsProvider extends ChangeNotifier {
  final List<LocationCategory> _categories = [
    LocationCategory(
      id: 'hospedagem',
      title: 'Hospedagem',
      subtitle: 'Hotéis e Pousadas',
      icon: Icons.hotel,
      color: Colors.blue,
    ),
    LocationCategory(
      id: 'alimentacao',
      title: 'Alimentação',
      subtitle: 'Restaurantes e Cafés',
      icon: Icons.restaurant,
      color: Colors.orange,
    ),
    LocationCategory(
      id: 'evento',
      title: 'O Evento',
      subtitle: 'Auditórios e Salas',
      icon: Icons.map,
      color: Color(0xFF0E564D),
    ),
    LocationCategory(
      id: 'transporte',
      title: 'Transporte',
      subtitle: 'Ônibus e Táxis',
      icon: Icons.directions_bus,
      color: Colors.purple,
    ),
    LocationCategory(
      id: 'turismo',
      title: 'Turismo',
      subtitle: 'Pontos turísticos da cidade',
      icon: Icons.camera_alt,
      color: Colors.pink,
    ),

    LocationCategory(
      id: 'saude',
      title: 'Saúde',
      subtitle: 'Hospitais e Farmácias',
      icon: Icons.local_hospital,
      color: Colors.red,
    ),
  ];

  List<LocationCategory> get categories => _categories;
}
