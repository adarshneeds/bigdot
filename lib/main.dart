import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

class HalfWheelCarousel extends StatefulWidget {
  const HalfWheelCarousel({super.key});

  @override
  State<HalfWheelCarousel> createState() => _HalfWheelCarouselState();
}

class _HalfWheelCarouselState extends State<HalfWheelCarousel> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  int _currentIndex = 0;
  final int _visibleItemCount = 5;
  double rotation = 0;

  final List<CarouselItem> items = [
    const CarouselItem(
      label: "3D Printing",
      iconUrl: "https://future100.ae/storage/post/827a7b316527cee7f14b6c875325a1f9.svg",
    ),
    const CarouselItem(
      label: "AI-based Service Optimization",
      iconUrl: "https://future100.ae/storage/post/b9b95c724101af657b0b24207909bfca.svg",
    ),
    const CarouselItem(
      label: "Blockchain",
      iconUrl: "https://future100.ae/storage/post/6b499e48b19e34914b25dbbb3dff3cb7.svg",
    ),
    const CarouselItem(label: "IoT", iconUrl: "https://future100.ae/storage/post/48c2969ce6ff7ba6fa166a4c5a60a72d.svg"),
    const CarouselItem(
      label: "On-demand\nEconomy",
      iconUrl: "https://future100.ae/storage/post/035950337c4708875c0f201475928aa7.svg",
    ),
    const CarouselItem(
      label: "Robotics",
      iconUrl: "https://future100.ae/storage/post/6b499e48b19e34914b25dbbb3dff3cb7.svg",
    ),
    const CarouselItem(
      label: "AR/VR",
      iconUrl: "https://future100.ae/storage/post/48c2969ce6ff7ba6fa166a4c5a60a72d.svg",
    ),
    const CarouselItem(
      label: "Biotechnology",
      iconUrl: "https://future100.ae/storage/post/035950337c4708875c0f201475928aa7.svg",
    ),
  ];

  final String halfRingSvg = '''
  <svg width="512" height="512" viewBox="0 0 1068.704 1068.704">
    <defs>
        <linearGradient id="a" x1="0.288" y1="0.536" x2="0.989" y2="0.281" gradientUnits="objectBoundingBox">
            <stop offset="0" stop-color="#2967b5" stop-opacity="0"></stop>
            <stop offset="1" stop-color="#1c75bc"></stop>
        </linearGradient>
    </defs>
    <path d="M534.352,267.176c-147.321,0-267.176,119.855-267.176,267.176S387.031,801.528,534.352,801.528,801.528,681.673,801.528,534.352,681.673,267.176,534.352,267.176M534.352,0C829.467,0,1068.7,239.237,1068.7,534.352S829.467,1068.7,534.352,1068.7,0,829.467,0,534.352,239.237,0,534.352,0Z" opacity="0.75" fill="url(#a)"></path>
  </svg>
  ''';

  double get step => pi / (_visibleItemCount - 1);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
  }

  void _animateTo(double target) {
    _animation =
        Tween<double>(
          begin: rotation,
          end: target,
        ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut))..addListener(() {
          setState(() {
            rotation = _animation.value;
          });
        });
    _controller.forward(from: 0);
  }

  void _onNavigate(int dir) {
    if (dir == 1 && _currentIndex >= items.length - _visibleItemCount) return;
    if (dir == -1 && _currentIndex <= 0) return;

    setState(() {
      _currentIndex += dir;
    });
    final targetRotation = -_currentIndex * step;
    _animateTo(targetRotation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double carouselWidth = constraints.maxWidth - 20;
        final double carouselHeight = constraints.maxHeight;

        // Use the smaller dimension to make the UI adapt better to landscape
        final double baseDimension = min(carouselWidth, carouselHeight);

        final double radius = baseDimension * 0.38;
        final double itemSize = baseDimension * 0.35;
        final double centerX = carouselWidth / 2;
        final double centerY = carouselHeight / 2;

        final bool isLeftDisabled = _currentIndex <= 0;
        final bool isRightDisabled = _currentIndex >= items.length - _visibleItemCount;

        return Stack(
          alignment: Alignment.centerLeft,
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: SvgPicture.string(halfRingSvg, width: baseDimension, height: baseDimension),
              ),
            ),
            ...List.generate(items.length, (i) {
              final baseAngle = -pi / 2 + i * step;
              final itemAngle = baseAngle + rotation;
              final x = radius * cos(itemAngle);
              final y = radius * sin(itemAngle);
              final isVisible = itemAngle > (-pi / 2 - 0.1) && itemAngle < (pi / 2 + 0.1);
              final opacity = isVisible ? 1.0 : 0.0;
              final scale = isVisible ? 1.0 : 0.8;

              return Positioned(
                left: centerX + x - (itemSize / 2),
                top: centerY + y - (itemSize / 2),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: opacity,
                  child: Transform.scale(
                    scale: scale,
                    child: SizedBox(
                      width: itemSize,
                      height: itemSize,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.network(
                            items[i].iconUrl,
                            width: itemSize * 0.3,
                            height: itemSize * 0.3,
                            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                          ),
                          SizedBox(height: itemSize * 0.05),
                          Text(
                            items[i].label,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: baseDimension * 0.035, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
            Positioned(
              left: carouselWidth * 0.05,
              child: const Text(
                "FUTURE\nTECHNOLOGIES",
                style: TextStyle(
                  fontSize: 18, // Keeping this fixed for style, but could be dynamic
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              top: carouselHeight * 0.1,
              left: 0,
              child: IconButton(
                icon: Icon(
                  Icons.chevron_left_rounded,
                  color: isLeftDisabled ? Colors.white.withOpacity(0.3) : Colors.white,
                  size: baseDimension * 0.12,
                ),
                onPressed: isLeftDisabled ? null : () => _onNavigate(-1),
              ),
            ),
            Positioned(
              bottom: carouselHeight * 0.1,
              left: 0,
              child: IconButton(
                icon: Icon(
                  Icons.chevron_right_rounded,
                  color: isRightDisabled ? Colors.white.withOpacity(0.3) : Colors.white,
                  size: baseDimension * 0.12,
                ),
                onPressed: isRightDisabled ? null : () => _onNavigate(1),
              ),
            ),
          ],
        );
      },
    );
  }
}
