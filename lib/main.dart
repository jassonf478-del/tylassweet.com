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
          seedColor: const Color(0xFFF48FB1),
          primary: const Color(0xFFEC407A),
          secondary: const Color(0xFFD4AF37),
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

  // Lista de páginas del menú
  final List<Widget> _pages = [
    const CatalogPage(), // Pasteles (3-5 columnas)
    const DessertsPage(), // Cupcakes, Flan, Chocoflan
    const AboutUsPage(), // Misión, Visión, Orígenes
    const ReviewsPage(), // Reseñas de clientes
  ];

  Future<void> _launchSocial(String url) async {
    final Uri uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // --- ENCABEZADO CON LOGO Y REDES ---
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: isMobile ? 15 : 25),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pink.shade50, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    height: isMobile ? 110 : 160,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stack) =>
                        const Icon(Icons.cake, size: 60, color: Colors.pink),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialCircleBtn(Icons.facebook, const Color(0xFF1877F2),
                          "https://www.facebook.com/TylasSweet"),
                      const SizedBox(width: 15),
                      _socialCircleBtn(Icons.music_note, Colors.black,
                          "https://www.tiktok.com/@tylas.sweet"),
                    ],
                  ),
                ],
              ),
            ),

            // --- BARRA DE NAVEGACIÓN (RESPONSIVA) ---
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  children: [
                    _navItem("Pasteles", Icons.cake, 0),
                    _navItem("Postres", Icons.icecream_outlined, 1),
                    _navItem("Nosotros", Icons.info_outline, 2),
                    _navItem("Reseñas", Icons.star_rate, 3),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, color: Colors.black12),

            // --- CONTENIDO DE LA PÁGINA ---
            Expanded(child: _pages[_selectedIndex]),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _launchWhatsApp(
            "¡Hola Tylas Sweet! Quisiera una cotización general."),
        backgroundColor: const Color(0xFF25D366),
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }

  Widget _socialCircleBtn(IconData icon, Color color, String url) {
    return InkWell(
      onTap: () => _launchSocial(url),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)
            ]),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }

  Widget _navItem(String text, IconData icon, int index) {
    bool sel = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: sel ? Colors.pink.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: sel ? Colors.pink : Colors.grey, size: 20),
            const SizedBox(width: 5),
            Text(text,
                style: TextStyle(
                    color: sel ? Colors.pink : Colors.grey,
                    fontWeight: sel ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}

// --- PÁGINA: POSTRES (NUEVA) ---
class DessertsPage extends StatelessWidget {
  const DessertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // IMPORTANTE: Aquí usamos assets locales para que no fallen las fotos
    final List<Map<String, String>> desserts = [
      {
        "nombre": "Cupcakes Gourmet",
        "img": "assets/images/postre (1).jpeg",
        "tipo": "Pack x6 / x12"
      },
      {
        "nombre": "Flan de Leche",
        "img": "assets/images/postre (2).jpeg",
        "tipo": "Tradicional"
      },
      {
        "nombre": "Chocoflan",
        "img": "assets/images/postre (3).jpeg",
        "tipo": "Pastel Imposible"
      },
      {
        "nombre": "Postres Fríos",
        "img": "assets/images/postre (4).jpeg",
        "tipo": "Variedad"
      },
    ];

    double width = MediaQuery.of(context).size.width;
    int cols = width < 600 ? 2 : 4;

    return GridView.builder(
      padding: const EdgeInsets.all(15),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: desserts.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () => _modalPedido(
              context, desserts[index]['nombre']!, desserts[index]['img']!),
          child: Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15)),
                  child:
                      Image.asset(desserts[index]['img']!, fit: BoxFit.cover),
                )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(desserts[index]['nombre']!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                          textAlign: TextAlign.center),
                      Text(desserts[index]['tipo']!,
                          style: const TextStyle(
                              color: Colors.pink, fontSize: 11)),
                    ],
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

// --- PÁGINA: CATÁLOGO (PASTELES) ---
class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    int cols = width < 600 ? 2 : 5; // Responsivo: 2 en móvil, 5 en PC

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemCount: 94,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () => _modalPedido(context, "Pastel #${index + 1}",
              "assets/images/postre (${index + 1}).jpeg"),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset("assets/images/postre (${index + 1}).jpeg",
                fit: BoxFit.cover),
          ),
        );
      },
    );
  }
}

// --- PÁGINA: NOSOTROS ---
class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          _infoCard("Nuestros Orígenes",
              "Tylas Sweet nació en Comayagua con la misión de endulzar tus mejores momentos con recetas artesanales y mucho amor."),
          _infoCard("Misión",
              "Crear obras de arte comestibles que deleiten el paladar y el corazón de nuestros clientes."),
          _infoCard("Visión",
              "Ser la repostería líder en innovación y sabor, llevando nuestra dulzura a cada rincón de Honduras."),
        ],
      ),
    );
  }

  Widget _infoCard(String t, String c) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(children: [
          Text(t,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink)),
          const SizedBox(height: 8),
          Text(c,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, height: 1.4)),
          const Divider(indent: 50, endIndent: 50, color: Colors.pinkOpacity),
        ]),
      );
}

// --- PÁGINA: RESEÑAS ---
class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final revs = [
      {
        "u": "Andrea M.",
        "c": "¡El pastel de mi boda fue soñado! Recomendados al 100%."
      },
      {
        "u": "Carlos R.",
        "c": "Los mejores postres de Comayagua. El chocoflan es increíble."
      },
    ];
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: revs.length,
      itemBuilder: (context, i) => Card(
        margin: const EdgeInsets.only(bottom: 15),
        child: ListTile(
          leading: const Icon(Icons.star, color: Color(0xFFD4AF37)),
          title: Text(revs[i]['u']!,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(revs[i]['c']!),
        ),
      ),
    );
  }
}

// --- FUNCIONES DE APOYO ---
void _modalPedido(BuildContext context, String nombre, String imgPath) {
  final ctrl = TextEditingController();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text("Cotizar $nombre",
          style: const TextStyle(color: Colors.pink, fontSize: 18)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(imgPath, height: 140, fit: BoxFit.cover)),
          const SizedBox(height: 15),
          TextField(
              controller: ctrl,
              decoration: const InputDecoration(
                  labelText: "Tu Nombre", border: OutlineInputBorder())),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar")),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink, foregroundColor: Colors.white),
          onPressed: () => _launchWhatsApp(
              "Hola Tylas Sweet! Soy ${ctrl.text}, me interesa: $nombre"),
          child: const Text("Enviar a WhatsApp"),
        ),
      ],
    ),
  );
}

Future<void> _launchWhatsApp(String msg) async {
  final url =
      Uri.parse("https://wa.me/50499656622?text=${Uri.encodeComponent(msg)}");
  await launchUrl(url, mode: LaunchMode.externalApplication);
}

extension ColorExt on Color {
  static const pinkOpacity = Color(0x22EC407A);
}
