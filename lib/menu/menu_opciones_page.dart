// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:smart_led/LEDS_FOCOS/normal/foco_normal.dart';
import 'package:smart_led/LEDS_FOCOS/led/led_screen.dart';
import 'package:smart_led/LEDS_FOCOS/bluetooth/bluetooth_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control de Luces',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const MenuOpciones(),
    );
  }
}

class MenuOpciones extends StatefulWidget {
  const MenuOpciones({super.key});

  @override
  _MenuOpcionesState createState() => _MenuOpcionesState();
}

class _MenuOpcionesState extends State<MenuOpciones> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Fondo animado con gradientes oscuros
          AnimatedBackground(animation: _animation),
          //Animación de estrellas
          StarAnimation(animation: _animation),
          // Contenido principal
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Título
                const Text(
                  'Control de Luces',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                // Botón para Normal LED
                NeonButton(
                  text: 'LED Normal',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NormalLedScreen()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                // Botón para RGB Bulb
                NeonButton(
                  text: 'Serie RGB',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LedScreen()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                // Botón para Bluetooth
                NeonButton(
                  text: 'LED Bluetooth',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BluetoothLedControlScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Fondo animado con gradiente dinámico oscuro
class AnimatedBackground extends StatelessWidget {
  final Animation<double> animation;

  const AnimatedBackground({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Colors.black,
                Colors.deepPurple.withOpacity(1 * animation.value),
                Colors.black,
              ],
              stops: const [0.3, 0.7, 1.0],
              center: const Alignment(0, 0),
              radius: 2,
            ),
          ),
        );
      },
    );
  }
}

// Animación de pequeñas luces (estrellas)
class StarAnimation extends StatelessWidget {
  final Animation<double> animation;

  const StarAnimation({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return CustomPaint(
          painter: StarrySkyPainter(animation.value * 2),
          child: Container(),
        );
      },
    );
  }
}

// Pintor personalizado para las estrellas
class StarrySkyPainter extends CustomPainter {
  final double animationValue;

  StarrySkyPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    const int starCount = 1000; // Aumentado el número de estrellas
    const double maxStarSize = 1.5;

    for (int i = 0; i < starCount; i++) {
      final double starSize = maxStarSize * (i % 2 == 0 ? animationValue : 1 - animationValue);
      final Offset starOffset = Offset(
        size.width * (i % 25 / 25),
        size.height * (i % 20 / 20 + animationValue / 20),
      );
      canvas.drawCircle(starOffset, starSize, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// Botón de neón con efecto de brillo y tamaño ajustado
class NeonButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const NeonButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 0, 94, 255),
              Color.fromARGB(255, 2, 213, 213),
              Color.fromARGB(255, 217, 0, 255),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.7),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 10,
                color: Colors.cyanAccent,
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
