import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

import '../models/song_model.dart';

class ApiService {
  // ✅ IMPORTANT: apna PC ka IP yahan lagao
  static const String baseUrl = "http://192.168.1.101:8080";

  static Future<List<Song>> fetchSongs() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/songs'));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return (data as List).map((e) => Song.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load songs");
      }
    } catch (e) {
      print("❌ Error fetching songs: $e");
      return [];
    }
  }

  static Future<bool> uploadSong({
    required String title,
    required String artist,
    required String cover,
    required Uint8List fileBytes,
  }) async {
    try {
      final base64File = base64Encode(fileBytes);

      final res = await http.post(
        Uri.parse('$baseUrl/upload'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "title": title,
          "artist": artist,
          "cover": cover,
          "file": base64File,
        }),
      );

      return res.statusCode == 200;
    } catch (e) {
      print("❌ Upload Error: $e");
      return false;
    }
  }
}