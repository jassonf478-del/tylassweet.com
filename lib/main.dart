import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

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
          seedColor: const Color(0xFFF48FB1), // Rosa Suave
          primary: const Color(0xFFEC407A), // Rosa Fuerte
          secondary: const Color(0xFFD4AF37), // Dorado Metálico
          background: const Color(0xFFFFF8F0), // Blanco Crema
        ),
        textTheme: GoogleFonts.quicksandTextTheme(),
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
  // Función para abrir WhatsApp
  Future<void> _launchWhatsApp() async {
    final Uri url = Uri.parse(
        "https://wa.me/50499656622?text=Hola Tylas Sweet! Vi tu catálogo web y quiero una cotización.");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('No se pudo abrir WhatsApp');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      // Quitamos el AppBar para que el logo sea el único protagonista arriba
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- SECCIÓN 1: EL LOGO GRANDE Y ANIMADO (ENCABEZADO) ---
            _buildAnimatedLogoHeader(context),
            const SizedBox(height: 30),

            // --- SECCIÓN 2: TÍTULO DE LA GALERÍA ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    "Nuestra Galería de Antojos",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    height: 4,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary, // Dorado
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // --- SECCIÓN 3: EL CATÁLOGO (Columnas de 5) ---
            _buildGallerySection(context),
            const SizedBox(height: 50),

            // --- SECCIÓN 4: PIE DE PÁGINA ---
            _buildFooterSection(context),
          ],
        ),
      ),

      // BOTÓN FLOTANTE DE WHATSAPP
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _launchWhatsApp,
        label: const Text("Cotizar Pastel",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.whatsapp, color: Colors.white),
        backgroundColor: const Color(0xFF25D366), // Verde WhatsApp
        elevation: 4,
      ),
    );
  }

  // --- WIDGET DEL ENCABEZADO CON LOGO ANIMADO ---
  Widget _buildAnimatedLogoHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      // Altura del encabezado (ajusta según prefieras)
      height: 350,
      decoration: BoxDecoration(
        // Fondo con un degradado suave rosado
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.pink.shade50,
            Theme.of(context).colorScheme.background,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ANIMACIÓN DE ENTRADA (Aparece y sube suavemente)
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(
                  milliseconds: 1200), // Duración de la animación
              curve: Curves.easeOutBack, // Efecto de rebote suave al final
              builder: (context, double value, child) {
                return Opacity(
                  opacity: value,
                  child: Padding(
                    // Mueve el logo de 50px abajo hacia su posición original
                    padding: EdgeInsets.only(top: (1 - value) * 50),
                    child: child,
                  ),
                );
              },
              // --- AQUÍ ESTÁ TU LOGO PNG ---
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    // Un borde dorado sutil alrededor del logo
                    border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 2),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.pink.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 5)
                    ]),
                child: Image.asset(
                  "assets/images/logo.png", // Nombre exacto de tu archivo
                  height: 180, // Ajusta el tamaño del logo aquí
                  fit: BoxFit.contain,
                  // Por si acaso el logo no carga, muestra un icono
                  errorBuilder: (context, error, stack) =>
                      const Icon(Icons.cake, size: 100, color: Colors.pink),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Un pequeño eslogan debajo del logo
            Text(
              "Repostería Artesanal",
              style: GoogleFonts.quicksand(
                fontSize: 18,
                letterSpacing: 2,
                color: Colors.pink.shade900,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- SECCIÓN GALERÍA (Columnas de 5) ---
  Widget _buildGallerySection(BuildContext context) {
    final List<String> todasLasFotos =
        List.generate(94, (index) => "postre (${index + 1}).jpeg");

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount =
            constraints.maxWidth < 600 ? 3 : 5; // 3 en móvil, 5 en PC

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.0,
          ),
          itemCount: todasLasFotos.length,
          itemBuilder: (context, index) {
            // USAMOS EL WIDGET INTERACTIVO (HoverCard) QUE CREAMOS ANTES
            return HoverCard(
                imagePath: "assets/images/${todasLasFotos[index]}",
                index: index + 1);
          },
        );
      },
    );
  }

  // PIE DE PÁGINA
  Widget _buildFooterSection(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.pink.shade900,
      padding: const EdgeInsets.all(40),
      child: const Column(
        children: [
          Text("Tylas Sweet Honduras",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("📍 Comayagua | 📞 +504 9965-6622",
              style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

// --- CLASE PARA EL EFECTO INTERACTIVO DE LAS IMÁGENES (HOVER) ---
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
              ..translate(0, -8, 0)
              ..scale(1.03)) // Se levanta sutilmente
            : Matrix4.identity(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isHovered
                ? const Color(0xFFD4AF37)
                : Colors.transparent, // Borde dorado en hover
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isHovered
                  ? Colors.pink.withOpacity(0.2)
                  : Colors.black.withOpacity(0.05),
              blurRadius: isHovered ? 15 : 8,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: Image.asset(
            widget.imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stack) => Container(
              color: Colors.pink.shade50,
              child: const Icon(Icons.cake, color: Colors.pink),
            ),
          ),
        ),
      ),
    );
  }
}
