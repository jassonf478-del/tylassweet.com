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
          background: const Color(0xFFFFF8F0),
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

  // Lista de páginas
  final List<Widget> _pages = [
    const CatalogPage(),
    const AboutUsPage(),
    const ReviewsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.asset("assets/images/logo.png",
            height: 60,
            errorBuilder: (context, error, stack) => Text("Tylas Sweet",
                style: GoogleFonts.pacifico(color: Colors.pink))),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            color: Colors.white,
            child: TabBar(
              onTap: (index) => setState(() => _selectedIndex = index),
              indicatorColor: Colors.pink,
              labelColor: Colors.pink,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(icon: Icon(Icons.cake), text: "Catálogo"),
                Tab(icon: Icon(Icons.info_outline), text: "Nosotros"),
                Tab(icon: Icon(Icons.star_rate), text: "Reseñas"),
              ],
              controller: TabController(length: 3, vsync: Scaffold.of(context)),
            ),
          ),
        ),
      ),
      body: _pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () => _launchWhatsApp("¡Hola! Quiero información general."),
        backgroundColor: const Color(0xFF25D366),
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }
}

// --- PÁGINA 1: CATÁLOGO (3 COLUMNAS) ---
class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text("Elige tu diseño favorito",
              style: GoogleFonts.quicksand(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink)),
          const Text("Toca una imagen para cotizar",
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // <--- SOLICITUD: 3 COLUMNAS
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: 94,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => _mostrarPedido(context, index + 1),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset("assets/images/postre (${index + 1}).jpeg",
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => Container(
                          color: Colors.pink.shade50,
                          child: const Icon(Icons.cake, color: Colors.pink))),
                ),
              );
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// --- PÁGINA 2: NOSOTROS (MISIÓN, VISIÓN, ORÍGENES) ---
class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoSection("Nuestros Orígenes",
              "Tylas Sweet nació en el corazón de Comayagua como un sueño familiar de endulzar los momentos más importantes de nuestra comunidad. Lo que comenzó en una cocina pequeña, hoy es una repostería que combina técnicas modernas con el sabor artesanal de casa."),
          const SizedBox(height: 30),
          _buildInfoSection("Misión",
              "Crear experiencias dulces inolvidables mediante repostería de alta calidad, diseños personalizados y un servicio cálido que haga de cada celebración un evento mágico."),
          const SizedBox(height: 30),
          _buildInfoSection("Visión",
              "Ser la repostería referente en Honduras, reconocida por nuestra creatividad artística y la excelencia en nuestros sabores, expandiendo la dulzura de Tylas Sweet a cada hogar."),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: GoogleFonts.quicksand(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.pink)),
        const SizedBox(height: 10),
        Text(content,
            style: const TextStyle(
                fontSize: 16, height: 1.5, color: Colors.black87)),
        const Divider(height: 40, color: Colors.pinkOpacity),
      ],
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
        "comment": "El pastel de mi boda superó mis expectativas. ¡Hermoso!",
        "stars": 5
      },
      {
        "user": "Carlos R.",
        "comment":
            "Excelente atención y el sabor de los cupcakes es de otro mundo.",
        "stars": 5
      },
      {
        "user": "Lucía G.",
        "comment": "Mi hija amó su pastel de cumpleaños. 100% recomendados.",
        "stars": 5
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(15),
            leading: const CircleAvatar(
                backgroundColor: Colors.pink,
                child: Icon(Icons.person, color: Colors.white)),
            title: Text(reviews[index]['user'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    children: List.generate(
                        5,
                        (i) => const Icon(Icons.star,
                            size: 18, color: Color(0xFFD4AF37)))),
                const SizedBox(height: 5),
                Text(reviews[index]['comment'] as String),
              ],
            ),
          ),
        );
      },
    );
  }
}

// --- FUNCIONES GLOBALES ---
void _mostrarPedido(BuildContext context, int index) {
  final controller = TextEditingController();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Hacer Pedido"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("assets/images/postre ($index).jpeg", height: 100),
          TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: "Tu nombre")),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar")),
        ElevatedButton(
          onPressed: () => _launchWhatsApp(
              "Hola! Soy ${controller.text}, me interesa el pastel #$index"),
          child: const Text("Enviar"),
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
