import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import '../lib/routes.dart';

void main() async {

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(_corsHeaders()) // ✅ CORS middleware add
      .addHandler(getRouter());

  // ✅ 0.0.0.0 use karo (important for web + mobile)
  await serve(handler, '0.0.0.0', 8080);

  print('🚀 Server running on http://192.168.1.101:8080');
}

// 🔥 CORS Middleware (VERY IMPORTANT)
Middleware _corsHeaders() {
  return (innerHandler) {
    return (request) async {

      // ✅ Handle preflight request
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
          'Access-Control-Allow-Headers': '*',
        });
      }

      final response = await innerHandler(request);

      return response.change(headers: {
        ...response.headers,
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
        'Access-Control-Allow-Headers': '*',
      });
    };
  };
}