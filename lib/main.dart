import 'package:flutter/material.dart';

void main() => runApp(const TylasSweetApp());

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
      backgroundColor: const Color(0xFFFFF8E1), // Color Crema/Vainilla
      appBar: AppBar(
        title: const Text('🍰 Tylas Sweet - Repostería'),
        backgroundColor: Colors.pink[100],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cake, size: 100, color: Colors.pinkAccent),
            const SizedBox(height: 20),
            const Text(
              '¡Bienvenidos a nuestra Repostería!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text('Próximamente los mejores postres online.'),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: () {}, child: const Text('Ver Menú')),
          ],
        ),
      ),
    );
  }
}
