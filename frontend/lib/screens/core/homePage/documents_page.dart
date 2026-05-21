import 'package:flutter/material.dart';
import 'package:fadir/providers/language_provider.dart';
import 'package:fadir/widgets/document_items.dart';

class DocumentsPage extends StatelessWidget {
  const DocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final Color tealColor = colors.primary;
    final background = colors.surface;
    String t(String key) => context.t(key);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: tealColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          t('documentsTitle'),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // CABEÇALHO DA LISTA
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
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
                Text(
                  t('meetingFiles'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  t('meetingFilesSubtitle'),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // LISTA DE ARQUIVOS
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                DocumentItem(
                  title: t('documentAgendaDecember'),
                  fileSize: "2.4 MB",
                  date: "12/12/2025",
                  format: "PDF",
                  onDownload: () {
                    // Lógica de download aqui
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(t('downloadingFile'))),
                    );
                  },
                ),
                DocumentItem(
                  title: t('documentResults2025'),
                  fileSize: "15.8 MB",
                  date: "10/12/2025",
                  format: "PPTX",
                  onDownload: () {},
                ),
                DocumentItem(
                  title: t('documentBudget2026'),
                  fileSize: "1.2 MB",
                  date: "09/12/2025",
                  format: "XLSX",
                  onDownload: () {},
                ),
                DocumentItem(
                  title: t('documentPreviousMinutes'),
                  fileSize: "850 KB",
                  date: "10/11/2025",
                  format: "DOCX",
                  onDownload: () {},
                ),
                DocumentItem(
                  title: t('documentInternalRegulation'),
                  fileSize: "3.5 MB",
                  date: "01/01/2025",
                  format: "PDF",
                  onDownload: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}