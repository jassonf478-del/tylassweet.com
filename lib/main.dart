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

  // FUNCIÓN PARA ABRIR WHATSAPP
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint("No se pudo abrir $url");
    }
  }

  // --- EL FORMULARIO QUE BUSCAMOS ---
  void _showOrderDialog(String dessertName) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController addressController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false, // Obliga a interactuar con el cuadro
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Detalles del Encargo",
            style: TextStyle(
                color: Color(0xFFEC407A), fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Para tu entrega en Comayagua, necesitamos:",
                style: TextStyle(fontSize: 13, color: Colors.black54)),
            const SizedBox(height: 15),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Tu Nombre completo",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person, size: 20),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: "Dirección de entrega",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on, size: 20),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  const Text("Cancelar", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEC407A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  addressController.text.isNotEmpty) {
                String message =
                    "Hola Tylas Sweet! Soy ${nameController.text}, vivo en ${addressController.text}. Quisiera encargar el postre: $dessertName";
                _launchURL(
                    "https://wa.me/50499656622?text=${Uri.encodeComponent(message)}");
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Por favor, completa todos los campos")));
              }
            },
            child: const Text("Enviar a WhatsApp"),
          ),
        ],
      ),
    );
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
        debugPrint(e.toString());
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
            padding: const EdgeInsets.only(top: 100, bottom: 80),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // --- RESEÑA PROFESIONAL ---
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    child: Column(
                      children: [
                        Text("REPOSTERÍA ARTESANAL PROFESIONAL",
                            style: TextStyle(
                                letterSpacing: 1.2,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink[800])),
                        const SizedBox(height: 8),
                        const Text(
                          "Ubicados en la Ciudad Colonial de Comayagua, Honduras. "
                          "En Tylas Sweet nos dedicamos a la creación de postres finos con "
                          "ingredientes seleccionados para garantizar el mejor sabor en tu mesa.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13, color: Colors.black87, height: 1.5),
                        ),
                        const Divider(height: 40, indent: 50, endIndent: 50),
                      ],
                    ),
                  ),

                  // --- GRILLA DE PRODUCTOS ---
                  _selectedIndex == 0
                      ? DynamicGrid(
                          folder: "images",
                          prefix: "postre",
                          onOrder: _showOrderDialog)
                      : DynamicGrid(
                          folder: "postres",
                          prefix: "",
                          onOrder: _showOrderDialog),
                ],
              ),
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
                              fontWeight: FontWeight.bold, color: Colors.pink)),
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

          // --- FOOTER REDES ---
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                border: Border(
                    top: BorderSide(color: Colors.pink.withValues(alpha: 0.1))),
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

  Widget _socialBtn(IconData icon, String url) => IconButton(
      icon: Icon(icon, color: Colors.pink[300]),
      onPressed: () => _launchURL(url));

  Widget _miniNavBtn(String label, int index) {
    bool sel = _selectedIndex == index;
    return TextButton(
        onPressed: () => setState(() => _selectedIndex = index),
        child: Text(label,
            style: TextStyle(
                color: sel ? Colors.pink : Colors.black54,
                fontWeight: sel ? FontWeight.bold : FontWeight.normal)));
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
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemCount: folder == "images" ? 40 : postresNuevos.length,
      itemBuilder: (context, i) {
        String name =
            folder == "images" ? "$prefix (${i + 1}).jpeg" : postresNuevos[i];
        return InkWell(
          onTap: () => onOrder(name), // AL TOCAR LA IMAGEN SALE EL FORMULARIO
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset("assets/$folder/$name",
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) =>
                          Container(color: Colors.pink[50])),
                ),
              ),
              Positioned(
                bottom: 5,
                right: 5,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                      color: Colors.green, shape: BoxShape.circle),
                  child: const Icon(Icons.add_shopping_cart,
                      color: Colors.white, size: 12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
