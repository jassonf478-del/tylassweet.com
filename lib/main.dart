import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Magia de animaciones
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart'; // Animación de grilla

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
        // Paleta de colores Premium: Rosa Suave, Dorado Metálico y Blanco Crema
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF48FB1), // Rosa Pastel
          primary: const Color(0xFFEC407A), // Rosa Fuerte
          secondary: const Color(0xFFD4AF37), // Dorado
          background: const Color(0xFFFFF8F0), // Crema
          surface: Colors.white,
        ),
        textTheme: GoogleFonts.quicksandTextTheme(), // Fuente elegante
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
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- SECCIÓN 1: EL LOGO GRANDE Y ANIMADO (ENCABEZADO) ---
            _buildAnimatedLogoHeader(context),
            const SizedBox(height: 30),

            // --- SECCIÓN 2: NUESTROS VALORES (Sección Profesional) ---
            _buildValuesSection(context),
            const SizedBox(height: 50),

            // --- SECCIÓN 3: LA GALERÍA DINÁMICA (Columnas de 5 con efectos) ---
            _buildAnimatedGallery(context),
            const SizedBox(height: 50),

            // --- SECCIÓN 4: TESTIMONIOS (Genera Confianza) ---
            _buildTestimonialsSection(context),
            const SizedBox(height: 50),

            // --- SECCIÓN 5: PIE DE PÁGINA ---
            _buildFooterSection(context),
          ],
        ),
      ),

      // BOTÓN FLOTANTE DE WHATSAPP (Con animación de pulso)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _launchWhatsApp,
        label: const Text("WhatsApp",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
        backgroundColor: const Color(0xFF25D366),
        elevation: 4,
      ).animate(onPlay: (controller) => controller.repeat(reverse: true)).scale(
          begin: const Offset(1, 1),
          end: const Offset(1.1, 1.1),
          duration: 1000.ms),
    );
  }

  // --- WIDGET 1: ENCABEZADO CON LOGO GRANDE Y ANIMADO ---
  Widget _buildAnimatedLogoHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 5))
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TU LOGO PNG (Grande y Animado)
            Image.asset(
              "assets/images/logo.png", // Asegúrate de tener este archivo
              height: 200,
              errorBuilder: (context, error, stack) =>
                  const Icon(Icons.cake, size: 100, color: Colors.pink),
            )
                .animate() // Magia de animación de entrada
                .fadeIn(duration: 800.ms)
                .slideY(
                    begin: 1.0,
                    end: 0.0,
                    curve: Curves.easeOutBack,
                    duration: 1000.ms), // Efecto Slide-Up con rebote

            const SizedBox(height: 20),
            Text(
              "Momentos Dulces, Brillo Eterno",
              style: GoogleFonts.quicksand(
                fontSize: 18,
                letterSpacing: 3,
                color: Colors.pink.shade900,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET 2: SECCIÓN DE VALORES PROFESIONALES (Íconos Dorados) ---
  Widget _buildValuesSection(BuildContext context) {
    return Column(
      children: [
        _buildSectionTitle(context, "El Sello Tylas Sweet"),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              _buildValueCard(context, Icons.star_border, "Artesanal",
                  "Hecho con amor y a mano."),
              _buildValueCard(context, Icons.palette_outlined, "Personalizado",
                  "Tu visión, nuestro diseño."),
              _buildValueCard(context, Icons.local_cafe_outlined,
                  "Ingredientes Premium", "Sabor de clase mundial."),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildValueCard(
      BuildContext context, IconData icon, String title, String desc) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.pink.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)
        ],
      ),
      child: Column(
        children: [
          Icon(icon,
              size: 40,
              color: Theme.of(context).colorScheme.secondary), // Dorado
          const SizedBox(height: 10),
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 5),
          Text(desc,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54, fontSize: 14)),
        ],
      ),
    );
  }

  // --- WIDGET 3: LA GALERÍA ANIMADA EN COLUMNAS DE 5 ---
  Widget _buildAnimatedGallery(BuildContext context) {
    final List<String> fotos =
        List.generate(94, (index) => "postre (${index + 1}).jpeg");

    return Column(
      children: [
        _buildSectionTitle(context, "Nuestra Colección Gourmet"),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5, // TUS 5 COLUMNAS
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
            ),
            itemCount: fotos.length,
            itemBuilder: (context, index) {
              // ANIMACIÓN INDIVIDUAL DE CADA FOTO (Al aparecer)
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 500),
                columnCount: 5,
                child: ScaleAnimation(
                  child: FadeInAnimation(
                    child: HoverCard(
                        imagePath: "assets/images/${fotos[index]}",
                        index: index + 1), // Efecto Hover Interactivo
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // --- WIDGET 4: TESTIMONIOS (Genera Confianza) ---
  Widget _buildTestimonialsSection(BuildContext context) {
    final testimonials = [
      {
        'name': 'Sofía L.',
        'quote': '¡El pastel de mi boda fue soñado! Delicioso y hermoso.'
      },
      {
        'name': 'Pedro C.',
        'quote': 'Increíble detalle en la decoración del pastel de mi hijo.'
      },
      {
        'name': 'María R.',
        'quote': 'Los cupcakes más suaves y ricos de Comayagua.'
      },
    ];

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          _buildSectionTitle(context, "Voces De Nuestros Clientes"),
          const SizedBox(height: 30),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: testimonials
                .map((t) => Container(
                      width: 300,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.format_quote,
                              size: 30, color: Color(0xFFD4AF37)), // Dorado
                          const SizedBox(height: 10),
                          Text(t['quote']!,
                              textAlign: TextAlign.center,
                              style:
                                  const TextStyle(fontStyle: FontStyle.italic)),
                          const SizedBox(height: 10),
                          Text("- ${t['name']}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink)),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  // WIDGETS DE SOPORTE
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Column(
      children: [
        Text(title,
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary)),
        Container(
            margin: const EdgeInsets.only(top: 5),
            height: 4,
            width: 60,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(2))),
      ],
    );
  }

  Widget _buildFooterSection(BuildContext context) {
    return Container(
        width: double.infinity,
        color: Colors.pink.shade900,
        padding: const EdgeInsets.all(40),
        child: const Column(children: [
          Text("Tylas Sweet Honduras",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("📍 Comayagua | 📞 +504 9965-6622",
              style: TextStyle(color: Colors.white70))
        ]));
  }
}

// --- CLASE PARA EL EFECTO INTERACTIVO DE LAS IMÁGENES (HOVER 3D Y BORDES) ---
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
        // EFECTO DINÁMICO: Al pasar el mouse, se levanta y se hace más grande
        transform: isHovered
            ? (Matrix4.identity()
              ..translate(0, -8, 0)
              ..scale(1.03))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          // BORDE DORADO: Aparece dinámicamente al hacer hover
          border: Border.all(
              color: isHovered ? const Color(0xFFD4AF37) : Colors.transparent,
              width: 2),
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
            errorBuilder: (context, error, stack) =>
                Container(color: Colors.pink.shade50),
          ),
        ),
      ),
    );
  }
}
