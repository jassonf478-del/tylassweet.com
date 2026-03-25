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
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.pink,
        textTheme: GoogleFonts.quicksandTextTheme(),
      ),
      home: const CatalogPage(),
    );
  }
}

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Generamos la lista de las 94 fotos automáticamente
    final List<String> todasLasFotos =
        List.generate(94, (index) => "postre (${index + 1}).jpeg");

    return Scaffold(
      appBar: AppBar(
        title: Text("Tylas Sweet",
            style: GoogleFonts.pacifico(
                fontSize: 30, color: Colors.pink.shade700)),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: todasLasFotos.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Image.asset(
                    "assets/images/${todasLasFotos[index]}",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => Container(
                      color: Colors.pink.shade50,
                      child:
                          const Icon(Icons.cake, color: Colors.pink, size: 40),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Postre #${index + 1}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => launchUrl(Uri.parse("https://wa.me/50499656622")),
        label: const Text("Pedidos WhatsApp"),
        icon: const Icon(Icons.whatsapp),
        backgroundColor: Colors.green,
      ),
    );
  }
}
