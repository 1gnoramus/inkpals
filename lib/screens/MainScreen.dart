import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static String id = 'main_screen_id';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class Line {
  Line({required this.color, required this.points, required this.strokeWidth});
  final Color color;
  final List<Offset?> points;
  final double strokeWidth;
}

class _MainScreenState extends State<MainScreen> {
  List<Offset?> _points = [];
  List<Line> _lines = [];
  Color _selectedColor = Colors.black;
  double _strokeWidth = 4.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Canvas"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _lines.clear();
              });
            },
            icon: Icon(Icons.refresh),
          )
        ],
      ),
      body: Stack(
        children: [
          GestureDetector(
            onPanStart: (details) {
              setState(() {
                _lines.add(Line(
                  points: [details.localPosition],
                  color: _selectedColor,
                  strokeWidth: _strokeWidth,
                ));
              });
            },
            onPanUpdate: (details) {
              setState(() {
                _lines.last.points.add(details.localPosition);
              });
            },
            onPanEnd: (details) {
              _lines.last.points.add(null);
            },
            child: CustomPaint(
              size: Size.infinite,
              painter: CanvasPainter(lines: _lines),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Row(
              children: [
                _buildColorPicker(Colors.red),
                _buildColorPicker(Colors.green),
                _buildColorPicker(Colors.blue),
                _buildColorPicker(Colors.yellow),
                _buildColorPicker(Colors.black),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Slider(
              value: _strokeWidth,
              min: 1.0,
              max: 10.0,
              onChanged: (value) {
                setState(() {
                  _strokeWidth = value;
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildColorPicker(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = color;
        });
      },
      child: Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey, width: 1.0),
        ),
      ),
    );
  }
}

class CanvasPainter extends CustomPainter {
  CanvasPainter({required this.lines});
  final List<Line> lines;

  @override
  void paint(Canvas canvas, Size size) {
    for (final line in lines) {
      final paint = Paint()
        ..color = line.color
        ..strokeWidth = line.strokeWidth
        ..strokeCap = StrokeCap.round;
      for (int i = 0; i < line.points.length - 1; i++) {
        if (line.points[i] != null && line.points[i + 1] != null) {
          canvas.drawLine(line.points[i]!, line.points[i + 1]!, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
