import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const TylasSweetApp());

class TylasSweetApp extends StatelessWidget {
  const TylasSweetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tylas Sweet - Repostería Profesional',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // --- ENCABEZADO CON TU LOGO PNG GRANDE ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30),
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
                  "assets/images/logo.png", // <--- TU LOGO
                  height: 180, // Tamaño grande para que llame la atención
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stack) =>
                      const Icon(Icons.cake, size: 100, color: Colors.pink),
                ),
                const SizedBox(height: 10),
                Text(
                  "Repostería con amor en cada detalle",
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    color: Colors.pink.shade300,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // --- BARRA DE NAVEGACIÓN ---
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _navButton("Catálogo", Icons.cake, 0),
                _navButton("Nosotros", Icons.info_outline, 1),
                _navButton("Reseñas", Icons.star_rate, 2),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.black12),

          // --- CONTENIDO DINÁMICO ---
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _launchWhatsApp("¡Hola! Quiero información general."),
        backgroundColor: const Color(0xFF25D366),
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }

  Widget _navButton(String text, IconData icon, int index) {
    bool isSelected = _selectedIndex == index;
    return TextButton.icon(
      onPressed: () => setState(() => _selectedIndex = index),
      icon: Icon(icon, color: isSelected ? Colors.pink : Colors.grey),
      label: Text(text,
          style: TextStyle(
              color: isSelected ? Colors.pink : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
    );
  }
}

// --- PÁGINA 1: CATÁLOGO (3 COLUMNAS) ---
class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // <--- 3 COLUMNAS SOLICITADAS
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 94,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () => _mostrarPedido(context, index + 1),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)
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

// --- PÁGINA 2: NOSOTROS ---
class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _section("Nuestros Orígenes",
              "Tylas Sweet nació de la pasión por crear momentos dulces e inolvidables en Comayagua. Cada receta lleva consigo años de tradición y el deseo de ver una sonrisa en cada cliente."),
          _section("Misión",
              "Ofrecer repostería artesanal de la más alta calidad, combinando arte y sabor para celebrar los momentos más especiales de la vida."),
          _section("Visión",
              "Convertirnos en la repostería preferida de las familias hondureñas, innovando en diseño y manteniendo el sabor casero que nos caracteriza."),
        ],
      ),
    );
  }

  Widget _section(String title, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.quicksand(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink)),
          const SizedBox(height: 10),
          Text(text,
              style: const TextStyle(
                  fontSize: 16, height: 1.5, color: Colors.black87)),
        ],
      ),
    );
  }
}

// --- PÁGINA 3: RESEÑAS ---
class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final reviews = [
      {
        "user": "Andrea M.",
        "comment": "El pastel de mi boda fue soñado. ¡Mil gracias!"
      },
      {
        "user": "Carlos R.",
        "comment": "Los mejores postres de Comayagua sin duda."
      },
      {
        "user": "Lucía G.",
        "comment": "Diseños increíbles y el sabor es de otro mundo."
      },
    ];
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.pink.withOpacity(0.1))),
          margin: const EdgeInsets.only(bottom: 15),
          child: ListTile(
            leading: const Icon(Icons.star, color: Color(0xFFD4AF37)),
            title: Text(reviews[index]['user']!,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(reviews[index]['comment']!),
          ),
        );
      },
    );
  }
}

// --- FUNCIONES COMUNES ---
void _mostrarPedido(BuildContext context, int index) {
  final nameCtrl = TextEditingController();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Cotizar Pastel"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset("assets/images/postre ($index).jpeg",
                  height: 120)),
          const SizedBox(height: 15),
          TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Tu Nombre")),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar")),
        ElevatedButton(
          onPressed: () => _launchWhatsApp(
              "Hola Tylas Sweet! Soy ${nameCtrl.text}, me interesa el pastel de la foto #$index."),
          child: const Text("Pedir por WhatsApp"),
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
