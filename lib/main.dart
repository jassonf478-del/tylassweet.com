import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const TylasSweetApp());
}

class TylasSweetApp extends StatelessWidget {
  const TylasSweetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tylas Sweet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF48FB1),
          primary: const Color(0xFFEC407A),
        ),
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

  // URL del stream de La Radio del Momento
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
      debugPrint("Error de radio: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
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
            const SnackBar(content: Text("Error al conectar con la radio")),
          );
        }
      }
      setState(() => _isLoading = false);
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      body: SafeArea(
        child: Column(
          children: [
            // --- LOGO MAXIMIZADO (35% de la pantalla) ---
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Image.asset(
                "assets/images/logo.png",
                height: screenHeight * 0.35,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.cake, size: 100, color: Colors.pink),
              ),
            ),

            // --- REPRODUCTOR DE RADIO ESTILO CÁPSULA ---
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10)
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isLoading)
                    const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.pink))
                  else
                    Icon(Icons.radio,
                        color: _isPlaying ? Colors.red : Colors.grey, size: 20),
                  const SizedBox(width: 15),
                  const Text("RADIO EN VIVO",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: Icon(
                        _isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        color: Colors.pink,
                        size: 40),
                    onPressed: _toggleRadio,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // --- BOTONES DE MENÚ ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _navBtn("Pasteles", 0),
                const SizedBox(width: 15),
                _navBtn("Postres", 1),
              ],
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Divider(indent: 80, endIndent: 80, color: Colors.black12),
            ),

            // --- GRIDS DE CONTENIDO ---
            Expanded(
              child: _selectedIndex == 0
                  ? const CatalogGrid()
                  : const Center(
                      child: Text(
                      "Sección de Postres Próximamente",
                      style: TextStyle(color: Colors.grey),
                    )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navBtn(String label, int index) {
    bool isSelected = _selectedIndex == index;
    return ElevatedButton(
      onPressed: () => setState(() => _selectedIndex = index),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.pink : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.pink,
        elevation: isSelected ? 4 : 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      child: Text(label),
    );
  }
}

class CatalogGrid extends StatelessWidget {
  const CatalogGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 12),
      itemCount: 15, // Cambia esto según cuántas fotos tengas
      itemBuilder: (context, i) => ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          "assets/images/postre (${i + 1}).jpeg",
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => Container(
            color: Colors.pink.withValues(alpha: 0.05),
            child: const Icon(Icons.image_not_supported,
                color: Colors.pink, size: 20),
          ),
        ),
      ),
    );
  }
}
