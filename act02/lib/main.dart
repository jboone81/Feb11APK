import 'package:flutter/material.dart';

void main() => runApp(const ValentineApp());

class ValentineApp extends StatelessWidget {
  const ValentineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ValentineHome(),
      theme: ThemeData(useMaterial3: true),
    );
  }
}

class ValentineHome extends StatefulWidget {
  const ValentineHome({super.key});

  @override
  State<ValentineHome> createState() => _ValentineHomeState();
}

class _ValentineHomeState extends State<ValentineHome> {
  final List<String> emojiOptions = ['Sweet Heart', 'Party Heart', 'Black Cupid', 'Golden Love'];
  String selectedEmoji = 'Sweet Heart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cupid\'s Canvas')),
      body: Column(
        children: [
          const SizedBox(height: 16),
          DropdownButton<String>(
            value: selectedEmoji,
            items: emojiOptions
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) =>
                setState(() => selectedEmoji = value ?? selectedEmoji),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: CustomPaint(
                size: const Size(300, 300),
                painter: HeartEmojiPainter(type: selectedEmoji),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeartEmojiPainter extends CustomPainter {
  HeartEmojiPainter({required this.type});
  final String type;


  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..style = PaintingStyle.fill;

    // Heart base
    final heartPath = Path()
      ..moveTo(center.dx, center.dy + 60)
      ..cubicTo(
        center.dx + 110,
        center.dy - 10,
        center.dx + 60,
        center.dy - 120,
        center.dx,
        center.dy - 40,
      )
      ..cubicTo(
        center.dx - 60,
        center.dy - 120,
        center.dx - 110,
        center.dy - 10,
        center.dx,
        center.dy + 60,
      )
      ..close();
    
    // GOLD GRADIENT SUPPORT
      if (type == 'Golden Love') {
        final rect = Rect.fromCenter(
          center: center,
          width: 220,
          height: 220,
        );

        final goldPaint = Paint()
          ..shader = const LinearGradient(
            colors: [
              Color(0xFFFFF8E1), // highlight
              Color(0xFFFFD700), // gold
              Color(0xFFFFA000), // deep gold
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(rect);

        canvas.drawPath(heartPath, goldPaint);

        // ✨ Shine highlight
        final shinePaint = Paint()
          ..color = Colors.white.withOpacity(0.25);

        canvas.drawCircle(
          Offset(center.dx - 40, center.dy - 60),
          25,
          shinePaint,
        );
      } else {
        paint.color = switch (type) {
          'Sweet Heart' => const Color(0xFFE91E63),
          'Party Heart' => const Color(0xFFF48FB1),
          'Black Cupid' => const Color(0xFF000000),
          _ => const Color(0xFFE91E63),
        };

        canvas.drawPath(heartPath, paint);
      }

    // Party hat placeholder (expand for confetti)
    if (type == 'Party Heart') {
      final hatPaint = Paint()..color = const Color(0xFFFFD54F);
      final hatPath = Path()
        ..moveTo(center.dx, center.dy - 110)
        ..lineTo(center.dx - 40, center.dy - 40)
        ..lineTo(center.dx + 40, center.dy - 40)
        ..close();
      canvas.drawPath(hatPath, hatPaint);
    }
  
    if (type == 'Black Cupid') {
      final wingPaint = Paint()..color = Colors.grey.shade800;

      // Left wing
      final leftWing = Path()
        ..moveTo(center.dx - 60, center.dy - 20)
        ..quadraticBezierTo(center.dx - 100, center.dy - 80, center.dx - 60, center.dy - 60);
      canvas.drawPath(leftWing, wingPaint);

      // Right wing
      final rightWing = Path()
        ..moveTo(center.dx + 60, center.dy - 20)
        ..quadraticBezierTo(center.dx + 100, center.dy - 80, center.dx + 60, center.dy - 60);
      canvas.drawPath(rightWing, wingPaint);
    }
  }
  @override
  bool shouldRepaint(covariant HeartEmojiPainter oldDelegate) =>
      oldDelegate.type != type;
}
