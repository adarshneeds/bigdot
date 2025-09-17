import 'package:bigdot/half_wheel_carousel.dart';
import 'package:flutter/material.dart';

class CarouselItem {
  final String label;
  final String iconUrl;

  const CarouselItem({required this.label, required this.iconUrl});
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(toolbarHeight: 0, backgroundColor: const Color(0xFF262262)),
        backgroundColor: const Color(0xFF262262),
        body: Center(child: HalfWheelCarousel()),
      ),
    );
  }
}
