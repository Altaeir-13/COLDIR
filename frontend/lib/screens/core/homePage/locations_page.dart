import 'package:fadir/screens/core/homePage/manage_locations_page.dart';
//import 'package:fadir/screens/core/homePage/manage_places_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fadir/providers/user_provider.dart';
import 'package:fadir/providers/locations_provider.dart';
import 'package:fadir/providers/language_provider.dart';
import 'package:fadir/widgets/category_card.dart';
import 'place_list_page.dart';

// Tela que exibe as categorias de locais
// Usuários admin podem acessar a criação de locais

class LocationsPage extends StatelessWidget {
  const LocationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final Color tealColor = colors.primary;
    final background = colors.surface;
    final onPrimary = colors.onPrimary;
    final user = context.watch<UserProvider>();
    final locations = context.watch<LocationsProvider>();
    String t(String key) => context.t(key);

    String localizedTitle(String id, String fallback) {
      const map = {
        'hospedagem': 'categoryLodgingTitle',
        'alimentacao': 'categoryFoodTitle',
        'evento': 'categoryEventTitle',
        'transporte': 'categoryTransportTitle',
        'turismo': 'categoryTourismTitle',
        'saude': 'categoryHealthTitle',
      };
      final key = map[id];
      return key != null ? t(key) : fallback;
    }

    String localizedSubtitle(String id, String fallback) {
      const map = {
        'hospedagem': 'categoryLodgingSubtitle',
        'alimentacao': 'categoryFoodSubtitle',
        'evento': 'categoryEventSubtitle',
        'transporte': 'categoryTransportSubtitle',
        'turismo': 'categoryTourismSubtitle',
        'saude': 'categoryHealthSubtitle',
      };
      final key = map[id];
      return key != null ? t(key) : fallback;
    }

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: tealColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: onPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          t('locationsTitle'),
          style: TextStyle(color: onPrimary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      floatingActionButton:
          user.cargo == "ADMIN" || user.cargo == "PROPRIETARIO"
              ? FloatingActionButton(
                backgroundColor: tealColor,
                child: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ManageLocationsPage(),
                    ),
                  );
                },
              )
              : null,

      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.1,
        children:
            locations.categories.map((category) {
              return CategoryCard(
                title: localizedTitle(category.id, category.title),
                subtitle: localizedSubtitle(category.id, category.subtitle),
                icon: category.icon,
                color: category.color,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => PlacesListPage(
                            categoryId: category.id,
                            categoryName: localizedTitle(category.id, category.title),
                            categoryColor: category.color,
                          ),
                    ),
                  );
                },
              );
            }).toList(),
      ),
    );
  }
}
