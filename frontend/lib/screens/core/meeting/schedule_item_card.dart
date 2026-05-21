import 'package:flutter/material.dart';
import 'package:fadir/models/cronograma_model.dart';

class ScheduleItemCard extends StatelessWidget {
  final CronogramaModel item;
  final VoidCallback onDelete;

  const ScheduleItemCard({
    super.key,
    required this.item,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item.horarioInicio,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
                  fontSize: 13),
            ),
            const Icon(Icons.arrow_downward, size: 12, color: Colors.grey),
            Text(
              item.horarioFim,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 13),
            ),
          ],
        ),
        title: Text(
          item.titulo,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column( 
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              item.descricao,
              style: const TextStyle(fontSize: 13),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(item.dataEvento, style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 12), // Espaço entre data e local
                const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    item.local.isEmpty ? "Local indefinido" : item.local,
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: onDelete,
          tooltip: 'Remover',
        ),
      ),
    );
  }
}