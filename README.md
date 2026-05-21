# Fadir - Event Management Flutter Application

A secure Flutter application for event management with integrated Supabase backend.

## Security Features

This application implements industry-standard security practices:

- **Secure Storage**: Sensitive data (tokens, user credentials) encrypted using `flutter_secure_storage`
- **Environment Variables**: API keys and URLs managed via `.env` files
- **Encrypted Session Management**: Supabase sessions stored securely
- **HTTPS Only**: All network communications use TLS/SSL
- **Code Obfuscation**: Release builds use Dart code obfuscation
- **Minimal Permissions**: Android and iOS permissions limited to necessary features only

## Getting Started

### Prerequisites

- Flutter SDK (^3.7.2)
- Dart SDK
- Android Studio / Xcode (for mobile development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/PittViic/fadir.git
   cd fadir
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Environment Variables**
   
   Copy the example environment file:
   ```bash
   cp .env.example .env
   ```
   
   Edit `.env` and add your credentials:
   ```env
   SUPABASE_URL=your_supabase_project_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   BACKEND_BASE_URL=your_backend_api_url
   ```
   
   ⚠️ **Important**: 
   - Never commit the `.env` file to version control!
   - For production builds, use `--dart-define` flags instead of `.env` files
   - See [ENV_CONFIG.md](ENV_CONFIG.md) for production deployment details

4. **Run the application**
   ```bash
   flutter run
   ```

## Building for Production

For production builds with security hardening, use the following commands:

### Android (Recommended with dart-define)
```bash
# APK with obfuscation and injected environment variables
flutter build apk --release \
  --obfuscate \
  --split-debug-info=build/app/outputs/symbols \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your_key \
  --dart-define=BACKEND_BASE_URL=https://your-backend.com

# App Bundle (recommended for Play Store)
flutter build appbundle --release \
  --obfuscate \
  --split-debug-info=build/app/outputs/symbols \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your_key \
  --dart-define=BACKEND_BASE_URL=https://your-backend.com
```

### iOS
```bash
flutter build ios --release \
  --obfuscate \
  --split-debug-info=build/ios/symbols \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your_key \
  --dart-define=BACKEND_BASE_URL=https://your-backend.com
```

⚠️ **Production Security Note**: 
- For development, you can use the `.env` file
- For production, **always** use `--dart-define` to inject secrets at build time
- Never include `.env` in app assets
- See [ENV_CONFIG.md](ENV_CONFIG.md) for detailed production deployment guide
- See [BUILD_SECURITY.md](BUILD_SECURITY.md) for additional security configuration

## Security Setup

### Secure Storage

This app uses `flutter_secure_storage` for encrypting sensitive data:
- User credentials
- Authentication tokens
- Session information
- User preferences

### Supabase Configuration

Supabase is configured with secure session storage:
- Sessions encrypted at rest using `flutter_secure_storage`
- No plain-text credentials in SharedPreferences
- Automatic token refresh with secure persistence

### Environment Variables

All sensitive configuration is managed through environment variables:
- Supabase URL and API keys
- Backend API endpoints
- No hardcoded credentials in source code

## Project Structure

```
lib/
├── main.dart                 # App entry point with secure Supabase init
├── models/                   # Data models
├── providers/                # State management
├── screens/                  # UI screens
├── services/
│   ├── auth_service.dart     # Authentication logic
│   ├── secure_storage_service.dart  # Secure storage wrapper
│   └── ...
├── utils/
│   └── api_constants.dart    # API endpoints from env vars
└── widgets/                  # Reusable UI components
```

## Dependencies

Main packages:
- `supabase_flutter`: ^2.3.4 - Backend and storage
- `flutter_secure_storage`: ^9.2.2 - Encrypted local storage
- `flutter_dotenv`: ^5.2.1 - Environment variable management
- `provider`: ^6.0.5 - State management
- `http`: ^1.2.0 - HTTP client

See [pubspec.yaml](pubspec.yaml) for complete list.

## Platform-Specific Notes

### Android
- Minimum permissions configured in AndroidManifest.xml
- Internet permission required for API calls
- Secure storage uses EncryptedSharedPreferences

### iOS
- Privacy descriptions added for camera and photo library access
- Keychain used for secure storage
- App Transport Security enforces HTTPS

## Security Best Practices

1. **Never commit sensitive data**
   - `.env` is in `.gitignore`
   - Use `.env.example` as template

2. **Keep dependencies updated**
   ```bash
   flutter pub upgrade
   ```

3. **Review permissions**
   - Check AndroidManifest.xml
   - Check Info.plist

4. **Use obfuscation for releases**
   - Always build with `--obfuscate` flag
   - Store debug symbols securely

5. **Validate user input**
   - Email format validation
   - Password strength requirements
   - Sanitize data before API calls

## Support

For issues and questions:
- Open an issue on GitHub
- Contact: [Project maintainer]

## License

[Add your license information here]

---

For detailed security build configuration, see [BUILD_SECURITY.md](BUILD_SECURITY.md).
