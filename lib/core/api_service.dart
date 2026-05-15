import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  static String get baseUrl {
    const configuredUrl = String.fromEnvironment('API_BASE_URL');
    if (configuredUrl.isNotEmpty) return configuredUrl;
    if (kIsWeb) return 'http://localhost:3000';
    return 'http://10.0.2.2:3000';
  }

  // Lưu Token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Lưu thông tin người dùng
  static Future<void> saveUserInfo(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', user['name'] ?? '');
    await prefs.setString('user_email', user['email'] ?? '');
    await prefs.setString('user_avatar', user['avatar'] ?? '');
  }

  // Lấy thông tin người dùng
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }

  static Future<String?> getUserAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_avatar');
  }

  // Lấy Token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Xóa Token (Logout)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    await prefs.remove('user_avatar');
  }

  // Header chung
  static Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // API 1: Đăng nhập
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await saveToken(data['token']);
      await saveUserInfo(data);
      return data;
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Đăng nhập thất bại');
    }
  }

  // API 2: Đăng ký
  static Future<Map<String, dynamic>> signup(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      await saveToken(data['token']);
      await saveUserInfo(data);
      return data;
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Đăng ký thất bại');
    }
  }

  // API 3: Cập nhật người dùng
  static Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.patch(
      Uri.parse('$baseUrl/auth/update'),
      headers: headers,
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      final updatedUser = jsonDecode(response.body);
      await saveUserInfo(updatedUser); // Update local storage
      return updatedUser;
    } else {
      throw Exception('Cập nhật thất bại');
    }
  }

  // API 4: Lấy danh sách người dùng
  static Future<List<dynamic>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/api/users'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Không thể lấy danh sách người dùng');
    }
  }

  // API 5: Lấy tin tức
  static Future<List<dynamic>> getNews() async {
    final response = await http.get(Uri.parse('$baseUrl/api/news'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Không thể lấy tin tức');
    }
  }

  // API 6: Lấy danh sách Tour
  static Future<List<dynamic>> getTours() async {
    final response = await http.get(Uri.parse('$baseUrl/api/tours'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Không thể lấy danh sách tour');
    }
  }

  // API 7: Lấy danh sách chuyến đi của tôi
  static Future<List<dynamic>> getMyTrips() async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/api/trips'), headers: headers);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Không thể lấy danh sách chuyến đi');
    }
  }

  // API 8: Tạo chuyến đi mới
  static Future<Map<String, dynamic>> createTrip(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/api/trips'),
      headers: headers,
      body: jsonEncode(data),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Không thể tạo chuyến đi');
    }
  }

  // API 9: Chi tiết chuyến đi
  static Future<Map<String, dynamic>> getTripDetail(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/api/trips/$id'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Không thể lấy chi tiết chuyến đi');
    }
  }

  // API 10: Lấy danh sách hội thoại
  static Future<List<dynamic>> getConversations() async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/api/chat/conversations'), headers: headers);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Không thể lấy danh sách hội thoại');
    }
  }

  // API 11: Tạo hội thoại
  static Future<Map<String, dynamic>> createConversation(String participantId) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/api/chat/conversations'),
      headers: headers,
      body: jsonEncode({'participantId': participantId}),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Không thể tạo hội thoại');
    }
  }

  // API 12: Lấy tin nhắn
  static Future<List<dynamic>> getMessages(String conversationId) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/api/chat/messages?conversationId=$conversationId'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Không thể lấy tin nhắn');
    }
  }

  // API 13: Gửi tin nhắn
  static Future<Map<String, dynamic>> sendMessage(String conversationId, String text) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/api/chat/messages'),
      headers: headers,
      body: jsonEncode({'conversationId': conversationId, 'text': text}),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Không thể gửi tin nhắn');
    }
  }

  // API 14: Upload file
  static Future<String> uploadFile(Uint8List fileBytes, String fileName) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/api/upload'));
    request.files.add(http.MultipartFile.fromBytes(
      'file',
      fileBytes,
      filename: fileName,
    ));
    
    var response = await request.send();
    if (response.statusCode == 200) {
      final resBody = await response.stream.bytesToString();
      return jsonDecode(resBody)['url'];
    } else {
      throw Exception('Upload ảnh thất bại');
    }
  }
}
