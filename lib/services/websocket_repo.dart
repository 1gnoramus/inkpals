import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:inkpals_app/models/drawing_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketRepository {
  final _channel = WebSocketChannel.connect(
    Uri.parse('wss://websocket-server-node-baeb166e25da.herokuapp.com/'),
  );

  final StreamController<List<DrawingModel>> _drawingsStreamController =
      StreamController<List<DrawingModel>>.broadcast();

  final StreamController<DrawingModel> _drawingUpdatesController =
      StreamController<DrawingModel>.broadcast();

  List<DrawingModel> _drawings = [];
  String? _subscribedDrawingId;

  WebSocketRepository() {
    _channel.stream.listen((message) {
      String decodedMessage;

      if (message is String) {
        decodedMessage = message;
      } else if (message is Uint8List) {
        decodedMessage = utf8.decode(message);
      } else {
        print('Received unsupported message type: ${message.runtimeType}');
        return;
      }

      final data = jsonDecode(decodedMessage);
      print('Received WebSocket message: $data');

      if (data['type'] == 'drawing_list') {
        _drawings = (data['drawings'] as List)
            .map((e) => DrawingModel.fromJson(e))
            .toList();
        _drawingsStreamController.add(_drawings);
      } else if (data['type'] == 'create_drawing') {
        final newDrawing = DrawingModel.fromJson(data['drawing']);
        _drawings.add(newDrawing);
        _drawingsStreamController.add(_drawings);
        print('New drawing created: ${newDrawing.name}');
      } else if (data['type'] == 'update_drawing') {
        final updatedDrawing = DrawingModel.fromJson(data['drawing']);
        if (_subscribedDrawingId == updatedDrawing.id) {
          _drawingUpdatesController.add(updatedDrawing);
        }
      } else if (data['type'] == 'delete_drawing') {
        final deletedDrawingId = data['drawing_id'];
        _drawings.removeWhere((drawing) => drawing.id == deletedDrawingId);
        _drawingsStreamController.add(_drawings);
        print('Drawing with ID $deletedDrawingId was deleted');
      }
    }, onError: (error) {
      print('Ошибка WebSocket: $error');
    });
  }

  Stream<List<DrawingModel>> get drawingsStream =>
      _drawingsStreamController.stream;
  Stream<DrawingModel> get drawingUpdatesStream =>
      _drawingUpdatesController.stream;

  void fetchDrawings() {
    _channel.sink.add(jsonEncode({'type': 'get_drawings'}));
    print('Drawings fetched');
  }

  void subscribeToDrawing(String drawingId) {
    _subscribedDrawingId = drawingId;
    _channel.sink
        .add(jsonEncode({'type': 'subscribe_drawing', 'id': drawingId}));
    print('Drawing ${drawingId} subscribed');
  }

  void sendDrawingUpdate(DrawingModel drawing) {
    _channel.sink.add(
        jsonEncode({'type': 'update_drawing', 'drawing': drawing.toJson()}));
    print('Drawing ${drawing.name} updated in WS');
  }

  void deleteDrawing(DrawingModel drawing) {
    final request =
        jsonEncode({'type': 'delete_drawing', 'drawing_id': drawing.id});
    _channel.sink.add(request);

    print("Sending delete request for drawing with ID: ${drawing.id}");
  }

  Future<void> disposeWebSocket() async {
    try {
      if (_channel.closeCode == null) {
        await _drawingsStreamController.close();
        await _drawingUpdatesController.close();
        await _channel.sink.close();
        print('WebSocket disposed');
      }
    } catch (e) {
      print('Ошибка при закрытии WebSocket: $e');
    }
  }

  void sendNewDrawing(DrawingModel drawing) {
    final request = jsonEncode({
      'type': 'create_drawing',
      'drawing': drawing.toJson(),
    });
    _channel.sink.add(request);
    print('Drawing ${drawing.name} sent to WebSocket');
  }
}
