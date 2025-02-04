import 'package:flutter/material.dart';
import 'package:inkpals_app/constants.dart';
import 'package:inkpals_app/models/drawing_model.dart';
import 'package:inkpals_app/models/line_model.dart';
import 'package:inkpals_app/screens/CanvasScreen.dart';
import 'package:inkpals_app/services/firebase_repo.dart';
import 'package:inkpals_app/services/shared_prefs.dart';
import 'package:inkpals_app/services/websocket_repo.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static String id = 'main_screen_id';
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  SharedPreferencesRepository prefs = SharedPreferencesRepository();
  final TextEditingController _controller = TextEditingController();
  FirebaseRepository firebase = FirebaseRepository();
  WebSocketRepository websocket = WebSocketRepository();

  List<DrawingModel> _drawings = [];

  void _syncDrawings(List<DrawingModel> serverDrawings) {
    if (_areListsEqual(_drawings, serverDrawings)) return;

    setState(() {
      _drawings = serverDrawings;
    });

    prefs.saveDrawingsOffline(serverDrawings);
  }

  bool _areListsEqual(List<DrawingModel> list1, List<DrawingModel> list2) {
    if (list1.length != list2.length) return false;
    for (var i = 0; i < list1.length; i++) {
      if (list1[i].id != list2[i].id) return false;
    }
    return true;
  }

  Future<void> _loadDrawings() async {
    List<DrawingModel> loadedDrawings = await prefs.getDrawingsOffline();
    setState(() {
      _drawings = loadedDrawings;
    });
  }

  @override
  void initState() {
    // prefs.clearAllPreferences();
    _loadDrawings();

    websocket.fetchDrawings();
    websocket.drawingsStream.listen((serverDrawings) {
      _syncDrawings(serverDrawings);
    });
    super.initState();
  }

  Future<void> _confirmDeleteDrawing(DrawingModel drawing) async {
    final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Deleting'),
            content: Text(
                'Are you sure you want to delete ${drawing.name} drawing?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Yes'),
              ),
            ],
          );
        });
    if (confirm == true) {
      await prefs.deleteDrawingOffline(drawing);
      await firebase.deleteDrawingFirestore(drawing);
      websocket.deleteDrawing(drawing);

      setState(() {
        _drawings.removeWhere((doc) => doc.id == drawing.id);
      });
    }
  }

  void _showAddDrawingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Name your Drawing'),
        content: TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: 'Insert new name'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () {
                final name = _controller.text.trim();
                List<Line> lines = [];
                if (name.isNotEmpty) {
                  final newDrawing = DrawingModel(
                    name: name,
                    lines: lines,
                    id: DateTime.now().microsecondsSinceEpoch.toString(),
                  );

                  setState(() {
                    _drawings.add(newDrawing);
                    _controller.clear();
                  });

                  prefs.saveDrawingOffline(newDrawing);
                  firebase.saveDrawingtoFirestore(newDrawing);

                  websocket.sendNewDrawing(newDrawing);
                  websocket.fetchDrawings();

                  Navigator.pop(context);
                }
              },
              child: const Text("Добавить"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Drawings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
            child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8,
          ),
          itemCount: _drawings.length,
          itemBuilder: (context, index) {
            final drawing = _drawings[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CanvasScreen(
                      drawingName: drawing.name,
                      drawingId: drawing.id,
                      drawingLines: drawing.lines,
                    ),
                  ),
                );
              },
              child: Stack(children: [
                Container(
                  width: 250,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: yellowishColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        drawing.name,
                        style: TextStyle(
                            color: textMainColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Icon(
                        Icons.arrow_forward,
                        size: 24,
                        color: textMainColor,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: IconButton(
                    onPressed: () {
                      _confirmDeleteDrawing(drawing);
                    },
                    icon: Icon(Icons.delete, color: reddishColor),
                  ),
                )
              ]),
            );
          },
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {_showAddDrawingDialog()},
        tooltip: 'Добавить новый рисунок',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    websocket.disposeWebSocket();
    super.dispose();
  }
}
