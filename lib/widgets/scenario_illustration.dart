import 'dart:math' as math;
import 'package:flutter/material.dart';

enum ScenarioType {
  minibus,
  market,
  shop,
  elder,
  family,
  football,
  clinic,
  mobileMoney,
  work,
  school,
  story,
}

class ScenarioIllustration extends StatelessWidget {
  final ScenarioType type;
  final double size;
  final BoxFit fit;

  const ScenarioIllustration({
    super.key,
    required this.type,
    this.size = 200,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ScenarioPainter(type: type),
        size: Size(size, size),
      ),
    );
  }
}

class _ScenarioPainter extends CustomPainter {
  final ScenarioType type;
  final math.Random _random = math.Random(42);

  _ScenarioPainter({required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final bgPaint = Paint()..color = _getBackgroundColor();
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bgPaint);

    switch (type) {
      case ScenarioType.minibus:
        _drawMinibus(canvas, w, h);
        break;
      case ScenarioType.market:
        _drawMarket(canvas, w, h);
        break;
      case ScenarioType.shop:
        _drawShop(canvas, w, h);
        break;
      case ScenarioType.elder:
        _drawElder(canvas, w, h);
        break;
      case ScenarioType.family:
        _drawFamily(canvas, w, h);
        break;
      case ScenarioType.football:
        _drawFootball(canvas, w, h);
        break;
      case ScenarioType.clinic:
        _drawClinic(canvas, w, h);
        break;
      case ScenarioType.mobileMoney:
        _drawMobileMoney(canvas, w, h);
        break;
      case ScenarioType.work:
        _drawWork(canvas, w, h);
        break;
      case ScenarioType.school:
        _drawSchool(canvas, w, h);
        break;
      case ScenarioType.story:
        _drawStory(canvas, w, h);
        break;
    }
  }

  Color _getBackgroundColor() {
    switch (type) {
      case ScenarioType.minibus:
        return const Color(0xFFFFF3E0);
      case ScenarioType.market:
        return const Color(0xFFE8F5E9);
      case ScenarioType.shop:
        return const Color(0xFFE3F2FD);
      case ScenarioType.elder:
        return const Color(0xFFF3E5F5);
      case ScenarioType.family:
        return const Color(0xFFFFEBEE);
      case ScenarioType.football:
        return const Color(0xFFE0F2F1);
      case ScenarioType.clinic:
        return const Color(0xFFE1F5FE);
      case ScenarioType.mobileMoney:
        return const Color(0xFFE0F7FA);
      case ScenarioType.work:
        return const Color(0xFFECEFF1);
      case ScenarioType.school:
        return const Color(0xFFFFF8E1);
      case ScenarioType.story:
        return const Color(0xFFFFF9C4);
    }
  }

