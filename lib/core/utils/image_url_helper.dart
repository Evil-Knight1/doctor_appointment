import 'package:doctor_appointment/core/config/app_config.dart';
import 'package:doctor_appointment/core/services/service_locator.dart';

class ImageUrlHelper {
  static String getFullUrl(String? path) {
    if (path == null || path.isEmpty) {
      return '';
    }
    
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    final String apiUrl = getIt<AppConfig>().apiUrl;
    
    // Remove trailing /api/ or /api if present in the base url
    // because images are usually served from the root (e.g. /Images/...)
    String baseDomain = apiUrl;
    if (baseDomain.endsWith('/api/')) {
      baseDomain = baseDomain.substring(0, baseDomain.length - 5);
    } else if (baseDomain.endsWith('/api')) {
      baseDomain = baseDomain.substring(0, baseDomain.length - 4);
    } else if (baseDomain.endsWith('/')) {
      baseDomain = baseDomain.substring(0, baseDomain.length - 1);
    }

    if (path.startsWith('/')) {
      return '$baseDomain$path';
    } else {
      return '$baseDomain/$path';
    }
  }
}
