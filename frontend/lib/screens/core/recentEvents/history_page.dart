import 'package:flutter/material.dart';
import 'package:fadir/providers/language_provider.dart';
import 'details_page.dart'; // Import para navegação
import 'package:fadir/widgets/history_header.dart'; // Import do Header
import 'package:fadir/widgets/history_items.dart';   // Import do Item

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _selectedFilter = 'all';
  String _searchQuery = "";

  final List<_HistoryEvent> _allEvents = const [
    _HistoryEvent(
      titleKey: 'eventCaxiasMeeting',
      status: 'inProgress',
      date: '12/12/2025',
    ),
    _HistoryEvent(
      titleKey: 'eventSaoJoaoMeeting',
      status: 'completed',
      date: '11/11/2025',
    ),
    _HistoryEvent(
      titleKey: 'eventSaoLuisMeeting',
      status: 'completed',
      date: '10/10/2025',
    ),
    _HistoryEvent(
      titleKey: 'eventCaxiasMeeting',
      status: 'completed',
      date: '09/09/2025',
    ),
    _HistoryEvent(
      titleKey: 'eventCodoMeeting',
      status: 'completed',
      date: '08/08/2025',
    ),
    _HistoryEvent(
      titleKey: 'eventTimonMeeting',
      status: 'absent',
      date: '07/07/2025',
    ),
  ];

  String _removeDiacritics(String str) {
    const diacritics = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    const nonDiacritics = 'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    return str.split('').map((char) {
      final index = diacritics.indexOf(char);
      return index != -1 ? nonDiacritics[index] : char;
    }).join('');
  }

  List<_HistoryEvent> _filteredEvents(BuildContext context) {
    return _allEvents.where((event) {
      final matchesFilter = _selectedFilter == 'all' || event.status == _selectedFilter;

      final normalizedTitle = _removeDiacritics(context.t(event.titleKey).toLowerCase());
      final normalizedQuery = _removeDiacritics(_searchQuery.toLowerCase());
      
      final searchTerms = normalizedQuery.split(' ').where((term) => term.isNotEmpty);
      final matchesSearch = searchTerms.every((term) => normalizedTitle.contains(term));

      return matchesFilter && matchesSearch;
    }).toList();
  }

  void _onFilterSelected(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  String _localizedStatus(BuildContext context, String status) {
    switch (status) {
      case 'inProgress':
        return context.t('statusInProgress');
      case 'completed':
        return context.t('statusCompleted');
      case 'absent':
        return context.t('statusAbsent');
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final background = colors.surface;
    final filteredEvents = _filteredEvents(context);
    return Scaffold(
      backgroundColor: background,
      body: Column(
        children: [
          // Widget de Cabeçalho Modularizado
          HistoryHeader(
            selectedFilter: _selectedFilter,
            onFilterSelected: _onFilterSelected,
            onSearchChanged: _onSearchChanged,
          ),

          // Lista de Itens
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                final event = filteredEvents[index];
                final displayTitle = context.t(event.titleKey);
                final statusLabel = _localizedStatus(context, event.status);
                return HistoryItem(
                  title: displayTitle,
                  status: statusLabel,
                  date: event.date,
                  onTap: () => _navigateToDetails(
                    context,
                    displayTitle,
                    statusLabel,
                    event.date,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Função auxiliar para navegação
  void _navigateToDetails(BuildContext context, String title, String status, String date) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(
          title: title,
          status: status,
          date: date,
        ),
      ),
    );
  }
}

class _HistoryEvent {
  final String titleKey;
  final String status;
  final String date;

  const _HistoryEvent({
    required this.titleKey,
    required this.status,
    required this.date,
  });
}