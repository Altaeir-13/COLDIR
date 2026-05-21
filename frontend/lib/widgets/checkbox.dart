import 'package:flutter/material.dart';

class CheckboxWidget extends StatefulWidget {
  final String text;
  final VoidCallback onPressed; // Ação do botão "Esqueceu a senha?"
  final bool marked; // Valor inicial do checkbox
  final VoidCallback? onTextTap; // Ação ao clicar no texto

  const CheckboxWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.marked = false,
    this.onTextTap,
  });

  @override
  State<CheckboxWidget> createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  // Variável de estado para controlar o checkbox
  late bool markedBox;

  @override
  void initState() {
    super.initState();
    // Inicializa a variável com o valor que veio do widget pai
    markedBox = widget.marked;
  }

  @override
  Widget build(BuildContext context) {
    return Container( 
      // Padding opcional para não grudar nas bordas se necessário
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Lado Esquerdo: Checkbox + Texto
          Row(
            children: [
              Checkbox(
                value: markedBox,
                activeColor: const Color(0xFFB71C1C), // Vermelho padrão
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                side: const BorderSide(color: Colors.grey, width: 1.5),
                onChanged: (value) {
                  setState(() {
                    markedBox = value!;
                    widget.onPressed();
                  });
                },
              ),
              // Usa o texto passado por parâmetro (widget.text)
              GestureDetector(
                onTap: widget.onTextTap,
                child: Text(
                  widget.text, 
                  style: TextStyle(
                    fontSize: 15,
                    color: widget.onTextTap != null ? const Color(0xFFB71C1C) : Colors.black,
                    fontWeight: widget.onTextTap != null ? FontWeight.bold : FontWeight.normal,
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