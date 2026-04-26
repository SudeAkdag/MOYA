import 'package:flutter_dotenv/flutter_dotenv.dart';

class AzureConfig {
  static String get fullUrl {
    return dotenv.env['AZURE_OPENAI_FULL_URL'] ?? '';
  }

  static String get endpoint {
    return dotenv.env['AZURE_OPENAI_ENDPOINT'] ?? '';
  }

  static String get apiKey {
    return dotenv.env['AZURE_OPENAI_KEY'] ?? '';
  }

  static String get deployment {
    return dotenv.env['AZURE_OPENAI_DEPLOYMENT'] ?? '';
  }

  static bool get isValid {
    return apiKey.isNotEmpty &&
        (fullUrl.isNotEmpty ||
            (endpoint.isNotEmpty && deployment.isNotEmpty));
  }
}