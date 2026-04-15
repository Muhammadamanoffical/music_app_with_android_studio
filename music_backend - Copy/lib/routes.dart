import 'package:shelf_router/shelf_router.dart';

import 'controllers/song_controller.dart';
import 'controllers/upload_controller.dart';
import 'controllers/favorite_controller.dart';
import 'controllers/search_controller.dart';

Router getRouter() {
  final router = Router();

  // 🎵 SONGS
  router.get('/songs', SongController.getSongs);
  router.post('/add-song', SongController.addSong);

  // 📤 UPLOAD
  router.post('/upload', UploadController.uploadSong);

  // ❤️ FAVORITES
  router.post('/favorite', FavoriteController.addFavorite);

  // 🔍 SEARCH
  router.get('/search', SearchController.searchSongs);

  return router;
}