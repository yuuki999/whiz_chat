import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';

  // User endpoints
  static const String getUser = '/consumer/user';
  static const String updateUser = '/consumer/user';

  // Chat endpoints
  static const String getMessages = '/chat/messages';
  static const String sendMessage = '/chat/messages';

  static String fullUrl(String endpoint) => dotenv.env['API_BASE_URL']! + endpoint;
}