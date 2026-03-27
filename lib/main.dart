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
      title: 'Tylas Sweet - Comayagua',
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

  final String radioUrl = "https://radio.worldkast.com:8034/stream";

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint("Error al abrir: $url");
    }
  }

  void _showOrderDialog(String dessertName) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFFF3E0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: const Column(
          // Añadido const para optimizar (Imagen 2000000.png)
          children: [
            Icon(Icons.cake_outlined, color: Color(0xFFD81B60), size: 40),
            SizedBox(height: 10),
            Text("Detalles del Pedido",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Postre: $dessertName",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Color(0xFF3E2723),
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            TextField(
                controller: nameController,
                decoration: const InputDecoration(
                    labelText: "Tu Nombre", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(
                controller: addressController,
                decoration: const InputDecoration(
                    labelText: "Dirección en Comayagua",
                    border: OutlineInputBorder())),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cerrar")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF43A047),
                foregroundColor: Colors.white),
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  addressController.text.isNotEmpty) {
                String msg =
                    "¡Hola Tylas Sweet! 🍰\nSoy: ${nameController.text}\nDirección: ${addressController.text}\nPedido: $dessertName\n¿Tienen disponible?";
                _launchURL(
                    "https://wa.me/50499656622?text=${Uri.encodeComponent(msg)}");
                Navigator.pop(context);
              }
            },
            child: const Text("Enviar a WhatsApp"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _toggleRadio() async {
    if (_isPlaying) {
      await _audioPlayer.stop();
      setState(() => _isPlaying = false);
    } else {
      setState(() => _isLoading = true);
      try {
        await _audioPlayer.setAudioSource(
          AudioSource.uri(Uri.parse(radioUrl)),
          preload: false,
        );
        _audioPlayer.play();
        setState(() {
          _isPlaying = true;
          _isLoading = false;
        });
      } catch (e) {
        debugPrint("Error de Radio: $e");
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3E2723), Color(0xFF1B0F0D)],
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(25),
                      child: Column(
                        // Añadido const (Imagen 2222222222222.png)
                        children: [
                          Text("REPOSTERÍA ARTESANAL PROFESIONAL",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFF8A80),
                                  letterSpacing: 1.5)),
                          SizedBox(height: 10),
                          Text(
                              "Calidad premium y entrega a domicilio en Comayagua.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xFFFFF3E0), fontSize: 13)),
                        ],
                      ),
                    ),
                    _selectedIndex == 0
                        ? DynamicGrid(
                            folder: "images",
                            prefix: "postre",
                            onOrder: _showOrderDialog)
                        : DynamicGrid(
                            folder: "postres",
                            prefix: "",
                            onOrder: _showOrderDialog),

                    // --- SECCIÓN DE COPYRIGHT ---
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          const Divider(
                              color: Colors.white10, indent: 50, endIndent: 50),
                          const SizedBox(height: 10),
                          const Text(
                              "© 2026 Tylas Sweet. Todos los derechos reservados.",
                              style: TextStyle(
                                  color: Colors.white38, fontSize: 11)),
                          const SizedBox(height: 4),
                          Text("By Jasson Flores | jassonf478@gmail.com",
                              style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // HEADER - CORREGIDO .withValues (Imagen 1999999.png)
            Positioned(
              top: 15,
              left: 10,
              right: 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withValues(alpha: 0.15), // Reemplazado withOpacity
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        Image.asset("assets/images/logo.png",
                            height: 35,
                            errorBuilder: (c, e, s) =>
                                const Icon(Icons.cake, color: Colors.pink)),
                        const SizedBox(width: 8),
                        _navBtn("Pasteles", 0),
                        _navBtn("Postres", 1),
                        const Spacer(),
                        _socialIcon(
                            Icons.facebook,
                            "https://facebook.com/tylassweet",
                            Colors.blue[300]!),
                        _socialIcon(
                            Icons.camera_alt,
                            "https://instagram.com/tylassweet",
                            Colors.purple[300]!),
                        _socialIcon(
                            Icons.music_note,
                            "https://www.tiktok.com/@tylas.sweet",
                            Colors.white),
                        const SizedBox(width: 5),
                        IconButton(
                            onPressed: _toggleRadio,
                            icon: _isLoading
                                ? const SizedBox(
                                    width: 15,
                                    height: 15,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.pink))
                                : Icon(
                                    _isPlaying
                                        ? Icons.pause_circle
                                        : Icons.play_circle,
                                    color: Colors.pink,
                                    size: 28)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialIcon(IconData icon, String url, Color col) => IconButton(
        visualDensity: VisualDensity.compact,
        icon: Icon(icon, color: col, size: 20),
        onPressed: () => _launchURL(url),
      );

  Widget _navBtn(String label, int index) {
    bool sel = _selectedIndex == index;
    return TextButton(
      onPressed: () => setState(() => _selectedIndex = index),
      child: Text(label,
          style: TextStyle(
              color: sel ? Colors.pink : Colors.white,
              fontSize: 13,
              fontWeight: sel ? FontWeight.bold : FontWeight.normal)),
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
    List<String> list = [];
    if (folder == "images") {
      list = List.generate(60, (i) => "$prefix (${i + 1}).jpeg");
    } else {
      list = ["chocoflan.png", "Cupcake-Dessert.png", "flan_napolitano.png"];
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: list.length,
      itemBuilder: (context, i) {
        return InkWell(
          onTap: () => onOrder(list[i]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                Positioned.fill(
                    child: Image.asset("assets/$folder/${list[i]}",
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) =>
                            Container(color: Colors.brown[900]))),
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                        color: Colors.green, shape: BoxShape.circle),
                    child: const Icon(Icons.chat_bubble_outline,
                        color: Colors.white, size: 12),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
