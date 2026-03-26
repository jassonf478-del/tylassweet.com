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
    const CatalogPage(), // Pasteles
    const DessertsPage(), // NUEVA: Cupcakes, Flan, etc.
    const AboutUsPage(),
    const ReviewsPage(),
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

            // BARRA DE NAVEGACIÓN CON 4 PESTAÑAS
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _navButton("Pasteles", Icons.cake, 0, isMobile),
                    const SizedBox(width: 15),
                    _navButton("Postres", Icons.icecream_outlined, 1, isMobile),
                    const SizedBox(width: 15),
                    _navButton("Nosotros", Icons.info_outline, 2, isMobile),
                    const SizedBox(width: 15),
                    _navButton("Reseñas", Icons.star_rate, 3, isMobile),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, color: Colors.black12),

            Expanded(child: _pages[_selectedIndex]),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _launchWhatsApp("¡Hola! Quiero hacer una consulta."),
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
        decoration:
            const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }

  Widget _navButton(String text, IconData icon, int index, bool isMobile) {
    bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        children: [
          Icon(icon, color: isSelected ? Colors.pink : Colors.grey, size: 22),
          Text(text,
              style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.pink : Colors.grey,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}

// --- PÁGINA DE POSTRES (CUPCAKES, FLAN, CHOCOFLAN) ---
class DessertsPage extends StatelessWidget {
  const DessertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> desserts = [
      {
        "nombre": "Cupcakes Gourmet",
        "imagen":
            "http://googleusercontent.com/image_collection/image_retrieval/6145759225366623390_0",
        "tipo": "Cupcakes"
      },
      {
        "nombre": "Flan de Leche",
        "imagen":
            "http://googleusercontent.com/image_collection/image_retrieval/1503219935099500571_1",
        "tipo": "Flan"
      },
      {
        "nombre": "Chocoflan (Imposible)",
        "imagen":
            "http://googleusercontent.com/image_collection/image_retrieval/7797657061751105560_2",
        "tipo": "Especialidad"
      },
      {
        "nombre": "Cupcakes Decorados",
        "imagen":
            "http://googleusercontent.com/image_collection/image_retrieval/6145759225366623390_3",
        "tipo": "Cupcakes"
      },
      {
        "nombre": "Flan Casero",
        "imagen":
            "http://googleusercontent.com/image_collection/image_retrieval/1503219935099500571_0",
        "tipo": "Flan"
      },
    ];

    double screenWidth = MediaQuery.of(context).size.width;
    int columns = screenWidth < 600 ? 2 : 3;

    return GridView.builder(
      padding: const EdgeInsets.all(15),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: desserts.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () => _mostrarPedidoPostre(
              context, desserts[index]['nombre']!, desserts[index]['imagen']!),
          child: Card(
            clipBehavior: Clip.antiAlias,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    child: Image.network(desserts[index]['imagen']!,
                        fit: BoxFit.cover)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(desserts[index]['nombre']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13)),
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

// --- CATALOGO (PASTELES) ---
class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int columns = screenWidth < 600 ? 2 : 5;
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemCount: 94,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () => _mostrarPedido(context, index + 1),
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

// --- RESTO DE PÁGINAS ---
class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          _sec("Misión", "Crear momentos dulces con sabor artesanal."),
          _sec("Visión", "Ser la repostería favorita de Comayagua."),
        ],
      ),
    );
  }

  Widget _sec(String t, String s) => Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(children: [
        Text(t,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink)),
        Text(s, textAlign: TextAlign.center)
      ]));
}

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("¡Nuestros clientes nos aman! ⭐⭐⭐⭐⭐"));
  }
}

// --- LOGICA DE PEDIDOS ---
void _mostrarPedidoPostre(BuildContext context, String nombre, String img) {
  final nameCtrl = TextEditingController();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Pedir $nombre"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(img, height: 120, fit: BoxFit.cover)),
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
              "¡Hola Tylas Sweet! Soy ${nameCtrl.text}, me gustaría cotizar un pedido de: $nombre."),
          child: const Text("Pedir"),
        ),
      ],
    ),
  );
}

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
                  height: 120, fit: BoxFit.cover)),
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
