import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Work Adventure',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: ChangeNotifierProvider(
        create: (context) => FocusScreenModel(),
        child: const FocusScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FocusScreen extends StatelessWidget {
  const FocusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FocusScreenContent();
  }
}

class _FocusScreenContent extends StatelessWidget {
  const _FocusScreenContent();

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<FocusScreenModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus Mode'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: model.toggleAdventureLog,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[100]!, Colors.blue[50]!],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularTimer(
                timeRemaining: model.timeRemaining,
                totalTime: 1800, // 30 minutes in seconds
                size: 250,
              ),
              const SizedBox(height: 30),
              Text(
                model.currentEncounterIcon,
                style: const TextStyle(fontSize: 70),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  model.currentEncounterDescription,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed:
                    model.isTimerRunning ? model.pauseTimer : model.startTimer,
                child: Text(model.isTimerRunning ? 'Pause' : 'Start'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CircularTimer extends StatelessWidget {
  final int timeRemaining;
  final int totalTime;
  final double size;

  const CircularTimer({
    super.key,
    required this.timeRemaining,
    required this.totalTime,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: DashedCircularProgressPainter(
              progress: 1 - (timeRemaining / totalTime),
              color: Colors.blue,
              backgroundColor: Colors.grey[300]!,
              strokeWidth: 12,
            ),
          ),
          Center(
            child: Text(
              formatTime(timeRemaining),
              style: TextStyle(
                fontSize: size / 5,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

class DashedCircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  DashedCircularProgressPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final foregroundPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw background circle
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw dashed progress arc
    final rect = Rect.fromCircle(center: center, radius: radius);
    const startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress;
    const dashLength = 5.0;
    const dashSpace = 3.0;
    final dashCount = (2 * pi * radius) ~/ (dashLength + dashSpace);

    for (var i = 0; i < dashCount; i++) {
      final dashStart = i * (dashLength + dashSpace);
      final dashEnd = dashStart + dashLength;
      final startAngleDash =
          startAngle + (dashStart / (2 * pi * radius)) * 2 * pi;
      final endAngleDash = startAngle + (dashEnd / (2 * pi * radius)) * 2 * pi;

      if (startAngleDash < startAngle + sweepAngle) {
        canvas.drawArc(
          rect,
          startAngleDash,
          endAngleDash - startAngleDash,
          false,
          foregroundPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class FocusScreenModel extends ChangeNotifier {
  int _timeRemaining = 1800; // 30 minutes in seconds
  bool _isTimerRunning = false;
  final String _currentEncounterIcon = '🌟';
  final String _currentEncounterDescription = 'Focus on your task!';

  int get timeRemaining => _timeRemaining;
  bool get isTimerRunning => _isTimerRunning;
  String get currentEncounterIcon => _currentEncounterIcon;
  String get currentEncounterDescription => _currentEncounterDescription;

  void startTimer() {
    if (!_isTimerRunning) {
      _isTimerRunning = true;
      _runTimer();
    }
  }

  void pauseTimer() {
    _isTimerRunning = false;
  }

  void _runTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isTimerRunning) {
        if (_timeRemaining > 0) {
          _timeRemaining--;
          notifyListeners();
          _runTimer();
        } else {
          _isTimerRunning = false;
        }
      }
    });
  }

  void toggleAdventureLog() {
    // Implement adventure log functionality
  }
}
