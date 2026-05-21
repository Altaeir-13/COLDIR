import 'package:fadir/screens/core/homePage/manage_places_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/language_provider.dart';
import '../../../providers/locations_provider.dart';

// Tela administrativa para gerenciar as categorias de locais
// e acessar o gerenciamento dos locais por categoria.

class ManageLocationsPage extends StatelessWidget {
  const ManageLocationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LocationsProvider>();
    final colors = Theme.of(context).colorScheme;
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
      backgroundColor: colors.surface,
      appBar: AppBar(title: Text(t('manageCategories'))),
      body: ListView.builder(
        itemCount: provider.categories.length,
        itemBuilder: (_, i) {
          final category = provider.categories[i];
          return ListTile(
            leading: Icon(category.icon, color: category.color),
            title: Text(localizedTitle(category.id, category.title)),
            subtitle: Text(localizedSubtitle(category.id, category.subtitle)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => ManagePlacesPage(
                        categoryId: category.id,
                        categoryName: localizedTitle(category.id, category.title),
                      ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
