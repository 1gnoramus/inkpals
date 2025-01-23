import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static String id = 'main_screen_id';

  @override
  State<MainScreen> createState() => MainScreenState();
}

class Line {
  Line({required this.color, required this.points, required this.strokeWidth});
  final Color color;
  final List<Offset?> points;
  final double strokeWidth;

  Map<String, dynamic> toJson() {
    return {
      'color': color.value.toRadixString(16).padLeft(8, '0'),
      'points':
          points.map((p) => p != null ? {'x': p.dx, 'y': p.dy} : null).toList(),
      'strokeWidth': strokeWidth,
    };
  }

  static Line fromJson(Map<String, dynamic> json) {
    return Line(
        color: Color(int.parse(json['color'], radix: 16)),
        points: (json['points'] as List<dynamic>)
            .map((p) => p != null ? Offset(p['x'], p['y']) : null)
            .toList(),
        strokeWidth: json['strokeWidth']);
  }
}

class MainScreenState extends State<MainScreen> {
  final List<Line> _lines = [];
  List<Line> get lines => _lines;
  Color _selectedColor = Colors.black;
  double _strokeWidth = 4.0;

  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://127.0.0.1:8000'),
  );

  @override
  void initState() {
    super.initState();
    _channel.stream.listen((message) {
      final data = jsonDecode(message);
      final line = Line.fromJson(data);
      setState(() {
        _lines.add(line);
      });
    }, onError: (error) {
      print('Ошибка WebSocket: $error');
    });
  }

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
            key: const Key('canvas_gesture_detector'),
            onPanStart: (details) {
              final newLine = Line(
                  color: _selectedColor,
                  points: [details.localPosition],
                  strokeWidth: _strokeWidth);

              setState(() {
                _lines.add(newLine);
              });
              _channel.sink.add(jsonEncode(newLine.toJson()));
            },
            onPanUpdate: (details) {
              setState(() {
                _lines.last.points.add(details.localPosition);
              });
              _channel.sink.add(jsonEncode(_lines.last.toJson()));
            },
            onPanEnd: (details) {
              _lines.last.points.add(null);
              _channel.sink.add(jsonEncode(_lines.last.toJson()));
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

  @override
  void dispose() {
    if (_channel.closeCode == null) {
      _channel.sink.close();
    }
    super.dispose();
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
