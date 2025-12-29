class Env {
  static const bool isProd = false;

  static String get baseUrl {
    if (isProd) {
      return 'https://your-production-domain.com/api';
    } else {
      return 'http://localhost:6969/api';
    }
  }
}
