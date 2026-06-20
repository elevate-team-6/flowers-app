import 'package:flutter/material.dart';

class PageThreeAnimation extends StatefulWidget {
  final bool isActive;
  const PageThreeAnimation({super.key, required this.isActive});

  @override
  State<PageThreeAnimation> createState() => _PageThreeAnimationState();
}

class _PageThreeAnimationState extends State<PageThreeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _carSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _carSlide = Tween<Offset>(
      begin: const Offset(-1.5, 0),
      end: const Offset(1.5, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (!widget.isActive) {
      _controller.stop();
    }
  }

  @override
  void didUpdateWidget(covariant PageThreeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.repeat();
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 300,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Road
            Positioned(
              top: 180,
              left: 0,
              right: 0,
              child: CustomPaint(
                size: const Size(double.infinity, 2),
                painter: RoadPainter(),
              ),
            ),
            // House
            const Positioned(
              right: 40,
              top: 120,
              child: Text("🏠", style: TextStyle(fontSize: 56)),
            ),
            // Car and Petals
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Stack(
                  children: [
                    // Petals
                    ...List.generate(5, (index) {
                      final delay = index * 0.05;
                      final petalOpacity = (1.0 - (index / 5)).clamp(0.0, 1.0);
                      return SlideTransition(
                        position:
                            Tween<Offset>(
                              begin: Offset(-1.5 - (index * 0.1), 0),
                              end: Offset(1.5 - (index * 0.1), 0),
                            ).animate(
                              CurvedAnimation(
                                parent: _controller,
                                curve: Curves.easeInOut,
                              ),
                            ),
                        child: Transform.translate(
                          offset: Offset(0, 180 + (index % 2 == 0 ? 5 : -5)),
                          child: Opacity(
                            opacity: petalOpacity * (1.0 - _controller.value),
                            child: const Text(
                              "🌸",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      );
                    }),
                    // Car
                    SlideTransition(
                      position: _carSlide,
                      child: Transform(
                        transform: Matrix4.identity()..translate(0.0, 160.0),
                        child: const Text("🚚", style: TextStyle(fontSize: 52)),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 10;
    const dashSpace = 10;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
