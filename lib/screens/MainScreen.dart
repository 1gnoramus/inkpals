import 'package:flutter/material.dart';
import 'package:inkpals_app/constants.dart';
import 'package:inkpals_app/models/drawing_model.dart';
import 'package:inkpals_app/screens/CanvasScreen.dart';
import 'package:inkpals_app/services/shared_prefs.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static String id = 'main_screen_id';
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  SharedPreferencesRepository prefs = SharedPreferencesRepository();
  final TextEditingController _controller = TextEditingController();

  List<DrawingModel> _drawings = [];
  @override
  void initState() {
    _loadDrawings();
    super.initState();
  }

  Future<void> _loadDrawings() async {
    List<DrawingModel> loadedDrawings = await prefs.getDrawingsOffline();
    setState(() {
      _drawings = loadedDrawings;
    });
  }

  void _showAddDrawingDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Name your Drawing'),
              content: TextField(
                controller: _controller,
                decoration: InputDecoration(hintText: 'Insert new name'),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel')),
                ElevatedButton(
                    onPressed: () {
                      final name = _controller.text.trim();
                      if (name.isNotEmpty) {
                        final newDrawing = DrawingModel(
                          name: name,
                          id: DateTime.now().microsecondsSinceEpoch.toString(),
                        );

                        setState(() {
                          _drawings.add(newDrawing);
                        });

                        prefs.saveDrawingOffline(newDrawing);

                        Navigator.pop(context);
                      }
                    },
                    child: Text("Добавить"))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Drawings'),
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
                    ),
                  ),
                );
              },
              child: Container(
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
            );
          },
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {_showAddDrawingDialog()},
        child: Icon(Icons.add),
        tooltip: 'Добавить новый рисунок',
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
