import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:inkpals_app/components/canvas_painter.dart';
import 'package:inkpals_app/models/line_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CanvasScreen extends StatefulWidget {
  const CanvasScreen({super.key, this.drawingName, this.drawingId});
  static String id = 'canvas_screen_id';
  final String? drawingName;
  final String? drawingId;
  @override
  State<CanvasScreen> createState() => CanvasScreenState();
}

class CanvasScreenState extends State<CanvasScreen> {
  final List<Line> _lines = [];
  List<Line> get lines => _lines;
  Color _selectedColor = Colors.black;
  double _strokeWidth = 4.0;

  final _channel = WebSocketChannel.connect(
    Uri.parse('wss://websocket-server-node-baeb166e25da.herokuapp.com/'),
  );

  @override
  void initState() {
    super.initState();
    _channel.stream.listen((message) {
      if (message is String) {
        final data = jsonDecode(message);
        final line = Line.fromJson(data);
        setState(() {
          _lines.add(line);
        });
      } else if (message is Uint8List) {
        final decodedMessage = utf8.decode(message);
        final data = jsonDecode(decodedMessage);
        final line = Line.fromJson(data);
        setState(() {
          _lines.add(line);
        });
      } else {
        print('Received unsupported message type: ${message.runtimeType}');
      }
    }, onError: (error) {
      print('Ошибка WebSocket: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.drawingName != null ? widget.drawingName! : 'Empty'),
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
