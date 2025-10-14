import 'package:flutter/material.dart';

class DottedLine extends StatelessWidget {
  final double height;
  final Color color;
  final double dotRadius;
  final double spacing;

  const DottedLine({
    Key? key,
    this.height = 1,
    this.color = Colors.grey,
    this.dotRadius = 2,
    this.spacing = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, height),
      painter: DottedLinePainter(
        color: color,
        dotRadius: dotRadius,
        spacing: spacing,
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  final Color color;
  final double dotRadius;
  final double spacing;

  DottedLinePainter({
    required this.color,
    required this.dotRadius,
    required this.spacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawCircle(
        Offset(startX + dotRadius, size.height / 2),
        dotRadius,
        paint,
      );
      startX += dotRadius * 2 + spacing;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
