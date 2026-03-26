import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint("No se pudo abrir $url");
    }
  }

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
            const SnackBar(content: Text("Error de conexión con la radio")),
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
          // --- CONTENIDO ---
          Padding(
            padding: const EdgeInsets.only(top: 90, bottom: 60),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: _selectedIndex == 0
                  ? DynamicGrid(
                      key: const ValueKey(0),
                      folder: "images",
                      prefix: "postre",
                      onOrder: _launchURL)
                  : DynamicGrid(
                      key: const ValueKey(1),
                      folder: "postres",
                      prefix: "",
                      onOrder: _launchURL),
            ),
          ),

          // --- HEADER GLASS ---
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
                      const Text("Tylas Sweet",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.pink)),
                      const Spacer(),
                      _miniNavBtn("Pasteles", 0),
                      _miniNavBtn("Postres", 1),
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

          // --- FOOTER REDES SOCIALES ---
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.white.withValues(alpha: 0.9)
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _socialBtn(Icons.facebook, "https://facebook.com/tylassweet"),
                  _socialBtn(
                      Icons.camera_alt, "https://instagram.com/tylassweet"),
                  _socialBtn(
                      Icons.music_note, "https://www.tiktok.com/@tylas.sweet"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialBtn(IconData icon, String url) {
    return IconButton(
      icon: Icon(icon, color: Colors.pink[300], size: 28),
      onPressed: () => _launchURL(url),
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
  final Function(String) onOrder;

  const DynamicGrid(
      {super.key,
      required this.folder,
      required this.prefix,
      required this.onOrder});

  @override
  Widget build(BuildContext context) {
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
      itemCount: folder == "images" ? 50 : postresNuevos.length,
      itemBuilder: (context, i) {
        String fileName =
            folder == "images" ? "$prefix (${i + 1}).jpeg" : postresNuevos[i];
        String path = "assets/$folder/$fileName";

        return Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(path,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox.shrink()),
              ),
            ),
            // Botón de encargo
            Positioned(
              bottom: 8,
              right: 8,
              child: InkWell(
                onTap: () => onOrder(
                    "https://wa.me/50499656622?text=Hola! Quiero encargar el postre: $fileName"),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                      color: Colors.green, shape: BoxShape.circle),
                  child: const Icon(Icons.chat_bubble_outline,
                      color: Colors.white, size: 18), // Icono corregido
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
