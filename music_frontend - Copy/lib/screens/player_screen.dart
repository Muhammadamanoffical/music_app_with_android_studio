
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song_model.dart';
import '../services/favorite_service.dart';

class PlayerScreen extends StatefulWidget {
  final Song song;

  const PlayerScreen({super.key, required this.song});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with SingleTickerProviderStateMixin {
  final AudioPlayer player = AudioPlayer();

  bool loading = true;
  bool isFav = false;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    initSong();
    checkFav();
  }

  // 🔥 FIXED AUDIO INIT (STABLE + SAFE)
  Future<void> initSong() async {
    try {
      setState(() => loading = true);

      print("🎵 PLAY URL: ${widget.song.url}");

      await player.stop();

      await player.setAudioSource(
        AudioSource.uri(Uri.parse(widget.song.url)),
      );

      await player.load();

      if (!mounted) return;

      setState(() => loading = false);

      await player.play(); // autoplay

    } catch (e) {
      print("❌ AUDIO ERROR: $e");
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> checkFav() async {
    isFav = await FavoriteService.isFavorite(widget.song.url);
    if (mounted) setState(() {});
  }

  void togglePlay() async {
    try {
      if (player.playing) {
        await player.pause();
        _controller.reverse();
      } else {
        await player.play();
        _controller.forward();
      }
      setState(() {});
    } catch (e) {
      print("❌ PLAY ERROR: $e");
    }
  }

  void toggleFav() async {
    await FavoriteService.toggleFavorite(widget.song.url);
    isFav = !isFav;
    setState(() {});
  }

  @override
  void dispose() {
    player.stop(); // 🔥 important fix
    player.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      // 🔥 FIXED UI (NO DISAPPEARING SCREEN BUG)
      body: Stack(
        children: [
          // BACKGROUND
          Positioned.fill(
            child: Image.network(
              widget.song.cover,
              fit: BoxFit.cover,
            ),
          ),

          // BLUR
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                color: Colors.black.withOpacity(0.7),
              ),
            ),
          ),

          SafeArea(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      const SizedBox(height: 10),

                      // TOP BAR
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.keyboard_arrow_down,
                                color: Colors.white, size: 30),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: toggleFav,
                            child: Icon(
                              isFav
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFav ? Colors.red : Colors.white,
                            ),
                          ),
                          const SizedBox(width: 15),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // COVER
                      Hero(
                        tag: widget.song.url,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            widget.song.cover,
                            height: 260,
                            width: 260,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      Text(
                        widget.song.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        widget.song.artist,
                        style: const TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 40),

                      // PLAY BUTTON
                      GestureDetector(
                        onTap: togglePlay,
                        child: Container(
                          width: 75,
                          height: 75,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1DB954),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            player.playing
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.black,
                            size: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}