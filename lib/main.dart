import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

void main() => runApp(
  const MaterialApp(
    home: Scaffold(body: Center(child: Text('¡Web Funcionando!'))),
  ),
);

void main() => runApp(const MaterialApp(home: SimpleGallery()));

class SimpleGallery extends StatelessWidget {
  const SimpleGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tylas Sweet - Galeria')),
      body: const Center(
        child: Text(
          'Si ves este texto, la web ya cargo correctamente. Ahora purga Cloudflare.',
        ),
      ),
    );
  }
}
