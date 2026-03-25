import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(
  const MaterialApp(debugShowCheckedModeBanner: false, home: TylasSweetHome()),
);

class TylasSweetHome extends StatefulWidget {
  const TylasSweetHome({super.key});
  @override
  State<TylasSweetHome> createState() => _TylasSweetHomeState();
}

class _TylasSweetHomeState extends State<TylasSweetHome> {
  List<String> imagenes = [];

  @override
  void initState() {
    super.initState();
    _cargarFotos();
  }

  Future<void> _cargarFotos() async {
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      // Filtramos solo los que empiecen con 'assets/images/postre' y sean archivos reales
      final fotosEncontradas = manifestMap.keys
          .where((String key) => key.startsWith('assets/images/postre'))
          .toList();

      setState(() {
        imagenes = fotosEncontradas;
      });
    } catch (e) {
      print("Error cargando fotos: $e");
      // Si falla el auto-escaneo, ponemos una foto de respaldo para que no se quede la rueda
      setState(() {
        imagenes = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🍰 Tylas Sweet',
          style: TextStyle(color: Colors.pink),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: imagenes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: imagenes.length,
              itemBuilder: (context, index) => ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(imagenes[index], fit: BoxFit.cover),
              ),
            ),
    );
  }
}
