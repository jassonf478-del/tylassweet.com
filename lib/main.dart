import 'package:flutter/material.dart';

void main() {
  runApp(const TylasSweetApp());
}

class TylasSweetApp extends StatelessWidget {
  const TylasSweetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tylas Sweet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        useMaterial3: true,
        fontFamily: 'Georgia', // Le da un toque elegante de pastelería
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1), // Fondo Crema/Vainilla
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '🍰 Tylas Sweet',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
        ),
        backgroundColor: Colors.pink[100],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner de Bienvenida
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              color: Colors.pink[50],
              child: Column(
                children: [
                  const Text(
                    '¡Bienvenidos a nuestra Repostería!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.pinkAccent,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Postres hechos con amor para endulzar tus momentos.',
                    style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            const Text(
              'Nuestras Especialidades',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const Divider(
              indent: 100,
              endIndent: 100,
              color: Colors.pinkAccent,
            ),

            // Galería de Postres
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Si la pantalla es ancha (PC) pone 3 columnas, si es angosta (Celular) pone 1
                  int columns = constraints.maxWidth > 600 ? 3 : 1;
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: columns,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 0.8,
                    children: [
                      _cardPostre(
                        'https://images.unsplash.com/photo-1578985545062-69928b1d9587?q=80&w=500',
                        'Pastel de Chocolate Superior',
                        '\$25.00',
                      ),
                      _cardPostre(
                        'https://images.unsplash.com/photo-1488477181946-6428a0291777?q=80&w=500',
                        'Cheesecake de Arándanos',
                        '\$18.50',
                      ),
                      _cardPostre(
                        'https://images.unsplash.com/photo-1551024506-0bccd828d307?q=80&w=500',
                        'Donas Artesanales',
                        '\$12.00',
                      ),
                      _cardPostre(
                        'https://images.unsplash.com/photo-1519915028121-7d3463d20b13?q=80&w=500',
                        'Cupcakes de Fresa',
                        '\$15.00',
                      ),
                    ],
                  );
                },
              ),
            ),

            // Pie de página
            Container(
              padding: const EdgeInsets.all(30),
              color: Colors.brown[400],
              child: const Center(
                child: Text(
                  'Siguenos en Redes Sociales @TylasSweet\nUbicados en Comayagua',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      // Botón flotante para pedidos
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Aquí podrías poner el link a tu WhatsApp
        },
        label: const Text('Hacer Pedido'),
        icon: const Icon(Icons.shopping_cart),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Widget para crear cada tarjeta de postre de forma rápida
  Widget _cardPostre(String url, String nombre, String precio) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Image.network(
                url,
                fit: BoxFit.cover,
              ), // Cambiar a Image.asset cuando tengas tus fotos
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text(
                  nombre,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  precio,
                  style: const TextStyle(
                    color: Colors.pinkAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
