# Guia de Segurança de Ambiente e Build

Este documento consolida configuração de ambiente e práticas de build seguro para evitar vazamento de segredos e reduzir riscos de engenharia reversa.

## Aviso crítico sobre variáveis de ambiente
- O arquivo `.env` é carregado apenas em desenvolvimento e **não** deve ir para o bundle.
- Para produção, injete valores em tempo de build (`--dart-define`) ou via pipeline de CI/CD.
- `.env` já está no `.gitignore`; nunca o versione.

## Configuração de ambiente (dev)
1. Copie o template: `cp .env.example .env`.
2. Preencha credenciais reais em `.env`:
   ```env
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_ANON_KEY=your_actual_anon_key_here
   BACKEND_BASE_URL=https://your-backend.com
   ```
3. Garanta que o carregamento via `flutter_dotenv` ocorre antes do uso das variáveis durante o desenvolvimento.

## Deploy para produção (recomendado)
Use `--dart-define` para injetar valores em tempo de build:
```bash
flutter build apk --release \
  --obfuscate \
  --split-debug-info=build/app/outputs/symbols \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your_key \
  --dart-define=BACKEND_BASE_URL=https://your-backend.com
```
No código, leia com `String.fromEnvironment`:
```dart
static const supabaseUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: '');
static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');
```

## Integração CI/CD (exemplo GitHub Actions)
```yaml
- name: Build APK
  run: |
    flutter build apk --release \
      --obfuscate \
      --split-debug-info=build/app/outputs/symbols \
      --dart-define=SUPABASE_URL=${{ secrets.SUPABASE_URL }} \
      --dart-define=SUPABASE_ANON_KEY=${{ secrets.SUPABASE_ANON_KEY }} \
      --dart-define=BACKEND_BASE_URL=${{ secrets.BACKEND_BASE_URL }}
```

## Remoção de dependência de .env em produção
1. Remova `dotenv.load` em `main.dart` para builds de produção.
2. Troque todas as leituras para `String.fromEnvironment`.
3. Sempre inclua `--dart-define` no build.
4. Avalie remover `flutter_dotenv` se não for mais usado.

## Boas práticas de segredos
- Use credenciais distintas para dev/staging/prod e rotacione chaves periodicamente.
- Não exponha tokens em logs, commits ou assets.
- Monitore vazamentos com secret scanning (ex.: GitHub).
- Prefira canais privados para discutir segurança.

## Builds seguros

### Comandos recomendados
- Android APK: `flutter build apk --release --obfuscate --split-debug-info=build/app/outputs/symbols`
- Android App Bundle: `flutter build appbundle --release --obfuscate --split-debug-info=build/app/outputs/symbols`
- iOS: `flutter build ios --release --obfuscate --split-debug-info=build/ios/symbols`
- Web: `flutter build web --release`

### Por que usar obfuscation e split-debug-info
- `--obfuscate`: embaralha o código Dart e dificulta engenharia reversa.
- `--split-debug-info`: separa símbolos de debug do binário, reduz o tamanho do app e auxilia em simbolização de crash.

### Armazenamento de símbolos
- Android: `build/app/outputs/symbols/`
- iOS: `build/ios/symbols/`
- Guarde esses artefatos para analisar crash reports e simbolizar stack traces.

### Hardening adicional
- ProGuard/R8 (Android):
  ```gradle
  buildTypes {
      release {
          minifyEnabled true
          shrinkResources true
          proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
      }
  }
  ```
- Assinatura: use keystore/certificados de release corretos, não versione chaves; prefira Play App Signing no Android.
- Cert pinning e TLS atuais para endpoints de backend.

## Solução de problemas
- App falha por configuração ausente: verifique existência de `.env` em dev ou flags `--dart-define` em prod.
- Variáveis não carregam em dev: confirme `await dotenv.load(fileName: ".env");` antes do uso e que o arquivo está na raiz.
- Build de produção falha: migre para `--dart-define` e confira secrets no CI/CD.

## Checklist rápido
- `.env` fora do controle de versão e não empacotado como asset.
- `--dart-define` usado em builds de distribuição.
- Símbolos de debug armazenados em local seguro.
- ProGuard/R8 e shrinkResources habilitados em release.
- Segredos separados por ambiente e rotacionados regularmente.
