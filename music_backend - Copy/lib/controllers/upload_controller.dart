import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:uuid/uuid.dart';
import '../db.dart';

class UploadController {
  static Future<Response> uploadSong(Request request) async {
    try {
      final conn = await connectDB();

      final body = await request.readAsString();
      final data = jsonDecode(body);

      // ✅ VALIDATION
      if (data['file'] == null ||
          data['title'] == null ||
          data['artist'] == null ||
          data['cover'] == null) {
        return Response.badRequest(
          body: jsonEncode({"error": "Missing fields"}),
        );
      }

      final String title = data['title'];
      final String artist = data['artist'];
      final String cover = data['cover'];
      final String fileContent = data['file'];

      // ✅ FIX BASE64 CLEANING
      final cleanBase64 = fileContent.split(',').last;

      final bytes = base64Decode(cleanBase64);

      final fileName = const Uuid().v4() + ".mp3";
      final savedPath = "C:/xampp/htdocs/music/$fileName";

      final file = File(savedPath);
      await file.writeAsBytes(bytes);

      final url = "http://192.168.1.101/music/$fileName";

      await conn.query(
        "INSERT INTO songs (title, artist, url, cover) VALUES (?, ?, ?, ?)",
        [title, artist, url, cover],
      );

      return Response.ok(
        jsonEncode({
          "message": "Upload successful",
          "url": url
        }),
        headers: {"Content-Type": "application/json"},
      );
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({"error": e.toString()}),
      );
    }
  }
}