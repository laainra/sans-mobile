import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://10.3.43.4:9000';

  Future<String?> login(String username, String password) async {
    final client = http.Client();
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/api/auth/signin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['accessToken'];
      } else {
        throw Exception('Login failed. Status code: ${response.statusCode}');
      }
    } on SocketException catch (error) {
      throw Exception(
          'Network error: Check your internet connection. ($error)'); // Include error details
    } on HttpException catch (error) {
      throw Exception(
          'Error during login: Status code: ${error} - ${error.message}'); // Include status code and message if available
    } on FormatException catch (error) {
      throw Exception(
          'Invalid server response format. ($error)'); // Handle potential JSON parsing issues
    } catch (error) {
      throw Exception(
          'An unexpected error occurred: $error'); // Still catch other unexpected errors
    }
  }
}
