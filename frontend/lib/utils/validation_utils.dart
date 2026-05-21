/// Input validation utilities for the application
class ValidationUtils {
  /// Email validation regex (RFC 5322 simplified)
  static final RegExp emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  /// URL validation regex
  static final RegExp urlRegex = RegExp(
    r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    caseSensitive: false,
  );

  /// Validates an email address
  /// 
  /// Returns `true` if the email is valid, `false` otherwise.
  static bool isValidEmail(String email) {
    return email.isNotEmpty && emailRegex.hasMatch(email);
  }

  /// Validates a URL
  /// 
  /// Returns `true` if the URL is valid, `false` otherwise.
  static bool isValidUrl(String url) {
    return url.isNotEmpty && urlRegex.hasMatch(url);
  }

  /// Validates file extension
  /// 
  /// Returns the extension if valid, throws exception otherwise.
  static String getValidatedFileExtension(
    String filePath,
    List<String> allowedExtensions,
  ) {
    final parts = filePath.split('.');
    if (parts.length < 2) {
      throw Exception('Arquivo sem extensão válida');
    }
    
    final extension = parts.last.toLowerCase();
    if (!allowedExtensions.contains(extension)) {
      throw Exception(
        'Formato de arquivo não suportado. Use: ${allowedExtensions.join(", ").toUpperCase()}',
      );
    }
    
    return extension;
  }

  /// Minimum password length
  static const int minPasswordLength = 6;

  /// Verification code length
  static const int verificationCodeLength = 6;
}
