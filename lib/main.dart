import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';

void main() => runApp(const TylasSweetApp());

class TylasSweetApp extends StatelessWidget {
  const TylasSweetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tylas Sweet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF48FB1)),
        textTheme: GoogleFonts.quicksandTextTheme(),
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = false;

  final String radioUrl = "https://laradiodelmomento.com/stream";

  @override
  void initState() {
    super.initState();
    _initRadio();
  }

  Future<void> _initRadio() async {
    try {
      await _audioPlayer.setUrl(radioUrl);
    } catch (e) {
      debugPrint("Error Radio: $e");
    }
  }

  void _toggleRadio() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      setState(() => _isLoading = true);
      try {
        await _audioPlayer.play();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error de conexión")),
          );
        }
      }
      setState(() => _isLoading = false);
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      body: Stack(
        children: [
          // --- CONTENIDO CON ANIMACIÓN ---
          Padding(
            padding: const EdgeInsets.only(top: 90),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: _selectedIndex == 0
                  ? const DynamicGrid(
                      key: ValueKey(0), folder: "images", prefix: "postre")
                  : const DynamicGrid(
                      key: ValueKey(1), folder: "postres", prefix: ""),
            ),
          ),

          // --- HEADER GLASS INTEGRADO ---
          Positioned(
            top: 15,
            left: 15,
            right: 15,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(50),
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      Image.asset("assets/images/logo.png",
                          height: 40,
                          errorBuilder: (c, e, s) =>
                              const Icon(Icons.cake, color: Colors.pink)),
                      const SizedBox(width: 10),
                      Text("Tylas Sweet",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.pink[800])),
                      const Spacer(),
                      _miniNavBtn("Pasteles", 0),
                      _miniNavBtn("Postres", 1),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _toggleRadio,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 15,
                                height: 15,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2))
                            : Icon(
                                _isPlaying
                                    ? Icons.pause_circle
                                    : Icons.play_circle,
                                color: Colors.pink,
                                size: 30),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniNavBtn(String label, int index) {
    bool isSelected = _selectedIndex == index;
    return TextButton(
      onPressed: () => setState(() => _selectedIndex = index),
      child: Text(label,
          style: TextStyle(
              color: isSelected ? Colors.pink : Colors.black54,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
    );
  }
}

class DynamicGrid extends StatelessWidget {
  final String folder;
  final String prefix;
  const DynamicGrid({super.key, required this.folder, required this.prefix});

  @override
  Widget build(BuildContext context) {
    // Lista exacta de tus nuevos archivos en assets/postres
    final List<String> postresNuevos = [
      "chocoflan.png",
      "chocoflan.jpg",
      "Cupcake-Dessert.png",
      "flan_napolitano.png"
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: folder == "images" ? 60 : postresNuevos.length,
      itemBuilder: (context, i) {
        String path = folder == "images"
            ? "assets/$folder/$prefix (${i + 1}).jpeg"
            : "assets/$folder/${postresNuevos[i]}";

        return ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(path,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink()),
        );
      },
    );
  }
}
