import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../utils/validation_utils.dart';

class UploadService {
  static final SupabaseClient _client = Supabase.instance.client;
  static const String _bucket = 'posts';

  // Faz upload do arquivo e retorna a URL pública
  static Future<String> uploadFile(File file) async {
    if (!await file.exists()) {
      throw Exception('Arquivo não encontrado');
    }

    // Limite de 10MB
    final fileSize = await file.length();
    const maxSize = 10 * 1024 * 1024;
    if (fileSize > maxSize) {
      throw Exception('Arquivo muito grande. Máximo 10MB.');
    }

    // Validação de extensão
    const allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
    final extensaoArquivo = ValidationUtils.getValidatedFileExtension(
      file.path,
      allowedExtensions,
    );

    final stringAleatoria = const Uuid().v4();
    final path = '$stringAleatoria.$extensaoArquivo';

    try {
      await _client.storage.from(_bucket).upload(
            path,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      return _client.storage.from(_bucket).getPublicUrl(path);
    } on StorageException catch (e) {
      throw Exception('Erro no armazenamento: ${e.message}');
    } catch (e) {
      throw Exception('Erro ao fazer upload. Verifique sua conexão.');
    }
  }
}
