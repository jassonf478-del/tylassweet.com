import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';

void main() => runApp(const TylasSweetApp());

class TylasSweetApp extends StatelessWidget {
  const TylasSweetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tylas Sweet - Repostería & Radio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF48FB1),
          primary: const Color(0xFFEC407A),
          surface: const Color(0xFFFFF8F0),
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

  // URL de tu Stream de Radio
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
      debugPrint("Error cargando radio: $e");
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
            const SnackBar(content: Text("Error de conexión con la radio.")),
          );
        }
      }
      setState(() => _isLoading = false);
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  List<Color> _getDailyGradient() {
    int day = DateTime.now().weekday;
    if (day == 5)
      return [const Color(0xFFFCE4EC), const Color(0xFFF8BBD0)]; // Viernes
    return [const Color(0xFFFFF8F0), Colors.white];
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _getDailyGradient(),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // --- LOGO MAXIMIZADO ---
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Image.asset(
                  "assets/images/logo.png",
                  height: screenHeight * 0.32,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stack) =>
                      const Icon(Icons.cake, size: 80, color: Colors.pink),
                ),
              ),

              // --- REPRODUCTOR DE RADIO ---
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.pink.withValues(alpha: 0.1),
                        blurRadius: 10)
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : Icon(Icons.radio,
                            color: _isPlaying ? Colors.red : Colors.grey,
                            size: 22),
                    const SizedBox(width: 15),
                    const Text("RADIO EN VIVO",
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 15),
                    IconButton(
                      icon: Icon(
                          _isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          color: Colors.pink,
                          size: 38),
                      onPressed: _toggleRadio,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // --- MENÚ DE NAVEGACIÓN ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _navBtn("Pasteles", Icons.cake, 0),
                  const SizedBox(width: 15),
                  _navBtn("Postres", Icons.icecream, 1),
                ],
              ),

              const Divider(
                  indent: 60, endIndent: 60, height: 40, color: Colors.black12),

              // --- CONTENIDO ---
              Expanded(
                child: _selectedIndex == 0
                    ? const CatalogGrid()
                    : const DessertsGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navBtn(String label, IconData icon, int index) {
    bool sel = _selectedIndex == index;
    return ElevatedButton.icon(
      onPressed: () => setState(() => _selectedIndex = index),
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: sel ? Colors.pink : Colors.white,
        foregroundColor: sel ? Colors.white : Colors.pink,
        elevation: sel ? 4 : 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

// --- GRIDS DE FOTOS ---
class CatalogGrid extends StatelessWidget {
  const CatalogGrid({super.key});
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemCount: 20, // Ajusta según tus fotos
      itemBuilder: (context, i) => ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset("assets/images/postre (${i + 1}).jpeg",
            fit: BoxFit.cover),
      ),
    );
  }
}

class DessertsGrid extends StatelessWidget {
  const DessertsGrid({super.key});
  @override
  Widget build(BuildContext context) {
    // Para que no falle, usamos las fotos 1 a 6 como ejemplo
    return GridView.builder(
      padding: const EdgeInsets.all(15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemCount: 6,
      itemBuilder: (context, i) => Card(
        child: Column(
          children: [
            Expanded(
                child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.asset("assets/images/postre (${i + 1}).jpeg",
                  fit: BoxFit.cover, width: double.infinity),
            )),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Postre Especial",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}
