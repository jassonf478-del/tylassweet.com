import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const TylasSweetApp());

class TylasSweetApp extends StatelessWidget {
  const TylasSweetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tylas Sweet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF48FB1),
          primary: const Color(0xFFEC407A),
          surface:
              const Color(0xFFFFF8F0), // Corregido: 'background' es obsoleto
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

  // EFECTO: Fondo degradado dinámico según el día
  List<Color> _getDailyGradient() {
    int day = DateTime.now().weekday;
    // Cambia los colores según el día para que la web siempre se sienta fresca
    if (day == 1) return [Colors.pink.shade50, Colors.orange.shade50];
    if (day == 5)
      return [
        const Color(0xFFFCE4EC),
        const Color(0xFFF8BBD0)
      ]; // Especial Viernes
    return [const Color(0xFFFFF8F0), Colors.white];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _getDailyGradient(),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // --- EL LOGO NUEVO ---
              Padding(
                padding: const EdgeInsets.all(20),
                child: Hero(
                  tag: 'logo',
                  child: Image.asset(
                    "assets/images/logo.png", // Asegúrate de que el archivo se llame así
                    height: 160,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stack) =>
                        const Icon(Icons.cake, size: 80, color: Colors.pink),
                  ),
                ),
              ),

              // --- REPRODUCTOR DE MÚSICA (INTERFAZ) ---
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(180),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.pink.withAlpha(50)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.music_note, color: Colors.pink, size: 20),
                    const SizedBox(width: 10),
                    const Text("Música Ambiente",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    IconButton(
                      icon: const Icon(Icons.play_circle_fill,
                          color: Colors.pink),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "🎶 Reproduciendo dulces melodías...")));
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // --- NAVEGACIÓN ---
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTab("Pasteles", Icons.cake, 0),
                    _buildTab("Postres", Icons.icecream, 1),
                    _buildTab("Nosotros", Icons.auto_awesome, 2),
                  ],
                ),
              ),

              const Divider(indent: 40, endIndent: 40),

              // --- GRID CON EFECTO DE SOMBRA ROSA ---
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(15),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: 20, // Ajusta a tus fotos
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink.withAlpha(30),
                            blurRadius: 10,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          "assets/images/postre (${index + 1}).jpeg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String label, IconData icon, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.pink : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isSelected ? Colors.white : Colors.grey, size: 18),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