  void _drawMinibus(Canvas canvas, double w, double h) {
    final groundPaint = Paint()..color = const Color(0xFF8D6E63);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.75, w, h * 0.25), groundPaint);

    final busPaint = Paint()..color = const Color(0xFFFF6B00);
    final busRect = Rect.fromLTWH(w * 0.15, h * 0.35, w * 0.7, h * 0.35);
    canvas.drawRRect(RRect.fromRectAndRadius(busRect, Radius.circular(w * 0.05)), busPaint);

    final windowPaint = Paint()..color = const Color(0xFFB3E5FC);
    for (int i = 0; i < 3; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(w * (0.22 + i * 0.18), h * 0.4, w * 0.12, h * 0.12),
          Radius.circular(w * 0.02),
        ),
        windowPaint,
      );
    }

    final wheelPaint = Paint()..color = const Color(0xFF424242);
    canvas.drawCircle(Offset(w * 0.3, h * 0.72), w * 0.08, wheelPaint);
    canvas.drawCircle(Offset(w * 0.7, h * 0.72), w * 0.08, wheelPaint);
    canvas.drawCircle(Offset(w * 0.3, h * 0.72), w * 0.04, Paint()..color = const Color(0xFFBDBDBD));
    canvas.drawCircle(Offset(w * 0.7, h * 0.72), w * 0.04, Paint()..color = const Color(0xFFBDBDBD));

    final textPaint = TextPainter(
      text: const TextSpan(text: '🚌', style: TextStyle(fontSize: 48)),
      textDirection: TextDirection.ltr,
    );
    textPaint.layout();
    textPaint.paint(canvas, Offset(w * 0.42, h * 0.08));
  }

  void _drawMarket(Canvas canvas, double w, double h) {
    final groundPaint = Paint()..color = const Color(0xFF8D6E63);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.8, w, h * 0.2), groundPaint);

    final stallPaint = Paint()..color = const Color(0xFFFF9800);
    canvas.drawRect(Rect.fromLTWH(w * 0.1, h * 0.35, w * 0.8, h * 0.35), stallPaint);

    final roofPaint = Paint()..color = const Color(0xFFF57C00);
    final roofPath = Path();
    roofPath.moveTo(w * 0.05, h * 0.35);
    roofPath.lineTo(w * 0.5, h * 0.15);
    roofPath.lineTo(w * 0.95, h * 0.35);
    roofPath.close();
    canvas.drawPath(roofPath, roofPaint);

    final producePaint = Paint()..color = const Color(0xFF4CAF50);
    canvas.drawCircle(Offset(w * 0.25, h * 0.55), w * 0.08, producePaint);
    canvas.drawCircle(Offset(w * 0.5, h * 0.55), w * 0.08, Paint()..color = const Color(0xFFFFEB3B));
    canvas.drawCircle(Offset(w * 0.75, h * 0.55), w * 0.08, Paint()..color = const Color(0xFFF44336));

    final textPaint = TextPainter(
      text: const TextSpan(text: '🛒', style: TextStyle(fontSize: 48)),
      textDirection: TextDirection.ltr,
    );
    textPaint.layout();
    textPaint.paint(canvas, Offset(w * 0.42, h * 0.08));
  }

  void _drawShop(Canvas canvas, double w, double h) {
    final groundPaint = Paint()..color = const Color(0xFF8D6E63);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.8, w, h * 0.2), groundPaint);

    final shopPaint = Paint()..color = const Color(0xFF795548);
    canvas.drawRect(Rect.fromLTWH(w * 0.15, h * 0.25, w * 0.7, h * 0.5), shopPaint);

    final awningPaint = Paint()..color = const Color(0xFF1CB0F6);
    final awningPath = Path();
    awningPath.moveTo(w * 0.1, h * 0.25);
    awningPath.lineTo(w * 0.5, h * 0.15);
    awningPath.lineTo(w * 0.9, h * 0.25);
    awningPath.close();
    canvas.drawPath(awningPath, awningPaint);

    final doorPaint = Paint()..color = const Color(0xFF5D4037);
    canvas.drawRect(Rect.fromLTWH(w * 0.4, h * 0.45, w * 0.2, h * 0.3), doorPaint);

    final textPaint = TextPainter(
      text: const TextSpan(text: '🏪', style: TextStyle(fontSize: 48)),
      textDirection: TextDirection.ltr,
    );
    textPaint.layout();
    textPaint.paint(canvas, Offset(w * 0.42, h * 0.08));
  }

  void _drawElder(Canvas canvas, double w, double h) {
    final groundPaint = Paint()..color = const Color(0xFF8D6E63);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.8, w, h * 0.2), groundPaint);

    final personPaint = Paint()..color = const Color(0xFF9B59B6);
    canvas.drawCircle(Offset(w * 0.5, h * 0.45), w * 0.15, personPaint);
    canvas.drawRect(Rect.fromLTWH(w * 0.35, h * 0.55, w * 0.3, h * 0.25), personPaint);

    final headPaint = Paint()..color = const Color(0xFFDEB887);
    canvas.drawCircle(Offset(w * 0.5, h * 0.35), w * 0.1, headPaint);

    final textPaint = TextPainter(
      text: const TextSpan(text: '👵', style: TextStyle(fontSize: 48)),
      textDirection: TextDirection.ltr,
    );
    textPaint.layout();
    textPaint.paint(canvas, Offset(w * 0.42, h * 0.08));
  }

  void _drawFamily(Canvas canvas, double w, double h) {
    final groundPaint = Paint()..color = const Color(0xFF8D6E63);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.8, w, h * 0.2), groundPaint);

    final housePaint = Paint()..color = const Color(0xFFFF7043);
    canvas.drawRect(Rect.fromLTWH(w * 0.2, h * 0.3, w * 0.6, h * 0.45), housePaint);

    final roofPaint = Paint()..color = const Color(0xFFD84315);
    final roofPath = Path();
    roofPath.moveTo(w * 0.15, h * 0.3);
    roofPath.lineTo(w * 0.5, h * 0.12);
    roofPath.lineTo(w * 0.85, h * 0.3);
    roofPath.close();
    canvas.drawPath(roofPath, roofPaint);

    final doorPaint = Paint()..color = const Color(0xFF5D4037);
    canvas.drawRect(Rect.fromLTWH(w * 0.4, h * 0.5, w * 0.2, h * 0.25), doorPaint);

    final textPaint = TextPainter(
      text: const TextSpan(text: '🏠', style: TextStyle(fontSize: 48)),
      textDirection: TextDirection.ltr,
    );
    textPaint.layout();
    textPaint.paint(canvas, Offset(w * 0.42, h * 0.08));
  }

  void _drawFootball(Canvas canvas, double w, double h) {
    final groundPaint = Paint()..color = const Color(0xFF66BB6A);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.65, w, h * 0.35), groundPaint);

    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;
    canvas.drawLine(Offset(w * 0.5, h * 0.65), Offset(w * 0.5, h), linePaint);
    canvas.drawCircle(Offset(w * 0.5, h * 0.82), w * 0.15, linePaint);

    final ballPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(w * 0.5, h * 0.5), w * 0.12, ballPaint);
    canvas.drawCircle(Offset(w * 0.5, h * 0.5), w * 0.12, Paint()..color = const Color(0xFF424242)..style = PaintingStyle.stroke..strokeWidth = 2);

    final textPaint = TextPainter(
      text: const TextSpan(text: '⚽', style: TextStyle(fontSize: 48)),
      textDirection: TextDirection.ltr,
    );
    textPaint.layout();
    textPaint.paint(canvas, Offset(w * 0.42, h * 0.08));
  }

  void _drawClinic(Canvas canvas, double w, double h) {
    final groundPaint = Paint()..color = const Color(0xFF8D6E63);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.8, w, h * 0.2), groundPaint);

    final buildingPaint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(w * 0.15, h * 0.2, w * 0.7, h * 0.55), buildingPaint);

    final crossPaint = Paint()..color = const Color(0xFFF44336);
    canvas.drawRect(Rect.fromLTWH(w * 0.4, h * 0.3, w * 0.2, h * 0.25), crossPaint);
    canvas.drawRect(Rect.fromLTWH(w * 0.32, h * 0.38, w * 0.36, h * 0.09), crossPaint);

    final textPaint = TextPainter(
      text: const TextSpan(text: '🏥', style: TextStyle(fontSize: 48)),
      textDirection: TextDirection.ltr,
    );
    textPaint.layout();
    textPaint.paint(canvas, Offset(w * 0.42, h * 0.08));
  }

  void _drawMobileMoney(Canvas canvas, double w, double h) {
    final phonePaint = Paint()..color = const Color(0xFF1CB0F6);
    final phoneRect = Rect.fromLTWH(w * 0.3, h * 0.2, w * 0.4, h * 0.55);
    canvas.drawRRect(RRect.fromRectAndRadius(phoneRect, Radius.circular(w * 0.08)), phonePaint);

    final screenPaint = Paint()..color = const Color(0xFFE3F2FD);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.35, h * 0.28, w * 0.3, h * 0.35), Radius.circular(w * 0.03)),
      screenPaint,
    );

    final textPaint = TextPainter(
      text: const TextSpan(text: '📱', style: TextStyle(fontSize: 48)),
      textDirection: TextDirection.ltr,
    );
    textPaint.layout();
    textPaint.paint(canvas, Offset(w * 0.42, h * 0.08));
  }

  void _drawWork(Canvas canvas, double w, double h) {
    final groundPaint = Paint()..color = const Color(0xFF8D6E63);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.8, w, h * 0.2), groundPaint);

    final buildingPaint = Paint()..color = const Color(0xFF607D8B);
    canvas.drawRect(Rect.fromLTWH(w * 0.2, h * 0.2, w * 0.6, h * 0.55), buildingPaint);

    for (int i = 0; i < 3; i++) {
      final windowPaint = Paint()..color = const Color(0xFFB3E5FC);
      canvas.drawRect(Rect.fromLTWH(w * (0.28 + i * 0.2), h * 0.3, w * 0.1, h * 0.15), windowPaint);
    }

    final textPaint = TextPainter(
      text: const TextSpan(text: '💼', style: TextStyle(fontSize: 48)),
      textDirection: TextDirection.ltr,
    );
    textPaint.layout();
    textPaint.paint(canvas, Offset(w * 0.42, h * 0.08));
  }

  void _drawSchool(Canvas canvas, double w, double h) {
    final groundPaint = Paint()..color = const Color(0xFF8D6E63);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.8, w, h * 0.2), groundPaint);

    final buildingPaint = Paint()..color = const Color(0xFFFFB74D);
    canvas.drawRect(Rect.fromLTWH(w * 0.15, h * 0.3, w * 0.7, h * 0.45), buildingPaint);

    final roofPaint = Paint()..color = const Color(0xFFFF7043);
    final roofPath = Path();
    roofPath.moveTo(w * 0.1, h * 0.3);
    roofPath.lineTo(w * 0.5, h * 0.12);
    roofPath.lineTo(w * 0.9, h * 0.3);
    roofPath.close();
    canvas.drawPath(roofPath, roofPaint);

    final doorPaint = Paint()..color = const Color(0xFF5D4037);
    canvas.drawRect(Rect.fromLTWH(w * 0.4, h * 0.5, w * 0.2, h * 0.25), doorPaint);

    final textPaint = TextPainter(
      text: const TextSpan(text: '🎓', style: TextStyle(fontSize: 48)),
      textDirection: TextDirection.ltr,
    );
    textPaint.layout();
    textPaint.paint(canvas, Offset(w * 0.42, h * 0.08));
  }

  void _drawStory(Canvas canvas, double w, double h) {
    final bookPaint = Paint()..color = const Color(0xFFFFF9C4);
    canvas.drawRect(Rect.fromLTWH(w * 0.2, h * 0.2, w * 0.6, h * 0.6), bookPaint);

    final coverPaint = Paint()..color = const Color(0xFFFFF176);
    canvas.drawRect(Rect.fromLTWH(w * 0.25, h * 0.25, w * 0.5, h * 0.5), coverPaint);

    final linePaint = Paint()
      ..color = const Color(0xFFE65100)
      ..strokeWidth = 2;
    for (int i = 0; i < 4; i++) {
      canvas.drawLine(
        Offset(w * 0.35, h * (0.35 + i * 0.08)),
        Offset(w * 0.65, h * (0.35 + i * 0.08)),
        linePaint,
      );
    }

    final textPaint = TextPainter(
      text: const TextSpan(text: '📖', style: TextStyle(fontSize: 48)),
      textDirection: TextDirection.ltr,
    );
    textPaint.layout();
    textPaint.paint(canvas, Offset(w * 0.42, h * 0.08));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
