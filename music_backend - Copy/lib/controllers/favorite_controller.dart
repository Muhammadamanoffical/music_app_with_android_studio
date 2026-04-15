import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../db.dart';

class FavoriteController {
  static Future<Response> addFavorite(Request req) async {
    final conn = await connectDB();
    final body = await req.readAsString();
    final data = jsonDecode(body);

    await conn.query(
      "INSERT INTO favorites (song_id, title, artist, url) VALUES (?, ?, ?, ?)",
      [data['id'], data['title'], data['artist'], data['url']],
    );

    return Response.ok(
      jsonEncode({"message": "Added to favorites ❤️"}),
    );
  }
}