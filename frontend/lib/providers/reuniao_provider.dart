import 'package:flutter/material.dart';
import '../models/reuniao_model.dart';
import '../services/reuniao_service.dart';

class ReuniaoProvider with ChangeNotifier {
  final ReuniaoService _service = ReuniaoService();

  ReuniaoModel? _proximaReuniao;
  List<ReuniaoModel> _historico = [];
  bool _isLoading = false;
  String? _erro;

  ReuniaoModel? get proximaReuniao => _proximaReuniao;
  List<ReuniaoModel> get historico => _historico;
  bool get isLoading => _isLoading;
  String? get erro => _erro;

  Future<void> carregarHome() async {
    _isLoading = true;
    _erro = null;
    notifyListeners();

    try {
      _proximaReuniao = await _service.getProximaReuniao();    
    } catch (e) {
      _erro = e.toString();
      _proximaReuniao = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> carregarHistorico() async {
    _isLoading = true;
    _erro = null; // Limpa o erro ao tentar carregar novamente
    notifyListeners();
    try {
      _historico = await _service.getHistorico();
    } catch (e) {
      _erro = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> criarReuniao(ReuniaoModel novaReuniao) async {
    _isLoading = true;
    _erro = null; // Importante limpar o erro antes de começar
    notifyListeners();

    try {
      // Chama o service que faz o POST para o Spring Boot
      await _service.criarReuniao(novaReuniao);
      
      // Após criar, atualiza a home para mostrar a reunião agendada
      await carregarHome(); 
      
    } catch (e) {
      _erro = e.toString();
      rethrow; // Repassa para a View mostrar o SnackBar vermelho
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Edita uma reunião existente
  Future<void> editarReuniao(ReuniaoModel reuniaoEditada) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Envia para o Java
      await _service.editarReuniao(reuniaoEditada);
      
      // Atualiza a variável local para a Home refletir a mudança na hora
      _proximaReuniao = reuniaoEditada;
      
      // (Opcional) Ou recarrega tudo do banco para garantir
      // await carregarHome(); 

    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}