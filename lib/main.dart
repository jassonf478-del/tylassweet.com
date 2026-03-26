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

  final List<Widget> _pages = [
    const CatalogPage(),
    const AboutUsPage(),
    const ReviewsPage(),
  ];

  Future<void> _launchSocial(String url) async {
    final Uri uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    // DETECTAMOS EL ANCHO DE LA PANTALLA
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;

    return Scaffold(
      body: SafeArea(
        // Evita que el contenido choque con la muesca/notch del celular
        child: Column(
          children: [
            // --- ENCABEZADO RESPONSIVO ---
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: isMobile ? 15 : 30),
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
                    height: isMobile ? 120 : 180, // Logo más pequeño en celular
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stack) =>
                        const Icon(Icons.cake, size: 60, color: Colors.pink),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialIconButton(Icons.facebook, const Color(0xFF1877F2),
                          "https://www.facebook.com/TylasSweet"),
                      const SizedBox(width: 15),
                      _socialIconButton(Icons.music_note, Colors.black,
                          "https://www.tiktok.com/@tylas.sweet"),
                    ],
                  ),
                ],
              ),
            ),

            // --- BARRA DE NAVEGACIÓN ADAPTADA ---
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _navButton("Catálogo", Icons.cake, 0, isMobile),
                  _navButton("Nosotros", Icons.info_outline, 1, isMobile),
                  _navButton("Reseñas", Icons.star_rate, 2, isMobile),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.black12),

            // --- CONTENIDO ---
            Expanded(child: _pages[_selectedIndex]),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _launchWhatsApp(
            "¡Hola! Vi su catálogo móvil y quiero información."),
        backgroundColor: const Color(0xFF25D366),
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }

  Widget _socialIconButton(IconData icon, Color color, String url) {
    return InkWell(
      onTap: () => _launchSocial(url),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 3)
          ],
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }

  Widget _navButton(String text, IconData icon, int index, bool isMobile) {
    bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              color: isSelected ? Colors.pink : Colors.grey,
              size: isMobile ? 22 : 26),
          Text(
            text,
            style: TextStyle(
              fontSize: isMobile ? 12 : 14,
              color: isSelected ? Colors.pink : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isSelected)
            Container(
                height: 2,
                width: 20,
                color: Colors.pink,
                margin: const EdgeInsets.only(top: 2)),
        ],
      ),
    );
  }
}

// --- CATÁLOGO ADAPTATIVO ---
class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // REGLA: 2 columnas en celular (<600px), 4 en pantallas medianas, 5 en PC grande
    int columns = screenWidth < 600 ? 2 : (screenWidth < 900 ? 3 : 5);

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 94,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () => _mostrarPedido(context, index + 1),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                "assets/images/postre (${index + 1}).jpeg",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) =>
                    Container(color: Colors.pink.shade50),
              ),
            ),
          ),
        );
      },
    );
  }
}

// --- PÁGINAS DE NOSOTROS Y RESEÑAS (Ya son flexibles) ---
class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          _section("Nuestros Orígenes",
              "Tylas Sweet nació de la pasión por crear momentos dulces e inolvidables en Comayagua."),
          _section("Misión",
              "Ofrecer repostería artesanal de alta calidad, celebrando cada momento especial."),
          _section("Visión",
              "Ser la repostería favorita de Honduras, innovando siempre en sabor y arte."),
        ],
      ),
    );
  }

  Widget _section(String title, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink)),
          const SizedBox(height: 5),
          Text(text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, height: 1.4)),
        ],
      ),
    );
  }
}

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final reviews = [
      {"user": "Andrea M.", "comment": "¡El mejor pastel de Comayagua!"},
      {"user": "Carlos R.", "comment": "Diseños increíbles y sabor único."},
    ];
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.pink.withOpacity(0.1))),
          child: ListTile(
            leading: const Icon(Icons.star, color: Color(0xFFD4AF37), size: 20),
            title: Text(reviews[index]['user']!,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: Text(reviews[index]['comment']!,
                style: const TextStyle(fontSize: 13)),
          ),
        );
      },
    );
  }
}

// --- FUNCIONES ---
void _mostrarPedido(BuildContext context, int index) {
  final nameCtrl = TextEditingController();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text("Cotizar Pastel"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset("assets/images/postre ($index).jpeg",
                  height: 150, fit: BoxFit.cover)),
          const SizedBox(height: 15),
          TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                  labelText: "Tu Nombre", border: OutlineInputBorder())),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cerrar")),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink, foregroundColor: Colors.white),
          onPressed: () => _launchWhatsApp(
              "Hola Tylas Sweet! Soy ${nameCtrl.text}, me interesa el pastel #$index."),
          child: const Text("Pedir"),
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
