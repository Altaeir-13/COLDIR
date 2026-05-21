import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/places_provider.dart';

class PlacesListPage extends StatelessWidget {
  final String categoryId;
  final String categoryName;
  final Color categoryColor;

  const PlacesListPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    final places = context.watch<PlacesProvider>().placesByCategory(categoryId);
    final colors = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: categoryColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          categoryName, 
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: places.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 10),
                  Text("Nenhum local encontrado.", style: TextStyle(color: Colors.grey[500])),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: places.length,
              itemBuilder: (context, index) {
                final place = places[index];
                
                // Não usamos place as dynamic, acessamos diretamente as variáveis da classe Place.
                final String imageUrl = place.imageUrl;
                final String? description = place.description;

                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05), // Usei withOpacity para compatibilidade
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- IMAGEM DO LOCAL ---
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: imageUrl.isNotEmpty
                            ? Image.network(
                                imageUrl,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, err, stack) => _buildPlaceholder(categoryColor),
                              )
                            : _buildPlaceholder(categoryColor),
                      ),
                      
                      // --- INFORMAÇÕES ---
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Título
                            Text(
                              place.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              ),
                            ),
                            const SizedBox(height: 6),
                            
                            // Endereço
                            Row(
                              children: [
                                Icon(Icons.location_on, size: 14, color: categoryColor),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    place.address,
                                    style: TextStyle(
                                      fontSize: 12, 
                                      color: Colors.grey[600]
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),

                            // Descrição (se houver)
                            if (description != null && description.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Text(
                                description,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                  height: 1.4,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                            
                            const SizedBox(height: 16),
                            
                            // Botão
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () {
                                  // Ação do botão
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: categoryColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)
                                  ),
                                ),
                                child: Text(
                                  "Ver Detalhes", 
                                  style: TextStyle(color: categoryColor)
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildPlaceholder(Color color) {
    return Container(
      height: 120,
      width: double.infinity,
      color: color.withValues(alpha: 0.1),
      child: Center(
        child: Icon(Icons.image_not_supported, color: color.withValues(alpha: 0.4), size: 40),
      ),
    );
  }
}