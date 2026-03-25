import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const TylasSweetApp());

class TylasSweetApp extends StatelessWidget {
  const TylasSweetApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.pinkAccent, useMaterial3: true),
      home: const GaleriaAutomatica(),
    );
  }
}

class GaleriaAutomatica extends StatefulWidget {
  const GaleriaAutomatica({super.key});
  @override
  State<GaleriaAutomatica> createState() => _GaleriaAutomaticaState();
}

class _GaleriaAutomaticaState extends State<GaleriaAutomatica> {
  List<String> imagenes = [];

  @override
  void initState() {
    super.initState();
    _cargarArchivos();
  }

  // ESTA ES LA MAGIA: Lee el inventario de Flutter automáticamente
  Future<void> _cargarArchivos() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    // Filtramos solo lo que esté en la carpeta de imágenes
    final fotosCargadas = manifestMap.keys
        .where((String key) => key.contains('assets/images/'))
        .toList();

    setState(() {
      imagenes = fotosCargadas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🍰 Catálogo Tylas Sweet'),
        backgroundColor: Colors.pink[50],
      ),
      body: imagenes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columnas
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: imagenes.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(imagenes[index], fit: BoxFit.cover),
                );
              },
            ),
    );
  }
}
