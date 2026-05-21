import 'package:flutter/material.dart';
import '../models/place.dart';

class PlacesProvider extends ChangeNotifier {
  final List<Place> _places = [];

  List<Place> placesByCategory(String categoryId) {
    return _places.where((p) => p.categoryId == categoryId).toList();
  }

  // --- NOVO MÉTODO: Adicionar Objeto Completo (Usado pelo Link) ---
  void addPlaceLocally(Place place) {
    _places.add(place);
    notifyListeners();
  }

  // Método antigo (Cadastro Manual) - Mantido para compatibilidade
  void addPlace({
    required String categoryId,
    required String name,
    required String address,
  }) {
    _places.add(
      Place(
        id: DateTime.now().toString(),
        categoryId: categoryId,
        name: name,
        address: address,
        rating: 0.0, // Novo local começa neutro
        distance: 0.0,
        imageUrl: '', // Sem imagem no cadastro manual simples
        description: null,
        linkOriginal: null,
      ),
    );
    notifyListeners();
  }

  // Atualizar (Editado para preservar descrição e link se existirem)
  void updatePlace({
    required String id,
    required String name,
    required String address,
  }) {
    final index = _places.indexWhere((p) => p.id == id);
    if (index >= 0) {
      final oldPlace = _places[index];
      
      _places[index] = Place(
        id: oldPlace.id,
        categoryId: oldPlace.categoryId,
        name: name,
        address: address,
        rating: oldPlace.rating,
        distance: oldPlace.distance,
        imageUrl: oldPlace.imageUrl,       // Preserva a imagem que veio do link
        description: oldPlace.description, // Preserva a descrição
        linkOriginal: oldPlace.linkOriginal, // Preserva o link
      );
      notifyListeners();
    }
  }

  void removePlace(String id) {
    _places.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}