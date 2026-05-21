import 'package:flutter/material.dart';

class EmptyScheduleWidget extends StatelessWidget {
  const EmptyScheduleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Icon(
            Icons.calendar_today_outlined, 
            size: 40, 
            color: Colors.grey.shade400
          ),
          const SizedBox(height: 8),
          Text(
            "Nenhuma atividade adicionada.",
            style: TextStyle(
              color: Colors.grey.shade600, 
              fontWeight: FontWeight.w500
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Clique em 'Adicionar Item' acima.",
            style: TextStyle(
              color: Colors.grey.shade400, 
              fontSize: 12
            ),
          ),
        ],
      ),
    );
  }
}