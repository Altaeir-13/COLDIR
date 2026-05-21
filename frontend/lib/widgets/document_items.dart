import 'package:flutter/material.dart';

class DocumentItem extends StatelessWidget {
  final String title;
  final String fileSize;
  final String date;
  final String format; // 'PDF', 'DOC', 'XLS', 'PPT'
  final VoidCallback onDownload;

  const DocumentItem({
    super.key,
    required this.title,
    required this.fileSize,
    required this.date,
    required this.format,
    required this.onDownload,
  });

  // Função auxiliar para definir cores baseadas no tipo de arquivo
  Color _getFormatColor() {
    switch (format.toUpperCase()) {
      case 'PDF': return Colors.redAccent;
      case 'DOC': 
      case 'DOCX': return Colors.blueAccent;
      case 'XLS': 
      case 'XLSX': return Colors.green;
      case 'PPT': 
      case 'PPTX': return Colors.orange;
      default: return Colors.grey;
    }
  }

  IconData _getFormatIcon() {
    switch (format.toUpperCase()) {
      case 'PDF': return Icons.picture_as_pdf;
      case 'DOC': 
      case 'DOCX': return Icons.description;
      case 'XLS': 
      case 'XLSX': return Icons.table_chart;
      case 'PPT': 
      case 'PPTX': return Icons.slideshow;
      default: return Icons.insert_drive_file;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final surface = colors.surface;
    final onSurface = colors.onSurface;
    final formatColor = _getFormatColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Ícone do Arquivo
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: formatColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              _getFormatIcon(),
              color: formatColor,
              size: 28,
            ),
          ),
          
          const SizedBox(width: 15),
          
          // Informações do Arquivo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      format.toUpperCase(),
                      style: TextStyle(
                        color: formatColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "$fileSize • $date",
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Botão de Download
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onDownload,
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: colors.outlineVariant),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.download_rounded,
                  color: Color(0xFF0E564D), // Verde do App
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}