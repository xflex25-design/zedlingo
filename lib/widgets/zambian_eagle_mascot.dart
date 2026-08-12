import 'dart:math' as math;
import 'package:flutter/material.dart';

enum MascotEmotion {
  happy,
  excited,
  thinking,
  encouraging,
  celebrating,
  sad,
  speaking,
  neutral,
}

class ZambianEagleMascot extends StatefulWidget {
  final MascotEmotion emotion;
  final double size;
  final VoidCallback? onTap;

  const ZambianEagleMascot({
    super.key,
    this.emotion = MascotEmotion.happy,
    this.size = 120,
    this.onTap,
  });

  @override
  State<ZambianEagleMascot> createState() => _ZambianEagleMascotState();
}

class _ZambianEagleMascotState extends State<ZambianEagleMascot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounce;
  late Animation<double> _wingFlap;
  late Animation<double> _blink;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _bounce = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5, curve: Curves.easeInOut)),
    );

    _wingFlap = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.3, curve: Curves.easeInOut)),
    );

    _blink = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.4, 0.6, curve: Curves.easeInOut)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final bounce = math.sin(_bounce.value * 2 * math.pi) * 4;
          final wingFlap = math.sin(_wingFlap.value * 2 * math.pi) * 0.15;
          final isBlinking = _blink.value > 0.5;

          return Transform.translate(
            offset: Offset(0, -bounce),
            child: CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _EaglePainter(
                emotion: widget.emotion,
                wingFlap: wingFlap,
                isBlinking: isBlinking,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _EaglePainter extends CustomPainter {
  final MascotEmotion emotion;
  final double wingFlap;
  final bool isBlinking;

  _EaglePainter({
    required this.emotion,
    required this.wingFlap,
    required this.isBlinking,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final bodyRadius = size.width * 0.28;

    // Body
    final bodyPaint = Paint()..color = const Color(0xFF8B4513);
    canvas.drawCircle(center, bodyRadius, bodyPaint);

    // Belly
    final bellyPaint = Paint()..color = const Color(0xFFDEB887);
    canvas.drawCircle(center, bodyRadius * 0.75, bellyPaint);

    // Head
    final headCenter = Offset(center.dx, center.dy - bodyRadius * 0.9);
    final headPaint = Paint()..color = const Color(0xFF8B4513);
    canvas.drawCircle(headCenter, bodyRadius * 0.65, headPaint);

    // Face
    final facePaint = Paint()..color = const Color(0xFFDEB887);
    canvas.drawCircle(headCenter, bodyRadius * 0.5, facePaint);

    // Eyes
    final eyeOffset = bodyRadius * 0.22;
    final eyeY = headCenter.dy - bodyRadius * 0.05;
    final eyeRadius = bodyRadius * 0.12;

    if (!isBlinking) {
      final leftEye = Offset(headCenter.dx - eyeOffset, eyeY);
      final rightEye = Offset(headCenter.dx + eyeOffset, eyeY);

      canvas.drawCircle(leftEye, eyeRadius, Paint()..color = Colors.white);
      canvas.drawCircle(rightEye, eyeRadius, Paint()..color = Colors.white);

      final pupilOffset = bodyRadius * 0.04;
      canvas.drawCircle(
        Offset(leftEye.dx + pupilOffset, leftEye.dy),
        eyeRadius * 0.5,
        Paint()..color = Colors.black,
      );
      canvas.drawCircle(
        Offset(rightEye.dx + pupilOffset, rightEye.dy),
        eyeRadius * 0.5,
        Paint()..color = Colors.black,
      );
    } else {
      final leftEye = Offset(headCenter.dx - eyeOffset, eyeY);
      final rightEye = Offset(headCenter.dx + eyeOffset, eyeY);
      final eyePaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawLine(
        Offset(leftEye.dx - eyeRadius, leftEye.dy),
        Offset(leftEye.dx + eyeRadius, leftEye.dy),
        eyePaint,
      );
      canvas.drawLine(
        Offset(rightEye.dx - eyeRadius, rightEye.dy),
        Offset(rightEye.dx + eyeRadius, rightEye.dy),
        eyePaint,
      );
    }

    // Beak
    final beakPaint = Paint()..color = const Color(0xFFFFA500);
    final beakPath = Path();
    final beakTop = Offset(headCenter.dx, headCenter.dy + bodyRadius * 0.15);
    final beakLeft = Offset(headCenter.dx - bodyRadius * 0.2, headCenter.dy + bodyRadius * 0.4);
    final beakRight = Offset(headCenter.dx + bodyRadius * 0.2, headCenter.dy + bodyRadius * 0.4);
    beakPath.moveTo(beakTop.dx, beakTop.dy);
    beakPath.lineTo(beakLeft.dx, beakLeft.dy);
    beakPath.lineTo(beakRight.dx, beakRight.dy);
    beakPath.close();
    canvas.drawPath(beakPath, beakPaint);

    // Wings
    final wingPaint = Paint()..color = const Color(0xFF8B4513);
    final wingTipPaint = Paint()..color = const Color(0xFFA0522D);

    final leftWingCenter = Offset(center.dx - bodyRadius * 1.1, center.dy);
    final rightWingCenter = Offset(center.dx + bodyRadius * 1.1, center.dy);

    canvas.save();
    canvas.translate(leftWingCenter.dx, leftWingCenter.dy);
    canvas.rotate(-0.3 + wingFlap);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: bodyRadius * 1.4, height: bodyRadius * 0.6),
      wingPaint,
    );
    canvas.restore();

    canvas.save();
    canvas.translate(rightWingCenter.dx, rightWingCenter.dy);
    canvas.rotate(0.3 - wingFlap);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: bodyRadius * 1.4, height: bodyRadius * 0.6),
      wingPaint,
    );
    canvas.restore();

    // Tail
    final tailPaint = Paint()..color = const Color(0xFF8B4513);
    final tailPath = Path();
    final tailTop = Offset(center.dx, center.dy + bodyRadius * 1.1);
    final tailLeft = Offset(center.dx - bodyRadius * 0.5, center.dy + bodyRadius * 1.6);
    final tailRight = Offset(center.dx + bodyRadius * 0.5, center.dy + bodyRadius * 1.6);
    tailPath.moveTo(tailTop.dx, tailTop.dy);
    tailPath.lineTo(tailLeft.dx, tailLeft.dy);
    tailPath.lineTo(tailRight.dx, tailRight.dy);
    tailPath.close();
    canvas.drawPath(tailPath, tailPaint);

    // Emotion-specific features
    _drawEmotionFeatures(canvas, center, bodyRadius);
  }

  void _drawEmotionFeatures(Canvas canvas, Offset center, double radius) {
    switch (emotion) {
      case MascotEmotion.happy:
        _drawHappyFace(canvas, center, radius);
        break;
      case MascotEmotion.excited:
        _drawExcitedFace(canvas, center, radius);
        break;
      case MascotEmotion.thinking:
        _drawThinkingFace(canvas, center, radius);
        break;
      case MascotEmotion.encouraging:
        _drawEncouragingFace(canvas, center, radius);
        break;
      case MascotEmotion.celebrating:
        _drawCelebratingFace(canvas, center, radius);
        break;
      case MascotEmotion.sad:
        _drawSadFace(canvas, center, radius);
        break;
      case MascotEmotion.speaking:
        _drawSpeakingFace(canvas, center, radius);
        break;
      case MascotEmotion.neutral:
        _drawNeutralFace(canvas, center, radius);
        break;
    }
  }

  void _drawHappyFace(Canvas canvas, Offset center, double radius) {
    final mouthPaint = Paint()
      ..color = const Color(0xFF8B4513)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final mouthPath = Path();
    final mouthY = center.dy + radius * 0.3;
    mouthPath.moveTo(center.dx - radius * 0.25, mouthY);
    mouthPath.quadraticBezierTo(center.dx, mouthY + radius * 0.2, center.dx + radius * 0.25, mouthY);
    canvas.drawPath(mouthPath, mouthPaint);

    // Blush
    final blushPaint = Paint()..color = const Color(0xFFFF69B4).withAlpha(80);
    canvas.drawCircle(Offset(center.dx - radius * 0.45, center.dy + radius * 0.1), radius * 0.12, blushPaint);
    canvas.drawCircle(Offset(center.dx + radius * 0.45, center.dy + radius * 0.1), radius * 0.12, blushPaint);
  }

  void _drawExcitedFace(Canvas canvas, Offset center, double radius) {
    final mouthPaint = Paint()
      ..color = const Color(0xFF8B4513)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final mouthY = center.dy + radius * 0.35;
    canvas.drawCircle(Offset(center.dx, mouthY), radius * 0.2, mouthPaint);

    // Stars
    final starPaint = Paint()..color = const Color(0xFFFFD700);
    _drawStar(canvas, Offset(center.dx - radius * 0.7, center.dy - radius * 0.5), radius * 0.08, starPaint);
    _drawStar(canvas, Offset(center.dx + radius * 0.7, center.dy - radius * 0.4), radius * 0.06, starPaint);
    _drawStar(canvas, Offset(center.dx - radius * 0.6, center.dy + radius * 0.7), radius * 0.05, starPaint);
  }

  void _drawThinkingFace(Canvas canvas, Offset center, double radius) {
    final mouthPaint = Paint()
      ..color = const Color(0xFF8B4513)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final mouthY = center.dy + radius * 0.25;
    canvas.drawLine(
      Offset(center.dx - radius * 0.2, mouthY),
      Offset(center.dx + radius * 0.2, mouthY),
      mouthPaint,
    );

    // Thought bubble
    final bubblePaint = Paint()..color = Colors.white;
    final bubbleStroke = Paint()
      ..color = const Color(0xFF8B4513)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final bubbleCenter = Offset(center.dx + radius * 0.8, center.dy - radius * 0.8);
    canvas.drawCircle(bubbleCenter, radius * 0.25, bubblePaint);
    canvas.drawCircle(bubbleCenter, radius * 0.25, bubbleStroke);
    canvas.drawCircle(Offset(center.dx + radius * 0.55, center.dy - radius * 0.55), radius * 0.08, bubblePaint);
    canvas.drawCircle(Offset(center.dx + radius * 0.55, center.dy - radius * 0.55), radius * 0.08, bubbleStroke);

    // Question mark
    final textPainter = TextPainter(
      text: const TextSpan(text: '?', style: TextStyle(fontSize: 20, color: Color(0xFF8B4513))),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(bubbleCenter.dx - 6, bubbleCenter.dy - 10));
  }

  void _drawEncouragingFace(Canvas canvas, Offset center, double radius) {
    final mouthPaint = Paint()
      ..color = const Color(0xFF8B4513)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final mouthY = center.dy + radius * 0.3;
    final mouthPath = Path();
    mouthPath.moveTo(center.dx - radius * 0.2, mouthY);
    mouthPath.quadraticBezierTo(center.dx, mouthY + radius * 0.15, center.dx + radius * 0.2, mouthY);
    canvas.drawPath(mouthPath, mouthPaint);

    // Thumbs up
    final thumbPaint = Paint()..color = const Color(0xFFDEB887);
    canvas.drawCircle(Offset(center.dx + radius * 0.7, center.dy + radius * 0.3), radius * 0.15, thumbPaint);
  }

  void _drawCelebratingFace(Canvas canvas, Offset center, double radius) {
    final mouthPaint = Paint()
      ..color = const Color(0xFF8B4513)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final mouthY = center.dy + radius * 0.35;
    canvas.drawCircle(Offset(center.dx, mouthY), radius * 0.18, mouthPaint);

    // Confetti
    final colors = [const Color(0xFFFFD700), const Color(0xFFFF6B6B), const Color(0xFF4ECDC4), const Color(0xFF45B7D1)];
    final random = math.Random(42);
    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * 2 * math.pi;
      final distance = radius * 0.9;
      final x = center.dx + math.cos(angle) * distance;
      final y = center.dy + math.sin(angle) * distance;
      canvas.drawRect(
        Rect.fromCenter(center: Offset(x, y), width: radius * 0.08, height: radius * 0.08),
        Paint()..color = colors[i % colors.length],
      );
    }
  }

  void _drawSadFace(Canvas canvas, Offset center, double radius) {
    final mouthPaint = Paint()
      ..color = const Color(0xFF8B4513)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final mouthY = center.dy + radius * 0.4;
    final mouthPath = Path();
    mouthPath.moveTo(center.dx - radius * 0.2, mouthY);
    mouthPath.quadraticBezierTo(center.dx, mouthY - radius * 0.15, center.dx + radius * 0.2, mouthY);
    canvas.drawPath(mouthPath, mouthPaint);

    // Tear
    final tearPaint = Paint()..color = const Color(0xFF87CEEB);
    canvas.drawCircle(Offset(center.dx - radius * 0.4, center.dy + radius * 0.2), radius * 0.05, tearPaint);
  }

  void _drawSpeakingFace(Canvas canvas, Offset center, double radius) {
    final mouthPaint = Paint()
      ..color = const Color(0xFF8B4513)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final mouthY = center.dy + radius * 0.3;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx, mouthY), width: radius * 0.3, height: radius * 0.2),
      mouthPaint,
    );

    // Sound waves
    final wavePaint = Paint()
      ..color = const Color(0xFF58CC02)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (int i = 1; i <= 2; i++) {
      canvas.drawArc(
        Rect.fromCenter(center: Offset(center.dx + radius * 0.5, center.dy), width: radius * 0.3, height: radius * 0.3),
        -0.5,
        1,
        false,
        wavePaint,
      );
    }
  }

  void _drawNeutralFace(Canvas canvas, Offset center, double radius) {
    final mouthPaint = Paint()
      ..color = const Color(0xFF8B4513)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final mouthY = center.dy + radius * 0.3;
    canvas.drawLine(
      Offset(center.dx - radius * 0.2, mouthY),
      Offset(center.dx + radius * 0.2, mouthY),
      mouthPaint,
    );
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    final points = <Offset>[];
    for (int i = 0; i < 5; i++) {
      final angle = (i * 4 * math.pi) / 5 - math.pi / 2;
      points.add(Offset(center.dx + math.cos(angle) * size, center.dy + math.sin(angle) * size));
    }
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
