import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CatalogPage(),
    ));

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Generamos la lista de tus 94 fotos
    final List<String> todasLasFotos =
        List.generate(94, (index) => "postre (${index + 1}).jpeg");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tylas Sweet",
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.pink)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemCount: todasLasFotos.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Image.asset(
                    "assets/images/${todasLasFotos[index]}",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) =>
                        const Icon(Icons.cake, size: 50, color: Colors.pink),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Text("Postre #${index + 1}", textAlign: TextAlign.center),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
