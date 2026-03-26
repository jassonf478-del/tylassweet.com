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
          secondary: const Color(0xFFD4AF37),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _launchWhatsApp() async {
    final Uri url = Uri.parse(
        "https://wa.me/50499656622?text=Hola! Quiero una cotizacion.");
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- ENCABEZADO CON TU LOGO ---
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.pink.shade50,
              child: Center(
                child: Image.asset(
                  "assets/images/logo.png",
                  height: 200,
                  errorBuilder: (context, error, stack) =>
                      const Icon(Icons.cake, size: 100, color: Colors.pink),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Nuestros Postres",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink)),
            const SizedBox(height: 20),

            // --- GALERÍA EN 5 COLUMNAS ---
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5, // <--- AQUÍ ESTÁN LAS 5 COLUMNAS
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 94,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    "assets/images/postre (${index + 1}).jpeg",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) =>
                        Container(color: Colors.pink.shade100),
                  ),
                );
              },
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
      // --- BOTÓN DE WHATSAPP CORREGIDO ---
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _launchWhatsApp,
        label: const Text("WhatsApp", style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.chat,
            color: Colors.white), // Usamos 'chat' para evitar error
        backgroundColor: const Color(0xFF25D366),
      ),
    );
  }
}
