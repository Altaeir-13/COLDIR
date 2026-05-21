import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/places_provider.dart';
import '../../../services/local_service.dart';
import '../../../models/place.dart';

class ManagePlacesPage extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const ManagePlacesPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<ManagePlacesPage> createState() => _ManagePlacesPageState();
}

class _ManagePlacesPageState extends State<ManagePlacesPage> {
  final LocalService _localService = LocalService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlacesProvider>();
    final places = provider.placesByCategory(widget.categoryId);
    final colors = Theme.of(context).colorScheme;
    final Color primaryColor = colors.primary;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'Gerenciar ${widget.categoryName}',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Adicionar Local", style: TextStyle(color: Colors.white)),
        onPressed: () => _showAddOptionSheet(context),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : places.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.place_outlined, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhum local nesta categoria.',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: places.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    final place = places[i];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: primaryColor.withValues(alpha: 0.1),
                          child: Icon(Icons.place, color: primaryColor),
                        ),
                        title: Text(
                          place.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          place.address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () {
                             // Lógica de exclusão aqui se necessário
                             provider.removePlace(place.id);
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _showAddOptionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: DefaultTabController(
            length: 2,
            child: SizedBox(
              height: 550, // Aumentei um pouco para caber os novos campos
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // Indicador visual
                  Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
                  const SizedBox(height: 10),
                  
                  const TabBar(
                    labelColor: Color(0xFF0E564D),
                    tabs: [
                      Tab(icon: Icon(Icons.link), text: "Via Link"),
                      Tab(icon: Icon(Icons.edit), text: "Manual"),
                    ],
                  ),
                  
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildLinkTab(ctx),
                        _buildManualTab(ctx),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLinkTab(BuildContext ctx) {
    final linkCtrl = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text("Cole o link do site ou mapa.", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          TextField(
            controller: linkCtrl,
            decoration: const InputDecoration(labelText: 'URL', prefixIcon: Icon(Icons.link), border: OutlineInputBorder()),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _processarAdicao(link: linkCtrl.text);
            },
            child: const Text("Buscar"),
          )
        ],
      ),
    );
  }

  Widget _buildManualTab(BuildContext ctx) {
    // Controladores para os campos manuais
    final nomeCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final endCtrl = TextEditingController();
    final cidadeCtrl = TextEditingController();
    final imgCtrl = TextEditingController();

    return SingleChildScrollView( // Permite rolar se o teclado cobrir
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(controller: nomeCtrl, decoration: const InputDecoration(labelText: 'Nome', prefixIcon: Icon(Icons.store))),
          const SizedBox(height: 10),
          TextField(controller: endCtrl, decoration: const InputDecoration(labelText: 'Endereço', prefixIcon: Icon(Icons.map))),
          const SizedBox(height: 10),
          TextField(controller: cidadeCtrl, decoration: const InputDecoration(labelText: 'Cidade', prefixIcon: Icon(Icons.location_city))),
          const SizedBox(height: 10),
          TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Descrição', prefixIcon: Icon(Icons.description))),
          const SizedBox(height: 10),
          TextField(controller: imgCtrl, decoration: const InputDecoration(labelText: 'URL da Imagem', prefixIcon: Icon(Icons.image))),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (nomeCtrl.text.isEmpty) return;
              Navigator.pop(ctx);
              
              // Aqui chamamos a função unificada passando os dados manuais
              _processarAdicao(
                nome: nomeCtrl.text,
                desc: descCtrl.text,
                endereco: endCtrl.text,
                cidade: cidadeCtrl.text,
                imagem: imgCtrl.text,
                isManual: true,
              );
            },
            child: const Text("Salvar Manualmente"),
          )
        ],
      ),
    );
  }

  // --- LÓGICA CENTRAL ---
  Future<void> _processarAdicao({
    String? link, 
    String? nome, 
    String? desc, 
    String? endereco, 
    String? cidade, 
    String? imagem, 
    bool isManual = false
  }) async {
    setState(() => _isLoading = true);

    try {
      Map<String, dynamic> dados;

      if (isManual) {
        // Agora o LocalService aceita esses parâmetros nomeados
        dados = await _localService.adicionarManual(
          nome: nome!, 
          descricao: desc ?? "", 
          endereco: endereco ?? "", 
          cidade: cidade ?? "", 
          imagem: imagem ?? ""
        );
      } else {
        dados = await _localService.adicionarViaLink(link!);
      }

      if (mounted) {
        final newPlace = Place.fromJson(dados, widget.categoryId);
        context.read<PlacesProvider>().addPlaceLocally(newPlace);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Local '${newPlace.name}' salvo!")));
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Erro"),
            content: Text(e.toString().replaceAll("Exception: ", "")),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}