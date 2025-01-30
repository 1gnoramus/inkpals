import 'package:flutter/material.dart';
import 'package:inkpals_app/components/canvas_painter.dart';
import 'package:inkpals_app/models/drawing_model.dart';
import 'package:inkpals_app/models/line_model.dart';
import 'package:inkpals_app/services/firebase_repo.dart';
import 'package:inkpals_app/services/shared_prefs.dart';
import 'package:inkpals_app/services/websocket_repo.dart';

class CanvasScreen extends StatefulWidget {
  const CanvasScreen(
      {super.key, this.drawingName, this.drawingId, this.drawingLines});
  static String id = 'canvas_screen_id';
  final String? drawingName;
  final String? drawingId;
  final List<Line>? drawingLines;
  @override
  State<CanvasScreen> createState() => CanvasScreenState();
}

class CanvasScreenState extends State<CanvasScreen> {
  List<Line> _lines = [];
  List<Line> get lines => _lines;
  Color _selectedColor = Colors.black;
  double _strokeWidth = 4.0;
  FirebaseRepository firebase = FirebaseRepository();
  SharedPreferencesRepository prefs = SharedPreferencesRepository();
  WebSocketRepository websocket = WebSocketRepository();

  @override
  void initState() {
    super.initState();
    _lines = widget.drawingLines ?? [];
    websocket.subscribeToDrawing(widget.drawingId!);

    websocket.drawingUpdatesStream.listen((updatedDrawing) {
      print('LOL:${updatedDrawing.id}');
      print('KEK:${widget.drawingId}');
      if (updatedDrawing.id == widget.drawingId) {
        print("Updated drawing lines: ${updatedDrawing.lines}");

        setState(() {
          _lines = updatedDrawing.lines;
        });
      }
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
                DrawingModel updatedDrawing = DrawingModel(
                  name: widget.drawingName!,
                  id: widget.drawingId!,
                  lines: _lines,
                );
                websocket.sendDrawingUpdate(updatedDrawing);

                firebase.updateDrawingFirestore(updatedDrawing);
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
              websocket.sendDrawingUpdate(DrawingModel(
                  id: widget.drawingId!,
                  name: widget.drawingName!,
                  lines: _lines));
            },
            onPanUpdate: (details) {
              setState(() {
                _lines.last.points.add(details.localPosition);
              });
              websocket.sendDrawingUpdate(DrawingModel(
                  id: widget.drawingId!,
                  name: widget.drawingName!,
                  lines: _lines));
            },
            onPanEnd: (details) {
              if (_lines.last.points.isNotEmpty) {
                _lines.last.points.add(null);
                DrawingModel updatedDrawing = DrawingModel(
                  name: widget.drawingName!,
                  id: widget.drawingId!,
                  lines: _lines,
                );
                websocket.sendDrawingUpdate(updatedDrawing);
                prefs.updateDrawingOffline(updatedDrawing);
                firebase.updateDrawingFirestore(updatedDrawing);
              }
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
          border: Border.all(
            color: _selectedColor == color ? color : Colors.white,
            width: 4.0,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    websocket.disposeWebSocket();

    super.dispose();
  }
}
