import 'package:flutter/material.dart';
import 'package:fadir/providers/language_provider.dart';
import 'history_filter_chip.dart'; // Importando o chip

class HistoryHeader extends StatefulWidget {
  final String selectedFilter;
  final Function(String) onFilterSelected;
  final Function(String) onSearchChanged;

  const HistoryHeader({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.onSearchChanged,
  });

  @override
  State<HistoryHeader> createState() => _HistoryHeaderState();
}

class _HistoryHeaderState extends State<HistoryHeader> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        widget.onSearchChanged("");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color tealColor = const Color(0xFF0E564D);
    String t(String key) => context.t(key);

    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
        color: tealColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título e Notificação
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                t('historyTitle'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Barra de Busca e Filtros
          Row(
            children: [
              // Botão de Busca (Laranja)
              GestureDetector(
                onTap: _toggleSearch,
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isSearching ? Icons.close : Icons.search,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              
              // Lista de Filtros ou Campo de Busca
              Expanded(
                child: _isSearching
                    ? TextField(
                        controller: _searchController,
                        onChanged: widget.onSearchChanged,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: t('searchHint'),
                          hintStyle: const TextStyle(color: Colors.white70),
                          border: InputBorder.none,
                        ),
                        autofocus: true,
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            HistoryFilterChip(
                              label: t('filterAll'),
                              isSelected: widget.selectedFilter == 'all',
                              onTap: () => widget.onFilterSelected('all'),
                            ),
                            const SizedBox(width: 10),
                            HistoryFilterChip(
                              label: t('filterInProgress'),
                              isSelected: widget.selectedFilter == 'inProgress',
                              onTap: () => widget.onFilterSelected('inProgress'),
                            ),
                            const SizedBox(width: 10),
                            HistoryFilterChip(
                              label: t('filterCompleted'),
                              isSelected: widget.selectedFilter == 'completed',
                              onTap: () => widget.onFilterSelected('completed'),
                            ),
                            const SizedBox(width: 10),
                            HistoryFilterChip(
                              label: t('filterAbsent'),
                              isSelected: widget.selectedFilter == 'absent',
                              onTap: () => widget.onFilterSelected('absent'),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}