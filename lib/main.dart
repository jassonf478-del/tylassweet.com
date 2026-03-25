import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const TylasSweetApp());

class TylasSweetApp extends StatelessWidget {
  const TylasSweetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tylas Sweet | Repostería',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFD1DC), // Rosa Pastel
          primary: const Color(0xFF8D5B4C), // Café Chocolate
        ),
        textTheme:
            GoogleFonts.quicksandTextTheme(), // Fuente elegante y legible
      ),
      home: const HomePage(),
    );
  }
}

// ==========================================
// CONFIGURACIÓN DE PRODUCTOS (Modifica aquí)
// ==========================================
class Producto {
  final String nombre;
  final String precio;
  final String imagen;

  Producto({required this.nombre, required this.precio, required this.imagen});
}

final List<Producto> misProductos = [
  Producto(
    nombre: "Pastel de Chocolate",
    precio: "L. 450",
    imagen: "assets/images/postre (1).jpg",
  ),
  Producto(
    nombre: "Cupcakes Especiales",
    precio: "L. 180",
    imagen: "assets/images/postre (2).jpg",
  ),
  Producto(
    nombre: "Tarta de Frutos Rojos",
    precio: "L. 500",
    imagen: "assets/images/postre (3).jpg",
  ),
  // Puedes seguir agregando más productos aquí...
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Función para abrir enlaces externos
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'No se pudo abrir $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F9), // Fondo crema pastel
      body: CustomScrollView(
        slivers: [
          // Banner de Bienvenida
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                "Tylas Sweet",
                style: GoogleFonts.pacifico(
                  color: const Color(0xFF8D5B4C),
                  fontSize: 28,
                ),
              ),
              background: Container(
                color: const Color(0xFFFFD1DC),
                child: const Center(
                  child: Icon(Icons.cake, size: 80, color: Colors.white),
                ),
              ),
            ),
          ),

          // Botones de Redes Sociales
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _socialButton(
                    Icons.whatsapp,
                    "Pedidos",
                    Colors.green,
                    () => _launchURL("https://wa.me/50499656622"),
                  ),
                  const SizedBox(width: 20),
                  _socialButton(
                    Icons.music_note,
                    "TikTok",
                    Colors.black,
                    () => _launchURL("https://www.tiktok.com/@tylas.sweet"),
                  ),
                ],
              ),
            ),
          ),

          // Título de Galería
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Nuestro Menú",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8D5B4C),
                ),
              ),
            ),
          ),

          // Cuadrícula de Productos
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final p = misProductos[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 5),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          child: Image.asset(
                            p.imagen,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image_not_supported, size: 50),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Text(
                              p.nombre,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              p.precio,
                              style: const TextStyle(
                                color: Colors.pink,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }, childCount: misProductos.length),
            ),
          ),

          // Pie de página
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: Text("© 2026 Tylas Sweet - Honduras")),
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: StadiumBorder(),
      ),
    );
  }
}
