import 'dart:io';

void main() async {
  final server = await HttpServer.bind('127.0.0.1', 8000);
  print('WebSocket-сервер запущен на ws://127.0.0.1:8000');
  await for (HttpRequest request in server) {
    if (WebSocketTransformer.isUpgradeRequest(request)) {
      WebSocketTransformer.upgrade(request).then(handleWebSocket);
    } else {
      request.response
        ..statusCode = HttpStatus.forbidden
        ..close();
    }
  }
}

final clients = <WebSocket>{};
void handleWebSocket(WebSocket websocket) {
  clients.add(websocket);
  print('Клиент подключен');
  websocket.listen((data) {
    print('Получено сообщение: $data');
    for (var client in clients) {
      if (client != websocket) {
        client.add(data);
      }
    }
  }, onDone: () {
    print('Клиент отключился');
    clients.remove(websocket);
  }, onError: (error) {
    print('Ошибка: $error');
    clients.remove(websocket);
  });
}
