import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const TylasSweetApp());

class TylasSweetApp extends StatelessWidget {
  const TylasSweetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tylas Sweet - Pedidos Online',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF48FB1),
          primary: const Color(0xFFEC407A),
          secondary: const Color(0xFFD4AF37),
        ),
        textTheme: GoogleFonts.quicksandTextTheme(),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // FUNCIÓN MAESTRA: Envía el pedido detallado a WhatsApp
  Future<void> _enviarPedidoWhatsApp(
      String fotoNum, String nombre, String tipoPastel) async {
    // Texto del mensaje que te llegará a ti
    String mensaje = "¡Hola Tylas Sweet! 🍰\n\n"
        "Me interesa el postre de la foto: *#$fotoNum*\n"
        "Nombre del cliente: *$nombre*\n"
        "Tipo de pastel solicitado: *$tipoPastel*\n\n"
        "¿Podrían darme una cotización?";

    final Uri url = Uri.parse(
        "https://wa.me/50499656622?text=${Uri.encodeComponent(mensaje)}");

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('No se pudo abrir WhatsApp');
    }
  }

  // DIÁLOGO PARA PEDIR DATOS AL SELECCIONAR IMAGEN
  void _mostrarFormularioPedido(BuildContext context, int index) {
    final TextEditingController nombreController = TextEditingController();
    String tipoSeleccionado = 'Personalizado (Fondant)'; // Valor por defecto

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("Detalles de tu Pedido 🎂",
              style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.bold, color: Colors.pink)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset("assets/images/postre ($index).jpeg",
                      height: 150, fit: BoxFit.cover),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: nombreController,
                  decoration: const InputDecoration(
                    labelText: "Tu Nombre",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: tipoSeleccionado,
                  decoration: const InputDecoration(
                      labelText: "Tipo de Pastel",
                      border: OutlineInputBorder()),
                  items: [
                    'Personalizado (Fondant)',
                    'Pastel Frío',
                    'Tres Leches',
                    'Cupcakes (Caja)',
                    'Otro'
                  ]
                      .map((label) =>
                          DropdownMenuItem(value: label, child: Text(label)))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => tipoSeleccionado = value!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancelar")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink, foregroundColor: Colors.white),
              onPressed: () {
                if (nombreController.text.isNotEmpty) {
                  Navigator.pop(context);
                  _enviarPedidoWhatsApp(index.toString(), nombreController.text,
                      tipoSeleccionado);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Por favor, ingresa tu nombre")),
                  );
                }
              },
              child: const Text("Enviar Pedido"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // LOGO ENCABEZADO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              color: Colors.white,
              child: Center(
                child: Image.asset("assets/images/logo.png",
                    height: 180,
                    errorBuilder: (context, error, stack) =>
                        const Icon(Icons.cake, size: 100, color: Colors.pink)),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Text("Selecciona el pastel que te gusta para cotizar:",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink.shade900)),
            ),

            // GRILLA DE 5 COLUMNAS INTERACTIVA
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: 94,
              itemBuilder: (context, index) {
                int fotoIndex = index + 1;
                return InkWell(
                  onTap: () => _mostrarFormularioPedido(context, fotoIndex),
                  child: Hero(
                    tag: 'postre_$fotoIndex',
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.pink.withOpacity(0.1)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5)
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                                "assets/images/postre ($fotoIndex).jpeg",
                                fit: BoxFit.cover),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.pink,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10)),
                                ),
                                child: const Icon(Icons.add_shopping_cart,
                                    color: Colors.white, size: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
