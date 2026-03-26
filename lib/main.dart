import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart'; // Si no la tienes, usaremos animaciones nativas de Flutter

void main() => runApp(const TylasSweetApp());

class TylasSweetApp extends StatelessWidget {
  const TylasSweetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tylas Sweet - Repostería Premium',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF48FB1),
          primary: const Color(0xFFEC407A),
          secondary: const Color(0xFFD4AF37), // Dorado para bordes premium
          surface: Colors.white,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Función para WhatsApp
  Future<void> _launchWhatsApp() async {
    final Uri url = Uri.parse(
        "https://wa.me/50499656622?text=Hola! Vi tu catálogo web y quiero una cotización.");
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Tylas Sweet",
            style: GoogleFonts.pacifico(fontSize: 30, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.pink.withOpacity(0.7),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pinkAccent, Colors.orangeAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildAnimatedHero(),
            const SizedBox(height: 30),
            _buildSectionTitle("Nuestro Menú de Arte"),
            _buildDynamicGallery(),
            _buildFooter(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _launchWhatsApp,
        label: const Text("WhatsApp",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.whatsapp, color: Colors.white),
        backgroundColor: const Color(0xFF25D366),
      ),
    );
  }

  // --- 1. HERO CON GRADIENTE ANIMADO ---
  Widget _buildAnimatedHero() {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF48FB1), Color(0xFFFCE4EC), Color(0xFFFFE0B2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(seconds: 2),
            builder: (context, double value, child) {
              return Opacity(
                opacity: value,
                child: Padding(
                  padding: EdgeInsets.only(top: (1 - value) * 50),
                  child: child,
                ),
              );
            },
            child: Column(
              children: [
                const Icon(Icons.auto_awesome,
                    color: Color(0xFFD4AF37), size: 50),
                Text(
                  "Repostería con Brillo Propio",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink.shade900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. GALERÍA DINÁMICA CON EFECTO HOVER ---
  Widget _buildDynamicGallery() {
    final List<String> fotos =
        List.generate(94, (i) => "postre (${i + 1}).jpeg");

    return Padding(
      padding: const EdgeInsets.all(15),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5, // TUS 5 COLUMNAS
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: fotos.length,
        itemBuilder: (context, index) {
          return HoverCard(
              imagePath: "assets/images/${fotos[index]}", index: index + 1);
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.quicksand(
          fontSize: 28, fontWeight: FontWeight.bold, color: Colors.pink),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(40),
      color: Colors.pink.shade50,
      child: Center(
        child: Text("© 2026 Tylas Sweet - Comayagua",
            style: TextStyle(color: Colors.pink.shade200)),
      ),
    );
  }
}

// --- CLASE PARA EL EFECTO DINÁMICO DE LAS IMÁGENES ---
class HoverCard extends StatefulWidget {
  final String imagePath;
  final int index;
  const HoverCard({super.key, required this.imagePath, required this.index});

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        transform: isHovered
            ? (Matrix4.identity()
              ..translate(0, -10, 0)
              ..scale(1.05)) // Se levanta y agranda
            : Matrix4.identity(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), // Bordes muy redondeados
          border: Border.all(
            color: isHovered
                ? const Color(0xFFD4AF37)
                : Colors.transparent, // Borde dorado al pasar mouse
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: isHovered ? Colors.pink.withOpacity(0.3) : Colors.black12,
              blurRadius: isHovered ? 20 : 10,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(17),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                widget.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => Container(
                  color: Colors.pink.shade50,
                  child: const Icon(Icons.cake, color: Colors.pink),
                ),
              ),
              if (isHovered)
                Container(
                  color: Colors.black26,
                  child: Center(
                    child: Text(
                      "Postre #${widget.index}",
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
